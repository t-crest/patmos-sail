default Order dec

$include <flow.sail>

type bits ('n : Int) = vector('n, dec, bit)
union option ('a : Type) = {None : unit, Some : 'a}

val spc : unit <-> string
val opt_spc : unit <-> string
val def_spc : unit <-> string

val hex_bits : forall 'n . (atom('n), bits('n)) <-> string

val string_startswith = "string_startswith" : (string, string) -> bool
val string_drop = "string_drop" : (string, nat) -> string
val string_take = "string_take" : (string, nat) -> string
val string_length = "string_length" : string -> nat
val string_append = {c: "concat_str", _: "string_append"} : (string, string) -> string
val maybe_int_of_prefix = "maybe_int_of_prefix" : string -> option((int, nat))
val maybe_nat_of_prefix = "maybe_nat_of_prefix" : string -> option((nat, nat))
val maybe_int_of_string = "maybe_int_of_string" : string -> option(int)

val hex_bits_12 : bits(12) <-> string
val hex_bits_12_forwards = "decimal_string_of_bits" : bits(12) -> string
val hex_bits_12_forwards_matches : bits(12) -> bool
function hex_bits_12_forwards_matches bv = true
val "hex_bits_12_matches_prefix" : string -> option((bits(12), nat))
val hex_bits_12_backwards_matches : string -> bool
function hex_bits_12_backwards_matches s = match s {
  s if match hex_bits_12_matches_prefix(s) {
    Some (_, n) if n == string_length(s) => true,
    _ => false
  } => true,
  _ => false
}
val hex_bits_12_backwards : string -> bits(12)
function hex_bits_12_backwards s =
  match hex_bits_12_matches_prefix(s) {
      Some (bv, n) if n == string_length(s) => bv
  }

val eq_vec = {ocaml: "eq_list", lem: "eq_vec", coq: "eq_vec", c: "eq_bits"} : forall 'n. (bits('n), bits('n)) -> bool

val eq_string = {c: "eq_string", ocaml: "eq_string", lem: "eq", coq: "generic_eq"} : (string, string) -> bool

val eq_real = {ocaml: "eq_real", lem: "eq"} : (real, real) -> bool

val eq_anything = {ocaml: "(fun (x, y) -> x = y)", lem: "eq", coq: "generic_eq"} : forall ('a : Type). ('a, 'a) -> bool

val bitvector_length = {ocaml: "length", lem: "length", coq: "length_mword"} : forall 'n. bits('n) -> atom('n)
val vector_length = {ocaml: "length", lem: "length_list", coq: "vec_length"} : forall 'n ('a : Type). vector('n, dec, 'a) -> atom('n)
val list_length = {ocaml: "length", lem: "length_list", coq: "length_list"} : forall ('a : Type). list('a) -> int

overload length = {bitvector_length, vector_length, list_length}

val "reg_deref" : forall ('a : Type). register('a) -> 'a effect {rreg}
/* sneaky deref with no effect necessary for bitfield writes */
val _reg_deref = "reg_deref" : forall ('a : Type). register('a) -> 'a

overload operator == = {eq_vec, eq_string, eq_real, eq_anything}

val vector_subrange = {
  ocaml: "subrange",
  lem: "subrange_vec_dec",
  c: "vector_subrange",
  coq: "subrange_vec_dec"
} : forall ('n : Int) ('m : Int) ('o : Int), 0 <= 'o <= 'm < 'n.
  (bits('n), atom('m), atom('o)) -> bits('m - 'o + 1)
/*
val vector_subrange = {ocaml: "subrange", lem: "subrange_vec_dec", coq: "subrange_vec_dec"} : forall ('n : Int) ('m : Int) ('o : Int), 'o <= 'm <= 'n.
  (bits('n), atom('m), atom('o)) -> bits('m - ('o - 1))
*/

val bitvector_access = {c: "bitvector_access", ocaml: "access", lem: "access_vec_dec", coq: "access_vec_dec"} : forall ('n : Int) ('m : Int), 0 <= 'm < 'n.
  (bits('n), atom('m)) -> bit

val any_vector_access = {ocaml: "access", lem: "access_list_dec", coq: "vec_access_dec"} : forall ('n : Int) ('m : Int) ('a : Type), 0 <= 'm < 'n.
  (vector('n, dec, 'a), atom('m)) -> 'a

overload vector_access = {bitvector_access, any_vector_access}

val bitvector_update = {ocaml: "update", lem: "update_vec_dec", coq: "update_vec_dec"} : forall 'n.
  (bits('n), int, bit) -> bits('n)

val any_vector_update = {ocaml: "update", lem: "update_list_dec", coq: "vector_update"} : forall 'n ('a : Type).
  (vector('n, dec, 'a), int, 'a) -> vector('n, dec, 'a)

overload vector_update = {bitvector_update, any_vector_update}

val update_subrange = {ocaml: "update_subrange", lem: "update_subrange_vec_dec", coq: "update_subrange_vec_dec"} : forall 'n 'm 'o.
  (bits('n), atom('m), atom('o), bits('m - ('o - 1))) -> bits('n)

val vcons = {lem: "cons_vec"} : forall ('n : Int) ('a : Type).
  ('a, vector('n, dec, 'a)) -> vector('n + 1, dec, 'a)

val bitvector_concat = {c: "append", ocaml: "append", lem: "concat_vec", coq: "concat_vec"} : forall ('n : Int) ('m : Int).
  (bits('n), bits('m)) -> bits('n + 'm)

val vector_concat = {ocaml: "append", lem: "append_list"} : forall ('n : Int) ('m : Int) ('a : Type).
  (vector('n, dec, 'a), vector('m, dec, 'a)) -> vector('n + 'm, dec, 'a)

overload append = {bitvector_concat, vector_concat}

val not_bool = {coq: "negb", _: "not"} : bool -> bool

val not_vec = {c: "not_bits", _: "not_vec"} : forall 'n. bits('n) -> bits('n)

overload ~ = {not_bool, not_vec}

val neq_vec = {lem: "neq"} : forall 'n. (bits('n), bits('n)) -> bool

function neq_vec (x, y) = not_bool(eq_vec(x, y))

val neq_anything = {lem: "neq", coq: "generic_neq"} : forall ('a : Type). ('a, 'a) -> bool

function neq_anything (x, y) = not_bool(x == y)

overload operator != = {neq_vec, neq_anything}

val and_vec = {lem: "and_vec", c: "and_bits", coq: "and_vec", ocaml: "and_vec"} : forall 'n. (bits('n), bits('n)) -> bits('n)

overload operator & = {and_vec}

val or_vec = {lem: "or_vec", c: "or_bits", coq: "or_vec", ocaml: "or_vec"} : forall 'n. (bits('n), bits('n)) -> bits('n)

overload operator | = {or_vec}

val unsigned = {ocaml: "uint", lem: "uint", coq: "uint", c: "sail_unsigned"} : forall 'n. bits('n) -> range(0, 2 ^ 'n - 1)

val signed = {ocaml: "sint", lem: "sint", coq: "sint", c: "sail_signed"} : forall 'n. bits('n) -> range(- (2 ^ ('n - 1)), 2 ^ ('n - 1) - 1)

val hex_slice = "hex_slice" : forall 'n 'm, 'n >= 'm. (string, atom('n), atom('m)) -> bits('n - 'm)

val __SetSlice_bits = "set_slice" : forall 'n 'm.
  (atom('n), atom('m), bits('n), int, bits('m)) -> bits('n)

val __SetSlice_int = "set_slice_int" : forall 'w. (atom('w), int, int, bits('w)) -> int

val __raw_SetSlice_int : forall 'w. (atom('w), int, int, bits('w)) -> int

val __raw_GetSlice_int = "get_slice_int" : forall 'w, 'w >= 0. (atom('w), int, int) -> bits('w)

val __GetSlice_int : forall 'n, 'n >= 0. (atom('n), int, int) -> bits('n)

function __GetSlice_int (n, m, o) = __raw_GetSlice_int(n, m, o)

val __raw_SetSlice_bits : forall 'n 'w.
  (atom('n), atom('w), bits('n), int, bits('w)) -> bits('n)

val __raw_GetSlice_bits : forall 'n 'w, 'w >= 0.
  (atom('n), atom('w), bits('n), int) -> bits('w)

val "shiftl" : forall 'm. (bits('m), int) -> bits('m)
val "shiftr" : forall 'm. (bits('m), int) -> bits('m)

val __SignExtendSlice = {lem: "exts_slice"} : forall 'm. (bits('m), int, int) -> bits('m)

val __ZeroExtendSlice = {lem: "extz_slice"} : forall 'm. (bits('m), int, int) -> bits('m)

val cast cast_unit_vec : bit -> bits(1)

function cast_unit_vec b = match b {
  bitzero => 0b0,
  bitone  => 0b1
}

val putchar = "putchar" : forall ('a : Type). 'a -> unit

val concat_str = {c: "concat_str", ocaml: "concat_str", lem: "stringAppend", coq: "String.append"} : (string, string) -> string

val string_of_int = {c: "string_of_int", ocaml: "string_of_int", lem: "stringFromInteger", coq: "string_of_int"} : int -> string

val DecStr : int -> string

val HexStr : int -> string

val BitStr = "string_of_bits" : forall 'n. bits('n) -> string
val "decimal_string_of_bits" : forall 'n. bits('n) -> string

val xor_vec = {c: "xor_bits", _: "xor_vec"} : forall 'n. (bits('n), bits('n)) -> bits('n)

val int_power = {ocaml: "int_power", lem: "pow", coq: "pow", c: "pow_int"} : (int, int) -> int

val real_power = {ocaml: "real_power", lem: "realPowInteger"} : (real, int) -> real

overload operator ^ = {xor_vec, int_power, real_power, concat_str}

val add_int = {ocaml: "add_int", lem: "integerAdd", c: "add_int", coq: "Z.add"} : forall 'n 'm.
  (int('n), int('m)) -> int('n + 'm)

val add_vec = {c: "add_bits", _: "add_vec"} : forall 'n. (bits('n), bits('n)) -> bits('n)

val add_vec_int = {c: "add_bits_int", _: "add_vec_int"} : forall 'n. (bits('n), int) -> bits('n)

val add_real = {ocaml: "add_real", lem: "realAdd"} : (real, real) -> real

overload operator + = {add_int, add_vec, add_vec_int, add_real}

val sub_int = {ocaml: "sub_int", lem: "integerMinus", c: "sub_int", coq: "Z.sub"} : forall 'n 'm.
  (int('n), int('m)) -> int('n - 'm)

val sub_nat = {ocaml: "(fun (x,y) -> let n = sub_int (x,y) in if Big_int.less_equal n Big_int.zero then Big_int.zero else n)",
	       lem: "integerMinus", coq: "sub_nat", c: "sub_nat"}
            : (nat, nat) -> nat

val sub_vec = {c: "sub_bits", _: "sub_vec"} : forall 'n. (bits('n), bits('n)) -> bits('n)

val sub_vec_int = {c: "sub_bits_int", _: "sub_vec_int"} : forall 'n. (bits('n), int) -> bits('n)

val sub_real = {ocaml: "sub_real", lem: "realMinus"} : (real, real) -> real

val negate_int = {ocaml: "negate", lem: "integerNegate", coq: "Z.opp"} : forall 'n. int('n) -> int(- 'n)

val negate_real = {ocaml: "Num.minus_num", lem: "realNegate"} : real -> real

overload operator - = {sub_int, sub_vec, sub_vec_int, sub_real}

overload negate = {negate_int, negate_real}

val mult_atom = {ocaml: "mult", lem: "integerMult", c: "mult_int", coq: "Z.mul"} : forall 'n 'm.
  (atom('n), atom('m)) -> atom('n * 'm)

val mult_int = {ocaml: "mult", lem: "integerMult", coq: "Z.mul"} : (int, int) -> int

val mult_real = {ocaml: "mult_real", lem: "realMult"} : (real, real) -> real

overload operator * = {mult_atom, mult_int, mult_real}

val Sqrt = {ocaml: "sqrt_real", lem: "realSqrt"} : real -> real

val gteq_int = {coq: "Z.geb", _: "gteq"} : (int, int) -> bool

val gteq_real = {ocaml: "gteq_real", lem: "gteq"} : (real, real) -> bool

overload operator >= = {gteq_atom, gteq_int, gteq_real}

val lteq_int = {coq: "Z.leb", _: "lteq"} : (int, int) -> bool

val lteq_real = {ocaml: "lteq_real", lem: "lteq"} : (real, real) -> bool

overload operator <= = {lteq_atom, lteq_int, lteq_real}

val gt_int = {coq: "Z.gtb", _: "gt"} : (int, int) -> bool

val gt_real = {ocaml: "gt_real", lem: "gt"} : (real, real) -> bool

overload operator > = {gt_atom, gt_int, gt_real}

val lt_int = {coq: "Z.ltb", _: "lt"} : (int, int) -> bool

val lt_real = {ocaml: "lt_real", lem: "lt"} : (real, real) -> bool

overload operator < = {lt_atom, lt_int, lt_real}

val RoundDown = {ocaml: "round_down", lem: "realFloor"} : real -> int

val RoundUp = {ocaml: "round_up", lem: "realCeiling"} : real -> int

val abs_int = {ocaml: "abs_int", lem: "abs", coq: "Z.abs"} : int -> int

val abs_real = {ocaml: "abs_real", lem: "abs"} : real -> real

overload abs = {abs_int, abs_real}

val quotient_nat = {ocaml: "quotient", lem: "integerDiv"} : (nat, nat) -> nat

val quotient_real = {ocaml: "quotient_real", lem: "realDiv"} : (real, real) -> real

val quotient = {ocaml: "quotient", lem: "integerDiv"} : (int, int) -> int

overload operator / = {quotient_nat, quotient, quotient_real}

val quot_round_zero = {ocaml: "quot_round_zero", lem: "hardware_quot", c: "tdiv_int"} : (int, int) -> int
val rem_round_zero = {ocaml: "rem_round_zero", lem: "hardware_mod", c: "tmod_int"} : (int, int) -> int

val modulus = {ocaml: "modulus", lem: "hardware_mod", c: "tmod_int"} : (int, int) -> int

overload operator % = {modulus}

val Real = {ocaml: "Num.num_of_big_int", lem: "realFromInteger"} : int -> real

val shl_int = "shl_int" : (int, int) -> int
val shr_int = "shr_int" : (int, int) -> int
val lor_int = "lor_int" : (int, int) -> int
val land_int = "land_int" : (int, int) -> int
val lxor_int = "lxor_int" : (int, int) -> int

val min_nat = {ocaml: "min_int", lem: "min", coq: "min_nat", c: "min_int"} : (nat, nat) -> nat

val min_int = {ocaml: "min_int", lem: "min", coq: "Z.min", c: "min_int"} : (int, int) -> int

val max_nat = {ocaml: "max_int", lem: "max", coq: "max_nat", c: "max_int"} : (nat, nat) -> nat

val max_int = {ocaml: "max_int", lem: "max", coq: "Z.max", c: "max_int"} : (int, int) -> int

overload min = {min_nat, min_int}

overload max = {max_nat, max_int}

val __WriteRAM = "write_ram" : forall 'n 'm.
  (atom('m), atom('n), bits('m), bits('m), bits(8 * 'n)) -> bool effect {wmv}

val __Patmos_write : forall 'n. (bits(32), atom('n), bits(8 * 'n)) -> bool effect {wmv}
function __Patmos_write (addr, width, data) = {
  __WriteRAM(32, width, 0x0000_0000, addr, data)
}

val __TraceMemoryWrite : forall 'n 'm.
  (atom('n), bits('m), bits(8 * 'n)) -> unit

val __ReadRAM = { lem: "MEMr", _ : "read_ram" } : forall 'n 'm, 'n >= 0.
  (atom('m), atom('n), bits('m), bits('m)) -> bits(8 * 'n) effect {rmem}

val __Patmos_read : forall 'n, 'n >= 0. (bits(32), atom('n)) -> option(bits(8 * 'n)) effect {rmem}
function __Patmos_read (addr, width) = Some(__ReadRAM(32, width, 0x0000_0000, addr))

val __TraceMemoryRead : forall 'n 'm. (atom('n), bits('m), bits(8 * 'n)) -> unit

val replicate_bits = "replicate_bits" : forall 'n 'm, 'm >= 0. (bits('n), atom('m)) -> bits('n * 'm)

val cast ex_nat : nat -> {'n, 'n >= 0. atom('n)}

function ex_nat 'n = n

val cast ex_int : int -> {'n, true. atom('n)}

function ex_int 'n = n

/*
val cast ex_range : forall 'n 'm. range('n, 'm) -> {'o, 'n <= 'o <= 'm. atom('o)}

function ex_range (n as 'N) = n
*/

val coerce_int_nat : int -> nat effect {escape}

function coerce_int_nat 'x = {
  assert(constraint('x >= 0));
  x
}

val slice = "slice" : forall ('n : Int) ('m : Int), 'm >= 0 & 'n >= 0.
  (bits('m), int, atom('n)) -> bits('n)

val pow2 = "pow2" : forall 'n. atom('n) -> atom(2 ^ 'n)

val print = "print_endline" : string -> unit
val print_int = "print_int" : (string, int) -> unit
val print_bits = "print_bits" : forall 'n. (string, bits('n)) -> unit
val print_string = "print_string" : (string, string) -> unit

val print_instr    = {ocaml: "Platform.print_instr", c: "print_instr", _: "print_endline"} : string -> unit
val print_reg      = {ocaml: "Platform.print_reg",   c: "print_reg", _: "print_endline"} : string -> unit
val print_mem      = {ocaml: "Platform.print_mem_access", c: "print_mem_access", _: "print_endline"} : string -> unit
val print_platform = {ocaml: "Platform.print_platform", c: "print_platform", _: "print_endline"} : string -> unit

val "sign_extend" : forall 'n 'm, 'm >= 'n. (bits('n), atom('m)) -> bits('m)
val "zero_extend" : forall 'n 'm, 'm >= 'n. (bits('n), atom('m)) -> bits('m)

val EXTS : forall 'n 'm , 'm >= 'n . bits('n) -> bits('m)
val EXTZ : forall 'n 'm , 'm >= 'n . bits('n) -> bits('m)

function EXTS v = sign_extend(v, sizeof('m))
function EXTZ v = zero_extend(v, sizeof('m))

infix 4 <_s
infix 4 >=_s
infix 4 <_u
infix 4 >=_u
infix 4 <=_u

val operator <_s  : forall 'n, 'n > 0. (bits('n), bits('n)) -> bool
val operator >=_s : forall 'n, 'n > 0. (bits('n), bits('n)) -> bool
val operator <_u  : forall 'n. (bits('n), bits('n)) -> bool
val operator >=_u : forall 'n. (bits('n), bits('n)) -> bool
val operator <=_u : forall 'n. (bits('n), bits('n)) -> bool

function operator <_s  (x, y) = signed(x) < signed(y)
function operator >=_s (x, y) = signed(x) >= signed(y)
function operator <_u  (x, y) = unsigned(x) < unsigned(y)
function operator >=_u (x, y) = unsigned(x) >= unsigned(y)
function operator <=_u (x, y) = unsigned(x) <= unsigned(y)

val cast bool_to_bits : bool -> bits(1)
function bool_to_bits x = if x then 0b1 else 0b0

val cast bit_to_bool : bit -> bool
function bit_to_bool b = match b {
  bitone  => true,
  bitzero => false
}

infix 7 >>
infix 7 <<

val operator >> = "shift_bits_right" : forall 'n 'm. (bits('n), bits('m)) -> bits('n)
val operator << = "shift_bits_left" : forall 'n 'm. (bits('n), bits('m)) -> bits('n)

val vector64 : int -> bits(64)

function vector64 n = __raw_GetSlice_int(64, n, 0)

val to_bits : forall 'l, 'l >= 0.(atom('l), int) -> bits('l)
function to_bits (l, n) = __raw_GetSlice_int(l, n, 0)

val vector_update_subrange_dec = {ocaml: "update_subrange", c: "vector_update_subrange", lem: "update_subrange_vec_dec", coq: "update_subrange_vec_dec"} : forall 'n 'm 'o.
  (bits('n), atom('m), atom('o), bits('m - ('o - 1))) -> bits('n)

val vector_update_subrange_inc = {ocaml: "update_subrange", lem: "update_subrange_vec_inc"} : forall 'n 'm 'o.
  (vector('n, inc, bit), atom('m), atom('o), vector('o - ('m - 1), inc, bit)) -> vector('n, inc, bit)

overload vector_update_subrange = {vector_update_subrange_dec, vector_update_subrange_inc}

/* Ideally these would be sail builtin */

function shift_right_arith64 (v : bits(64), shift : bits(6)) -> bits(64) =
    let v128 : bits(128) = EXTS(v) in
    (v128 >> shift)[63..0]

function shift_right_arith32 (v : bits(32), shift : bits(5)) -> bits(32) =
    let v64 : bits(64) = EXTS(v) in
    (v64 >> shift)[31..0]

/* Special version of zero_extend that the Lem back-end knows will be at a
   case split on 'm and uses a more generic type for.  (Temporary hack, honest) */
val zero_extend_type_hack = "zero_extend" : forall 'n 'm, 'm >= 'n. (bits('n), atom('m)) -> bits('m)


val n_leading_spaces : string -> nat
function n_leading_spaces s =
  match s {
    "" => 0,
    _ => match string_take(s, 1) {
      " " => 1 + n_leading_spaces(string_drop(s, 1)),
      _ => 0
    }
  }

val spc_forwards : unit -> string
function spc_forwards () = " "
val spc_backwards : string -> unit
function spc_backwards s = ()
val spc_matches_prefix : string -> option((unit, nat))
function spc_matches_prefix s = {
  let n = n_leading_spaces(s);
  match n {
    0 => None(),
    _ => Some((), n)
  }
}

val opt_spc_forwards : unit -> string
function opt_spc_forwards () = ""
val opt_spc_backwards : string -> unit
function opt_spc_backwards s = ()
val opt_spc_matches_prefix : string -> option((unit, nat))
function opt_spc_matches_prefix s =
  Some((), n_leading_spaces(s))

val def_spc_forwards : unit -> string
function def_spc_forwards () = " "
val def_spc_backwards : string -> unit
function def_spc_backwards s = ()
val def_spc_matches_prefix : string -> option((unit, nat))
function def_spc_matches_prefix s = opt_spc_matches_prefix(s)


