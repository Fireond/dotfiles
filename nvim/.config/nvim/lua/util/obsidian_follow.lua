vim.notify("obsidian_follow loaded")
local vault_root = vim.fs.normalize(vim.fn.expand("~/Documents/sync-server/Obsidian-Vault"))
local follow_url = "http://127.0.0.1:27135/follow"

local uv = vim.uv or vim.loop
local timer = uv.new_timer()

local last_sent = nil

local function is_markdown_buffer(bufnr)
  if vim.bo[bufnr].buftype ~= "" then
    return false
  end
  local name = vim.api.nvim_buf_get_name(bufnr)
  return name ~= "" and name:match("%.md$")
end

local function relpath_under_vault(abs_path)
  abs_path = vim.fs.normalize(abs_path)
  if abs_path:sub(1, #vault_root) ~= vault_root then
    return nil
  end

  local rel = abs_path:sub(#vault_root + 2)
  if rel == "" then
    return nil
  end
  return rel
end

local function send_follow()
  local bufnr = vim.api.nvim_get_current_buf()
  if not is_markdown_buffer(bufnr) then
    return
  end

  local mode = vim.api.nvim_get_mode().mode
  if mode ~= "n" and mode ~= "no" and mode ~= "nov" and mode ~= "niI" then
    return
  end

  local abs_path = vim.api.nvim_buf_get_name(bufnr)
  local rel = relpath_under_vault(abs_path)
  if not rel then
    return
  end

  local pos = vim.api.nvim_win_get_cursor(0)
  local row = pos[1] - 1
  local col = pos[2]

  local payload_tbl = {
    path = rel,
    line = row,
    ch = col,
  }

  local key = rel .. ":" .. row .. ":" .. col
  if last_sent == key then
    return
  end
  last_sent = key

  local payload = vim.json.encode(payload_tbl)

  vim.system({
    "curl",
    "--noproxy",
    "*",
    "-sS",
    "-X",
    "POST",
    follow_url,
    "-H",
    "Content-Type: application/json",
    "-d",
    payload,
  }, { detach = true }, function(_) end)
end

local function send_follow_debounced()
  timer:stop()
  timer:start(100, 0, vim.schedule_wrap(send_follow))
end

vim.api.nvim_create_autocmd({ "BufEnter", "CursorMoved", "InsertLeave" }, {
  callback = function()
    send_follow_debounced()
  end,
})
vim.api.nvim_create_user_command("ObsidianFollowNow", function()
  send_follow()
end, {})
