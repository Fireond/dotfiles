Monitor.on("create-node", function(node)
	local desc = node.properties["node.description"] or ""

	-- 提高显示器扬声器的优先级
	if desc == "GA106 High Definition Audio Controller Digital Stereo (HDMI)" then
		node:set_property("priority.session", 200)
		Log.info("Priority set: HDMI (monitor) = 200")
	end

	-- 降低笔记本模拟音响的优先级
	if desc == "Family 17h/19h/1ah HD Audio Controller Analog Stereo" then
		node:set_property("priority.session", 100)
		Log.info("Priority set: Internal analog = 100")
	end
end)
