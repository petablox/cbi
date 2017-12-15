open Phase
open Statement


let process () =
  let argSpecs = [] in
  let objects = ref [] in

  let doOne filename =
    let channel = open_in filename in
    let stream = Stream.of_channel channel in
    time ("parse " ^ filename)
      (fun () -> objects := (Object.parse filename stream) :: !objects)
  in

  Arg.parse argSpecs doOne
    ("Usage:" ^ Sys.executable_name ^ " <module>.cfg ...");

  let graph = new Graph.graph !nodeCount !edgeCount in
  time "create graph nodes" (fun () -> List.iter (Object.addNodes graph) !objects);
  time "create graph edges" (fun () -> List.iter (Object.addEdges graph) !objects);
  graph
