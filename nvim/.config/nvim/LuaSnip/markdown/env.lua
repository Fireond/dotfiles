local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local d = ls.dynamic_node
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
  s({ trig = ";b", snippetType = "autosnippet" }, fmta("**<>**", i(1)), { condition = tex.in_text_md }),
  s({ trig = "；b", snippetType = "autosnippet" }, fmta("**<>**", i(1)), { condition = tex.in_text_md }),
  s({ trig = ";t", snippetType = "autosnippet" }, fmta("*<>*", i(1)), { condition = tex.in_text_md }),
  s({ trig = "；t", snippetType = "autosnippet" }, fmta("*<>*", i(1)), { condition = tex.in_text_md }),
  s({ trig = ";h", snippetType = "autosnippet" }, fmta("- [ ] <>", i(0)), { condition = tex.in_text_md }),
  s({ trig = "；h", snippetType = "autosnippet" }, fmta("- [ ] <>", i(0)), { condition = tex.in_text_md }),
  s({ trig = ";H", snippetType = "autosnippet" }, fmta("- [x] <>", i(0)), { condition = tex.in_text_md }),
  s({ trig = "；H", snippetType = "autosnippet" }, fmta("- [x] <>", i(0)), { condition = tex.in_text_md }),
  s(
    { trig = ";c", snippetType = "autosnippet" },
    fmta(
      [[
      ```<>
      <>
      ```
      ]],
      { i(1), i(0) }
    ),
    { condition = tex.in_text_md }
  ),
  s(
    { trig = ";d", snippetType = "autosnippet" },
    fmta(
      [[
<<!--
<>
-->>
      ]],
      { i(0) }
    ),
    { condition = tex.in_text_md }
  ),
  s(
    { trig = "；d", snippetType = "autosnippet" },
    fmta(
      [[
<<!--
<>
-->>
      ]],
      { i(0) }
    ),
    { condition = tex.in_text_md }
  ),
  s({ trig = "ii", snippetType = "autosnippet" }, fmta("$<>$", i(1)), { condition = tex.in_text_md }),
  s({ trig = "dd", snippetType = "autosnippet" }, fmta("$$\n<>\n$$", i(1)), { condition = tex.in_text_md }),
  s(
    { trig = "bff", snippetType = "autosnippet" },
    fmta(
      [[
**Proof.**
<>
$\square$
      ]],
      {
        i(0),
      }
    ),
    { condition = line_begin * tex.in_text }
  ),
  s(
    { trig = "beg", snippetType = "autosnippet" },
    fmta(
      [[
[!<>] <>
<>
      ]],
      {
        i(1),
        rep(1),
        i(0),
      }
    ),
    { condition = line_begin }
  ),
  s(
    { trig = "case", snippetType = "autosnippet" },
    fmta(
      [[
      \begin{cases}
        <>
      \end{cases}
      ]],
      {
        i(0),
      }
    ),
    { condition = tex.in_mathzone_md }
  ),
  s(
    { trig = "bal", snippetType = "autosnippet" },
    fmta(
      [[
      \begin{aligned}
        <>
      \end{aligned}
      ]],
      {
        i(0),
      }
    ),
    { condition = tex.in_mathzone_md }
  ),
  s(
    { trig = "bal", snippetType = "autosnippet", priority = 2000 },
    fmta(
      [[
      \begin{aligned}
        <>
      \end{aligned}
      ]],
      {
        d(1, get_visual),
      }
    ),
    { condition = tex.in_mathzone_md }
  ),
}
