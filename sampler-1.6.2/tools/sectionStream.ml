open Stream


let until basis terminator =
  let generator _ =
    let line = next basis in
    if line = terminator then
      None
    else
      Some line
  in
  from generator
