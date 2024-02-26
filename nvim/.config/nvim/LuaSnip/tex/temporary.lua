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
  -- s({ trig = "sp", snippetType = "autosnippet" }, fmta("\\hat{\\$}", {}), { condition = tex.in_mathzone }),
  -- s({ trig = "T", snippetType = "autosnippet" }, fmta("\\mathcal{T}", {}), { condition = tex.in_mathzone }),
  -- s({ trig = "tv", snippetType = "autosnippet" }, fmta("\\mathrm{TV}", {}), { condition = tex.in_mathzone }),
  -- s({ trig = "ce", snippetType = "autosnippet" }, fmta("\\mathrm{couple}", {}), { condition = tex.in_mathzone }),
  -- s({ trig = "mix", snippetType = "autosnippet" }, fmta("\\mathrm{mix}", {}), { condition = tex.in_mathzone }),
  s({ trig = "\\psii", snippetType = "autosnippet", priority = 3000 }, {
    t("\\psi_i"),
  }, { condition = tex.in_mathzone }),
  s({ trig = "FF", snippetType = "autosnippet", priority = 3000 }, {
    t("\\mathcal{F}"),
  }, { condition = tex.in_mathzone }),
  s({ trig = "SS", snippetType = "autosnippet", priority = 3000 }, {
    t("\\mathcal{S}"),
  }, { condition = tex.in_mathzone }),
  s(
    { trig = "EE", snippetType = "autosnippet" },
    fmta("\\E_{\\sigma} \\ab[ <> ]", {
      i(1),
    }),
    { condition = tex.in_mathzone }
  ),
  s({ trig = "\\varphii", snippetType = "autosnippet", priority = 3000 }, {
    t("\\varphi_i"),
  }, { condition = tex.in_mathzone }),
  s({ trig = "cc", snippetType = "autosnippet" }, {
    t("^c"),
  }, { condition = tex.in_mathzone }),
  s({ trig = "--", snippetType = "autosnippet", priority = 2000 }, {
    t("^-"),
  }, { condition = tex.in_mathzone }),
  s({ trig = "\\oplust", snippetType = "autosnippet", priority = 2000 }, {
    t("\\OPT"),
  }, { condition = tex.in_mathzone }),
  s({ trig = "++", snippetType = "autosnippet" }, {
    t("^+"),
  }, { condition = tex.in_mathzone }),
  s({ trig = "ii", snippetType = "autosnippet" }, {
    t("\\int"),
  }, { condition = tex.in_mathzone }),
  s({ trig = "ed", snippetType = "autosnippet" }, {
    t("\\ed"),
  }, { condition = tex.in_mathzone }),
  s({ trig = "cas", snippetType = "autosnippet", priority = 2000 }, {
    t("\\cas"),
  }, { condition = tex.in_mathzone }),
  s({ trig = "lr", snippetType = "autosnippet" }, {
    t("\\leftrightarrow"),
  }, { condition = tex.in_mathzone }),
  s({ trig = "sa", snippetType = "autosnippet" }, {
    t("s_A"),
  }, { condition = tex.in_mathzone }),
  s({ trig = "sb", snippetType = "autosnippet" }, {
    t("s_B"),
  }, { condition = tex.in_mathzone }),
  s(
    { trig = "(%a);", regTrig = true, wordTrig = false, snippetType = "autosnippet" },
    fmta("\\hat{<>}", {
      f(function(_, snip)
        return snip.captures[1]
      end),
    }),
    { condition = tex.in_mathzone }
  ),
  s({ trig = "\\psi;", snippetType = "autosnippet", priority = 3000 }, {
    t("\\tilde{\\psi}"),
  }, { condition = tex.in_mathzone }),
  s({ trig = "\\varphi;", snippetType = "autosnippet", priority = 3000 }, {
    t("\\tilde{\\varphi}"),
  }, { condition = tex.in_mathzone }),
  s({ trig = "IS", snippetType = "autosnippet", priority = 3000 }, {
    t("\\mathcal{IS}"),
  }, { condition = tex.in_mathzone }),
}
