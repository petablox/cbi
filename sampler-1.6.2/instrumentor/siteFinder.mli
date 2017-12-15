open Cil


class visitor :
  object
    inherit FunctionBodyVisitor.visitor

    method private includedStatement : stmt -> bool
    method private includedFunction : fundec -> bool
  end
