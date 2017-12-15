open Cil


type collection = unit Int64Hash.c


let compareToConstants =
  Options.registerBoolean
    ~flag:"compare-constants"
    ~desc:"compare with constant expressions found in same file"
    ~ident:"CompareConstants"
    ~default:false


let checkFileFilter {file = file} =
  if FileFilter.filter#included file then
    DoChildren
  else
    SkipChildren


class visitor collection =
  object
    inherit nopCilVisitor

    method vglob = function
      | GEnumTag _ ->
	  SkipChildren
      | other ->
	  checkFileFilter (get_globalLoc other)

    method vstmt stmt =
      checkFileFilter (get_stmtLoc stmt.skind)

    method vfunc fundec =
      if FunctionFilter.filter#included fundec.svar.vname then
	DoChildren
      else
	SkipChildren

    method vexpr exp =
      if FileFilter.filter#included !currentLoc.file then
	begin
	  match isInteger (constFold true exp) with
	  | Some constant ->
	      collection#replace constant ()
	  | None ->
	      ()
	end;
      DoChildren
  end


let collect file =
  let collection = new Int64Hash.c 1 in
  collection#add Int64.zero ();
  if !compareToConstants then
    begin
      let visitor = new visitor collection in
      visitCilFileSameGlobals visitor file
    end;
  collection
