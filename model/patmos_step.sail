/* The emulator fetch-execute-interrupt dispatch loop. */

union FetchResult = {
  F_Bundle32  : word,			    /* Bundle format of 32bits */
  F_Error     : (ExceptionType, rslenbits)  /* exception and PC */  
}

val fetch : unit -> FetchResult effect {rmem, rreg}
function fetch() -> FetchResult =
match checked_mem_read(Instruction, PC, 4) {
  MemException(e) => F_Error(E_Fetch_Access_Fault, PC),
  MemValue(i) => F_Bundle32(i)
}

/* returns whether to increment the step count in the trace */
val step : int -> bool effect {rmem, rreg, wreg}
function step(step_no) = {
  let (retired) : (bool) =
    match fetch() {
      F_Error(e, addr) => {
      	handle_mem_exception(addr, e);
      	(false)
      },
      F_Bundle32(w) => {
        match decode(w) {
           None() => {
             print_instr("[" ^ string_of_int(step_no) ^ "]: " ^ BitStr(PC) ^ " (" ^ BitStr(w) ^ ") <no-decode>");
             instbits = EXTZ(w);
             handle_illegal();
             (false)
           },
           Some(ast) => {
             print_instr("[" ^ string_of_int(step_no) ^ "]: " ^ BitStr(PC) ^ " (" ^ BitStr(w) ^ ") " ^ ast);
             nextPC = PC + 4;
             (execute(ast))
           }
        }
      }
    };
  PC = nextPC;
  print_instr("New PC = " ^ BitStr(PC));
  true
}

val loop : unit -> unit effect {rmem, rreg, wreg}
function loop () = {
  step_no : int = 0;
  while (true) do {
    print_instr("PC = " ^ BitStr(PC));
    let stepped = step(step_no);
    if stepped then step_no = step_no + 1;
  }
}

