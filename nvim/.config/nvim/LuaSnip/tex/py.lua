local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local d = ls.dynamic_node
local fmta = require("luasnip.extras.fmt").fmta
local rep = require("luasnip.extras").rep
local line_begin = require("luasnip.extras.expand_conditions").line_begin
local tex = require("util.latex")
local get_visual = function(args, parent)
  if #parent.snippet.env.SELECT_RAW > 0 then
    return sn(nil, t(parent.snippet.env.SELECT_RAW))
  else -- If SELECT_RAW is empty, return a blank insert node
    return sn(nil, i(1))
  end
end

return {
  s(
    { trig = "sym", wordTrig = false, snippetType = "autosnippet" },
    fmta("sympy <> sympy", {
      i(0),
    }),
    { condition = tex.in_mathzone }
  ),
  s(
    { trig = "sym", wordTrig = false, snippetType = "autosnippet", priority = 2000 },
    fmta("sympy <> sympy", {
      d(1, get_visual),
    }),
    { condition = tex.in_mathzone }
  ),
  s( -- This one evaluates anything inside the simpy block
    { trig = "sympy.*sympys", regTrig = true, desc = "Sympy block evaluator", snippetType = "autosnippet" },
    d(1, function(_, parent)
      local to_eval = string.gsub(parent.trigger, "^sympy(.*)sympys", "%1")
      to_eval = string.gsub(to_eval, "^%s+(.*)%s+$", "%1")

      local Job = require("plenary.job")

      local sympy_script = string.format(
        [[
from latex2sympy2 import latex2latex
import re
origin = r'%s'
# remove white space
standard = re.sub(r"\\d", "d", origin)
latex = latex2latex(standard)
output = origin + " = " + latex
print(output)
            ]],
        to_eval
      )

      sympy_script = string.gsub(sympy_script, "^[\t%s]+", "")
      local result = ""

      Job:new({
        command = "python3",
        args = {
          "-c",
          sympy_script,
        },
        on_exit = function(j)
          result = j:result()
        end,
      }):sync()

      return sn(nil, t(result))
    end)
  ),
  s( -- This one evaluates anything inside the simpy block
    { trig = "sympy.*sympy ", regTrig = true, desc = "Sympy block evaluator", snippetType = "autosnippet" },
    d(1, function(_, parent)
      -- Gets the part of the block we actually want, and replaces spaces
      -- at the beginning and at the end
      local to_eval = string.gsub(parent.trigger, "^sympy(.*)sympy", "%1")
      to_eval = string.gsub(to_eval, "^%s+(.*)%s+$", "%1")
      local pattern = { "\\ab" }
      local repl = { "" }
      for i = 1, #pattern do
        to_eval = string.gsub(to_eval, pattern[i], repl[i])
      end

      local Job = require("plenary.job")

      local sympy_script = string.format(
        [[
from sympy import *
from latex2sympy2 import latex2sympy, latex2latex
import re
origin = r'%s'
origin = re.sub(r"\\d", "d", origin)
latex = latex2latex(origin)
print(latex)
            ]],
        to_eval
      )

      sympy_script = string.gsub(sympy_script, "^[\t%s]+", "")
      local result = ""

      Job:new({
        command = "python3",
        args = {
          "-c",
          sympy_script,
        },
        on_exit = function(j)
          result = j:result()
        end,
      }):sync()

      return sn(nil, t(result))
    end)
  ),
  s(
    { trig = "qcircuit", wordTrig = false },
    fmta("QCircuit <> QCircuit", {
      i(1),
    }),
    { condition = tex.in_text }
  ),
  s(
    { trig = "qcircuit", wordTrig = false, priority = 2000 },
    fmta("QCircuit <> QCircuit", {
      d(1, get_visual),
    }),
    { condition = tex.in_text }
  ),
  s( -- This one evaluates anything inside the simpy block
    { trig = "QCircuit.*QCircuit ", regTrig = true, desc = "QCircuit block evaluator", snippetType = "autosnippet" },
    d(1, function(_, parent)
      -- Gets the part of the block we actually want, and replaces spaces
      -- at the beginning and at the end
      local to_eval = string.gsub(parent.trigger, "^QCircuit(.*)QCircuit ", "%1")
      to_eval = string.gsub(to_eval, "^%s+(.*)%s+$", "%1")

      -- Replace lash with rash for to_evil
      local pattern = {
        "ts",
        "I_?(%d)",
        "C(%w)",
        "dagger",
        "\\ket{0}",
        "\\ket{1}",
        "\\ket{%+}",
        "\\ket{%-}",
        "\\ket{%+i}",
        "\\ket{i}",
        "\\ket{%-i}",
        "\\bra{0}",
        "\\bra{1}",
        "\\bra{%+}",
        "\\bra{%-}",
        "\\bra{%+i}",
        "\\bra{i}",
        "\\bra{%-i}",
      }
      local repl = {
        "TensorProduct",
        "eye(%1)",
        "controlled_gate_12(%1)",
        ".conjugate().transpose()",
        "ket0",
        "ket1",
        "ketp",
        "ketm",
        "ketpi",
        "ketpi",
        "ketmi",
        "bra0",
        "bra1",
        "brap",
        "bram",
        "brapi",
        "brapi",
        "brami",
      }
      for i = 1, #pattern do
        to_eval = string.gsub(to_eval, pattern[i], repl[i])
      end
      print(to_eval)

      local Job = require("plenary.job")

      local sympy_script = string.format(
        [[
from sympy import *
from sympy.physics.quantum import *
def controlled_gate_12(gate):
    return TensorProduct(Matrix([ [1, 0], [0, 0] ]), eye(2))+TensorProduct(Matrix([ [0, 0], [0, 1] ]), gate)
def controlled_gate_21(gate):
    return TensorProduct(eye(2), Matrix([ [1, 0], [0, 0] ]))+TensorProduct(gate, Matrix([ [0, 0], [0, 1] ]))
H = Matrix([ [1, 1], [1, -1] ]) / sqrt(2)
X = Matrix([ [0, 1], [1, 0] ])
Y = Matrix([ [0, -I], [I, 0] ])
Z = Matrix([ [1, 0], [0, -1] ])
e1 = Matrix([ [1], [0], [0], [0] ])
e2 = Matrix([ [0], [1], [0], [0] ])
e3 = Matrix([ [0], [0], [1], [0] ])
e4 = Matrix([ [0], [0], [0], [1] ])
ket0 = Matrix([ [1], [0] ])
ket1 = Matrix([ [0], [1] ])
ketp = Matrix([ [1], [1] ]) / sqrt(2)
ketm = Matrix([ [1], [-1] ]) / sqrt(2)
ketpi = Matrix([ [1], [I] ]) / sqrt(2)
ketmi = Matrix([ [1], [-I] ]) / sqrt(2)
bra0 = Matrix([ [1, 0] ])
bra1 = Matrix([ [0, 1] ])
brap = Matrix([ [1, 1] ]) / sqrt(2)
bram = Matrix([ [1, -1] ]) / sqrt(2)
brapi = Matrix([ [1, -I] ]) / sqrt(2)
brami = Matrix([ [1, I] ]) / sqrt(2)
out00 = e1*e1.transpose()
out01 = e2*e2.transpose()
out10 = e3*e3.transpose()
out11 = e4*e4.transpose()
%s
output = latex(res)
print(output)
            ]],
        to_eval
      )

      sympy_script = string.gsub(sympy_script, "^[\t%s]+", "")
      local result = ""

      Job:new({
        command = "python3",
        args = {
          "-c",
          sympy_script,
        },
        on_exit = function(j)
          result = j:result()
        end,
      }):sync()

      return sn(nil, t(result))
    end)
  ),
  s(
    { trig = "exd", wordTrig = false, snippetType = "autosnippet" },
    fmta("expand <> expand", {
      i(1),
    }),
    { condition = tex.in_mathzone }
  ),
  s( -- This one evaluates anything inside the simpy block
    { trig = "expand.*expand ", regTrig = true, desc = "expand block evaluator", snippetType = "autosnippet" },
    d(1, function(_, parent)
      -- Gets the part of the block we actually want, and replaces spaces
      -- at the beginning and at the end
      local to_eval = string.gsub(parent.trigger, "^expand(.*)expand ", "%1")
      to_eval = string.gsub(to_eval, "^%s+(.*)%s+$", "%1")
      local pattern = { "\\ab" }
      local repl = { "" }
      for i = 1, #pattern do
        to_eval = string.gsub(to_eval, pattern[i], repl[i])
      end

      local Job = require("plenary.job")

      local sympy_script = string.format(
        [[
from sympy import *
from latex2sympy2 import latex2sympy, latex2latex
x, y = symbols('x y')
theta = symbols('theta')
origin = r'%s'
expand = latex2sympy(origin).expand()
print(latex(expand))
            ]],
        to_eval
      )

      sympy_script = string.gsub(sympy_script, "^[\t%s]+", "")
      local result = ""

      Job:new({
        command = "python3",
        args = {
          "-c",
          sympy_script,
        },
        on_exit = function(j)
          result = j:result()
        end,
      }):sync()

      return sn(nil, t(result))
    end)
  ),
}
