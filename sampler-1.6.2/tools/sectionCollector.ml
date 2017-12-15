class t (finisher : _ -> unit) =
  object
    val lines : string QueueClass.container = new QueueClass.container

    method readLine line =
      lines#push line

    method finish =
      let fill _ = lines#pop in
      let array = Array.init lines#length fill in
      finisher array;
      ()
  end
