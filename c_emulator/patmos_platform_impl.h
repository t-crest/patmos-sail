#pragma once

#include <stdbool.h>
#include <stdint.h>

/* Settings of the platform implementation. */

#define DEFAULT_RSTVEC     0x00001000
#define SAIL_XLEN          32

extern uint64_t rv_ram_base;
extern uint64_t rv_ram_size;

extern uint64_t rv_rom_base;
extern uint64_t rv_rom_size;

extern uint64_t rv_insns_per_tick;

extern int term_fd;
void plat_term_write_impl(char c);
