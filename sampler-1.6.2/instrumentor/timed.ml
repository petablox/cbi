let timed action argument =
  let before = Unix.gettimeofday () in
  let result = action argument in
  let after = Unix.gettimeofday () in
  let elapsed = after -. before in
  elapsed, result
