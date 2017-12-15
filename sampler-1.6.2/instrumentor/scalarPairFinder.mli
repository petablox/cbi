open Cil


class visitor :
    Constants.collection -> varinfo list ->
      Counters.manager -> Implications.constantComparisonAccumulator -> fundec -> SiteFinder.visitor
