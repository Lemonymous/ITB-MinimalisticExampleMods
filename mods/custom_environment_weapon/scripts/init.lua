
local mod =  {
	id = "lmn_custom_env",
	name = "Custom Environment Weapon",
	version = "0.1.0",
	description = "A minimalistic example of a weapon placing custom environment effects",
	dependencies = {}
	load = function() end,
}

function mod:init(options)
	require(self.scriptPath.."libs/CustomEnv")
	require(self.scriptPath.."env_weapon")
end

return mod
