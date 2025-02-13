local enable_image = false
return {
  {
    "vhyrro/luarocks.nvim",
    enabled = enable_image,
    cond = not (vim.g.neovide or false),
    priority = 1001, -- this plugin needs to run before anything else
    opts = {
      rocks = { "magick" },
    },
  },
  {
    "3rd/image.nvim",
    enabled = enable_image,
    cond = not (vim.g.neovide or false),
    dependencies = { "luarocks.nvim" },
    opts = {
      integrations = {
        markdown = {
          only_render_image_at_cursor = true,
        },
      },
      window_overlap_clear_enabled = false, -- toggles images when windows are overlapped
    },
  },
  {
    "fireond/mdmath.nvim",
    enabled = enable_image,
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
    opts = {
      hide_on_insert = false,
    },
  },
}
