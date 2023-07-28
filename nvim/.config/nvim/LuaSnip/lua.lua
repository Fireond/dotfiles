local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local extras = require("luasnip.extras")
local l = extras.lambda
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local rep = require("luasnip.extras").rep
local line_begin = require("luasnip.extras.expand_conditions").line_begin

return {
  s(
    "localreq",
    fmt('local {} = require("{}")', {
      l(l._1:match("[^.]*$"):gsub("[^%a]+", "_"), 1),
      i(1, "module"),
    })
  ),
  s(
    { trig = "add", snippetType = "autosnippet" },
    fmta('["<>"] = "<>",', {
      i(1),
      i(2),
    })
  ),
  ls.parser.parse_snippet("lm", "local M = {}\n\n$1 \n\nreturn M"),
  s(
    { trig = "optsnip", snippetType = "autosnippet" },
    fmta(
      [[
      s(
        { trig = "<>", snippetType = "autosnippet" },
        c(1, { sn(nil, { t("\\<>{"), i(1), t("}") }), sn(nil, { t("\\<>["), i(1), t("]{"), i(2), t("}") }) }),
        { condition = tex.<> }
      ),
      ]],
      { i(1), rep(1), rep(1), c(2, { t("in_quantikz"), t("in_mathzone") }) }
    ),
    { condition = line_begin }
  ),
  s(
    { trig = "starsnip", snippetType = "autosnippet" },
    fmta(
      [[
      s(
        { trig = "<>", snippetType = "autosnippet" },
        c(1, { sn(nil, { t("\\<>{"), i(1), t("}") }), sn(nil, { t("\\<>*{"), i(1), t("}") }) }),
        { condition = tex.<> }
      ),
      ]],
      { i(1), rep(1), rep(1), c(2, { t("in_quantikz"), t("in_mathzone") }) }
    ),
    { condition = line_begin }
  ),
  s(
    { trig = "fmtasnip", snippetType = "autosnippet" },
    fmta(
      [[
      s({ trig = "<>", snippetType = "autosnippet" },
        fmta("\\<>{<<>>}", {
        <>
        }),
       { condition = tex.<> }),
      ]],
      { i(1), rep(1), i(2, "i(0),"), c(3, { t("in_mathzone"), t("in_quantikz") }) }
    ),
    { condition = line_begin }
  ),
  s(
    { trig = "tsnip", snippetType = "autosnippet" },
    fmta(
      [[
      s({ trig = "<>", snippetType = "autosnippet" }, {
        t("\\<>"),
      }, { condition = tex.<> }),
      ]],
      { i(1), rep(1), c(2, { t("in_mathzone"), t("in_quantikz") }) }
    ),
    { condition = line_begin }
  ),
}
