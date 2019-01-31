#pragma once
#include "sail.h"

mach_bits plat_ram_base(unit);
mach_bits plat_ram_size(unit);
bool within_phys_mem(mach_bits, sail_int);

mach_bits plat_rom_base(unit);
mach_bits plat_rom_size(unit);

void plat_insns_per_tick(sail_int *rop, unit);

unit plat_term_write(mach_bits);

unit memea(mach_bits, sail_int);

