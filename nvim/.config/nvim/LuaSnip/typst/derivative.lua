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
  -- s(
  --   { trig = "pv", snippetType = "autosnippet" },
  --   fmta("\\pdv[order={<>}]{<>}{<>}", {
  --     i(0),
  --     i(1),
  --     i(2),
  --   }),
  --   { condition = tex.in_mathzone }
  -- ),
  s(
    { trig = "pv", snippetType = "autosnippet" },
    c(1, {
      sn(nil, { t("\\pdv{"), i(1), t("}{"), i(2), t("}") }),
      sn(nil, { t("\\pdv[order={"), i(3), t("}]{"), i(1), t("}{"), i(2), t("}") }),
    }),
    { condition = tex.in_mathzone }
  ),
  s(
    { trig = "ov", snippetType = "autosnippet" },
    c(1, {
      sn(nil, { t("\\odv{"), i(1), t("}{"), i(2), t("}") }),
      sn(nil, { t("\\odv[order={"), i(3), t("}]{"), i(1), t("}{"), i(2), t("}") }),
    }),
    { condition = tex.in_mathzone }
  ),
  s(
    { trig = "ov", snippetType = "autosnippet" },
    fmta("\\odv[order={<>}]{<>}{<>}", {
      i(0),
      i(1),
      i(2),
    }),
    { condition = tex.in_mathzone }
  ),
}
