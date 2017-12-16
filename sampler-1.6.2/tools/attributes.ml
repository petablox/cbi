open Str


type t = string StringHash.c


exception Malformed of string


let pattern = regexp "^ \\([a-z]+\\)=\"\\([^\"]*\\)\"\\(.*\\)$"

let parse text =
  let result = new StringHash.c 1 in
  let rec consume = function
    | "" -> ()
    | text ->
	if string_match pattern text 0 then
	  let name = matched_group 1 text in
	  let value = matched_group 2 text in
	  let remainder = matched_group 3 text in
	  result#add name value;
	  consume remainder
	else
	  raise (Malformed text)
  in
  consume text;
  result
