
LightningWeapon = Skill:new{
	Name = "EnvLightning Placer",
	Description = "Placed a lightning environment on a tile",
	-- You can also try changing this to another environment that
	-- uses 'Locations' to define marked locations, like "Env_Seismic"
	Environment = "Env_Lightning",
}


function LightningWeapon:GetTargetArea(point)
	local ret = PointList()

	for _,p in ipairs(Board) do
		if p ~= point then
			ret:push_back(p)
		end
	end

	return ret
end


function LightningWeapon:GetSkillEffect(p1, p2)
	local ret = SkillEffect()

	ret:AddScript(string.format([[
		local mission = GetCurrentMission() 
		local target = %s 
		local env_id = %q 
		local env = mission.CustomEnv[env_id] 

		if env == nil then 
			env = _G[env_id]:new() 
			env:Start() 

			mission.CustomEnv[env_id] = env 
		end 

		table.insert(env.Locations, target) 
	]], p2:GetString(), self.Environment))

	return ret
end
