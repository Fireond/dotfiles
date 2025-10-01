return {
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        ["json"] = { "jq" },
        ["jsonc"] = { "jq" },
      },
    },
    -- opts = function(_, opts)
    --   local latexindent_path = ""
    --   if vim.loop.os_uname().sysname == "Darwin" then
    --     latexindent_path = "/Users/hanyu_yan/Documents/Latex/latexindent.yaml"
    --   elseif vim.loop.os_uname().sysname == "Linux" then
    --     latexindent_path = "/home/fireond/Documents/Latex/latexindent.yaml"
    --   end
    --   opts.formatters_by_ft = opts.formatters_by_ft or {}
    --   opts.formatters_by_ft.tex = { "latexindent" }
    --   opts.formatters_by_ft.json = { "jq" }
    --   opts.formatters_by_ft.jsonc = { "jq" }
    --   opts.formatters = opts.formatters or {}
    --   opts.formatters.latexindent = {
    --     command = "/home/fireond/.local/share/latexindent/latexindent.pl",
    --     args = { "-l", latexindent_path, "$FILENAME" },
    --   }
    --   return opts
    -- end,
  },
}
