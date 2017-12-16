exception Reached


let explore trace succ origin =
  let worklist = new QueueClass.container in
  let visited = new HashClass.c 0 in

  let visit midpoint =
    trace midpoint;
    if not (visited#mem midpoint) then
      begin
	visited#add midpoint ();
	worklist#push midpoint
      end
  in

  visit origin;

  while not worklist#isEmpty do
    let frontier = worklist#pop in
    List.iter (fun edge -> visit (snd edge)) (succ frontier)
  done


let reach trace succ origin destination =
  let trace midpoint =
    trace midpoint;
    if midpoint = destination then
      raise Reached
  in

  try
    explore trace succ origin;
    false
  with Reached ->
    true
