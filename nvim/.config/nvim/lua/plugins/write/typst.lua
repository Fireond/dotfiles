return {
  {
    "chomosuke/typst-preview.nvim",
    ft = "typst",
    version = "1.*",
    opts = {
      dependencies_bin = {
        ["tinymist"] = "tinymist",
      },
      -- open_cmd = "firefox %s -P typst-preview --class typst-preview",
    },
  },
}
