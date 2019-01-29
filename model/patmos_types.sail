/* Basic type and function definitions used pervasively in the model. */

let rslen = 32
type rslenbits = bits(32)

let rslen_max_unsigned = 2 ^ rslen - 1
let rslen_max_signed = 2 ^ (rslen - 1) - 1
let rslen_min_signed = 0 - 2 ^ (rslen - 1)

type half = bits(16)
type word = bits(32)

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

/* UP TO HERE, code is updated for Patmos */

/* instruction fields */

type opcode = bits(7)
type imm12  = bits(12)
type imm20  = bits(20)
type amo    = bits(1)  /* amo opcode flags */

/* base architecture definitions */

enum Architecture = {RV32, RV64, RV128}
type arch_rlen = bits(2)
function architecture(a : arch_rlen) -> option(Architecture) =
  match (a) {
    0b01 => Some(RV32),
    0b10 => Some(RV64),
    0b11 => Some(RV128),
    _    => None()
  }

function arch_to_bits(a : Architecture) -> arch_rlen =
  match (a) {
    RV32  => 0b01,
    RV64  => 0b10,
    RV128 => 0b11
  }

/* privilege levels */

type priv_level = bits(2)
enum Privilege  = {User, Supervisor, Machine}

val cast privLevel_to_bits : Privilege -> priv_level
function privLevel_to_bits (p) =
  match (p) {
    User       => 0b00,
    Supervisor => 0b01,
    Machine    => 0b11
  }

val cast privLevel_of_bits : priv_level -> Privilege
function privLevel_of_bits (p) =
  match (p) {
    0b00 => User,
    0b01 => Supervisor,
    0b11 => Machine
  }

