
--▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓©2023 00fox▓▓
----------------------------------------------------------------------------------------------------
--										SETTINGS
----------------------------------------------------------------------------------------------------
--▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓


local min, max, floor, ceil, rand, sqrt, log	= math.min, math.max, math.floor, math.ceil, math.random, math.sqrt, math.log
local huge, pi, cos, sin, deg, rad, atan2		= math.huge, math.pi, math.cos, math.sin, math.deg, math.rad, math.atan2
local len, match, find, sub, split, format		= string.len, string.match, string.find, string.sub, string.split, string.format
local lower, upper, capital						= string.lower, string.upper, function(str) return (str:gsub("^%l", string.upper)) end
local insert, remove, concat, sort				= table.insert, table.remove, table.concat, table.sort
local After, NewTicker, NewTimer				= C_Timer.After, C_Timer.NewTicker, C_Timer.NewTimer

local RegisterCanvasLayoutCategory				= Settings.RegisterCanvasLayoutCategory
local RegisterCanvasLayoutSubcategory			= Settings.RegisterCanvasLayoutSubcategory
local RegisterAddOnCategory						= Settings.RegisterAddOnCategory

local _, FoxDBTest								= ...
local L											= FoxDBTest.L


--▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
--										VARIABLES
--▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓


local Global
local Layout
local Profil
local Keys
local Datas
local InCombat

local Settings						= FoxDBTest.Settings
local Settings1						= FoxDBTest.Settings1
local Settings2						= FoxDBTest.Settings2
local Settings9						= FoxDBTest.Settings9
local ConfirmDialog					= StaticPopupDialogs["FoxDBTest_CONFIRM"]

local StaticPopupDialogsText		= ""
StaticPopupDialogs["FoxDBTest_WEB_ADDRESS"] = {
	text = "",
	hasEditBox = true,
	button1 = "Ok",
	timeout = 0,
	whileDead = true,
	hideOnEscape = true,
	enterClicksFirstButton = true,
	preferredIndex = 3,
	OnShow = function (self, data)
			self.editBox:SetText(StaticPopupDialogsText)
			self.editBox:SetJustifyH("CENTER")
			self.editBox:SetWidth(240)
			self.editBox:HighlightText()
		end
}


--▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
--										EVENTS
--▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓


--▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
----------------------------------------------------------------------------------------------------
function Settings:RegisterEvents(unregister)
----------------------------------------------------------------------------------------------------
	if unregister then
		Settings:UnregisterAllEvents()
	else
		Settings:RegisterEvent("PLAYER_REGEN_DISABLED")
		Settings:RegisterEvent("PLAYER_REGEN_ENABLED")
	end
end
--▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
----------------------------------------------------------------------------------------------------
local function OnEvent(frame, event, arg1, ...)
----------------------------------------------------------------------------------------------------
	if	event == "PLAYER_REGEN_DISABLED"														then
			InCombat = true
----------------------------------------------------------------------------------------------------
	elseif	event == "PLAYER_REGEN_ENABLED"														then
			InCombat = false
----------------------------------------------------------------------------------------------------
	end
end


--▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
--										MOTOR
--▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓


--▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
----------------------------------------------------------------------------------------------------
function Settings:Initialize(state)
----------------------------------------------------------------------------------------------------
	Global		= FoxDBTest.db.global
	Layout		= FoxDBTest.db.layout
	Profile		= FoxDBTest.db.profile
	Keys		= FoxDBTest.db.keys
	Datas		= FoxDBTest.db
	InCombat	= InCombatLockdown()

	self:Module(state)
end
--▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
----------------------------------------------------------------------------------------------------
local category, layout
local first = true
function Settings:Module(state)
----------------------------------------------------------------------------------------------------
	if type(state) ~= "boolean" then return end

	if state then
		if first then
			first = false

			category, layout = RegisterCanvasLayoutCategory(self, L[9.000])
			if category then
				self.Category = category:GetID()
				RegisterAddOnCategory(category)

				local category1 = RegisterCanvasLayoutSubcategory(category, Settings1, L[9.100])
				local category2 = RegisterCanvasLayoutSubcategory(category, Settings2, L[9.200])
				local category9 = RegisterCanvasLayoutSubcategory(category, Settings9, L[9.900])
			end

			self:InitBase()
			Settings1:Init1()
			Settings2:Init2()
			Settings9:Init9()

			self:reset()
			Settings1:reset()
			Settings2:reset()
			Settings9:reset()

			self:AddPages()
		end

		self:SetScript("OnEvent", OnEvent)
		self:RegisterEvents()
	else
		self:RegisterEvents(true)
		self:SetScript("OnEvent", nil)
		self:Hide()
	end
end
--▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
----------------------------------------------------------------------------------------------------
function Settings:CreateLabel(dest, title, bigfont, width)
----------------------------------------------------------------------------------------------------
	width = width or self.panel:GetWidth()-23

	local center = dest:CreateFontString(nil, "BACKGROUND", bigfont and "GameFontNormalLarge" or"GameFontNormal")
	center:SetText(bigfont and title:upper() or title)
	center:SetJustifyH("CENTER")

	local labelwidth = (width-center:GetWidth())/2-10

	local left = dest:CreateTexture(nil, "BACKGROUND")
	left:SetSize(labelwidth, 8)
	left:SetTexture(137057)	-- Interface\\Tooltips\\UI-Tooltip-Border
	left:SetTexCoord(0.81, 0.94, 0.5, 1)

	local right = dest:CreateTexture(nil, "BACKGROUND")
	right:SetSize(labelwidth, 8)
	right:SetTexture(137057)
	right:SetTexCoord(0.81, 0.94, 0.5, 1)

	center:SetPoint("LEFT", left, "RIGHT", 5, 0)
	right:SetPoint("LEFT", center, "RIGHT", 5, 0)

	return left
end
--▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
----------------------------------------------------------------------------------------------------
local Choices = {}
local RightPages = {}
local npanels = 0
local currentpage
function Settings:ShowPage(pagenumber)
----------------------------------------------------------------------------------------------------
	local right = RightPages[pagenumber]
	if right then
		currentpage = right

		self.panel.scrollbar:Hide()

		for i=1,#RightPages do
			if i == pagenumber and Choices[i].activated then
				RightPages[i]:Show()
			else
				RightPages[i]:Hide()
			end
		end

		local steps = floor(max((right:GetHeight() - self.panel:GetHeight()), 0)/50)
		self.panel.scrollbar:SetMinMaxValues(0, steps)
		self.panel.scrollbar:SetValue(0)

		if steps == 0 then
			self.panel.scrollbar:Hide()
		else
			self.panel.scrollbar:Show()
		end
	end
end
--▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
----------------------------------------------------------------------------------------------------
function Settings:AddPage(text, tooltip, activated, func, modified)
----------------------------------------------------------------------------------------------------
	npanels = npanels+1
	self.choice:SetHeight(18*npanels+10)

	Choices[npanels] = CreateFrame("Button", nil, self.choice, "FoxDBTest_EmptyButtonTemplate")
	local Choice = Choices[npanels]
	Choice:SetSize(112, 18)
	Choice:SetPoint("TOP", npanels == 1 and self.choice or Choices[npanels-1], npanels == 1 and "TOP" or "BOTTOM", 0, npanels == 1 and -5 or 0)
	Choice:RegisterForClicks("AnyUp")
	Choice.OnClick = function(btn) self:ShowPage(btn.Page) end
	if func then Choice.OnActivate = function(btn) self:ShowPage(btn.Page) return func(btn.activated) end end

	Choice:SetText(text or "choice "..npanels)
	Choice.tooltipText = tooltip
	Choice.Page = npanels
	Choice.activated = activated or not func
	Choice.modified = modified
	Choice:SetState()

	RightPages[npanels] = CreateFrame("Frame", nil, self.panel)
	local page = RightPages[npanels]
	local width = self.panel:GetWidth()-23
	page:SetSize(width, self.panel:GetHeight())
	page:SetPoint("TOPLEFT", self.panel, "TOPLEFT", 0, -12)
	page:Hide()

	page.title = Settings:CreateLabel(page, text, true)
	page.title:SetPoint("TOPLEFT", page, "TOPLEFT", 10, 0)

	Choices[1]:Click()

	return page, page.title, width-20
end
--▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
----------------------------------------------------------------------------------------------------
local envTable = GetCurrentEnvironment()
local function GetChild(frame, key)
----------------------------------------------------------------------------------------------------
	if (frame[key]) then
		return frame[key]
	else
		local name = frame:GetName()
		if name then
			return envTable[name..key]
		end
	end

	return nil
end


--▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
--										GLOBAL
--▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓


--▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
----------------------------------------------------------------------------------------------------
function Settings:ResetGlobal()
----------------------------------------------------------------------------------------------------
	ConfirmDialog.text		= L[4.3]
	ConfirmDialog.OnAccept	= function() Datas:ResetGlobal() Settings9:reset() end
	StaticPopup_Show("FoxDBTest_CONFIRM")
