open Cil
open Pretty


class c func inspiration expression =
  object
    inherit SiteInfo.c func inspiration as super

    method print =
      super#print @ [d_exp () expression]
  end
