open FlowGraph


type result = Compilation.result list


val parse : string -> char Stream.t -> result

val addNodes : graph -> result -> unit
val addEdges : graph -> result -> unit
