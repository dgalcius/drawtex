
default: 00_01.pdf

%.dvi: %.tex .FORCE
	etex -recorder $<

%.ps: %.dvi .FORCE
	dvips -j0 $<

%.pdf: %.ps
	ps2pdf $<

diff.tex: 00.tex 01.tex .FORCE
	diff -a   --old-group-format="D %<" \
--new-group-format="I %>" \
--changed-group-format="\\DIFFOLD%c'\012'  %<\\DIFFEND%c'\012'\\DIFFNEW%c'\012'  %>\\DIFFEND%c'\012'" \
--unchanged-group-format="%<" 00.tex 01.tex >$@ || true

diff2.tex: 00.tex 01.tex .FORCE
	diff -a   --old-group-format="D %<" \
--new-group-format="I %>" \
--changed-group-format="\\DIFFOLD%    ************%c'\012'%<\\DIFFEND%    ############%c'\012'" \
--unchanged-group-format="%<" 00.tex 01.tex >$@ || true

.FORCE:
