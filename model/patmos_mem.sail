/* Physical memory model.
 * No support MMIO regions
 */

/* memory access exceptions */
function is_aligned_addr forall 'n. (addr : rslenbits, width : atom('n)) -> bool =
  unsigned(addr) % width == 0

function phys_mem_read forall 'n, 'n >= 0. (t : ReadType, addr : rslenbits, width : atom('n)) -> MemoryOpResult(bits(8 * 'n)) =
  match (t, __Patmos_read(addr, width)) {
    (Instruction, None()) => MemException(E_Fetch_Access_Fault),
    (Data, None())        => MemException(E_Load_Access_Fault),
    (_, Some(v))          => { print_mem("mem[" ^ t ^ "," ^ BitStr(addr) ^ "] -> " ^ BitStr(v));
                               MemValue(v) }
  }

function checked_mem_read forall 'n, 'n > 0. (t : ReadType, addr : rslenbits, width : atom('n)) -> MemoryOpResult(bits(8 * 'n)) =
/*  if within_phys_mem(addr, width)*/
   phys_mem_read(t, addr, width)
/*  else MemException(E_Load_Access_Fault)*/

val mem_read : forall 'n, 'n > 0. (rslenbits, atom('n)) -> MemoryOpResult(bits(8 * 'n)) effect {rmem}

function mem_read (addr, width) = {
 let result : MemoryOpResult(bits(8 * 'n)) =
  if (~ (is_aligned_addr(addr, width)))
  then MemException(E_Load_Addr_Align)
  else checked_mem_read(Data, addr, width);
 result
}

// only used for actual memory regions, to avoid MMIO effects
function phys_mem_write forall 'n. (addr : rslenbits, width : atom('n), data: bits(8 * 'n)) -> MemoryOpResult(bool) = {
  print_mem("mem[" ^ BitStr(addr) ^ "] <- " ^ BitStr(data));
  MemValue(__Patmos_write(addr, width, data))
}

// dispatches to MMIO regions or physical memory regions depending on physical memory map
function checked_mem_write forall 'n, 'n > 0. (addr : rslenbits, width : atom('n), data: bits(8 * 'n)) -> MemoryOpResult(bool) =
  if within_phys_mem(addr, width)
  then phys_mem_write(addr, width, data)
  else MemException(E_SAMO_Access_Fault)

val mem_write_value : forall 'n, 'n > 0. (rslenbits, atom('n), bits(8 * 'n)) -> MemoryOpResult(bool) effect {wmv}

function mem_write_value (addr, width, value) = {
  if (~ (is_aligned_addr(addr, width)))
  then MemException(E_SAMO_Addr_Align)
  else checked_mem_write(addr, width, value)
}

function handle_mem_exception(addr : rslenbits, e : ExceptionType) -> unit = {
  nextPC = EXTZ(0b0);
}

