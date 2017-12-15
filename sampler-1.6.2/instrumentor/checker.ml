open Cil

let check = Check.checkFile []

let process filename =
  Printf.printf "%s:\n" filename;
  let file = Frontc.parse filename () in
  check file

;;

initCIL ();
let filenames = List.tl (Array.to_list Sys.argv) in
let valid = List.fold_left (fun valid name -> process name && valid) true filenames in
if not valid then raise Errormsg.Error
