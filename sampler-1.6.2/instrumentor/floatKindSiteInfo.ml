open Cil
open Pretty


type left = lval * string * string


class c func inspiration left =
  object
    inherit SiteInfo.c func inspiration as super

    method print =
      let (leftLval, leftHost, leftOff) = left in
      let leftLval = d_lval () leftLval in
      let leftHost = text leftHost in
      let leftOff = text leftOff in

      super#print @
      [leftLval; leftHost; leftOff]
  end
