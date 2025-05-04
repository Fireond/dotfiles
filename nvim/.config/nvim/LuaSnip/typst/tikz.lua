local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local f = ls.function_node
local i = ls.insert_node
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
  s({ trig = "vsp", snippetType = "autosnippet" }, {
    t("\\vspace{\\baselineskip}"),
  }),
  s(
    { trig = "bti", snippetType = "autosnippet" },
    fmta(
      [[
      \begin{tikzpicture}<>
        <>
      \end{tikzpicture}
      ]],
      {
        c(1, { t("[overlay,remember picture,>=stealth,nodes={align=left,inner ysep=1pt},<-]"), t("") }),
        i(0),
      }
    ),
    { condition = line_begin }
  ),
  s(
    { trig = "tm", snippetType = "autosnippet" },
    fmta(
      [[
      \tikzmarknode{<>}{<>}
      ]],
      {
        i(1, "markname"),
        i(0),
      }
    ),
    { condition = tex.in_tikz }
  ),
  s(
    { trig = "tm", snippetType = "autosnippet", priority = 2000 },
    fmta(
      [[
      \tikzmarknode{<>}{<>}
      ]],
      {
        i(1, "markname"),
        d(2, get_visual),
      }
    ),
    { condition = tex.in_mathzone }
  ),
  s(
    { trig = "lu", snippetType = "autosnippet", dscr = "Left up annotate" },
    fmta(
      [[
      \path (<>.north) ++ (0,1em) node[anchor=south east,color=<>!67] (<>_node){<>};
      \draw [color=<>!57](<>.north) |- ([xshift=-0.3ex,color=<>]<>_node.south west);
      ]],
      {
        i(1, "markname"),
        i(2, "color"),
        rep(1),
        i(3, "text"),
        rep(2),
        rep(1),
        rep(2),
        rep(1),
      }
    ),
    { condition = tex.in_tikz }
  ),
  s(
    { trig = "rd", snippetType = "autosnippet", dscr = "Right down annotate" },
    fmta(
      [[
      \path (<>.south) ++ (0,-0.8em) node[anchor=north west,color=<>!67] (<>_node){<>};
      \draw [color=<>!57](<>.south) |- ([xshift=-0.3ex,color=<>]<>_node.south east);
      ]],
      {
        i(1, "markname"),
        i(2, "color"),
        rep(1),
        i(3, "text"),
        rep(2),
        rep(1),
        rep(2),
        rep(1),
      }
    ),
    { condition = tex.in_tikz }
  ),
  s(
    { trig = "ld", snippetType = "autosnippet", dscr = "Left down annotate" },
    fmta(
      [[
      \path (<>.south) ++ (0,-0.8em) node[anchor=north east,color=<>!67] (<>_node){<>};
      \draw [color=<>!57](<>.south) |- ([xshift=-0.3ex,color=<>]<>_node.south west);
      ]],
      {
        i(1, "markname"),
        i(2, "color"),
        rep(1),
        i(3, "text"),
        rep(2),
        rep(1),
        rep(2),
        rep(1),
      }
    ),
    { condition = tex.in_tikz }
  ),
  s(
    { trig = "hl", snippetType = "autosnippet" },
    fmta(
      [[
      \hlmath{<>}{<>}
      ]],
      {
        i(1, "red"),
        i(2),
      }
    ),
    { condition = tex.in_mathzone }
  ),
  s(
    { trig = "hl", snippetType = "autosnippet", priority = 2000 },
    fmta(
      [[
      \hlmath{<>}{<>}
      ]],
      {
        i(1, "red"),
        d(2, get_visual),
      }
    ),
    { condition = tex.in_mathzone }
  ),
  s(
    { trig = "hl", snippetType = "autosnippet" },
    fmta(
      [[
      \hltext{<>}{<>}
      ]],
      {
        i(1, "red"),
        i(2),
      }
    ),
    { condition = tex.in_text }
  ),
  s(
    { trig = "hl", snippetType = "autosnippet", priority = 2000 },
    fmta(
      [[
      \hltext{<>}{<>}
      ]],
      {
        i(1, "red"),
        d(2, get_visual),
      }
    ),
    { condition = tex.in_text }
  ),
}
