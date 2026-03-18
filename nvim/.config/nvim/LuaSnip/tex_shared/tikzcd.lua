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
    return sn(nil, i(1, parent.snippet.env.SELECT_RAW))
  else -- If SELECT_RAW is empty, return a blank insert node
    return sn(nil, i(1))
  end
end

return {
  s(
    { trig = "ad", snippetType = "autosnippet" },
    fmta(
      [[
      \arrow[d, "<>"]
      ]],
      {
        i(1),
      }
    ),
    { condition = tex.in_tikzcd }
  ),
  s(
    { trig = "arr", snippetType = "autosnippet" },
    fmta(
      [[
      \arrow[r, "<>"]
      ]],
      {
        i(1),
      }
    ),
    { condition = tex.in_tikzcd }
  ),
  s(
    { trig = "au", snippetType = "autosnippet" },
    fmta(
      [[
      \arrow[u, "<>"]
      ]],
      {
        i(1),
      }
    ),
    { condition = tex.in_tikzcd }
  ),
  s(
    { trig = "ard", snippetType = "autosnippet" },
    fmta(
      [[
      \arrow[rd, "<>"]
      ]],
      {
        i(1),
      }
    ),
    { condition = tex.in_tikzcd }
  ),

  s(
    { trig = "chn", snippetType = "autosnippet", priority = 2000 },
    fmta(
      [[
      \cdots \arrow[r] <>_{n+1} \arrow[r, "<>"] & <>_{n} \arrow[r, "<>"] & <>_{n-1} \arrow[d, "<>"] \\
      ]],
      {
        i(1),
        i(2),
        rep(1),
        rep(2),
        rep(1),
        rep(2),
      }
    ),
    { condition = tex.in_env("tikzcd") }
  ),
}
