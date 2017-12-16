type t = {
    file : string;
    line : int;
  }


val parse : char Stream.t -> t
