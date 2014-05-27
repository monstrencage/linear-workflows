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

let test dag name policy =
  let wf = policy dag in Printf.printf "%s :\n" name; print_order wf
  (*let time = schedTime {lambda=0.01; d=1.} dag wf
  in Printf.printf "%s : %f\n" name time*)

(** Testing function that exports a given DAG to an image,
    and then performs the schedulling policies [dfs_v1],
    [dfs_v2] and [bfs]. *)
let full_test dag name =
  Printf.printf "Testing graph %s\n" name;
  let _ = draw_dag dag name in
  test dag (Printf.sprintf "%s (dfs_v1)" name) Schedule.dfs_v1 ;
  test dag (Printf.sprintf "%s (dfs_v2)" name) Schedule.dfs_v2 ;
  test dag (Printf.sprintf "%s (bfs)" name) Schedule.bfs ;
  test dag (Printf.sprintf "%s (bfs + chk_all)" name) 
    (fun dag -> Checkpoint.chk_all dag (Schedule.bfs dag));
  test dag (Printf.sprintf "%s (bfs + chk_per)" name)
    (fun dag -> Checkpoint.chk_per dag (Schedule.bfs dag) 3.)

(** Binary tree of size [10] with weight [5.]. *)
let _ = 
  full_test (spec_to_dag (bintree_default 10 5.)) "ex1"

(** DAG extracted from the file [exdag.dag]. *)
let _ = 
  full_test (dag_from_file "exdag.dag") "ex2"

