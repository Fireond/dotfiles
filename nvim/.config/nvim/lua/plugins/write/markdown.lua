return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    enabled = false,
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
  {
    "fireond/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    build = "cd app && yarn install",
    init = function()
      vim.g.mkdp_filetypes = { "markdown" }
      vim.g.mkdp_auto_start = 1
      vim.g.mkdp_auto_close = 0
      vim.g.mkdp_combine_preview = 1
      vim.g.mkdp_browser = "firefox"
    end,
    ft = { "markdown" },
  },

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
