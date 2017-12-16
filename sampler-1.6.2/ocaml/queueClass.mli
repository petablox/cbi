class ['element] container :
  object
    method push : 'element -> unit
    method pop : 'element

    method clear : unit
    method isEmpty : bool
    method length : int

    method iter : ('element -> unit) -> unit
    method fold : ('result -> 'element -> 'result) -> 'result -> 'result
  end
