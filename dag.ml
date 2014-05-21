open Defs

let find x m =
  try (IMap.find x m)
  with Not_found -> ISet.empty

let ( $$ ) dag t =
  try (IMap.find t (dag.tasks)).w
  with Not_found -> 0.

let ( |> ) dag t =
 (find t (dag.succ))

let ( <| ) dag t =
  (find t (dag.prev))

let ( ?! ) x = ISet.is_empty x

let addint x k m =
  try IMap.add x (k + IMap.find x m) m
  with Not_found -> IMap.add x k m

let get_prev (d : dag) (ts : ISet.t) =
  ISet.fold (fun t acc -> ISet.union (d <| t) acc) ts ISet.empty

let top size prev =
  let rec aux acc = function
    | -1 -> acc
    | i ->
      if ?! (find i prev)
      then aux (ISet.add i acc) (i-1)
      else aux acc (i-1)
  in
  aux ISet.empty (size - 1)

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
  (fun i -> ws.(i))

let to_set = List.fold_left (fun acc i -> ISet.add i acc) ISet.empty

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

let print_order lw =
  let rec aux k =
    try Printf.printf "%d:%d\n" k (IMap.find k lw.order);
	aux (k+1)
    with Not_found -> ()
  in
  aux 0

let dag_from_file filename =
  let ch = open_in filename in
  let sp = 
    DagParser.specs DagLexer.token (Lexing.from_channel ch)
  in
  spec_to_dag sp
