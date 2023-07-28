return {
  {
    "toppair/peek.nvim",
    build = "deno task --quiet build:fast",
    ft = "markdown",
    keys = {
      { "<leader>pm", "<cmd>lua require'peek'.open()<cr>", desc = "Open peek preview" },
    },
  },
}
