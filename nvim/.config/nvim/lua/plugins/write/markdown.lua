return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    enabled = false,
    opts = function()
      return {}
    end,
  },
  {
    "epwalsh/obsidian.nvim",
    version = "*", -- recommended, use latest release instead of latest commit
    lazy = true,
    ft = "markdown",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "hrsh7th/nvim-cmp",
    },
    opts = {
      workspaces = {
        {
          name = "Root",
          path = "/home/fireond/Documents/Obsidian-Vault",
        },
        {
          name = "Topology",
          path = "/home/fireond/Documents/Obsidian-Vault/Topology",
        },
      },
      completion = {
        min_chars = 0,
      },
      ui = {
        checkboxes = {
          [" "] = { char = "󰄱", hl_group = "ObsidianTodo" },
          ["x"] = { char = "", hl_group = "ObsidianDone" },
        },
      },
    },
    keys = {
      { "<leader>no", "<cmd>ObsidianOpen<cr>", desc = "Open Obsidian" },
      { "<leader>nt", "<cmd>ObsidianTags<cr>", desc = "Open Obsidian" },
    },
  },
  {
    "saghen/blink.cmp",
    dependencies = {
      { "saghen/blink.compat", lazy = true, version = false },
    },
    opts = {
      sources = {
        -- providers = {
        --   obsidian = { name = "obsidian", module = "blink.compat.source" },
        --   obsidian_new = { name = "obsidian_new", module = "blink.compat.source" },
        --   obsidian_tags = { name = "obsidian_tags", module = "blink.compat.source" },
        -- },
        compat = { "obsidian", "obsidian_new", "obsidian_tags" },
        providers = {
          obsidian = {
            kind = "Obsidian",
            score_offset = 30,
          },
          obsidian_new = {
            kind = "Obsidian",
            async = true,
          },
          obsidian_tags = {
            kind = "Obsidian",
            score_offset = 30,
            async = true,
          },
        },
      },
    },
    -- opts_extend = { "sources.default" },
  },
  {
    "fireond/mdmath.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
    opts = {
      -- hide_on_insert = false,
    },
  },
}
