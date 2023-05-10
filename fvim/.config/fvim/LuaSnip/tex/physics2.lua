local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local d = ls.dynamic_node
local fmt = require("luasnip.extras.fmt").fmt
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
    { trig = "bk", snippetType = "autosnippet", priority = 1000 },
    fmta("\\braket<< <> >>", {
      i(1),
    }),
    { condition = tex.in_mathzone }
  ),
  s(
    { trig = "kb", snippetType = "autosnippet", priority = 1000 },
    fmta("\\ketbra| <> |", {
      i(1),
    }),
    { condition = tex.in_mathzone }
  ),
  s(
    { trig = "\\pab", snippetType = "autosnippet", priority = 1000 },
    fmta("\\ab( <> )", {
      i(1),
    }),
    { condition = tex.in_mathzone }
  ),
  s(
    { trig = "\\Bab", snippetType = "autosnippet", priority = 1000 },
    fmta("\\ab\\{ <> \\}", {
      i(1),
    }),
    { condition = tex.in_mathzone }
  ),
  s(
    { trig = "\\bab", snippetType = "autosnippet", priority = 1000 },
    fmta("\\ab[ <> ]", {
      i(1),
    }),
    { condition = tex.in_mathzone }
  ),
  s(
    { trig = "\\forallb", snippetType = "autosnippet", priority = 1000 },
    fmta("\\ab<< <> >>", {
      i(1),
    }),
    { condition = tex.in_mathzone }
  ),
  s(
    { trig = "\\vab", snippetType = "autosnippet", priority = 1000 },
    fmta("\\ab| <> |", {
      i(1),
    }),
    { condition = tex.in_mathzone }
  ),
  s(
    { trig = "\\Vab", snippetType = "autosnippet", priority = 1000 },
    fmta("\\ab\\| <> \\|", {
      i(1),
    }),
    { condition = tex.in_mathzone }
  ),
}
