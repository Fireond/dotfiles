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
    { trig = "voo", wordTrig = false, snippetType = "autosnippet" },
    fmta(
      [[
    with self.voiceover(text="<>") as tracker:
        <>
    ]],
      {
        i(1),
        i(0),
      }
    )
  ),
  s(
    { trig = "mte", wordTrig = false },
    fmta(
      [[
      <>_string = "<>"
      <>_tex = MathTex(r"<>", tex_template=myTemplate)
      with self.voiceover(text=<>_string) as tracker:
          self.play(Write(<>_tex))
    ]],
      {
        i(1),
        i(2),
        rep(1),
        i(3),
        rep(1),
        rep(1),
      }
    )
  ),
  s(
    { trig = "text", wordTrig = false },
    fmta(
      [[
      <>_string = "<>"
      <>_text = Text(<>_string)
      with self.voiceover(text=<>_string) as tracker:
          self.play(Write(<>_text), run_time=tracker.duration)
    ]],
      {
        i(1),
        i(2),
        rep(1),
        rep(1),
        rep(1),
        rep(1),
      }
    )
  ),
  s(
    { trig = "spt", wordTrig = false, snippetType = "autosnippet" },
    fmta(
      [[
    self.play(Write(<>), run_time=tracker.duration)
    ]],
      {
        i(0),
      }
    )
  ),
  s(
    { trig = "spd", wordTrig = false, snippetType = "autosnippet" },
    fmta(
      [[
    self.play(FadeOut(<>))
    ]],
      {
        i(0),
      }
    )
  ),
  s(
    { trig = "spp", wordTrig = false, snippetType = "autosnippet" },
    fmta(
      [[
    self.play(<>)
    ]],
      {
        i(0),
      }
    )
  ),
  s(
    { trig = "mtex", wordTrig = false, snippetType = "autosnippet" },
    fmta(
      [[
    <> = MathTex(r"<>", tex_template=myTemplate)
    ]],
      {
        i(1),
        i(0),
      }
    )
  ),
}
