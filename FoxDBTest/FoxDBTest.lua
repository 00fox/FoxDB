
--▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓©2023 00fox▓▓
----------------------------------------------------------------------------------------------------
--										FOXDBTEST
----------------------------------------------------------------------------------------------------
--▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓


if select(4, GetBuildInfo()) < 100000 then return end

local min, max, floor, ceil, rand, sqrt, log	= math.min, math.max, math.floor, math.ceil, math.random, math.sqrt, math.log
local huge, pi, cos, sin, deg, rad, atan2		= math.huge, math.pi, math.cos, math.sin, math.deg, math.rad, math.atan2
local len, match, find, sub, split, format		= string.len, string.match, string.find, string.sub, string.split, string.format
local lower, upper, capital						= string.lower, string.upper, function(str) return (str:gsub("^%l", string.upper)) end
local insert, remove, concat, sort				= table.insert, table.remove, table.concat, table.sort
local After, NewTicker, NewTimer				= C_Timer.After, C_Timer.NewTicker, C_Timer.NewTimer

local IsAddOnLoaded								= C_AddOns.IsAddOnLoaded
local OpenToCategory							= Settings.OpenToCategory

local _, FoxDBTest								= ...
_G.FoxDBTest									= FoxDBTest
local L											= FoxDBTest.L


--▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
--										VARIABLES
--▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓


FoxDBTest.EditModeOn				= false
FoxDBTest.Snapping					= true
FoxDBTest.Gridding					= true
FoxDBTest.Launched					= false

local Global
local Layout
local Profil
local Keys
local Datas
local InCombat

FoxDBTest.Dialog					= CreateFrame("Frame", nil, UIParent, "ResizeLayoutFrame")

FoxDBTest.Settings					= CreateFrame("Frame", "FoxDBTest_Settings")
FoxDBTest.Settings:Hide()

local Settings						= FoxDBTest.Settings
FoxDBTest.Settings1					= setmetatable(CreateFrame("Frame", "FoxDBTest_Settings1"), {__index = Settings})
FoxDBTest.Settings2					= setmetatable(CreateFrame("Frame", "FoxDBTest_Settings2"), {__index = Settings})
FoxDBTest.Settings9					= setmetatable(CreateFrame("Frame", "FoxDBTest_Settings9"), {__index = Settings})

StaticPopupDialogs["FoxDBTest_CONFIRM"] = {
	text					= "",
	button1					= L[4.0],
	button2					= L[4.1],
	OnAccept				= function() end,
	timeout					= 0,
	whileDead				= true,
	hideOnEscape			= true,
	enterClicksFirstButton	= true,
	preferredIndex			= 3
}
local ConfirmDialog					= StaticPopupDialogs["FoxDBTest_CONFIRM"]


--▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
--										ADDON COMPARTMENT
--▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓


local GeneratorFunction = function(ownerRegion, rootDescription)
	rootDescription:CreateTitle("FoxDBTest "..L[1.1])
	rootDescription:CreateSpacer()
	rootDescription:CreateButton(L[1.2], function() FoxDBTest:ResetFrames()		end)
	rootDescription:CreateButton(L[1.3], function() FoxDBTest:onIconLeftClick()	end)
	rootDescription:CreateButton(L[1.4], function()
			ConfirmDialog.text = L[4.2]
			ConfirmDialog.OnAccept = function() securecall(ReloadUI) end
			StaticPopup_Show("FoxDBTest_CONFIRM")
		end)
end
function FoxDBTest_OnAddonCompartmentClick(addonName, button)
--	if		button == "LeftButton"		then
--	elseif	button == "MiddleButton"	then
--	elseif	button == "RightButton"		then
		MenuUtil.CreateContextMenu(UIParent, GeneratorFunction)
--	end
end

function FoxDBTest_OnAddonCompartmentEnter(addonName, addonTable)
	if GameTooltip then
		GameTooltip:ClearLines()
		GameTooltip:SetOwner(addonTable, "ANCHOR_LEFT")
		GameTooltip:SetText("FoxDBTest")
		GameTooltip:AddLine(L[1.0], 1, 1, 1)
		GameTooltip:Show()
	end
end

