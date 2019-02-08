#pragma once
#include "sail.h"

typedef uint32_t mach_32bits;

mach_32bits plat_ram_base(unit);
mach_32bits plat_ram_size(unit);
bool within_phys_mem(mach_32bits, sail_int);

mach_32bits plat_rom_base(unit);
mach_32bits plat_rom_size(unit);

