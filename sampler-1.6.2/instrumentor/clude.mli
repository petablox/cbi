class filter : flag:string -> desc:string -> ident:string ->
  object
    method addExclude : string -> unit
    method addInclude : string -> unit

    method included : string -> bool
  end