end


--▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
--										LAYOUT
--▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓


--▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
----------------------------------------------------------------------------------------------------
function Settings:ResetLayout()
----------------------------------------------------------------------------------------------------
	ConfirmDialog.text		= L[4.4]
	ConfirmDialog.OnAccept	= function() Datas:ResetLayout() Settings9:reset() end
	StaticPopup_Show("FoxDBTest_CONFIRM")
end
--▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
----------------------------------------------------------------------------------------------------
function Settings:DeleteLayout(layout)
----------------------------------------------------------------------------------------------------
	ConfirmDialog.text		= L[4.5]..layout
	ConfirmDialog.OnAccept	= function() Datas:DeleteLayout(layout) Settings9:reset() end
	StaticPopup_Show("FoxDBTest_CONFIRM")
end
--▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
----------------------------------------------------------------------------------------------------
function Settings:CopyLayout(layout)
----------------------------------------------------------------------------------------------------
	ConfirmDialog.text		= L[4.6]..layout
	ConfirmDialog.OnAccept	= function() Datas:CopyLayout(layout) Settings9:reset() end
	StaticPopup_Show("FoxDBTest_CONFIRM")
end

--▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
--										PROFILE
--▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓


--▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
----------------------------------------------------------------------------------------------------
function Settings:ResetProfile()
----------------------------------------------------------------------------------------------------
	ConfirmDialog.text		= L[4.7]
	ConfirmDialog.OnAccept	= function() Datas:ResetProfile() Settings9:reset() end
	StaticPopup_Show("FoxDBTest_CONFIRM")
end
--▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
----------------------------------------------------------------------------------------------------
function Settings:DeleteProfile(profile)
----------------------------------------------------------------------------------------------------
	ConfirmDialog.text		= L[4.8]..profile
	ConfirmDialog.OnAccept	= function() Datas:DeleteProfile(profile) Settings9:reset() end
	StaticPopup_Show("FoxDBTest_CONFIRM")
end
--▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
----------------------------------------------------------------------------------------------------
function Settings:CopyProfile(profile)
----------------------------------------------------------------------------------------------------
	ConfirmDialog.text		= L[4.9]..profile
	ConfirmDialog.OnAccept	= function() Datas:CopyProfile(profile) Settings9:reset() end
	StaticPopup_Show("FoxDBTest_CONFIRM")
end


--▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
--										FRAMES
--▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓


local backdrop = {
	bgFile		= "Interface/Tooltips/UI-Tooltip-Background",
	edgeFile	= "Interface/Tooltips/UI-Tooltip-Border",
	tile		= true,
	tileSize	= 16,
	edgeSize	= 16,
	insets		= {left=4, right=4, top=4, bottom=4}
}
--▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
----------------------------------------------------------------------------------------------------
function Settings:InitBase()
----------------------------------------------------------------------------------------------------
	self:SetFrameStrata("TOOLTIP")

	self.logo = self:CreateTexture(nil, "ARTWORK")
	self.logo:SetSize(36, 36)
	self.logo:SetPoint("TOPLEFT", 8, -8)
	self.logo:SetTexture("Interface\\Icons\\spell_shadow_brainwash")

	self.title = self:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
	self.title:SetScale(1.5)
	self.title:SetPoint("TOPLEFT", self.logo, "TOPRIGHT", 4, -4)
	self.title:SetText("FoxDB LIBRARY")
	self.title:SetTextColor(0.7, 0.7, 1, 1)
	self.title:SetJustifyH("LEFT")

	self.title2 = self:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
	self.title2:SetPoint("TOPLEFT", self.title, "BOTTOMLEFT", 1, 0)
	self.title2:SetText(L[9.001])

	self.Check1 = CreateFrame("CheckButton", "FoxDBTest_Settings_Check_0_1", self, "FoxDBTest_UICheckButtonTemplate")
	self.Check1:SetPoint("TOPLEFT", self.title2, "BOTTOMLEFT", -2, -17)
	self.Check1.OnClick = function(self, value)
			if InCombat then self:SetChecked(Global.TestActivated) return end
			Global.TestActivated = value
			FoxDBTest:Launch()
		end
	self.Check1.label = _G[self.Check1:GetName().."Text"]
	self.Check1.label:SetText(L[9.002])
	self.Check1.tooltipText = L[9.002]
	self.Check1.tooltipRequirement = description

	self.panel = CreateFrame("Frame", nil, self, "BackdropTemplate")
	self.panel:SetSize(420, 603)
	self.panel:SetPoint("TOP", self, "TOP", 0, 5)
	self.panel:SetPoint("BOTTOM", self, "BOTTOM", 0, 2)
	self.panel:SetPoint("RIGHT", self, "RIGHT", -1, 0)
	self.panel:SetBackdrop(backdrop)
	self.panel:SetBackdropColor(0.05, 0.05, 0.05, 0)
	self.panel:SetBackdropBorderColor(0.5, 0.5, 0.5, 1)
	self.panel:SetClipsChildren(true)
	self.panel:EnableMouseWheel(true)
	self.panel:SetScript("OnMouseWheel", function(self, delta) self.scrollbar:SetValue(self.scrollbar.currentvalue-delta) end)

	self.panel.scrollbar = CreateFrame("Slider", nil, self.panel, "UIPanelScrollBarTemplate")
	self.panel.scrollbar:SetPoint("TOPRIGHT", self.panel, -5, -19)
	self.panel.scrollbar:SetPoint("BOTTOMRIGHT", self.panel, -5, 19)
	self.panel.scrollbar:SetScript("OnValueChanged", function(scroll, value)
			scroll.currentvalue = value
			if currentpage then currentpage:SetPoint("TOPLEFT", self.panel, "TOPLEFT", 0, value*50-12) end
		end)
	self.panel.scrollbar.back = self.panel.scrollbar:CreateTexture(nil, "BACKGROUND")
	self.panel.scrollbar:SetWidth(13)
	self.panel.scrollbar.back:SetColorTexture(0.1,0.1,0.1,1)
	self.panel.scrollbar.back:SetAllPoints(self.panel.scrollbar)
	self.panel.scrollbar:SetMinMaxValues(0, 10)
	self.panel.scrollbar:SetValueStep(1)
	self.panel.scrollbar.currentvalue = 0
	self.panel.scrollbar:Hide()

	self.choice = CreateFrame("Frame", nil, self, "BackdropTemplate")
	self.choice:SetSize(175, 28)
	self.choice:SetPoint("TOP", self.Check1, "BOTTOM", 0, -17)
	self.choice:SetPoint("RIGHT", self.panel, "LEFT", 0, 0)
	self.choice:SetBackdrop(backdrop)
	self.choice:SetBackdropColor(0.05, 0.05, 0.05, 0)
	self.choice:SetBackdropBorderColor(0.5, 0.5, 0.5, 1)

	self.button1 = CreateFrame("Button", nil, self, "FoxDBTest_SettingsButtonTemplate")
	self.button1:SetPoint("BOTTOMLEFT", self, "BOTTOMLEFT", 29, 10)
	self.button1:SetText("Excecute lua script")
	self.button1.tooltipText = "This will excecute the lua script entered into the edit box."
	self.button1:SetScript("OnClick", function()
			if InCombat then return end
			local text = self.editbox:GetText()
			local func, errorMessage = loadstring(text)
			if not errorMessage then After(0.1, func) end
		end)

	self.editbox = self.editbox or CreateFrame("EditBox", nil, self, "InputBoxTemplate")
	self.editbox:SetSize(200, 24)
	self.editbox:SetPoint("BOTTOM", self.button1, "TOP", 0, 5)
	self.editbox:SetAutoFocus(false)
	self.editbox:SetTextInsets(0, 0, 3, 3)
	self.editbox:SetMaxLetters(256)
	self.editbox:SetText("")
--	self.editbox.OnRefresh = function(self) self:SetText("") end
	self.editbox:Show()

	self.github = CreateFrame("Button", nil, self, "UIPanelButtonTemplate")
	self.github:SetSize(100, 26)
	self.github:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 0, -6)
	self.github:SetText("Github")
	self.github.tooltipText = "|cFFFFFF00Github of 00fox/FoxDB|r\n\n "..L[9.105]
	self.github:RegisterForClicks("AnyUp")
	self.github:SetScript("OnClick", function()
			StaticPopupDialogsText = "https://github.com/00fox/FoxDB"
			StaticPopup_Show("FoxDBTest_WEB_ADDRESS")
		end)

	self.reset = function() After(0.01, function()
			self.Check1:SetChecked(Global.TestActivated)
		end) end
	self:SetScript("OnShow", self.reset)
