/* The emulator fetch-execute-interrupt dispatch loop. */

union FetchResult = {
  F_Bundle32  : word,			    /* Bundle format of 32bits */
  F_Bundle64  : double,     	   	    /* Bundle format of 64bits */
  F_Error     : (ExceptionType, rslenbits)  /* exception and PC */  
}

function isBundle64(d : double) -> bool = (d[63] == 0b1)

val fetch : unit -> FetchResult effect {escape, rmem, rreg, wmv, wreg}
function fetch() -> FetchResult =
/* TODO: this need to be updated with Patmos mem operations are defined */
  match checked_mem_read(Instruction, ppclo, 2, false, false, false) {
     MemException(e) => F_Error(E_Fetch_Access_Fault, PC),
     MemValue(ilo) => {
       if isBundle64(ilo) then F_Bundle64(ilo)
       else {
            PChi : xlenbits = PC + 2;
            match translateAddr(PChi, Execute, Instruction) {
              TR_Failure(e) => F_Error(e, PChi),
              TR_Address(ppchi) => {
                match checked_mem_read(Instruction, ppchi, 2, false, false, false) {
                  MemException(e) => F_Error(E_Fetch_Access_Fault, PChi),
                  MemValue(ihi) => F_Base(append(ihi, ilo))
                }
              }
            }
          }
        }
      }
    }
  }

/* returns whether to increment the step count in the trace */
val step : int -> bool effect {barr, eamem, escape, exmem, rmem, rreg, wmv, wreg}
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
  true
}

val loop : unit -> unit effect {barr, eamem, escape, exmem, rmem, rreg, wmv, wreg}
function loop () = {
  let insns_per_tick = plat_insns_per_tick();
  i : int = 0;
  step_no : int = 0;
  /* TODO: what do we need to load a code here? */
  while (~ (htif_done)) do {
    let stepped = step(step_no);
    if stepped then step_no = step_no + 1;

    /* check htif exit */
    if htif_done then {
      let exit_val = unsigned(htif_exit_code);
      if exit_val == 0 then print("SUCCESS")
      else print_int("FAILURE: ", exit_val);
    } else {
      /* update time */
      i = i + 1;
      if i == insns_per_tick then {
        tick_clock();
        /* for now, we drive the platform i/o at every clock tick. */
        tick_platform();
        i = 0;
      }
    }
  }
}
