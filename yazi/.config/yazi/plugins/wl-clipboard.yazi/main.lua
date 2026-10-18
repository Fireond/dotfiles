-- Meant to run at async context. (yazi system-clipboard)

local selected_or_hovered = ya.sync(function()
	local tab, paths = cx.active, {}
	-- Yazi 26.9 returns File objects here, so read each file's URL.
	for _, file in pairs(tab.selected) do
		paths[#paths + 1] = tostring(file.url)
	end
	if #paths == 0 and tab.current.hovered then
		paths[1] = tostring(tab.current.hovered.url)
	end
	return paths
end)

return {
	entry = function()
		ya.emit("escape", { visual = true })

		local urls = selected_or_hovered()

		if #urls == 0 then
			return ya.notify({ title = "System Clipboard", content = "No file selected", level = "warn", timeout = 5 })
		end

		-- ya.notify({ title = #urls, content = table.concat(urls, " "), level = "info", timeout = 5 })

		-- Format the URLs for `text/uri-list` specification
		local function encode_uri(uri)
			return uri:gsub("([^%w%-%._~:/])", function(c)
				return string.format("%%%02X", string.byte(c))
			end)
		end

		local file_list_formatted = ""
		for _, path in ipairs(urls) do
			-- Each file path must be URI-encoded and prefixed with "file://"
			file_list_formatted = file_list_formatted .. "file://" .. encode_uri(path) .. "\r\n"
		end

		local child, err =
			Command("wl-copy"):arg("--type"):arg("text/uri-list"):arg(file_list_formatted):spawn()
		local status
		if child then
			status, err = child:wait()
		end

		if status and status.success then
			ya.notify({
				title = "System Clipboard",
				content = string.format("Successfully copied %d file(s) to system clipboard", #urls),
				level = "info",
				timeout = 5,
			})
		end

		if not status or not status.success then
			ya.notify({
				title = "System Clipboard",
				content = string.format("Could not copy selected file(s) %s", status and status.code or err),
				level = "error",
				timeout = 5,
			})
		end
	end,
}
