open Cil


class visitor (counters : Counters.manager) =
  object (self)
    inherit SiteFinder.visitor

    method vfunc func =
      begin
	if self#includedFunction func then
	  let body = func.sbody in
	  let siteInfo = new SiteInfo.c func func.svar.vdecl in
	  let bump, _ = counters#addSiteOffset siteInfo NoOffset in
	  body.bstmts <- bump :: body.bstmts
      end;
      SkipChildren
  end
