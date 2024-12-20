return {
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      local latexindent_path = ""
      if vim.loop.os_uname().sysname == "Darwin" then
        latexindent_path = "/Users/hanyu_yan/Documents/Latex/latexindent.yaml"
      elseif vim.loop.os_uname().sysname == "Linux" then
        latexindent_path = "/home/fireond/Documents/Latex/latexindent.yaml"
      end
      opts.servers = {
        texlab = {
          mason = false,
          settings = {
            texlab = {
              diagnostics = { ignoredPatterns = { "^Overfull", "^Underfull" } },
              latexFormatter = "latexindent",
              latexindent = {
                ["local"] = latexindent_path,
              },
            },
          },
        },
      }
      return opts
    end,
  },
}
