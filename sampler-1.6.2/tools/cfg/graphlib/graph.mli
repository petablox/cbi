class ['node, 'nodeData, 'edge] graph : int -> int ->
  object
    method addNode : 'node -> 'nodeData -> unit
    method addEdge : 'node -> 'edge -> 'node -> unit

    method isNode : 'node -> bool
    method isEdge : 'node -> 'edge -> 'node -> bool

    method iterNodes : ('node -> 'nodeData -> unit) -> unit

    method succ : 'node -> ('edge * 'node) list
    method pred : 'node -> ('edge * 'node) list
  end
