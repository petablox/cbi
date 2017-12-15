open FlowGraph


type result = Types.Statement.data


val nodeCount : int ref
val edgeCount : int ref
val parse : char Stream.t -> result

val isReturn : result -> bool

val findNode : Types.Function.extension * Types.Statement.extension -> FlowGraph.node

val addNodes : graph -> Types.Statement.key -> result -> unit
val addEdges : graph -> Symtab.t -> Types.Statement.key -> result -> unit
