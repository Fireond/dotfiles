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
local get_visual = function(args, parent)
  if #parent.snippet.env.SELECT_RAW > 0 then
    return sn(nil, i(1, parent.snippet.env.SELECT_RAW))
  else -- If SELECT_RAW is empty, return a blank insert node
    return sn(nil, i(1))
  end
end

return {
  s(
    "link",
    fmta("[<>](<>)", { i(1), f(function(_, snip)
      return snip.env.TM_SELECTED_TEXT[1] or {}
    end, {}) })
  ),
  s({ trig = ";b", snippetType = "autosnippet" }, fmta("**<>**", i(1))),
  s({ trig = ";t", snippetType = "autosnippet" }, fmta("*<>*", i(1))),
  s({ trig = "xx", snippetType = "autosnippet" }, fmta("$\\times$", {})),
  s(
    { trig = ";c", snippetType = "autosnippet" },
    fmta(
      [[
      ```<>
      <>
      ```
      ]],
      { i(1), i(0) }
    )
  ),
}
