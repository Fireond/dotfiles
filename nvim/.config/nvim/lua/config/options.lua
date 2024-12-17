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

-- Knap Config

vim.g.knap_settings = {
  delay = 500,
}

-- jukit Config

vim.g.jukit_mappings = 0
vim.spell = false

-- prettier Config
vim.g.lazyvim_prettier_needs_config = true
