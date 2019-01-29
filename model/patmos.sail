/* ****************************************************************** */
union clause ast = ALU_REG_TYPE : (bits(1), pred, bits(5), rregbits, rregbits, rregbits, bits(3), func4)

mapping encdec_func : func4 <-> bits(4) = {
  PATMOS_ADD <-> 0b0000,
  PATMOS_SUB <-> 0b0001,
  PATMOS_XOR <-> 0b0010,
  PATMOS_SL  <-> 0b0011,
  PATMOS_SR  <-> 0b0100,
  PATMOS_SRA <-> 0b0101,
  PATMOS_OR  <-> 0b0110,
  PATMOS_AND <-> 0b0111,
  PATMOS_NOR <-> 0b1011,
  PATMOS_SHADD <-> 0b1100,
  PATMOS_SHADD2 <-> 0b1101
}

mapping clause encdec = ALU_REG_TYPE(pred, rd, rs1, rs2, func) <-> 0b1 @ pred @ 0b01000 @ rd @ rs1 @ rs2 @ 0b000 @ encdec_func(func)

function clause execute ALU_REG_TYPE(pred, rd, rs1, rs2, func) = {
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

/* TODO: need to find a way to merge this with ALU_REG_TYPE */
union clause ast = ALU_IMM_TYPE : (bits(1), pred, bits(2), func3, rregbits, rregbits, bits(12))

mapping encdec_func : func3 <-> bits(3) = {
  PATMOS_ADD <-> 0b000,
  PATMOS_SUB <-> 0b001,
  PATMOS_XOR <-> 0b010,
  PATMOS_SL  <-> 0b011,
  PATMOS_SR  <-> 0b100,
  PATMOS_SRA <-> 0b101,
  PATMOS_OR  <-> 0b110,
  PATMOS_AND <-> 0b111,
}

mapping clause encdec = ALU_IMM_TYPE(pred, func, rd, rs1, imm) <-> 0b1 @ pred @ 0b00 @ encdec_func(func) @ rd @ rs1 @ imm

function clause execute ALU_IMM_TYPE(pred, func3, rd, rs1, imm) = {
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

mapping alu_reg_type_mnemonic : func <-> string = {
  PATMOS_ADD <-> "add",
  PATMOS_SUB <-> "sub",
  PATMOS_XOR <-> "xor",
  PATMOS_SL  <-> "sl",
  PATMOS_SR  <-> "sr",
  PATMOS_SRA <-> "sra",
  PATMOS_OR  <-> "or",
  PATMOS_AND <-> "and",
}

