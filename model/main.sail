val elf_tohost = {
  ocaml: "Elf_loader.elf_tohost",
  c: "elf_tohost"
} :  unit -> int

val elf_entry = {
  ocaml: "Elf_loader.elf_entry",
  c: "elf_entry"
} : unit -> int

val main : unit -> unit effect {rreg, wreg, rmem}

function main () = {
  /* TODO: needs to be setup to the correct value */
  PC = zero_extend(0x0000, 32);
  print_bits("PC = ", PC);
  try {
    init_platform();
    /* TODO: currently no system mode init_sys();*/
    loop()
  } catch {
    Error_not_implemented(s) => print_string("Error: Not implemented: ", s),
    Error_internal_error() => print("Error: internal error")
  }
}
