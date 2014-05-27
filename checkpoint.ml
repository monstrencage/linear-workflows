open Defs
open Dag

let chk_all dag wf =
  let rec aux s = function
    | 0 -> s
    | n -> aux (ISet.add (n-1) s) (n-1)
  in
  {order = wf.order; sched = wf.sched; chk = aux ISet.empty dag.size}

let chk_none _ wf =
  {order = wf.order; sched = wf.sched; chk = ISet.empty}

let chk_per dag wf nbchk =
  let weightsum = IMap.fold (fun _ t acc -> acc+.t.w) dag.tasks 0. in
  let period = weightsum /. nbchk in
  let rec aux chk temp i =
    if i = dag.size
    then chk
    else
      let id = (IMap.find i wf.sched) in
      let temp' = temp +. (dag $$ id) in
      if temp' > period
      then
	if (temp' > 2. *. period)
	then 
	  let id' = IMap.find (i-1) wf.sched in
	  if (i > 0)&&(not (ISet.mem id chk))
	  then 
	    aux 
	      (ISet.add id (ISet.add id' chk)) 
	      (temp' -. 2. *. period) (i+1)
	  else 
	    aux (ISet.add id chk) (temp'-.period) (i+1)
	else aux (ISet.add id chk) (temp'-.period) (i+1)
      else aux chk temp' (i+1)
  in
  {order = wf.order; sched = wf.sched; chk = aux ISet.empty 0. 0}


let chk_sort dag wf nbchk cmp =
  let nbchk = min (int_of_float nbchk) dag.size 
  and ordered_tasks = 
    List.fast_sort 
      (fun (_,t1) (_,t2) -> cmp t1 t2) 
      (IMap.bindings dag.tasks) 
  in
  let rec aux chk k lst =
    if k = nbchk 
    then chk 
    else
      aux (ISet.add (fst (List.hd lst)) chk) (k+1) (List.tl lst)
  in
  {order = wf.order; sched = wf.sched; chk = aux ISet.empty 0 ordered_tasks}
