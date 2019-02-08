#include "patmos_platform_impl.h"
#include <unistd.h>
#include <stdio.h>

/* Settings of the platform implementation, with common defaults. */

uint32_t rv_ram_base = UINT32_C(0x80000000);
uint32_t rv_ram_size = UINT32_C(0x80000000);

uint32_t rv_rom_base = UINT32_C(0x1000);
uint32_t rv_rom_size = UINT32_C(0x100);

uint32_t rv_insns_per_tick = UINT32_C(100);
