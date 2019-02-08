#include "sail.h"
#include "rts.h"
#include "patmos_prelude.h"
#include "patmos_platform_impl.h"

typedef uint32_t mach_32bits;

/* This file contains the definitions of the C externs of Sail model. */

mach_32bits plat_ram_base(unit u)
{ return rv_ram_base; }

mach_32bits plat_ram_size(unit u)
{ return rv_ram_size; }

mach_32bits plat_rom_base(unit u)
{ return rv_rom_base; }

mach_32bits plat_rom_size(unit u)
{ return rv_rom_size; }

