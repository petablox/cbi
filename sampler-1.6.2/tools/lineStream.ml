let of_channel source =
  let generator _ =
    try Some (input_line source)
    with End_of_file -> None
  in
  Stream.from generator
