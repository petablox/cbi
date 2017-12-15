type t = {
    statement : Cil.stmt;
    mutable scale : int;
  }


val build : Cil.stmt -> t
