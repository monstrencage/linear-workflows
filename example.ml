open Format
open Def

(* A default DAG to try the code as it comes along. This is a binary tree.*)
let bintree_default =
	let ntasks = 10 in
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
	{
		tabTask = tabTaskInit;
		tabParents = tabParentsInit;
		tabChildren = tabChildrenInit;
	}

