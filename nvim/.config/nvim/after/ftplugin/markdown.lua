vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.wo.foldmethod = "expr"

vim.treesitter.language.register("latex", "tikz")