function FoxDBTest_OnAddonCompartmentLeave(addonName, addonTable)
	if GameTooltip then GameTooltip:Hide() end
end


--▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
--										EVENTS
--▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓


--▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
----------------------------------------------------------------------------------------------------
local function OnEvent(frame, event, arg1, arg2, ...)
----------------------------------------------------------------------------------------------------
	if		event == "ADDON_LOADED"																then
			if arg1 == "FoxDBTest" then FoxDBTest:onInitialize() end
----------------------------------------------------------------------------------------------------
	elseif	event == "PLAYER_REGEN_DISABLED"													then
			FoxDBTest:onEditModeExit()
			InCombat = true
----------------------------------------------------------------------------------------------------
	elseif	event == "PLAYER_REGEN_ENABLED"														then
			InCombat = false
----------------------------------------------------------------------------------------------------
	elseif	event == "ADDON_ACTION_BLOCKED"
		or	event == "ADDON_ACTION_FORBIDDEN"
		or	event == "LUA_WARNING"																then
			local messagesystemtext = FoxDBTest.messagesystemtext
			if messagesystemtext then
				messagesystemtext:SetText(arg1..": "..arg2)
			end
----------------------------------------------------------------------------------------------------
	end
end
local EventHandler = CreateFrame("Frame", nil)
EventHandler:SetScript("OnEvent", OnEvent)
EventHandler:RegisterEvent("ADDON_LOADED")
EventHandler:RegisterEvent("PLAYER_REGEN_DISABLED")
EventHandler:RegisterEvent("PLAYER_REGEN_ENABLED")
EventHandler:RegisterEvent("ADDON_ACTION_BLOCKED")
EventHandler:RegisterEvent("ADDON_ACTION_FORBIDDEN")
EventHandler:RegisterEvent("LUA_WARNING")


--▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
--										MOTOR
--▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓


--▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
----------------------------------------------------------------------------------------------------
function FoxDBTest:Launch(reverse)
----------------------------------------------------------------------------------------------------
	if reverse then Global.TestActivated = not Global.TestActivated end

	if Global.TestActivated then
		if not self.Launched then
			self.Launched = true
			self:CreateFrames()
			self:DialogInit()
		end
		self:SetFrames()
	elseif self.Launched then
		self.GlobalFrame:Hide()
		self.LayoutFrame:Hide()
		self.ProfilFrame:Hide()
	end
end


--▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
--										GLOBAL
--▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓


--▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
----------------------------------------------------------------------------------------------------
function FoxDBTest:onInitialize(reset)
----------------------------------------------------------------------------------------------------
print("|cFFFFFF00onInitialize|r", reset)
	if not reset then
		self.db		= self:New("FoxDBTestDB", true)
		Datas		= self.db
		Global		= Datas.global
		Profil		= Datas.profile
		Keys		= Datas.keys
		InCombat	= InCombatLockdown()

		local icon	= Datas.icon
		icon.label	= "FoxDB"
		icon.file	= "Interface\\Icons\\spell_shadow_brainwash"
		icon.line1	= L[1.3]
		icon.line3	= L[1.4]
		Datas:IconStart()
	end

	if type(Global.TestActivated)	~= "boolean"	then Global.TestActivated	= true	end
	if type(Global.useGlobalFrame)	~= "boolean"	then Global.useGlobalFrame	= true	end
	if type(Global.useLayoutFrame)	~= "boolean"	then Global.useLayoutFrame	= true	end
	if type(Global.useProfilFrame)	~= "boolean"	then Global.useProfilFrame	= true	end
	if type(Global.Colored)			~= "boolean"	then Global.Colored			= true	end
	if type(Global.FramesScale)		~= "number"		then Global.FramesScale		= 1		end

	if type(Global.Framex) ~= "number" then Global.Framex = (select(1, UIParent:GetCenter())-150)*UIParent:GetScale()	end
	if type(Global.Framey) ~= "number" then Global.Framey = select(2, UIParent:GetCenter())*UIParent:GetScale()			end

	Global.FramesScale = min(max(Global.FramesScale, 0.5), 1.5)
end


--▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
--										PROFILE
--▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓


--▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
----------------------------------------------------------------------------------------------------
function FoxDBTest:onProfileChanged()
----------------------------------------------------------------------------------------------------
print("|cFFFFFF00onProfileChanged|r:", Keys.char)
	Profil.Name		= Keys.name
	Profil.Race		= Keys.race
	Profil.Class	= Keys.class
	Profil.Faction	= Keys.faction
	Profil.Realm	= Keys.realm

	if type(Profil.Framex) ~= "number" then Profil.Framex = (select(1, UIParent:GetCenter())+150)*UIParent:GetScale()	end
	if type(Profil.Framey) ~= "number" then Profil.Framey = select(2, UIParent:GetCenter())*UIParent:GetScale()			end
	if type(Profil.Colored) ~= "boolean" then Profil.Colored = true end

	if Global.TestActivated and self.Launched then self:SetLocation(self.ProfilFrame) end
end


--▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
--										LAYOUT
--▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓


--▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
----------------------------------------------------------------------------------------------------
function FoxDBTest:onLayoutLoaded()
----------------------------------------------------------------------------------------------------
print("|cFFFFFF00onLayoutLoaded|r")
	Layout = Datas.layout

	if Global.TestActivated then
		self.Launched = true
		self:CreateFrames()
		self:DialogInit()
	end
	Settings:Initialize(true)
	self:onLayoutChanged()

	print("\n")
	print("|cFFFFFF00Name|r:",		Keys.name)
	print("|cFFFFFF00Race|r:",		Keys.race)
	print("|cFFFFFF00Class|r:",		Keys.class)
	print("|cFFFFFF00Faction|r:",	Keys.faction)
	print("|cFFFFFF00Realm|r:",		Keys.realm)
	print("|cFFFFFF00FRealm|r:",	Keys.frealm)
	print("\n")
end
--▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
----------------------------------------------------------------------------------------------------
local firstlayout = false
function FoxDBTest:onLayoutChanged()
----------------------------------------------------------------------------------------------------
print("|cFFFFFF00onLayoutChanged|r:", Keys.layout)
	Layout = Datas.layout
	InCombat = InCombatLockdown()

	if type(Layout.Framex) ~= "number" then Layout.Framex = select(1, UIParent:GetCenter())*UIParent:GetScale() end
	if type(Layout.Framey) ~= "number" then Layout.Framey = select(2, UIParent:GetCenter())*UIParent:GetScale() end
	if type(Layout.Colored) ~= "boolean" then Layout.Colored = true end

	if Global.TestActivated and self.Launched then self:SetFrames() end
end


--▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
--										FRAMES
--▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓


--▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
----------------------------------------------------------------------------------------------------
function FoxDBTest:CreateFrames()
----------------------------------------------------------------------------------------------------
	self.GlobalFrame	= self.GlobalFrame		or CreateFrame("Frame", "FoxDBTest_Global", UIParent, "BackdropTemplate")
	self.LayoutFrame	= self.LayoutFrame		or CreateFrame("Frame", "FoxDBTest_Layout", UIParent, "BackdropTemplate")
	self.ProfilFrame	= self.ProfilFrame		or CreateFrame("Frame", "FoxDBTest_Profil", UIParent, "BackdropTemplate")

	local GlobalFrame	= self.GlobalFrame
	local LayoutFrame	= self.LayoutFrame
	local ProfilFrame	= self.ProfilFrame

	GlobalFrame:SetClampedToScreen(true)
	LayoutFrame:SetClampedToScreen(true)
	ProfilFrame:SetClampedToScreen(true)

	GlobalFrame:SetDontSavePosition(true)
	LayoutFrame:SetDontSavePosition(true)
	ProfilFrame:SetDontSavePosition(true)

	GlobalFrame:SetSize(100, 100)
	LayoutFrame:SetSize(100, 100)
	ProfilFrame:SetSize(100, 100)

	GlobalFrame:SetFrameStrata("MEDIUM")
	LayoutFrame:SetFrameStrata("MEDIUM")
	ProfilFrame:SetFrameStrata("MEDIUM")

	GlobalFrame:SetFrameLevel(1)
	LayoutFrame:SetFrameLevel(1)
	ProfilFrame:SetFrameLevel(1)

	GlobalFrame:SetAlpha(0.75)
	LayoutFrame:SetAlpha(0.75)
	ProfilFrame:SetAlpha(0.75)

	GlobalFrame.texture = GlobalFrame.texture or GlobalFrame:CreateTexture()
	LayoutFrame.texture = LayoutFrame.texture or LayoutFrame:CreateTexture()
	ProfilFrame.texture = ProfilFrame.texture or ProfilFrame:CreateTexture()

	GlobalFrame.texture:SetAllPoints(GlobalFrame)
	LayoutFrame.texture:SetAllPoints(LayoutFrame)
	ProfilFrame.texture:SetAllPoints(ProfilFrame)

	GlobalFrame:SetScript("OnEnter", function(btn)
			GlobalFrame:SetAlpha(1)
			if GameTooltip and not FoxDBTest.EditModeOn then
				GameTooltip:ClearLines()
				GameTooltip:SetOwner(GlobalFrame, "ANCHOR_RIGHT", 10, -9.5)
				GameTooltip:AddLine(L[2.3], 1, 1, 0)
				GameTooltip:AddLine(L[2.4], 1, 1, 1)
				GameTooltip:AddLine(L[2.9], 0.2, 1, 0.9)
				GameTooltip:Show()
			end
		end)
	LayoutFrame:SetScript("OnEnter", function(btn)
			LayoutFrame:SetAlpha(1)
			if GameTooltip and not FoxDBTest.EditModeOn then
				GameTooltip:ClearLines()
				GameTooltip:SetOwner(LayoutFrame, "ANCHOR_RIGHT", 10, -9.5)
				GameTooltip:AddLine(L[2.5], 1, 1, 0)
				GameTooltip:AddLine(L[2.6], 1, 1, 1)
				GameTooltip:AddLine(L[2.9], 0.2, 1, 0.9)
				GameTooltip:Show()
			end
		end)
	ProfilFrame:SetScript("OnEnter", function(btn)
			ProfilFrame:SetAlpha(1)
			if GameTooltip and not FoxDBTest.EditModeOn then
				GameTooltip:ClearLines()
				GameTooltip:SetOwner(ProfilFrame, "ANCHOR_RIGHT", 10, -9.5)
				GameTooltip:AddLine(L[2.7], 1, 1, 0)
				GameTooltip:AddLine(L[2.8], 1, 1, 1)
				GameTooltip:AddLine(L[2.9], 0.2, 1, 0.9)
				GameTooltip:Show()
			end
		end)

	GlobalFrame:SetScript("OnLeave", function(btn)
			if GameTooltip then GameTooltip:Hide() end
			GlobalFrame:SetAlpha(0.75)
		end)
	LayoutFrame:SetScript("OnLeave", function(btn)
			if GameTooltip then GameTooltip:Hide() end
			LayoutFrame:SetAlpha(0.75)
		end)
	ProfilFrame:SetScript("OnLeave", function(btn)
			if GameTooltip then GameTooltip:Hide() end
			ProfilFrame:SetAlpha(0.75)
		end)

	local Dialog = FoxDBTest.Dialog
	GlobalFrame.OnDragStart = function()
			if Dialog then Dialog:Hide() end
--			GlobalFrame:ClearAllPoints()
			GlobalFrame:SetAlpha(0)
			GlobalFrame:SetMovable(true)
			GlobalFrame:StartMoving()
		end
	LayoutFrame.OnDragStart = function()
			if Dialog then Dialog:Hide() end
--			LayoutFrame:ClearAllPoints()
			LayoutFrame:SetAlpha(0)
			LayoutFrame:SetMovable(true)
			LayoutFrame:StartMoving()
		end
	ProfilFrame.OnDragStart = function()
			if Dialog then Dialog:Hide() end
--			ProfilFrame:ClearAllPoints()
			ProfilFrame:SetAlpha(0)
			ProfilFrame:SetMovable(true)
			ProfilFrame:StartMoving()
		end

	GlobalFrame.OnDragStop = function()
			GlobalFrame:SetMovable(false)
			GlobalFrame:SetAlpha(1)
			GlobalFrame:StopMovingOrSizing()
