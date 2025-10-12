return {
  {
    "toppair/peek.nvim",
    event = { "VeryLazy" },
    build = "deno task --quiet build:fast",
    config = function()
      require("peek").setup()
      vim.api.nvim_create_user_command("PeekOpen", require("peek").open, {})
      vim.api.nvim_create_user_command("PeekClose", require("peek").close, {})
    end,
  },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    enabled = true,
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-mini/mini.nvim" }, -- if you use the mini.nvim suite
    opts = {
      callout = {
        theorem = { raw = "[!THEOREM]", rendered = " Theorem", highlight = "RenderMarkdownWarn" },
        problem = { raw = "[!PROBLEM]", rendered = " Problem", highlight = "RenderMarkdownInfo" },
      },
      heading = {
        icons = { " 󰼏 ", " 󰎨 ", " 󰼑 ", " 󰎲 ", " 󰼓 ", " 󰎴 " },
        border = true,
        render_modes = true, -- keep rendering while inserting
      },
      pipe_table = {
        alignment_indicator = "─",
        border = { "╭", "┬", "╮", "├", "┼", "┤", "╰", "┴", "╯", "│", "─" },
      },
      anti_conceal = {
        -- disabled_modes = { "n" },
        ignore = {
          bullet = true, -- render bullet in insert mode
          head_border = true,
          head_background = true,
        },
      },
      html = {
        comment = {
          conceal = false,
        },
      },
    },
  },
  -- {
  --   "Noname672/markdown-preview.nvim",
  --   enabled = false,
  --   cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
  --   ft = { "markdown" },
  --   build = function()
  --     vim.fn["mkdp#util#install"]()
  --   end,
  --   config = function()
  --     vim.g.mkdp_browser = "firefox"
  --     vim.g.mkdp_preview_options.katex_preamble = [[\newcommand{\d}{\,\mathrm{d}}]]
  --     vim.g.mkdp_auto_close = 0
  --   end,
  -- },
  -- {
  --   "fireond/number-markdown.nvim",
  --   ft = "markdown",
  --   opts = {
  --     start_level = 2,
  --     auto_update = function()
  --       local cur_path = vim.fn.expand("%:p")
  --       local target_path = vim.fn.expand("~/Documents/Obsidian-Vault")
  --       local math_path = vim.fn.expand("~/Documents/Obsidian-Vault/02-math")
  --       if cur_path:sub(1, #math_path) == math_path then
  --         return false
  --       elseif cur_path:sub(1, #target_path) == target_path then
  --         return true
  --       else
  --         return false
  --       end
  --     end,
  --   },
  --   keys = {
  --     {
  --       "<leader>uH",
  --       function()
  --         require("number-markdown").toggle_auto_update()
  --       end,
  --       desc = "Toggle auto number headers",
  --     },
  --   },
  -- },
}
