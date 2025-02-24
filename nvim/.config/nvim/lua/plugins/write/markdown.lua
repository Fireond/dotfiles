return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    enabled = true,
    dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.nvim" }, -- if you use the mini.nvim suite
    opts = {
      callout = {
        theorem = { raw = "[!THEOREM]", rendered = " Theorem", highlight = "RenderMarkdownWarn" },
        problem = { raw = "[!PROBLEM]", rendered = " Problem", highlight = "RenderMarkdownInfo" },
      },
    },
  },
  {
    "Noname672/markdown-preview.nvim",
    enabled = false,
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = function()
      vim.fn["mkdp#util#install"]()
    end,
    config = function()
      vim.g.mkdp_browser = "firefox"
      vim.g.mkdp_preview_options.katex_preamble = [[\newcommand{\d}{\,\mathrm{d}}]]
      vim.g.mkdp_auto_close = 0
    end,
  },
  -- {
  --   "fireond/number-markdown.nvim",
  --   ft = "markdown",
  --   opts = {
  --     start_level = 2,
  --     auto_update = function()
  --       local cur_path = vim.fn.expand("%:p")
  --       local target_path = vim.fn.expand("~/Documents/Obsidian-Vault")
  --       if cur_path:sub(1, #target_path) == target_path then
  --         return true
  --       else
  --         return false
  --       end
  --     end,
  --   },
  -- },
}
