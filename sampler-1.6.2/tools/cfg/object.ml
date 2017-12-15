open Basics


type result = Compilation.result list


let parse name =
    let compilations = sequence Stream.empty (Compilation.parse name) in
    parser [< compilations = compilations >] -> compilations


let addNodes graph =
  List.iter (Compilation.addNodes graph)


let addEdges graph =
  List.iter (Compilation.addEdges graph)
