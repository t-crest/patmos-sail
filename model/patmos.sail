/* ****************************************************************** */

union clause ast = ALU_REG_TYPE : (bundle, pred, bits(5), rregbits, rregbits, rregbits, bits(3), func4)

union clause ast = ALU_IMM_TYPE : (bundle, pred, bits(5), rregbits, rregbits, rregbits, bits(3), func4)

union clause ast = ALU_LIMM_TYPE : (bundle, pred, bits(5), rregbits, rregbits, rregbits, bits(3), func4)

mapping encdec_alu : func4 <-> bits(4) = {
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
  PATMOS_SHADD2 <-> 0b1101,                  
}

