open Cil
  

class countdown : file -> fundec ->
  object
    method decrement : location -> int -> stmtkind
    method export : location -> instr
    method import : location -> instr
    method checkThreshold : location -> Weight.t -> stmt -> stmt -> stmtkind
    method decrementAndCheckZero : stmtkind -> int -> stmtkind
    method printStats : unit
  end
