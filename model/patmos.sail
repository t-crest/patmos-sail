/* /\* ****************************************************************** *\/ */

/* /\* ALU REG REG format *\/ */
/* mapping encdec_func4 : alu_func4 <-> bits(4) = { */
/*   PATMOS_ADD    <-> 0b0000, */
/*   PATMOS_SUB    <-> 0b0001, */
/*   PATMOS_XOR    <-> 0b0010, */
/*   PATMOS_SL     <-> 0b0011, */
/*   PATMOS_SR     <-> 0b0100, */
/*   PATMOS_SRA    <-> 0b0101, */
/*   PATMOS_OR     <-> 0b0110, */
/*   PATMOS_AND    <-> 0b0111, */
/*   PATMOS_NOR    <-> 0b1011, */
/*   PATMOS_SHADD  <-> 0b1100, */
/*   PATMOS_SHADD2 <-> 0b1101 */
/*  } */

/* union clause ast = ALU_REG_TYPE : (rregbits, rregbits, rregbits, alu_func4) */

/* mapping clause encdec = ALU_REG_TYPE(rd, rs1, rs2, func) <-> 0b0 @ 0b0000 @ 0b01000 @ rd @ rs1 @ rs2 @ 0b000 @ encdec_func4(func) */

/* function clause execute ALU_REG_TYPE(rd, rs1, rs2, func) = { */
/*   print_reg("Rd = " ^ rd ^ ", Rs1 = " ^ rs1 ^ ", Op2 = " ^ rs2);  */
/*   let rs1_val = R(rs1); */
/*   let op2_val = R(rs2); */
/*   let ret : rslenbits = match func { */
/*     PATMOS_ADD => rs1_val + op2_val, */
/*     PATMOS_SUB => rs1_val - op2_val, */
/*     PATMOS_XOR => rs1_val ^ op2_val,  */
/*     PATMOS_SL  => rs1_val << (op2_val[4..0]), */
/*     PATMOS_SR  => rs1_val >> (op2_val[4..0]), */
/*     PATMOS_SRA => shift_right_arith32(rs1_val, op2_val[4..0]), */
/*     PATMOS_OR  => rs1_val | op2_val, */
/*     PATMOS_AND => rs1_val & op2_val, */
/*     PATMOS_NOR => ~(rs1_val | op2_val), */
/*     PATMOS_SHADD => (rs1_val << 0b1) + op2_val, */
/*     PATMOS_SHADD2 => ((rs1_val << 0b1) << 0b1) + op2_val */
/*   }; */
/*   R(rd) = ret; */
/*   true */
/* } */



/* mapping alu_reg_type_mnemonic : alu_func4 <-> string = { */
/*   PATMOS_ADD <-> "add", */
/*   PATMOS_SUB <-> "sub", */
/*   PATMOS_XOR <-> "xor", */
/*   PATMOS_SL  <-> "sl", */
/*   PATMOS_SR  <-> "sr", */
/*   PATMOS_SRA <-> "sra", */
/*   PATMOS_OR  <-> "or", */
/*   PATMOS_AND <-> "and", */
/*   PATMOS_NOR <-> "nor", */
/*   PATMOS_SHADD <-> "shadd", */
/*   PATMOS_SHADD2 <-> "shadd2" */
/* } */

/* mapping clause assembly = ALU_REG_TYPE(rd, rs1, rs2, op) */
/*                       <-> alu_reg_type_mnemonic(op) ^ spc() ^ reg_name(rd) ^ sep() ^ reg_name(rs1) ^ spc() ^ reg_name(rs2) */

/* ****************************************************************** */

/* ALU REG Imm format */
mapping encdec_func3 : alu_func3 <-> bits(3) = {
  PATMOS_ADD <-> 0b000,
  PATMOS_SUB <-> 0b001,
  PATMOS_XOR <-> 0b010,
  PATMOS_SL  <-> 0b011,
  PATMOS_SR  <-> 0b100,
  PATMOS_SRA <-> 0b101,
  PATMOS_OR  <-> 0b110,
  PATMOS_AND <-> 0b111
}

union clause ast = ALU_IMM_TYPE : (rregbits, rregbits, bits(12), alu_func3)

mapping clause encdec = ALU_IMM_TYPE(rd, rs1, imm, func) <-> 0b1 @ 0b0000 @ 0b00 @ encdec_func3(func) @ rd @ rs1 @ imm

function clause execute ALU_IMM_TYPE(rd, rs1, imm, func) = {
  let rs1_val = R(rs1);
  let immext : rslenbits = EXTS(imm);
  let ret : rslenbits = match func {
    PATMOS_ADD => rs1_val + immext,
    PATMOS_SUB => rs1_val - immext,
    PATMOS_XOR => rs1_val ^ immext, 
    PATMOS_SL  => rs1_val << (immext[4..0]),
    PATMOS_SR  => rs1_val >> (immext[4..0]),
    PATMOS_SRA => shift_right_arith32(rs1_val, immext[4..0]),
    PATMOS_OR  => rs1_val | immext,
    PATMOS_AND => rs1_val & immext
  };
  R(rd) = ret;
  true
}

mapping alu_imm_mnemonic : alu_func3 <-> string = {
  PATMOS_ADD <-> "add",
  PATMOS_SUB <-> "sub",
  PATMOS_XOR <-> "xor",
  PATMOS_SL  <-> "sl",
  PATMOS_SR  <-> "sr",
  PATMOS_SRA <-> "sra",
  PATMOS_OR  <-> "or",
  PATMOS_AND <-> "and"
}

mapping clause assembly = ALU_IMM_TYPE(rd, rs1, imm, op)
                      <-> alu_imm_mnemonic(op) ^ spc() ^ reg_name(rd) ^ sep() ^ reg_name(rs1) ^ spc() ^ hex_bits_12(imm)

