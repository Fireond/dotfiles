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
    return sn(nil, i(1, parent.snippet.env.SELECT_RAW))
  else -- If SELECT_RAW is empty, return a blank insert node
    return sn(nil, i(1))
  end
end

return {
  s(
    { trig = "bmat", snippetType = "autosnippet" },
    fmta(
      [[
      \begin{bmatrix}
        <>
      \end{bmatrix}
      ]],
      {
        i(0),
      }
    ),
    { condition = tex.in_mathzone }
  ),
  s(
    { trig = "Bmat", snippetType = "autosnippet" },
    fmta(
      [[
      \begin{Bmatrix}
        <>
      \end{Bmatrix}
      ]],
      {
        i(0),
      }
    ),
    { condition = tex.in_mathzone }
  ),
  s(
    { trig = "pmat", snippetType = "autosnippet" },
    fmta(
      [[
      \begin{pmatrix}
        <>
      \end{pmatrix}
      ]],
      {
        i(0),
      }
    ),
    { condition = tex.in_mathzone }
  ),
  s(
    { trig = "Vmat", snippetType = "autosnippet" },
    fmta(
      [[
      \begin{Vmatrix}
        <>
      \end{Vmatrix}
      ]],
      {
        i(0),
      }
    ),
    { condition = tex.in_mathzone }
  ),
  s(
    { trig = "pmat", snippetType = "autosnippet" },
    fmta(
      [[
      \pmat{<>}
      ]],
      {
        i(0),
      }
    ),
    { condition = tex.in_mathzone }
  ),
  s(
    { trig = "Bmat", snippetType = "autosnippet" },
    fmta(
      [[
      \Bmat{<>}
      ]],
      {
        i(0),
      }
    ),
    { condition = tex.in_mathzone }
  ),
  s(
    { trig = "vmat", snippetType = "autosnippet" },
    fmta(
      [[
      \vmat{<>}
      ]],
      {
        i(0),
      }
    ),
    { condition = tex.in_mathzone }
  ),
  s(
    { trig = "Vmat", snippetType = "autosnippet" },
    fmta(
      [[
      \Vmat{<>}
      ]],
      {
        i(0),
      }
    ),
    { condition = tex.in_mathzone }
  ),
  s(
    { trig = "pma(%a)", regTrig = true, wordTrig = false, snippetType = "autosnippet" },
    fmta("\\pmat<>{<>}", {
      f(function(_, snip)
        return snip.captures[1]
      end),
      i(0),
    }),
    { condition = tex.in_mathzone }
  ),
}
