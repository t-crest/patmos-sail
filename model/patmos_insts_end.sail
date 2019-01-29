/* End definitions */
end ast
end execute
end assembly
end encdec

val cast print_insn : ast -> string
function print_insn insn = assembly(insn)

val decode : bits(32) -> option(ast) effect pure
function decode bv = Some(encdec(bv))
