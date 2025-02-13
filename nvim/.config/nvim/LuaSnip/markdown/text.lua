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
  s({ trig = "dps", snippetType = "autosnippet" }, {
    t("\\displaystyle"),
  }, { condition = tex.in_mathzone }),
  s({ trig = "if", snippetType = "autosnippet" }, {
    t("\\text{\\ if\\ }"),
  }, { condition = tex.in_mathzone }),
  s({ trig = "stt", snippetType = "autosnippet" }, {
    t("\\text{ s.t. }"),
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
  s({ trig = "wlog", snippetType = "autosnippet" }, {
    t("without loss of generality"),
  }, { condition = tex.in_text }),
  s({ trig = "Wlog", snippetType = "autosnippet" }, {
    t("Without loss of generality"),
  }, { condition = tex.in_text }),
  s({ trig = "thmm", snippetType = "autosnippet" }, {
    t("theorem"),
  }, { condition = tex.in_text }),
  s({ trig = "Thmm", snippetType = "autosnippet" }, {
    t("Theorem"),
  }, { condition = tex.in_text }),
  s({ trig = "propp", snippetType = "autosnippet" }, {
    t("proposition"),
  }, { condition = tex.in_text }),
  s({ trig = "deff", snippetType = "autosnippet" }, {
    t("definition"),
  }, { condition = tex.in_text }),
  s({ trig = "Deff", snippetType = "autosnippet" }, {
    t("Definition"),
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
  s({ trig = "homeo" }, {
    t("homeomorphism"),
  }, { condition = tex.in_text }),
  s({ trig = "homeo" }, {
    t("homeomorphic"),
  }, { condition = tex.in_text }),
  s({ trig = "homo" }, {
    t("homomorphism"),
  }, { condition = tex.in_text }),
  s({ trig = "homo" }, {
    t("homomorphic"),
  }, { condition = tex.in_text }),
  s({ trig = "si ", snippetType = "autosnippet" }, {
    t("is "),
  }, { condition = tex.in_text }),
  s({ trig = "=>", snippetType = "autosnippet" }, {
    t("$\\implies$"),
  }, { condition = tex.in_text }),
  s({ trig = "<=", snippetType = "autosnippet" }, {
    t("$\\impliedby$"),
  }, { condition = tex.in_text }),
  s(
    { trig = "(%a)ii", regTrig = true, wordTrig = false, snippetType = "autosnippet" },
    fmta("$<>$", {
      f(function(_, snip)
        return snip.captures[1]
      end),
    }),
    { condition = tex.in_text }
  ),
  s(
    {
      trig = "#(%d)",
      regTrig = true,
      wordTrig = false,
      snippetType = "autosnippet",
    },
    fmta(
      "<> ",
      { f(function(_, snip)
        local n = tonumber(snip.captures[1])
        return string.rep("#", n)
      end) }
    ),
    { condition = tex.in_text }
  ),
}
