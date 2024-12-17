return {
  "lervag/vimtex",
  init = function()
    vim.keymap.set("n", "<localleader>lt", ":call vimtex#fzf#run()<cr>")

    vim.g.vimtex_syntax_conceal_disable = 1
    vim.g.vimtex_mappings_disable = { ["n"] = { "K" } } -- disable `K` as it conflicts with LSP hover
    vim.g.vimtex_quickfix_method = vim.fn.executable("pplatex") == 1 and "pplatex" or "latexlog"
    vim.g.vimtex_compiler_silent = 1
    vim.g.vimtex_compiler_method = "latexmk"

    if vim.loop.os_uname().sysname == "Darwin" then
      vim.g.vimtex_view_method = "skim"
      vim.g.vimtex_view_skim_sync = 1
    elseif vim.loop.os_uname().sysname == "Linux" then
      vim.g.vimtex_view_method = "zathura"
    end
  end,
}
