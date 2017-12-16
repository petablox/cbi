open Cil


class visitor : global -> fundec ->
  object
    inherit SiteFinder.visitor
    method globals : global list
  end
