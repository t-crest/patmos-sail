/* Instruction definitions.
 *
 * This includes decoding, execution, and assembly parsing and printing.
 */

scattered union ast

/* returns whether an instruction was retired, used for computing minstret */
val execute : ast -> bool effect {escape, wreg, rreg, wmv, eamem, rmem, barr, exmem}
scattered function execute

val assembly : ast <-> string
scattered mapping assembly

val encdec : ast <-> bits(32)
scattered mapping encdec