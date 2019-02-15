(* FIXME: copyright header *)

(* int->byte converters in little-endian order *)

let uint32_to_bytes u = let open Int32 in
 List.map to_int
  [ logand u 0xffl;
    logand (shift_right u 8) 0xffl;
    logand (shift_right u 16) 0xffl;
    logand (shift_right u 24) 0xffl;
  ]

let uint64_to_bytes u = let open Int64 in
 List.map to_int
  [ logand u 0xffL;
    logand (shift_right u 8) 0xffL;
    logand (shift_right u 16) 0xffL;
    logand (shift_right u 24) 0xffL;
    logand (shift_right u 32) 0xffL;
    logand (shift_right u 40) 0xffL;
    logand (shift_right u 48) 0xffL;
    logand (shift_right u 56) 0xffL;
  ]

(* address map *)

let dram_base  = 0x00020000L;;  
let dram_size_ref = ref (Int64.(shift_left 2048L 20))

type mem_region = {
    addr : Int64.t;
    size : Int64.t
}

let make_mems () = [{ addr = dram_base;
                      size = !dram_size_ref }];;

let bytes_to_string bytes =
  String.init (List.length bytes) (fun i -> Char.chr (List.nth bytes i))

let set_dram_size mb =
  dram_size_ref := Int64.(shift_left (Int64.of_int mb) 20)

(* Platform diagnostics *)

let show_bytes s =
  output_string stdout s

