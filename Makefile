
default: 00_01.pdf

%.dvi: %.tex 
	latex -recorder $<

%.ps: %.dvi .FORCE
	dvips -j0 $<

%.pdf: %.ps
	ps2pdf $<

diff.tex: 00.tex 01.tex .FORCE
	diff -a   --old-group-format="D %<" \
--new-group-format="I %>" \
--changed-group-format="\\DIFFOLD%c'\012'  %<\\DIFFEND%c'\012'\\DIFFNEW%c'\012'  %>\\DIFFEND%c'\012'" \
--unchanged-group-format="%<" 00.tex 01.tex >$@ || true

%.diff.tex: %.old %.new
	diff -a   --old-group-format="D %<" \
--new-group-format="I %>" \
--changed-group-format="\\DIFFOLD%c'\012'  %<\\DIFFEND%c'\012'\\DIFFNEW%c'\012'  %>\\DIFFEND%c'\012'" \
--unchanged-group-format="%<" $^ >$@ || true

diff2.tex: 00.tex 01.tex .FORCE
	diff -a   --old-group-format="D %<" \
--new-group-format="I %>" \
--changed-group-format="\\DIFFOLD%    ************%c'\012'%<\\DIFFEND%    ############%c'\012'" \
--unchanged-group-format="%<" 00.tex 01.tex >$@ || true

sample2e.tex:
	cpx $@

%.dt: %.dvi
	dv2dt $< $@

%.raw: %.dt
	ruby dt2rawtex.rb $< >$@

%.raw.dvi: %.raw .FORCE
	etex -recorder -jobname=$< $<

%.dfc.pdf: %.dvi %.raw.dvi
	dfc $^
	mv out.pdf $@


1: sample2e.tex sample2e.dvi sample2e.dt sample2e.raw sample2e.raw.dvi sample2e.dfc.pdf
	cp sample2e.raw 3.old

2: 02.dvi 02.dt 02.raw 02.raw.dvi 02.dfc.pdf
	cp 02.raw 3.new

3: 3.diff.tex



clean:
	rm -f sample2e.*
	rm -f 3.*

.FORCE:
