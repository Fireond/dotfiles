return {
  {
    "nvim-neo-tree/neo-tree.nvim",
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
}
