all : 
	ocamlbuild example.byte

opt : 
	ocamlbuild example.native

clean :
	ocamlbuild -clean

doc :
	ocamlbuild doc.docdir/index.html
