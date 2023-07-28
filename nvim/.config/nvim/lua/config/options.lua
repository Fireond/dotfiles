vim.opt.timeoutlen = 150
vim.opt.spell = true
vim.opt.spelllang = { "en", "cjk" }
vim.opt.spelloptions = "camel"
vim.opt.backup = false
vim.g.tex_flavor = "latex"

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

-- ============= --
-- Vimtex Config --
-- ============= --
-- vim.g.vimtex_view_method = "skim"
-- vim.g.vimtex_quickfix_mode = 0
-- vim.g.vimtex_quickfix_open_on_warning = 0
-- vim.g.vimtex_compiler_silent = 1
-- vim.g.vimtex_view_general_options = "-r @line @pdf @tex"
-- vim.g.vimtex_indent_enabled = 1
-- vim.g.vimtex_imaps_enabled = 0
-- -- Custom conceasl
-- -- vim.g.vimtex_syntax_conceal_disable = 0
-- vim.cmd([[
-- let g:vimtex_syntax_custom_cmds = [
--   \ {'name': 'limits', 'mathmode': 1, 'concealchar': ' '},
--   \ {'name': 'dd', 'mathmode': 1, 'concealchar': 'd'},
--   \ {'name': 'cp', 'mathmode': 1, 'concealchar': 'x'},
--   \ {'name': 'order', 'mathmode': 1, 'concealchar': 'O'},
--   \ {'name': 'unlhd', 'mathmode': 1, 'concealchar': '⊴'},
--   \ {'name': 'rank', 'mathmode': 1, 'concealchar': 'r'},
--   \ {'name': 'vb', 'mathmode': 1, 'conceal': 1, 'argstyle': 'boldunder'},
--   \]
-- ]])
-- vim.cmd([[
-- let g:vimtex_syntax_custom_cmds_with_concealed_delims = [
--   \ {'name': 'ket', 'mathmode': 1, 'cchar_open': '|', 'cchar_close': '>'},
--   \ {'name': 'bra', 'mathmode': 1, 'cchar_open': '<', 'cchar_close': '|'},
--   \ {'name': 'abs', 'mathmode': 1, 'cchar_open': '|', 'cchar_close': '|'},
--   \ {'name': 'norm', 'mathmode': 1, 'cchar_open': '⫼', 'cchar_close': '⫼'},
--   \ {'name': 'ceil', 'mathmode': 1, 'cchar_open': '⌈', 'cchar_close': '⌉'},
--   \ {'name': 'floor', 'mathmode': 1, 'cchar_open': '⌊', 'cchar_close': '⌋'},
--   \]
-- ]])
--
