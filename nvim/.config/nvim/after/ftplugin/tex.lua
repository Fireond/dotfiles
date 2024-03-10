vim.opt.conceallevel = 2

vim.keymap.set({ "n", "i" }, "<a-f>", "<cmd>VimtexView<cr>", { desc = "Vimtex: View" })
vim.keymap.set({ "n", "i" }, "<a-b>", "<cmd>VimtexCompile<cr>", { desc = "Vimtex: Compile" })
