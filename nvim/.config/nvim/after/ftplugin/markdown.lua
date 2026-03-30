vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.wo.foldmethod = "expr"
vim.opt.expandtab = false
vim.opt.softtabstop = 0

vim.treesitter.language.register("latex", "tikz")
