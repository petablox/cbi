let balancePaths : bool ref =
  Options.registerBoolean
    ~flag:"balance-paths"
    ~desc:"balance instrumentation across all paths using dummy sites"
    ~ident:"BalancePaths"
    ~default:false
