return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        typst_lsp = {
          settings = {
            typst_lsp = {},
          },
        },
        texlab = {
          mason = false,
          settings = {
            texlab = {
              diagnostics = { ignoredPatterns = { "^Overfull", "^Underfull" } },
              latexFormatter = "latexindent",
              latexindent = {
                ["local"] = "/Users/hanyu_yan/Documents/Latex/latexindent.yaml",
              },
            },
          },
        },
      },
    },
  },
}
