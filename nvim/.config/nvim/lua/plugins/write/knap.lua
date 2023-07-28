return {
  {
    "frabjous/knap",
    enabled = false,
    keys = {
      {
        "<leader>pk",
        function()
          require("knap").toggle_autopreviewing()
        end,
        desc = "Knap toggle auto previewing",
      },
      {
        "<leader>ps",
        function()
          require("knap").forward_jump()
        end,
        desc = "Knap forward jump",
      },
    },
    ft = { "tex", "markdown" },
  },
}
