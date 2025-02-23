return {
  {
    "HakonHarnes/img-clip.nvim",
    event = "VeryLazy",
    opts = {
      -- add options here
      -- or leave it empty to use the default settings
      default = {
        dir_path = function()
          local ft = vim.bo.filetype
          if ft == "tex" then
            return vim.fn.expand("%:p:h") .. "/figures"
          elseif ft == "markdown" then
            local cur_file = vim.fn.expand("%:p")
            local obs_path = vim.fn.fnamemodify("~/Documents/Obsidian-Vault/", ":p")
            if cur_file:sub(1, #obs_path) == obs_path then
              return vim.fn.expand("%:p:h") .. "/attachments"
            else
              return vim.fn.expand("%:p:h")
            end
          end
        end,
      },
    },
    keys = {
      { "<leader>ip", "<cmd>PasteImage<cr>", desc = "Paste image from system clipboard" },
    },
  },
}
