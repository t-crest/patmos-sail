open Sail_lib;;
module P = Platform_impl;;

(* logging *)

let config_print_instr       = ref true
let config_print_reg         = ref true
let config_print_mem_access  = ref true
let config_print_platform    = ref true

let print_instr s =
  if !config_print_instr
  then print_endline s
  else ()

let print_reg s =
  if !config_print_reg
  then print_endline s
  else ()

let print_mem_access s =
  if !config_print_mem_access
  then print_endline s
  else ()

let print_platform s =
  if !config_print_platform
  then print_endline s
  else ()

(* Mapping to Sail externs *)

let bits_of_int i =
  get_slice_int (Big_int.of_int 64, Big_int.of_int i, Big_int.zero)

let bits_of_int64 i =
  get_slice_int (Big_int.of_int 64, Big_int.of_int64 i, Big_int.zero)

let dram_base () = bits_of_int64 P.dram_base
let dram_size () = bits_of_int64 !P.dram_size_ref

