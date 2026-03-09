return {
  {
    "obsidian-nvim/obsidian.nvim",
    version = "*", -- recommended, use latest release instead of latest commit
    lazy = true,
    ft = "markdown",
    opts = {
      legacy_commands = false,
      workspaces = {
        { name = "Root", path = vim.fn.expand("~/Documents/sync-server/Obsidian-Vault") },
      },
      daily_notes = {
        folder = "01-dailies",
        date_format = "%Y-%m-%d",
        default_tags = { "daily-notes" },
        template = "daily.md",
      },
      completion = { min_chars = 0 },
      new_notes_location = "current_dir",
      note_id_func = function(title)
        local suffix = ""
        if title ~= nil then
          suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
        else
          for _ = 1, 4 do
            suffix = suffix .. string.char(math.random(65, 90))
          end
        end
        return suffix
      end,
      -- wiki_link_func = "prepend_note_path",
      templates = {
        folder = "templates",
        date_format = "%Y-%m-%d",
        time_format = "%H:%M",
        customizations = {
          math = {
            notes_subdir = "02-math/",
          },
          quantum = {
            notes_subdir = "03-quantum/",
          },
        },
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

      attachments = {
        folder = "./assets",
        img_text_func = function(path)
          local name = vim.fs.basename(tostring(path))
          local encoded_name = require("obsidian.util").urlencode(name)
          return string.format("![%s](%s)", name, "./assets/" .. encoded_name)
        end,
      },

      frontmatter = {
        func = function(note)
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
      },

      ui = {},
    },
    keys = {
      { "<leader>no", "<cmd>Obsidian open<cr>", desc = "Open Obsidian" },
      { "<leader>nt", "<cmd>Obsidian tags<cr>", desc = "Search tags" },
      { "<leader>nd", "<cmd>Obsidian dailies<cr>", desc = "Open recent dailies" },
      { "<leader>ni", "<cmd>Obsidian paste_img<cr>", desc = "Obsidian paste image" },
    },
  },
  {
    "oflisback/obsidian-bridge.nvim",
    enabled = false,
    commit = "079f788",
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
      warnings = true,
    },
  },
}
