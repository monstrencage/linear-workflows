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
(** Imports a DAG from a file. *)
(** For this function to succeed, the file must have the following 
    syntax :

    w(0);w(1); ... ; w(n-1); i(0)[->]j(0);i(1)[->]j(1); ... ; i(k)[ ->]j(k)
    
    This would correspond to a specification :

    [({w=]w(0)[;c=0.;r=0.}::{w=]w(1)[;c=0.;r=0.}::]...[{w=]w(n-1)[;c=0.;r=0.}::[],(]i(0)[,]j(0)[)::(]i(1)[,]j(1)[)::]...[(]i(k)[,]j(k)[)::[])].
*)
val dag_from_file : string -> Defs.dag
