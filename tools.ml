open Format
open Def


let isCkptWF workflow i = (* Returns whether ith task of the workflow is checkpointed. *)
	snd (workflow.order.(i))

let isCkptDAG workflow i = (* Returns whether task i is checkpointed. *)
	if not (snd workflow.sched.(i)) then failwith "the task is not scheduled"
	else
		snd (workflow.order.(fst workflow.sched.(i)))


let indTaskWF2DAG workflow i =
		fst workflow.order.(i)

let indTaskDAG2WF workflow i =
	if not (snd workflow.sched.(i)) then failwith "the task is not scheduled"
	else
		fst workflow.sched.(i)
