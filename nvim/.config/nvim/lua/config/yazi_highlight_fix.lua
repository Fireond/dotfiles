local M = {}

function M.setup()
  local Highlighter = require("yazi.buffer_highlighting.yazi_session_highlighter")
  if Highlighter._closed_hover_guard then
    return
  end

  local closed = setmetatable({}, { __mode = "k" })
  local clear_highlights = Highlighter.clear_highlights
  local highlight_buffers_when_hovered = Highlighter.highlight_buffers_when_hovered

  -- yazi.nvim clears highlights when its session exits. Killing `ya` does not
  -- cancel hover callbacks already queued with vim.schedule, so retire this
  -- highlighter before restoring the original window options.
  function Highlighter:clear_highlights(...)
    closed[self] = true
    return clear_highlights(self, ...)
  end

  function Highlighter:highlight_buffers_when_hovered(...)
    if closed[self] then
      return
    end
    return highlight_buffers_when_hovered(self, ...)
  end

  Highlighter._closed_hover_guard = true
end

return M
