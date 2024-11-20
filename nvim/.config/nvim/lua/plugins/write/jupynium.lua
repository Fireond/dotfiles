return {
  {
    "kiyoon/jupynium.nvim",
    ft = "python",
    build = "conda run --no-capture-output -n QCX pip install .",
    opts = {
      python_host = { "conda", "run", "--no-capture-output", "-n", "QCX", "python" },
      jupyter_command = { "conda", "run", "--no-capture-output", "-n", "QCX", "jupyter" },
    },
    shortsighted = true,
    notify = {
      ignore = {
        "download_ipynb",
        -- "error_download_ipynb",
        -- "attach_and_init",
        -- "error_close_main_page",
        -- "notebook_closed",
      },
    },
    keys = {
      { "<leader>Ko", "<cmd>JupyniumStartAndAttachToServer<cr>", desc = "Jupynium Start and Attach" },
      { "<leader>Ks", "<cmd>JupyniumStartSync<cr>", desc = "Jupynium Sync" },
      { "<leader>Kz", "<cmd>JupyniumShortsightedToggle<cr>", desc = "Jupynium Short Sighted" },
      { "<leader>Kc", "<cmd>JupyniumKernelSelect<cr>", desc = "Jupynium Change Kernel" },
      { "<leader>KO", "<cmd>JupyniumStartAndAttachToServerInTerminal<cr>", desc = "Jupynium Start In Terminal" },
      { "<leader>Kj", "<cmd>JupyniumScrollDown<cr>", desc = "Jupynium Scroll Down" },
      { "<leader>Kk", "<cmd>JupyniumScrollUp<cr>", desc = "Jupynium Scroll Up" },
    },
  },
}