--			GlobalFrame:ClearAllPoints()
			local scale = Global.FramesScale*UIParent:GetScale()
			local x, y = GlobalFrame:GetCenter()
			if x and y and scale then
				Global.Framex = x*scale
				Global.Framey = y*scale
			end
		end
	LayoutFrame.OnDragStop = function()
			LayoutFrame:SetMovable(false)
			LayoutFrame:SetAlpha(1)
			LayoutFrame:StopMovingOrSizing()
--			LayoutFrame:ClearAllPoints()
			local scale = Global.FramesScale*UIParent:GetScale()
			local x, y = LayoutFrame:GetCenter()
			if x and y and scale then
				Layout.Framex = x*scale
				Layout.Framey = y*scale
			end
		end
	ProfilFrame.OnDragStop = function()
			ProfilFrame:SetMovable(false)
			ProfilFrame:SetAlpha(1)
			ProfilFrame:StopMovingOrSizing()
--			ProfilFrame:ClearAllPoints()
			local scale = Global.FramesScale*UIParent:GetScale()
			local x, y = ProfilFrame:GetCenter()
			if x and y and scale then
				Profil.Framex = x*scale
				Profil.Framey = y*scale
			end
		end

	self.GlobalOverlay = Datas:CreateSystemFrame(self.GlobalFrame, L[2.0], "FoxDBTest")
	self.LayoutOverlay = Datas:CreateSystemFrame(self.LayoutFrame, L[2.1], "FoxDBTest")
	self.ProfilOverlay = Datas:CreateSystemFrame(self.ProfilFrame, L[2.2], "FoxDBTest")

	local GlobalOverlay	= self.GlobalOverlay
	local LayoutOverlay	= self.LayoutOverlay
	local ProfilOverlay	= self.ProfilOverlay

	GlobalOverlay:SetSize(100, 100)
	LayoutOverlay:SetSize(100, 100)
	ProfilOverlay:SetSize(100, 100)

	Datas:RegisterSystemFrame(GlobalOverlay)
	Datas:RegisterSystemFrame(LayoutOverlay)
	Datas:RegisterSystemFrame(ProfilOverlay)
end
--▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
----------------------------------------------------------------------------------------------------
function FoxDBTest:ResetFrames()
----------------------------------------------------------------------------------------------------
	Global.useGlobalFrame	= true
	Global.useLayoutFrame	= true
	Global.useProfilFrame	= true
	Global.Colored			= true
	Layout.Colored			= true
	Profil.Colored			= true
	Global.FramesScale		= 1

	local x = select(1, UIParent:GetCenter())
	local y = select(2, UIParent:GetCenter())*UIParent:GetScale()
	Global.Framex	= (x-150)*UIParent:GetScale()
	Global.Framey	= y
	Layout.Framex	= x*UIParent:GetScale()
	Layout.Framey	= y
	Profil.Framex	= (x+150)*UIParent:GetScale()
	Profil.Framey	= y

	if self.Launched then
		self:SetFrames()
	end
end
--▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
----------------------------------------------------------------------------------------------------
function FoxDBTest:SetFrames()
----------------------------------------------------------------------------------------------------
	local GlobalFrame	= self.GlobalFrame
	local LayoutFrame	= self.LayoutFrame
	local ProfilFrame	= self.ProfilFrame

	GlobalFrame:SetScale(Global.FramesScale)
	LayoutFrame:SetScale(Global.FramesScale)
	ProfilFrame:SetScale(Global.FramesScale)

	self:SetLocation(GlobalFrame)
	self:SetLocation(LayoutFrame)
	self:SetLocation(ProfilFrame)

	FoxDBTest:SetVisible(GlobalFrame)
	FoxDBTest:SetVisible(LayoutFrame)
	FoxDBTest:SetVisible(ProfilFrame)

	FoxDBTest:SetColor(GlobalFrame)
	FoxDBTest:SetColor(LayoutFrame)
	FoxDBTest:SetColor(ProfilFrame)