val cast privLevel_to_str : Privilege -> string
function privLevel_to_str (p) =
  match (p) {
    User       => "U",
    Supervisor => "S",
    Machine    => "M"
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

/* architectural interrupt definitions */

type exc_code = bits(4)

enum InterruptType = {
  I_U_Software,
  I_S_Software,
  I_M_Software,
  I_U_Timer,
  I_S_Timer,
  I_M_Timer,
  I_U_External,
  I_S_External,
  I_M_External
}

val cast interruptType_to_bits : InterruptType -> exc_code
function interruptType_to_bits (i) =
  match (i) {
    I_U_Software => 0x0,
    I_S_Software => 0x1,
    I_M_Software => 0x3,
    I_U_Timer    => 0x4,
    I_S_Timer    => 0x5,
    I_M_Timer    => 0x7,
    I_U_External => 0x8,
    I_S_External => 0x9,
    I_M_External => 0xb
  }

/* architectural exception definitions */

enum ExceptionType = {
 E_Fetch_Addr_Align,
 E_Fetch_Access_Fault,
 E_Illegal_Instr,
 E_Breakpoint,
 E_Load_Addr_Align,
 E_Load_Access_Fault,
 E_SAMO_Addr_Align,
 E_SAMO_Access_Fault,
 E_U_EnvCall,
 E_S_EnvCall,
 E_Reserved_10,
 E_M_EnvCall,
 E_Fetch_Page_Fault,
 E_Load_Page_Fault,
 E_Reserved_14,
 E_SAMO_Page_Fault
}

val cast exceptionType_to_bits : ExceptionType -> exc_code
function exceptionType_to_bits(e) =
  match (e) {
    E_Fetch_Addr_Align   => 0x0,
    E_Fetch_Access_Fault => 0x1,
    E_Illegal_Instr      => 0x2,
    E_Breakpoint         => 0x3,
    E_Load_Addr_Align    => 0x4,
    E_Load_Access_Fault  => 0x5,
    E_SAMO_Addr_Align    => 0x6,
    E_SAMO_Access_Fault  => 0x7,
    E_U_EnvCall          => 0x8,
    E_S_EnvCall          => 0x9,
    E_Reserved_10        => 0xa,
    E_M_EnvCall          => 0xb,
    E_Fetch_Page_Fault   => 0xc,
    E_Load_Page_Fault    => 0xd,
    E_Reserved_14        => 0xe,
    E_SAMO_Page_Fault    => 0xf
  }

val cast exceptionType_to_str : ExceptionType -> string
function exceptionType_to_str(e) =
  match (e) {
    E_Fetch_Addr_Align   => "misaligned-fetch",
    E_Fetch_Access_Fault => "fetch-access-fault",
    E_Illegal_Instr      => "illegal-instruction",
    E_Breakpoint         => "breakpoint",
    E_Load_Addr_Align    => "misaligned-load",
    E_Load_Access_Fault  => "load-access-fault",
    E_SAMO_Addr_Align    => "misaliged-store/amo",
    E_SAMO_Access_Fault  => "store/amo-access-fault",
    E_U_EnvCall          => "u-call",
    E_S_EnvCall          => "s-call",
    E_Reserved_10        => "reserved-0",
    E_M_EnvCall          => "m-call",
    E_Fetch_Page_Fault   => "fetch-page-fault",
    E_Load_Page_Fault    => "load-page-fault",
    E_Reserved_14        => "reserved-1",
    E_SAMO_Page_Fault    => "store/amo-page-fault"
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

type tv_mode = bits(2)
enum TrapVectorMode = {TV_Direct, TV_Vector, TV_Reserved}

val cast trapVectorMode_of_bits : tv_mode -> TrapVectorMode
function trapVectorMode_of_bits (m) =
  match (m) {
    0b00 => TV_Direct,
    0b01 => TV_Vector,
    _    => TV_Reserved
  }

/* extension context status */

type ext_status = bits(2)
enum ExtStatus = {Off, Initial, Clean, Dirty}

val cast extStatus_to_bits : ExtStatus -> ext_status
function extStatus_to_bits(e) =
  match (e) {
    Off     => 0b00,
    Initial => 0b01,
    Clean   => 0b10,
    Dirty   => 0b11
  }

val cast extStatus_of_bits : ext_status -> ExtStatus
function extStatus_of_bits(e) =
  match (e) {
    0b00 => Off,
    0b01 => Initial,
    0b10 => Clean,
    0b11 => Dirty
  }

/* supervisor-level address translation modes */

type satp_mode = bits(4)
enum SATPMode = {Sbare, Sv32, Sv39}

function satpMode_of_bits(a : Architecture, m : satp_mode) -> option(SATPMode) =
  match (a, m) {
    (_,    0x0) => Some(Sbare),
    (RV32, 0x1) => Some(Sv32),
    (RV64, 0x8) => Some(Sv39),
    (_, _)      => None()
  }

/* CSR access control bits (from CSR addresses) */

type csrRW = bits(2)  /* read/write */

/* instruction opcode grouping */
enum uop = {RISCV_LUI, RISCV_AUIPC}               /* upper immediate ops */
enum bop = {RISCV_BEQ, RISCV_BNE, RISCV_BLT,
            RISCV_BGE, RISCV_BLTU, RISCV_BGEU}    /* branch ops */
enum iop = {RISCV_ADDI, RISCV_SLTI, RISCV_SLTIU,
            RISCV_XORI, RISCV_ORI, RISCV_ANDI}    /* immediate ops */
enum sop = {RISCV_SLLI, RISCV_SRLI, RISCV_SRAI}   /* shift ops */
enum rop = {RISCV_ADD, RISCV_SUB, RISCV_SLL, RISCV_SLT,
            RISCV_SLTU, RISCV_XOR, RISCV_SRL, RISCV_SRA,
            RISCV_OR, RISCV_AND}                  /* reg-reg ops */

enum ropw  = {RISCV_ADDW, RISCV_SUBW, RISCV_SLLW,
              RISCV_SRLW, RISCV_SRAW}             /* reg-reg 32-bit ops */
enum sopw = {RISCV_SLLIW, RISCV_SRLIW,
             RISCV_SRAIW}                         /* RV64-only shift ops */
enum amoop = {AMOSWAP, AMOADD, AMOXOR, AMOAND, AMOOR,
              AMOMIN, AMOMAX, AMOMINU, AMOMAXU}   /* AMO ops */
enum csrop = {CSRRW, CSRRS, CSRRC}                /* CSR ops */

/* mappings for assembly */

val reg_name : bits(5) <-> string
mapping reg_name = {
    0b00000 <-> "zero",
    0b00001 <-> "ra",
    0b00010 <-> "sp",
    0b00011 <-> "gp",
    0b00100 <-> "tp",
    0b00101 <-> "t0",
    0b00110 <-> "t1",
    0b00111 <-> "t2",
    0b01000 <-> "fp",
    0b01001 <-> "s1",
    0b01010 <-> "a0",
    0b01011 <-> "a1",
    0b01100 <-> "a2",
    0b01101 <-> "a3",
    0b01110 <-> "a4",
    0b01111 <-> "a5",
    0b10000 <-> "a6",
    0b10001 <-> "a7",
    0b10010 <-> "s2",
    0b10011 <-> "s3",
    0b10100 <-> "s4",
    0b10101 <-> "s5",
    0b10110 <-> "s6",
    0b10111 <-> "s7",
    0b11000 <-> "s8",
    0b11001 <-> "s9",
    0b11010 <-> "s10",
    0b11011 <-> "s11",
    0b11100 <-> "t3",
    0b11101 <-> "t4",
    0b11110 <-> "t5",
    0b11111 <-> "t6"
}

mapping creg_name : bits(3) <-> string = {
  0b000 <-> "s0",
  0b001 <-> "s1",
  0b010 <-> "a0",
  0b011 <-> "a1",
  0b100 <-> "a2",
  0b101 <-> "a3",
  0b110 <-> "a4",
  0b111 <-> "a5"
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
