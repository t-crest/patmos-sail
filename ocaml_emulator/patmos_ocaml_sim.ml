open Elf_loader
open Sail_lib
open Patmos
module PI = Platform_impl
module P = Platform
module Elf = Elf_loader;;             

(* OCaml driver for generated Patmos model. *)

let opt_file_arguments = ref ([] : string list)

let options = Arg.align ([("-ram-size",
                           Arg.Int PI.set_dram_size,
                           " size of physical ram memory to use (in MB)");
                         ])

let usage_msg = "Patmos platform options:"

let elf_arg =
  Arg.parse options (fun s -> opt_file_arguments := !opt_file_arguments @ [s])
            usage_msg;
  ( match !opt_file_arguments with
      | f :: _ -> prerr_endline ("Sail/Patmos: running ELF file " ^ f); f
      | _ -> (prerr_endline "Please provide an ELF file."; exit 0)
  )

let run pc =
  sail_call
    (fun r ->
      try ( 
            zPC := pc;
            zloop ()
          )
      with
        | ZError_not_implemented (zs) ->
              print_string ("Error: Not implemented: ", zs)
        | ZError_internal_error (_) ->
              prerr_endline "Error: internal error"
    )

let show_times init_s init_e run_e insts =
  let init_time = init_e.Unix.tms_utime -. init_s.Unix.tms_utime in
  let exec_time = run_e.Unix.tms_utime -. init_e.Unix.tms_utime in
  Printf.eprintf "\nInitialization: %g secs\n" init_time;
  Printf.eprintf "Execution: %g secs\n" exec_time;
  Printf.eprintf "Instructions retired: %Ld\n" insts;
  Printf.eprintf "Perf: %g ips\n" ((Int64.to_float insts) /. exec_time)

let () =
  Random.self_init ();
  Elf.load_elf elf_arg;

  let init_start = Unix.times () in
  let pc = Elf.Big_int.to_int64 (Elf.elf_entry ()) in
  let init_end = Unix.times () in
  let _ = run pc in
  let run_end = Unix.times () in
  let insts = Big_int.to_int64 (uint (!Patmos.zminstret)) in
  show_times init_start init_end run_end insts
