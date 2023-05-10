local ls = require("luasnip")
local c = ls.choice_node
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local fmta = require("luasnip.extras.fmt").fmta
local tex = require("util.latex")

return {
  s({ trig = "dps", snippetType = "autosnippet" }, {
    t("\\displaystyle"),
  }, { condition = tex.in_mathzone }),
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
    t("s.t."),
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
  s({ trig = "psp", snippetType = "autosnippet" }, {
    t("\\(p\\)-subgroup"),
  }, { condition = tex.in_text }),
  s({ trig = "pgp", snippetType = "autosnippet" }, {
    t("\\(p\\)-subgroup"),
  }, { condition = tex.in_text }),
  s({ trig = "spsp", snippetType = "autosnippet" }, {
    t("Sylow \\(p\\)-subgroup"),
  }, { condition = tex.in_text }),
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
    \input{~/Documents/Latex/Package_elegantbook.tex}
    \input{~/Documents/Latex/Sample_Homework.tex}
    \begin{document}
    \begin{spacing}{1.1}
    \maketitle \thispagestyle{empty}
      
    <>
      
    \end{spacing}
    \end{document}
    ]],
      {
        c(1, { t("Abstract Algebra"), t("Mathematics for Artificial Intelligence"), t("Quantum Computer Science") }),
        i(2, "number"),
        i(0),
      }
    ),
    { condition = tex.in_text }
  ),
}
