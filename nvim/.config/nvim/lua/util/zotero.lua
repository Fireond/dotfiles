local M = {}

local function get_visual_selection()
  local region = vim.fn.getregionpos(vim.fn.getpos("v"), vim.fn.getpos("."), {
    type = vim.fn.mode(),
    exclusive = false,
    eol = false,
  })

  if not region or vim.tbl_isempty(region) then
    return ""
  end

  local bufnr = 0
  local start_row = region[1][1][2] - 1
  local start_col = region[1][1][3] - 1
  local end_row = region[#region][2][2] - 1
  local end_col = region[#region][2][3]

  local lines = vim.api.nvim_buf_get_text(bufnr, start_row, start_col, end_row, end_col, {})
  return table.concat(lines, "\n")
end

local function normalize_citekey(s)
  s = s:gsub("^%s+", ""):gsub("%s+$", "")
  s = s:gsub("\n", "")
  s = s:gsub("^@", "")
  s = s:gsub("\\cite%a*%s*%b{}", function(match)
    return match:match("%b{}"):sub(2, -2)
  end)
  s = s:gsub("[{}%[%]()%s]", "")
  return s
end

function M.open_zotero_pdf_from_visual()
  local raw = get_visual_selection()
  local citekey = normalize_citekey(raw)

  if citekey == "" then
    vim.notify("No citekey selected", vim.log.levels.ERROR)
    return
  end

  vim.system({ "zotero-open-by-citekey.sh", citekey }, { detach = true }, function(res)
    vim.schedule(function()
      if res.code ~= 0 then
        vim.notify("Failed to open Zotero PDF: " .. (res.stderr or ""), vim.log.levels.ERROR)
        return
      end
      vim.notify("Opening PDF for " .. citekey)
    end)
  end)
end

return M
