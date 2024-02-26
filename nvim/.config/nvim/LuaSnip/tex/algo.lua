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
  s(
    { trig = "bal", snippetType = "autosnippet" },
    fmta(
      [[
    \begin{algorithm}
      \caption{<>}
      \label{algo:<>}
      \begin{algorithmic}[1]
        \Require <>
      \end{algorithmic}

    \end{algorithm}
      ]],
      {
        i(1),
        rep(1),
        i(0),
      }
    ),
    { condition = line_begin }
  ),
  s({ trig = "ss", snippetType = "autosnippet" }, {
    t("\\State "),
  }, { condition = tex.in_algo * line_begin }),
  s({ trig = "sx", snippetType = "autosnippet" }, {
    t("\\Statex "),
  }, { condition = tex.in_algo * line_begin }),
  s({ trig = "return", snippetType = "autosnippet" }, {
    t("\\Return"),
  }, { condition = tex.in_algo }),
  s(
    { trig = "while", snippetType = "autosnippet" },
    fmta(
      [[
      \While{<>}
        <>
      \EndWhile
      ]],
      {
        i(1),
        i(0),
      }
    ),
    { condition = tex.in_algo * line_begin }
  ),
  s(
    { trig = "for", snippetType = "autosnippet" },
    fmta(
      [[
      \For{<>}
        <>
      \EndFor
      ]],
      {
        i(1),
        i(0),
      }
    ),
    { condition = tex.in_algo * line_begin }
  ),
  s(
    { trig = "if", snippetType = "autosnippet" },
    fmta(
      [[
      \If{<>}
        <>
      \EndIf
      ]],
      {
        i(1),
        i(0),
      }
    ),
    { condition = tex.in_algo * line_begin }
  ),
  s(
    { trig = "elif", snippetType = "autosnippet" },
    fmta(
      [[
      \ElsIf{<>}
        <>
      ]],
      {
        i(1),
        i(0),
      }
    ),
    { condition = tex.in_algo * line_begin }
  ),
  s(
    { trig = "else", snippetType = "autosnippet" },
    fmta(
      [[
      \Else
        <>
      ]],
      {
        i(0),
      }
    ),
    { condition = tex.in_algo * line_begin }
  ),
  s(
    { trig = "fn", snippetType = "autosnippet" },
    fmta(
      [[
      \Function{<>}{<>}
        <>
      \EndFunction
      ]],
      {
        i(1),
        i(2),
        i(0),
      }
    ),
    { condition = tex.in_algo * line_begin }
  ),
}
