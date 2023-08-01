return {
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    opts = {
      shade_terminals = false,
    },
    keys = {
      { "<leader>t", "<cmd>ToggleTerm dir='%:p:h'<cr>" },
      { "<leader>tt", "<cmd>ToggleTerm dir='%:p:h'<cr>", desc = "Horizontal Terminal" },
      { "<leader>tf", "<cmd>ToggleTerm dir='%:p:h' direction=float<cr>", desc = "Float Terminal" },
    },
  },
}
