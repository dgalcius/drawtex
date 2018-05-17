require 'rubygems'
require 'fileutils'

#filein = ARG[0]
filein = 'test02.dt'
fileout = 'rawtex01.tex'

f = File.open(filein, 'r')
lines = f.readlines

tex = Array.new()

tex << "\\input rawcmd"
lines.each do |line|
  next if line =~ /^pre/
  tex << "\\down{" + $1 + "}"   if line =~ /^d[0-9]\s(.*)/
  tex << "\\right{" + $1 + "}"  if line =~ /^r[0-9]\s(.*)/
  tex << "\\w{" + $1 + "}"      if line =~ /^w[1-4]\s(.*)/
  tex << "\\wzero"              if line =~ /^w0/
  tex << "\\push"               if line =~ /^\[/
  tex << "\\pop"                if line =~ /^\]/

  tex << "\\bop"                if line =~ /^bop/
  tex << "\\eop"                if line =~ /^eop/

  tex << "\\text{"+$1+"}"       if line =~ /^\((.*)\)/
  tex << "\\special{"+$1+"}"    if line =~ /^special[1-4] [1-9]* '(.*)'/

  tex << "\\fontdef{"+$1+"}{"+$4+"}{"+$2+"}{"+$3+"}"    if line =~ /^fd[1-4]\s(.*)\s.*\s(.*)\s(.*)\s0\s5\s'.*'\s'(.*)'/
  tex << "\\fontsel{"+$1+"}"    if line =~ /^fn(.*)/

  break if line =~ /^post/
  
end

tex << "\\bye"

puts tex

