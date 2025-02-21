local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
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
  s({ trig = "sin", snippetType = "autosnippet" }, {
    t("\\sin"),
  }, { condition = tex.in_mathzone }),
  s({ trig = "asin", snippetType = "autosnippet" }, {
    t("\\arcsin"),
  }, { condition = tex.in_mathzone }),
  s({ trig = "cos", snippetType = "autosnippet" }, {
    t("\\cos"),
  }, { condition = tex.in_mathzone }),
  s({ trig = "acos", snippetType = "autosnippet" }, {
    t("\\arccos"),
  }, { condition = tex.in_mathzone }),
  s({ trig = "tan", snippetType = "autosnippet" }, {
    t("\\tan"),
  }, { condition = tex.in_mathzone }),
  s({ trig = "atan", snippetType = "autosnippet" }, {
    t("\\arctan"),
  }, { condition = tex.in_mathzone }),
  s({ trig = "cot", snippetType = "autosnippet" }, {
    t("\\cot"),
  }, { condition = tex.in_mathzone }),
  s({ trig = "acot", snippetType = "autosnippet" }, {
    t("\\arccot"),
  }, { condition = tex.in_mathzone }),
  s({ trig = "csc", snippetType = "autosnippet" }, {
    t("\\csc"),
  }, { condition = tex.in_mathzone }),
  s({ trig = "acsc", snippetType = "autosnippet" }, {
    t("\\arccsc"),
  }, { condition = tex.in_mathzone }),
  s({ trig = "sec", snippetType = "autosnippet" }, {
    t("\\sec"),
  }, { condition = tex.in_mathzone }),
  s({ trig = "asec", snippetType = "autosnippet" }, {
    t("\\arcsec"),
  }, { condition = tex.in_mathzone }),
  s({ trig = "log", snippetType = "autosnippet" }, {
    t("\\log"),
  }, { condition = tex.in_mathzone }),
  s({ trig = "ln", snippetType = "autosnippet" }, {
    t("\\ln"),
  }, { condition = tex.in_mathzone }),
  s({ trig = "exp", snippetType = "autosnippet" }, {
    t("\\exp"),
  }, { condition = tex.in_mathzone }),
  s({ trig = "grad", snippetType = "autosnippet" }, {
    t("\\grad"),
  }, { condition = tex.in_mathzone }),
  s({ trig = "curl", snippetType = "autosnippet" }, {
    t("\\curl"),
  }, { condition = tex.in_mathzone }),
  s({ trig = "div", snippetType = "autosnippet" }, {
    t("\\div"),
  }, { condition = tex.in_mathzone }),
  s({ trig = "lap", snippetType = "autosnippet" }, {
    t("\\laplacian"),
  }, { condition = tex.in_mathzone }),
  s({ trig = "bbr", snippetType = "autosnippet" }, {
    t("\\mathbb{R}"),
  }, { condition = tex.in_mathzone }),
  s({ trig = "bbq", snippetType = "autosnippet" }, {
    t("\\mathbb{Q}"),
  }, { condition = tex.in_mathzone }),
  s({ trig = "bbh", snippetType = "autosnippet" }, {
    t("\\mathbb{H}"),
  }, { condition = tex.in_mathzone }),
  s({ trig = "bbc", snippetType = "autosnippet" }, {
    t("\\mathbb{C}"),
  }, { condition = tex.in_mathzone }),
  s({ trig = "bbz", snippetType = "autosnippet" }, {
    t("\\mathbb{Z}"),
  }, { condition = tex.in_mathzone }),
  s({ trig = "bbn", snippetType = "autosnippet" }, {
    t("\\mathbb{N}"),
  }, { condition = tex.in_mathzone }),
  s({ trig = "bb1", snippetType = "autosnippet", priority = 2000 }, {
    t("\\mathbbm{1}"),
  }, { condition = tex.in_mathzone }),
  s({ trig = "bbe", snippetType = "autosnippet" }, {
    t("\\mathbb{E}"),
  }, { condition = tex.in_mathzone }),
  s(
    { trig = "bb(%w)", regTrig = true, wordTrig = false, snippetType = "autosnippet" },
    fmta("\\mathbb{<>}", {
      f(function(_, snip)
        return string.upper(snip.captures[1])
      end),
    }),
    { condition = tex.in_mathzone }
  ),
  s({ trig = "exp", snippetType = "autosnippet" }, {
    t("\\exp"),
  }, { condition = tex.in_mathzone }),
  s({ trig = "cv", snippetType = "autosnippet" }, fmta("\\conv", {}), { condition = tex.in_mathzone }),
  s(
    { trig = "brr", snippetType = "autosnippet" },
    fmta("\\bar{<>}", {
      i(1),
    }),
    { condition = tex.in_mathzone }
  ),
  s(
    { trig = "bar", snippetType = "autosnippet" },
    fmta("\\overline{<>}", {
      i(1),
    }),
    { condition = tex.in_mathzone }
  ),
  s(
    { trig = "(%a)bar", wordTrig = false, regTrig = true, snippetType = "autosnippet" },
    fmta("\\overline{<>}", {
      f(function(_, snip)
        return snip.captures[1]
      end),
    }),
    { condition = tex.in_mathzone }
  ),
  s(
    { trig = "ob", snippetType = "autosnippet" },
    fmta("\\overbrace{<>}^{<>}", {
      i(1),
      i(2),
    }),
    { condition = tex.in_mathzone }
  ),
  s(
    { trig = "ob", snippetType = "autosnippet", priority = 2000 },
    fmta("\\overbrace{<>}^{<>}", {
      d(1, get_visual),
      i(2),
    }),
    { condition = tex.in_mathzone }
  ),
  s(
    { trig = "td", snippetType = "autosnippet", priority = 2000 },
    fmta("\\tilde{<>}", {
      d(1, get_visual),
    }),
    { condition = tex.in_mathzone }
  ),
  s(
    { trig = "td", snippetType = "autosnippet" },
    fmta("\\ttlde{<>}", {
      i(1),
    }),
    { condition = tex.in_mathzone }
  ),
  s(
    { trig = "(\\%a+)~", wordTrig = false, regTrig = true, snippetType = "autosnippet" },
    fmta("\\tilde{<>}", {
      f(function(_, snip)
        return snip.captures[1]
      end),
    }),
    { condition = tex.in_mathzone }
  ),
  s(
    { trig = "(%a)~", wordTrig = false, regTrig = true, snippetType = "autosnippet" },
    fmta("\\tilde{<>}", {
      f(function(_, snip)
        return snip.captures[1]
      end),
    }),
    { condition = tex.in_mathzone }
  ),
  s(
    { trig = "dot", snippetType = "autosnippet", priority = 2000 },
    fmta("\\dot{<>}", {
      d(1, get_visual),
    }),
    { condition = tex.in_mathzone }
  ),
  s(
    { trig = "dot", snippetType = "autosnippet" },
    fmta("\\dot{<>}", {
      i(1),
    }),
    { condition = tex.in_mathzone }
  ),
  s(
    { trig = "doo", snippetType = "autosnippet", priority = 2000 },
    fmta("\\ddot{<>}", {
      i(1),
    }),
    { condition = tex.in_mathzone }
  ),
  s(
    { trig = "vb", snippetType = "autosnippet" },
    c(1, { sn(nil, { t("\\vb{"), i(1), t("}") }), sn(nil, { t("\\vb*{"), i(1), t("}") }) }),
    { condition = tex.in_mathzone }
  ),
  s(
    { trig = "vu", snippetType = "autosnippet" },
    c(1, { sn(nil, { t("\\vu{"), i(1), t("}") }), sn(nil, { t("\\vu*{"), i(1), t("}") }) }),
    { condition = tex.in_mathzone }
  ),
  s(
    { trig = "hat", snippetType = "autosnippet", priority = 2000 },
    fmta("\\hat{<>}", {
      d(1, get_visual),
    }),
    { condition = tex.in_mathzone }
  ),
  s(
    { trig = "hat", snippetType = "autosnippet" },
    fmta("\\hat{<>}", {
      i(1),
    }),
    { condition = tex.in_mathzone }
  ),
  s(
    { trig = "vec", snippetType = "autosnippet", priority = 2000 },
    fmta("\\vec{<>}", {
      d(1, get_visual),
    }),
    { condition = tex.in_mathzone }
  ),
  s(
    { trig = ";v", snippetType = "autosnippet" },
    fmta("\\vec{<>}", {
      i(1),
    }),
    { condition = tex.in_mathzone }
  ),
  s(
    { trig = "vec", snippetType = "autosnippet" },
    fmta("\\vec{<>}", {
      i(1),
    }),
    { condition = tex.in_mathzone }
  ),
  -- s({ trig = "rr", snippetType = "autosnippet" }, fmta("\\ran", {}), { condition = tex.in_mathzone }),
  -- s({ trig = "kk", snippetType = "autosnippet" }, fmta("\\ker", {}), { condition = tex.in_mathzone }),
  s({ trig = "tr", snippetType = "autosnippet" }, fmta("\\tr", {}), { condition = tex.in_mathzone }),
  s({ trig = "span", snippetType = "autosnippet" }, fmta("\\span", {}), { condition = tex.in_mathzone }),
  s({ trig = "aut", snippetType = "autosnippet" }, fmta("\\Aut", {}), { condition = tex.in_mathzone }),
  s({ trig = "gal", snippetType = "autosnippet" }, fmta("\\Gal", {}), { condition = tex.in_mathzone }),
  s({ trig = "rank", snippetType = "autosnippet" }, fmta("\\rank", {}), { condition = tex.in_mathzone }),
  s({ trig = "dim", snippetType = "autosnippet" }, fmta("\\dim", {}), { condition = tex.in_mathzone }),
  s({ trig = "det", snippetType = "autosnippet" }, fmta("\\det", {}), { condition = tex.in_mathzone }),
  s({ trig = "vol", snippetType = "autosnippet" }, fmta("\\Vol", {}), { condition = tex.in_mathzone }),
  s(
    { trig = "->", snippetType = "autosnippet" },
    fmta("\\xlongrightarrow{<>}", {
      i(1),
    }),
    { condition = tex.in_mathzone }
  ),
  s(
    { trig = "<-", snippetType = "autosnippet" },
    fmta("\\xlongleftarrow{<>}", {
      i(1),
    }),
    { condition = tex.in_mathzone }
  ),
  s({ trig = "--", snippetType = "autosnippet" }, fmta("\\longleftrightarrow", {}), { condition = tex.in_mathzone }),
  s(
    { trig = "gt", snippetType = "autosnippet" },
    fmta("\\gt{<>}", {
      i(1),
    }),
    { condition = tex.in_mathzone }
  ),
  s({ trig = "min", snippetType = "autosnippet" }, fmta("\\min", {}), { condition = tex.in_mathzone }),
  s({ trig = "max", snippetType = "autosnippet" }, fmta("\\max", {}), { condition = tex.in_mathzone }),
  s(
    { trig = "amin", snippetType = "autosnippet" },
    fmta("\\argmin_{<>}", {
      i(1),
    }),
    { condition = tex.in_mathzone }
  ),
  s(
    { trig = "amax", snippetType = "autosnippet" },
    fmta("\\argmax_{<>}", {
      i(1),
    }),
    { condition = tex.in_mathzone }
  ),
  s({ trig = "sup", snippetType = "autosnippet", priority = 2000 }, fmta("\\sup", {}), { condition = tex.in_mathzone }),
  s({ trig = "inf", snippetType = "autosnippet", priority = 2000 }, fmta("\\inf", {}), { condition = tex.in_mathzone }),
  s(
    { trig = ";r", wordTrig = false, snippetType = "autosnippet" },
    fmta("\\frac{<>}{<>}", {
      i(1),
      i(2),
    }),
    { condition = tex.in_mathzone }
  ),
  s(
    { trig = ";r", snippetType = "autosnippet", priority = 2000 },
    fmta("\\frac{<>}{<>}", {
      d(1, get_visual),
      i(2),
    }),
    { condition = tex.in_mathzone }
  ),
  s(
    { trig = "binom", snippetType = "autosnippet" },
    fmta("\\binom{<>}{<>}", {
      i(1),
      i(2),
    }),
    { condition = tex.in_mathzone }
  ),
  s({ trig = "dd", snippetType = "autosnippet" }, fmta("\\d ", {}), { condition = tex.in_mathzone }),
  s({ trig = "poly", snippetType = "autosnippet" }, fmta("\\poly", {}), { condition = tex.in_mathzone }),
  s(
    { trig = "sq", wordTrig = false, snippetType = "autosnippet" },
    c(1, { sn(nil, { t("\\sqrt{"), i(1), t("}") }), sn(nil, { t("\\sqrt["), i(1), t("]{"), i(2), t("}") }) }),
    { condition = tex.in_mathzone }
  ),
  s(
    { trig = "mod", wordTrig = false, snippetType = "autosnippet" },
    fmta("\\mod{<>}", {
      i(1),
    }),
    { condition = tex.in_mathzone }
  ),
  s(
    { trig = "nmod", wordTrig = false, snippetType = "autosnippet", priority = 2000 },
    fmta("\\nmod{<>}", {
      i(1),
    }),
    { condition = tex.in_mathzone }
  ),
  s(
    { trig = "pmod", wordTrig = false, snippetType = "autosnippet", priority = 2000 },
    fmta("\\pmod{<>}", {
      i(1),
    }),
    { condition = tex.in_mathzone }
  ),
  s(
    { trig = "sgn", wordTrig = false, snippetType = "autosnippet", priority = 2000 },
    fmta("\\sgn", {}),
    { condition = tex.in_mathzone }
  ),
  s(
    { trig = "SI", wordTrig = false, snippetType = "autosnippet", priority = 2000 },
    fmta("\\SI{<>}{<>}", {
      i(1),
      i(2),
    }),
    { condition = tex.in_mathzone }
  ),
  s(
    { trig = "cond", wordTrig = false, snippetType = "autosnippet", priority = 2000 },
    fmta("\\cond(<>)", {
      i(1),
    }),
    { condition = tex.in_mathzone }
  ),
  s(
    { trig = "cqty", wordTrig = false, snippetType = "autosnippet", priority = 2000 },
    fmta("\\complexqty{<>}{<>}", {
      i(1),
      i(2),
    }),
    { condition = tex.in_mathzone }
  ),
  s(
    { trig = "gcd", wordTrig = false, snippetType = "autosnippet", priority = 2000 },
    fmta("\\gcd", {}),
    { condition = tex.in_mathzone }
  ),
  s(
    { trig = "deg", wordTrig = false, snippetType = "autosnippet", priority = 2000 },
    fmta("\\degree", {}),
    { condition = tex.in_mathzone }
  ),
  s({ trig = "pr", wordTrig = false, snippetType = "autosnippet" }, fmta("\\Pr", {}), { condition = tex.in_mathzone }),
  s({ trig = "sch", snippetType = "autosnippet" }, {
    t("\\Sch"),
  }, { condition = tex.in_mathzone }),
  s({ trig = "\\Pii", snippetType = "autosnippet", priority = 2000 }, {
    t("P_i"),
  }, { condition = tex.in_mathzone }),
  s({ trig = "bv", snippetType = "autosnippet", priority = 2000 }, {
    t("\\bigg\\vert"),
  }, { condition = tex.in_mathzone }),
  s({ trig = "ab", snippetType = "autosnippet" }, {
    t("\\ab"),
  }, { condition = tex.in_mathzone }),
  s(
    { trig = "ub", snippetType = "autosnippet", priority = 2000 },
    fmta("\\underbrace{<>}", { i(1) }),
    { condition = tex.in_mathzone }
  ),
  s(
    { trig = "ob", snippetType = "autosnippet", priority = 2000 },
    fmta("\\overbrace{<>}", { i(1) }),
    { condition = tex.in_mathzone }
  ),
  s(
    { trig = "ring", snippetType = "autosnippet", priority = 2000 },
    fmta("\\mathring{<>}", { i(1) }),
    { condition = tex.in_mathzone }
  ),
}
