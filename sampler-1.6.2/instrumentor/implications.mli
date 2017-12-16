val saveImplications : string ref

class type constantComparisonAccumulator =
  object
    method addInfo : (int * Cil.location * Cil.lval * Cil.exp) -> unit
    method getInfos : unit -> (int * Cil.location * Cil.lval * Cil.exp) list
  end

val getAccumulator : constantComparisonAccumulator Lazy.t 

val printAll : Digest.t Lazy.t -> out_channel -> (int * Cil.location * Cil.lval * Cil.exp) list -> unit
