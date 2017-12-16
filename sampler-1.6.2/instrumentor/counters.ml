open Cil
open Pretty
open Printf
open SchemeName


class manager name file =
  let counters = FindGlobal.find ("cbi_" ^ name.prefix ^ "Counters") file in

  object (self)
    val mutable nextId : int = 0
    val siteInfos = new QueueClass.container
    val stamper = Timestamps.set file

    method private bump = Threads.bump file

    method addSiteExpr siteInfo selector =
      self#addSiteOffset siteInfo (Index (selector, NoOffset))

    method addSiteOffset siteInfo selector =
      let thisId = nextId in
      let site = (Var counters, Index (integer thisId, NoOffset)) in
      let func = siteInfo#fundec in
      let location = siteInfo#inspiration in
      let stamp = stamper name thisId location in
      let counter = addOffsetLval selector site in
      let bump = self#bump counter location in
      let implementation = siteInfo#implementation in
      let instructions = bump :: stamp in
      implementation.skind <- IsolateInstructions.isolate instructions;
      Sites.registry#add func (Site.build implementation);
      siteInfos#push siteInfo;
      nextId <- nextId + 1;
      implementation, thisId

    method patch =
      mapGlobals file
	begin
	  function
	    | GVar ({vtype = TArray (elementType, _, attributes)} as varinfo, initinfo, location)
	      when varinfo == counters
	      ->
		GVar ({varinfo with vtype = TArray (elementType,
						    Some (integer nextId),
						    attributes)},
		      initinfo, location)

	    | GFun ({svar = {vname = "cbi_reporter"}; sbody = sbody}, _) as global
	      when nextId > 0 ->
		let schemeReporter = FindFunction.find ("cbi_" ^ name.prefix ^ "Reporter") file in
		let call = Call (None, Lval (var schemeReporter), [], locUnknown) in
		sbody.bstmts <- mkStmtOneInstr call :: sbody.bstmts;
		global

	    | other ->
		other
	end

    method saveSiteInfo digest channel =
      SiteInfo.print channel digest name siteInfos
  end
