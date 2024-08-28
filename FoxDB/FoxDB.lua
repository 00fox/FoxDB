--[[--------------------------------------------------------------------------------- FoxDB 11.0.2-0

--▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
----------------------------------------------------------------------------------------------------
--			FoxDB manages the SavedVariables of your addons, with EditMode included.
----------------------------------------------------------------------------------------------------
--▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓

	 Written in clean language and optimized code,
		 the goal of starting from scratch, in addition to EditMode,
		 is to not let the addon go through a full chain of dependencies,
		 having hundreds of lines of code actions before the next, each.
		 ( and avoid too many unnecessary encapsulations )
		 Priority: quick launch, memory, intelligible code.

	 This system is not in conflict with the systems already in place,
		 so you will not encounter any problem when using it for a new addon,
		 to make a transition from an old one or to keep an old one as it is.

	 You of course still have access to a simplified version of the profiles;
		 otherwise, this part remains dormant.

	 If you come from an already made addon in a classic way (global+profiles),
		a transition exists internally to change these things
			and keep the defaults in each profile that used it,
			after which there is no longer a default profile.
		the final goal being to use the globals,
			the layout (instead of the profile)
			and the profile for the few variables which remain necessary to be specific to each character.
		but in the meantime, your base will continue to function as before,
			as long as you don't start using the layouts yourself.

	 Additional Content:
		 SavedVariable files are also written during /reload
		 Layout management is fully automated, user access is not required, but some things are still doable.
		 No nightmares with default databases,
			you define variables in a function if they don't already exist on loading,
			you do what you need when the layout/profile is changed/reset in another.
		 Register one or several chat commands
			and receive the arguments already split into a function.
		 Possibility of an Minimap icon, in ultra light code, without any inconvenience if not used
			Player's EditMode support to manage them include visibility, so not conflicting with AddonCompartment.

	 EditMode:
		 Addons that use EditMode receive a simplified common support for the correct functioning of all (addons and system).
		 Automatic frame registration.
		 Automatic showing/hidding frames when entering/exiting EditMode.
		 Automatic hidding system menus and highlighting frames.
		 Receive a callback when a frame is clicked to hide/show your menu.

	 Note:
		You manually start your addon, then load the data base, which will tell you when the layouts are ready;
		 you therefore control everything with a feeling of the early days of wow.


	See the note FOR EDITMODE DEVELOPERS at the end of this review.


--▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
----------------------------------------------------------------------------------------------------
--											USAGE:
----------------------------------------------------------------------------------------------------
--▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓


--▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
--				In your MyAddon.toc file:
--▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓

	## Title: MyAddon

		...Add usual descriptions...

	## SavedVariables: MyAddonDB

		You don't need another library
		FoxDB.xml

		(OPTIONAL)
		You may need advanced ones to do what you want, or, it is needed by another library
			They're not recommanded, see chapter AVOID USING HEAVY LIBRARIES
			To know about various callback, secure, hook functions
			And how to use one line instead of 2000 from a library
		libs\CallbackHandler-1.0\CallbackHandler-1.0.xml
		libs\LibDataBroker-1.1.lua						
		libs\AceGUI-3.0\AceGUI-3.0.xml					
		libs\AceConfig-3.0\AceConfig-3.0.xml
		libs\LibSharedMedia-3.0\lib.xml

		Then,
		MyAddon.lua
		...


--▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
--				IN YOUR MyAddon.lua FILE:
--▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓

--▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
--			MANUAL START
--▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒

	MyAddon = {}

	To access your addon as a global
	_G.MyAddon		= MyAddon


	You can simply use this (And that's it):
		EventRegistry:RegisterFrameEventAndCallback("VARIABLES_LOADED", function() MyAddon:onInitialize() end, MyAddon)

	Note: You can later unregister any Callback if you no longer needed
		EventRegistry:UnregisterFrameEventAndCallback("VARIABLES_LOADED", MyAddon)


	But if you want to handle multiple events in your add-on, better use this:
				Event		-> Frame				-> Function
	RegisterEvent		SetScript	CreateFrame		function

	Define the function that will process the events
		local function OnEvent(frame, event, arg)
			if		event == "ADDON_LOADED" and arg == "MyAddon"		then MyAddon:onInitialize()			-- This call onInitialize after your addon is fully loaded

			(OPTIONAL)
			elseif	event == "ADDON_LOADED" and arg == "AnotherAddon"	then MyAddon:onAnotherAddon()		-- To do something after another addon is loaded
			elseif	event == "VARIABLES_LOADED"							then MyAddon:onVariablesLoaded()	-- To do something with CVars, but better wait for layout loaded
			elseif	event == "PLAYER_LOGIN"								then MyAddon:onPlayerLogin()		-- To do something when player login, only once when the UI loads
			elseif	event == "SETTINGS_LOADED"							then MyAddon:onSettingsLoaded()		-- To do something when settings have been loaded
			elseif	event == "PLAYER_ENTERING_WORLD"					then MyAddon:onEnteringWorld()		-- To do something when new zone is loaded
			elseif	event == "PLAYER_REGEN_DISABLED"					then MyAddon:onCombatLockdown(true)	-- To so something when entering in combat (lock frames etc.)
			elseif	event == "PLAYER_REGEN_ENABLED"						then MyAddon:onCombatLockdown(false)	-- or put the result in a variable
			...
			end
		end
	Note: Don't use "EDIT_MODE_LAYOUTS_UPDATED", FoxDB already call onLayoutLoaded()

	Create the frame that will handle the events
		local EventHandler = CreateFrame("Frame", nil)

	Define the function that will process the events for the frame
		EventHandler:SetScript("OnEvent", OnEvent)

	Register any events to be processed by the frame (here in loading order, but not necessary)
		EventHandler:RegisterEvent("ADDON_LOADED")
		...

	Note: function and frame can be subparts of MyAddon instead of local, in this case use:
		function MyAddon:OnEvent(event, arg)
		MyAddon.EventHandler = CreateFrame("Frame", nil)
		local EventHandler = MyAddon.EventHandler
		EventHandler:SetScript("OnEvent", MyAddon.OnEvent)
		EventHandler:RegisterEvent("ADDON_LOADED")

--▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
--			FUNCTION CALLED BY YOU WHEN YOUR ADDON IS LOADED
--▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒

	function MyAddon:onInitialize()

		Initialize your database
			self.db = FoxDB:New(self, "MyAddonDB")

		You can already access these tables:
			self.db.global				-- Variables for all characters on the same account
			self.db.realm				-- Variables for all characters that share the same realm
			self.db.faction				-- Variables for all characters that share the same faction
			self.db.race				-- Variables for all characters that share the same race
			self.db.class				-- Variables for all characters that share the same class
			self.db.frealm				-- Variables for all characters that share the same faction and realm

		You can already access these keys:
			self.db.keys.locked			-- If there is an operation in progress on the current layout/profile, set to true otherwise false
			self.db.keys.editmode		-- Whether EditMode is active or not

		When you intend to use profiles too (character dependant, OPTIONAL)
			self.db.profile				-- Variables for current profile
			self.db.keys.profile		-- Name of the current profile

		Some stuff that don't need layouts
		   Elements that require layouts start at onLayoutLoaded()
		   !!! You should wait for onLayoutLoaded to do the real start of your addon

	end

--▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
--			FUNCTION CALLED BY FOXDB WHEN LAYOUTS ARE READY	(REAL START OF YOUR ADDON)
--▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒

	function MyAddon:onLayoutLoaded()

		You can then access these table:
			self.db.layout				-- Variables for all characters that share the same layout

		You can then access these keys:
			self.db.keys.layout			-- Name of the current layout

	end


--▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
--				LAYOUTS:
--▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓

--▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
--			FUNCTION CALLED BY FOXDB WHEN A LAYOUT HAS BEEN CHANGED
--▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒

	function MyAddon:onLayoutChanged(MyAddonDB)

		Stuff to do when layout has been changed. (load time, new, new by copy)

		If the layout did not already exist, it was copied from the current layout, or onNewLayout() is called before if it exists

		You may still want to reset some data,
			self.db.layout.myVariable = true
			self.db.layout.mySubBase = {}
			self.db.layout.mySubBase.myVariable = true
			self.db.layout.mySubBase.myVariable2 = "sometext"

		Or you may need to erase some old datas
			if self.db.layout.myUnneededVariable then self.db.layout.myUnneededVariable = nil
			if self.db.layout.myUnneededSubBase then self.db.layout.myUnneededSubBase = nil

		But more important, check/add the layout dependant datas
		This is where you add them the first time,
		and check if they are still present the second time, when a player change his layout,
		so you need an if...then... wording to avoid overwriting the current content by the default one:
			if type(self.db.layout.myVariable)				~= "boolean"	then self.db.layout.myVariable				= true			end
			if not self.db.layout.mySubBase									then self.db.layout.mySubBase				= {}			end
			if type(self.db.layout.mySubBase.myVariable)	~= "boolean"	then self.db.layout.mySubBase.myVariable	= true			end
			if type(self.db.layout.mySubBase.myVariable2)	~= "string"		then self.db.layout.mySubBase.myVariable2	= "sometext"	end

	end

	Note: This is why there is no longer a default data system

--▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
--			FUNCTION CALLED BY FOXDB WHEN A LAYOUT DIDN'T EXIST (OPTIONAL)
--▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒

	function MyAddon:onNewLayout(MyAddonDB)

		Technically this will only happen on load if the layout doesn't exist,
			because when creating (or moving to) a new layout,
			the new layout is copied from the current one or from the source of copy.

		Then do veryfirsttime stuff there, but better do variables management in onLayoutChanged.

		Note: onLayoutChanged() will be called afterwards, don't call it yourself.

	end

--▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
--			CALLED BY FOXDB WHEN A LAYOUT HAS BEEN RENAMED (OPTIONAL)
--▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒

	function MyAddon:onLayoutRenamed(MyAddonDB)

		Occurs when the layout was simply renamed.

	end

--▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
--			CALLED BY FOXDB WHEN A LAYOUT HAS BEEN SAVED (OPTIONAL)
--▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒

	function MyAddon:onLayoutSaved(MyAddonDB)

		Occurs when the layout is saved but not changed, copied or saved.

	end

--▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
--			SPECIFIC LAYOUTS FUNCTIONS (OPTIONAL)
--▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒

	self.db:GetLayouts()			-- Returns a table with the names of existing layouts - current in 1st place.
	self.db:ResetLayout()			-- Clear the current layout. Will call onNewLayout() then onLayoutChanged()
	self.db:CopyLayout(from)		-- Replace current layout by another. 'from' is a string with layout name.


--▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
--				PROFILES:
--▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓

--▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
--			FUNCTION CALLED BY FOXDB WHEN A PROFILE HAS BEEN CHANGED
--▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒

	function MyAddon:onProfileChanged(MyAddonDB)

		Stuff to do when profile has been changed. (load time, reset or copy)

		If the profile did not already exist onNewProfile() is called before if it exists

		You may still want to reset some data,
			self.db.profile.myVariable = true
			self.db.profile.mySubBase = {}
			self.db.profile.mySubBase.myVariable = true
			self.db.profile.mySubBase.myVariable2 = "sometext"

		Or you may need to erase some old datas
			if self.db.profile.myUnneededVariable	then self.db.layout.myUnneededVariable = nil
			if self.db.profile.myUnneededSubBase	then self.db.layout.myUnneededSubBase = nil

		But more important, check/add the profile dependant datas
		This is where you add them the first time,
		and check if they are still present the second time, when a player change his profile, or character changed
		so you need an if...then... wording to avoid overwriting the current content by the default one:
			if type(self.db.profile.myVariable)				~= "boolean"	then self.db.profile.myVariable				= true			end
			if not self.db.profile.mySubBase								then self.db.profile.mySubBase				= {}			end
			if type(self.db.profile.mySubBase.myVariable)	~= "boolean"	then self.db.profile.mySubBase.myVariable	= true			end
			if type(self.db.profile.mySubBase.myVariable2)	~= "string"		then self.db.profile.mySubBase.myVariable2	= "sometext"	end

	end

	Note: This is why there is no longer a default data system thanks to this. (global + default OR profile)
		Now it's the global + layout and the profile if necessary.
		If you still need to offer the user a choice for specific variables between global and profile,
			Put the choice in a profile variable
			Depending on this choice, use a golable variable or profile where necessary
			A simple checkbox is then sufficient.

--▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
--			FUNCTION CALLED BY FOXDB WHEN A PROFILE DIDN'T EXIST (OPTIONAL)
--▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒

	function MyAddon:onNewProfile(MyAddonDB)

		There is no need for a default table and profile.

		Then do veryfirsttime stuff there, but better do variables management in onProfileChanged.

		Note: onProfileChanged() will be called afterwards, don't call it yourself.

	end

--▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
--			SPECIFIC PROFILES FUNCTIONS (OPTIONAL)
--▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒

	self.db:GetProfiles()			-- Returns a table with the names of existing profiles - Current in 1st place.
	self.db:DeleteProfile(profile) 	-- Deletes a profile, except current.
	self.db:ResetProfile()			-- Clear the current profile. Will call onNewProfile() then onProfileChanged()
	self.db:CopyProfile(from)		-- Replace current profile by another. 'from' is a string with profile name.


--▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
--			HOW TO PLACE KEYS IN VARIABLES TO USE THEM MORE PRACTICALLY THROUGHOUT YOUR FILE
--▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓

	local Global
	local Layout
	local Profile

	function MyAddon:onInitialize()
		MyAddon.db	= FoxDB:New(self, "MyAddonDB", [true])
		Global		= MyAddon.db.global
		[Profile	= MyAddon.db.profile]
	end

	function MyAddon:onLayoutLoaded()
		Layout		= MyAddon.db.layout
		(real start)
	end


--▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
--				IF YOU WANT TO USE CHAT COMMANDS:
--▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓

	Place in your file a function:
		MyAddon:onChatCommand(cmd, arg, ...)
			if cmd == "myaddoncmd" then
				if		arg == "argisarg"	then ...
				elseif	arg == true			then ...
				elseif	arg == 4			then ...
				end
			elseif cmd == "myaddoncmd2"		then ...
			end
		end

	Then register the command with
		self.db:RegisterChatCommand("myaddoncmd")

	you can use it more than once to register multiple commands


--▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
----------------------------------------------------------------------------------------------------
--										USING LOCALES:
----------------------------------------------------------------------------------------------------
--▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓


	You can opt for common solutions, with a library, takes memory, uses complex opeerations,
		plus compare tables (to takes the most appropriate value each time), for each addon.
		Instead you just need to do that:

	Make a directory named locale

	Add a file in it, named xxYY.lua, for each locale you want, except your own
		possibly enUS [, enGB], deDE, itIT, esES, esMX, frFR, koKR, ptBR, ruRU, zhCN, zhTW

	In your main file:
		MyAddon.L = {}

	Two cases of files:

		1. the default language, in which you will put everything you need for sure		(enUS.lua for example)
			local _, MyAddon = ...
			local L = MyAddon.L
			L["My Text"] = "My Text"
			...

		2. an example of locale added													(deDE.lua for example)
			if GetLocale() ~= "deDE" then return end	-- the file won't be executed if it is not the user's locale
			local _, MyAddon = ...
			local L = MyAddon.L
			L["My Text"] = "Mein Text"
			...

	Add a line for each of them in your MyAddon.toc file,
	Place them at first place just before your main addon lua,
	and give priority to default language:
			FoxDB.xml
			locale\enUS.lua
			locale\deDE.lua
			...
			MyAddon.lua

	print(L["My Text"])

	Advantage: 		Accessed directly.
	Inconvenience:	Uses more memory.

--▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
--			OPTION 1: USE A SIMPLE BASE AND A FUNCTION
--▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒

	MyAddon.L = {}
	local function L(text) return MyAddon.L[text] == true and text or MyAddon.L[text] end

	L["My Text"] = true				-- default language
	L["My Text"] = "Mein Text"		-- locale added

	print(L("My Text"))

	Advantage: 		Default language takes only half of the memory.
	Inconvenience:	You need to pass by a function to access the value.

--▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
--			OPTION 2: USE A METATABLE, TO REINDEX THE REAL VALUES WITH STRINGS
--▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒

	MyAddon.L = setmetatable({}, {__newindex = function(self, key, value) rawset(self, key, value == true and key or value) end})
	local L = MyAddon.L

	L["My Text"] = true				-- default language
	L["My Text"] = "Mein Text"		-- locale added

	print(L["My Text"])

	Advantage: 		Default language takes only half of the memory, accessed ~directly.
	Inconvenience:	You need to pass by an indexed database to access the value.


--▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
----------------------------------------------------------------------------------------------------
--									HOW TO USE A MINIMAP ICON:
----------------------------------------------------------------------------------------------------
--▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓


	Minimap icons can be use to perform left, Middle and right click actions.
		They can be quickly be moved into EditMode and get a dedicated menu.
		The first time they get a random place onto the border of the minimap.
		
		Into EditMode:
		The player can decide where to place and whether it stays visible or not outside EditMode.
		The player can decide how much it grows to a factor size of x3 from 0.8.
		The player can put an offset which change the distance between the center and the border of Minimap.
		The player can adjust an alpha while mouseOn/Out.

--▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
--				IN YOUR MAIN LUA FILE, MyAddon.lua:
--▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒

	-- In
	function MyAddon:onInitialize()

		-- After
		self.db = FoxDB:New(self, "MyAddonDB")

		-- Need to be unique, usually addon name
		self.db.icon.label = "MyAddon"

		-- Needed icon object (https://www.wowhead.com/icons)
		self.db.icon.file = "Interface\\Icons\\spell_shadow_brainwash"		-- (FreeMind addon example)

		-- Optional:
		self.db.icon.line1		= "Left click action"	-- Action on left click description.
		self.db.icon.line2		= "Right click action"	-- Action on right click description.

		-- Launch Icon
		self.db:IconStart()

	end

	Note: If you want to refer to your own addon's icon, use self.db.iconinuse

--▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
--			FUNCTION CALLED WHILE CLICKING ON YOUR ICON OR PLAYER CHANGED VISIBILITY:
--▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒

	function MyAddon:onIconLeftClick()
		...
	end

	function MyAddon:onIconMiddleClick()
		...
	end

	function MyAddon:onIconRightClick()
		...
	end

	function MyAddon:onIconVisibility(visible)
		...
	end

	Note: If you don't use these functions, don't put them, avoiding loading them as callbacks in memory

--▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
--			BROWSE ICONS TABLE:
--▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒

	-- GetIcons returns a table containing all addons icons with their labels
	for label,icon in pairs(self.db:GetIcons()) do ... end

	-- Unique icon identifier
	AddonName.db.iconinuse.label

	-- Icon object
	AddonName.db.iconinuse


--▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
----------------------------------------------------------------------------------------------------
--									AVOID USING HEAVY LIBRARIES:
----------------------------------------------------------------------------------------------------
--▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓


	Note: Avoid to use libraries for callbacks or other stuff, use them only if you really need them.
		The idea was good, reducing the memory needed in total of all addons
		Except that most of times
			it consumes a lot of resources to handle all the possibilites of functions already present in wow
				and this in most cases, for simple things you can do on your own
			or it's 2000 lines of code and 500 lines being processed,
				for only one if it had been done manually knowing that it's not that hard.


	Registers a callback to a frame event
		Example: "WORLD_CURSOR_TOOLTIP_UPDATE"
		EventRegistry:RegisterFrameEventAndCallback(frameEvent, func, [owner], ...)
		EventEventRegistry:UnregisterFrameEventAndCallback(frameEvent, owner)

	Registers a callback to an event
		Example: "EditMode.Enter"
		EventRegistry:RegisterCallback(Event, func, [owner], ...)
		EventEventRegistry:UnregisterCallback(Event, owner)

	Registers a callback to a custom defined event (Mixin)
		CallbackRegistryMixin:RegisterCallback(event, func, [owner], ...)
		CallbackRegistryMixin:UnregisterCallback(event, owner)

	Calls the specified function without propagating taint to the caller
		securecallfunction(func, ...)

	Gives a script to your own frame
		Example: "OnClick"
		frame:SetScript("handler", func [nil to remove])

	Securely posthooks the specified frame function. Works with secure frames
		Example: "OnClick"
		frame:HookScript("handler", hookfunc)

	Securely posthooks the specified function
		The hook will be called with the same arguments after the original call is performed
			hooksecurefunc([table,] functionName, hookfunc)

	Create your own EditMode menus
		See chapter: NOTE FOR EDITMODE DEVELOPPERS


--▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
----------------------------------------------------------------------------------------------------
--										NOTE FOR TRANSITION:
----------------------------------------------------------------------------------------------------
--▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓


--▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
--				START BY THE MANUAL START:
--▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓

	!!! keep a copy of your SavedVariables file aside, you never know, while experimenting

	Remove
		MyAddon = LibStub("AceAddon-3.0"):NewAddon("MyAddon", "AceConsole-3.0", "AceEvent-3.0", "AceHook-3.0")

	Add
		local _, MyAddon = ...
		_G.MyAddon = MyAddon

	And choose between
		EventRegistry:RegisterFrameEventAndCallback("VARIABLES_LOADED", function() MyAddon:onInitialize() end, MyAddon)

	Or
		local function OnEvent(frame, event, arg)
			if event == "ADDON_LOADED" and arg == "MyAddon" then MyAddon:onInitialize() end
		end
		local EventHandler = CreateFrame("Frame", nil)
		EventHandler:SetScript("OnEvent", OnEvent)
		EventHandler:RegisterEvent("ADDON_LOADED")

	or
		function MyAddon:OnEvent(event, arg)
			if event == "ADDON_LOADED" and arg == "MyAddon" then MyAddon:onInitialize() end
		end
		MyAddon.EventHandler = CreateFrame("Frame", nil)
		local EventHandler = MyAddon.EventHandler
		EventHandler:SetScript("OnEvent", MyAddon.OnEvent)
		EventHandler:RegisterEvent("ADDON_LOADED")

--▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
--			MODIFY EVERY CALLBACK, YOU DON'T NEED A LIBRARY IN MOST CASES
--▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒

	Example (2000 lines <> only one):

	From this:
		self:RegisterEvent("GAME_PAD_CONNECTED", self.GAME_PAD_CONNECTED)
	To this:
		EventRegistry:RegisterCallback("PLAYER_ENTERING_WORLD", self.PLAYER_ENTERING_WORLD, self)

	See chapter: AVOID USING HEAVY LIBRARIES

--▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
--			CHANGE OnInitialize() TO onInitialize()
--▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒

	If you use self:RegisterChatCommand("myaddoncmd", function)

	change it to self.db:RegisterChatCommand("myaddoncmd")
		you can use it more than once to register multiple commands

	rename your function(input)
		to MyAddon:onChatCommand(cmd, arg, ...)
		then benefit from an already splited arguments


--▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
--			IF EVERYTHING GOES RIGHT THEN,
--▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓

--▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
--			IN MyAddon.toc
--▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒

	Add FoxDB.xml
	Remove libs\AceAddon-3.0\AceAddon-3.0.xml
	Remove libs\LibStub\LibStub.lua
		except if needed by another library

--▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
--			IN MyAddon.lua
--▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒

	If you use them, change all self.db.factionrealm to self.db.frealm
	The transition exists internally to change these things (factionrealm to frealm...) in your database

	In function
	MyAddon:onInitialize()

		Add
			self.db = FoxDB:New(self, "MyAddonDB", true)		-- MyAddonDB same as in MyAddon.toc
				true indicates that you use profiles for the moment
				if you didn't use them, or changed to layouts later, you can remove it:
					self.db = FoxDB:New(self, "MyAddonDB")

	In function
	MyAddon:onLayoutLoaded()

		Put everything there was before in onInitialize() here,
			it's the new start of the addon,
			once the layouts have been loaded
			what comes after the profiles.

	In function
	MyAddon:onProfileChanged()

		There is still no more the concept of Default profile and complicated things with the definition of defaults variables.
		This is where you add them the first time,
		and check if they are still present the second time, when a player change his profile, or character changed
		so you need an if...then... wording to avoid overwriting the current content by the default one.
		(See chapter: FUNCTION CALLED BY FOXDB WHEN A PROFILE HAS BEEN CHANGED)

		Put everything you need after a new profile, reset or copy
		Note: you can optionally use MyAddon:onNewProfile()

--▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
--			TRY YOUR ADDON AT THIS STEP, IT SHOULD WORK AS BEFORE
--▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒

	Perhaps, it is still necessary to adapt the functions to manage the profiles

	See chapter: SPECIFIC PROFILES FUNCTIONS

	- self.db:GetProfiles()
	- self.db:DeleteProfile(profile)
	- self.db:ResetProfile()
	- self.db:CopyProfile(from)

--▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
--			THEN, IF YOU WANT INSTEAD OF PROFILE, USE THE NEW, FULLY AUTOMATED LAYOUT FUNCTIONS
--▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒

	See chapter: USAGE/LAYOUTS

	- function MyAddon:onLayoutLoaded(MyAddonDB)
	- function MyAddon:onNewLayout(MyAddonDB)
	- function MyAddon:onLayoutChanged(MyAddonDB)


--▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
----------------------------------------------------------------------------------------------------
--								NOTE FOR EditMode DEVELOPPERS:
----------------------------------------------------------------------------------------------------
--▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓


	If you want your addon to manages your own frames into EditMode,
		you have to use EditModeSystemSelectionTemplate for overlays,
		but you don't need another library to manage them in EditMode

	It is important for all addons to know which frames are used during EditMode,
		so they can open or close theirs menus, and highlight frames. FoxDB handle it.
		Functions have been added to manage operations once for all addons.

	So for example,

		local MyFrame = CreateFrame("Frame", "MyFrameName", UIParent, "SecureHandlerStateTemplate")
		local overlay = CreateFrame("Frame", "MyOverlayName", MyFrame, "EditModeSystemSelectionTemplate")
		!!! Don't set the overlay's parent to UIParent, otherwise EditMode will get errors when moving system frames.

		Manage position, etc.

		Then register it with the FoxDB library.
			self.db:RegisterSystemFrame(overlay)
			While in EditMode, when player click on your frame:
				Your overlay will be in yellow
				Other overlays will be in white
				You receive in onEditModeFrame function which overlay was clicked
					and decide to show/close your own menu based on that
					(Maybe you'll need to hide frames from addons that don't use FoxDB, but that's not necessary)

		You can at any time unregister it, the frame will be hidden, and not shown again while entering edit mode.
			self.db:UnregisterSystemFrame(overlay)

	Remember you can use self.db.keys.editmode in functions to be sure EditMode is active or not.

--▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
--			FUNCTION CALLED WHILE ENTERING EditMode:
--▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒

	function MyAddon:onEditModeEnter(grid, snap)

		grid is a boolean, true if Grid is checked
		snap is a boolean, true if Snap is checked

		Note: Overlays will be automatically shown and highlighted
		
		you can transmit parameters to functions of next chapter.

	end

--▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
--			FUNCTION CALLED WHILE EXITING EditMode:
--▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒

	function MyAddon:onEditModeExit()

		You can call it while entering in combat under EditMode,
			if your menu options changed in combat can cause taint.
		Overlays will be automatically hidden.
		You can close your menu.

	end

--▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
--			FUNCTION CALLED WHILE A FRAME IS ACTIVATED:
--▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒

	function MyAddon:onEditModeFrame(frame)

		If it's a system one, frame == EditModeManagerFrame

		If a non system frame is selected and system menu is shown,
			system menu and overlays registred by other addons which use FoxDB
			will automatically be closed.

		Frames will be displayed in yellow or white and made movable
			depending on whether they are selected or not.

		Open or close your own menu based on it,
		  and perform your onMouseDown actions (don't register onMouseDown).

			if frame == MyAddonOverlay then
				self:OpenMyAddonMenu()
			else
				self:CloseMyAddonMenu()
			end

	end

--▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
--			FUNCTION CALLED WHILE PLAYER CHANGE GRID OPTION: (OPTIONAL)
--▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒

	function MyAddon:onEditModeGrid(grid)

		grid is a boolean, true if Grid is checked

	end

--▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
--			FUNCTION CALLED WHILE PLAYER CHANGE SNAP OPTION: (OPTIONAL)
--▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒

	function MyAddon:onEditModeSnap(snap)

		snap is a boolean, true if Snap is checked

	end

--▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
--				WHAT YOU NEED TO IMPLEMENT:
--▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒

	Register OnDragStart and OnDragStop for overlay !!!but no OnMouseDown!!!
		overlay:SetScript('OnDragStart', self.overlays.onDragStart)
		overlay:SetScript('OnDragStop', self.overlays.onDragStop)

	function MyAddon.overlays:onDragStart()
		Hide your menu
		Your frame should follow the overlay
	end

	function MyAddon.overlays:onDragStop()
		Save your frame position according the overlay for next start
		Show your menu again
	end

	Use the menu created by yourself (SecureHandlerStateTemplate + EditModeSystemSelectionTemplate)
	(See IconManager example at the end of the file)

	function MyAddon:OpenMyAddonMenu()
		MyAddonMenu:Show()
	end

	function MyAddon:CloseMyAddonMenu()
		MyAddonMenu:Hide()
	end
]]


--▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
----------------------------------------------------------------------------------------------------
--											CODE
----------------------------------------------------------------------------------------------------
--▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓


--▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
--										VARIABLES
--▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓

FoxDB = FoxDB or {}
if not FoxDB then return end

-- library for all databases
FoxDB.db_registry = FoxDB.db_registry or {}

-- library for all icons
FoxDB.db_icons = FoxDB.db_icons or {}

-- library for all EditMode frames
FoxDB.db_frames = FoxDB.db_frames or {}

-- Locales
FoxDB.db_L = FoxDB.db_L or {}

-- table for indexing functions
local FunctionsDB = {}

-- table for indexing Profile functions if used
local FunctionsP = {}

local locale		= GetLocale()
local realmKey		= GetRealmName()
local factionKey	= UnitFactionGroup("player")
local raceKey		= select(2, UnitRace("player"))
local classKey		= select(2, UnitClass("player"))
local charKey		= UnitName("player") .. " - " .. realmKey
local frealmKey		= factionKey .. " - " .. realmKey

local min, max, rand, sqrt, pi, cos, sin, atan2 = math.min, math.max, math.random, math.sqrt, math.pi, math.cos, math.sin, math.atan2
local find = string.find
local GetLayouts = C_EditMode.GetLayouts

FoxDB.IconManager = FoxDB.IconManager or CreateFrame("Frame", nil, UIParent, "ResizeLayoutFrame")
local IconManager = FoxDB.IconManager


--▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
--										LOCALES
--▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓


if #FoxDB.db_L == 0 then
	if locale == "deDE" then
		FoxDB.db_L["Icon is not visible"]	= "Symbol ist nicht sichtbar"
		FoxDB.db_L["Tooltip deactivated"]	= "Tooltip deaktiviert"
		FoxDB.db_L["Visible"]				= "Sichtbar"
		FoxDB.db_L["Tooltip"]				= "Tooltip"
		FoxDB.db_L["Mouse On"]				= "Maus an"
		FoxDB.db_L["Mouse Out"]				= "Mouse Out"
		FoxDB.db_L["Offset"]				= "Versatz"
		FoxDB.db_L["Next minimap icon"]		= "Nächstes Minikartensymbol"

	elseif locale == "itIT" then
		FoxDB.db_L["Icon is not visible"]	= "L'icona non è visibile"
		FoxDB.db_L["Tooltip deactivated"]	= "Descrizione disattivata"
		FoxDB.db_L["Visible"]				= "Visibile"
		FoxDB.db_L["Tooltip"]				= "Descrizione"
		FoxDB.db_L["Mouse On"]				= "Mouse acceso"
		FoxDB.db_L["Mouse Out"]				= "Mouse fuori"
		FoxDB.db_L["Offset"]				= "Compensare"
		FoxDB.db_L["Next minimap icon"]		= "Icona successiva sulla minimappa"

	elseif locale == "esES" or locale == "esMX" then
		FoxDB.db_L["Icon is not visible"]	= "El icono no es visible"
		FoxDB.db_L["Tooltip deactivated"]	= "Información desactivada"
		FoxDB.db_L["Visible"]				= "Visible"
		FoxDB.db_L["Tooltip"]				= "Información"
		FoxDB.db_L["Mouse On"]				= "Ratón encendido"
		FoxDB.db_L["Mouse Out"]				= "Ratón fuera"
		FoxDB.db_L["Offset"]				= "Compensar"
		FoxDB.db_L["Next minimap icon"]		= "Siguiente icono del minimapa"

	elseif locale == "frFR" then
		FoxDB.db_L["Icon is not visible"]	= "L'icône n'est pas visible"
		FoxDB.db_L["Tooltip deactivated"]	= "Info-bulle désactivée"
		FoxDB.db_L["Visible"]				= "Visible"
		FoxDB.db_L["Tooltip"]				= "Info-bulle"
		FoxDB.db_L["Mouse On"]				= "Souris dessus"
		FoxDB.db_L["Mouse Out"]				= "Souris dehors"
		FoxDB.db_L["Offset"]				= "Offset"
		FoxDB.db_L["Next minimap icon"]		= "Prochaine Icône de minimap"

	elseif locale == "koKR" then
		FoxDB.db_L["Icon is not visible"]	= "아이콘이 보이지 않습니다"
		FoxDB.db_L["Tooltip deactivated"]	= "툴팁 비활성화됨"
		FoxDB.db_L["Visible"]				= "보이는"
		FoxDB.db_L["Tooltip"]				= "툴팁"
		FoxDB.db_L["Mouse On"]				= "마우스 온"
		FoxDB.db_L["Mouse Out"]				= "마우스 아웃"
		FoxDB.db_L["Offset"]				= "오프셋"
		FoxDB.db_L["Next minimap icon"]		= "다음 미니맵 아이콘"

	elseif locale == "ptBR" then
		FoxDB.db_L["Icon is not visible"]	= "O ícone não está visível"
		FoxDB.db_L["Tooltip deactivated"]	= "Dica desativada"
		FoxDB.db_L["Visible"]				= "Visível"
		FoxDB.db_L["Tooltip"]				= "Dica"
		FoxDB.db_L["Mouse On"]				= "Mouse entrar"
		FoxDB.db_L["Mouse Out"]				= "Mouse sair"
		FoxDB.db_L["Offset"]				= "Desvio"
		FoxDB.db_L["Next minimap icon"]		= "Próximo ícone do minimapa"

	elseif locale == "ruRU" then
		FoxDB.db_L["Icon is not visible"]	= "Значок не виден"
		FoxDB.db_L["Tooltip deactivated"]	= "Подсказка отключена"
		FoxDB.db_L["Visible"]				= "Видимый"
		FoxDB.db_L["Tooltip"]				= "Подсказка"
		FoxDB.db_L["Mouse On"]				= "Мышь включена"
		FoxDB.db_L["Mouse Out"]				= "Мышь выведена"
		FoxDB.db_L["Offset"]				= "Компенсировать"
		FoxDB.db_L["Next minimap icon"]		= "Следующий значок"

	elseif locale == "zhCN" or locale == "zhTW" then
		FoxDB.db_L["Icon is not visible"]	= "图标不可见"
		FoxDB.db_L["Tooltip deactivated"]	= "提示关闭"
		FoxDB.db_L["Visible"]				= "可见的"
		FoxDB.db_L["Tooltip"]				= "工具提示"
		FoxDB.db_L["Mouse On"]				= "鼠标打开"
		FoxDB.db_L["Mouse Out"]				= "鼠标移出"
		FoxDB.db_L["Offset"]				= "抵消"
		FoxDB.db_L["Next minimap icon"]		= "下一个小地图图标"

	else
		FoxDB.db_L["Icon is not visible"]	= true
		FoxDB.db_L["Tooltip deactivated"]	= true
		FoxDB.db_L["Visible"]				= true
		FoxDB.db_L["Tooltip"]				= true
		FoxDB.db_L["Mouse On"]				= true
		FoxDB.db_L["Mouse Out"]				= true
		FoxDB.db_L["Offset"]				= true
		FoxDB.db_L["Next minimap icon"]		= true
	end
end
local function L(text) return FoxDB.db_L[text] == true and text or FoxDB.db_L[text] end


--▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
--										UTILS
--▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓


--▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
----------------------------------------------------------------------------------------------------
-- Copy a table to another
local function copyTable(srce, dest, noreplace)
----------------------------------------------------------------------------------------------------
	if type(dest) ~= "table" then dest = {} end
	if type(srce) == "table" then
		for k,v in pairs(srce) do
			if not (noreplace and dest[k]) then
				if type(v) == "table" then v = copyTable(v, dest[k]) end
				dest[k] = v
			end
		end
	end
	return dest
end
--▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
----------------------------------------------------------------------------------------------------
-- Clean a table of its empty sections
local function clearTable(t)
----------------------------------------------------------------------------------------------------
	for k,v in pairs(t) do
		if type(v) == "table" then
			clearTable(v)
			if next(v) == nil then
				t[k] = nil
			end
		end
	end
end

--▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
--										FIRST CALL
--▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓


--▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
----------------------------------------------------------------------------------------------------
-- self.db = FoxDB:New(self, "MyAddonDB", useProfiles)
function FoxDB:New(self, MyAddonDB, useProfiles)
----------------------------------------------------------------------------------------------------
	if type(self) ~= "table"				then error("Usage: FoxDB:New(self, MyAddonDB, useProfiles): 'self' is required", 2) end
	if not MyAddonDB						then error("Usage: FoxDB:New(self, MyAddonDB, useProfiles): 'MyAddonDB', is required", 2) end
	if type(MyAddonDB) ~= "string"			then error("Usage: FoxDB:New(self, MyAddonDB, useProfiles): 'MyAddonDB', string is required", 2) end
	if useProfiles and useProfiles ~= true	then error("Usage: FoxDB:New(self, MyAddonDB, useProfiles): 'useProfiles', true is required or leave empty", 2) end
	
	-- Database initialization
	local database = _G[MyAddonDB]
	if not database then database = {} _G[MyAddonDB] = database end

	-- Transition
	if database.profileKeys then
		if database.profiles then
			if database.profiles["Default"] then
				for k,v in pairs(database.profileKeys) do
					if v == "Default" then
						copyTable(database.profiles["Default"], database.profiles[k])
					end
				end
				database.profiles["Default"] = nil
			end
		end
		if database.factionrealm then
			if not database.frealm then database.frealm = {} end
			copyTable(database.factionrealm, database.frealm)
			database.factionrealm = nil
		end
		database.profileKeys = nil
	end

	-- Generate the 'always' database keys
	if not database.global then database.global = {} end
	if not database.layouts then database.layouts = {} end
	if not database.profiles then database.profiles = {} end
	if not database.icon then database.icon = {} end

	-- Initializes the meta database
	local db = setmetatable({}, {__index = database})

	-- Database keys
	local keys = {
		["global"]		= true,			-- handled in a special case
		["layouts"]		= true,			-- handled in a special case
		["profiles"]	= true,			-- handled in a special case
		["realm"]		= realmKey,
		["faction"]		= factionKey,
		["race"]		= raceKey,
		["class"]		= classKey,
		["frealm"]		= frealmKey,
		["icon"]		= false,		-- container for icon data
		--["layout"]	= false,		-- known only after the launch of EditMode
		--["profile"]	= false,		-- set while New(self, "MyAddonDB") function
	}

	-- Add properties
	db.keys				= keys
	db.keys.name		= MyAddonDB
	db.keys.chat		= 0
	db.keys.locked		= true			-- An operation is in progress concerning the current layout or profile
	db.keys.editmode	= false			-- Whether EditMode is active or not
	db.database			= database

	-- Generate the database keys for each dynamic section
	for k,v in pairs(keys) do
		if v ~= false then if not db.database[k] then db.database[k] = {} end end
		if type(v) ~= "boolean" then
			if not db.database[k][v] then db.database[k][v] = {} end
			rawset(db, k, db.database[k][v])
		end
	end

	-- Add callbacks if exists

	if self.onIconLeftClick		then db.onIconLeftClick		= function() self.onIconLeftClick(self)		end end
	if self.onIconMiddleClick	then db.onIconMiddleClick	= function() self.onIconMiddleClick(self)	end end
	if self.onIconRightClick	then db.onIconRightClick	= function() self.onIconRightClick(self)	end end
	if self.onIconVisibility	then db.onIconVisibility	= function(visible) self.onIconVisibility(self,visible)				end end
	if self.onChatCommand		then db.onChatCommand		= function(cmd, arg, ...) self.onChatCommand(self, cmd, arg, ...)	end end

	if EditModeManagerFrame then
		if self.onLayoutLoaded	then db.onLayoutLoaded	= function() self.onLayoutLoaded(self, MyAddonDB)		end end
		if self.onNewLayout		then db.onNewLayout		= function() self.onNewLayout(self, MyAddonDB)			end end
		if self.onLayoutChanged	then db.onLayoutChanged	= function() self.onLayoutChanged(self, MyAddonDB)		end end
		if self.onLayoutRenamed	then db.onLayoutRenamed	= function() self.onLayoutRenamed(self, MyAddonDB)		end end	
		if self.onLayoutSaved	then db.onLayoutSaved	= function() self.onLayoutSaved(self, MyAddonDB)		end end

		if self.onEditModeEnter	then db.onEditModeEnter	= function(grid, snap)	self.onEditModeEnter(self, grid, snap)	end end
		if self.onEditModeGrid	then db.onEditModeGrid	= function(grid)		self.onEditModeGrid(self, grid)			end end
		if self.onEditModeSnap	then db.onEditModeSnap	= function(snap)		self.onEditModeSnap(self, snap)			end end
		if self.onEditModeExit	then db.onEditModeExit	= function()			self.onEditModeExit(self)				end end
		if self.onEditModeFrame	then db.onEditModeFrame	= function(frame, icon)	self.onEditModeFrame(self, frame, icon)	end end
	end

	-- locally add functions to do implicit calls
	for name, FunctionDB in pairs(FunctionsDB) do db[name] = FunctionDB end

	-- Add profile
	database.profile = nil
	if useProfiles then

		-- Add callbacks if exists
		if self.onNewProfile		then db.onNewProfile		= function() self.onNewProfile(self, MyAddonDB)		end end
		if self.onProfileChanged	then db.onProfileChanged	= function() self.onProfileChanged(self, MyAddonDB)	end end

		-- locally add functions related to the use of profiles to do implicit meta calls
		for name, FunctionP in pairs(FunctionsP) do db[name] = FunctionP end

		-- Generate the profile key
		db.profile = {}

		local newprofile = false
		if not db.database.profiles[charKey] then
			db.database.profiles[charKey] = {}
			newprofile = true
		end

		-- Attrib the profile
		db.profile = db.database.profiles[charKey]

		-- Change keys.profile name
		db.keys.profile = charKey

		-- Indicate if the profile was created to launch onNewProfile before onProfileChanged/onLayoutLoaded
		db.keys.newprofile = newprofile

	end

	-- Store in registry
	FoxDB.db_registry[db] = true

	db.keys.locked = false

	return db
end


--▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
--										CHAT COMMAND
--▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓


--▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
----------------------------------------------------------------------------------------------------
-- self.db = FoxDB:Add(self, "MyAddonDB", useProfiles)
function FunctionsDB:RegisterChatCommand(cmd)
----------------------------------------------------------------------------------------------------
	if not cmd									then error("Usage: RegisterChatCommand(cmd): 'cmd', is required", 2) end
	if type(cmd) ~= "string"					then error("Usage: RegisterChatCommand(cmd): 'cmd', string is required", 2) end
	if not self.onChatCommand					then error("Usage: RegisterChatCommand(cmd): you have not defined 'onChatCommand' function in your file", 2) end
	if type(self.onChatCommand) ~= "function"	then error("Usage: RegisterChatCommand(cmd): 'onChatCommand' function is required", 2) end

	if self.keys.chat == 0 then

		local function ChatCommand(msg, editbox)
			local _, _, cmd, msg = find(msg or "", "%s?(%w+)%s?(.*)")
			local _, _, arg, msg = find(msg or "", "%s?(%w+)%s?(.*)")
			self.onChatCommand(cmd or "", arg or "", msg or "")
		end
		SlashCmdList[self.keys.name] = ChatCommand

	end

	self.keys.chat = self.keys.chat+1
	_G["SLASH_"..self.keys.name..tostring(self.keys.chat)] = "/"..cmd:lower()
end


--▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
--										LAYOUTS
--▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓


--▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
---------------------------------------------------------------------------------------------------
-- Returns a table with the names of existing layouts - current in 1st place.
function FunctionsDB:GetLayouts()
----------------------------------------------------------------------------------------------------
	local layouts = {}
	layouts[1] = self.keys.layout

	local i = 2
	for layout,_ in pairs(self.database.layouts) do
		if layout ~= self.keys.layout then
			layouts[i] = layout
			i = i + 1
		end
	end

	return layouts
end
--▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
----------------------------------------------------------------------------------------------------
-- Clear the current layout.
function FunctionsDB:ResetLayout()
----------------------------------------------------------------------------------------------------
	self.keys.locked = true

		-- Clear the current layout
		for k,v in pairs(self.layout) do self.layout[k] = nil end
		if self.onNewLayout then securecallfunction(self.onNewLayout) end

	self.keys.locked = false
	if self.onLayoutChanged then securecallfunction(self.onLayoutChanged) end
end
--▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
----------------------------------------------------------------------------------------------------
-- Replace current layout by another.
function FunctionsDB:CopyLayout(from)
----------------------------------------------------------------------------------------------------
	if not from or type(from) ~= "string"	then error(("CopyLayout(from): 'from' - string expected."), 2) end
	if not self.database.layouts[from]		then error(("CopyLayout error: %q does not exist."):format(from), 2) end
	if from == self.keys.layout				then return end	--Source and destination are the same

	self.keys.locked = true

		-- Clear the destination layout
		for k,v in pairs(self.layout) do self.layout[k] = nil end

		-- Copy the layout to current (no link)
		copyTable(self.database.layouts[from], self.layout)

	self.keys.locked = false
	if self.onLayoutChanged then securecallfunction(self.onLayoutChanged) end
end


--▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
--										PROFILES
--▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓


--▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
---------------------------------------------------------------------------------------------------
-- Returns a table with the names of existing profiles - Current in 1st place.
function FunctionsDB:GetProfiles()
----------------------------------------------------------------------------------------------------
	local profiles = {}

	if self.keys.profile then
		profiles[1] = self.keys.profile
		local i = 2
		for profile,_ in pairs(self.database.profiles) do
			if profile ~= self.keys.profile then
				profiles[i] = profile
				i = i + 1
			end
		end
	else
		local i = 2
		for profile,_ in pairs(self.database.profiles) do
			profiles[i] = profile
			i = i + 1
		end
	end

	return profiles
end
--▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
----------------------------------------------------------------------------------------------------
-- Deletes a profile, except current.
function FunctionsDB:DeleteProfile(profilename)
----------------------------------------------------------------------------------------------------
	if not profilename or type(profilename) ~= "string"	then error(("DeleteProfile(profilename): 'profilename' - string expected."), 2) end
	if not self.database.profiles[profilename]			then error(("DeleteProfile error: %q does not exist."):format(profilename), 2) end
	if profilename == self.keys.profile					then return end	-- Use ResetProfile()

	-- Remove the profile
	self.database.profiles[profilename] = nil
end
--▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
----------------------------------------------------------------------------------------------------
-- Clear the current profile.
function FunctionsP:ResetProfile()
----------------------------------------------------------------------------------------------------
	self.keys.locked = true

	-- Clear the current profile
	for k,v in pairs(self.profile) do
		self.profile[k] = nil
	end
	if self.onNewProfile then securecallfunction(self.onNewProfile) end

	self.keys.locked = false
	if self.onProfileChanged then securecallfunction(self.onProfileChanged) end
end
--▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
----------------------------------------------------------------------------------------------------
-- Replace current profile by another.
function FunctionsP:CopyProfile(from)
----------------------------------------------------------------------------------------------------
	if not from or type(from) ~= "string"	then error(("CopyProfile(from): 'from' - string expected."), 2) end
	if not self.database.profiles[from]		then error(("CopyProfile error: %q does not exist."):format(from), 2) end
	if from == self.keys.profile			then return end	--Source and destination are the same

	self.keys.locked = true

	-- Clear the current profile
	for k,v in pairs(self.profile) do self.profile[k] = nil end

	-- Copy the profile to current (no link)
	copyTable(self.database.profiles[from], self.profile)

	self.keys.locked = false
	if self.onProfileChanged then securecallfunction(self.onProfileChanged) end
end


--▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
--										EVENTS
--▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓


local EditModeOn = false
local FoxDBLayouts = {}
local FoxDBLayoutIndex = 0
local FoxDBLayoutNumber = 0
local FoxDBLayoutName = nil
local Grid = EditModeManagerFrame.ShowGridCheckButton
local Snap = EditModeManagerFrame.EnableSnapCheckButton

--▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
----------------------------------------------------------------------------------------------------
local function onEditModeEnter()
----------------------------------------------------------------------------------------------------
	EditModeOn = true
	for editmodeframe,enabled in pairs(FoxDB.db_frames) do
		if enabled then
			securecallfunction(editmodeframe.Show, editmodeframe)
			securecallfunction(editmodeframe.ShowHighlighted, editmodeframe)		-- Displays in white
		end
	end
	local grid = Grid:IsControlChecked() or false
	local snap = Snap:IsControlChecked() or false
	for db in pairs(FoxDB.db_registry) do
		db.keys.editmode = true
		if db.onEditModeEnter then securecallfunction(db.onEditModeEnter, grid, snap) end
	end
	for _,button in pairs(FoxDB.db_icons) do
		button:EnableMouseWheel(true)
		button:SetScript("OnMouseWheel", function(self, wheel) securecallfunction(button.onMouseWheel, button, wheel) end)
		button:SetFrameStrata("DIALOG")
		button:Show()
	end
end
EventRegistry:RegisterCallback("EditMode.Enter", onEditModeEnter)
--▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
----------------------------------------------------------------------------------------------------
local function onEditModeGrid()
----------------------------------------------------------------------------------------------------
	local grid = Grid:IsControlChecked() or false
	for db in pairs(FoxDB.db_registry) do
		if db.onEditModeGrid then securecallfunction(db.onEditModeGrid, grid) end
	end
end
hooksecurefunc(EditModeManagerFrame.ShowGridCheckButton, "OnCheckButtonClick", onEditModeGrid)
--▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
----------------------------------------------------------------------------------------------------
local function onEditModeSnap()
----------------------------------------------------------------------------------------------------
	local snap = Snap:IsControlChecked() or false
	for db in pairs(FoxDB.db_registry) do
		if db.onEditModeGrid then securecallfunction(db.onEditModeSnap, snap) end
	end
end
hooksecurefunc(EditModeManagerFrame.EnableSnapCheckButton, "OnCheckButtonClick", onEditModeSnap)
--▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
----------------------------------------------------------------------------------------------------
local function onEditModeExit()
----------------------------------------------------------------------------------------------------
	EditModeOn = false
	for editmodeframe,enabled in pairs(FoxDB.db_frames) do
		if enabled then
			editmodeframe:Hide()
		end
	end
	for db in pairs(FoxDB.db_registry) do
		db.keys.editmode = false
		if db.onEditModeExit then securecallfunction(db.onEditModeExit) end
	end
	if IconManager then IconManager:Hide() end
	for _,button in pairs(FoxDB.db_icons) do
		button:EnableMouseWheel(false)
		button:SetScript("OnMouseWheel", nil)
		button:SetFrameStrata("MEDIUM")
		if button:Visibility() == false then button:Hide() end
	end
end
EventRegistry:RegisterCallback("EditMode.Exit", onEditModeExit)
--▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
----------------------------------------------------------------------------------------------------
local function onLayoutSaved()
----------------------------------------------------------------------------------------------------
	local GetLayouts = GetLayouts()
	local Layouts = GetLayouts.layouts
	local LayoutIndex = GetLayouts.activeLayout
	local LayoutNumber = #Layouts + 2

	if LayoutNumber == FoxDBLayoutNumber then					-- Filter other events of onLayoutUpdated()
		local index = nil
		for i = 1, LayoutNumber - 2 do
			if Layouts[i].layoutName ~= FoxDBLayouts[i].layoutName then index = i end
		end
		if index then
			local oldname = FoxDBLayouts[index].layoutName
			local newname = Layouts[index].layoutName
			if index == FoxDBLayoutIndex - 2 then				-- If Current layout
				for db in pairs(FoxDB.db_registry) do
					db.keys.locked = true

						-- Remove the new layout if exists
						db.database.layouts[newname] = nil

						-- Copy the current layout to new destination
						rawset(db.database.layouts, newname, db.database.layouts[oldname])

						-- Remove the old layout
						db.layout = nil
						db.database.layouts[oldname] = nil

						-- Reattrib the layout
						db.layout = db.database.layouts[newname]

						-- Change keys.layout name
						db.keys.layout = newname

					db.keys.locked = false
				end
				FoxDBLayoutName = newname
			else
				for db in pairs(FoxDB.db_registry) do
					-- Remove the new layout if exists
					db.database.layouts[newname] = nil

					-- Copy the old named layout to new destination
					rawset(db.database.layouts, newname, db.database.layouts[oldname])

					-- Remove the old layout
					db.database.layouts[oldname] = nil
				end
			end
			FoxDBLayouts = Layouts
			for db in pairs(FoxDB.db_registry) do
				if db.onLayoutRenamed then securecallfunction(db.onLayoutRenamed) end
			end
		else
			for db in pairs(FoxDB.db_registry) do
				if db.onLayoutSaved then securecallfunction(db.onLayoutSaved) end
			end
		end
	end
end
EventRegistry:RegisterCallback("EditMode.SavedLayouts", onLayoutSaved)
--▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
----------------------------------------------------------------------------------------------------
local function onLayoutUpdated()
----------------------------------------------------------------------------------------------------
	local Layouts = GetLayouts().layouts
	local LayoutIndex = GetLayouts().activeLayout
	local LayoutName = nil
	if LayoutIndex > 2 then LayoutName = Layouts[LayoutIndex - 2].layoutName elseif LayoutIndex == 2 then LayoutName = "Preset_Classic" else LayoutName = "Preset_Modern" end
	local LayoutNumber = #Layouts + 2

	if FoxDBLayoutName == nil then						-- Loading the layout while edit mode initialization
		if LayoutName then
			for db in pairs(FoxDB.db_registry) do
				local created = false
				db.keys.locked = true

					-- Do the new layout already exist?
					if not db.database.layouts[LayoutName] then
						db.database.layouts[LayoutName] = {}
						created = true
					end

					-- Attrib the layout
					db.layout = nil
					db.layout = {}
					db.layout = db.database.layouts[LayoutName]

					-- Change keys.layout name
					db.keys.layout = LayoutName
					if created then if db.onNewLayout then securecallfunction(db.onNewLayout) end end

				db.keys.locked = false

				if db.keys.newprofile then
					if db.onNewProfile then securecallfunction(db.onNewProfile) end
					db.keys.newprofile = false
				end
				if db.onProfileChanged	then securecallfunction(db.onProfileChanged)	end
				if db.onLayoutLoaded	then securecallfunction(db.onLayoutLoaded)		end
			end
			FoxDBLayoutName = LayoutName
		end
	elseif LayoutNumber > FoxDBLayoutNumber then		-- Adding a layout swap automatically to it
		for db in pairs(FoxDB.db_registry) do
			db.keys.locked = true
				-- Remove the current layout
				db.layout = nil

				-- overwrite but not delete if already exists in an old SavedVariables copied before
				if not db.database.layouts[LayoutName] then db.database.layouts[LayoutName] = {} end

				-- Copy the layout to destination (no link)
				copyTable(db.database.layouts[FoxDBLayoutName], db.database.layouts[LayoutName])

				-- Attrib the layout
				db.layout = db.database.layouts[LayoutName]

				-- Change keys.layout name
				db.keys.layout = LayoutName

			db.keys.locked = false
			if db.onLayoutChanged then securecallfunction(db.onLayoutChanged) end
		end
	elseif LayoutNumber < FoxDBLayoutNumber then		-- Romoving a layout swap automatically to a preset if we were on that layout, else we stay on actual layout
		if LayoutNumber == 2 then						-- If the layout was the last non preset layout
			for db in pairs(FoxDB.db_registry) do
				db.keys.locked = true

					-- Remove the current layout
					db.layout = nil

					-- Do the new layout already exist?
					if not db.database.layouts[LayoutName] then
						-- Create new empty layout
						db.database.layouts[LayoutName] = {}

						-- Copy the layout to destination (no link)
						copyTable(db.database.layouts[FoxDBLayouts[1].layoutName], db.database.layouts[LayoutName])
					end

					-- Remove the deleted layout
					db.database.layouts[FoxDBLayouts[1].layoutName] = nil

					-- Attrib the layout
					db.layout = db.database.layouts[LayoutName]

					-- Change keys.layout name
					db.keys.layout = LayoutName

				db.keys.locked = false
				if db.onLayoutChanged then securecallfunction(db.onLayoutChanged) end
			end
		else	
			local nameold = nil
			local Layoutfound = false
			for index = 3, LayoutNumber do				-- Else if not latest non preset layout
				if not Layoutfound then
					nameold = FoxDBLayouts[index - 2].layoutName
					local namenew = Layouts[index - 2].layoutName

					if nameold ~= namenew then
						Layoutfound = true
					end
				end
			end
			if not Layoutfound then						-- Else if the latest non preset layout
				nameold = FoxDBLayouts[FoxDBLayoutNumber - 2].layoutName
			end
			for db in pairs(FoxDB.db_registry) do
				db.keys.locked = true

					-- Remove the current layout
					db.layout = nil

					-- Do the new layout already exist?
					if not db.database.layouts[LayoutName] then
						-- Create new empty layout
						db.database.layouts[LayoutName] = {}

						-- Copy the layout to destination (no link)
						copyTable(db.database.layouts[FoxDBLayoutName], db.database.layouts[LayoutName])
					end

					-- Remove the deleted layout
					db.database.layouts[nameold] = nil

					-- Attrib the layout
					db.layout = db.database.layouts[LayoutName]

					-- Change keys.layout name
					db.keys.layout = LayoutName

				db.keys.locked = false
				if db.onLayoutChanged then securecallfunction(db.onLayoutChanged) end
			end
		end
	else
		for db in pairs(FoxDB.db_registry) do
			db.keys.locked = true

				-- Remove the current layout
				db.layout = nil

				-- Do the new layout already exist?
				if not db.database.layouts[LayoutName] then
					-- Create new empty layout
					db.database.layouts[LayoutName] = {}

					-- Copy the layout to destination (no link)
					copyTable(db.database.layouts[FoxDBLayoutName], db.database.layouts[LayoutName])
				end

				-- Attrib the layout
				db.layout = db.database.layouts[LayoutName]

				-- Change keys.layout name
				db.keys.layout = LayoutName

			db.keys.locked = false
			if db.onLayoutChanged then securecallfunction(db.onLayoutChanged) end
		end
	end

	FoxDBLayouts = Layouts
	FoxDBLayoutIndex = LayoutIndex
	FoxDBLayoutName = LayoutName
	FoxDBLayoutNumber = LayoutNumber
end
EventRegistry:RegisterFrameEventAndCallback("EDIT_MODE_LAYOUTS_UPDATED", onLayoutUpdated, FoxDB)
--▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
local function onPlayerLogout()
	for db in pairs(FoxDB.db_registry) do
		for _,v in pairs(db) do if type(v) == "table" and v ~= db.profile and v ~= db.layout then clearTable(v) end end
	end
end
EventRegistry:RegisterFrameEventAndCallback("PLAYER_LOGOUT", onPlayerLogout, FoxDB)


--▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
--										EDITMODE FRAMES
--▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓


--▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
----------------------------------------------------------------------------------------------------
-- Callback to know if a frame has been clicked while EditMode; all addons, not only System frames.
local function onFrameClicked(frame)
----------------------------------------------------------------------------------------------------
	if IconManager then IconManager:Hide() end

	for editmodeframe,enabled in pairs(FoxDB.db_frames) do
		if enabled then
			editmodeframe:SetMovable(false)
			editmodeframe:ShowHighlighted()		-- Displays in white
		end
	end

	if FoxDB.db_frames[frame] then
		-- Close the current system menu, if it exists. Taint if InCombat.
		if not InCombatLockdown() then EditModeManagerFrame:ClearSelectedSystem() end
		frame:ShowSelected(true)				-- Displays in yellow
		frame:SetMovable(true)
	end

	for db in pairs(FoxDB.db_registry) do
		if db.onEditModeFrame then securecallfunction(db.onEditModeFrame, frame, false) end
	end
end
hooksecurefunc(EditModeManagerFrame, 'SelectSystem', onFrameClicked)
--▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
----------------------------------------------------------------------------------------------------
-- Callback to know if an iconn has been clicked while EditMode.
local function onEditModeButtonClicked(icon, closeonly, ...)
----------------------------------------------------------------------------------------------------
	if IconManager then IconManager:Hide() end

	-- Close the current system menu, if it exists. Taint if InCombat.
	if not InCombatLockdown() then EditModeManagerFrame:ClearSelectedSystem() end
	if closeonly then return end

	if icon ~= IconManager.MinimapIcon then
		IconManager.MinimapIcon = icon
		IconManager.Title:SetText(icon.label)
		IconManager.Tooltip.Button:SetChecked(icon.Tooltip())
		IconManager.Visibility.Button:SetChecked(icon.Visibility())
		IconManager.MouseOn.Slider:SetValue(icon.Alpha1())
		IconManager.MouseOut.Slider:SetValue(icon.Alpha2())
		IconManager.Offset.Slider:SetValue(icon.Offset())
	end
	IconManager:Show()
	IconManager:SetSize(383, 239)

	for db in pairs(FoxDB.db_registry) do
		if db.onEditModeFrame then securecallfunction(db.onEditModeFrame, icon, true) end
	end
end
--▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
----------------------------------------------------------------------------------------------------
function FunctionsDB:RegisterSystemFrame(frame)
----------------------------------------------------------------------------------------------------
	FoxDB.db_frames[frame] = true
	frame:SetScript('OnMouseDown', onFrameClicked)
	if EditModeOn then frame:Show() else frame:Hide() end
end
--▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
----------------------------------------------------------------------------------------------------
function FunctionsDB:UnregisterSystemFrame(frame)
----------------------------------------------------------------------------------------------------
	FoxDB.db_frames[frame] = false
	frame:SetScript('OnMouseDown', nil)
	frame:Hide()
end


--▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
--										ICONS
--▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓


--▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
----------------------------------------------------------------------------------------------------
-- Returns the table with all FoxDB minimap icons.
function FunctionsDB:GetIcons()
----------------------------------------------------------------------------------------------------
	return FoxDB.db_icons
end
--▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
----------------------------------------------------------------------------------------------------
-- Sends the next icon from current icon.
function FunctionsDB:GetNextIcon()
----------------------------------------------------------------------------------------------------
	if not EditModeOn then return end

	local found = 0
	local first = true
	local icon1 = nil
	for index,icon in pairs(FoxDB.db_icons) do
		if first == true then icon1 = icon first = false end
		if found == 1 then
			found = 2
			onEditModeButtonClicked(icon)
			break
		elseif icon == IconManager.MinimapIcon then
			found = 1
		end
	end
	if found ~= 2 and icon1 then onEditModeButtonClicked(icon1) end
end
--▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
----------------------------------------------------------------------------------------------------
function FunctionsDB:IconSquare(isSquare)
----------------------------------------------------------------------------------------------------
	for label,button in pairs(FoxDB.db_icons) do
		securecallfunction(button.Square, isSquare)
	end
end
--▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
----------------------------------------------------------------------------------------------------
function FunctionsDB:IconStart()
----------------------------------------------------------------------------------------------------
	if not self.icon then self.icon = {} end
	local IconName = "FoxDB_Icon_"..(self.icon.label or "")

	-- Errors
	if not self.icon.label								then error("Cannot start icon without label, use self.db.icon.label =") end
	if type(self.icon.label) ~= "string"				then error("Cannot start icon without icon label, string expected") end
	if FoxDB.db_icons[IconName]							then error("The icon's unique identifier ".. self.icon.label .." is already registered.") return end
	if not self.icon.file								then error("Can't start icon without icon object, use self.db.icon.file =") end

	-- Variables
	if type(self.icon.tooltip)		~= "boolean"	then self.icon.tooltip		= true							end
	if type(self.icon.visible)		~= "boolean"	then self.icon.visible		= true							end
	if type(self.icon.alpha1)		~= "number"		then self.icon.alpha1		= 0.8							end
	if type(self.icon.alpha2)		~= "number"		then self.icon.alpha2		= min(0.6, self.icon.alpha1)	end
	if type(self.icon.scale)		~= "number"		then self.icon.scale		= 0.9							end
	if type(self.icon.square)		~= "boolean"	then self.icon.square		= false							end
	if type(self.icon.angle)		~= "number"		then self.icon.angle		= rand(-pi, pi)					end
	if type(self.icon.offset)		~= "number"		then self.icon.offset		= 0								end
	if type(self.icon.line1)		~= "string"		then self.icon.line1		= ""							end
	if type(self.icon.line2)		~= "string"		then self.icon.line2		= ""							end
	if type(self.icon.line3)		~= "string"		then self.icon.line3		= ""							end

	-- Button
	local button = self.iconinuse or CreateFrame("Button", IconName, UIParent)
	button.label = self.icon.label
	button:SetSize(30, 30)
	button:SetFrameStrata("MEDIUM")
	button:SetFixedFrameStrata(false)
	button:SetFrameLevel(1002)
	button:SetFixedFrameLevel(true)
	-- Icon
	button.icon = button.icon or button:CreateTexture(IconName.."_icon", "BACKGROUND")
	button.icon:SetSize(25, 25)
	button.icon:SetPoint("CENTER", 0.34, 0)
	button.icon:SetTexture(self.icon.file)
	button.icon:SetMask("Interface\\Masks\\CircleMaskScalable")
	-- Normal
	button.normal = button.normal or button:CreateTexture(IconName.."_normal", "BORDER")
	button.normal:SetSize(30, 30)
	button.normal:SetAlpha(0.65)
	button.normal:SetPoint("CENTER")
	button.normal:SetTexture("Interface\\COMMON\\GoldRing")
	-- highlight
	button.highlight = button.highlight or button:CreateTexture(IconName.."_highlight", "HIGHLIGHT")
	button.highlight:SetSize(24.467, 24.367)
	button.highlight:SetAlpha(0.75)
	button.highlight:SetPoint("CENTER",1.43,-1.01)
	button.highlight:SetTexture("Interface\\COMMON\\CommonRoundHighlight")

	-- Tooltip
	button.Tooltip = function(tooltip) if type(tooltip) ~= "boolean" then return self.icon.tooltip else self.icon.tooltip = tooltip end end
	button.onIconEnter = function(btn)
		if not btn then return end
		btn:SetAlpha(self.icon.alpha1)
		if GameTooltip and (self.icon.tooltip == true or EditModeOn == true) then
			GameTooltip:ClearLines()
			GameTooltip:SetOwner(button, "ANCHOR_RIGHT")
			GameTooltip:AddLine(self.icon.label, 0, 1, 0)
			if EditModeOn == true then
				GameTooltip:AddDoubleLine("|cff69ccf0Scale:|r",	("|cffffffff%s|r"):format(self.icon.scale))
				if self.icon.visible == false then			GameTooltip:AddLine(L"Icon is not visible", 1, 1, 1) end
			end
			if self.icon.tooltip == true then
				if type(self.icon.line1) == "string" then	GameTooltip:AddDoubleLine("|cff69ccf0Left:|r", 	("|cffffffff%s|r"):format(self.icon.line1)) end
				if type(self.icon.line2) == "string" then	GameTooltip:AddDoubleLine("|cff69ccf0Middle:|r",("|cffffffff%s|r"):format(self.icon.line2)) end
				if type(self.icon.line3) == "string" then	GameTooltip:AddDoubleLine("|cff69ccf0Right:|r",	("|cffffffff%s|r"):format(self.icon.line3)) end
			else
															GameTooltip:AddLine(L"Tooltip deactivated", 1, 1, 1)
			end
			GameTooltip:Show()
		end
	end
	button.onIconLeave = function(btn)
		if not btn then return end
		btn:SetAlpha(self.icon.alpha2)
		if (self.icon.tooltip == true or EditModeOn == true) and GameTooltip then GameTooltip:Hide() end
	end
	button:SetScript("OnEnter", function(btn) securecallfunction(button.onIconEnter, btn) end)
	button:SetScript("OnLeave", function(btn) securecallfunction(button.onIconLeave, btn) end)

	-- Visibility
	button.Visibility = function(visible)
			if visible ~= "_" then if type(visible) ~= "boolean" then return self.icon.visible else self.icon.visible = visible end end
			if self.onIconVisibility then securecallfunction(self.onIconVisibility, self.icon.visible) end
			if EditModeOn == true then return end
			if self.icon.visible == true then
				button:Show()
				securecallfunction(button.Minimap)
			else
				button:Hide()
			end
		end

	-- Transparency
	button.Alpha1 = function(alpha1)
			if alpha1 ~= "_" then if type(alpha1) ~= "number" then return self.icon.alpha1 else self.icon.alpha1 = min(max(alpha1, 0.2), 1) end end
			self.icon.alpha2 = min(max(self.icon.alpha2, 0), self.icon.alpha1)
			button:SetAlpha(self.icon.alpha1)
		end
	button.Alpha2 = function(alpha2)
			if alpha2 ~= "_" then if type(alpha2) ~= "number" then return self.icon.alpha2 else self.icon.alpha2 = min(max(alpha2, 0), 1) end end
			self.icon.alpha1 = min(max(self.icon.alpha1, self.icon.alpha2), 1)
			button:SetAlpha(self.icon.alpha2)
		end

	-- Scale
	button.Scale = function(scale)
			if scale ~= "_" then if type(scale) ~= "number" then return self.icon.scale else self.icon.scale = min(max(scale, 0.8), 3) end end
			button:ClearAllPoints()
			button:SetScale(self.icon.scale*MinimapCluster:GetScale()*Minimap:GetScale())
			securecallfunction(button.Minimap)
		end

	-- Position
	button:SetDontSavePosition(true)
	button:SetClampedToScreen(true)
	button:SetMovable(true)
	button:RegisterForDrag("LeftButton")
	button.Minimap = function()
			if not Minimap then button:ClearAllPoints() button:Hide() end
			self.icon.angle = min(max(self.icon.angle, -pi), pi)
			local w = Minimap:GetWidth()/2	+ self.icon.offset
			local h = Minimap:GetHeight()/2	+ self.icon.offset
			local x = cos(self.icon.angle)*w
			local y = sin(self.icon.angle)*h
			if self.icon.square == true then
				x = max(-w, min(sqrt(2)*x, w))
				y = max(-h, min(sqrt(2)*y, h))
			end
			button:ClearAllPoints()
			local scale = button:GetEffectiveScale()
			button:SetPoint("CENTER", Minimap, "CENTER", x/self.icon.scale, y/self.icon.scale)
		end
	button.Square = function(square)
			if square ~= "_" then if type(square) ~= "boolean" then return self.icon.square
				else
					self.icon.square = square
					securecallfunction(button.Scale, "_")
					return
				end
			end
			securecallfunction(button.Minimap)
		end
	button.Offset = function(offset)
			if offset ~= "_" then if type(offset) ~= "number" then return self.icon.offset else self.icon.offset = min(max(offset, -35), 35) end end
			securecallfunction(button.Minimap)
		end
	button.onReceiveDrag = function(btn)
		local x, y = GetCursorPosition()
		if Minimap then
			local scale = Minimap:GetEffectiveScale()
			local z, t = Minimap:GetCenter()
			z, t = z*scale, t*scale
			self.icon.angle = atan2(y-t, x-z)
			securecallfunction(button.Minimap)
		end
	end
	button.onDragStart = function(btn)
			if self.icon.tooltip then GameTooltip:Hide() end
			if EditModeOn == true then securecallfunction(onEditModeButtonClicked, button, true) end
			button:SetScript("OnUpdate", function(self) if self.onReceiveDrag then securecallfunction(self.onReceiveDrag, button) end end)
			button:StartMoving()
		end
	button.onDragStop = function(btn)
			button:StopMovingOrSizing()
			button:SetScript("OnUpdate", nil)
		end
	button.onEditModeEnter = function(btn)
			button:SetScript("OnDragStart", function(self) if self.onDragStart then securecallfunction(self.onDragStart, button) end end)
			button:SetScript("OnDragStop", function(self) if self.onDragStop then securecallfunction(self.onDragStop, button) end end)
		end
	button.onEditModeExit = function(btn)
			button:SetScript("OnDragStart", nil)
			button:SetScript("OnDragStop", nil)
		end
	EventRegistry:RegisterCallback("EditMode.Enter", function() button:onEditModeEnter() end, button)
	EventRegistry:RegisterCallback("EditMode.Exit", function() button:onEditModeExit() end, button)

	-- Mouse
	if self.onIconLeftClick		then button.onIconLeftClick		= self.onIconLeftClick		end
	if self.onIconRightClick	then button.onIconRightClick	= self.onIconRightClick		end
	if self.onIconMiddleClick	then button.onIconMiddleClick	= self.onIconMiddleClick	end
	button:RegisterForClicks("anyUp")
	button:SetScript("OnClick", function(self, btn)
			if		btn == "LeftButton"	then
				if EditModeOn == true											then securecallfunction(onEditModeButtonClicked, button)
				else								if self.onIconLeftClick		then securecallfunction(self.onIconLeftClick)		end
				end
			elseif	btn == "RightButton"	then	if self.onIconRightClick	then securecallfunction(self.onIconRightClick)		end
			elseif	btn == "MiddleButton"	then	if self.onIconMiddleClick	then securecallfunction(self.onIconMiddleClick)		end
			end
		end)
	button.onMouseWheel = function(btn, wheel)
			securecallfunction(button.Scale, self.icon.scale+wheel*0.05)
			securecallfunction(button.onIconEnter, button)
		end

	-- Initialization
	button.onInit = function()
			EventRegistry:UnregisterFrameEventAndCallback("PLAYER_LOGIN", button)
			securecallfunction(button.Visibility, "_")
			securecallfunction(button.Alpha2, "_")
			securecallfunction(button.Scale, "_")
			securecallfunction(button.Offset, "_")
			securecallfunction(button.Minimap)
			Minimap:HookScript("OnSizeChanged",			function(mm, w, h)	securecallfunction(button.Scale, "_")		end)
			MinimapCluster:HookScript("OnSizeChanged",	function(cl, w, h)	securecallfunction(button.Scale, "_")		end)
			MinimapBackdrop:HookScript("OnHide",		function(bd)		securecallfunction(button.Hide, button)		end)
			MinimapBackdrop:HookScript("OnShow",		function(bd)		securecallfunction(button.Visibility, "_")	end)
		end
	EventRegistry:RegisterFrameEventAndCallback("PLAYER_LOGIN", function() button:onInit() end, button)

	self.iconinuse = button
	FoxDB.db_icons[IconName] = button
	IconManager.MinimapIcon = icon
end


--▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
--										ICON MANAGER
--▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓


--▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
----------------------------------------------------------------------------------------------------
FoxDB.IconManagerInitialized = FoxDB.IconManagerInitialized or false
local function IconManagerInit()
----------------------------------------------------------------------------------------------------
	if FoxDB.IconManagerInitialized then return else FoxDB.IconManagerInitialized = true end
	EventRegistry:UnregisterFrameEventAndCallback("PLAYER_LOGIN", IconManager)

	IconManager:SetSize(383, 239)
	IconManager:SetFrameStrata("DIALOG")
	IconManager:SetFrameLevel(200)
	IconManager:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
	IconManager:EnableMouse(true)
	IconManager:SetMovable(true)
	IconManager:SetClampedToScreen(true)
	IconManager:SetDontSavePosition(true)
	IconManager:RegisterForDrag("LeftButton", "RightButton")
	IconManager:SetScript("OnDragStart", function() IconManager:StartMoving() end)
	IconManager:SetScript("OnDragStop", function() IconManager:StopMovingOrSizing() end)
	IconManager:Hide()

	IconManager.Border = IconManager.Border or CreateFrame("Frame", nil, IconManager, "DialogBorderTranslucentTemplate")
	IconManager.Border.ignoreInLayout = true
	IconManager.Border:Show()

	IconManager.Close = IconManager.Close or CreateFrame("Button", nil, IconManager, "UIPanelCloseButton")
	IconManager.Close:SetPoint("TOPRIGHT")
	IconManager.Close.ignoreInLayout = true
	IconManager.Close:Show()

	IconManager.Title = IconManager.Title or IconManager:CreateFontString(nil, nil, 'GameFontHighlightLarge')
	IconManager.Title:SetPoint('TOP', 0, -15)
	IconManager.Title:Show()

	IconManager.Visibility = IconManager.Visibility or CreateFrame("Frame", nil, IconManager, "EditModeSettingCheckboxTemplate")
	IconManager.Visibility.Label:SetWidth(145)
	IconManager.Visibility.Label:SetText(L"Visible")
	IconManager.Visibility:SetPoint("TOPLEFT", IconManager, "TOPLEFT", 20, -43)
	IconManager.Visibility.Button:SetScript("OnClick", function(self, event, ...) securecallfunction(IconManager.MinimapIcon.Visibility, self:GetChecked()) end)
	IconManager.Visibility:Show()

	IconManager.Tooltip = IconManager.Tooltip or CreateFrame("Frame", nil, IconManager, "EditModeSettingCheckboxTemplate")
	IconManager.Tooltip.Label:SetWidth(165)
	IconManager.Tooltip.Label:SetText(L"Tooltip")
	IconManager.Tooltip:SetPoint("TOPLEFT", IconManager.Visibility, "TOPRIGHT", 0, 0)
	IconManager.Tooltip.Button:SetScript("OnClick", function(self, event, ...) securecallfunction(IconManager.MinimapIcon.Tooltip, self:GetChecked()) end)
	IconManager.Tooltip:Show()

	IconManager.MouseOn = IconManager.MouseOn or CreateFrame("Frame", nil, IconManager, "EditModeSettingSliderTemplate")
	IconManager.MouseOn.Slider:SetWidth(190)
	IconManager.MouseOn.Slider.MinText:Hide()
	IconManager.MouseOn.Slider.MaxText:Hide()
	IconManager.MouseOn.Label:SetText(L"Mouse On")
	IconManager.MouseOn:SetPoint("TOPLEFT", IconManager.Visibility, "BOTTOMLEFT", 0, 0)
	IconManager.MouseOn.formatters = {}
	IconManager.MouseOn.formatters[MinimalSliderWithSteppersMixin.Label.Right] = CreateMinimalSliderFormatter(
			MinimalSliderWithSteppersMixin.Label.Right,
			function(value) if value ~= -1 then 
					securecallfunction(IconManager.MinimapIcon.Alpha1, value)
					IconManager.MouseOut.Slider:SetValue(IconManager.MinimapIcon.Alpha2())
					return ("%d%%"):format(value*100)
				end
			end)
	IconManager.MouseOn.Slider:Init(-1, 0.2, 1, 80, IconManager.MouseOn.formatters)
	IconManager.MouseOn.Slider.Slider:SetScript("OnMouseUp", function(self) securecallfunction(IconManager.MinimapIcon.Alpha2, "_") end)
	IconManager.MouseOn:Show()

	IconManager.MouseOut = IconManager.MouseOut or CreateFrame("Frame", nil, IconManager, "EditModeSettingSliderTemplate")
	IconManager.MouseOut.Slider:SetWidth(190)
	IconManager.MouseOut.Slider.MinText:Hide()
	IconManager.MouseOut.Slider.MaxText:Hide()
	IconManager.MouseOut.Label:SetText(L"Mouse Out")
	IconManager.MouseOut:SetPoint("TOPLEFT", IconManager.MouseOn, "BOTTOMLEFT", 0, 0)
	IconManager.MouseOut.formatters = {}
	IconManager.MouseOut.formatters[MinimalSliderWithSteppersMixin.Label.Right] = CreateMinimalSliderFormatter(
			MinimalSliderWithSteppersMixin.Label.Right,
			function(value) if value ~= -1 then 
					securecallfunction(IconManager.MinimapIcon.Alpha2, value)
					IconManager.MouseOn.Slider:SetValue(IconManager.MinimapIcon.Alpha1())
					return ("%d%%"):format(value*100)
				end
			end)
	IconManager.MouseOut.Slider:Init(-1, 0, 1, 100, IconManager.MouseOut.formatters)
	IconManager.MouseOut:Show()

	IconManager.Offset = IconManager.Offset or CreateFrame("Frame", nil, IconManager, "EditModeSettingSliderTemplate")
	IconManager.Offset.Slider:SetWidth(190)
	IconManager.Offset.Slider.MinText:Hide()
	IconManager.Offset.Slider.MaxText:Hide()
	IconManager.Offset.Label:SetText(L"Offset")
	IconManager.Offset:SetPoint("TOPLEFT", IconManager.MouseOut, "BOTTOMLEFT", 0, 0)
	IconManager.Offset.formatters = {}
	IconManager.Offset.formatters[MinimalSliderWithSteppersMixin.Label.Right] = CreateMinimalSliderFormatter(
			MinimalSliderWithSteppersMixin.Label.Right,
			function(value)
				if value ~= -1 then securecallfunction(IconManager.MinimapIcon.Offset, value) return value end
			end)
	IconManager.Offset.Slider:Init(-1, -35, 35, 70, IconManager.Offset.formatters)
	IconManager.Offset:Show()

	IconManager.Divider2 = IconManager.Divider2 or CreateFrame("Frame", nil, IconManager)
	IconManager.Divider2:SetSize(330,16)
	IconManager.Divider2:SetPoint("TOPLEFT", IconManager.Offset, "BOTTOMLEFT", 0, 3)
	IconManager.Divider2.divider = IconManager.Divider2:CreateTexture(nil, "ARTWORK")
	IconManager.Divider2.divider:SetTexture("Interface\\FriendsFrame\\UI-FriendsFrame-OnlineDivider") --389194
	IconManager.Divider2.divider:SetSize(330,16)
	IconManager.Divider2.divider:SetPoint("TOPLEFT")
	IconManager.Divider2:Show()

	IconManager.Next = IconManager.Next or CreateFrame("Button", nil, IconManager, "EditModeSystemSettingsDialogButtonTemplate")
	IconManager.Next:SetWidth(330)
	IconManager.Next:SetText(L"Next minimap icon")
	IconManager.Next:SetPoint("TOPLEFT", IconManager.Divider2, "BOTTOMLEFT", -1, -2)	-- 0, -12 after divider if CheckBox
	IconManager.Next:SetOnClickHandler(function() securecallfunction(FunctionsDB.GetNextIcon, FoxDB) end)
	IconManager.Next:Show()
end
EventRegistry:RegisterFrameEventAndCallback("PLAYER_LOGIN", IconManagerInit, IconManager)
