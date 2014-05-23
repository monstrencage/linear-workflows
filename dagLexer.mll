{ open DagParser }

let skip = [ ' ' '\r' '\t' ]
let digit = ['0'-'9']
let sep = [ '\n' ';' ]

rule token = parse
  | skip+        { token lexbuf }
  | "//"         { comment lexbuf }
  | digit+"."digit* as s { FL (float_of_string s) }
  | digit+ as n  { INT (int_of_string n) }
  | "->"         { ARROW }
  | sep+         { NEWLINE }
  | ','          { VIRG }
  | eof  { EOF}

and comment = parse
  | '\n' { NEWLINE }
  | eof  { EOF}
  | _    { comment lexbuf }
