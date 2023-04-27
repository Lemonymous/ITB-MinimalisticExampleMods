
-- Requires
-- 	images in the mod's ./img/libs/multishot/


local VERSION = "0.1.0"


local function getImageMark(self, damage, count, origin, target)
	Assert.Equals("table", type(self), "Check for . vs :")
	Assert.Equals({"nil", "number"}, type(damage), "Argument #1")
	Assert.Equals("number", type(count), "Argument #2")

	local originPawn
	local targetPawn
	local isBoosted
	local isAcid
	local isArmor
	local color

	if damage == nil then
		damage = 0
	end

	if origin then
		Assert.TypePoint(origin, "Argument #3")
		originPawn = Board:GetPawn(origin)
		isBoosted = originPawn and originPawn:IsBoosted()
	end

	if target then
		Assert.TypePoint(target, "Argument #4")
		targetPawn = Board:GetPawn(target)
		isAcid = targetPawn and targetPawn:IsAcid()
		isArmor = targetPawn and targetPawn:IsArmor()
	end

	if damage <= 0 then
		color = "white"
	elseif isBoosted then
		color = "pink"
	elseif isAcid then
		color = "green"
	elseif isArmor then
		color = "white"
	else
		color = "yellow"
	end

	return "combat/multishot_"..color..count..".png"
end


local function setLocations()
	local offset = Point(1,10)
	for count = 2, 18 do
		for _, color in ipairs{"white", "yellow", "green", "pink"} do
			Location["combat/multishot_"..color..count..".png"] = offset
		end
	end
end


local function finalizeInit(self)
	setLocations()
	self.getImageMark = getImageMark
end


local function onModsInitialized()
	local isHighestVersion = true
		and MultishotLib.initialized ~= true
		and MultishotLib.version == VERSION

	if isHighestVersion then
		MultishotLib:finalizeInit()
		MultishotLib.initialized = true
	end
end


local isNewerVersion = false
	or MultishotLib == nil
	or VERSION > MultishotLib.version

if isNewerVersion then
	MultishotLib = MultishotLib or {}
	MultishotLib.version = VERSION
	MultishotLib.finalizeInit = finalizeInit

	modApi:appendCombatAssets("img/libs/multishot/", "multishot_")
	modApi.events.onModsInitialized:subscribe(onModsInitialized)
end


return MultishotLib
