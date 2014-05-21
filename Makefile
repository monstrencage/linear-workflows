all : 
	ocamlbuild example.byte

opt : 
	ocamlbuild example.native

clean :
	ocamlbuild -clean
