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

union MemoryOpResult ('a : Type) = {
  MemValue     : 'a,
  MemException : ExceptionType
}

/* Platform-specific handling of instruction faults */

function handle_illegal() -> unit = {
  nextPC = 0x00000000
}
