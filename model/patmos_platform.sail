/* Platform-specific definitions, and basic MMIO devices. */

/* Current constraints on this implementation are:
   - it cannot access memory directly, but instead provides definitions for the physical memory model
   - it can access system register state, needed to manipulate interrupt bits
   - it relies on externs to get platform address information and doesn't hardcode them.
*/

/* Main memory */
val plat_ram_base = {c: "plat_ram_base", ocaml: "Platform.dram_base", lem: "plat_ram_base"} : unit -> rslenbits
val plat_ram_size = {c: "plat_ram_size", ocaml: "Platform.dram_size", lem: "plat_ram_size"} : unit -> rslenbits

/* ROM holding reset vector  */
val plat_rom_base   = {ocaml: "Platform.rom_base", c: "plat_rom_base", lem: "plat_rom_base"} : unit -> rslenbits
val plat_rom_size   = {ocaml: "Platform.rom_size", c: "plat_rom_size", lem: "plat_rom_size"} : unit -> rslenbits

val phys_mem_segments : unit -> list((rslenbits, rslenbits))
function phys_mem_segments() =
  (plat_rom_base (), plat_rom_size ()) ::
  (plat_ram_base (), plat_ram_size ()) ::
  [||]

/* Physical memory map predicates */

function within_phys_mem forall 'n. (addr : rslenbits, width : atom('n)) -> bool = {
  let ram_base = plat_ram_base ();
  let rom_base = plat_rom_base ();
  let ram_size = plat_ram_size ();
  let rom_size = plat_rom_size ();

  /* todo: iterate over segment list */
  if (  ram_base <=_u addr
      & (addr + sizeof('n)) <=_u (ram_base + ram_size))
       then true
  else if (  rom_base <=_u addr
           & (addr + sizeof('n)) <=_u (rom_base + rom_size))
       then true
  else {
    print_platform("within_phys_mem: " ^ BitStr(addr) ^ " not within phys-mem:");
    print_platform("  plat_rom_base: " ^ BitStr(rom_base));
    print_platform("  plat_rom_size: " ^ BitStr(rom_size));
    print_platform("  plat_ram_base: " ^ BitStr(ram_base));
    print_platform("  plat_ram_size: " ^ BitStr(ram_size));
    false
  }
}

val plat_insns_per_tick = {ocaml: "Platform.insns_per_tick", c: "plat_insns_per_tick", lem: "plat_insns_per_tick"} : unit -> int

register cycle : rslenbits

val tick_clock : unit -> unit effect {rreg, wreg}
function tick_clock() = {
  cycle = cycle + 1;
}

/* Basic terminal character I/O. */

val plat_term_write = {ocaml: "Platform.term_write", c: "plat_term_write", lem: "plat_term_write"} : bits(8) -> unit
val plat_term_read  = {ocaml: "Platform.term_read",  c: "plat_term_read", lem: "plat_term_read"}  : unit -> bits(8)

union MemoryOpResult ('a : Type) = {
  MemValue     : 'a,
  MemException : ExceptionType
}

function within_mmio_readable forall 'n. (addr : rslenbits, width : atom('n)) -> bool = false

function within_mmio_writable forall 'n. (addr : rslenbits, width : atom('n)) -> bool = false

function mmio_read forall 'n, 'n > 0. (addr : rslenbits, width : atom('n)) -> MemoryOpResult(bits(8 * 'n)) = MemValue(zero_extend_type_hack(0x0, sizeof(8 * 'n)))

function mmio_write forall 'n, 'n > 0. (addr : rslenbits, width : atom('n), data: bits(8 * 'n)) -> MemoryOpResult(bool) = MemValue(true)

/* Platform initialization and ticking. */

function init_platform() -> unit = {
  cycle = cycle + 1;
}

function tick_platform() -> unit = {
  cycle = cycle + 1;
}

/* Platform-specific handling of instruction faults */

function handle_illegal() -> unit = {
  nextPC = 0x00000000
}