end
--▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
----------------------------------------------------------------------------------------------------
function FoxDBTest:SetLocation(frame)
----------------------------------------------------------------------------------------------------
	if not frame then return end

	local GlobalFrame	= self.GlobalFrame
	local LayoutFrame	= self.LayoutFrame
	local ProfilFrame	= self.ProfilFrame

	local x, y
	if frame == GlobalFrame then
		x = Global.Framex
		y = Global.Framey
	elseif frame == LayoutFrame then
		x = Layout.Framex
		y = Layout.Framey
	elseif frame == ProfilFrame then
		x = Profil.Framex
		y = Profil.Framey
	else
		return
	end
	x = x/(UIParent:GetScale()*Global.FramesScale)
	y = y/(UIParent:GetScale()*Global.FramesScale)

	frame:ClearAllPoints()
	frame:SetPoint("CENTER", UIParent, "BOTTOMLEFT", x, y)
end
--▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
----------------------------------------------------------------------------------------------------
function FoxDBTest:SetVisible(frame)
----------------------------------------------------------------------------------------------------
	if not frame then return end

	local GlobalFrame	= self.GlobalFrame
	local LayoutFrame	= self.LayoutFrame
	local ProfilFrame	= self.ProfilFrame

	if frame == GlobalFrame then
		self.GlobalFrame:SetShown(Global.useGlobalFrame)
	elseif frame == LayoutFrame then
		self.LayoutFrame:SetShown(Global.useLayoutFrame)
	elseif frame == ProfilFrame then
		self.ProfilFrame:SetShown(Global.useProfilFrame)
	end
end
--▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
----------------------------------------------------------------------------------------------------
function FoxDBTest:SetColor(frame)
----------------------------------------------------------------------------------------------------
	if not frame then return end

	local GlobalFrame	= self.GlobalFrame
	local LayoutFrame	= self.LayoutFrame
	local ProfilFrame	= self.ProfilFrame

	if frame == GlobalFrame then
		if Global.Colored then
			GlobalFrame.texture:SetColorTexture(0.25,0.25,1,0.8)
		else
			GlobalFrame.texture:SetColorTexture(0.15,0.15,0.15,1)
		end
	elseif frame == LayoutFrame then
		if Layout.Colored then
			LayoutFrame.texture:SetColorTexture(1,0,0,0.65)
		else
			LayoutFrame.texture:SetColorTexture(0.15,0.15,0.15,1)
		end
	elseif frame == ProfilFrame then
		if Profil.Colored then
			ProfilFrame.texture:SetColorTexture(0.08,1,0.08,1)
		else
			ProfilFrame.texture:SetColorTexture(0.15,0.15,0.15,1)
		end
	end
end


--▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
--										ICON
--▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓


--▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
----------------------------------------------------------------------------------------------------
function FoxDBTest:onIconLeftClick()
----------------------------------------------------------------------------------------------------
	if Settings.Category then OpenToCategory(Settings.Category)	end
end
--▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
----------------------------------------------------------------------------------------------------
function FoxDBTest:onIconRightClick()
----------------------------------------------------------------------------------------------------
	ReloadUI()
end
--▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
----------------------------------------------------------------------------------------------------
--function FoxDBTest:onIconMiddleClick()
----------------------------------------------------------------------------------------------------
--end
--▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
----------------------------------------------------------------------------------------------------
--function FoxDBTest:onIconVisibility(visible)
----------------------------------------------------------------------------------------------------
--end


--▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
--										EDITMODE
--▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓


local CurrentFrame = 1
--▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
----------------------------------------------------------------------------------------------------
function FoxDBTest:onEditModeEnter(grid, snap)
----------------------------------------------------------------------------------------------------
	FoxDBTest.Gridding = grid
	FoxDBTest.Snapping = snap
	FoxDBTest.EditModeOn = true
end
--▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
----------------------------------------------------------------------------------------------------
EditModeSystemSettingsDialog.CloseButton:HookScript("OnClick", function()
		if InCombat then return end
		if not FoxDBTest.Launched then return end

		local Dialog = FoxDBTest.Dialog
		if Dialog then Dialog:Hide() end
	end)
function FoxDBTest:onEditModeExit()
----------------------------------------------------------------------------------------------------
	FoxDBTest.EditModeOn = false
	if InCombat then return end
	if not self.Launched then return end

	local Dialog = self.Dialog
	if Dialog then Dialog:Hide() end
