module Object : sig
  type key = string
end


module Compilation : sig
  type basis = Object.key
  type extension = string
  type key = basis * extension
end


module rec Function : sig
  type linkage = Static | Extern

  type basis = Compilation.key
  type extension = string
  type key = basis * extension

  type data = {
      location : Location.t;
      nodes : Statement.data array;
      returns : int list;
    }
end


and Statement : sig
  type basis = Function.key
  type extension = int
  type key = basis * extension

  type data = {
      location : Location.t;
      successors : int list;
      callees : string list Known.known;
    }
end
