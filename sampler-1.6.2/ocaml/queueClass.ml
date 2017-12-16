class ['element] container =
  object
    val storage : 'element Queue.t = Queue.create ()

    method push element = Queue.push element storage
    method pop = Queue.pop storage

    method clear = Queue.clear storage
    method isEmpty = Queue.is_empty storage
    method length = Queue.length storage

    method iter iterator = Queue.iter iterator storage

    method fold
	: 'result . (('result -> _ -> 'result) -> 'result -> 'result)
	= fun folder basis ->
	  Queue.fold folder basis storage
  end
