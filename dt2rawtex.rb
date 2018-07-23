require 'rubygems'
require 'fileutils'

filein = ARGV[0]

f = File.open(filein, 'r')
lines = f.readlines

tex = Array.new()

tex << "\\input rawcmd"
lines.each do |line|
  next if line =~ /^pre/
  tex << "\\down{" + $1 + "}"   if line =~ /^d[0-9]\s(.*)/
  tex << "\\right{" + $1 + "}"  if line =~ /^r[0-9]\s(.*)/
  tex << "\\w{" + $1 + "}"      if line =~ /^w[1-4]\s(.*)/
  tex << "\\x{" + $1 + "}"      if line =~ /^x[1-4]\s(.*)/
  tex << "\\y{" + $1 + "}"      if line =~ /^y[1-4]\s(.*)/
  tex << "\\z{" + $1 + "}"      if line =~ /^z[1-4]\s(.*)/
  tex << "\\wzero"              if line =~ /^w0/
  tex << "\\xzero"              if line =~ /^x0/
  tex << "\\yzero"              if line =~ /^y0/
  tex << "\\zzero"              if line =~ /^z0/
  tex << "\\push"               if line =~ /^\[/
  tex << "\\pop"                if line =~ /^\]/
  tex << "\\putrule{"+$1+"}{"+$2+"}" if line =~ /^pr\s(.*?)\s(.*?)$/

  tex << "\%\% Page "+$1+"\n\\bop"  if line =~ /^bop\s(.*?)\s/
  tex << "\\eop"                   if line =~ /^eop/

  if line =~ /^\((.*)\)/
    i = $1
    ii = i.clone
    ii.gsub!(/ /){"\\char32"}
    ii.gsub!(/#/){"\\char35"}
    ii.gsub!(/\$/){"\\char36"}
    ii.gsub!(/%/){"\\char37"}
    ii.gsub!(/&/){"\\char38 "}
    ii.gsub!(/{/){"\\char123 "}
    ii.gsub!(/\\\(/){"("}
    ii.gsub!(/\\\)/){")"}
    ii.gsub!(/\\\\/){"\\char92 "}
    ii.gsub!(/\\\"/){"\\char34 "}
    
    tex << "\\text{"+ii+"}"
  end

  if line =~ /^\\(.*)/
    i = $1
    ii = i.to_i(16).to_s(10)
    tex << "\\text{\\char" +ii+"}" 
  end
  
  tex << "\\special{"+$1+"}"    if line =~ /^special[1-4] [1-9]* '(.*)'/

  tex << "\\fontdef{"+$1+"}{"+$4+"}{"+$2+"}{"+$3+"}"    if line =~ /^fd[1-4]\s(.*)\s.*\s(.*)\s(.*)\s.*\s.*\s'.*'\s'(.*)'/
  tex << "\\fontsel{"+$1+"}"    if line =~ /^fn(.*)/

  break if line =~ /^post/
  
end

tex << "\\bye"

puts tex

