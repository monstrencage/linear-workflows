%{
(** Parser for specifications of DAGs of tasks *)
  open Defs
%}

%token ARROW EOF NEWLINE VIRG
%token<int> INT
%token<float> FL

%type<Defs.spec> specs
%start specs

%%
specs:
 | task NEWLINE specs { let (ts,dp) = $3 in ($1::ts,dp) }
 | deps { [],$1 }

task:
 | FL VIRG FL VIRG FL { {w=$1;c=$3;r=$5} }
 
deps:
 | EOF { [] }
 | INT ARROW INT NEWLINE deps { ($1,$3)::$5 }
 | INT ARROW INT { ($1,$3)::[] }
