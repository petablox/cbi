type ('node, 'edge) follow = 'node -> ('edge * 'node) list
type 'node trace = 'node -> unit

type ('node, 'edge) explore = 'node trace ->  ('node, 'edge) follow -> 'node -> unit
type ('node, 'edge) reach = 'node trace ->  ('node, 'edge) follow -> 'node -> 'node -> bool
