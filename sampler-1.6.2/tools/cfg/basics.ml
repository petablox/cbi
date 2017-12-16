let rec sequence terminator element = parser
  | [< () = terminator >] -> []
  | [< first = element; rest = sequence terminator element >] ->
      first :: rest

let rec sequenceLine element = parser
  | [< ''\n' >] -> []
  | [< first = element; rest = sequenceLine element >] ->
      first :: rest

let rec sequenceTab element = parser
  | [< ''\t' >] -> []
  | [< first = element; rest = sequenceTab element >] ->
      first :: rest


(**********************************************************************)


let flatten chars =
  let buffer = Buffer.create 64 in
  List.iter (Buffer.add_char buffer) chars;
  Buffer.contents buffer


let wordLine stream =
  let rec p = parser
    | [< ''\n' >] -> []
    | [< 'first; rest = p >] ->
	first :: rest
  in
  flatten (p stream)


let wordTab stream =
  let rec p = parser
  | [< ''\t' >] -> []
  | [< 'first; rest = p >] ->
      first :: rest
  in
  flatten (p stream)


let integerLine stream =
  let rec p = parser
    | [< ''\n' >] -> []
    | [< ''0' .. '9' as first; rest = p >] ->
	first :: rest
  in
  int_of_string (flatten (p stream))


let integerTab stream =
  let rec p = parser
    | [< ''\t' >] -> []
    | [< ''0' .. '9' as first; rest = p >] ->
	first :: rest
  in
  int_of_string (flatten (p stream))
