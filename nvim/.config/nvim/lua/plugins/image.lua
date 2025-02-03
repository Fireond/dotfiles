return {
  {
    "vhyrro/luarocks.nvim",
    cond = not (vim.g.neovide or false),
    priority = 1001, -- this plugin needs to run before anything else
    opts = {
      rocks = { "magick" },
    },
  },
  {
    "3rd/image.nvim",
    cond = not (vim.g.neovide or false),
    dependencies = { "luarocks.nvim" },
    opts = {
      integrations = {
        markdown = {
          only_render_image_at_cursor = false,
        },
      },
      window_overlap_clear_enabled = true, -- toggles images when windows are overlapped
    },
  },
  {
    "fireond/mdmath.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
    opts = {},
  },
}
