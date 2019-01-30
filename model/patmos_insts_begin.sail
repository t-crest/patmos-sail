/* Instruction definitions.
 *
 * This includes decoding, execution, and assembly parsing and printing.
 */

scattered union ast

/* returns whether an instruction was retired */
val execute : ast -> bool effect {wreg, rreg, wmea, wmv, rmem, escape}
scattered function execute

val assembly : ast <-> string
scattered mapping assembly

val encdec : ast <-> bits(32)
scattered mapping encdec