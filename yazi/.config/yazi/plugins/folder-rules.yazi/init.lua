local function setup()
	ps.sub("cd", function()
		local cwd = cx.active.current.cwd
		if cwd:ends_with("Downloads") then
			ya.manager_emit("sort", { "btime", reverse = true, dir_first = false })
		else
			ya.manager_emit("sort", { "mtime", reverse = false, dir_first = true })
		end
	end)
end

return { setup = setup }
