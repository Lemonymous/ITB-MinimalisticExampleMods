
local VERSION = "0.1.0"


local function alterMissionObject()
	-- Preserve references to overridden functions
	Mission.ApplyEnvironmentEffectVanilla = Mission.ApplyEnvironmentEffect
	Mission.IsEnvironmentEffectVanilla = Mission.IsEnvironmentEffect

	-- Create a table that will hold all custom environments by some unique id.
	Mission.CustomEnv = {}

	-- This function will apply one environment effect per call
	Mission.ApplyEnvironmentEffect = function(self)
		local env = self.LiveEnvironment
		if env:IsEffect() then
			env:ApplyEffect()
			-- return true if any environment is still unprocessed,
			-- to hint the caller that we are not done.
			return self:IsEnvironmentEffect()
		end

		for _, env in pairs(self.CustomEnv) do
			if env:IsEffect() then
				env:ApplyEffect()
				-- return true if any environment is still unprocessed,
				-- to hint the caller that we are not done.
				return self:IsEnvironmentEffect()
			end
		end
	end

	-- This function returns true if any of the environments are still unprocessed
	Mission.IsEnvironmentEffect = function(self)
		for _, env in pairs(self.CustomEnv) do
			if env:IsEffect() then
				return true
			end
		end

		return self.LiveEnvironment:IsEffect()
	end
end


local function onMissionUpdate(mission)
	for _, env in pairs(mission.CustomEnv) do
		env:MarkBoard()
	end
end


local function finalizeInit(self)
	alterMissionObject()
	modApi.events.onMissionUpdate:subscribe(onMissionUpdate)
end


local function onModsInitialized()
	local isHighestVersion = true
		and CustomEnv.initialized ~= true
		and CustomEnv.version == VERSION

	if isHighestVersion then
		CustomEnv:finalizeInit()
		CustomEnv.initialized = true
	end
end


local isNewerVersion = false
	or CustomEnv == nil
	or VERSION > CustomEnv.version

if isNewerVersion then
	CustomEnv = CustomEnv or {}
	CustomEnv.version = VERSION
	CustomEnv.finalizeInit = finalizeInit

	modApi.events.onModsInitialized:subscribe(onModsInitialized)
end


return CustomEnv
