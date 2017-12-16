class ['element] container :
  object
    method push : 'element -> unit
    method pop : 'element

    method clear : unit
    method isEmpty : bool

    method iter : ('element -> unit) -> unit
  end
