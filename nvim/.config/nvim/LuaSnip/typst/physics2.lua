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
    return sn(nil, t(parent.snippet.env.SELECT_RAW))
  else -- If SELECT_RAW is empty, return a blank insert node
    return sn(nil, i(1))
  end
end

return {
  s(
    { trig = "bra", wordTrig = false, snippetType = "autosnippet", priority = 1000 },
    fmta("|<> angle.r", {
      i(1),
    }),
    { condition = tex.in_mathzone }
  ),
  s(
    { trig = "ket", wordTrig = false, snippetType = "autosnippet", priority = 1000 },
    fmta("angle.r <>|", {
      i(1),
    }),
    { condition = tex.in_mathzone }
  ),
  s({ trig = "ar", snippetType = "autosnippet" }, {
    t("angle.r"),
  }, { condition = tex.in_mathzone }),
  s({ trig = "al", snippetType = "autosnippet" }, {
    t("angle.l"),
  }, { condition = tex.in_mathzone }),
  s(
    { trig = "bk", snippetType = "autosnippet" },
    c(1, {
      sn(nil, { t("\\braket{"), i(1), t("}{"), i(2), t("}") }),
      sn(nil, { t("\\braket[3]{"), i(1), t("}{"), i(2), t("}{"), i(3), t("}") }),
    }),
    { condition = tex.in_mathzone }
  ),
  s(
    { trig = "ev", snippetType = "autosnippet" },
    fmta("\\braket[1]{<>}", {
      i(1),
    }),
    { condition = tex.in_mathzone }
  ),
  s(
    { trig = "kb", snippetType = "autosnippet" },
    c(1, {
      sn(nil, { t("\\ketbra{"), i(1), t("}{"), i(2), t("}") }),
      sn(nil, { t("\\ketbra{"), i(1), t("}["), i(2), t("]{"), i(3), t("}") }),
    }),
    { condition = tex.in_mathzone }
  ),
}
