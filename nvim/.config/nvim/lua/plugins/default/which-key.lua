return {
  {
    "folke/which-key.nvim",
    config = function(_, opts)
      local wk = require("which-key")
      wk.setup(opts)
      local keymaps = {
        mode = { "n", "v" },
        ["m"] = { name = "+surround" },
        ["]"] = { name = "+next" },
        ["["] = { name = "+prev" },
        ["<leader><tab>"] = { name = "+tabs" },
        ["<leader>c"] = { name = "+code" },
        ["<leader>f"] = { name = "+file/find" },
        ["<leader>q"] = { name = "+quit/session" },
        ["<leader>g"] = { name = "+go to" },
        ["<leader>s"] = { name = "+search" },
        ["<leader>u"] = { name = "+ui" },
        ["<leader>x"] = { name = "+diagnostics/quickfix" },
        ["<leader>l"] = { name = "+jupyter" },
        ["<leader>sn"] = { name = "+noice" },
        ["<leader>p"] = { name = "+preview" },
      }
      wk.register(keymaps)
    end,
    opts = {
      triggers_blacklist = {
        -- list of mode / prefixes that should never be hooked by WhichKey
        -- this is mostly relevant for key maps that start with a native binding
        -- most people should not need to change this
        i = { "f", "j", "k" },
        v = { "f", "j", "k" },
      },
    },
  },
}
