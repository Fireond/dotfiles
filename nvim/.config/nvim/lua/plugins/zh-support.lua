return {
  {
    "rainzm/flash-zh.nvim",
    event = "VeryLazy",
    dependencies = "folke/flash.nvim",
    keys = {
      {
        "S",
        mode = { "n", "x", "o" },
        function()
          require("flash-zh").jump({
            chinese_only = true,
          })
        end,
        desc = "Flash between Chinese",
      },
    },
  },
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {
      highlight = {
        -- backdrop = false,
        -- matches = false,
      },
    },
    keys = {
      {
        "s",
        mode = { "n", "x", "o" },
        function()
          require("flash").jump({
            remote_op = {
              restore = true,
              motion = nil,
            },
          })
        end,
        desc = "Flash",
      },
      { "S", false },
    },
  },
  {
    "pysan3/fcitx5.nvim",
    cond = vim.loop.os_uname().sysname == "Linux",
    opts = {
      imname = {
        norm = "keyboard-us",
        cmd = "keyboard-us",
      },
    },
  },
}
