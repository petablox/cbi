open FlowGraph
open Types.Function


type result = key * data


val parse : Types.Compilation.key -> Symtab.t -> char Stream.t -> result

val addNodes : graph -> result -> unit
val addEdges : graph -> Symtab.t -> result -> unit
