/* Basic type and function definitions used pervasively in the model. */

let rslen = 32
type rslenbits = bits(32)

let rslen_max_unsigned = 2 ^ rslen - 1
let rslen_max_signed = 2 ^ (rslen - 1) - 1
let rslen_min_signed = 0 - 2 ^ (rslen - 1)

type half   = bits(16)
type word   = bits(32)
type double = bits(64)

/* register identifiers */

type rregbits = bits(5)	   /* general purpose registers
type sregbits = bits(4)    /* special purpose registers */

/* register file indexing */

type regno ('n : Int), 0 <= 'n < 32 = atom('n)

val cast rregbits_to_regno : bits(5) -> {'n, 0 <= 'n < 32. regno('n)}
function regbits_to_regno b = let 'r = unsigned(b) in r

/* some architecture and ABI relevant register identifiers */
let zreg : regbits = 0b00000  /* x0, zero register  */
let sp   : regbits = 0b00110  /* s6, stack pointer  */
let srb  : regbits = 0b00111  /* s7, return base    */
let sro  : regbits = 0b01000  /* s8, return offset  */

/* program counter */

register PC       : rslenbits
register nextPC   : rslenbits

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

val rR : forall 'n, 0 <= 'n < 32. regno('n) -> rslenbits effect {rreg}
function rR r = match r {
  0 => 0x0000000000000000,
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

val wR : forall 'n, 0 <= 'n < 32. (regno('n), rslenbits) -> unit effect {wreg}
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
}

overload R = {rR, wR}

/* special register file and accessors */

register Ss : vector(32, dec, rslenbits)

register s0  : rslenbits
register s1  : rslenbits
register s2  : rslenbits
register s3  : rslenbits
register s4  : rslenbits
register s5  : rslenbits
register s6  : rslenbits
register s7  : rslenbits
register s8  : rslenbits
register s9  : rslenbits
register s10 : rslenbits
register s11 : rslenbits
register s12 : rslenbits
register s13 : rslenbits
register s14 : rslenbits
register s15 : rslenbits
register s16 : rslenbits
register s17 : rslenbits
register s18 : rslenbits
register s19 : rslenbits
register s20 : rslenbits
register s21 : rslenbits
register s22 : rslenbits
register s23 : rslenbits
register s24 : rslenbits
register s25 : rslenbits
register s26 : rslenbits
register s27 : rslenbits
register s28 : rslenbits
register s29 : rslenbits
register s30 : rslenbits
register s31 : rslenbits

val rS : forall 'n, 0 <= 'n < 32. regno('n) -> rslenbits effect {rreg}
function rS r = match r {
  0 => s0,
  1 => s1,
  2 => s2,
  3 => s3,
  4 => s4,
  5 => s5,
  6 => s6,
  7 => s7,
  8 => s8,
  9 => s9,
  10 => s10,
  11 => s11,
  12 => s12,
  13 => s13,
  14 => s14,
  15 => s15,
  16 => s16,
  17 => s17,
  18 => s18,
  19 => s19,
  20 => s20,
  21 => s21,
  22 => s22,
  23 => s23,
  24 => s24,
  25 => s25,
  26 => s26,
  27 => s27,
  28 => s28,
  29 => s29,
  30 => s30,
  31 => s31
}

val wS : forall 'n, 0 <= 'n < 32. (regno('n), rslenbits) -> unit effect {wreg}
function wS (r, v) = {
  match r {
    0 => s0 = v,
    1 => s1 = v,
    2 => s2 = v,
    3 => s3 = v,
    4 => s4 = v,
    5 => s5 = v,
    6 => s6 = v,
    7 => s7 = v,
    8 => s8 = v,
    9 => s9 = v,
    10 => s10 = v,
    11 => s11 = v,
    12 => s12 = v,
    13 => s13 = v,
    14 => s14 = v,
    15 => s15 = v,
    16 => s16 = v,
    17 => s17 = v,
    18 => s18 = v,
    19 => s19 = v,
    20 => s20 = v,
    21 => s21 = v,
    22 => s22 = v,
    23 => s23 = v,
    24 => s24 = v,
    25 => s25 = v,
    26 => s26 = v,
    27 => s27 = v,
    28 => s28 = v,
    29 => s29 = v,
    30 => s30 = v,
    31 => s31 = v
  };
}

overload S = {rS, wS}

/* register names */

val cast reg_name_abi : regbits -> string

function reg_name_abi(r) = {
  match (r) {
    0b00000 => "zero",
    0b00001 => "ra",
    0b00010 => "sp",
    0b00011 => "gp",
    0b00100 => "tp",
    0b00101 => "t0",
    0b00110 => "t1",
    0b00111 => "t2",
    0b01000 => "fp",
    0b01001 => "s1",
    0b01010 => "a0",
    0b01011 => "a1",
    0b01100 => "a2",
    0b01101 => "a3",
    0b01110 => "a4",
    0b01111 => "a5",
    0b10000 => "a6",
    0b10001 => "a7",
    0b10010 => "s2",
    0b10011 => "s3",
    0b10100 => "s4",
    0b10101 => "s5",
    0b10110 => "s6",
    0b10111 => "s7",
    0b11000 => "s8",
    0b11001 => "s9",
    0b11010 => "s10",
    0b11011 => "s11",
    0b11100 => "t3",
    0b11101 => "t4",
    0b11110 => "t5",
    0b11111 => "t6"
  }
}

/* instruction fields */

type bundle = bits(1)
type func3  = bits(3)
type func4  = bits(4)
type imm12  = bits(12)
type imm32  = bits(32) /* for long immediate */
type pred   = bits(4)  /* predicates */


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

/* architectural interrupt definitions */
/* TODO */

/* trap modes */
/* TODO */

/* instruction opcode grouping */
enum alu_reg_op = {PATMOS_ADD, PATMOS_SUB, PATMOS_XOR,
 		   PATMOS_SL, PATMOS_SR, PATMOS_SRA,
		   PATMOS_OR, PATMOS_AND}

enum alu_imm_op = {PATMOS_ADD, PATMOS_SUB, PATMOS_XOR,
 		   PATMOS_SL, PATMOS_SR, PATMOS_SRA,
		   PATMOS_OR, PATMOS_AND}

/* mappings for assembly */

val sreg_name : bits(4) <-> string
mapping reg_name = {
    0b0000 <-> "s0",
    0b0001 <-> "s1",
    0b0010 <-> "sl",
    0b0011 <-> "sh",
    0b0100 <-> "s4",
    0b0101 <-> "ss",
    0b0110 <-> "st",
    0b0111 <-> "srb",
    0b1000 <-> "sro",
    0b1001 <-> "sxb",
    0b1010 <-> "sxo",
    0b1011 <-> "s11",
    0b1100 <-> "s12",
    0b1101 <-> "s13",
    0b1110 <-> "s14",
    0b1111 <-> "s15",
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
