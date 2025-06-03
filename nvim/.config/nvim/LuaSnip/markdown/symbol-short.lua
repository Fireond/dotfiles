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
  s({ trig = "...", wordTrig = false, snippetType = "autosnippet" }, {
    t("\\dots"),
  }, { condition = tex.in_mathzone_md }),
  s({ trig = "c.", wordTrig = false, snippetType = "autosnippet" }, {
    t("\\cdot"),
  }, { condition = tex.in_mathzone_md }),
  s({ trig = "\\cdot.", wordTrig = false, snippetType = "autosnippet" }, {
    t("\\cdots"),
  }, { condition = tex.in_mathzone_md }),
  s({ trig = "v.", wordTrig = false, snippetType = "autosnippet" }, {
    t("\\vdot"),
  }, { condition = tex.in_mathzone_md }),
  s({ trig = "\\vdot.", wordTrig = false, snippetType = "autosnippet" }, {
    t("\\vdots"),
  }, { condition = tex.in_mathzone_md }),
  s({ trig = "iff", wordTrig = false, snippetType = "autosnippet" }, {
    t("\\iff"),
  }, { condition = tex.in_mathzone_md }),
  s({ trig = "inn", wordTrig = false, snippetType = "autosnippet" }, {
    t("\\in"),
  }, { condition = tex.in_mathzone_md }),
  s({ trig = "notin", wordTrig = false, snippetType = "autosnippet" }, {
    t("not\\in"),
  }, { condition = tex.in_mathzone_md }),
  s({ trig = "aa", wordTrig = false, snippetType = "autosnippet" }, {
    t("\\forall"),
  }, { condition = tex.in_mathzone_md }),
  s({ trig = "ee", wordTrig = false, snippetType = "autosnippet" }, {
    t("\\exists"),
  }, { condition = tex.in_mathzone_md }),
  s({ trig = "!=", wordTrig = false, snippetType = "autosnippet" }, {
    t("\\neq"),
  }, { condition = tex.in_mathzone_md }),
  s({ trig = "==", wordTrig = false, snippetType = "autosnippet" }, {
    t("&="),
  }, { condition = line_begin }),
  s({ trig = "==", wordTrig = false, snippetType = "autosnippet" }, {
    t("&="),
  }, { condition = tex.in_mathzone }),
  s({ trig = "\\leq=", wordTrig = false, snippetType = "autosnippet" }, {
    t("&\\leq"),
  }, { condition = tex.in_mathzone_md }),
  s({ trig = "\\geq=", wordTrig = false, snippetType = "autosnippet" }, {
    t("&\\geq"),
  }, { condition = tex.in_mathzone_md }),
  s({ trig = "~=", wordTrig = false, snippetType = "autosnippet" }, {
    t("\\approx"),
  }, { condition = tex.in_mathzone_md }),
  s({ trig = "~~", wordTrig = false, snippetType = "autosnippet" }, {
    t("\\sim"),
  }, { condition = tex.in_mathzone_md }),
  s({ trig = ">=", wordTrig = false, snippetType = "autosnippet" }, {
    t("\\geq"),
  }, { condition = tex.in_mathzone_md }),
  s({ trig = "<=", wordTrig = false, snippetType = "autosnippet" }, {
    t("\\leq"),
  }, { condition = tex.in_mathzone_md }),
  s({ trig = ">>", wordTrig = false, snippetType = "autosnippet" }, {
    t("\\gg"),
  }, { condition = tex.in_mathzone_md }),
  s({ trig = "<<", wordTrig = false, snippetType = "autosnippet" }, {
    t("\\ll"),
  }, { condition = tex.in_mathzone_md }),
  s({ trig = "cp", wordTrig = false, snippetType = "autosnippet" }, {
    t("\\cp"),
  }, { condition = tex.in_mathzone_md }),
  s({ trig = "get", wordTrig = false, snippetType = "autosnippet" }, {
    t("\\gets"),
  }, { condition = tex.in_mathzone_md }),
  s({ trig = "to", wordTrig = false, snippetType = "autosnippet" }, {
    t("\\to"),
  }, { condition = tex.in_mathzone_md }),
  s({ trig = "mto", wordTrig = false, snippetType = "autosnippet", priority = 1001 }, {
    t("\\mapsto"),
  }, { condition = tex.in_mathzone_md }),
  s({ trig = "\\\\\\", wordTrig = false, snippetType = "autosnippet" }, {
    t("\\setminus"),
  }, { condition = tex.in_mathzone_md }),
  s({ trig = "||", wordTrig = false, snippetType = "autosnippet" }, {
    t("\\mid"),
  }, { condition = tex.in_mathzone_md }),
  s({ trig = "mid", wordTrig = false, snippetType = "autosnippet" }, {
    t("\\mid"),
  }, { condition = tex.in_mathzone_md }),
  s({ trig = "nmid", wordTrig = false, snippetType = "autosnippet", priority = 2000 }, {
    t("\\nmid"),
  }, { condition = tex.in_mathzone_md }),
  s({ trig = "sr", wordTrig = false, snippetType = "autosnippet" }, {
    t("^2"),
  }, { condition = tex.in_mathzone_md }),
  s({ trig = "cb", wordTrig = false, snippetType = "autosnippet" }, {
    t("^3"),
  }, { condition = tex.in_mathzone_md }),
  s({ trig = "inv", wordTrig = false, snippetType = "autosnippet" }, {
    t("^{-1}"),
  }, { condition = tex.in_mathzone_md }),
  s({ trig = "**", wordTrig = false, snippetType = "autosnippet" }, {
    t("^*"),
  }, { condition = tex.in_mathzone_md }),
  s({ trig = "  ", wordTrig = false, snippetType = "autosnippet" }, {
    t("\\,"),
  }, { condition = tex.in_mathzone_md }),
  s({ trig = "<>", wordTrig = false, snippetType = "autosnippet" }, {
    t("\\diamond"),
  }, { condition = tex.in_mathzone_md }),
  s({ trig = "+-", wordTrig = false, snippetType = "autosnippet" }, {
    t("\\pm"),
  }, { condition = tex.in_mathzone_md }),
  s({ trig = "-+", wordTrig = false, snippetType = "autosnippet" }, {
    t("\\mp"),
  }, { condition = tex.in_mathzone_md }),
  s({ trig = "rhs", wordTrig = false, snippetType = "autosnippet" }, {
    t("\\mathrm{R.H.S}"),
  }, { condition = tex.in_mathzone_md }),
  s({ trig = "lhs", wordTrig = false, snippetType = "autosnippet" }, {
    t("\\mathrm{L.H.S}"),
  }, { condition = tex.in_mathzone_md }),
  s({ trig = "cap", wordTrig = false, snippetType = "autosnippet" }, {
    t("\\cap"),
  }, { condition = tex.in_mathzone_md }),
  s({ trig = "cup", wordTrig = false, snippetType = "autosnippet" }, {
    t("\\cup"),
  }, { condition = tex.in_mathzone_md }),
  s({ trig = "sub", wordTrig = false, snippetType = "autosnippet" }, {
    t("\\subseteq"),
  }, { condition = tex.in_mathzone_md }),
  s({ trig = "suq", wordTrig = false, snippetType = "autosnippet" }, {
    t("\\supseteq"),
  }, { condition = tex.in_mathzone_md }),
  s({ trig = "oo", wordTrig = false, snippetType = "autosnippet" }, {
    t("\\infty"),
  }, { condition = tex.in_mathzone_md }),
  s({ trig = "tp", wordTrig = false, snippetType = "autosnippet" }, {
    t("^\\top"),
  }, { condition = tex.in_mathzone_md }),
  s({ trig = "dr", wordTrig = false, snippetType = "autosnippet" }, {
    t("^\\dagger"),
  }, { condition = tex.in_mathzone_md }),
  s({ trig = "perp", wordTrig = false, snippetType = "autosnippet" }, {
    t("\\perp"),
  }, { condition = tex.in_mathzone_md }),
  s({ trig = "ss", wordTrig = false, snippetType = "autosnippet" }, {
    t("\\star"),
  }, { condition = tex.in_mathzone_md }),
  s({ trig = "xx", wordTrig = false, snippetType = "autosnippet" }, {
    t("\\times"),
  }, { condition = tex.in_mathzone_md }),
  s({ trig = "=>", wordTrig = false, snippetType = "autosnippet" }, {
    t("\\implies"),
  }, { condition = tex.in_mathzone_md }),
  s({ trig = "llr", wordTrig = false, snippetType = "autosnippet" }, {
    t("\\longleftrightarrow"),
  }, { condition = tex.in_mathzone_md }),
  s({ trig = "up", wordTrig = false, snippetType = "autosnippet" }, {
    t("\\uparrow"),
  }, { condition = tex.in_mathzone_md }),
  s({ trig = "down", wordTrig = false, snippetType = "autosnippet" }, {
    t("\\downarrow"),
  }, { condition = tex.in_mathzone_md }),
  s({ trig = "cir", wordTrig = false, snippetType = "autosnippet" }, {
    t("\\circ"),
  }, { condition = tex.in_mathzone_md }),
  s({ trig = "iso", wordTrig = false, snippetType = "autosnippet" }, {
    t("\\cong"),
  }, { condition = tex.in_mathzone_md }),
  s({ trig = "ihbar", wordTrig = false, snippetType = "autosnippet", priority = 2000 }, {
    t("i\\hbar"),
  }, { condition = tex.in_mathzone_md }),
  s({ trig = "hbar", wordTrig = false, snippetType = "autosnippet", priority = 1500 }, {
    t("\\hbar"),
  }, { condition = tex.in_mathzone_md }),
  s({ trig = "ns", wordTrig = false, snippetType = "autosnippet" }, {
    t("\\unlhd"),
  }, { condition = tex.in_mathzone_md }),
  s({ trig = "eqv", wordTrig = false, snippetType = "autosnippet" }, {
    t("\\equiv"),
  }, { condition = tex.in_mathzone_md }),
  s({ trig = "##", wordTrig = false, snippetType = "autosnippet" }, {
    t("\\#"),
  }, { condition = tex.in_mathzone_md }),
  s({ trig = "ell", wordTrig = false, snippetType = "autosnippet", priority = 2000 }, {
    t("\\ell"),
  }, { condition = tex.in_mathzone_md }),
  s({ trig = "ot", wordTrig = false, snippetType = "autosnippet" }, {
    t("\\otimes"),
  }, { condition = tex.in_mathzone_md }),
  s({ trig = "op", wordTrig = false, snippetType = "autosnippet" }, {
    t("\\oplus"),
  }, { condition = tex.in_mathzone_md }),
  s({ trig = "not", wordTrig = false, snippetType = "autosnippet", priority = 2000 }, {
    t("\\not"),
  }, { condition = tex.in_mathzone_md }),
  s({ trig = "par", wordTrig = false, snippetType = "autosnippet", priority = 2000 }, {
    t("\\partial"),
  }, { condition = tex.in_mathzone_md }),
  s({ trig = "land", snippetType = "autosnippet" }, {
    t("\\land"),
  }, { condition = tex.in_mathzone_md }),
  s({ trig = "lor", snippetType = "autosnippet" }, {
    t("\\lor"),
  }, { condition = tex.in_mathzone_md }),
  s({ trig = "\\tri", snippetType = "autosnippet" }, {
    t("\\triangle"),
  }, { condition = tex.in_mathzone_md }),
  s({ trig = "emp", snippetType = "autosnippet", priority = 2000 }, {
    t("\\emptyset"),
  }, { condition = tex.in_mathzone_md }),
  s({ trig = "po", snippetType = "autosnippet" }, {
    t("\\propto"),
  }, { condition = tex.in_mathzone_md }),
  s({ trig = "neg", snippetType = "autosnippet" }, {
    t("\\neg"),
  }, { condition = tex.in_mathzone_md }),
  s({ trig = "nabla", snippetType = "autosnippet" }, {
    t("\\nabla"),
  }, { condition = tex.in_mathzone_md }),
  s({ trig = "cong", snippetType = "autosnippet" }, {
    t("\\cong"),
  }, { condition = tex.in_mathzone_md }),
  s({ trig = "ii", snippetType = "autosnippet" }, {
    t("\\int"),
  }, { condition = tex.in_mathzone_md }),
  s({ trig = "oii", snippetType = "autosnippet", priority = 2000 }, {
    t("\\oint"),
  }, { condition = tex.in_mathzone_md }),
  s({ trig = "rr", snippetType = "autosnippet" }, {
    t("\\rangle"),
  }, { condition = tex.in_mathzone_md }),
  s({ trig = "ll", snippetType = "autosnippet" }, {
    t("\\langle"),
  }, { condition = tex.in_mathzone_md }),
  s(
    { trig = "b|", wordTrig = false, snippetType = "autosnippet" },
    fmta(
      [[
    \Big|_{<>}
    ]],
      { i(1) }
    ),
    { condition = tex.in_mathzone_md }
  ),
  s(
    { trig = "jk", wordTrig = false, snippetType = "autosnippet" },
    fmta(
      [[
    _{<>}
    ]],
      { i(1) }
    ),
    { condition = tex.in_mathzone_md }
  ),
  s(
    { trig = "kj", wordTrig = false, snippetType = "autosnippet" },
    fmta(
      [[
    ^{<>}
    ]],
      { i(1) }
    ),
    { condition = tex.in_mathzone_md }
  ),
}