end
--▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
----------------------------------------------------------------------------------------------------
function Settings:Init1()
----------------------------------------------------------------------------------------------------
	self:SetFrameStrata("TOOLTIP")

	self.logo = self:CreateTexture(nil, "ARTWORK")
	self.logo:SetSize(36, 36)
	self.logo:SetPoint("TOPLEFT", 8, -8)
	self.logo:SetTexture("Interface\\Icons\\spell_shadow_brainwash")

	self.title = self:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
	self.title:SetScale(1.5)
	self.title:SetPoint("TOPLEFT", self.logo, "TOPRIGHT", 4, -4)
	self.title:SetText("FoxDB LIBRARY")
	self.title:SetTextColor(0.7, 0.7, 1, 1)
	self.title:SetJustifyH("LEFT")

	self.title2 = self:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
	self.title2:SetPoint("TOPLEFT", self.title, "BOTTOMLEFT", 1, 0)
	self.title2:SetText(L[9.100])

	self.Check1 = CreateFrame("CheckButton", "FoxDBTest_Settings_Check_1_1", self, "FoxDBTest_UICheckButtonTemplate")
	self.Check1:SetPoint("TOPLEFT", self.title2, "BOTTOMLEFT", -2, -17)
	self.Check1.label = _G[self.Check1:GetName().."Text"]
	self.Check1.label:SetText(L[9.101])
	self.Check1.tooltipText = L[9.101]
	self.Check1.tooltipRequirement = description
	self.Check1.OnClick = function(self, value)
			if InCombat then self:SetChecked(Global.useGlobalFrame) return end
			Global.useGlobalFrame = value
			FoxDBTest:SetVisible(FoxDBTest.GlobalFrame)
		end

	self.Check2 = CreateFrame("CheckButton", "FoxDBTest_Settings_Check_1_2", self, "FoxDBTest_UICheckButtonTemplate")
	self.Check2:SetPoint("TOPLEFT", self.Check1, "BOTTOMLEFT", 0, -10)
	self.Check2.label = _G[self.Check2:GetName().."Text"]
	self.Check2.label:SetText(L[9.102])
	self.Check2.tooltipText = L[9.102]
	self.Check2.tooltipRequirement = description
	self.Check2.OnClick = function(self, value)
			if InCombat then self:SetChecked(Global.useLayoutFrame) return end
			Global.useLayoutFrame = value
			FoxDBTest:SetVisible(FoxDBTest.LayoutFrame)
		end

	self.Check3 = CreateFrame("CheckButton", "FoxDBTest_Settings_Check_1_3", self, "FoxDBTest_UICheckButtonTemplate")
	self.Check3:SetPoint("TOPLEFT", self.Check2, "BOTTOMLEFT", 0, -10)
	self.Check3.label = _G[self.Check3:GetName().."Text"]
	self.Check3.label:SetText(L[9.103])
	self.Check3.tooltipText = L[9.103]
	self.Check3.tooltipRequirement = description
	self.Check3.OnClick = function(self, value)
			if InCombat then self:SetChecked(Global.useProfilFrame) return end
			Global.useProfilFrame = value
			FoxDBTest:SetVisible(FoxDBTest.ProfilFrame)
		end

	self.reset = function()
			if not FoxDBTest.Launched then self:Hide() return end
			if not Global.TestActivated then self:Hide() return end
			After(0.01, function()
				self.Check1:SetChecked(Global.useGlobalFrame)
				self.Check2:SetChecked(Global.useLayoutFrame)
				self.Check3:SetChecked(Global.useProfilFrame)
			end)
		end
	self:SetScript("OnShow", self.reset)
end
--▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
----------------------------------------------------------------------------------------------------
function Settings:Init2()
----------------------------------------------------------------------------------------------------
	self:SetFrameStrata("TOOLTIP")

	self.logo = self:CreateTexture(nil, "ARTWORK")
	self.logo:SetSize(36, 36)
	self.logo:SetPoint("TOPLEFT", 8, -8)
	self.logo:SetTexture("Interface\\Icons\\spell_shadow_brainwash")

	self.title = self:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
	self.title:SetScale(1.5)
	self.title:SetPoint("TOPLEFT", self.logo, "TOPRIGHT", 4, -4)
	self.title:SetText("FoxDB LIBRARY")
	self.title:SetTextColor(0.7, 0.7, 1, 1)
	self.title:SetJustifyH("LEFT")

	self.title2 = self:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
	self.title2:SetPoint("TOPLEFT", self.title, "BOTTOMLEFT", 1, 0)
	self.title2:SetText(L[9.200])

	self.Sliderlabel2 = self:CreateFontString(nil, "ARTWORK", "GameFontNormal")
	self.Sliderlabel2:SetPoint("TOPLEFT", self.title2, "BOTTOMLEFT", -1, -17)
	self.Sliderlabel2:SetText(L[9.104])
	self.Sliderlabel2:SetTextColor(1, 1, 1, 0.85)
	self.Sliderlabel2:SetJustifyH("LEFT")

	self.Slider1 = CreateFrame("Slider", "FoxDBTest_Settings_Slider2_1", self, "UISliderTemplateWithLabels")
	self.Slider1:SetSize(200, 20)
	self.Slider1:SetPoint("TOPLEFT", self.Sliderlabel2, "BOTTOMLEFT", 4, -4)
	self.Slider1:SetOrientation('HORIZONTAL')
	self.Slider1.tooltipText = L[9.104]
	self.Slider1:SetValueStep(0.1)
	self.Slider1:SetMinMaxValues(0.5, 1.5)
	--_G["FoxDBTest_Settings_Slider2_1Low"]:SetText('0.5')
	--_G["FoxDBTest_Settings_Slider2_1High"]:SetText('1.5')
	_G[self.Slider1:GetDebugName().."Low"]:SetText('0.5')
	_G[self.Slider1:GetDebugName().."High"]:SetText('1.5')
	self.Slider1:SetObeyStepOnDrag(true)
	self.Slider1:SetScript("OnValueChanged", function(self, value)
			if InCombat then self:SetValue(Global.FramesScale) return end
			value = tonumber(format("%.2f", value))
			self.Label:SetText(value)
			Global.FramesScale = value
			FoxDBTest:SetFrames()
		end)
	self.Slider1.Label = self.Slider1:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
	self.Slider1.Label:SetPoint("TOP", self.Slider1, "BOTTOM", 0, 0)

	self.reset = function()
			if not FoxDBTest.Launched then self:Hide() return end
			if not Global.TestActivated then self:Hide() return end
			After(0.01, function()
				self.Slider1:SetValue(Global.FramesScale or 1)
				self.Slider1.Label:SetText(Global.FramesScale or 1)
			end)
		end
	self:SetScript("OnShow", self.reset)