end
--▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
----------------------------------------------------------------------------------------------------
function FoxDBTest:onEditModeFrame(frame, icon)
----------------------------------------------------------------------------------------------------
	if not frame then return end
	if InCombat then return end
	if not self.Launched then return end

	local GlobalOverlay	= self.GlobalOverlay
	local LayoutOverlay	= self.LayoutOverlay
	local ProfilOverlay	= self.ProfilOverlay

	local checked
	local text
	if		frame == GlobalOverlay then CurrentFrame = 1
	elseif	frame == LayoutOverlay then CurrentFrame = 2
	elseif	frame == ProfilOverlay then CurrentFrame = 3
	else
		local Dialog = self.Dialog
		if Dialog then Dialog:Hide() end
		return
	end

	self:SetDialog()
end
--▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
----------------------------------------------------------------------------------------------------
function FoxDBTest:onEditModeGrid(grid)
----------------------------------------------------------------------------------------------------
	FoxDBTest.Gridding = grid
end
--▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
----------------------------------------------------------------------------------------------------
function FoxDBTest:onEditModeSnap(snap)
----------------------------------------------------------------------------------------------------
	FoxDBTest.Snapping = snap
end
--▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
----------------------------------------------------------------------------------------------------
function FoxDBTest:DialogInit()
----------------------------------------------------------------------------------------------------
	if not self.Launched then return end
	local Dialog = self.Dialog

	Dialog:SetSize(368, 173)
	Dialog:SetFrameStrata("DIALOG")
	Dialog:SetFrameLevel(200)
	Dialog.heightPadding = 39
	Dialog:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
	Dialog:EnableMouse(true)
	Dialog:SetMovable(true)
	Dialog:SetClampedToScreen(true)
	Dialog:SetDontSavePosition(true)
	Dialog:RegisterForDrag("LeftButton", "RightButton")
	Dialog:SetScript("OnDragStart", function() Dialog:StartMoving() end)
	Dialog:SetScript("OnDragStop", function() Dialog:StopMovingOrSizing() end)
	Dialog:Hide()

	Dialog.Border = Dialog.Border or CreateFrame("Frame", nil, Dialog, "DialogBorderTranslucentTemplate")
	Dialog.Border.ignoreInLayout = true
	Dialog.Border:Show()

	Dialog.Close = Dialog.Close or CreateFrame("Button", nil, Dialog, "UIPanelCloseButton")
	Dialog.Close:SetPoint("TOPRIGHT")
	Dialog.Close.ignoreInLayout = true
	Dialog.Close:Show()

	Dialog.Title = Dialog.Title or Dialog:CreateFontString(nil, nil, 'GameFontHighlightLarge')
	Dialog.Title:SetPoint('TOP', 0, -15)
	Dialog.Title:Show()

	Dialog.Colored = Dialog.Colored or CreateFrame("Frame", nil, Dialog, "EditModeSettingCheckboxTemplate")
	Dialog.Colored.Label:SetWidth(145)
	Dialog.Colored.Label:SetText(L[3.3])
	Dialog.Colored:SetPoint("TOPLEFT", Dialog, "TOPLEFT", 20, -43)
	Dialog.Colored.Button:SetScript("OnClick", function(self, event, ...)
			local valueon = self:GetChecked()
			if		CurrentFrame == 1 then Global.Colored = valueon FoxDBTest:SetColor(FoxDBTest.GlobalFrame)
			elseif	CurrentFrame == 2 then Layout.Colored = valueon FoxDBTest:SetColor(FoxDBTest.LayoutFrame)
			elseif	CurrentFrame == 3 then Profil.Colored = valueon FoxDBTest:SetColor(FoxDBTest.ProfilFrame)
			end
			Dialog.Colored2.Slider:SetValue(valueon and 100 or 0)
			Dialog.Colored3:SetText(valueon and L[3.4] or L[3.3])
		end)
	Dialog.Colored:Show()

	Dialog.Colored2 = Dialog.Colored2 or CreateFrame("Frame", nil, Dialog, "EditModeSettingSliderTemplate")
	Dialog.Colored2.Slider:SetWidth(190)
	Dialog.Colored2.Slider.MinText:Hide()
	Dialog.Colored2.Slider.MaxText:Hide()
	Dialog.Colored2.Label:SetText(L[3.3])
	Dialog.Colored2:SetPoint("TOPLEFT", Dialog.Colored, "BOTTOMLEFT", 0, 1)
	Dialog.Colored2.formatters = {}
	Dialog.Colored2.formatters[MinimalSliderWithSteppersMixin.Label.Right] = CreateMinimalSliderFormatter(
			MinimalSliderWithSteppersMixin.Label.Right,
			function(value)
				if value ~= -1 then
					local valueon = value > 50
					if		CurrentFrame == 1 then Global.Colored = valueon FoxDBTest:SetColor(FoxDBTest.GlobalFrame)
					elseif	CurrentFrame == 2 then Layout.Colored = valueon FoxDBTest:SetColor(FoxDBTest.LayoutFrame)
					elseif	CurrentFrame == 3 then Profil.Colored = valueon FoxDBTest:SetColor(FoxDBTest.ProfilFrame)
					end
					Dialog.Colored.Button:SetChecked(valueon)
					Dialog.Colored3:SetText(valueon and L[3.4] or L[3.3])
					return value end
			end)
	Dialog.Colored2.Slider:Init(-1, 0, 100, 50, Dialog.Colored2.formatters)
	Dialog.Colored2:Show()

	Dialog.Divider = Dialog.Divider or CreateFrame("Frame", nil, Dialog)
	Dialog.Divider:SetSize(330,16)
	Dialog.Divider:SetPoint("TOPLEFT", Dialog.Colored2, "BOTTOMLEFT", 0, 3)
	Dialog.Divider.divider = Dialog.Divider:CreateTexture(nil, "ARTWORK")
	Dialog.Divider.divider:SetTexture(389194)	--"Interface\\FriendsFrame\\UI-FriendsFrame-OnlineDivider"
	Dialog.Divider.divider:SetSize(330,16)
	Dialog.Divider.divider:SetPoint("TOPLEFT")
	Dialog.Divider:Show()

	Dialog.Colored3 = Dialog.Colored3 or CreateFrame("Button", nil, Dialog, "EditModeSystemSettingsDialogButtonTemplate")
	Dialog.Colored3:SetWidth(330)
	Dialog.Colored3:SetPoint("TOPLEFT", Dialog.Divider, "BOTTOMLEFT", -1, -2)
	Dialog.Colored3:SetText("")
	Dialog.Colored3:SetOnClickHandler(function()
			local valueon
			if		CurrentFrame == 1 then Global.Colored = not Global.Colored FoxDBTest:SetColor(FoxDBTest.GlobalFrame) valueon = Global.Colored
			elseif	CurrentFrame == 2 then Layout.Colored = not Layout.Colored FoxDBTest:SetColor(FoxDBTest.LayoutFrame) valueon = Layout.Colored
			elseif	CurrentFrame == 3 then Profil.Colored = not Profil.Colored FoxDBTest:SetColor(FoxDBTest.ProfilFrame) valueon = Profil.Colored
			end
			Dialog.Colored.Button:SetChecked(valueon)
			Dialog.Colored2.Slider:SetValue(valueon and 100 or 0)
		end)
	Dialog.Colored3:Show()
end
--▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
----------------------------------------------------------------------------------------------------
function FoxDBTest:SetDialog()
----------------------------------------------------------------------------------------------------
	if not self.Launched then return end
	local Dialog = self.Dialog

	local text
	local checked
	if		CurrentFrame == 1 then text = L[3.0] checked = Global.Colored
	elseif	CurrentFrame == 2 then text = L[3.1] checked = Layout.Colored
	elseif	CurrentFrame == 3 then text = L[3.2] checked = Profil.Colored
	else	if Dialog then Dialog:Hide() end return
	end

	if Dialog.Title		then Dialog.Title:SetText(text)								end
	if Dialog.Colored	then Dialog.Colored.Button:SetChecked(checked)				end
	if Dialog.Colored2	then Dialog.Colored2.Slider:SetValue(checked and 100 or 0)	end
	if Dialog.Colored3	then Dialog.Colored3:SetText(checked and L[3.4] or L[3.3])	end

	Dialog:Show()
	Dialog:SetSize(368, 173)
end
