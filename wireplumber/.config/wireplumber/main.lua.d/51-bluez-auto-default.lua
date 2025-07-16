bluetooth_monitor = {}

bluetooth_monitor.on_device_connected = function(node)
	local name = node.properties["node.name"] or ""
	local description = node.properties["node.description"] or ""

	if string.find(name, "bluez_output") or string.find(description:lower(), "bluetooth") then
		Log.info("Bluetooth audio device connected: " .. description)
		node:activate(0, function()
			node:set_property("device.routes.default", "true")
			Log.info("Set " .. description .. " as default output device")
		end)
	end
end

SimpleEventHook({
	interest = {
		type = "node",
		action = "add",
		Constraint({ "media.class", "matches", "Audio/Sink" }),
	},
	execute = bluetooth_monitor.on_device_connected,
})
