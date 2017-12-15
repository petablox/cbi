open Cil


let patch clones weights countdown =
  
  let patchOne jump =
    let weight = weights#find jump in
    match jump.skind with
    | Goto (destination, location) ->
	let findClone = ClonesMap.findCloneOf clones in
	let clonedDest = findClone !destination in
	let choice = countdown#checkThreshold location weight clonedDest !destination in
	jump.skind <- choice;
	(findClone jump).skind <- choice;

    | _ -> failwith "unexpected statement kind in backward jumps list"
  in

  List.iter patchOne
