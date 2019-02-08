/* Basic type and function definitions used pervasively in the model. */

let rslen = 32
type rslenbits = bits(32)

let rslen_max_unsigned = 2 ^ rslen - 1
let rslen_max_signed = 2 ^ (rslen - 1) - 1
let rslen_min_signed = 0 - 2 ^ (rslen - 1)

type half   = bits(16)
type word   = bits(32)
type double = bits(64)

/* Predicate register stuff */

type predbits = bits(4)    

/* register identifiers */

type rregbits = bits(5)	   /* general purpose registers */
type sregbits = bits(4)    /* special purpose registers */

/* register file indexing */

type rregno ('n : Int), 0 <= 'n < 32 = atom('n)
type sregno ('n : Int), 0 <= 'n < 16 = atom('n)

val cast rregbits_to_rregno : bits(5) -> {'n, 0 <= 'n < 32. rregno('n)}
function rregbits_to_rregno b = let 'r = unsigned(b) in r

val cast sregbits_to_sregno : bits(4) -> {'n, 0 <= 'n < 16. sregno('n)}
function sregbits_to_sregno b = let 's = unsigned(b) in s

/* program counter */

register PC       : rslenbits
register nextPC   : rslenbits

/* internal state to hold instruction bits for faulting instructions */
register instbits : rslenbits

/* general register file and accessors */

register Rs : vector(32, dec, rslenbits)

register r1  : rslenbits
register r2  : rslenbits
register r3  : rslenbits
register r4  : rslenbits
register r5  : rslenbits
register r6  : rslenbits
register r7  : rslenbits
register r8  : rslenbits
register r9  : rslenbits
register r10 : rslenbits
register r11 : rslenbits
register r12 : rslenbits
register r13 : rslenbits
register r14 : rslenbits
register r15 : rslenbits
register r16 : rslenbits
register r17 : rslenbits
register r18 : rslenbits
register r19 : rslenbits
register r20 : rslenbits
register r21 : rslenbits
register r22 : rslenbits
register r23 : rslenbits
register r24 : rslenbits
register r25 : rslenbits
register r26 : rslenbits
register r27 : rslenbits
register r28 : rslenbits
register r29 : rslenbits
register r30 : rslenbits
register r31 : rslenbits

val rR : forall 'n, 0 <= 'n < 32. rregno('n) -> rslenbits effect {rreg}
/* The following code does not seem to work when generating the C simulator */
/* function rR (r) = { */
/*   if (r == 0) then 0x00000000 */
/*   else Rs[r] */
/* } */
function rR r = match r {
  0 => 0x00000000,
  1 => r1,
  2 => r2,
  3 => r3,
  4 => r4,
  5 => r5,
  6 => r6,
  7 => r7,
  8 => r8,
  9 => r9,
  10 => r10,
  11 => r11,
  12 => r12,
  13 => r13,
  14 => r14,
  15 => r15,
  16 => r16,
  17 => r17,
  18 => r18,
  19 => r19,
  20 => r20,
  21 => r21,
  22 => r22,
  23 => r23,
  24 => r24,
  25 => r25,
  26 => r26,
  27 => r27,
  28 => r28,
  29 => r29,
  30 => r30,
  31 => r31
}

/* The following code does not seem to work when generating the C simulator */
/* function wR (r, v) = */
/*   if (r != 0) then { */
/*      Rs[r] = v; */
/*   } */
val wR : forall 'n, 0 <= 'n < 32. (rregno('n), rslenbits) -> unit effect {wreg}
function wR (r, v) = {
  match r {
    0 => (),
    1 => r1 = v,
    2 => r2 = v,
    3 => r3 = v,
    4 => r4 = v,
    5 => r5 = v,
    6 => r6 = v,
    7 => r7 = v,
    8 => r8 = v,
    9 => r9 = v,
    10 => r10 = v,
    11 => r11 = v,
    12 => r12 = v,
    13 => r13 = v,
    14 => r14 = v,
    15 => r15 = v,
    16 => r16 = v,
    17 => r17 = v,
    18 => r18 = v,
    19 => r19 = v,
    20 => r20 = v,
    21 => r21 = v,
    22 => r22 = v,
    23 => r23 = v,
    24 => r24 = v,
    25 => r25 = v,
    26 => r26 = v,
    27 => r27 = v,
    28 => r28 = v,
    29 => r29 = v,
    30 => r30 = v,
    31 => r31 = v
  };
  if (r != 0) then {
     print_reg("x" ^ string_of_int(r) ^ " <- " ^ BitStr(v));
  }
}

overload R = {rR, wR}

/* special register file and accessors */

register Ss : vector(16, dec, rslenbits)

val rS : forall 'n, 0 <= 'n < 16. sregno('n) -> rslenbits effect {rreg}
function rS s = Ss[s]

val wS : forall 'n, 0 <= 'n < 16. (sregno('n), rslenbits) -> unit effect {wreg}
function wS (r, v) = Ss[r] = v

overload S = {rS, wS}

/* register names */

val cast rreg_name_abi : rregbits -> string
function rreg_name_abi(r) = {
  match (r) {
    0b00000 => "r0",
    0b00001 => "r1",
    0b00010 => "r2",
    0b00011 => "r3",
    0b00100 => "r4",
    0b00101 => "r5",
    0b00110 => "r6",
    0b00111 => "r7",
    0b01000 => "r8",
    0b01001 => "r9",
    0b01010 => "r10",
    0b01011 => "r11",
    0b01100 => "r12",
    0b01101 => "r13",
    0b01110 => "r14",
    0b01111 => "r15",
    0b10000 => "r16",
    0b10001 => "r17",
    0b10010 => "r18",
    0b10011 => "r19",
    0b10100 => "r20",
    0b10101 => "r21",
    0b10110 => "r22",
    0b10111 => "r23",
    0b11000 => "r24",
    0b11001 => "r25",
    0b11010 => "r26",
    0b11011 => "r27",
    0b11100 => "r28",
    0b11101 => "r29",
    0b11110 => "r30",
    0b11111 => "r31"
  }
}

val cast sreg_name_abi : sregbits -> string
function sreg_name_abi(s) = {
  match (s) {
    0b0000 => "s0",
    0b0001 => "s1",
    0b0010 => "sl",
    0b0011 => "sh",
    0b0100 => "s4",
    0b0101 => "ss",
    0b0110 => "st",
    0b0111 => "srb",
    0b1000 => "sro",
    0b1001 => "sxb",
    0b1010 => "sxo",
    0b1011 => "s11",
    0b1100 => "s12",
    0b1101 => "s13",
    0b1110 => "s14",
    0b1111 => "s15"
  }
}

/* memory access types */

enum AccessType = {Read, Write, ReadWrite, Execute}

val cast accessType_to_str : AccessType -> string
function accessType_to_str (a) =
  match (a) {
    Read      => "R",
    Write     => "W",
    ReadWrite => "RW",
    Execute   => "X"
  }

enum ReadType   = {Instruction, Data}

val cast readType_to_str : ReadType -> string
function readType_to_str (r) =
  match (r) {
    Instruction => "I",
    Data        => "D"
  }

enum word_width = {BYTE, HALF, WORD, DOUBLE}

/* architectural exception definitions */

type exc_code = bits(4)

enum ExceptionType = {
 E_Fetch_Access_Fault,
 E_Load_Access_Fault,
 E_Load_Addr_Align,
 E_SAMO_Addr_Align,
 E_SAMO_Access_Fault
}

val cast exceptionType_to_bits : ExceptionType -> exc_code
function exceptionType_to_bits(e) =
  match (e) {
    E_Fetch_Access_Fault => 0x0,
    E_Load_Access_Fault  => 0x1,
    E_Load_Addr_Align    => 0x2,
    E_SAMO_Addr_Align    => 0x3,
    E_SAMO_Access_Fault  => 0x4
  }

val cast exceptionType_to_str : ExceptionType -> string
function exceptionType_to_str(e) =
  match (e) {
    E_Fetch_Access_Fault => "fetch-access-fault",
    E_Load_Access_Fault  => "load-access-fault",
    E_Load_Addr_Align    => "misaligned-load",
    E_SAMO_Addr_Align    => "misaliged-store/amo",
    E_SAMO_Access_Fault  => "store/amo-access-fault"
  }

/* model-internal exceptions */

union exception = {
  Error_not_implemented : string,
  Error_internal_error  : unit
}

val not_implemented : forall ('a : Type). string -> 'a effect {escape}
function not_implemented message = throw(Error_not_implemented(message))

val internal_error : forall ('a : Type). string -> 'a effect {escape}
function internal_error(s) = {
    assert (false, s);
    throw Error_internal_error()
}

/* trap modes */
/* TODO */

/* instruction opcode grouping */
enum alu_func4 = {PATMOS_ADD, PATMOS_SUB, PATMOS_XOR,
 		  PATMOS_SL, PATMOS_SR, PATMOS_SRA,
		  PATMOS_OR, PATMOS_AND, PATMOS_NOR,
		  PATMOS_SHADD, PATMOS_SHADD2}

/* mappings for assembly */

val reg_name : bits(5) <-> string
mapping reg_name = {
    0b00000 <-> "zero",
    0b00001 <-> "r1",
    0b00010 <-> "r2",
    0b00011 <-> "r3",
    0b00100 <-> "r4",
    0b00101 <-> "r5",
    0b00110 <-> "r6",
    0b00111 <-> "r7",
    0b01000 <-> "r8",
    0b01001 <-> "r9",
    0b01010 <-> "r10",
    0b01011 <-> "r11",
    0b01100 <-> "r12",
    0b01101 <-> "r13",
    0b01110 <-> "r14",
    0b01111 <-> "r15",
    0b10000 <-> "r16",
    0b10001 <-> "r17",
    0b10010 <-> "r18",
    0b10011 <-> "r19",
    0b10100 <-> "r20",
    0b10101 <-> "r21",
    0b10110 <-> "r22",
    0b10111 <-> "r23",
    0b11000 <-> "r24",
    0b11001 <-> "r25",
    0b11010 <-> "r26",
    0b11011 <-> "r27",
    0b11100 <-> "r28",
    0b11101 <-> "r29",
    0b11110 <-> "r30",
    0b11111 <-> "r31"
}


val sep : unit <-> string
mapping sep : unit <-> string = {
  ()     <-> opt_spc() ^ "," ^ def_spc()
}

mapping bool_bits : bool <-> bits(1) = {
  true   <-> 0b1,
  false  <-> 0b0
}

mapping bool_not_bits : bool <-> bits(1) = {
  true   <-> 0b0,
  false  <-> 0b1
}

mapping size_bits : word_width <-> bits(2) = {
  BYTE   <-> 0b00,
  HALF   <-> 0b01,
  WORD   <-> 0b10,
  DOUBLE <-> 0b11
}

mapping size_mnemonic : word_width <-> string = {
  BYTE   <-> "b",
  HALF   <-> "h",
  WORD   <-> "w",
  DOUBLE <-> "d"
}
