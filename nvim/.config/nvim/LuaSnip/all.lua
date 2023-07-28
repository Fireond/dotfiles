local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local d = ls.dynamic_node
local c = ls.choice_node
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local rep = require("luasnip.extras").rep
return {
  s(
    "date",
    f(function()
      return os.date("%D - %H:%M")
    end)
  ),
  s("choicenode", c(1, { t("choice 1"), t("choice 2"), t("choice 3") })),
}
