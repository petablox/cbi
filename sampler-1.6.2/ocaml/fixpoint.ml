let rec compute refine =
  let madeProgress = ref false in
  let result = refine madeProgress in
  if !madeProgress then
    compute refine
  else
    result
