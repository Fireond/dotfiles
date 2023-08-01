return {
  {
    "f3fora/nvim-texlabconfig",
    config = true,
    -- enabled = false,
    build = "go build -o ~/.bin",
    ft = "tex",
    keys = {
      { "<leader>pb", "<cmd>TexlabBuild<cr>", desc = "Texlab build" },
      { "<leader>pt", "<cmd>TexlabForward<cr>", desc = "Texlab forward" },
    },
  },
}
