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
      mat(delim: "[", <>)
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
      mat(delim: "{", <>)
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
      mat(<>)
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
      mat(delim: "|", <>)
      ]],
      {
        i(0),
      }
    ),
    { condition = tex.in_mathzone }
  ),
  s(
    { trig = "II3", snippetType = "autosnippet", priority = 2000 },
    fmta(
      [[
      mat(
        1,,;
        ,1,;
        ,,1;
      )
      ]],
      {}
    ),
    { condition = tex.in_mathzone }
  ),
  s(
    { trig = "II4", snippetType = "autosnippet", priority = 2000 },
    fmta(
      [[
      \begin{bmatrix}
        1 & & & \\
        & 1 & & \\
        & & 1 & \\
        & & & 1 \\
      \end{bmatrix}
      ]],
      {}
    ),
    { condition = tex.in_mathzone }
  ),
  s(
    { trig = "II5", snippetType = "autosnippet", priority = 2000 },
    fmta(
      [[
      \begin{bmatrix}
        1 & & & &\\
        & 1 & & &\\
        & & 1 & &\\
        & & & 1 &\\
        & & & & 1\\
      \end{bmatrix}
      ]],
      {}
    ),
    { condition = tex.in_mathzone }
  ),
  s(
    { trig = "II6", snippetType = "autosnippet", priority = 2000 },
    fmta(
      [[
      \begin{bmatrix}
        1 & & & & &\\
        & 1 & & & &\\
        & & 1 & & &\\
        & & & 1 & &\\
        & & & & 1 &\\
        & & & & & 1\\
      \end{bmatrix}
      ]],
      {}
    ),
    { condition = tex.in_mathzone }
  ),
}
