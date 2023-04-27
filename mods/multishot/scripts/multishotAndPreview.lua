
modApi:appendWeaponAssets("img/", "mini_")


-- We will use this local variable to control what each
-- call to mini_MultishotAndPreview.GetSkillEffect does
local multishot = true


mini_MultishotAndPreview = Skill:new{
	Name = "Multishot & Preview",
	Description = "Fires multiple shots",
	Icon = "weapons/mini_multishot.png",
	GetTargetArea = TankDefault.GetTargetArea,
	PathSize = INT_MAX,
	Shots = 3,
	Damage = 2,
	Push = true,
}


-- This function contains the code for each individual shot.
function mini_MultishotAndPreview:SingleShot(ret, p1, p2)
	local target = GetProjectileEnd(p1, p2)
	local direction = GetDirection(p2 - p1)
	local damageEvent = SpaceDamage(target, self.Damage)

	ret:AddSound("/weapons/stock_cannons")

	damageEvent.iPush = self.Push and direction or DIR_NONE
	damageEvent.sImageMark = MultishotLib:getImageMark(self.Damage, self.Shots, p1, target)
	damageEvent.sSound = "/impact/generic/explosion"
	damageEvent.sScript = string.format("Board:AddAnimation(%s,'explo_fire1',ANIM_NO_DELAY)", target:GetString())

	--[[

	Alternate ways of adding animation at the end of a projectile:

	damageEvent.sAnimation = "explo_fire1"
		Using this method, will cause the animation to
		correctly happen at the time of impact. However, the
		animation will always make the board busy, so the it
		will have to finish completely before another shot
		can be fired.

	ret:AddAnimation(target,"explo_fire1",ANIM_NO_DELAY)
		This can be a good option to call after a projectile
		that uses FULL_DELAY. Otherwise, it can be difficult
		to get the timing right, so that the animation is
		played at the exact time of the projectile hitting
		the target.

	Using a script to call Board:AddAnimation is probably
	the most flexible option. However, the other options are
	simpler in use.

	]]

	ret:AddProjectile(p1, damageEvent, "effects/shot_mechtank", FULL_DELAY)
end


-- This function contains the code to fire multiple shots.
function mini_MultishotAndPreview:Multishot(ret, p1, p2)
	local pawn = Board:GetPawn(p1)
	if pawn == nil then return end

	-- Skip first shot, because we already fired it in GetSkillEffect to generate the preview.
	for i = 2, self.Shots do
		-- Prepare N-1 shots to be fired after this weapon has finished its SkillEffect
		ret:AddScript(string.format("mini_MultishotAndPreview:PrepareFire(%s,%s,%s)", pawn:GetId(), p1:GetString(), p2:GetString()))
	end
end


function mini_MultishotAndPreview:GetSkillEffect(p1, p2)
	local ret = SkillEffect()

	-- If the flag multishot is not toggled off, initiate additional shots.
	-- We can do this before or after the single shot. However, doing it
	-- before like this, allows us to not lose potential boosted status
	-- from firing the projectile, so we can check it in PrepareFire
	-- which is called via a script.
	if multishot then
		self:Multishot(ret, p1, p2)
	end

	-- We can fire a single shot every call to GetSkillEffect.
	-- This allows us to pass a preview to the game. And we can
	-- now simply fire this weapon with the flag 'multishot'
	-- toggled off for each bullet.
	self:SingleShot(ret, p1, p2)

	return ret
end


function mini_MultishotAndPreview:PrepareFire(pawnId, p1, p2)
	local pawn = Board:GetPawn(pawnId)
	if pawn == nil then return end

	-- Create a new SkillEffect and add it to the Board, so the code will execute after the previous SkillEffect has finished.
	-- Check if the unit was originally boosted, so we can boost each shot manually if needed.
	local fx = SkillEffect()

	fx:AddScript(string.format("mini_MultishotAndPreview:Fire(%s,%s,%s)", pawnId, p2:GetString(), tostring(pawn:IsBoosted())))

	Board:AddEffect(fx)
end


function mini_MultishotAndPreview:Fire(pawnId, p2, boosted)
	local pawn = Board:GetPawn(pawnId)
	if pawn == nil then return end

	-- Boost the following shot if the unit was originally boosted.
	if boosted then
		pawn:SetBoosted(true)
	end

	-- Add a weapon, fire it, and remove it. Each shot will consume a boost.
	-- Untoggle multishot before each shot, so we don't trigger any more.
	multishot = false
	pawn:AddWeapon("mini_MultishotAndPreview")
	local count = pawn:GetWeaponCount()
	pawn:FireWeapon(p2, count)
	pawn:RemoveWeapon(count)
	multishot = true

	-- We could have fired the weapon our unit already have. But it is a bit
	-- tricky to retrieve the weapon index that was fired. So it is just
	-- simpler to add an additional weapon, and fire that instead.

	-- This does however mean that we will have to manually fire the correct
	-- upgrade of the weapon. (See multishotAndPreviewAndUpgrades.lua)
end
