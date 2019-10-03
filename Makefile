
default: out.pdf

%.dvi: %.tex
	latex -recorder $<

%.dt: %.dvi
	dv2dt $< $@

%.rawtex: %.dt
	ruby dt2rawtex.rb $< >$@

%.rawtex.pdf: %.rawtex
	etex --jobname=$*.rawtex $<
	dvips -j0 -o $*.rawtex.ps $*.rawtex.dvi
	ps2pdf $*.rawtex.ps $*.rawtex.pdf

a.tex: 01.rawtex 02.rawtex
	diff -a   \
--old-group-format="\\DELETEOLD%c'\012'%<\\DELETEEND%c'\012'" \
--new-group-format="\\INSERTOLD%c'\012'%>\INSERTEND%c'\012'" \
--changed-group-format="\\DIFFOLD%    ************%c'\012'%<\\DIFFEND%    ############%c'\012'" \
--unchanged-group-format="%<" $^ >$@ || true

#--old-group-format="\\DELETENEW%c'\012'%<\\DELETEEND%c'\012'" \
#--new-group-format="\\INSERTNEW%c'\012'%>\INSERTEND%c'\012'" \

a1.tex: 02.rawtex 01.rawtex
	diff -a \
--changed-group-format="\\REDOLD%c'\012'%<\\ENDREDOLD%c'\012'\\REDNEW%c'\012'%>\\ENDREDNEW%c'\012'" \
--unchanged-group-format="%<" $^ >$@ || true

b.tex: 01.rawtex 02.rawtex
	diff -a \
--old-group-format="\\DELETENEW%c'\012'%<\\DELETEEND%c'\012'" \
--new-group-format="\\INSERTNEW%c'\012'%>\INSERTEND%c'\012'" \
--changed-group-format="\\DIFFNEW%    ************%c'\012'%>\\DIFFEND%    ############%c'\012'" \
--unchanged-group-format="%<" $^ >$@ || true

out.pdf: a.dvi b.dvi
	dfc --side-by-side $^

a.dvi: a.tex
	etex $<

a1.dvi: a1.tex
	etex $<

b.dvi: b.tex
	etex $<

%.ps: %.dvi
	dvips -j0 $<

%.pdf: %.ps
	ps2pdf $< $@


clean:
	rm -f *.aux *.dvi *.fls *.log *.ps *.pdf *.rawtex*
	rm -f a.tex b.tex
