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
    return sn(nil, i(1, parent.snippet.env.SELECT_RAW))
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
  s({ trig = "bb1", snippetType = "autosnippet" }, {
    t("\\mathbbm{1}"),
  }, { condition = tex.in_mathzone }),
  s({ trig = "bbe", snippetType = "autosnippet" }, {
    t("\\mathbb{E}"),
  }, { condition = tex.in_mathzone }),
  s({ trig = "exp", snippetType = "autosnippet" }, {
    t("\\exp"),
  }, { condition = tex.in_mathzone }),
  s(
    { trig = "bar", snippetType = "autosnippet", priority = 2000 },
    fmta("\\overline{<>}", {
      d(1, get_visual),
    }),
    { condition = tex.in_mathzone }
  ),
  s(
    { trig = "bar", snippetType = "autosnippet" },
    fmta("\\overline{<>}", {
      i(0),
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
      i(0),
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
      i(0),
    }),
    { condition = tex.in_mathzone }
  ),
  s(
    { trig = "vb", snippetType = "autosnippet", priority = 2000 },
    fmta("\\vb{<>}", {
      d(1, get_visual),
    }),
    { condition = tex.in_mathzone }
  ),
  s(
    { trig = "vb", snippetType = "autosnippet" },
    fmta("\\vb{<>}", {
      i(0),
    }),
    { condition = tex.in_mathzone }
  ),
  s(
    { trig = "iv", snippetType = "autosnippet", wordTrig = false, priority = 2000 },
    fmta("\\ivb{<>}", {
      d(1, get_visual),
    }),
    { condition = tex.in_mathzone }
  ),
  s(
    { trig = "ivb", snippetType = "autosnippet" },
    fmta("\\vb*{<>}", {
      i(0),
    }),
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
      i(0),
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
    { trig = "vec", snippetType = "autosnippet" },
    fmta("\\vec{<>}", {
      i(0),
    }),
    { condition = tex.in_mathzone }
  ),
  -- s({ trig = "rr", snippetType = "autosnippet" }, fmta("\\ran", {}), { condition = tex.in_mathzone }),
  s({ trig = "kk", snippetType = "autosnippet" }, fmta("\\ker", {}), { condition = tex.in_mathzone }),
  s({ trig = "aut", snippetType = "autosnippet" }, fmta("\\Aut{<>}", { i(1) }), { condition = tex.in_mathzone }),
  s({ trig = "rank", snippetType = "autosnippet" }, fmta("\\rank", {}), { condition = tex.in_mathzone }),
  s({ trig = "dim", snippetType = "autosnippet" }, fmta("\\dim", {}), { condition = tex.in_mathzone }),
  s({ trig = "det", snippetType = "autosnippet" }, fmta("\\det", {}), { condition = tex.in_mathzone }),
  s({ trig = "vol", snippetType = "autosnippet" }, fmta("\\Vol", {}), { condition = tex.in_mathzone }),
  s(
    { trig = "->", snippetType = "autosnippet" },
    fmta("\\xlongrightarrow{<>}", {
      i(0),
    }),
    { condition = tex.in_mathzone }
  ),
  s(
    { trig = "gt", snippetType = "autosnippet" },
    fmta("\\gt{<>}", {
      i(0),
    }),
    { condition = tex.in_mathzone }
  ),
  s({ trig = "min", snippetType = "autosnippet" }, fmta("\\min", {}), { condition = tex.in_mathzone }),
  s(
    { trig = "\\minl", snippetType = "autosnippet" },
    fmta("\\min\\limits_{<>}", {
      i(0),
    }),
    { condition = tex.in_mathzone }
  ),
  s({ trig = "max", snippetType = "autosnippet" }, fmta("\\max", {}), { condition = tex.in_mathzone }),
  s(
    { trig = "\\maxl", snippetType = "autosnippet" },
    fmta("\\max\\limits_{<>}", { i(0) }),
    { condition = tex.in_mathzone }
  ),
  s(
    { trig = "amin", snippetType = "autosnippet" },
    fmta("\\argmin\\limits_{<>}", {
      i(0),
    }),
    { condition = tex.in_mathzone }
  ),
  s(
    { trig = "amax", snippetType = "autosnippet" },
    fmta("\\argmax\\limits_{<>}", {
      i(0),
    }),
    { condition = tex.in_mathzone }
  ),
  s(
    { trig = "sup", snippetType = "autosnippet" },
    fmta("\\sup\\limits_{<>}", {
      i(0),
    }),
    { condition = tex.in_mathzone }
  ),
  s(
    { trig = "inf", snippetType = "autosnippet" },
    fmta("\\inf\\limits_{<>}", {
      i(0),
    }),
    { condition = tex.in_mathzone }
  ),
  s(
    { trig = ";r", wordTrig = false, snippetType = "autosnippet" },
    fmta("\\frac{<>}{<>}", {
      i(1),
      i(0),
    }),
    { condition = tex.in_mathzone }
  ),
  s(
    { trig = ";r", snippetType = "autosnippet", priority = 2000 },
    fmta("\\frac{<>}{<>}", {
      d(1, get_visual),
      i(0),
    }),
    { condition = tex.in_mathzone }
  ),
  s(
    { trig = "bi", snippetType = "autosnippet" },
    fmta("\\binom{<>}{<>}", {
      i(1),
      i(0),
    }),
    { condition = tex.in_mathzone }
  ),
  s(
    { trig = "dd", snippetType = "autosnippet" },
    fmta("\\dd{<>}", {
      i(0),
    }),
    { condition = tex.in_mathzone }
  ),
  s(
    { trig = "sq", wordTrig = false, snippetType = "autosnippet" },
    fmta("\\sqrt{<>}", {
      i(0),
    }),
    { condition = tex.in_mathzone }
  ),
  s(
    { trig = "mod", wordTrig = false, snippetType = "autosnippet" },
    fmta("\\mod{<>}", {
      i(0),
    }),
    { condition = tex.in_mathzone }
  ),
  s(
    { trig = "nmod", wordTrig = false, snippetType = "autosnippet", priority = 2000 },
    fmta("\\nmod{<>}", {
      i(0),
    }),
    { condition = tex.in_mathzone }
  ),
  s(
    { trig = "pmod", wordTrig = false, snippetType = "autosnippet", priority = 2000 },
    fmta("\\pmod{<>}", {
      i(0),
    }),
    { condition = tex.in_mathzone }
  ),
}
