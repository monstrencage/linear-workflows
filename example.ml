(*open Format
open Def
open Tools
open Schedule
open Time

(* A default DAG to try the code as it comes along. This is a binary tree.*)
let bintree_default k =
	let ntasks = k in
	let tabTaskInit = Array.make ntasks {id=0;w=5.;c=1.;r=1.} in
	let tabParentsInit = Array.make ntasks [] in
	let tabChildrenInit = Array.make ntasks [] in
	let ind_parent = ref 0 in
	let card_child = ref 0 in
		for i = 1 to ntasks -1 do
			tabTaskInit.(i) <- {id=i;w=5.;c=1.;r=1.};
			if !card_child >= 2 then (incr ind_parent; card_child := 0);
			incr card_child;
			tabParentsInit.(i) <- [!ind_parent];
			tabChildrenInit.(!ind_parent) <- i :: tabChildrenInit.(!ind_parent);
		done;
	let temp = { tabTask = tabTaskInit; sources = [0]; tabParents = tabParentsInit; tabChildren = tabChildrenInit; weightSucc = Array.make ntasks 0.;} in
		computeWS temp


let wf1 = dfs_v1 (bintree_default 10)
let t1 = schedTime {lambda=0.01; d=1.} (bintree_default 10) wf1
let _ = Printf.printf "t1 = %f\n" t1

let wf2 = dfs_v2 (bintree_default 10)
let t2 = schedTime {lambda=0.01; d=1.} (bintree_default 10) wf2
let _ = Printf.printf "t2 = %f\n" t2


*)
open Defs
open Dag

let bintree_default k : spec = 
  let t = 
    let rec aux acc = function
      | -1 -> acc
      | i -> aux ({w=5.;c=0.;r=0.}::acc) (i-1)
    in
    aux [] (k-1)
  in
  let rec aux acc i = 
    let n = 2*i+1 in
    if n > k - 1
    then acc
    else 
      if n = k - 1
      then (i,n)::acc
      else aux ((i,n)::(i,n+1)::acc) (i+1)
  in
  (t,aux [] 0)

let example = spec_to_dag (bintree_default 10)

let wf1 = Schedule.dfs_v1 example

let wf2 = Schedule.dfs_v2 example

let ex2 = dag_from_file "exdag.dag"
