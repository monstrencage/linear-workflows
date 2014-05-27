(** Basic functions over specifications and DAGs. *)


open Defs

(** [find x m] will return [s] if [x] is bound to [s] in [m],
    or [ISet.empty] if there is no binding of [x] in [m]. *)
let find x m =
  try (IMap.find x m)
  with Not_found -> ISet.empty

(** [dag $$ t] returns the weight of the task [t] in the graph [dag]. *)
let ( $$ ) dag t =
  try (IMap.find t (dag.tasks)).w
  with Not_found -> 0.

(** [dag |> t] returns the set of successors of the task [t] in 
    the graph [dag]. *)
let ( |> ) dag t =
 (find t (dag.succ))

(** [dag <| t] returns the set of predecessors of the task [t] in 
    the graph [dag]. *)
let ( <| ) dag t =
  (find t (dag.prev))

(** [?! s] tests wether the set [s] is empty. *)
let ( ?! ) x = ISet.is_empty x

(*let addint x k m =
  try IMap.add x (k + IMap.find x m) m
  with Not_found -> IMap.add x k m*)

(*
let get_prev (d : dag) (ts : ISet.t) =
  ISet.fold (fun t acc -> ISet.union (d <| t) acc) ts ISet.empty*)

(** [top size prev] computes the set of integers [i] such that :
    - [0<= i] and [i<size]
    - [?! (find x prev)]. *)
let top size prev =
  let rec aux acc = function
    | -1 -> acc
    | i ->
      if ?! (find i prev)
      then aux (ISet.add i acc) (i-1)
      else aux acc (i-1)
  in
  aux ISet.empty (size - 1)

(** [induced_order size succ src] computes a partial ordering over 
    integers below [size] induced by the relation [succ], if [src]
    is the set of integers under [size] that are not successors. *)
let induced_order size succ src =
  let below = Array.make size ISet.empty in
  let rec aux i =
      below.(i)<- 
	ISet.fold 
	(fun j acc -> aux j; 
	  (ISet.union (below.(j)) acc)) (find i succ) (find i succ)
  in
  ISet.iter aux src;
  fun t1 t2 -> ISet.mem t1 (below.(t2))

(** Computes the sum of the weights of the successors of tasks, direct or not *)
let weightsucc size succ src weight =
  let ( <! ) = induced_order size succ src in
  let ws = Array.make size 0. in
  for i = 0 to (size -1) do
    for j = (i+1) to (size -1) do
      if i <! j
      then ws.(j) <- ws.(j) +. (weight i)
      else 
	if j <! i
	then ws.(i) <- (weight j) +. ws.(i);
    done
  done;
  let (_,wm) =
    Array.fold_left 
      (fun (i,wm) w ->
	(i+1,IMap.add i w wm))
      (0,IMap.empty)
      ws
  in
  wm

(** Computes the set of integers appearing in a list. *)
let to_set = List.fold_left (fun acc i -> ISet.add i acc) ISet.empty

(** Converts a specification in a DAG. *)
let spec_to_dag (tsks,deps :spec) : dag =
  let size,tasks =
    List.fold_left 
      (fun (i,ts) task -> (i+1,IMap.add i task ts))
      (0,IMap.empty)
      tsks
  in
  let (succ,prev) =
    List.fold_left
      (fun (s,p) (t1,t2 : int * int) ->
	assert (t1<size && t2 < size && t1 >= 0 && t2 >=0);
	(IMap.add t1 (ISet.add t2 (find t1 s)) s,
	 IMap.add t2 (ISet.add t1 (find t2 p)) p))
      (IMap.empty,IMap.empty)
      deps
  in
  let sources = top size prev in
  let weight t = 
    try (IMap.find t tasks).w
    with Not_found -> 0.
  in
  let weightsucc = weightsucc size succ sources weight in
  {
    size =size;
    tasks = tasks;
    succ = succ;
    prev = prev;
    sources = sources;
    weightsucc = weightsucc;
  }


(** Prints a linear workflow on the standard output. *)
let print_order lw =
  let rec aux k =
    try Printf.printf "%d;" (IMap.find k lw.order) ;
	aux (k+1)
    with Not_found -> ()
  in
  aux 0;
  print_newline()

let dag_from_file filename =
  let ch = open_in filename in
  let sp = 
    DagParser.specs DagLexer.token (Lexing.from_channel ch)
  in
  spec_to_dag sp
(** Imports a DAG from a file. *)


(** For this function to succeed, the syntax of the file should be as follows :

    [list_of_tasks]
    [list_of_dependencies]

    Or, alternatively :

    [list_of_tasks];[list_of_dependencies]
    
    Each task [t] should be described as

    [w(t),c(t),r(t)],

    the semantics being taht this will produce a record of type [task] with the fields [w] being set to [w(t)], [c] being set to [c(t)], and [r] being set to [r(t)]. Task should be separated by [;] or by a new line in the list.

    Each dependency must be in the form [i -> j], where [i,j] represent respectively the [i]th and [j]th tasks specified in [list_of_tasks]. The should be separated in the list by [;] or a new line.*)

let draw_dag dag filename =
  let chout = open_out (filename^".dot") in
  Printf.fprintf chout "digraph structs {\nnode [shape=record];\n";
  let printtsk i task =
    Printf.fprintf 
      chout 
      "%d [label=\"%d:|%.1f|%.1f|%.1f\"];\n" 
      i i task.w task.c task.r
  in
  let printdep i j =
    Printf.fprintf chout "%d -> %d;\n" i j
  in
  IMap.iter printtsk dag.tasks;
  IMap.iter (fun i -> ISet.iter (printdep i)) dag.succ;
  Printf.fprintf chout " }";
  close_out chout;
  let cmd = Printf.sprintf "dot %s.dot -Tpng > %s.png" filename filename 
  in
  let _ = Printf.printf "%s\n" cmd;Unix.system cmd
  in ()
(** [draw_dag dag filename] draws the DAG [dag] in the file [filename.png].
    {b Warning } : uses the [dot] command from the [graphviz] linux package. *)

