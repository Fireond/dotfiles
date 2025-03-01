return {
  {
    "epwalsh/obsidian.nvim",
    version = "*", -- recommended, use latest release instead of latest commit
    lazy = true,
    ft = "markdown",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "hrsh7th/nvim-cmp",
    },
    opts = {
      workspaces = {
        { name = "Root", path = vim.fn.expand("~/Documents/Obsidian-Vault") },
      },
      daily_notes = {
        folder = "01-dailies",
        date_format = "%Y-%m-%d",
        default_tags = { "daily-notes" },
        template = "daily.md",
      },
      completion = { min_chars = 0 },
      new_notes_location = "current_dir",
      -- note_id_func = function(title)
      --   return title
      -- end,
      note_id_func = function(title)
        local suffix = ""
        if title ~= nil then
          suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
        else
          for _ = 1, 4 do
            suffix = suffix .. string.char(math.random(65, 90))
          end
        end
        return tostring(os.time()) .. "-" .. suffix
      end,
      wiki_link_func = "prepend_note_path",
      templates = {
        folder = "templates",
        date_format = "%Y-%m-%d",
        time_format = "%H:%M",
        -- A map for custom variables, the key should be the variable and the value a function
        substitutions = {
          -- yesterday = function()
          --   return os.date("%Y-%m-%d", os.time() - 86400)
          -- end,
          unfinished_todos = function()
            local todos = require("util.obsidian").get_unfinished_todos()
            if todos == "" then
              return "  - [ ]"
            else
              return todos
            end
          end,
        },
      },

      follow_url_func = function(url)
        vim.ui.open(url) -- need Neovim 0.10.0+
      end,

      attachments = { img_folder = "assets/imgs" },

      note_frontmatter_func = function(note)
        -- Add the title of the note as an alias.
        if note.title then
          note:add_alias(note.title)
        end
        local out = { id = note.id, aliases = note.aliases, tags = note.tags, sources = {} }
        if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
          for k, v in pairs(note.metadata) do
            out[k] = v
          end
        end

        return out
      end,

      ui = {
        enable = false,
        checkboxes = {
          [" "] = { char = "󰄱", hl_group = "ObsidianTodo" },
          ["x"] = { char = "", hl_group = "ObsidianDone" },
        },
      },
    },
    keys = {
      { "<leader>no", "<cmd>ObsidianOpen<cr>", desc = "Open Obsidian" },
      { "<leader>nt", "<cmd>ObsidianTags<cr>", desc = "Open Obsidian tags" },
      { "<leader>nd", "<cmd>ObsidianDailies<cr>", desc = "Open Obsidian dailies" },
    },
  },
  {
    "saghen/blink.cmp",
    dependencies = {
      { "saghen/blink.compat", lazy = true, version = false },
    },
    opts = {
      sources = {
        compat = { "obsidian", "obsidian_new", "obsidian_tags" },
        providers = {
          obsidian = {
            kind = "Obsidian",
            score_offset = 30,
          },
          obsidian_new = {
            kind = "Obsidian",
            async = true,
          },
          obsidian_tags = {
            kind = "Obsidian",
            score_offset = 30,
            async = true,
          },
        },
      },
    },
  },
  {
    "oflisback/obsidian-bridge.nvim",
    lazy = true,
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    event = {
      "BufReadPre *.md",
      "BufNewFile *.md",
    },
    opts = {
      scroll_sync = true,
      warnings = false,
    },
  },
}
