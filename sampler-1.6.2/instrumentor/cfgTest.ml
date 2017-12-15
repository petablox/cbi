open Cil

let process filename =
  let file = Frontc.parse filename () in
  let digest = lazy (Digest.file file.fileName) in
  EmbedCFG.visit file digest;
  dumpFile defaultCilPrinter stdout filename file

;;

initCIL ();
lineDirectiveStyle := None;

let filenames = List.tl (Array.to_list Sys.argv) in
List.iter process filenames
