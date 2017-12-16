open Types.Statement


type split = Before | After

type node = split * key

type edge = Flow | Call | Return

class type graph = [node, data, edge] Graph.graph
