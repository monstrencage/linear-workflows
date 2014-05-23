all : 
	ocamlbuild -lib unix example.byte

opt : 
	ocamlbuild -lib unix example.native

clean :
	ocamlbuild -clean

doc :
	ocamlbuild -lib unix doc.docdir/index.html
