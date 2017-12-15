exception Found


type ('node, 'edge) edge = ('node * 'edge * 'node)


class ['node, 'nodeData, 'edge] graph nodeCount edgeCount =
  let _ = Printf.eprintf "build graph with %d nodes and %d edges\n%!" nodeCount edgeCount in
  object (self)
    val mutable nodes = new HashClass.c nodeCount
    val mutable edges = new HashClass.c edgeCount

    val mutable succs = new HashClass.c edgeCount
    val mutable preds = new HashClass.c edgeCount


    method addNode (node : 'node) (data : 'nodeData) =
      assert (not (self#isNode node));
      nodes#add node data

    method addEdge origin label destination =
      let edge : ('node, 'edge) edge = (origin, label, destination) in
      assert (not (self#isEdgeTuple edge));
      edges#add edge ();
      succs#add origin (label, destination);
      preds#add destination (label, origin)


    method isNode =
      nodes#mem

    method isEdge origin label destination =
      self#isEdgeTuple (origin, label, destination)

    method private isEdgeTuple =
      edges#mem


    method iterNodes =
      nodes#iter


    method succ origin : ('edge * 'node) list =
      assert (self#isNode origin);
      succs#findAll origin

    method pred destination : ('edge * 'node) list =
      assert (self#isNode destination);
      preds#findAll destination
  end
