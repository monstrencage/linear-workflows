open Format
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


