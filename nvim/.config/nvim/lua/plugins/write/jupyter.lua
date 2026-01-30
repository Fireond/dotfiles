local python = vim.fn.exepath("python3")
return {
  -- {
  --   "kiyoon/jupynium.nvim",
  --   -- ft = "python",
  --   build = function()
  --     -- 自动从当前环境找 python
  --     if python == "" then
  --       error("Python3 not found in PATH")
  --     end
  --     vim.fn.system({ python, "-m", "pip", "install", "." })
  --   end,
  --   opts = {
  --     jupyter_command = { python, "-m", "jupyter" },
  --     shortsighted = true,
  --     firefox_profile_name = "default-release",
  --     notify = {
  --       ignore = {
  --         "download_ipynb",
  --         -- "error_download_ipynb",
  --         -- "attach_and_init",
  --         -- "error_close_main_page",
  --         -- "notebook_closed",
  --       },
  --     },
  --   },
  --   keys = {
  --     { "<leader>Ko", "<cmd>JupyniumStartAndAttachToServer<cr>", desc = "Jupynium Start and Attach" },
  --     { "<leader>Ks", "<cmd>JupyniumStartSync<cr>", desc = "Jupynium Sync" },
  --     { "<leader>Kz", "<cmd>JupyniumShortsightedToggle<cr>", desc = "Jupynium Short Sighted" },
  --     { "<leader>Kc", "<cmd>JupyniumKernelSelect<cr>", desc = "Jupynium Change Kernel" },
  --     { "<leader>KO", "<cmd>JupyniumStartAndAttachToServerInTerminal<cr>", desc = "Jupynium Start In Terminal" },
  --     { "<leader>Kj", "<cmd>JupyniumScrollDown<cr>", desc = "Jupynium Scroll Down" },
  --     { "<leader>Kk", "<cmd>JupyniumScrollUp<cr>", desc = "Jupynium Scroll Up" },
  --   },
  -- },
  {
    "ajbucci/ipynb.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "neovim/nvim-lspconfig",
      -- "nvim-tree/nvim-web-devicons", -- optional, for language icons
      "folke/snacks.nvim", -- optional, for inline images
    },
    opts = {},
  },
}
