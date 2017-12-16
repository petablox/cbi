open Types.Function


class t :
  object
    method add : extension -> (key * data) -> unit
    method find : extension -> (key * data)
  end


val externs : t
