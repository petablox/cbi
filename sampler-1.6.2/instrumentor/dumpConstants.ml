open Cil

let dump file =
  let constants = Constants.collect file in
  print_endline "constants:";
  let scanner n () = Printf.printf "\t%Ld\n" n in
  constants#iter scanner;
  print_newline ()

let process filename =
  let file = Frontc.parse filename () in
  dump file;
  Rmtmps.removeUnusedTemps file;
  dump file;
  dumpFile defaultCilPrinter stdout filename file

;;

initCIL ();
let filenames = List.tl (Array.to_list Sys.argv) in
List.iter process filenames
