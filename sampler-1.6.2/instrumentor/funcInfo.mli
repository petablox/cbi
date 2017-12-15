open Cil


type t = {
    calls : Calls.info list;
    sites : stmt list;
  }
