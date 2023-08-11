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
    { trig = "ii", snippetType = "autosnippet" },
    fmta(
      [[
      \(<>\)
      ]],
      {
        i(1),
      }
    ),
    { condition = tex.in_text }
  ),
  s(
    { trig = "dd", snippetType = "autosnippet" },
    fmta(
      [[
      \[
        <>
      .\]
      ]],
      {
        i(1),
      }
    ),
    { condition = tex.in_text }
  ),
  s(
    { trig = "bad", snippetType = "autosnippet" },
    fmta(
      [[
      \begin{adjustbox}{width=0.<>\textwidth}
        <>
      \end{adjustbox}
      ]],
      {
        i(1, "8"),
        i(0),
      }
    ),
    { condition = line_begin }
  ),
  s(
    { trig = "bp", snippetType = "autosnippet" },
    fmta(
      [[
      \begin{homeworkProblem}[<>]
        <>
      \end{homeworkProblem}
      ]],
      {
        i(1),
        i(0),
      }
    ),
    { condition = line_begin }
  ),
  s(
    { trig = "bf", snippetType = "autosnippet" },
    fmta(
      [[
      \begin{proof}
        <>
      \end{proof}
      ]],
      {
        i(0),
      }
    ),
    { condition = line_begin }
  ),
  s(
    { trig = "bep", snippetType = "autosnippet" },
    fmta(
      [[
      \begin{problem}[<>]
        <>
      \end{problem}
      ]],
      {
        i(1),
        i(0),
      }
    ),
    { condition = line_begin }
  ),
  s(
    { trig = "bex", snippetType = "autosnippet" },
    fmta(
      [[
      \begin{exercise}[<>]
        <>
      \end{exercise}
      ]],
      {
        i(1),
        i(0),
      }
    ),
    { condition = line_begin }
  ),
  s(
    { trig = "beg", snippetType = "autosnippet" },
    fmta(
      [[
      \begin{<>}[<>]
        <>
      \end{<>}
      ]],
      {
        i(1),
        i(2),
        i(0),
        rep(1),
      }
    ),
    { condition = line_begin }
  ),
  s(
    { trig = "ben", snippetType = "autosnippet" },
    fmta(
      [[
      \begin{enumerate}[<>]
        \item <>
      \end{enumerate}
      ]],
      {
        i(1, "(a)"),
        i(0),
      }
    ),
    { condition = line_begin }
  ),
  s(
    { trig = "box", snippetType = "autosnippet" },
    fmta(
      [[
      \begin{framed}
        <>
      \end{framed}
      ]],
      {
        i(0),
      }
    ),
    { condition = tex.in_text * line_begin }
  ),
  s(
    { trig = "dcase", snippetType = "autosnippet", priority = 2000 },
    fmta(
      [[
      \begin{dcases}
        <>
      \end{dcases}
      ]],
      {
        i(0),
      }
    ),
    { condition = tex.in_mathzone }
  ),
  s(
    { trig = "case", snippetType = "autosnippet" },
    fmta(
      [[
      \begin{cases}
        <>
      \end{cases}
      ]],
      {
        i(0),
      }
    ),
    { condition = tex.in_mathzone }
  ),
  s(
    { trig = "bal", snippetType = "autosnippet" },
    fmta(
      [[
      \begin{aligned}
        <>
      \end{aligned}
      ]],
      {
        i(0),
      }
    ),
    { condition = tex.in_mathzone }
  ),
  s(
    { trig = "bal", snippetType = "autosnippet", priority = 2000 },
    fmta(
      [[
      \begin{aligned}
        <>
      \end{aligned}
      ]],
      {
        d(1, get_visual),
      }
    ),
    { condition = tex.in_mathzone }
  ),
  s(
    { trig = "bit", snippetType = "autosnippet" },
    fmta(
      [[
      \begin{itemize}
        \item <>
      \end{itemize}
      ]],
      {
        i(0),
      }
    ),
    { condition = line_begin }
  ),
  s({ trig = "im", snippetType = "autosnippet" }, {
    t("\\item"),
  }, { condition = tex.in_item * line_begin }),
  s(
    { trig = "bcr", snippetType = "autosnippet" },
    fmta(
      [[
      \begin{center}
        <>
      \end{center}
      ]],
      {
        i(0),
      }
    ),
    { condition = line_begin }
  ),
  s(
    { trig = "btr", snippetType = "autosnippet" },
    fmta(
      [[
      \begin{tabular}{<>}
        \hline
        <>
        \hline
      \end{tabular}
      ]],
      {
        i(1),
        i(0),
      }
    ),
    { condition = line_begin }
  ),
  s(
    { trig = "cha", snippetType = "autosnippet" },
    fmta(
      [[
        \chapter{<>}
      ]],
      {
        i(0),
      }
    ),
    { condition = line_begin }
  ),
  s(
    { trig = "par", snippetType = "autosnippet" },
    fmta(
      [[
        \paragraph{<>}
      ]],
      {
        i(0),
      }
    ),
    { condition = line_begin }
  ),
  s(
    { trig = "sec", snippetType = "autosnippet" },
    fmta(
      [[
        \section{<>}
      ]],
      {
        i(0),
      }
    ),
    { condition = line_begin }
  ),
  s(
    { trig = "ssec", snippetType = "autosnippet" },
    fmta(
      [[
        \subsection{<>}
      ]],
      {
        i(0),
      }
    ),
    { condition = line_begin }
  ),
  s(
    { trig = "sss", snippetType = "autosnippet" },
    c(1, { sn(nil, { t("\\subsubsection{"), i(1), t("}") }), sn(nil, { t("\\subsubsection*{"), i(1), t("}") }) }),
    { condition = tex.in_text }
  ),
  s(
    { trig = "sss", snippetType = "autosnippet" },
    fmta(
      [[
        \subsubsection{<>}
      ]],
      {
        i(0),
      }
    ),
    { condition = line_begin }
  ),
}
