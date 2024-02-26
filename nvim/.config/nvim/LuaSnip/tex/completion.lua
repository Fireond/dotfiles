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
  -- s(
  --   { trig = "(%a);", regTrig = true, wordTrig = false, snippetType = "autosnippet" },
  --   fmta("\\hat{<>}", {
  --     f(function(_, snip)
  --       return snip.captures[1]
  --     end),
  --   }),
  --   { condition = tex.in_mathzone }
  -- ),
  s(
    { trig = "([%a%)%]%}])(%d)", regTrig = true, wordTrig = false, snippetType = "autosnippet" },
    fmta("<>_<>", {
      f(function(_, snip)
        return snip.captures[1]
      end),
      f(function(_, snip)
        return snip.captures[2]
      end),
    }),
    { condition = tex.in_mathzone }
  ),
  s(
    { trig = "([%a%)%]%}])_(%d)(%d)", regTrig = true, wordTrig = false, snippetType = "autosnippet" },
    fmta("<>_{<><>}", {
      f(function(_, snip)
        return snip.captures[1]
      end),
      f(function(_, snip)
        return snip.captures[2]
      end),
      f(function(_, snip)
        return snip.captures[3]
      end),
    }),
    { condition = tex.in_mathzone }
  ),
  s(
    { trig = "([%a%)%]%}])(%a)%2", regTrig = true, wordTrig = false, snippetType = "autosnippet", priority = 100 },
    fmta("<>_<>", {
      f(function(_, snip)
        return snip.captures[1]
      end),
      f(function(_, snip)
        return snip.captures[2]
      end),
    }),
    { condition = tex.in_mathzone }
  ),
  s(
    { trig = "([%a%)%]%}])_(%a)(%a)%3", regTrig = true, wordTrig = false, snippetType = "autosnippet", priority = 2000 },
    fmta("<>_{<><>}", {
      f(function(_, snip)
        return snip.captures[1]
      end),
      f(function(_, snip)
        return snip.captures[2]
      end),
      f(function(_, snip)
        return snip.captures[3]
      end),
    }),
    { condition = tex.in_mathzone }
  ),
  s(
    { trig = "(%d+)/", regTrig = true, wordTrig = false, snippetType = "autosnippet", priority = 100 },
    fmta("\\frac{<>}{<>}", {
      f(function(_, snip)
        return snip.captures[1]
      end),
      i(1),
    }),
    { condition = tex.in_mathzone }
  ),
  s(
    { trig = "(%a)/", regTrig = true, wordTrig = false, snippetType = "autosnippet", priority = 100 },
    fmta("\\frac{<>}{<>}", {
      f(function(_, snip)
        return snip.captures[1]
      end),
      i(1),
    }),
    { condition = tex.in_mathzone }
  ),
  s(
    { trig = "%((.+)%)/", regTrig = true, wordTrig = false, snippetType = "autosnippet" },
    fmta("\\frac{<>}{<>}", {
      f(function(_, snip)
        return snip.captures[1]
      end),
      i(1),
    }),
    { condition = tex.in_mathzone }
  ),
  s(
    { trig = "(\\%a+)/", regTrig = true, wordTrig = false, snippetType = "autosnippet", priority = 2000 },
    fmta("\\frac{<>}{<>}", {
      f(function(_, snip)
        return snip.captures[1]
      end),
      i(1),
    }),
    { condition = tex.in_mathzone }
  ),
  s(
    { trig = "(\\%a+%{%a+%})/", regTrig = true, wordTrig = false, snippetType = "autosnippet", priority = 3000 },
    fmta("\\frac{<>}{<>}", {
      f(function(_, snip)
        return snip.captures[1]
      end),
      i(1),
    }),
    { condition = tex.in_mathzone }
  ),
  s(
    { trig = "\\%)(%a)", regTrig = true, wordTrig = false, snippetType = "autosnippet", priority = 2000 },
    fmta("\\) <>", {
      f(function(_, snip)
        return snip.captures[1]
      end),
    })
  ),
  s(
    { trig = "\\](%a)", regTrig = true, wordTrig = false, snippetType = "autosnippet", priority = 2000 },
    fmta("\\] <>", {
      f(function(_, snip)
        return snip.captures[1]
      end),
    })
  ),
  s(
    { trig = "lim", regTrig = true, wordTrig = false, snippetType = "autosnippet" },
    fmta("\\lim_{<>}", {
      i(1),
    }),
    { condition = tex.in_mathzone }
  ),
  s(
    { trig = "lsup", regTrig = true, wordTrig = false, snippetType = "autosnippet", priority = 2000 },
    fmta("\\limsup_{<>}", {
      i(1),
    }),
    { condition = tex.in_mathzone }
  ),
  s(
    { trig = "linf", regTrig = true, wordTrig = false, snippetType = "autosnippet" },
    fmta("\\liminf_{<>}", {
      i(1),
    }),
    { condition = tex.in_mathzone }
  ),
  -- s(
  --   { trig = "sum", regTrig = true, wordTrig = false, snippetType = "autosnippet" },
  --   fmta("\\sum\\limits_{<>}^{<>}", {
  --     i(1),
  --     i(1),
  --   }),
  --   { condition = tex.in_mathzone }
  -- ),
  s(
    { trig = "sum", snippetType = "autosnippet" },
    c(1, {
      sn(nil, { t("\\sum_{"), i(1), t("} ") }),
      sn(nil, { t("\\sum_{"), i(1), t("}^{"), i(2), t("} ") }),
    }),
    { condition = tex.in_mathzone }
  ),
  s(
    { trig = "pd", snippetType = "autosnippet" },
    c(1, {
      sn(nil, { t("\\prod_{"), i(1), t("} ") }),
      sn(nil, { t("\\prod_{"), i(1), t("}^{"), i(2), t("} ") }),
    }),
    { condition = tex.in_mathzone }
  ),
  s(
    { trig = "bot", regTrig = true, wordTrig = false, snippetType = "autosnippet", priority = 2000 },
    fmta("\\bigotimes_{<>}^{<>}", {
      i(1),
      i(2),
    }),
    { condition = tex.in_mathzone }
  ),
  s(
    { trig = "bcap", regTrig = true, wordTrig = false, snippetType = "autosnippet", priority = 2000 },
    fmta("\\bigcap_{<>}^{<>}", {
      i(1),
      i(2),
    }),
    { condition = tex.in_mathzone }
  ),
  s(
    { trig = "bcup", regTrig = true, wordTrig = false, snippetType = "autosnippet", priority = 2000 },
    fmta("\\bigcup_{<>}^{<>}", {
      i(1),
      i(2),
    }),
    { condition = tex.in_mathzone }
  ),
  s(
    { trig = "blor", regTrig = true, wordTrig = false, snippetType = "autosnippet", priority = 2000 },
    fmta("\\bigvee_{<>}^{<>}", {
      i(1),
      i(2),
    }),
    { condition = tex.in_mathzone }
  ),
  s(
    { trig = "band", regTrig = true, wordTrig = false, snippetType = "autosnippet", priority = 2000 },
    fmta("\\bigwedge_{<>}^{<>}", {
      i(1),
      i(2),
    }),
    { condition = tex.in_mathzone }
  ),
  s(
    { trig = "bscap", regTrig = true, wordTrig = false, snippetType = "autosnippet", priority = 2000 },
    fmta("\\bigsqcap_{<>}^{<>}", {
      i(1),
      i(2),
    }),
    { condition = tex.in_mathzone }
  ),
  s(
    { trig = "bscup", regTrig = true, wordTrig = false, snippetType = "autosnippet", priority = 2000 },
    fmta("\\bigsqcup_{<>}^{<>}", {
      i(1),
      i(2),
    }),
    { condition = tex.in_mathzone }
  ),
  s(
    { trig = "pt", regTrig = true, wordTrig = false, snippetType = "autosnippet" },
    fmta("\\int <> \\d P", {
      i(1),
    }),
    { condition = tex.in_mathzone }
  ),
  s(
    { trig = "mt", regTrig = true, wordTrig = false, snippetType = "autosnippet" },
    fmta("\\int <> d\\mu", {
      i(1),
    }),
    { condition = tex.in_mathzone }
  ),
  s(
    { trig = "int", regTrig = true, wordTrig = false, snippetType = "autosnippet" },
    fmta("\\int_{<>}^{<>} <> \\d <>", {
      i(1),
      i(2),
      i(3),
      i(4),
    }),
    { condition = tex.in_mathzone }
  ),
  s(
    { trig = "2int", regTrig = true, wordTrig = false, snippetType = "autosnippet", priority = 2000 },
    fmta("\\int_{<>}^{<>}\\int_{<>}^{<>} <> \\d <>\\d <>", {
      i(1),
      i(2),
      i(3),
      i(4),
      i(5),
      i(6),
      i(7),
    }),
    { condition = tex.in_mathzone }
  ),
  s(
    { trig = "iint", regTrig = true, wordTrig = false, snippetType = "autosnippet", priority = 2000 },
    fmta("\\iint_{<>}^{<>} <> \\d <>", {
      i(1, "-\\infty"),
      i(2, "\\infty"),
      i(3),
      i(4),
    }),
    { condition = tex.in_mathzone }
  ),
  s(
    { trig = "lint", regTrig = true, wordTrig = false, snippetType = "autosnippet", priority = 2000 },
    fmta("\\int_{<>} <> \\d <>", {
      i(1, "\\infty"),
      i(2),
      i(3),
    }),
    { condition = tex.in_mathzone }
  ),
}
