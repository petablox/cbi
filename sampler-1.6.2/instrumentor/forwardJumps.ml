open Cil


let patch clones =
  let findClone = ClonesMap.findCloneOf clones in
  let patchOne jump =
    match jump.skind with
    | Goto (destination, location) ->
	let clonedJump = findClone jump in
	let clonedDest = findClone !destination in
	assert (Labels.hasGotoLabel clonedDest);
	clonedJump.skind <- Goto (ref clonedDest, location)
    | _ ->
	failwith "unexpected statement kind in forward jumps list"
  in
  List.iter patchOne
