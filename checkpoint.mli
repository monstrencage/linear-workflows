(** Checkpoints *)

(** Checks all tasks. *)
val chk_all : Defs.dag -> Defs.linearwf -> Defs.linearwf

(** Checks no task. *)
val chk_none : Defs.dag -> Defs.linearwf -> Defs.linearwf

(** Checks tasks periodicaly. *)
val chk_per : Defs.dag -> Defs.linearwf -> float -> Defs.linearwf

(** Checks the smallest tasks, with respect to some comparison function. *)
val chk_sort :
  Defs.dag ->
  Defs.linearwf -> float -> (Defs.task -> Defs.task -> int) -> Defs.linearwf
