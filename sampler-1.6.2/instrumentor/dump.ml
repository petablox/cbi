open Cil

let process filename =
  let file = Frontc.parse filename () in
  dumpFile defaultCilPrinter stdout "" file

;;

initCIL ();
let filenames = List.tl (Array.to_list Sys.argv) in
List.iter process filenames
