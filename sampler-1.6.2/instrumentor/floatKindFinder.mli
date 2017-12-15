open Cil


type classifier

val classifier : file -> classifier

class visitor : classifier -> Counters.manager -> fundec -> SiteFinder.visitor
