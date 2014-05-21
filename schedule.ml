(*open Format
open Def
open Tools



let dfs_v1 dag =
	let ntasks = Array.length dag.tabTask in
	let result = {order = Array.make ntasks (-1,false); sched = Array.make ntasks (-1,false)} in
	let current = ref 0 in (* The position of the current task in the linearization*)
	let rec auxdfs_v1 taskId =
		(* We verify first whether all parents of taskId have been scheduled *)
		if (List.for_all (fun x -> snd result.sched.(x)) dag.tabParents.(taskId)) then 
		begin
			if (snd result.sched.(taskId) || (fst result.order.(!current)) >= 0) then failwith "already scheduled";
			(* We add the current task to the linearization first, without checkpoint.*)
			result.sched.(taskId) <- (!current , true);
			result.order.(!current) <- (taskId , false);
			incr current;
			
			(* Finally, we execute the dfs order. Note that the next tweak will sort in a specific manner dag.tabChildren.(taskId)*)
			List.iter auxdfs_v1 dag.tabChildren.(taskId)
		end
	in
	List.iter auxdfs_v1 dag.sources;
	if !current <> ntasks then (Printf.printf "Not everyone has been scheduled: %d." !current; failwith "\n") ; 
	result

let dfs_v2 dag =
	let ntasks = Array.length dag.tabTask in
	let result = {order = Array.make ntasks (-1,false); sched = Array.make ntasks (-1,false)} in
	let current = ref 0 in (* The position of the current task in the linearization*)
	let rec auxdfs_v2 taskId =
		(* We verify first whether all parents of taskId have been scheduled *)
		if (List.for_all (fun x -> snd result.sched.(x)) dag.tabParents.(taskId)) then 
		begin
			if (snd result.sched.(taskId) || (fst result.order.(!current)) >= 0) then failwith "already scheduled";
			(* We add the current task to the linearization first, without checkpoint.*)
			result.sched.(taskId) <- (!current, true);
			result.order.(!current) <- (taskId , false);
			incr current;
			
			(* We sort the children in increasing order of weightSucc *)
			let childrenSorted = List.fast_sort (fun x y -> compare (dag.weightSucc.(x)) (dag.weightSucc.(y))) dag.tabChildren.(taskId) in
			List.iter auxdfs_v2 childrenSorted
		end
	in
	List.iter auxdfs_v2 dag.sources;
	if !current <> ntasks then (Printf.printf "Not everyone has been scheduled: %d." !current; failwith "\n") ; 
	result


*)

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
  if tps <> dag.size
  then  (Printf.printf "Not everyone has been scheduled: %d." tps; failwith "\n") ; 
  {order = ord;sched=sch}

let dfs_v2 dag =
  let w = dag.weightsucc in
  let sort s = 
    List.fast_sort 
      (fun x y -> compare (w x) (w y)) 
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
  if tps <> dag.size
  then  (Printf.printf "Not everyone has been scheduled: %d." tps; failwith "\n") ; 
  {order = ord;sched=sch}

