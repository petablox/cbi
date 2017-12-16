open SchemeName


let name = {
  flag = "nothing";
  prefix = "nothing";
  ident = "Nothing";
}


class c file : Scheme.c =
  object
    method findAllSites = ()
    method saveSiteInfo _ _ = ()
  end


let factory = new c
