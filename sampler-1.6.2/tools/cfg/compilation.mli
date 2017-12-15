open FlowGraph


type result = Function.result list * Symtab.t


val parse : Types.Object.key -> char Stream.t -> result

val addNodes : graph -> result -> unit
val addEdges : graph -> result -> unit
