(** Definitions of the basic types. *)

(** Tasks are identified by integers. *)
module Id = struct
  type t = int
  let compare = compare
end

(** Maps with integers keys. *)
module IMap = Map.Make(Id)

(** Sets over integers. *)
module ISet = Set.Make(Id)

(** Task caracteristics. *)
type task = {
  w : float;	(** work *)
  c : float;	(** checkpoint time *)
  r : float;	(** recovery time *)
}

(** Complete type of a Directed Acyclic Graph. *)
(** Actually, the acyclicity is not enforced by the type *)
(** (but most functions will not terminate if it is not the case). *)
type dag = {
  size : int;             (** number of tasks *)
  tasks : task IMap.t;    (** maps tasks to their caracteristics *)
  succ : ISet.t IMap.t;   (** maps tasks to their direct successors *)
  prev : ISet.t IMap.t;   (** maps tasks to their direct predecessors *)
  sources : ISet.t;       (** the set of tasks without predecessors *)
  weightsucc : float IMap.t; 
  (** maps tasks to the sum of the weights of their successors, direct or not *)
}

(** Type of the specification of a DAG. Can be converted to [dag] *)
(** (see [Dag.spec_to_dag]). *)
type spec = task list * (int * int) list

(** Type of a linear workflow. *)
type linearwf = {
  order : int IMap.t; (** maps [i] to the [i]th task in the order *)
  sched : int IMap.t; (** maps task [i] to its rank in the order *)
  chk : ISet.t        (** the set of checkpointed tasks *)
}

(** Type of the parameters. *)
type param = {
  lambda : float;
  d : float;
}
