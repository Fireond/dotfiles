return {
  {
    "kiyoon/jupynium.nvim",
    ft = "python",
    build = "conda run --no-capture-output -n QCX pip install .",
    config = {
      python_host = { "conda", "run", "--no-capture-output", "-n", "QCX", "python" },
      jupyter_command = { "conda", "run", "--no-capture-output", "-n", "QCX", "jupyter" },
      default_notebook_URL = "localhost:8888",
      auto_start_server = {
        enable = true,
        file_pattern = { "*.ju.*" },
      },
    },
    -- build = "conda run --no-capture-output -n jupynium pip install .",
    -- enabled = vim.fn.isdirectory(vim.fn.expand "~/miniconda3/envs/jupynium"),
    keys = {
      { "<leader>Ko", "<cmd>JupyniumStartAndAttachToServer<cr>", desc = "Jupynium Start" },
      { "<leader>Ks", "<cmd>JupyniumStartSync<cr>", desc = "Jupynium Sync" },
      { "<leader>KO", "<cmd>JupyniumStartAndAttachToServerInTerminal<cr>", desc = "Jupynium Start In Terminal" },
    },
  },
}
