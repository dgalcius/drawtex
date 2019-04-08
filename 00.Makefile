
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

%.diff: %.old %.new
	diff -a   --old-group-format="D %<" \
--new-group-format="I %>" \
--changed-group-format="\\DIFFOLD%    ************%c'\012'%<\\DIFFEND%    ############%c'\012'" \
--unchanged-group-format="%<" $^ >$@ || true

diff2.tex: 00.tex 01.tex .FORCE
	diff -a   --old-group-format="D %<" \
--new-group-format="I %>" \
--changed-group-format="\\DIFFOLD%    ************%c'\012'%<\\DIFFEND%    ############%c'\012'" \
--unchanged-group-format="%<" 00.tex 01.tex >$@ || true

diff4: 00.tex 01.tex .FORCE
	diff -a   --old-group-format="D %<" \
--new-group-format="I %>" \
--changed-group-format="\\DIFFNEW%    ************%c'\012'%>\\DIFFEND%    ############%c'\012'" \
--unchanged-group-format="%<" 00.tex 01.tex >4.tex || true

#--changed-group-format="\\DIFFOLD%c'\012'  %<\\DIFFEND%c'\012'"

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

3: 3.diff
	cp 3.diff 3.tex
	etex 3
	dvips 3
	ps2pdf 3.ps

4: diff4
	etex 4
	dvips 4
	ps2pdf 4.ps

5: 3.dvi 4.dvi
# dvidvi
	dvitodvi -i 3.dvi -o 5.dvi '2:0+1(14cm,0)'
	dvips -ta3 -tlandscape 5
	ps2pdf 5.ps

clean:
	rm -f sample2e.*
	rm -f 3.*

.FORCE:
