vim.opt.conceallevel = 2

vim.keymap.set({ "n", "i" }, "<a-f>", "<cmd>TexlabForward<cr>", { desc = "Forward search" })
vim.keymap.set({ "n", "i" }, "<a-c>", function()
  require("util.latex").clean()
end, { desc = "Build" })