end
--▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
----------------------------------------------------------------------------------------------------
function Settings:Init9()
----------------------------------------------------------------------------------------------------
	self:SetFrameStrata("TOOLTIP")

	self.logo = self:CreateTexture(nil, "ARTWORK")
	self.logo:SetSize(36, 36)
	self.logo:SetPoint("TOPLEFT", 8, -8)
	self.logo:SetTexture("Interface\\Icons\\spell_shadow_brainwash")

	self.title = self:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
	self.title:SetScale(1.5)
	self.title:SetPoint("TOPLEFT", self.logo, "TOPRIGHT", 4, -4)
	self.title:SetText("FoxDB LIBRARY")
	self.title:SetTextColor(0.7, 0.7, 1, 1)
	self.title:SetJustifyH("LEFT")

	self.title2 = self:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
	self.title2:SetPoint("TOPLEFT", self.title, "BOTTOMLEFT", 1, 0)
	self.title2:SetText(L[9.900])

	self.label1 = self:CreateLabel(self, L[9.901], false, 423)
	self.label1:SetPoint("TOPLEFT", self.title2, "BOTTOMLEFT", -18, -17)

	self.button1 = CreateFrame("Button", nil, self, "FoxDBTest_SettingsButtonTemplate")
	self.button1:SetPoint("TOPLEFT", self.label1, "BOTTOMLEFT", 10, -17)
	self.button1:SetText(L[9.902])
	self.button1.tooltipText = L[9.903]
	self.button1:SetScript("OnClick", function()
			if InCombat then return end
			self:ResetGlobal()
		end)

	self.label2 = self:CreateLabel(self, L[9.904], false, 423)
	self.label2:SetPoint("TOPLEFT", self.button1, "BOTTOMLEFT", -10, -24)

	self.button2 = CreateFrame("Button", nil, self, "FoxDBTest_SettingsButtonTemplate")
	self.button2:SetPoint("TOPLEFT", self.label2, "BOTTOMLEFT", 10, -17)
	self.button2:SetText(L[9.905])
	self.button2.tooltipText = L[9.906]
	self.button2:SetScript("OnClick", function()
			if InCombat then return end
			self:ResetLayout()
		end)

	self.button3 = CreateFrame("Button", nil, self, "FoxDBTest_SettingsButtonTemplate")
	self.button3:SetPoint("TOPLEFT", self.button2, "BOTTOMLEFT", 0, -17)
	self.button3:SetText(L[9.907])
	self.button3.tooltipText = L[9.908]
	self.button3:SetScript("OnClick", function()
			if InCombat then return end
			local layout = self.dropdown1.selected
			if layout and layout ~= "" then
				self:DeleteLayout(layout)
			end
		end)

	self.dropdown1 = CreateFrame("Frame", nil, self, "UIDropDownMenuTemplate")
	self.dropdown1:SetSize(177, 24)
	GetChild(self.dropdown1, "Middle"):SetWidth(177)
	self.dropdown1:SetPoint("LEFT", self.button3, "RIGHT", 5, 0)
	self.dropdown1.initialize = function()
			for _,layoutname in next, Datas:GetLayouts(true) do
				local option = {}
				option.value = layoutname
				option.text = layoutname
				option.func = function(option)
						if InCombat then return end
						self.dropdown1.selected = option.value
						self.dropdown1.Text:SetText(option.value)
					end
				option.checked = layoutname == (self.dropdown1.selected or Keys.layout)
				UIDropDownMenu_AddButton(option)
			end
			self.dropdown1.Text:SetText(self.dropdown1.selected or "")
		end

	self.button4 = CreateFrame("Button", nil, self, "FoxDBTest_SettingsButtonTemplate")
	self.button4:SetPoint("TOPLEFT", self.button3, "BOTTOMLEFT", 0, -17)
	self.button4:SetText(L[9.909])
	self.button4.tooltipText = L[9.910]
	self.button4:SetScript("OnClick", function()
			if InCombat then return end
			local layout = self.dropdown2.selected
			if layout and layout ~= "" then
				self:CopyLayout(layout)
			end
		end)

	self.dropdown2 = CreateFrame("Frame", nil, self, "UIDropDownMenuTemplate")
	self.dropdown2:SetSize(177, 24)
	GetChild(self.dropdown2, "Middle"):SetWidth(177)
	self.dropdown2:SetPoint("LEFT", self.button4, "RIGHT", 5, 0)
	self.dropdown2.initialize = function()
			for _,layoutname in next, Datas:GetLayouts(true) do
				local option = {}
				option.value = layoutname
				option.text = layoutname
				option.func = function(option)
						if InCombat then return end
						self.dropdown2.selected = option.value
						self.dropdown2.Text:SetText(option.value)
					end
				option.checked = layoutname == (self.dropdown2.selected or Keys.layout)
				UIDropDownMenu_AddButton(option)
			end
			self.dropdown2.Text:SetText(self.dropdown2.selected or "")
		end

	self.label3 = self:CreateLabel(self, L[9.911], false, 423)
	self.label3:SetPoint("TOPLEFT", self.button4, "BOTTOMLEFT", -10, -24)

	self.button5 = CreateFrame("Button", nil, self, "FoxDBTest_SettingsButtonTemplate")
	self.button5:SetPoint("TOPLEFT", self.label3, "BOTTOMLEFT", 10, -17)
	self.button5:SetText(L[9.912])
	self.button5.tooltipText = L[9.913]
	self.button5:SetScript("OnClick", function()
			if InCombat then return end
			self:ResetProfile()
		end)

	self.button6 = CreateFrame("Button", nil, self, "FoxDBTest_SettingsButtonTemplate")
	self.button6:SetPoint("TOPLEFT", self.button5, "BOTTOMLEFT", 0, -17)
	self.button6:SetText(L[9.914])
	self.button6.tooltipText = L[9.915]
	self.button6:SetScript("OnClick", function()
			if InCombat then return end
			local profile = self.dropdown3.selected
			if profile and profile ~= "" then
				self:DeleteProfile(profile)
			end
		end)

	self.dropdown3 = CreateFrame("Frame", nil, self, "UIDropDownMenuTemplate")
	self.dropdown3:SetSize(177, 24)
	GetChild(self.dropdown3, "Middle"):SetWidth(177)
	self.dropdown3:SetPoint("LEFT", self.button6, "RIGHT", 5, 0)
	self.dropdown3.initialize = function()
			for _,layoutname in next, Datas:GetProfiles(true) do
				local option = {}
				option.value = layoutname
				option.text = layoutname
				option.func = function(option)
						if InCombat then return end
						self.dropdown3.selected = option.value
						self.dropdown3.Text:SetText(option.value)
					end
				option.checked = layoutname == (self.dropdown3.selected or Keys.profile)
				UIDropDownMenu_AddButton(option)
			end
			self.dropdown3.Text:SetText(self.dropdown3.selected or "")
		end

	self.button7 = CreateFrame("Button", nil, self, "FoxDBTest_SettingsButtonTemplate")
	self.button7:SetPoint("TOPLEFT", self.button6, "BOTTOMLEFT", 0, -17)
	self.button7:SetText(L[9.916])
	self.button7.tooltipText = L[9.917]
	self.button7:SetScript("OnClick", function()
			if InCombat then return end
			local profile = self.dropdown4.selected
			if profile and profile ~= "" then
				self:CopyProfile(profile)
			end
		end)

	self.dropdown4 = CreateFrame("Frame", nil, self, "UIDropDownMenuTemplate")
	self.dropdown4:SetSize(177, 24)
	GetChild(self.dropdown4, "Middle"):SetWidth(177)
	self.dropdown4:SetPoint("LEFT", self.button7, "RIGHT", 5, 0)
	self.dropdown4.initialize = function()
			for _,layoutname in next, Datas:GetProfiles(true) do
				local option = {}
				option.value = layoutname
				option.text = layoutname
				option.func = function(option)
						if InCombat then return end
						self.dropdown4.selected = option.value
						self.dropdown4.Text:SetText(option.value)
					end
				option.checked = layoutname == (self.dropdown4.selected or Keys.profile)
				UIDropDownMenu_AddButton(option)
			end
			self.dropdown4.Text:SetText(self.dropdown4.selected or "")
		end

	self.reset = function()
			After(0.01, function()
				self.dropdown1.selectedID = nil
				self.dropdown1.selected = nil
				self.dropdown1.Text:SetText("")
				self.dropdown2.selectedID = nil
				self.dropdown2.selected = nil
				self.dropdown2.Text:SetText("")
				self.dropdown3.selectedID = nil
				self.dropdown3.selected = nil
				self.dropdown3.Text:SetText("")
				self.dropdown4.selectedID = nil
				self.dropdown4.selected = nil
				self.dropdown4.Text:SetText("")
			end)
		end
	self:SetScript("OnShow", self.reset)
end


--▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
--										SETTING PAGES
--▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓


--▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
----------------------------------------------------------------------------------------------------
function Settings:ToYellow(text)
----------------------------------------------------------------------------------------------------
	text = text:gsub("YYY",			"|cFFFFCC00")
	text = text:gsub("GGG",			"|cFF33FF99")
	text = text:gsub("BBB",			"|cFF99AAFF")
	text = text:gsub("OOO",			"|cFFFF6600")
	text = text:gsub("YY",			"|r")
	return text
