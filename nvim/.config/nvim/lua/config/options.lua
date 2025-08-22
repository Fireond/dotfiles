vim.lsp.log.set_level(vim.log.levels.OFF)
vim.opt.timeoutlen = 150
vim.opt.spell = true
vim.opt.spelllang = { "en", "cjk" }
vim.opt.spelloptions = "camel"
vim.opt.backup = false
vim.g.maplocalleader = " "
vim.g.mapleader = " "

local indent = 2
-- vim.opt.expandtab = true -- Use spaces instead of tabs
vim.opt.softtabstop = indent -- Number of spaces that a <Tab> counts for while performing editing operations
vim.opt.tabstop = indent -- Number of spaces tabs count for
vim.opt.shiftwidth = indent -- Size of an indent

if vim.g.neovide then
  require("config.neovide")
end
