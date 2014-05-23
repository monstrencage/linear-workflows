(** Basic examples. *)

open Defs
open Dag

(** [bintree_default size weight] computes a binary tree with [size]
    identical tasks, each of them having weight [weight]. *)
let bintree_default k w : spec = 
  let t = 
    let rec aux acc = function
      | -1 -> acc
      | i -> aux ({w=w;c=1.;r=1.}::acc) (i-1)
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

(** Binary tree of size [10] with weight [5.]. *)
let ex1 = spec_to_dag (bintree_default 10 5.)
let _ = draw_dag ex1 "ex1"

(** First scheduling policy on [ex1]. *)
let wf11 = Schedule.dfs_v1 ex1
(*
let t11 = schedTime {lambda=0.01; d=1.} ex1 wf11
let _ = Printf.printf "t11 = %f\n" t11
*)

(** Second scheduling policy on [example]. *)
let wf12 = Schedule.dfs_v2 ex1
(*
let t12 = schedTime {lambda=0.01; d=1.} ex1 wf12
let _ = Printf.printf "t12 = %f\n" t12
*)

(** DAG extracted from the file [exdag.dag]. *)
let ex2 = dag_from_file "exdag.dag"
let _ = draw_dag ex2 "exdag"

(** First scheduling policy on [ex2]. *)
let wf21 = Schedule.dfs_v1 ex2
(*
let t21 = schedTime {lambda=0.01; d=1.} ex2 wf21
let _ = Printf.printf "t21 = %f\n" t21
*)

(** Second scheduling policy on [ex2]. *)
let wf22 = Schedule.dfs_v2 ex2
(*
let t22 = schedTime {lambda=0.01; d=1.} ex2 wf22
let _ = Printf.printf "t22 = %f\n" t22
*)

