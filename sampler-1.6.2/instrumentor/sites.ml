open Cil
open Scanf
open Scanning
open Site


let registry = new FunctionNameHash.c 1


let loadScales =
  Options.registerString
    ~flag:"load-scales"
    ~desc:"load non-default site scaling factors from the named file"
    ~ident:"LoadScales"


let setScales () =
  if !loadScales <> "" then
    let scales = new HashClass.c 1 in

    let scanbuf = from_file !loadScales in
    while not (end_of_input scanbuf) do
      bscanf scanbuf "%s@\t%s\t%d\n"
	(fun func id scale ->
	  scales#add (func, id) scale)
    done;

    registry#iter
      (fun {svar = {vname = vname}} site ->
	let scale = try scales#find (vname, string_of_int site.statement.sid)
	with Not_found -> try scales#find (vname, "*")
	with Not_found -> try scales#find ("*", "*")
	with Not_found -> 1
	in
	site.scale <- scale)


let patch clones countdown site =
  let original = site.statement in
  let scale = site.scale in
  let location = get_stmtLoc original.skind in
  let decrement = countdown#decrement location scale in
  let clone = ClonesMap.findCloneOf clones original in
  clone.skind <- countdown#decrementAndCheckZero clone.skind scale;
  if !BalancePaths.balancePaths then
    original.skind <- Instr []
  else
    original.skind <- decrement
