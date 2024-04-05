local ls = require("luasnip")
local c = ls.choice_node
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local fmta = require("luasnip.extras.fmt").fmta
local tex = require("util.latex")
local rep = require("luasnip.extras").rep
local line_begin = require("luasnip.extras.expand_conditions").line_begin

return {
  s(
    { trig = "DeclareMathOperator" },
    fmta("\\DeclareMathOperator{\\<>}{<>}", {
      i(1),
      rep(1),
    }),
    { condition = tex.in_mathzone }
  ),
  s({ trig = "dps", snippetType = "autosnippet" }, {
    t("\\displaystyle"),
  }, { condition = tex.in_mathzone }),
  s({ trig = "if", snippetType = "autosnippet" }, {
    t("\\text{\\ if\\ }"),
  }, { condition = tex.in_mathzone }),
  s({ trig = "stt", snippetType = "autosnippet" }, {
    t("\\quad\\text{s.t.}\\quad"),
  }, { condition = tex.in_mathzone }),
  s({ trig = "as", snippetType = "autosnippet" }, {
    t("\\text{\\ as\\ }"),
  }, { condition = tex.in_mathzone }),
  s({ trig = "or", snippetType = "autosnippet" }, { t("\\text{\\ or\\ }") }, { condition = tex.in_mathzone }),
  s({ trig = "otherwise", snippetType = "autosnippet" }, {
    t("\\text{\\ otherwise\\ }"),
  }, { condition = tex.in_mathzone }),
  s({ trig = "then", snippetType = "autosnippet" }, {
    t("\\text{\\ then\\ }"),
  }, { condition = tex.in_mathzone }),
  s({ trig = "since", snippetType = "autosnippet" }, {
    t("\\text{\\ since\\ }"),
  }, { condition = tex.in_mathzone }),
  s({ trig = "by", snippetType = "autosnippet" }, {
    t("\\text{\\ by\\ }"),
  }, { condition = tex.in_mathzone }),
  s({ trig = "and", snippetType = "autosnippet" }, {
    t("\\text{\\ and\\ }"),
  }, { condition = tex.in_mathzone }),
  s({ trig = "qd", snippetType = "autosnippet" }, {
    t("\\quad"),
  }, { condition = tex.in_mathzone }),
  s(
    { trig = "setc", snippetType = "autosnippet" },
    fmta("\\setcounter{<>}{<>}", {
      c(1, { t("exercise"), t("theorem") }),
      i(2),
    }),
    { condition = tex.in_text }
  ),
  s(
    { trig = "PP", snippetType = "autosnippet" },
    fmta("\\section*{Problem <>}", { i(1) }),
    { condition = tex.in_text }
  ),

  -- s({ trig = "label", snippetType = "autosnippet" }, {
  --   t("\\label{"),
  --   i(0),
  --   t("}"),
  -- }, { condition = tex.in_text, show_condition = tex.in_text }),
  s(
    { trig = "href", snippetType = "autosnippet" },
    fmta("\\href{<>}{<>}", {
      i(1),
      i(2),
    }),
    { condition = tex.in_text }
  ),

  s({ trig = "wlog", snippetType = "autosnippet" }, {
    t("without loss of generality"),
  }, { condition = tex.in_text }),
  s({ trig = "Wlog", snippetType = "autosnippet" }, {
    t("Without loss of generality"),
  }, { condition = tex.in_text }),
  s({ trig = "%%", snippetType = "autosnippet" }, {
    t("\\%"),
  }, { condition = tex.in_text }),
  s({ trig = "&&", snippetType = "autosnippet" }, {
    t("\\&"),
  }, { condition = tex.in_text }),
  s({ trig = "##", snippetType = "autosnippet" }, {
    t("\\#"),
  }, { condition = tex.in_text }),
  s({ trig = "thm", snippetType = "autosnippet" }, {
    t("theorem"),
  }, { condition = tex.in_text }),
  s({ trig = "propp", snippetType = "autosnippet" }, {
    t("proposition"),
  }, { condition = tex.in_text }),
  s({ trig = "deff", snippetType = "autosnippet" }, {
    t("definition"),
  }, { condition = tex.in_text }),
  s({ trig = "exaa", snippetType = "autosnippet" }, {
    t("example"),
  }, { condition = tex.in_text }),
  s({ trig = "iee", snippetType = "autosnippet" }, {
    t("i.e."),
  }, { condition = tex.in_text }),
  s({ trig = "stt", snippetType = "autosnippet" }, {
    t("such that"),
  }, { condition = tex.in_text }),
  s({ trig = "iff", snippetType = "autosnippet" }, {
    t("if and only if"),
  }, { condition = tex.in_text }),
  s({ trig = "iso" }, {
    t("isomorphic"),
  }, { condition = tex.in_text }),
  s({ trig = "iso" }, {
    t("isomorphism"),
  }, { condition = tex.in_text }),
  s({ trig = "homo" }, {
    t("homomorphism"),
  }, { condition = tex.in_text }),
  s({ trig = "homo" }, {
    t("homomorphic"),
  }, { condition = tex.in_text }),
  -- s({ trig = "psp", snippetType = "autosnippet" }, {
  --   t("\\(p\\)-subgroup"),
  -- }, { condition = tex.in_text }),
  -- s({ trig = "pgp", snippetType = "autosnippet" }, {
  --   t("\\(p\\)-subgroup"),
  -- }, { condition = tex.in_text }),
  -- s({ trig = "spsp", snippetType = "autosnippet" }, {
  --   t("Sylow \\(p\\)-subgroup"),
  -- }, { condition = tex.in_text }),
  s({ trig = "=>", snippetType = "autosnippet" }, {
    t("\\(\\implies\\)"),
  }, { condition = tex.in_text }),
  s(
    { trig = "homework" },
    fmta(
      [[
    \documentclass{article}
    \newcommand{\Class}{<>}
    \newcommand{\Title}{Homework <>}
    \author{Hanyu Yan}
    \input{~/Documents/Latex/Package_elegantbook.tex}
    \input{~/Documents/Latex/Sample_Homework.tex}
    \begin{document}
    \maketitle \thispagestyle{empty}
      
    <>
      
    \end{document}
    ]],
      {
        c(1, {
          t("Numerical Analysis"),
          t("Experimental Quantum Information Processing"),
          t("Quantum Communication and Cryptography"),
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
    \documentclass[letterpaper, 12pt]{article}
    \input{~/Documents/Latex/note_template.tex}
    \begin{document}
    \title{<> \\[1em]
    \normalsize <>}
    \author{\normalsize Fireond}
    \date{\normalsize\vspace{-1ex} Last updated: \today}
    \maketitle
    \tableofcontents\label{sec:contents}

    <>
      
    \end{document}
    ]],
      {
        i(1, "title"),
        i(2, "subtitle"),
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
    \input{~/Documents/Latex/Package_elegantbook.tex}

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
    \input{~/Documents/Latex/Package_elegantbook.tex}
    \input{~/Documents/Latex/Sample_Homework.tex}
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
}
