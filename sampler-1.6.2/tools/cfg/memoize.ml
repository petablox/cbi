let memoize worker =
  let known = new HashClass.c 0 in
  fun arg ->
    try
      let result = known#find arg in
      prerr_endline "remembered old result";
      result
    with Not_found ->
      let result = worker arg in
      known#add arg result;
      prerr_endline "memoized new result";
      result
