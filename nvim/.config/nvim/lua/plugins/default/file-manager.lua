return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    enabled = false,
    lazy = true,
    opts = {
      filesystem = {
        window = {
          mappings = {
            ["o"] = "system_open",
          },
        },
        commands = {
          system_open = function(state)
            local node = state.tree:get_node()
            local path = node:get_id()
            vim.api.nvim_command("silent !open -g " .. path)
          end,
        },
      },
    },
  },
  {
    "nvim/mini.nvim",
    -- opts = {
    --   options = {
    --     use_as_default_explorer = true,
    --   },
    -- },
    keys = {
      {
        "<leader>e",
        function()
          require("mini.files").open(vim.api.nvim_buf_get_name(0), true)
        end,
        desc = "Open mini.files (Directory of Current File)",
      },
      {
        "<leader>E",
        function()
          require("mini.files").open(vim.uv.cwd(), true)
        end,
        desc = "Open mini.files (cwd)",
      },
    },
  },
}
