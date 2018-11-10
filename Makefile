

%.dvi: %.tex
	latex -recorder $<

%.dt: %.dvi
	dv2dt $< $@

%.rawtex: %.dt
	ruby dt2rawtex.rb $< >$@

a.tex: 01.rawtex 02.rawtex
	diff -a   --old-group-format="D %<" \
--new-group-format="I %>" \
--changed-group-format="\\DIFFOLD%    ************%c'\012'%<\\DIFFEND%    ############%c'\012'" \
--unchanged-group-format="%<" $^ >$@ || true

b.tex: 01.rawtex 02.rawtex
	diff -a   --old-group-format="D %<" \
--new-group-format="I %>" \
--changed-group-format="\\DIFFNEW%    ************%c'\012'%>\\DIFFEND%    ############%c'\012'" \
--unchanged-group-format="%<" $^ >$@ || true

out.dvi: a.dvi b.dvi
	dvimerge $^ 1 100
	mv merged.dvi ab.dvi
	dvitodvi -i ab.dvi -o out.dvi '2:0+1(14cm,0)'

out.ps:
	dvips  -tlandscape -ta3 out

%.dvi: %.tex
	etex $<

%.ps: %.dvi
	dvips -j0 $<

%.pdf: %.ps
	ps2pdf $< $@
