module Id = struct
  type t = int
  let compare = compare
end

module IMap = Map.Make(Id)

module ISet = Set.Make(Id)

type task = {
  w : float;	(* work *)
  c : float;		(* checkpoint time *)
  r : float;		(* recovery time *)
}

type dag = {
  size : int;
  tasks : task IMap.t;
  succ : ISet.t IMap.t;
  prev : ISet.t IMap.t;
  sources : ISet.t;
  weightsucc : int -> float;
}

type spec = task list * (int * int) list

type linearwf = {
  order : int IMap.t;
  sched : int IMap.t;
}

type param = {
  lambda : float;
  d : float;
}
