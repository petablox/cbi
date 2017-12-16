open Cil
open Pretty


class c func inspiration left host offset =
  object
    inherit SiteInfo.c func inspiration as super

    method print =
      super#print @
      [d_lval () left; text host; text offset]
  end
