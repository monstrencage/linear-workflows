type task = {id : int; w : float; c : float; r : float;}

type edge = { id1 : int; id2 : int; }

type dag = { tabTask : task array; tabParents : int list array; tabChildren : int list array; }

type linearWorkflow = (int * bool) array
