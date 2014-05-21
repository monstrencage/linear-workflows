val find : Defs.IMap.key -> Defs.ISet.t Defs.IMap.t -> Defs.ISet.t
val ( $$ ) : Defs.dag -> Defs.IMap.key -> float
val ( |> ) : Defs.dag -> Defs.IMap.key -> Defs.ISet.t
val ( <| ) : Defs.dag -> Defs.IMap.key -> Defs.ISet.t
val ( ?! ) : Defs.ISet.t -> bool
val addint : Defs.IMap.key -> int -> int Defs.IMap.t -> int Defs.IMap.t
val get_prev : Defs.dag -> Defs.ISet.t -> Defs.ISet.t
val top : int -> Defs.ISet.t Defs.IMap.t -> Defs.ISet.t
val induced_order :
  int ->
  Defs.ISet.t Defs.IMap.t -> Defs.ISet.t -> Defs.ISet.elt -> int -> bool
val weightsucc :
  int ->
  Defs.ISet.t Defs.IMap.t ->
  Defs.ISet.t -> (Defs.ISet.elt -> float) -> int -> float
val to_set : Defs.ISet.elt list -> Defs.ISet.t
val spec_to_dag : Defs.spec -> Defs.dag
val print_order : Defs.linearwf -> unit
val dag_from_file : string -> Defs.dag
