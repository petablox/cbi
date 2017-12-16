class ['element] container =
  object
    val storage : 'element Stack.t = Stack.create ()

    method push element = Stack.push element storage
    method pop = Stack.pop storage

    method clear = Stack.clear storage
    method isEmpty = Stack.is_empty storage

    method iter iterator = Stack.iter iterator storage
  end
