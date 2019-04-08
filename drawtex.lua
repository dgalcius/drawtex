#!/usr/bin/env texlua

--[[
drawtex program. Author Deimantas Galcius deimantas(dot)galcius(at)gmail(dot)com
--]]


drawtex  = drawtex or { }
local version = "0.1"
drawtex.version = version
drawtex.self = "drawtex"

local _name = "drawtex"
--local exit = os.exit
local kpse = kpse
local kpse_version = kpse.version()
kpse.set_program_name("luatex")

local dvi = require("dvi")
local inspect  = require("inspect")
print("OK")

local filein = "sample2e.dvi"
local fhi = assert(io.open(filein, 'rb'))
local content = dvi.parse(fhi) -- get dvi file as lua table


local tex = {}
table.insert(tex, "\\input rawcmd.tex")
for _i, op in ipairs(content) do

   if op._opcode == "post" then
     break
   end

   if op._opcode == "pre" then
      table.insert(tex, "\\pre")
   end

   if op._opcode == "down" then
      table.insert(tex, "\\down{" .. op.size .. "}")
   end

   if op._opcode == "right" then
--      print(inspect(op))
--      os.exit(9)
      table.insert(tex, "\\right{" .. op.size .. "}")
   end

   if op._opcode == "x" then
--      print(inspect(op))
--      os.exit(9)
      table.insert(tex, "\\x{" .. op.size .. "}")
   end

   if op._opcode == "x0" then
--      print(inspect(op))
--      os.exit(9)
      table.insert(tex, "\\xzero")
   end

   if op._opcode == "y" then
--      print(inspect(op))
--      os.exit(9)
      table.insert(tex, "\\y{" .. op.size .. "}")
   end

   if op._opcode == "y0" then
--      print(inspect(op))
--      os.exit(9)
      table.insert(tex, "\\yzero")
   end
   
   if op._opcode == "w" then
--      print(inspect(op))
--      os.exit(9)
      table.insert(tex, "\\w{" .. op.size .. "}")
   end

   if op._opcode == "w0" then
--      print(inspect(op))
--      os.exit(9)
      table.insert(tex, "\\wzero")
   end

   if op._opcode == "push" then
--      print(inspect(op))
--      os.exit(9)
      table.insert(tex, "\\push")
   end

   if op._opcode == "pop" then
--      print(inspect(op))
--      os.exit(9)
      table.insert(tex, "\\pop")
   end

   if op._opcode == "bop" then
--      print(inspect(op))
--      os.exit(9)
      table.insert(tex, "\\bop")
   end

   if op._opcode == "eop" then
--      print(inspect(op))
--      os.exit(9)
      table.insert(tex, "\\eop")
   end

   if op._opcode == "setchar" then
--      print(inspect(op))
--      os.exit(9)
      table.insert(tex, "\\setchari{" .. op.index .. "}% " .. op.zzz_char )
   end

   if op._opcode == "fntdef" then
--      print(inspect(op))
--      os.exit(9)
      local s = "\\fntdef{" .. op.num .. "}{" .. op.fontname .. "}"
      s = s .. "{" .. op.design_size .. "}{" .. op.scale .. "}"
      table.insert(tex, s)
   end

   if op._opcode == "fntnum" then
--      print(inspect(op))
--      os.exit(9)
      table.insert(tex, "\\fntnum{" .. op.index .. "}")
   end

   
end

table.insert(tex, "\\bye")
for _i, _j in ipairs(tex) do
   print(_j)
end
-- print(inspect(content))
