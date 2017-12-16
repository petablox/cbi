let graph = Args.process ()

let reach (fromFunc, fromSlot) (toFunc, toSlot) =
  let origin = Statement.findNode (fromFunc, fromSlot) in
  let destination = Statement.findNode (toFunc, toSlot) in
  let result = Transitive.reach ignore graph#succ origin destination in
  Printf.printf "(%s, %d) --> (%s, %d) == %b\n"
    fromFunc fromSlot
    toFunc toSlot
    result

;;

reach ("tiny", 0) ("tiny", 3);
reach ("tiny", 3) ("tiny", 0);
reach ("tiny", 0) ("pong", 0);
reach ("pong", 0) ("tiny", 3)
