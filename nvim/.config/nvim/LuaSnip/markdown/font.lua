local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local i = ls.insert_node
local d = ls.dynamic_node
local fmta = require("luasnip.extras.fmt").fmta
local rep = require("luasnip.extras").rep
local line_begin = require("luasnip.extras.expand_conditions").line_begin
local get_visual = function(args, parent)
  if #parent.snippet.env.SELECT_RAW > 0 then
    return sn(nil, t(parent.snippet.env.SELECT_RAW))
  else -- If SELECT_RAW is empty, return a blank insert node
    return sn(nil, i(1))
  end
end

local tex = require("util.latex")

return {
  s(
    { trig = "msf", snippetType = "autosnippet", priority = 2000 },
    fmta("\\mathsf{<>}", {
      d(1, get_visual),
    }),
    { condition = tex.in_mathzone_md }
  ),
  s(
    { trig = "msf", snippetType = "autosnippet" },
    fmta("\\mathsf{<>}", {
      i(0),
    }),
    { condition = tex.in_mathzone_md }
  ),
  s(
    { trig = "bf", snippetType = "autosnippet" },
    fmta("\\mathbf{<>}", {
      i(1),
    }),
    { condition = tex.in_mathzone_md }
  ),
  s(
    { trig = "cal", snippetType = "autosnippet", priority = 2000 },
    fmta("\\mathcal{<>}", {
      d(1, get_visual),
    }),
    { condition = tex.in_mathzone_md }
  ),
  s(
    { trig = "cal", snippetType = "autosnippet" },
    fmta("\\mathcal{<>}", {
      i(0),
    }),
    { condition = tex.in_mathzone_md }
  ),
  s(
    { trig = "scr", snippetType = "autosnippet", priority = 2000 },
    fmta("\\mathscr{<>}", {
      d(1, get_visual),
    }),
    { condition = tex.in_mathzone_md }
  ),
  s(
    { trig = "scr", snippetType = "autosnippet" },
    fmta("\\mathscr{<>}", {
      i(0),
    }),
    { condition = tex.in_mathzone_md }
  ),
  s(
    { trig = "mbb", snippetType = "autosnippet", priority = 2000 },
    fmta("\\mathbb{<>}", {
      d(1, get_visual),
    }),
    { condition = tex.in_mathzone_md }
  ),
  s(
    { trig = "mbb", snippetType = "autosnippet" },
    fmta("\\mathbb{<>}", {
      i(0),
    }),
    { condition = tex.in_mathzone_md }
  ),
  s(
    { trig = "mrm", snippetType = "autosnippet", priority = 2000 },
    fmta("\\mathrm{<>}", {
      d(1, get_visual),
    }),
    { condition = tex.in_mathzone_md }
  ),
  s(
    { trig = "mrm", snippetType = "autosnippet" },
    fmta("\\mathrm{<>}", {
      i(0),
    }),
    { condition = tex.in_mathzone_md }
  ),
  s(
    { trig = "qq", wordTrig = false, snippetType = "autosnippet" },
    fmta("\\text{<>}", {
      i(1),
    }),
    { condition = tex.in_mathzone_md }
  ),
}
