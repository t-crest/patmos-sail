#include "patmos_platform_impl.h"
#include <unistd.h>
#include <stdio.h>

/* Settings of the platform implementation, with common defaults. */

uint64_t rv_ram_base = UINT64_C(0x80000000);
uint64_t rv_ram_size = UINT64_C(0x80000000);

uint64_t rv_rom_base = UINT64_C(0x1000);
uint64_t rv_rom_size = UINT64_C(0x100);

uint64_t rv_insns_per_tick = UINT64_C(100);

int term_fd = 1; // set during startup
void plat_term_write_impl(char c)
{
  if (write(term_fd, &c, sizeof(c)) < 0) {
    fprintf(stderr, "Unable to write to terminal!\n");
  }
}
