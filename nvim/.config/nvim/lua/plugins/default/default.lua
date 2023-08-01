return {
  {
    "neovim/nvim-lspconfig",
    init = function()
      local keys = require("lazyvim.plugins.lsp.keymaps").get()
      -- keys[#keys + 1] = { "K", "a<cr><Esc>k$" }
    end,
    opts = {
      setup = {
        clangd = function(_, opts)
          opts.capabilities.offsetEncoding = { "utf-16" }
        end,
      },
    },
  },
  {
    "echasnovski/mini.bufremove",
    keys = {
      {
        "<leader>d",
        function()
          require("mini.bufremove").delete(0, false)
        end,
        desc = "Delete Buffer",
      },
    },
  },
  -- {
  --   "akinsho/bufferline.nvim",
  --   keys = function()
  --     return {}
  --   end,
  -- },
  {
    "nvim-telescope/telescope.nvim",
    keys = {
      { "<leader>gc", false },
      { "<leader>gs", false },
      { "<leader>uC", false },
    },
  },
  -- {
  --   "lewis6991/gitsigns.nvim",
  --   opts = {
  --     on_attach = function()
  --       return {}
  --     end,
  --   },
  -- },
  {
    "echasnovski/mini.surround",
    opts = {
      mappings = {
        add = "ma", -- Add surrounding in Normal and Visual modes
        delete = "md", -- Delete surrounding
        find = "mf", -- Find surrounding (to the right)
        find_left = "mF", -- Find surrounding (to the left)
        highlight = "mh", -- Highlight surrounding
        replace = "mr", -- Replace surrounding
        update_n_lines = "mn", -- Update `n_lines`
      },
    },
    config = function(_, opts)
      require("mini.surround").setup(opts)
    end,
  },
}
