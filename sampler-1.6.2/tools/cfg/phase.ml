let time description operation =
  Printf.eprintf "%s: begin\n%!" description;
  let before = Unix.gettimeofday () in
  let result = operation () in
  let after = Unix.gettimeofday () in
  Printf.eprintf "%s: end; %g sec\n%!" description (after -. before);
  result
