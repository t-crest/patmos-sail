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

type rregno ('n : Int), 0 <= 'n < 32 = atom('n)
type sregno ('n : Int), 0 <= 'n < 16 = atom('n)

val cast rregbits_to_rregno : bits(5) -> {'n, 0 <= 'n < 32. rregno('n)}
function rregbits_to_rregno b = let 'r = unsigned(b) in r

val cast sregbits_to_sregno : bits(4) -> {'n, 0 <= 'n < 16. sregno('n)}
function sregbits_to_sregno b = let 's = unsigned(b) in s

/* program counter */

register PC       : rslenbits
register nextPC   : rslenbits

/* general register file and accessors */

register Rs : vector(32, dec, rslenbits)

val rR : forall 'n, 0 <= 'n < 32. regno('n) -> rslenbits effect {rreg}
function rR 0 = 0x00000000
and rR (r if r > 0) = Rs[r]

val wR : forall 'n, 0 <= 'n < 32. (regno('n), rslenbits) -> unit effect {wreg}
function wR (r, v) =
  if (r != 0) then {
     Rs[r] = v;

}

overload R = {rR, wR}

/* special register file and accessors */

register Ss : vector(32, dec, rslenbits)

val rS : forall 'n, 0 <= 'n < 32. regno('n) -> rslenbits effect {rreg}
function rS s = Ss[s]

val wS : forall 'n, 0 <= 'n < 32. (regno('n), rslenbits) -> unit effect {wreg}
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
    0b1111 => "s15",
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
		   PATMOS_OR, PATMOS_AND, PATMOS_NOR,
		   PATMOS_SHADD, PATMOS_SHADD2}

enum alu_imm_op = {PATMOS_ADD, PATMOS_SUB, PATMOS_XOR,
 		   PATMOS_SL, PATMOS_SR, PATMOS_SRA,
		   PATMOS_OR, PATMOS_AND}

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
