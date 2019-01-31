#include "sail.h"
#include "rts.h"
#include "patmos_prelude.h"
#include "patmos_platform_impl.h"

/* This file contains the definitions of the C externs of Sail model. */

mach_bits plat_ram_base(unit u)
{ return rv_ram_base; }

mach_bits plat_ram_size(unit u)
{ return rv_ram_size; }

mach_bits plat_rom_base(unit u)
{ return rv_rom_base; }

mach_bits plat_rom_size(unit u)
{ return rv_rom_size; }

unit plat_term_write(mach_bits s)
{ char c = s & 0xff;
  plat_term_write_impl(c);
  return UNIT;
}

void plat_insns_per_tick(sail_int *rop, unit u)
{ }

unit memea(mach_bits len, sail_int n)
{
  return UNIT;
}
