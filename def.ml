open Format

(* DEFINITION TYPE TASKS *)

type task = {
	id : int;
	w : float;	(* work *)
	c : float;		(* checkpoint time *)
	r : float;		(* recovery time *)
}
    
(* DEFINITION TYPE (DIRECTED) EDGES *)
type edge = {
	id1 : int;
	id2 : int;
}

(* DEFINITION TYPE DAG *)
type dag = {
	tabTask : task array;
	tabParents : int list array; 	(* tabParents.(i) is the list of the index in tabTask of the parents of tabTask.(i) *)
	tabChildren : int list array;	(* tabChildren.(i) is the list of the index in tabTask of the children of tabTask.(i) *)
}

(* DEFINITION TYPE LINEAR WORKFLOW *)
type linearWorkflow = (int * bool) array (* "int" is the index of the task in dag.tabTask; "bool" is whether or not that task is checkpointed *)