end
--▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
----------------------------------------------------------------------------------------------------
function Settings:AddPages()
----------------------------------------------------------------------------------------------------
	local page, title, width = self:AddPage(L[6.0], L[6.1])
	local text = page:CreateFontString(nil, "BACKGROUND", "GameFontHighlight")
	text:SetWidth(width)
	text:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 5, -15)
	text:SetJustifyH("LEFT")
	page:SetHeight(600)
	text:SetText(L[6.2].."\n\n                                                                     00fox")
	Choices[1]:Click()

	local page, title, width = self:AddPage("FoxDB", nil)
	local text = page:CreateFontString(nil, "BACKGROUND", "GameFontHighlight")
	text:SetWidth(width)
	text:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 5, -15)
	text:SetJustifyH("LEFT")
	page:SetHeight(950)
	text:SetText(self:ToYellow("GGGFoxDBYY manages the SavedVariables of YYYyour addonsYY,\r\
    with BBBEditModeYY's layouts included.\n\
Written in clean language and optimized code,\r\
    the goal of starting from scratch, in addition to EditMode,\r\
    is to not let the addon go through a full chain of dependencies,\r\
    having hundreds of lines of code actions before the next, each,\r\
    (and avoid too many unnecessary encapsulations).\r\
    YYYPriorityYY: quick launch, memory, intelligible code.\n\
This system is not in conflict with the systems already in place,\r\
    so you will not encounter any problem\r\
    when using it for a new addon,\r\
    to make a transition from an old one\r\
    or to keep an old one as it is.\n\
BBBLayoutsYY management is fully automated,\r\
     user access is not required,\r\
     but some things are still doable.\n\
You of course still have access\r\
    to a simplified version of the BBBprofilesYY;\r\
    otherwise, this part remains dormant.\n\
No nightmares with BBBdefaultYY databases,\r\
     you define variables in a function\r\
     if they don't already exist on loading.\r\
     In others, do what you need\r\
     when the layout/profile is changed/reset.\n\
If you come from an already made addon\r\
    in a classic way (global+profiles),\r\
    a OOOtransitionYY exists internally to change these things\r\
    and keep the defaults in each profile that used it,\r\
    after which there is no longer a default profile.\r\
    (Remember to make a backup beforehand)\n\
The final goal being to use the globals,\r\
    the layout (instead of the profile),\r\
    and the profile for the few variables,\r\
         which remain necessary to be specific to each character.\r\
    But in the meantime,\r\
    your base will continue to function as before,\r\
    as long as you don't start using the layouts yourself.\n\
SavedVariables files are also written during YYY/reloadYY\n\
Register one or several OOOchat commandsYY\r\
    and receive the arguments already split into a function.\n\
Possibility of an OOOMinimap iconYY, in ultra light code,\r\
    without any inconvenience if not used.\r\
    Player's EditMode support to manage them,\r\
         including visibility,\r\
         so not conflicting with BBBAddonCompartmentYY.\n\
EditMode:\r\
    Addons receive a simplified OOOcommon supportYY\r\
         for the correct functioning of all (addons and system).\r\
    Automatic OOOframe registrationYY.\r\
    Automatic OOOshowing/hidding framesYY\r\
         when entering/exiting EditMode.\r\
    Automatic OOOhidding system menusYY and OOOhighlighting framesYY.\r\
    Receive a OOOcallback when a frame is clickedYY\r\
         to hide/show your menu.\n\
Note:\r\
    You manually start your addon, then load the Database,\r\
    which will tell you when the layouts are ready;\r\
     you therefore control everything\r\
     with a feeling of the early days of wow.\n"))

	local page, title, width = self:AddPage("MyAddon.toc", nil)
	local text = page:CreateFontString(nil, "BACKGROUND", "GameFontHighlight")
	text:SetWidth(width)
	text:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 5, -15)
	text:SetJustifyH("LEFT")
	page:SetHeight(600)
	text:SetText(self:ToYellow("In your YYYMyAddon.tocYY file:\n\n\
Add usual descriptions...\n\
    YYY## Title: MyAddonYY\r\
    YYY## SavedVariables: MyAddonDB\r\
    ...YY\n\n\
You don't need another library:\r\
    GGGFoxDB.xmlYY\n\n\
You may need advanced ones to do what you want,\r\
    or, it is needed by another library.\r\
    But they're not recommanded (see next chapter).\r\
    LibSharedMedia-3.0\\lib.xml (for example)\n\n\
Then,\r\
    YYYMyAddon.lua\r\
    ...YY\n"))

	local page, title, width = self:AddPage("Libraries", nil)
	local text = page:CreateFontString(nil, "BACKGROUND", "GameFontHighlight")
	text:SetWidth(width)
	text:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 5, -15)
	text:SetJustifyH("LEFT")
	page:SetHeight(900)
	text:SetText(self:ToYellow("The idea was good,\r\
    reducing the memory needed in total of all addons\n\
    Except that most of times,\r\
    it consumes a lot of resources\r\
    to handle all the possibilites\r\
    of functions already present in wow.\r\
    And this in most cases,\r\
    for simple things you can do on your own\r\
    Or it's 2000 lines of code and 500 lines being processed,\r\
    for only one if it had been done manually\r\
    knowing that it's not that hard.\n\n\
Some BBBalternativesYY:\n\n\
Registers a callback to a classic event:\r\
    (Example: YYY\"WORLD_CURSOR_TOOLTIP_UPDATE\"YY)\n\
    YYYEventRegistry:RegisterFrameEventAndCallback\r\
         (frameEvent, func, [owner], ...)\r\
    EventRegistry:UnregisterFrameEventAndCallback\r\
         (frameEvent, owner)YY\n\n\
Registers a callback to a function event:\r\
    (Example: YYY\"EditMode.Enter\"YY)\n\
    YYYEventRegistry:RegisterCallback(Event, func, [owner], ...)\r\
    EventRegistry:UnregisterCallback(Event, owner)YY\n\n\
Registers a callback to a custom defined event (Mixin):\n\
    YYYCallbackRegistryMixin:RegisterCallback\r\
         (event, func, [owner], ...)\r\
    CallbackRegistryMixin:UnregisterCallback(event, owner)YY\n\n\
Securely posthooks the specified frame function:\r\
    (Works with secure frames)\r\
    (Example: YYY\"OnClick\"YY)\n\
    YYYframe:HookScript(\"handler\", hookfunc)YY\n\n\
Securely posthooks the specified function:\r\
    (Will be called with the same arguments\r\
    after the original call is performed)\r\
    (Example: YYY\"ToggleGameMenu\"YY)\n\
    YYYhooksecurefunc([table,] functionName, hookfunc)YY\n\n\
Calls the specified function\r\
    without propagating taint to the caller:\n\
    YYYsecurecall(func or functionName, ...)YY\n\n\
Gives a script to your own frame:\r\
    (Example: YYY\"OnClick\"YY)\n\
    YYYframe:SetScript(\"handler\", func [nil to remove])YY\n"))

	local page, title, width = self:AddPage("MyAddon.lua", nil)
	local text = page:CreateFontString(nil, "BACKGROUND", "GameFontHighlight")
	text:SetWidth(width)
	text:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 5, -15)
	text:SetJustifyH("LEFT")
	page:SetHeight(1000)
	text:SetText(self:ToYellow("Keep a variable of your BBBaddon tableYY:\r\
    YYYlocal _, MyAddon = ...YY\n\n\
To access your addon as a BBBglobalYY:\r\
    YYY_G.MyAddon = MyAddonYY\n\n\
To start your first function you could simply use this:\n\
    YYYEventRegistry:RegisterFrameEventAndCallback\r\
         (\"VARIABLES_LOADED\",\r\
              function() MyAddon:onInitialize() end,\r\
              MyAddon)YY\n\n\
And later you could unregister any callback\r\
if you no longer needed:\n\
    YYYEventRegistry:UnregisterFrameEventAndCallback\r\
         (\"VARIABLES_LOADED\", MyAddon)YY\n\n\
But if you want to BBBhandle multiple eventsYY in your add-on,\r\
better use this:\n\
Define the function that will process the events:\n\
    YYYlocal function OnEvent(frame, event, arg)\n\
        if event == \"ADDON_LOADED\"\r\
        and arg == \"MyAddon\" then\r\
             MyAddon:onInitialize()YY\r\
             (this call onInitialize() after your addon is fully loaded)\r\
        YYYend\n\
    endYY\n\n\
BBBOptionalYY:\n\
YYY\"ADDON_LOADED\" and arg == \"AnotherAddon\"YY\r\
    To do something after another addon is loaded\n\
YYY\"VARIABLES_LOADED\"YY\r\
    To do something with CVars\n\
YYY\"PLAYER_LOGIN\"YY\r\
    To do something when player login,\r\
    only once when the UI loads\n\
YYY\"SETTINGS_LOADED\"YY\r\
    To do something when settings have been loaded\n\
YYY\"PLAYER_ENTERING_WORLD\"YY\r\
    To do something when new zone is loaded\n\
YYY\"PLAYER_REGEN_DISABLED\"YY\r\
    To so something when entering in combat\n\
YYY\"PLAYER_REGEN_ENABLED\"YY\r\
    To so something when exiting combat\n\
YYY...YY\n\n\
Note: Don't use YYY\"EDIT_MODE_LAYOUTS_UPDATED\"YY,\r\
    GGGFoxDBYY already call YYYonLayoutLoaded()YY\n\n\
Create the frame that will handle the events:\r\
    YYYlocal EventHandler = CreateFrame(\"Frame\", nil)YY\n\n\
Define the function that will process the events for the frame:\r\
    YYYEventHandler:SetScript(\"OnEvent\", OnEvent)YY\n\n\
Register any events to be processed by the frame:\r\
    YYYEventHandler:RegisterEvent(\"ADDON_LOADED\")\r\
    ...YY\n"))

	local page, title, width = self:AddPage("onInitialize()", nil)
	local text = page:CreateFontString(nil, "BACKGROUND", "GameFontHighlight")
	text:SetWidth(width)
	text:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 5, -15)
	text:SetJustifyH("LEFT")
	page:SetHeight(750)
	text:SetText(self:ToYellow("Function called by you when your addon is loaded\n\n\
YYYfunction MyAddon:onInitialize(reset)YY\n\
    Initialize your BBBdatabaseYY:\r\
         YYYself.db = FoxDB:New(self, \"MyAddonDB\")YY\n\n\
    You can already access these tables:\r\
         Variables for all characters that share the same...\n\
         YYYself.db.globalYY          account\r\
         YYYself.db.realmYY           realm\r\
         YYYself.db.factionYY         faction\r\
         YYYself.db.raceYY             race\r\
         YYYself.db.classYY            class\r\
         YYYself.db.frealmYY         faction+realm\n\n\
    You can already access these keys:\n\
         YYYself.db.keys.dbnameYY        Name of the BBBDatabaseYY\r\
         YYYself.db.keys.lockedYY       BBBDatabaseYY operation in progress\r\
         YYYself.db.keys.editmodeYY  BBBEditModeYY is active\r\
         YYYself.db.keys.nameYY          Name\r\
         YYYself.db.keys.raceYY            Race\r\
         YYYself.db.keys.classYY           Class\r\
         YYYself.db.keys.factionYY        Faction\r\
         YYYself.db.keys.realmYY          Realm\r\
         YYYself.db.keys.charYY            Name+Realm\r\
         YYYself.db.keys.frealmYY        Faction+Realm\n\n\
    When you intend to use BBBprofilesYY (character dependant) too:\n\
         YYYself.db = FoxDB:New(self, \"MyAddonDB\", true)YY\n\
         YYYself.db.profileYY            Current profile\r\
         YYYself.db.keys.profileYY   Current profile's name\n\n\
    Some stuff that don't need layouts\r\
         Elements that require layouts start at onLayoutLoaded(),\r\
         wait for it to do the real start of your addon.\n\n\
    Use the boolean variable 'YYYresetYY' to distinguish\r\
         what needs to be done only once\r\
         from what needs to be redone\r\
         using a reset of global variables.\n\
YYYendYY\n"))

	local page, title, width = self:AddPage("onNewProfile()", nil)
	local text = page:CreateFontString(nil, "BACKGROUND", "GameFontHighlight")
	text:SetWidth(width)
	text:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 5, -15)
	text:SetJustifyH("LEFT")
	page:SetHeight(600)
	text:SetText(self:ToYellow("Function called by GGGFoxDBYY when a BBBprofileYY didn't exist\r\
    (optional: don't put if not used to not register it)\n\n\
YYYfunction MyAddon:onNewProfile()YY\n\
    There is no need to a default profile anymore.\r\
    Then do veryfirsttime stuff there, time stamps etc.\r\
    but better do variables management in onProfileChanged.\n\
YYYendYY\n\n\
Note: YYYonProfileChanged()YY will be called afterwards,\r\
    don't call it by yourself.\n"))

	local page, title, width = self:AddPage("onProfileChanged()", nil)
	local text = page:CreateFontString(nil, "BACKGROUND", "GameFontHighlight")
	text:SetWidth(width)
	text:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 5, -15)
	text:SetJustifyH("LEFT")
	page:SetHeight(600)
	text:SetText(self:ToYellow("Function called by GGGFoxDBYY when a BBBprofileYY has been changed\r\
    (optional: don't put if not used to not register it)\n\n\
YYYfunction MyAddon:onProfileChanged()YY\n\
    If the profile did not already exist,\r\
    YYYonNewProfile()YY (if used) was called before this.\n\n\
    You may want to reset, erase some old datas\r\
    from previous versions, or specific while change is made:\n\
    YYYself.db.profile.myVariable = true\r\
    self.db.profile.mySubBase = {}\r\
    self.db.profile.mySubBase.myVariable = \"sometext\"\r\
    self.db.profile.myUnneededVariable = nil\r\
    self.db.profile.mySubBase = nilYY\n\n\
    But it's time to add the BBBprofileYY dependant datas:\n\
    YYYif type(self.db.profile.myVariable) ~= \"boolean\" then\r\
         self.db.profile.myVariable = true\r\
    end\n\
    if not self.db.profile.mySubBase then\r\
         self.db.profile.mySubBase = {}\r\
    end\n\
    if type(self.db.profile.mySubBase.myVariable) ~= \"string\" then\r\
         self.db.profile.mySubBase.myVariable = \"sometext\"\r\
    endYY\n\
YYYendYY\n\n\
Note: This is why there is no longer a BBBdefaultYY data system\r\
    This works the same with BBBlayoutsYY\n\
    If you still need to offer the user a choice\r\
    for specific variables between global and profile,\r\
    put the choice in a profile variable;\r\
    and depending on this choice,\r\
    use a golable variable or profile where necessary.\r\
    (A simple checkbox is then sufficient)\n"))

	local page, title, width = self:AddPage("onLayoutLoaded()", nil)
	local text = page:CreateFontString(nil, "BACKGROUND", "GameFontHighlight")
	text:SetWidth(width)
	text:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 5, -15)
	text:SetJustifyH("LEFT")
	page:SetHeight(600)
	text:SetText(self:ToYellow("Function called by GGGFoxDBYY when BBBlayoutsYY are ready\r\
    (Real start of your addon)\n\n\
YYYfunction MyAddon:onLayoutLoaded()YY\n\
    You can already access these BBBtablesYY:\r\
         Variables for all characters that share the same...\n\
         YYYself.db.layoutYY        layout\n\n\
    You can already access these BBBkeysYY:\n\
         YYYself.db.keys.layoutYY   Name of the current layout\n\
YYYendYY\n"))

	local page, title, width = self:AddPage("onNewLayout()", nil)
	local text = page:CreateFontString(nil, "BACKGROUND", "GameFontHighlight")
	text:SetWidth(width)
	text:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 5, -15)
	text:SetJustifyH("LEFT")
	page:SetHeight(600)
	text:SetText(self:ToYellow("Function called by GGGFoxDBYY when a BBBlayoutYY didn't exist\r\
    (optional: don't put if not used to not register it)\n\n\
YYYfunction MyAddon:onNewLayout()YY\n\
    Technically this will only happen on load\r\
         if the layout doesn't exist,\r\
         or when the layout is reset by the function made for this.\r\
         Because, when creating (or moving to) a new layout,\r\
         the new layout is copied from the current one\r\
         or from the source of the copy.\n\n\
    Then do veryfirsttime stuff there, time stamps etc.\r\
    but better do variables management in onLayoutChanged.\n\
YYYendYY\n\n\
Note: YYYonLayoutChanged()YY will be called afterwards,\r\
    don't call it by yourself.\n"))

	local page, title, width = self:AddPage("onLayoutChanged()", nil)
	local text = page:CreateFontString(nil, "BACKGROUND", "GameFontHighlight")
	text:SetWidth(width)
	text:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 5, -15)
	text:SetJustifyH("LEFT")
	page:SetHeight(600)
	text:SetText(self:ToYellow("Function called by GGGFoxDBYY when a BBBlayoutYY has been changed\n\n\
YYYfunction MyAddon:onLayoutChanged()YY\n\
    If the layout did not already exist,\r\
    it was copied from the current layout,\r\
    otherwise, YYYonNewLayout()YY (if used) was called before this.\n\n\
    You may want to reset, erase some old datas\r\
    from previous versions, or specific while change is made:\n\
    YYYself.db.layout.myVariable = true\r\
    self.db.layout.mySubBase = {}\r\
    self.db.layout.mySubBase.myVariable = \"sometext\"\r\
    self.db.layout.myUnneededVariable = nil\r\
    self.db.layout.mySubBase = nilYY\n\n\
    But it's time to add the BBBlayoutYY dependant datas:\n\
    YYYif type(self.db.layout.myVariable) ~= \"boolean\" then\r\
         self.db.layout.myVariable = true\r\
    end\n\
    if not self.db.layout.mySubBase then\r\
         self.db.layout.mySubBase = {}\r\
    end\n\
    if type(self.db.layout.mySubBase.myVariable) ~= \"string\" then\r\
         self.db.layout.mySubBase.myVariable = \"sometext\"\r\
    endYY\n\
YYYendYY\n\n\
Note: This is why there is no longer a BBBdefaultYY data system\r\
    This works the same with BBBprofilesYY (if used)\n"))

	local page, title, width = self:AddPage("onLayoutRenamed()", nil)
	local text = page:CreateFontString(nil, "BACKGROUND", "GameFontHighlight")
	text:SetWidth(width)
	text:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 5, -15)
	text:SetJustifyH("LEFT")
	page:SetHeight(600)
	text:SetText(self:ToYellow("Function called by GGGFoxDBYY when a BBBlayoutYY has been renamed\r\
    (optional: don't put if not used to not register it)\n\n\
YYYfunction MyAddon:onLayoutRenamed()YY\n\
    Occurs when the layout was simply renamed.\r\
         There is nothing specific to do,\r\
         GGGFoxDBYY already managed to do the changes\r\
         in the BBBDatabaseYY.\n\
YYYendYY\n"))

	local page, title, width = self:AddPage("onLayoutSaved()", nil)
	local text = page:CreateFontString(nil, "BACKGROUND", "GameFontHighlight")
	text:SetWidth(width)
	text:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 5, -15)
	text:SetJustifyH("LEFT")
	page:SetHeight(600)
	text:SetText(self:ToYellow("Function called by GGGFoxDBYY when a BBBlayoutYY has been saved\r\
    (optional: don't put if not used to not register it)\n\n\
YYYfunction MyAddon:onLayoutSaved()YY\n\
    Occurs when the layout is saved\r\
    but not changed, copied or saved.\r\
         If it can help...\n\
YYYendYY\n"))

	local page, title, width = self:AddPage("onPlayerLogout()", nil)
	local text = page:CreateFontString(nil, "BACKGROUND", "GameFontHighlight")
	text:SetWidth(width)
	text:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 5, -15)
	text:SetJustifyH("LEFT")
	page:SetHeight(600)
	text:SetText(self:ToYellow("Function called by GGGFoxDBYY when the BBBplayerYY log out\r\
    (optional: don't put if not used to not register it)\n\n\
YYYfunction MyAddon:onPlayerLogout()YY\n\
    Occurs when the player log out,\r\
    after exiting world.\r\
    You can use it to perform some tasks\r\
    before the database is cleaned.\n\
YYYendYY\n"))

	local page, title, width = self:AddPage("More practical", nil)
	local text = page:CreateFontString(nil, "BACKGROUND", "GameFontHighlight")
	text:SetWidth(width)
	text:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 5, -15)
	text:SetJustifyH("LEFT")
	page:SetHeight(600)
	text:SetText(self:ToYellow("How to place keys in variables\r\
    to use them more practically throughout your file\n\n\
YYYlocal BBBGlobalYY\r\
local BBBProfileYY\r\
local BBBLayoutYY\r\
local BBBKeysYY\r\
local BBBInCombatYY\n\n\
function MyAddon:onInitialize(reset)\r\
    self.db   = FoxDB:New(self, \"MyAddonDB\", [true])\r\
    Global    = self.db.global\r\
    Profile    = self.db.profile\r\
    Keys       = self.db.keys\r\
end\n\n\
function MyAddon:onLayoutLoaded()\r\
    Layout       = self.db.layout\r\
    InCombat  = InCombatLockdown()\r\
endYY"))

	local page, title, width = self:AddPage("Specific Functions", nil)
	local text = page:CreateFontString(nil, "BACKGROUND", "GameFontHighlight")
	text:SetWidth(width)
	text:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 5, -15)
	text:SetJustifyH("LEFT")
	page:SetHeight(600)
	text:SetText(self:ToYellow("Clear the BBBglobalYY variables,\r\
will call YYYonInitialize(true)YY then YYYonLayoutChanged()YY\r\
    YYYself.db:ResetGlobal()YY\n\n\n\
Clear the current BBBprofileYY,\r\
will call YYYonNewProfile()YY then YYYonProfileChanged()YY\r\
    YYYself.db:ResetProfile()YY\n\n\
Returns a table with the names of existing profiles,\r\
Current one is not in if 'nocurrent' is specified,\r\
otherwise current one is in 1st place.\r\
    YYYself.db:GetProfiles()YY\n\n\
Deletes a profile, except current.\r\
    YYYself.db:DeleteProfile(profile)YY\n\n\
Replace current profile by another,\r\
'YYYfromYY' is a string with profile name.\r\
    YYYself.db:CopyProfile(from)YY\n\n\n\
Clear the current BBBlayoutYY,\r\
will call YYYonNewLayout()YY then YYYonLayoutChanged()YY\r\
    YYYself.db:ResetLayout()YY\n\n\
Returns a table with the names of existing layouts,\r\
Current one is not in if 'nocurrent' is specified,\r\
otherwise current one is in 1st place.\r\
    YYYself.db:GetLayouts(nocurrent)YY\n\n\
Deletes a layout, except current.\r\
    YYYself.db:DeleteLayout(layout)YY\n\n\
Replace current layout by another,\r\
'YYYfromYY' is a string with layout name.\r\
    YYYself.db:CopyLayout(from)YY\n"))

	local page, title, width = self:AddPage("Chat commands", nil)
	local text = page:CreateFontString(nil, "BACKGROUND", "GameFontHighlight")
	text:SetWidth(width)
	text:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 5, -15)
	text:SetJustifyH("LEFT")
	page:SetHeight(600)
	text:SetText(self:ToYellow("If you want to use BBBchat commandsYY:\n\n\
Place in your file a function to receive player commands:\r\
    (optional: don't put if not used to not register it)\n\
    YYYMyAddon:onChatCommand(cmd, arg1, arg2, arg3, arg4, ...)\r\
         if cmd == \"myaddoncmd\" then\r\
              ...\r\
         elseif cmd == \"myaddoncmd2\" then\r\
              ...\r\
         end\r\
    endYY\n\n\
Register the command with:\r\
    YYYself.db:RegisterChatCommand(\"myaddoncmd\")YY\n\n\
You can use it more than once to register multiple commands:\r\
    YYYself.db:RegisterChatCommand(\"myaddoncmd2\")\r\
    ...YY\n\n\
You can already access this BBBkeyYY:\r\
    YYYself.db.keys.chatYY   Number of registred commands\n\n\
The player can send multiple lines at once,\r\
    it will trigger the function once for each line.\n"))

	local page, title, width = self:AddPage("Using locales", nil)
	local text = page:CreateFontString(nil, "BACKGROUND", "GameFontHighlight")
	text:SetWidth(width)
	text:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 5, -15)
	text:SetJustifyH("LEFT")
	page:SetHeight(1650)
	text:SetText(self:ToYellow("You can use a library, common solutions, takes memory,\r\
    uses complex operations, compare tables, for each addon.\n\n\
    Or just need to do that:\n\n\
    BBBOnly one fileYY: GGGlocale.luaYY\n\
    YYYlocal locale = GetLocale()\r\
    if locale == \"deDE\" then\r\
          ...\r\
    else\r\
          ...\r\
    endYY\n\
    Add him in your GGGMyAddon.tocYY file\n\n\n\
    BBBMultiple filesYY:\n\
    Make a directory named GGGlocaleYY;\r\
    Add a file named GGGxxZZ.luaYY in it for each locale you want,\r\
    enUS[enGB], deDE, itIT, esES, esMX, frFR,\r\
    koKR, ptBR, ruRU, zhCN, zhTW\n\
    YYYlocal locale = GetLocale()\r\
    if locale ~= \"deDE\" then return end\r\
         ...YY\n\
    Add a line for each of them in your GGGMyAddon.tocYY file\r\
    before main lua, and, depending on solution,\r\
    give priority to default language.\n\n\n\
BBBSOLUTION 1YY: Full text for each\n\n\
    YYYMyAddon.L = {}\r\
    local L = MyAddon.L\n\n\
    L[\"My Text\"] = \"My Text\"\r\
    L[\"My Text\"] = \"Mein Text\"\n\n\
    print(L[\"My Text\"])YY\n\n\
Advantage:\r\
     Accessed directly.\r\
Inconvenience:\r\
     Uses more memory.\n\n\n\
BBBSOLUTION 2YY: Use a simple base and a function\n\n\
    YYYMyAddon.L = {}\r\
    local function L(text)\r\
         return MyAddon.L[text] == true and text\r\
         or MyAddon.L[text]\r\
    end\n\n\
    L[\"My Text\"] = true\r\
    L[\"My Text\"] = \"Mein Text\"\n\n\
    print(L(\"My Text\"))YY\n\n\
Advantage:\r\
     Default language takes only half of the memory.\r\
Inconvenience:\r\
     You need to pass by a function to access the value.\n\n\n\
BBBSOLUTION 3YY: Use a metatable,\r\
    to reindex the real values with strings\n\n\
    YYYMyAddon.L = setmetatable({},\r\
    {__newindex = function(self, key, value)\r\
         rawset(self, key, value == true and key or value)\r\
    end})\r\
    local L = MyAddon.L\n\n\
    L[\"My Text\"] = true\r\
    L[\"My Text\"] = \"Mein Text\"\n\n\
    print(L[\"My Text\"])YY\n\n\
Advantage:\r\
     Default language takes only half of the memory,\r\
     accessed ~directly.\r\
Inconvenience:\r\
     You need to pass by an indexed database to access the value.\n\n\n\
BBBSOLUTION 4YY: Use numbers as index\n\n\
    YYYMyAddon.L = {}\r\
    local L = MyAddon.L\n\n\
    L[4.205] = \"My Text\"\r\
    L[4.205] = \"Mein Text\"\n\n\
    print(L[4.205])YY\n\n\
Advantage:\r\
     Default language takes only half of the memory,\r\
     accessed directly.\r\
     Possible and simple architecture,\r\
     example: Part 4, Subpart 2, text 5.\r\
Inconvenience:\r\
     It is more difficult when looking through the code\r\
     to know what text the variable refers to.\n"))

	local page, title, width = self:AddPage("Minimap icon", nil)
	local text = page:CreateFontString(nil, "BACKGROUND", "GameFontHighlight")
	text:SetWidth(width)
	text:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 5, -15)
	text:SetJustifyH("LEFT")
	page:SetHeight(1200)
	text:SetText(self:ToYellow("Besides BBBAddonCompartmentYY,\r\
    you can add your own minimap icon\n\
Into EditMode, player can decide what to do with it,\r\
then the two solutions are not in conflict,\r\
you could also add them to do two different things.\r\
    (optional: don't put if not used to not register it)\n\n\
if you want to use it, into YYYonInitialize()YY, after:\n\
    YYYself.db = FoxDB:New(self, \"MyAddonDB\", [true])YY\n\n\
Add your unique identifier:\n\
    YYYself.db.icon.label = \"MyAddon\"YY\n\n\
An icon object (https://www.wowhead.com/icons):\n\
    YYYself.db.icon.file = \"Interface\\Icons\\spell_shadow_brainwash\"YY\r\
    (FreeMind addon example)\n\n\
You can add tooltip descriptions for each mouse buttons (optional)\n\
    YYYself.db.icon.line1 = \"Left click action description\"YY\r\
    YYYself.db.icon.line2 = \"Middle click action description\"YY\r\
    YYYself.db.icon.line3 = \"Right click action description\"YY\n\n\
Launch Icon:\r\
    The first time they get a random place\r\
    onto the border of the minimap.\n\
    YYYself.db:IconStart()YY\n\n\
You can already access these tables:\n\
     YYYself.db.icon.buttonYY   Your addon's icon\r\
     YYYself.db.icon.labelYY    Unique identifier\n\n\
You can put into your main file these functions,\r\
to excute actons while the icon is clicked.\r\
    (optional: don't put all if not used to not register them)\n\
    YYYfunction MyAddon:onIconLeftClick() ... end\r\
    function MyAddon:onIconMiddleClick() ... end\r\
    function MyAddon:onIconRightClick() ... endYY\n\n\
Into BBBEditModeYY, it get a dedicated menu,\r\
     and the player can change:\r\
     Where to place.\r\
     Whether it stays visible or not outside EditMode.\r\
     How much it grows to a factor size of x3 from x0.8.\r\
     An offset of the distance with the Minimap's border.\r\
     Two alpha values while mouseOn or MouseOut.\n\
Your addon can be notified if player changes visibility\r\
    (optional: don't put if not used to not register it)\n\
    YYYfunction MyAddon:onIconVisibility(visible) ... endYY\n\n\
GGGOthers addonsYY icons:\r\
Icon object:\n\
    YYYAddonName.db.icon.iconYY\n\n\
Table containing all addons icons:\n\
    YYYself.db:GetIcons()\r\
    for label,icon in pairs(self.db:GetIcons()) do ... endYY\n\n\
GGGMinimapYY behavior:\r\
    You can indicate that your addon change the mininmap\r\
    from circle to square with this function:\n\
    YYYself.db:IconSquare(isSquare)YY"))

	local page, title, width = self:AddPage("EditMode", nil)
	local text = page:CreateFontString(nil, "BACKGROUND", "GameFontHighlight")
	text:SetWidth(width)
	text:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 5, -15)
	text:SetJustifyH("LEFT")
	page:SetHeight(1050)
	text:SetText(self:ToYellow("In order to manage a frame into EditMode you need an BBBoverlayYY.\n\n\
You have to do this part yourself:\r\
    YYYlocal MyFrame\r\
    local overlay = CreateFrame(\"Frame\", nil, MyFrame, \"EditModeSystemSelectionTemplate\")YY\r\
    (Set the overlay's parent to your frame, not UIParent,\r\
    otherwise you'll get errors while moving system frames.)\n\n\
Manage it's position, drag etc:\n\
    YYYoverlay:SetScript('OnDragStart', ...)\r\
    overlay:SetScript('OnDragStop', ...)YY\n\n\
    Set all points of BBBoverlayYY to the frame.\r\
    When you start to drag the overlay, hide your menu,\r\
    clear all points, then make the frame follow the overlay.\r\
    When you stop to drag the overlay, save the position,\r\
    and set all points of overlay to the frame again;\r\
    possibly show your menu again.\r\
    GGGA complete exemple is in FoxDBTestYY.\n\n\
And register it with FoxDB library\r\
    YYYself.db:RegisterSystemFrame(overlay)YY\n\n\
But after that, GGGFoxDBYY will manage which overlay\r\
    to put in white or yellow (Highlight),\r\
    based on which one was selectioned by the player.\n\n\
You can at any time unregister it, the frame will be hidden,\r\
and not shown again while entering edit mode.\r\
    YYYself.db:UnregisterSystemFrame(overlay)YY\n\n\
To create your own BBBmenuYY you need a ResizeLayoutFrame:\r\
    YYYlocal menu = CreateFrame(\"Frame\", nil, UIParent, \"ResizeLayoutFrame\")YY\r\
    and some YYYEditModeSetting...TemplateYY controls on it.\r\
    GGGA complete exemple is in FoxDBTestYY.\n\n\
And you receive in a function which overlay was clicked,\r\
    to decide to show or close your own menu based on that:\r\
    If it's a system one, frame == EditModeManagerFrame\r\
    YYYfunction MyAddon:onEditModeFrame(frame) ... endYY\r\
    (optional: don't put if not used to not register it)\n\n\
Additional functions linked to BBBEditModeYY:\r\
    YYYgridYY is a boolean, true if Grid is checked\r\
    YYYsnapYY is a boolean, true if Snap is checked\n\n\
Function called while entering EditMode:\r\
Overlays will be automatically shown and highlighted\r\
    YYYfunction MyAddon:onEditModeEnter(grid, snap) ... endYY\r\
    (optional: don't put if not used to not register it)\n\n\
Function called while exiting EditMode:\r\
Overlays will be automatically hidden\r\
You can close your menu\r\
    YYYfunction MyAddon:onEditModeExit() ... endYY\r\
    (optional: don't put if not used to not register it)\n\n\
Function called while player change grid option:\r\
    YYYfunction MyAddon:onEditModeGrid(grid) ... endYY\r\
    (optional: don't put if not used to not register it)\n\n\
Function called while player change snap option:\r\
    YYYfunction MyAddon:onEditModeSnap(snap) ... endYY\r\
    (optional: don't put if not used to not register it)\n"))

	local page, title, width = self:AddPage("Transition", nil)
	local text = page:CreateFontString(nil, "BACKGROUND", "GameFontHighlight")
	text:SetWidth(width)
	text:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 5, -15)
	text:SetJustifyH("LEFT")
	page:SetHeight(1010)
	text:SetText(self:ToYellow("If you come from an already existing database\r\
and want to use GGGFoxDBYY instead:\n\n\
- Keep a copy of your BBBSavedVariablesYY file aside.\n\n\
- Start by the manual start (see GGGMyAddon.luaYY), remove:\r\
         OOOMyAddon = LibStub(\"AceAddon-3.0\"):NewAddon...YY\r\
    Choose the start of your choice, to launch:\r\
         YYYMyAddon:onInitialize()YY instead\n\n\
- Modify every callback, to use yours (see GGGLibrariesYY).\r\
    From: YYYself:RegisterEvent(...)YY\r\
    To: YYYEventRegistry:RegisterCallback(...)YY\r\
    or better, use your own event handler.\n\n\
- Change YYYOnInitialize()YY to YYYMyAddon:onInitialize()YY\n\n\
----- Make a test, and if everything goes right then -----\n\n\
In BBBMyAddon.tocYY\r\
    Add GGGFoxDB.xmlYY\r\
    Remove OOOlibs\AceAddon-3.0\AceAddon-3.0.xmlYY\r\
    Remove OOOlibs\LibStub\LibStub.luaYY\r\
         (except if needed by another library)\n\n\
If you use chat commands, adapt it (see GGGChat commandsYY).\r\
    From: YYYself:RegisterChatCommand(\"myaddoncmd\", ...)YY\r\
    To: YYYself.db:RegisterChatCommand(\"myaddoncmd\")YY\r\
    From: YYYyourfunction(input)YY\r\
    To: YYYMyAddon:onChatCommand(cmd, arg1, arg2, arg3, arg4)YY\n\n\
In BBBMyAddon.luaYY, if you use them,\r\
    change all OOOself.db.factionrealmYY to GGGself.db.frealmYY\n\n\
In YYYMyAddon:onInitialize()YY add:\r\
    YYYself.db = FoxDB:New(self, \"MyAddonDB\", true)YY\r\
    YYYtrueYY indicates that you use profiles for the moment,\r\
    if you didn't use them remove it.\n\n\
In YYYMyAddon:onLayoutLoaded()YY\r\
    Put everything there was before in onInitialize() here,\r\
    it's the new start of the addon\r\
    once the layouts have been loaded.\n\n\
In YYYMyAddon:onProfileChanged()YY (see GGGonProfileChanged()YY)\r\
    Put everything you need after a new profile, reset or copy.\r\
    There is no more the concept of BBBDefaultYY profile and variables,\r\
    so you just need to check if a player posses old default there.\r\
    No need to use MyAddon:onNewProfile() now.\n\n\
----- Try your addon at this step, it should work as before -----\n\n\
    In your database, first time,\r\
    A BBBtransitionYY has been done to adapt everything like frealm,\r\
    and distribute old defaults profiles and values into each,\r\
    after what, default is supressed and never been used again.\n\n\
You can now possibly use some BBBsettingsYY functions\r\
(see GGGSpecific functionsYY)\r\
And perhaps transit some variables frome BBBprofilesYY to BBBlayoutsYY,\r\
if you want to use them (see GGGonLayoutChanged()YY).\r\
If not, you still have a very more light addon.\n"))
end