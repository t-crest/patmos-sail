/* ****************************************************************** */

/* Binary arithmetic */

mapping encdec_func3 : func3 <-> bits(3) = {
  PATMOS_ADD <-> 0b000,
  PATMOS_SUB <-> 0b001,
  PATMOS_XOR <-> 0b010,
  PATMOS_SL  <-> 0b011,
  PATMOS_SR  <-> 0b100,
  PATMOS_SRA <-> 0b101,
  PATMOS_OR  <-> 0b110,
  PATMOS_AND <-> 0b111
}
/* TODO: this should be defined by including the previous mapping */
mapping encdec_func4 : func4 <-> bits(4) = {
  PATMOS_NOR    <-> 0b1011,
  PATMOS_SHADD  <-> 0b1100,
  PATMOS_SHADD2 <-> 0b1101
}

mapping alu_reg_type_mnemonic : func3 <-> string = {
  PATMOS_ADD <-> "add",
  PATMOS_SUB <-> "sub",
  PATMOS_XOR <-> "xor",
  PATMOS_SL  <-> "sl",
  PATMOS_SR  <-> "sr",
  PATMOS_SRA <-> "sra",
  PATMOS_OR  <-> "or",
  PATMOS_AND <-> "and",
}
/* TODO: this should be defined by including the previous mapping */
mapping alu_reg_type_mnemonic : func4 <-> string = {
  PATMOS_ADD <-> "add",
  PATMOS_SUB <-> "sub",
  PATMOS_XOR <-> "xor",
  PATMOS_SL  <-> "sl",
  PATMOS_SR  <-> "sr",
  PATMOS_SRA <-> "sra",
  PATMOS_OR  <-> "or",
  PATMOS_AND <-> "and",
  PATMOS_NOR <-> "nor",
  PATMOS_SHADD <-> "shadd",
  PATMOS_SHADD2 <-> "shadd2"
}

/* TODO: This should be defined using a single interface common to both
   so that a single execute clause statement is kept */
union clause ast = ALU_REG_TYPE : (predbits, rregbits, rregbits, rregbits, func4)
union clause ast = ALU_IMM_TYPE : (predbits, rregbits, rregbits, bits(12), func3)

mapping clause encdec = ALU_REG_TYPE(pred, rd, rs1, rs2, func) <-> 0b0 @ pred @ 0b01000 @ rd @ rs1 @ rs2 @ 0b000 @ encdec_func4(func)
mapping clause encdec = ALU_IMM_TYPE(pred, rd, rs1, imm, func) <-> 0b1 @ pred @ 0b00 @ encdec_func3(func) @ rd @ rs1 @ imm

function clause execute ALU_REG_TYPE(pred, rd, rs1, op2, func) = {
  let rs1_val = R(rs1);
  let rs2_val = R(rs2); 
  let ref : rslenbits = match func {
    PATMOS_ADD => rs1_val + rs2_val,
    PATMOS_SUB => rs1_val - rs2_val,
    PATMOS_XOR => rs1_val ^ rs2_val, 
    PATMOS_SL  => rs1_val << (rs2_val[4..0]),
    PATMOS_SR  => rs1_val >> (rs2_val[4..0]),
    PATMOS_SRA => shift_right_arith64(rs1_val, rs2_val[4..0]),
    PATMOS_OR  => rs1_val | rs2_val,
    PATMOS_AND => rs1_val & rs2_val,
    PATMOS_NOR => ~(rs1_val | rs2_val),
    PATMOS_SHADD => (rs1_val << 1) + rs2_val ,
    PATMOS_SHADD2 => (rs1_val << 2) + rs2_val,
  };
  R(rd) = ret;
  true
}

function clause execute ALU_IMM_TYPE(pred, rd, rs1, imm, func) = {
  let op2 : rslenbits = EXTS(imm)
  let rs1_val = R(rs1);
  let ref : rslenbits = match func {
    PATMOS_ADD => rs1_val + op2,
    PATMOS_SUB => rs1_val - op2,
    PATMOS_XOR => rs1_val ^ op2, 
    PATMOS_SL  => rs1_val << (op2[4..0]),
    PATMOS_SR  => rs1_val >> (op2[4..0]),
    PATMOS_SRA => shift_right_arith64(rs1_val, op2[4..0]),
    PATMOS_OR  => rs1_val | op2,
    PATMOS_AND => rs1_val & op2,
  };
  R(rd) = ret;
  true
}


