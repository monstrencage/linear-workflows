(** Scheduling policies. *)

(** Basic "depth first" ordering. *)
val dfs_v1 : Defs.dag -> Defs.linearwf

(** "depth first" ordering exploring first the tasks 
    with smallest [weightsucc]. *)
val dfs_v2 : Defs.dag -> Defs.linearwf
