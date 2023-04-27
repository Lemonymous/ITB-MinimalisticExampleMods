This mod showcases minimalistic examples for one way to code a multishot weapon in ITB
- Boosts every shot if the unit is boosted when attacking
- Runs all weapon code through GetSkillEffect and FireWeapon, so SkillBuildHook can be used to alter the weapon
- Advanced preview is not showcased
- Simple preview, adding xN for N shots next to the first damage event, is showcased in multishotAndPreview.lua
- Simple weapon sounds and effects are showcased in multishotAndPreview.lua

files:
	multishot.lua
		- very simple
		- preview is completely removed
		- the user is free to code preview however they want
	multishotAndPreview.lua
		- adds simple preview
		- previews the first shot
		- uses the library MultishotLib to add an image "xN" to the preview (N is number of shots)
	multishotAndPreviewAndUpgrades.lua
		- continuation of multishotAndPreview.lua
		- adds upgrades, and changes the code so each shot is fired using the correct upgraded weapon

- Weapons can be added via the in-game console with the following commands (case sensitive):
	weapon mini_Multishot
	weapon mini_MultishotAndPreview
	weapon mini_MultishotAndPreviewAndUpgrades
