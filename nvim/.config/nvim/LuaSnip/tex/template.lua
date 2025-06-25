local ls = require("luasnip")
local c = ls.choice_node
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local fmta = require("luasnip.extras.fmt").fmta
local tex = require("util.latex")
local rep = require("luasnip.extras").rep
local line_begin = require("luasnip.extras.expand_conditions").line_begin

return {
  s(
    { trig = "homework" },
    fmta(
      [[
    \documentclass{article}
    \newcommand{\Class}{<>}
    \newcommand{\Title}{Homework <>}
    \author{Hanyu Yan}
    \input{/home/fireond/Documents/Latex/preamble.tex}
    \input{/home/fireond/Documents/Latex/Sample_Homework.tex}
    \begin{document}
    \maketitle \thispagestyle{empty}
      
    <>
      
    \end{document}
    ]],
      {
        c(1, {
          t("Quantum Computation + X"),
          t("Advanced Atomic Physics"),
          t("Electronics for Experimental Physics"),
        }),
        i(2, "number"),
        i(0),
      }
    ),
    { condition = tex.in_text * line_begin }
  ),
  s(
    { trig = "note" },
    fmta(
      [[
\documentclass[12pt]{article}
\input{/home/fireond/Documents/Latex/preamble.tex}
\begin{document}
\title{<>}
\author{Fireond}
\date{\today}
\maketitle
\tableofcontents
\newpage

<>

\end{document}
    ]],
      {
        i(1, "title"),
        i(0),
      }
    ),
    { condition = tex.in_text * line_begin }
  ),
  s(
    { trig = "algo" },
    fmta(
      [[
    \documentclass[utf8]{article}
    \usepackage{amsmath,amssymb}
    \usepackage{graphicx}
    \usepackage{fullpage}
    \usepackage{setspace}
    \usepackage{verbatim}
    \usepackage{algorithm}
    \usepackage{algpseudocodex}
    \algrenewcommand\algorithmicrequire{\textbf{Input:}}
    \algrenewcommand\algorithmicensure{\textbf{Output:}}
    \input{/home/fireond/Documents/Latex/Package_elegantbook.tex}

    \onehalfspacing

    \title{\bf\huge Algorithm Design - Assignment <>}
    \author{Hanyu Yan\\2022010860\\Class 23}
    \date{\today}

    \begin{document}
    \maketitle

    <>

    \end{document}
    ]],
      { i(1), i(0) }
    ),
    { condition = tex.in_text * line_begin }
  ),
  s(
    { trig = "report" },
    fmta(
      [[
    %! TeX program = xelatex
    \documentclass{article}
    \newcommand{\Class}{<>}
    \newcommand{\Title}{<>}
    \author{严涵宇}
    \usepackage[UTF8]{ctex}
    \input{/home/fireond/Documents/Latex/Package_elegantbook.tex}
    \input{/home/fireond/Documents/Latex/Sample_Homework.tex}
    \renewcommand{\arraystretch}{1.3}
    \begin{document}
    \maketitle \thispagestyle{empty}
      
    <>
      
    \end{document}
    ]],
      {
        c(1, {
          t("量子信息实验报告"),
        }),
        i(2),
        i(0),
      }
    ),
    { condition = tex.in_text * line_begin }
  ),
  s(
    { trig = "cpho" },
    fmta(
      [[
%! TEX program = xelatex
\documentclass[10pt]{article}
\input{/home/fireond/Documents/Latex/preamble.tex}
\usepackage{ctex}
\begin{document}

<>
\begin{enumerate}[1.]
  \item
\end{enumerate}

\end{document}
    ]],
      { i(0) }
    ),
    { condition = tex.in_text * line_begin }
  ),
}
