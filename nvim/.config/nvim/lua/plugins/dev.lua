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
        if cur_path:sub(1, #math_path) == math_path then
          return true
        elseif cur_path:sub(1, #target_path) == target_path then
          return true
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
