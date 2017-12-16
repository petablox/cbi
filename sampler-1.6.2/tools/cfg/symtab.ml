open Types.Function


class t =
  object
    val table : (extension, (key * data)) HashClass.t
	= new HashClass.c 1

    method add name value =
      if table#mem name then
	Printf.eprintf "duplicate symbol table entry: %s\n" name;
      table#add name value

    method find = table#find
  end


let externs = new t
