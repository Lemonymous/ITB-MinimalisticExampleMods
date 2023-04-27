
local mod = {
	id = "lmn_multishot",
	name = "Multishot Example",
	version = "0.1.0",
	description = "A minimalistic example of a multishot weapon",
	icon = "scripts/icon.png",
	dependencies = { "memedit" },
	load = function() end,
}

function mod:init()
	require(self.scriptPath.."libs/multishot")
	require(self.scriptPath.."multishot")
end

return mod
