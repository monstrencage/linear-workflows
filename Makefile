OCAMLC=ocamlc
OCAMLOPT=ocamlopt
OCAMLYACC=ocamlyacc
OCAMLLEX=ocamllex
OCAMLDEP=ocamldep

OBJS=def.cmi def.cmo example.cmo
OPTOBJS=def.cmi def.cmx example.cmi example.cmx

CMOBJS=def.cmo example.cmo
CMOPTOBJS=def.cmx example.cmx

all : dep comp

opt: dep optcomb

comp : $(OBJS)
	$(OCAMLC) -o comp unix.cma $(CMOBJS)

optcomb: $(OPTOBJS)
	$(OCAMLOPT) -o comp unix.cmxa $(CMOPTOBJS)

# Common rules
.SUFFIXES: .ml .mli .cmo .cmi .cmx .mly .mll

.ml.cmo:
	$(OCAMLC) $(OCAMLFLAGS) -c $<

.mli.cmi:
	$(OCAMLC) $(OCAMLFLAGS) -c $<

.ml.cmx:
	$(OCAMLOPT) $(OCAMLFLAGS) -c $<

.mly.ml:
	$(OCAMLYACC) $<

.mly.mli:
	$(OCAMLYACC) $<
.mll.ml:
	$(OCAMLLEX) $<

dep:
	$(OCAMLDEP) *.ml *.mli > .dep

clean:
	rm -f *.o *.cmx *.cmo *.cmi *.out *.pdf *.toc *.blg *.bbl *.lot graph_parser.ml graph_parser.mli graph_lexer.ml

include .dep
