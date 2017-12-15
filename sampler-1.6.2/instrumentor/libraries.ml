let functions =
  let functions = [
  ] in

  let collection = new StringHash.c 0 in

  List.iter (fun func -> collection#add func ()) functions;
  collection
