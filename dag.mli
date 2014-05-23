(** Basic functions over specifications and DAGs. *)

(** [find x m] will return [s] if [x] is bound to [s] in [m],
    or [ISet.empty] if there is no binding of [x] in [m]. *)
val find : Defs.IMap.key -> Defs.ISet.t Defs.IMap.t -> Defs.ISet.t

(** [dag $$ t] returns the weight of the task [t] in the graph [dag]. *)
val ( $$ ) : Defs.dag -> Defs.IMap.key -> float

(** [dag |> t] returns the set of successors of the task [t] in 
    the graph [dag]. *)
val ( |> ) : Defs.dag -> Defs.IMap.key -> Defs.ISet.t

(** [dag <| t] returns the set of predecessors of the task [t] in 
    the graph [dag]. *)
val ( <| ) : Defs.dag -> Defs.IMap.key -> Defs.ISet.t

(** [?! s] tests wether the set [s] is empty. *)
val ( ?! ) : Defs.ISet.t -> bool

(** [top size prev] computes the set of integers [i] such that :
    - [0<= i] and [i<size]
    - [?! (find x prev)]. *)
val top : int -> Defs.ISet.t Defs.IMap.t -> Defs.ISet.t

(** [induced_order size succ src] computes a partial ordering over 
    integers below [size] induced by the relation [succ], if [src]
    is the set of integers under [size] that are not successors. *)
val induced_order :
  int ->
  Defs.ISet.t Defs.IMap.t -> Defs.ISet.t -> Defs.ISet.elt -> int -> bool

(** Computes the sum of the weights of the successors of tasks, direct or not *)
val weightsucc :
  int ->
  Defs.ISet.t Defs.IMap.t ->
  Defs.ISet.t -> (Defs.ISet.elt -> float) -> float Defs.IMap.t

(** Computes the set of integers appearing in a list. *)
val to_set : Defs.ISet.elt list -> Defs.ISet.t

(** Converts a specification in a DAG. *)
val spec_to_dag : Defs.spec -> Defs.dag

(** Prints a linear workflow on the standard output. *)
val print_order : Defs.linearwf -> unit

val dag_from_file : string -> Defs.dag
(** Imports a DAG from a file. 

    For this function to succeed, the syntax of the file should be as follows :

    [list_of_tasks]
    
    [list_of_dependencies]

    Or, alternatively : [list_of_tasks;list_of_dependencies]
    
    Each task [t] should be described as

    [w(t),c(t),r(t)]

    with [w(t)], [c(t)] and [r(t)] being floating point numbers written as in OCaml syntax (they are processed by calling [Pervasives.float_of_string]). This will produce a record of type [task] with the fields [w] being set to [w(t)], [c] being set to [c(t)], and [r] being set to [r(t)]. Task should be separated by [;] or by a new line in the list.

    Each dependency must be in the form [i -> j], where [i,j] represent respectively the [i]th and [j]th tasks specified in [list_of_tasks]. The should be separated in the list by [;] or a new line.*)

val draw_dag : Defs.dag -> string -> unit
(** [draw_dag dag filename] draws the DAG [dag] in the file [filename.png].
    {b Warning } : uses the [dot] command from the [graphviz] linux package. *)
