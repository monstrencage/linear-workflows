type 'a queue = int * 'a list * int * 'a list

type 'a t = E | R of 'a queue ref

let return l= 
  let rec aux acc = function
    | [] -> acc
    | e::l -> aux (e::acc) l
  in
  aux [] l

let balance = function
  | E -> E
  | R q -> 
    begin
      match (!q) with
      | (i,l,j,m) when i<j -> (q:=(i+j,l@(return m),0,[]);R (ref (!q)))
      | _ -> R (ref (!q))
    end

exception Empty

let empty = E
  
let pop = function
  | E -> raise Empty
  | R q -> 
    begin 
      match !q with
      | (_,[],_,[]) -> raise Empty
      | (i,t::l,j,m) when i-1 < j -> 
	(let l' = l@return m in
	 q:=(i+j,t::l',0,[]);
	 (t,R(ref (i-1+j,l',0,[]))))
      | (i,t::l,j,m) -> 
	(t,R(ref (i-1,l,j,m)))
      | _ -> failwith "not supposed to happend"
    end

let push x = function
  | E -> R(ref (1,[x],0,[]))
  | R q ->
    begin
      match !q with
      | (i,l,j,m) when i < j+1 ->
	(let l' = l@return m in 
	 q:=(i+j,l',0,[]);
	 R (ref (i+j,l',1,[x])))
      | (i,l,j,m) ->
	R (ref (i,l,j+1,x::m))
    end

let is_empty = function
  | E -> true
  | R q ->
    begin
      match !q with
      | (0,[],0,[]) -> true
      | _ -> false
    end

