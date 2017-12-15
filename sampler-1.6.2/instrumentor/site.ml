type t = {
    statement : Cil.stmt;
    mutable scale : int;
  }


let build stmt = {
  statement = stmt;
  scale = 1;
}
