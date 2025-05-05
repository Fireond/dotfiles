return {
  {
    dir = "~/Documents/Codes/number-markdown.nvim/",
    ft = "markdown",
    opts = {
      start_level = 2,
      auto_update = function()
        local cur_path = vim.fn.expand("%:p")
        local target_path = vim.fn.expand("~/Documents/Obsidian-Vault")
        local math_path = vim.fn.expand("~/Documents/Obsidian-Vault/02-math")
        local disable_path = vim.fn.expand("~/Documents/Obsidian-Vault/02-math/group-nutshell/")
        if cur_path:sub(1, #disable_path) == disable_path then
          return false
        elseif cur_path:sub(1, #target_path) == target_path then
          return false
        else
          return false
        end
      end,
    },
    keys = {
      {
        "<leader>uH",
        function()
          require("number-markdown").toggle_auto_update()
        end,
        desc = "Toggle auto number headers",
      },
    },
  },
}
