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
    return sn(nil, i(1, parent.snippet.env.SELECT_RAW))
  else -- If SELECT_RAW is empty, return a blank insert node
    return sn(nil, i(1))
  end
end

return {
  s(
    { trig = "map4", snippetType = "autosnippet", priority = 2000 },
    fmta(
      [[
    \mqty[
    <> & <> & <> & <> \\
    <> & <> & <> & <> \\
    <> & <> & <> & <> \\
    <> & <> & <> & <> \\
    ]
    ]],
      {
        i(1),
        i(2),
        i(3),
        i(4),
        i(5),
        i(6),
        i(7),
        i(8),
        i(9),
        i(10),
        i(11),
        i(12),
        i(13),
        i(14),
        i(15),
        i(0),
      }
    ),
    { condition = tex.in_mathzone }
  ),
}
