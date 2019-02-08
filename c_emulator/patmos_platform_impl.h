#pragma once

#include <stdbool.h>
#include <stdint.h>

/* Settings of the platform implementation. */

#define DEFAULT_RSTVEC     0x00001000
#define SAIL_XLEN          32

extern uint32_t rv_ram_base;
extern uint32_t rv_ram_size;

extern uint32_t rv_rom_base;
extern uint32_t rv_rom_size;

