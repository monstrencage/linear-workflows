(** Scheduling policies. *)

(** Basic "depth first" ordering. *)
val dfs_v1 : Defs.dag -> Defs.linearwf

(** "depth first" ordering exploring the tasks 
     according to a comparison function. *)
val dfs_compare :
  (int -> int -> int) -> Defs.dag -> Defs.linearwf

(** "depth first" ordering exploring first the tasks 
    with smallest [weightsucc], using [dfs_compare]. *)
val dfs_v2 : Defs.dag -> Defs.linearwf


(** Basic "breadth first" ordering. *)
val bfs : Defs.dag -> Defs.linearwf
