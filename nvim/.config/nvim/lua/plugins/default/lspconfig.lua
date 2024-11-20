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
              -- build = {
              --   executable = "xelatex",
              --   args = {
              --     "-pdf",
              --     "-interaction=nonstopmode",
              --     "-synctex=1",
              --     "%f",
              --   },
              --   onSave = false,
              -- },
              -- rootDirectory = "..",
              -- forwardSearch = {
              --   executable = "sioyek",
              --   args = {
              --     -- "--reuse-window",
              --     -- "--inverse-search",
              --     -- [[nvim-texlabconfig -file %1 -line %2 -server ]] .. vim.v.servername,
              --     -- "--forward-search-file",
              --     -- "%f",
              --     -- "--forward-search-line",
              --     -- "%l",
              --     -- "%p",
              --     "--reuse-window",
              --     "--execute-command",
              --     "toggle_synctex", -- Open Sioyek in synctex mode.
              --     "--inverse-search",
              --     [[nvim-texlabconfig -file %%%1 -line %%%2 -server ]] .. vim.v.servername,
              --     "--forward-search-file",
              --     "%f",
              --     "--forward-search-line",
              --     "%l",
              --     "%p",
              --   },
              -- },
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
