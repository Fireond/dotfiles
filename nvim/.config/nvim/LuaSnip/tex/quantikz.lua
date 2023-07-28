local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
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
    { trig = "bqu", snippetType = "autosnippet" },
    fmta(
      [[
      \begin{quantikz}
        & <>
      \end{quantikz}
      ]],
      {
        i(0),
      }
    ),
    { condition = tex.in_text }
  ),
  s(
    { trig = "cl", snippetType = "autosnippet" },
    c(1, { sn(nil, { t("\\ctrl{"), i(1), t("}") }), sn(nil, { t("\\ctrl["), i(1), t("]{"), i(2), t("}") }) }),
    { condition = tex.in_quantikz }
  ),
  s(
    { trig = "ocl", snippetType = "autosnippet", priority = 2000 },
    c(1, { sn(nil, { t("\\octrl{"), i(1), t("}") }), sn(nil, { t("\\octrl["), i(1), t("]{"), i(2), t("}") }) }),
    { condition = tex.in_quantikz }
  ),
  s(
    { trig = "tar", snippetType = "autosnippet" },
    c(1, { sn(nil, { t("\\targ{"), i(1), t("}") }), sn(nil, { t("\\targX{"), i(1), t("}") }) }),
    { condition = tex.in_quantikz }
  ),
  s(
    { trig = "gate", snippetType = "autosnippet" },
    c(1, { sn(nil, { t("\\gate{"), i(1), t("}") }), sn(nil, { t("\\gate["), i(1), t("]{"), i(2), t("}") }) }),
    { condition = tex.in_quantikz }
  ),
  s(
    { trig = "g(%a)", regTrig = true, wordTrig = false, snippetType = "autosnippet" },
    fmta("\\gate{<>}", {
      f(function(_, snip)
        return snip.captures[1]
      end),
    }),
    { condition = tex.in_quantikz }
  ),
  s(
    { trig = "wire", snippetType = "autosnippet" },
    c(1, { sn(nil, { t("\\wire["), i(1), t("]{"), i(2), t("}") }), sn(nil, { t("\\wire{"), i(1), t("}") }) }),
    { condition = tex.in_quantikz }
  ),
  s(
    { trig = "mt", snippetType = "autosnippet" },
    c(1, { sn(nil, { t("\\meter{"), i(1), t("}") }), sn(nil, { t("\\meter["), i(1), t("]{"), i(2), t("}") }) }),
    { condition = tex.in_quantikz }
  ),
  s(
    { trig = "phase", snippetType = "autosnippet" },
    fmta("\\phase{<>}", {
      i(0),
    }),
    { condition = tex.in_quantikz }
  ),
  s(
    { trig = "swap", snippetType = "autosnippet" },
    fmta("\\swap{<>}", {
      i(0),
    }),
    { condition = tex.in_quantikz }
  ),
  s(
    { trig = "ls", snippetType = "autosnippet" },
    c(1, { sn(nil, { t("\\lstick{"), i(1), t("}") }), sn(nil, { t("\\lstick["), i(1), t("]{"), i(2), t("}") }) }),
    { condition = tex.in_quantikz }
  ),
  s(
    { trig = "rs", snippetType = "autosnippet" },
    c(1, { sn(nil, { t("\\rstick{"), i(1), t("}") }), sn(nil, { t("\\rstick["), i(1), t("]{"), i(2), t("}") }) }),
    { condition = tex.in_quantikz }
  ),
  s(
    { trig = "group", snippetType = "autosnippet" },
    fmta("\\gategroup[<>,steps=<>]{<>}", {
      i(1),
      i(2),
      i(0),
    }),
    { condition = tex.in_quantikz }
  ),
  s(
    { trig = "slice", snippetType = "autosnippet" },
    fmta("\\slice{<>}", {
      i(0),
    }),
    { condition = tex.in_quantikz }
  ),
  s(
    { trig = "push", snippetType = "autosnippet" },
    fmta("\\push{<>}", {
      i(0),
    }),
    { condition = tex.in_quantikz }
  ),
  s(
    { trig = "ms", snippetType = "autosnippet" },
    c(1, {
      sn(nil, { t("\\measure{"), i(1), t("}") }),
      sn(nil, { t("\\measuretab{"), i(1), t("}") }),
    }),
    { condition = tex.in_quantikz }
  ),
  s(
    { trig = "ket", snippetType = "autosnippet" },
    fmta("\\ket{<>}", {
      i(0),
    }),
    { condition = tex.in_quantikz }
  ),
  s(
    { trig = "bra", snippetType = "autosnippet" },
    fmta("\\bra{<>}", {
      i(0),
    }),
    { condition = tex.in_quantikz }
  ),
  s({ trig = "alp", snippetType = "autosnippet", wordTrig = false }, {
    t("\\alpha"),
  }, { condition = tex.in_quantikz }),
  s({ trig = "Alp", snippetType = "autosnippet", wordTrig = false }, {
    t("\\Alpha"),
  }, { condition = tex.in_quantikz }),
  s({ trig = "beta", snippetType = "autosnippet", wordTrig = false }, {
    t("\\beta"),
  }, { condition = tex.in_quantikz }),
  s({ trig = "Beta", snippetType = "autosnippet", wordTrig = false }, {
    t("\\Beta"),
  }, { condition = tex.in_quantikz }),
  s({ trig = "gam", snippetType = "autosnippet", wordTrig = false }, {
    t("\\gamma"),
  }, { condition = tex.in_quantikz }),
  s({ trig = "Gam", snippetType = "autosnippet", wordTrig = false }, {
    t("\\Gamma"),
  }, { condition = tex.in_quantikz }),
  s({ trig = "del", snippetType = "autosnippet", wordTrig = false }, {
    t("\\delta"),
  }, { condition = tex.in_quantikz }),
  s({ trig = "Del", snippetType = "autosnippet", wordTrig = false }, {
    t("\\Delta"),
  }, { condition = tex.in_quantikz }),
  s({ trig = "eps", snippetType = "autosnippet", wordTrig = false }, {
    t("\\epsilon"),
  }, { condition = tex.in_quantikz }),
  s({ trig = "vps", snippetType = "autosnippet", wordTrig = false }, {
    t("\\varepsilon"),
  }, { condition = tex.in_quantikz }),
  s({ trig = "Eps", snippetType = "autosnippet", wordTrig = false }, {
    t("\\Epsilon"),
  }, { condition = tex.in_quantikz }),
  s({ trig = "zeta", snippetType = "autosnippet", wordTrig = false }, {
    t("\\zeta"),
  }, { condition = tex.in_quantikz }),
  s({ trig = "Zeta", snippetType = "autosnippet", wordTrig = false }, {
    t("\\Zeta"),
  }, { condition = tex.in_quantikz }),
  s({ trig = "eta", snippetType = "autosnippet", wordTrig = false }, {
    t("\\eta"),
  }, { condition = tex.in_quantikz }),
  s({ trig = "Eta", snippetType = "autosnippet", wordTrig = false }, {
    t("\\Eta"),
  }, { condition = tex.in_quantikz }),
  s({ trig = "the", snippetType = "autosnippet", wordTrig = false }, {
    t("\\theta"),
  }, { condition = tex.in_quantikz }),
  s({ trig = "The", snippetType = "autosnippet", wordTrig = false }, {
    t("\\Theta"),
  }, { condition = tex.in_quantikz }),
  s({ trig = "iot", snippetType = "autosnippet", wordTrig = false }, {
    t("\\iota"),
  }, { condition = tex.in_quantikz }),
  s({ trig = "Iot", snippetType = "autosnippet", wordTrig = false }, {
    t("\\Iota"),
  }, { condition = tex.in_quantikz }),
  s({ trig = "kap", snippetType = "autosnippet", wordTrig = false }, {
    t("\\kappa"),
  }, { condition = tex.in_quantikz }),
  s({ trig = "Kap", snippetType = "autosnippet", wordTrig = false }, {
    t("\\Kappa"),
  }, { condition = tex.in_quantikz }),
  s({ trig = "lam", snippetType = "autosnippet", wordTrig = false }, {
    t("\\lambda"),
  }, { condition = tex.in_quantikz }),
  s({ trig = "Lam", snippetType = "autosnippet", wordTrig = false }, {
    t("\\Lambda"),
  }, { condition = tex.in_quantikz }),
  s({ trig = "mu", snippetType = "autosnippet", wordTrig = false }, {
    t("\\mu"),
  }, { condition = tex.in_quantikz }),
  s({ trig = "Mu", snippetType = "autosnippet", wordTrig = false }, {
    t("\\Mu"),
  }, { condition = tex.in_quantikz }),
  s({ trig = "nu", snippetType = "autosnippet", wordTrig = false }, {
    t("\\nu"),
  }, { condition = tex.in_quantikz }),
  s({ trig = "Nu", snippetType = "autosnippet", wordTrig = false }, {
    t("\\Nu"),
  }, { condition = tex.in_quantikz }),
  -- s({ trig = "xi", snippetType = "autosnippet", wordTrig = false }, {
  --   t("\\xi"),
  -- }, { condition = tex.in_quantikz }),
  -- s({ trig = "Xi", snippetType = "autosnippet", wordTrig = false }, {
  --   t("\\Xi"),
  -- }, { condition = tex.in_quantikz }),
  s({ trig = "omi", snippetType = "autosnippet", wordTrig = false }, {
    t("\\omicron"),
  }, { condition = tex.in_quantikz }),
  s({ trig = "pi", snippetType = "autosnippet", wordTrig = false }, {
    t("\\pi"),
  }, { condition = tex.in_quantikz }),
  s({ trig = "\\pii", snippetType = "autosnippet", wordTrig = false, priority = 2000 }, {
    t("p_i"),
  }, { condition = tex.in_quantikz }),
  s({ trig = "Pi", snippetType = "autosnippet", wordTrig = false }, {
    t("\\Pi"),
  }, { condition = tex.in_quantikz }),
  s({ trig = "rho", snippetType = "autosnippet", wordTrig = false }, {
    t("\\rho"),
  }, { condition = tex.in_quantikz }),
  s({ trig = "Rho", snippetType = "autosnippet", wordTrig = false }, {
    t("\\Rho"),
  }, { condition = tex.in_quantikz }),
  s({ trig = "sig", snippetType = "autosnippet", wordTrig = false }, {
    t("\\sigma"),
  }, { condition = tex.in_quantikz }),
  s({ trig = "Sig", snippetType = "autosnippet", wordTrig = false }, {
    t("\\Sigma"),
  }, { condition = tex.in_quantikz }),
  s({ trig = "tau", snippetType = "autosnippet", wordTrig = false }, {
    t("\\tau"),
  }, { condition = tex.in_quantikz }),
  s({ trig = "Tau", snippetType = "autosnippet", wordTrig = false }, {
    t("\\Tau"),
  }, { condition = tex.in_quantikz }),
  s({ trig = "ups", snippetType = "autosnippet", wordTrig = false }, {
    t("\\ups"),
  }, { condition = tex.in_quantikz }),
  s({ trig = "Ups", snippetType = "autosnippet", wordTrig = false }, {
    t("\\Ups"),
  }, { condition = tex.in_quantikz }),
  s({ trig = "phi", snippetType = "autosnippet", wordTrig = false }, {
    t("\\phi"),
  }, { condition = tex.in_quantikz }),
  s({ trig = "Phi", snippetType = "autosnippet", wordTrig = false }, {
    t("\\Phi"),
  }, { condition = tex.in_quantikz }),
  s({ trig = "vhi", snippetType = "autosnippet", wordTrig = false }, {
    t("\\varphi"),
  }, { condition = tex.in_quantikz }),
  s({ trig = "Vhi", snippetType = "autosnippet", wordTrig = false }, {
    t("\\Varphi"),
  }, { condition = tex.in_quantikz }),
  s({ trig = "chi", snippetType = "autosnippet", wordTrig = false }, {
    t("\\chi"),
  }, { condition = tex.in_quantikz }),
  s({ trig = "Chi", snippetType = "autosnippet", wordTrig = false }, {
    t("\\Chi"),
  }, { condition = tex.in_quantikz }),
  s({ trig = "psi", snippetType = "autosnippet", wordTrig = false }, {
    t("\\psi"),
  }, { condition = tex.in_quantikz }),
  s({ trig = "Psi", snippetType = "autosnippet", wordTrig = false }, {
    t("\\Psi"),
  }, { condition = tex.in_quantikz }),
  s({ trig = "ome", snippetType = "autosnippet", wordTrig = false }, {
    t("\\omega"),
  }, { condition = tex.in_quantikz }),
  s({ trig = "Ome", snippetType = "autosnippet", wordTrig = false }, {
    t("\\Omega"),
  }, { condition = tex.in_quantikz }),
}
