#include <getopt.h>
#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/mman.h>
#include <sys/time.h>
#include <sys/socket.h>
#include <netinet/ip.h>
#include <fcntl.h>

#include "elf.h"
#include "sail.h"
#include "rts.h"
#include "patmos_platform.h"
#include "patmos_platform_impl.h"
#include "patmos_sail.h"

static bool do_show_times = false;
char *term_log = NULL;

bool config_print_instr = true;
bool config_print_reg = true;
bool config_print_mem_access = true;
bool config_print_platform = true;

struct timeval init_start, init_end, run_end;
int total_insns = 0;

static struct option options[] = {
  {"ram-size",                    required_argument, 0, 'z'},
  {"terminal-log",                required_argument, 0, 't'},
  {"show-times",                  required_argument, 0, 'p'},
  {"help",                        no_argument,       0, 'h'},
  {0, 0, 0, 0}
};

static void print_usage(const char *argv0, int ec)
{
  fprintf(stdout, "Usage: %s [options] <elf_file>\n", argv0);
  struct option *opt = options;
  while (opt->name) {
    fprintf(stdout, "\t -%c\t %s\n", (char)opt->val, opt->name);
    opt++;
  }
  exit(ec);
}

char *process_args(int argc, char **argv)
{
  int c, idx = 1;
  uint64_t ram_size = 0;
  while(true) {
    c = getopt_long(argc, argv, "pz:t:v:h:", options, &idx);
    if (c == -1) break;
    switch (c) {
    case 'p':
      do_show_times = true;
      break;
    case 'z':
      ram_size = atol(optarg);
      if (ram_size) {
        fprintf(stderr, "setting ram-size to %lu MB\n", ram_size);
        rv_ram_size = ram_size << 20;
      }
      break;
    case 't':
      term_log = strdup(optarg);
      break;
    case 'h':
      print_usage(argv[0], 0);
      break;
    default:
      fprintf(stderr, "Unrecognized optchar %c\n", c);
      print_usage(argv[0], 1);
    }
  }
  if (idx >= argc) print_usage(argv[0], 0);
  if (term_log == NULL) term_log = strdup("term.log");

  fprintf(stdout, "Running file %s.\n", argv[optind]);
  return argv[optind];
}

uint64_t load_sail(char *f)
{
  bool is32bit;
  uint64_t entry;
  load_elf(f, &is32bit, &entry);
  if (is32bit) {
    fprintf(stderr, "32-bit RISC-V not yet supported.\n");
    exit(1);
  }
  fprintf(stdout, "ELF Entry @ %lx\n", entry);
  return entry;
}

void init_sail_reset_vector(uint64_t entry)
{
#define RST_VEC_SIZE 8
  uint32_t reset_vec[RST_VEC_SIZE] = {
    0x297,                                      // auipc  t0,0x0
    0x28593 + (RST_VEC_SIZE * 4 << 20),         // addi   a1, t0, &dtb
    0xf1402573,                                 // csrr   a0, mhartid
    SAIL_XLEN == 32 ?
      0x0182a283u :                             // lw     t0,24(t0)
      0x0182b283u,                              // ld     t0,24(t0)
    0x28067,                                    // jr     t0
    0,
    (uint32_t) (entry & 0xffffffff),
    (uint32_t) (entry >> 32)
  };

  rv_rom_base = DEFAULT_RSTVEC;
  uint64_t addr = rv_rom_base;
  for (int i = 0; i < sizeof(reset_vec); i++)
    write_mem(addr++, (uint64_t)((char *)reset_vec)[i]);

  /* zero-fill to page boundary */
  const int align = 0x1000;
  uint64_t rom_end = (addr + align -1)/align * align;
  for (int i = addr; i < rom_end; i++)
    write_mem(addr++, 0);

  /* set rom size */
  rv_rom_size = rom_end - rv_rom_base;
  /* boot at reset vector */
  zPC = rv_rom_base;
}

void init_sail(uint64_t elf_entry)
{
  model_init();
  init_sail_reset_vector(elf_entry);
}

void finish(int ec)
{
  model_fini();
  if (gettimeofday(&run_end, NULL) < 0) {
    fprintf(stderr, "Cannot gettimeofday: %s\n", strerror(errno));
    exit(1);
  }
  if (do_show_times) {
    int init_msecs = (init_end.tv_sec - init_start.tv_sec)*1000 + (init_end.tv_usec - init_start.tv_usec)/1000;
    int exec_msecs = (run_end.tv_sec - init_end.tv_sec)*1000 + (run_end.tv_usec - init_end.tv_usec)/1000;
    double Kips    = ((double)total_insns)/((double)exec_msecs);
    fprintf(stderr, "Initialization:   %d msecs\n", init_msecs);
    fprintf(stderr, "Execution:        %d msecs\n", exec_msecs);
    fprintf(stderr, "Instructions:     %d\n", total_insns);
    fprintf(stderr, "Perf:             %.3f Kips\n", Kips);
  }
  exit(ec);
}

void flush_logs(void)
{
  fprintf(stderr, "\n");
  fflush(stderr);
  fprintf(stdout, "\n");
  fflush(stdout);
}


void run_sail(void)
{
  bool stepped;

  /* initialize the step number */
  mach_int step_no = 0;
  int insn_cnt = 0;

  sail_int sail_step;
  CREATE(sail_int)(&sail_step);
  CONVERT_OF(sail_int, mach_int)(&sail_step, step_no);
  stepped = zstep(sail_step);
  flush_logs();
  KILL(sail_int)(&sail_step);
  if (stepped) {
    step_no++;
    insn_cnt++;
    total_insns++;
  }
}

void init_logs()
{
}

int main(int argc, char **argv)
{
  char *file = process_args(argc, argv);
  init_logs();

  if (gettimeofday(&init_start, NULL) < 0) {
    fprintf(stderr, "Cannot gettimeofday: %s\n", strerror(errno));
    exit(1);
  }

  uint64_t entry = load_sail(file);

  init_sail(entry);

  if (gettimeofday(&init_end, NULL) < 0) {
    fprintf(stderr, "Cannot gettimeofday: %s\n", strerror(errno));
    exit(1);
  }

  do {
    run_sail();
  } while (0);
  flush_logs();
}
