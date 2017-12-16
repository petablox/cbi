open Cil


let threads =
  Options.registerBoolean
    ~flag:"threads"
    ~desc:"create thread-safe code"
    ~ident:"Threads"
    ~default:false


let enabled () = !threads


let bump file =
  if !threads then
    let helper = Lval (var (FindFunction.find "cbi_atomicIncrementCounter" file)) in
    fun lval location ->
      Call (None, helper, [mkAddrOrStartOf lval], location)
  else
    fun lval location ->
      Set (lval, increm (Lval lval) 1, location)
