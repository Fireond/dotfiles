return {
  {
    "folke/snacks.nvim",
    keys = {
      {
        "<c-/>",
        function()
          Snacks.terminal(nil, { cwd = vim.fn.expand("%:p:h") })
        end,
        desc = "Toggle Terminal",
      },
      {
        "]]",
        function()
          Snacks.words.jump(vim.v.count1)
        end,
        desc = "Next Reference",
        mode = { "n", "t" },
      },
      {
        "[[",
        function()
          Snacks.words.jump(-vim.v.count1)
        end,
        desc = "Prev Reference",
        mode = { "n", "t" },
      },
    },
  },
}
