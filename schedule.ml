open Defs
open Dag

let dfs_v1 dag =
  let rec aux id (ord,sch,tps) =
    if ISet.for_all (fun j -> IMap.mem j sch) (dag <| id)
    then 
      begin
	let ord' = IMap.add tps id ord
	and sch' = IMap.add id tps sch in
	ISet.fold aux (dag |> id) (ord',sch',tps+1)
      end
    else (ord,sch,tps)
  in
  let ord,sch,tps = ISet.fold aux dag.sources (IMap.empty,IMap.empty,0)
  in
  let res = {order = ord;sched=sch;chk = ISet.empty} in
  if tps <> dag.size
  then  (Printf.printf "Not everyone has been scheduled: %d.\n" tps; print_order res;failwith "") ; 
  res

let dfs_compare cmp dag =
  let sort s = 
    List.fast_sort 
      (fun x y -> cmp x y) 
      (ISet.elements s) 
  in
  let rec aux (ord,sch,tps) id =
    if ISet.for_all (fun j -> IMap.mem j sch) (dag <| id)
    then 
      begin
	let ord' = IMap.add tps id ord
	and sch' = IMap.add id tps sch in
	List.fold_left aux (ord',sch',tps+1) (sort (dag |> id))
      end
    else (ord,sch,tps)
  in
  let ord,sch,tps = 
    List.fold_left aux (IMap.empty,IMap.empty,0) (sort dag.sources)
  in
  let res = {order = ord;sched=sch;chk = ISet.empty} in
  if tps <> dag.size
  then  (Printf.printf "Not everyone has been scheduled: %d.\n" tps; print_order res;failwith "") ; 
  res

let dfs_v2 dag =
  let cmp x y =
    let w i = 
      try
	IMap.find i dag.weightsucc 
      with 
      | Not_found -> 0.
    in compare (w x) (w y)
  in
  dfs_compare cmp dag

let bfs dag = 
  let rec aux (ord,sch,tps) q = 
    try
      let id,q' = FQueue.pop q in
      if IMap.mem id sch
      then aux (ord,sch,tps) q'
      else
	if ISet.for_all (fun j -> IMap.mem j sch) (dag <| id)
	then 
	  begin
	    let ord' = IMap.add tps id ord
	    and sch' = IMap.add id tps sch in
	    aux (ord',sch',tps+1) (ISet.fold (fun j q -> FQueue.push j q) (dag |> id) q')
	  end
	else aux (ord,sch,tps) q'
    with
    | FQueue.Empty -> (ord,sch,tps)
  in
  let ord,sch,tps = 
    aux (IMap.empty,IMap.empty,0) (ISet.fold (fun j q -> FQueue.push j q) dag.sources FQueue.empty)
  in
  let res = {order = ord;sched=sch;chk = ISet.empty} in
  if tps <> dag.size
  then  (Printf.printf "Not everyone has been scheduled: %d.\n" tps; print_order res;failwith "") ; 
  res
