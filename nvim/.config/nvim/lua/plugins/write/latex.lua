return {
  {
    "ryleelyman/latex.nvim",
    enabled = false,
    opts = {
      conceals = {
        add = {
          ["colon"] = ":",
          ["coloneqq"] = "≔",
          ["pdv"] = "∂",
          ["odv"] = "d",
          ["sqrt"] = "√",
          ["|"] = "⫴",
          ["{"] = "{",
          ["}"] = "}",
          ["nmid"] = "∤",
          ["implies"] = "⇨",

          -- hide
          [","] = "",
          [" "] = "",
          ["vb"] = "",
          ["va"] = "",
          ["qq"] = "",
          ["mathrm"] = "",
          ["displaystyle"] = "",
          ["limits"] = "",
          ["ab"] = "",
          ["ab*"] = "",
          -- ["bra"] = "",
          -- ["ket"] = "",
          -- ["braket"] = "",
          -- ["ketbra"] = "",
        },
      },
      imaps = {
        enabled = false,
        -- add = { ["\\emptyset"] = "1", ["\\Alpha"] = "A" },
        -- default_leader = ";",
      },
      surrounds = { enabled = false },
    },
    ft = "tex",
  },

  -- inverse serach for LaTeX
  {
    "f3fora/nvim-texlabconfig",
    config = true,
    build = "go build",
    ft = "tex",
  },
}
