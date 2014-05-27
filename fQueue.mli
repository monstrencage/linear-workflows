(** Functionnal queues. *)

(** type of queues *)
type 'a t

(** raised when trying to pop from an empty queue. *)
exception Empty

(** returns the first element of the queue together with the rest of the queue. *)
val pop : 'a t -> 'a * 'a t

(** adds an element at the end of the queue. *)
val push : 'a -> 'a t -> 'a t

(** test wether a queue contains any element *)
val is_empty : 'a t -> bool

(** the empty queue. *)
val empty : 'a t
