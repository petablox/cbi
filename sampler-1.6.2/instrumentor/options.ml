open Cil
open Arg


type argspec = string * spec * string


let args = ref []


let push argspec =
  args := argspec :: !args


let registerBoolean ~flag ~desc ~ident ~default =
  let storage = ref default in
  push ("--no-" ^ flag, Clear storage, "");
  push ("--" ^ flag, Set storage, desc);
  if ident <> "" then
    Idents.register (ident, fun () -> string_of_bool !storage);
  storage


let registerString ~flag ~desc ~ident =
  let storage = ref "" in
  push ("--" ^ flag, String ((:=) storage), desc);
  if ident <> "" then
    Idents.register (ident, fun () -> !storage);
  storage


let argspecs () = !args
