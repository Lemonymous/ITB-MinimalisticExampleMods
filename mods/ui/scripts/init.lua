
local mod = {
	id = "lmn_ui_example",
	name = "Ui Example",
	version = "0.1.0",
	description = "A minimalistic example of a custom ui",
	icon = "scripts/icon.png",
	dependencies = {},
	load = function() end,
}

function mod:init()
	require(self.scriptPath.."ui_examples")
end

return mod
