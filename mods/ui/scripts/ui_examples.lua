
local EXAMPLE_1
--[[
	SIMPLE FRAME
	------------

	- Ui objects are created by calling the ui object type you want to create
	- All ui objects inherit from Ui
	- Calling Ui() is the simplest way to create a base ui object
--]]

-- (Add a dash in front of --[[ to disable the comment block and enable the code inside)
-- (Remove a dash from ---[[ when you want to disable the code and enable the next example)

local EXAMPLE_1_CODE
---[[
modApi.events.onUiRootCreated:subscribe(function(screen, uiRoot)
	local ui = Ui()

	-- percent size of the parent object's size. 0.3 == 30%
	-- set size to match 30% of of the parent's x and y size
	-- uiRoot has the same size as the full screen
	ui:size(0.3,0.3)

	-- ui objects without decoration is invisible
	-- decorate it with a simple frame
	ui:decorate{ DecoFrame() }

	-- ui objects not connected to the root in some way is invisible
	-- add it to root
	ui:addTo(uiRoot)
end)
--]]



local EXAMPLE_2
--[[
	FUNCTION CHAINING
	-----------------

	- Most functions in ui objects have a specific pattern that returns the ui object itself
	- This allows you to chain its functions in a way that makes the code looks neat
	- The below code is the exact same as the previous code in the above example
--]]

local EXAMPLE_2_CODE
--[[
modApi.events.onUiRootCreated:subscribe(function(screen, uiRoot)
	Ui()
		:size(0.3,0.3)
		:decorate{ DecoFrame() }
		:addTo(uiRoot)
end)
--]]



local EXAMPLE_3
--[[
	UI TREE-HIERARCHY
	-----------------

	Some examples of ui object types:
	(incomplete list - see lua files in mod_loader/ui/widgets for more)
		- Ui
		- UiBoxLayout
		- UiFlowLayout
		- UiScrollArea
		- UiWeightLayout

	Custom ui is built using a combination of ui types in a tree-like hierarchy.
	It can help to visualize your ui like a tree of objects.

	Example structure could be:
	Ui
		UiScrollArea
			UiFlowLayout
				Ui
				Ui
				Ui
				Ui
				Ui

	This ui would have a main frame containing a scrollarea and a scrollbar.
	Inside the scrollarea there will be an object that lays out its children
	in sequance both horizontally and vertically when the horizontal space
	gets filled up.
	Lastly the 5 Ui objects can be entries like in the arrange pilot window
--]]

local EXAMPLE_3_CODE
--[[
modApi.events.onUiRootCreated:subscribe(function(screen, uiRoot)
	local ui_main = Ui()
	local ui_scrollarea = UiScrollArea()
	local ui_flow = UiFlowLayout()

	ui_main
		:sizepx(250,250) -- 250x250 pixel main element
		:pospx(100,100) -- set to position 100x100 relative to its parent (uiRoot)
		:decorate{ DecoFrame() }
		:addTo(uiRoot)

	ui_scrollarea
		:size(1,1)
		:addTo(ui_main)

	ui_flow
		:size(1,1)
		:addTo(ui_scrollarea)

	-- add 5 100x100 pixel frames to the innermost ui_flow element
	for i = 1, 5 do
		Ui()
			:sizepx(100,100)
			:decorate{ DecoFrame() }
			:addTo(ui_flow)
	end
end)
--]]



local EXAMPLE_4
--[[
	CREATE UI ON DEMAND
	-------------------

	Sometimes you may want to only show an Ui at certain times.
	In those instances you can create the ui when the UiRoot is created like
	above; and change its visibility based on when you want to show it.
	Alternatively, you can create and destroy the ui when you want.

	Note that the following code contains two global functions:
		- CreateUiExample4()
		- DestroyUiExample4()

	You will have to manually run those functions in the console to test the code
--]]

local EXAMPLE_4_CODE
--[[
local example_4_ui
function CreateUiExample4()
	-- As long as this function is called after the ui root has been created, this will work fine
	local uiRoot = sdlext:getUiRoot()

	-- Return if we have already created the ui, or do something else if you
	-- want to be able to create several instances of the same ui object
	if example_4_ui then
		return
	end

	example_4_ui = Ui()
		:size(0.3,0.3)
		:decorate{ DecoFrame() }
		:addTo(uiRoot)
end

function DestroyUiExample4()
	if example_4_ui == nil then
		return
	end

	-- If you detach the ui from its parent and make sure nothing
	-- references it anymore, it will eventually be garbage collected.
	example_4_ui:detach()
	example_4_ui = nil
end
--]]



local EXAMPLE_ADDITIONAL_A
--[[
	UI VARIABLES
	------------

	All ui objects have a lot of variables that you can change.
	It can be challenging to get a handle on them.
	Most of the common ones can be found at the top of mod_loader/ui/widgets/base.lua.
	Other ui object types can have additional variables that you can check in their files.
	In addition you can add variables for your ui objects if you need to keep track of something.
--]]



local EXAMPLE_ADDITIONAL_B
--[[
	UI FUNCTIONS
	------------

	All ui objects have a lot of functions. All of them can be overridden if you need altered functionality.
	Most of the common functions can be found in mod_loader/ui/widgets/base.lua.
	Other ui object types can have additional functions that you can check in their files.
	In addition you can add functions for your ui objects if you need additional functionality.
--]]

local EXAMPLE_ADDITIONAL_B_CODE
--[[
modApi.events.onUiRootCreated:subscribe(function(screen, uiRoot)
	local ui_custom = Ui()

	ui_custom
		:sizepx(250,250) -- 250x250 pixel main element
		:pospx(100,100) -- set to position 100x100 relative to its parent (uiRoot)
		:decorate{ DecoFrame() }
		:addTo(uiRoot)

	-- override its relayout function.
	-- every ui object has a relayout function that when called
	-- will relay out positioning to its children, in order for
	-- every element to be displayed correctly on the screen.

	ui_custom.relayout = function(self)
		-- for example we could want to set this element to only
		-- be visible while we are in the hangar.
		self.visible = sdlext.isHangar()

		-- usually you will want to call back the original
		-- relayout function for the same object type unless you
		-- want to override its default relayout completely.
		Ui.relayout(self)
	end
end)
--]]