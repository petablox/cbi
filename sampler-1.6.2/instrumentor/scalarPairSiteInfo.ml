open Cil
open Pretty


type left = lval * string * string
type right = Constant of exp | Variable of varinfo


class c func inspiration left right =
  object
    inherit SiteInfo.c func inspiration as super

    method print =
      let (leftLval, leftHost, leftOff) = left in
      let leftLval = d_lval () leftLval in
      let leftHost = text leftHost in
      let leftOff = text leftOff in

      let (rightExpr, rightKind) =
	match right with
	| Constant expr ->
	    (d_exp () expr, "const")
	| Variable varinfo ->
	    let scope = if varinfo.vglob then "global" else "local" in
	    (text varinfo.vname, scope)
      in
      let rightKind = text rightKind in

      super#print @
      [leftLval; leftHost; leftOff;
       rightExpr; rightKind]
  end
