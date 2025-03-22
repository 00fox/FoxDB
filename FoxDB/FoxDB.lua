
--[[▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓FoxDB 11.1.0-0▓▓
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

	 Layout management is fully automated, user access is not required,
		 but some things are still doable.

	 You of course still have access to a simplified version of the profiles;
		 otherwise, this part remains dormant.

	 No nightmares with default databases,
		 you define variables in a function if they don't already exist on loading.
		 In others, do what you need when the layout/profile is changed/reset.

	 If you come from an already made addon in a classic way (global+profiles),
		a transition exists internally to change these things
			and keep the defaults in each profile that used it,
			after which there is no longer a default profile.
			(Remember to make a backup beforehand)

	 The final goal being to use the globals,
		the layout (instead of the profile),
		and the profile for the few variables which remain necessary to be specific to each character.
	 But in the meantime, your base will continue to function as before,
		as long as you don't start using the layouts yourself.

	 SavedVariable files are also written during /reload

	 Register one or several chat commands
		and receive the arguments already split into a function.

	 Possibility of an Minimap icon, in ultra light code, without any inconvenience if not used.
		Player's EditMode support to manage them, including visibility, so not conflicting with AddonCompartment.

	 EditMode:
		 Addons that use EditMode receive a simplified common support for the correct functioning of all (addons and system).
		 Automatic frame registration.
		 Automatic showing/hidding frames when entering/exiting EditMode.
		 Automatic hidding system menus and highlighting frames.
		 Receive a callback when a frame is clicked to hide/show your menu.

	 Note:
		You manually start your addon, then load the Database, which will tell you when the layouts are ready;
		 you therefore control everything with a feeling of the early days of wow.

]]

--▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
----------------------------------------------------------------------------------------------------
--											CODE
----------------------------------------------------------------------------------------------------
--▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓


local min, max, floor, ceil, rand, sqrt, log	= math.min, math.max, math.floor, math.ceil, math.random, math.sqrt, math.log
local huge, pi, cos, sin, deg, rad, atan2		= math.huge, math.pi, math.cos, math.sin, math.deg, math.rad, math.atan2
local len, match, find, sub, split, format		= string.len, string.match, string.find, string.sub, string.split, string.format
local lower, upper, capital						= string.lower, string.upper, function(str) return (str:gsub("^%l", string.upper)) end
local insert, remove, concat, sort				= table.insert, table.remove, table.concat, table.sort
local After, NewTicker, NewTimer				= C_Timer.After, C_Timer.NewTicker, C_Timer.NewTimer

local GetLayouts								= C_EditMode.GetLayouts
local IsAddonMessagePrefixRegistered			= C_ChatInfo.IsAddonMessagePrefixRegistered
local RegisterAddonMessagePrefix				= C_ChatInfo.RegisterAddonMessagePrefix
local SendAddonMessage							= C_ChatInfo.SendAddonMessage

local addonname, addon							= ...
addon.FoxDB										= {}
local FoxDB										= addon.FoxDB


--▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
--										VARIABLES
--▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓


-- library for all databases
FoxDB.Registry						= {}

-- library for all EditMode frames
FoxDB.Frames						= {}

-- library for all icons
FoxDB.Icons							= {}

-- Locales
FoxDB.L								= {}

-- Table for indexing main database functions
local FunctionsDB					= {}

-- Table for indexing layout functions, different from main because in all databases
local FunctionsL					= {}

-- Table for indexing Profile functions, different from layout because not necessary used
local FunctionsP					= {}

local locale						= GetLocale()
local nameKey						= UnitName("player")
local raceKey						= select(2, UnitRace("player"))
local classKey						= select(2, UnitClass("player"))
local factionKey					= UnitFactionGroup("player")
local realmKey						= GetRealmName()
local charKey						= UnitName("player").." - "..realmKey
local frealmKey						= factionKey.." - "..realmKey

local IconManager					= CreateFrame("Frame", nil, UIParent, "ResizeLayoutFrame")


--▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
--										LOCALES
--▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓


if locale == "deDE" then
	FoxDB.L["Icon is not visible"]	= "Symbol ist nicht sichtbar"
	FoxDB.L["Tooltip deactivated"]	= "Tooltip deaktiviert"
	FoxDB.L["Visible"]				= "Sichtbar"
	FoxDB.L["Tooltip"]				= "Tooltip"
	FoxDB.L["Mouse On"]				= "Maus an"
	FoxDB.L["Mouse Out"]				= "Mouse Out"
	FoxDB.L["Offset"]				= "Versatz"
	FoxDB.L["Next minimap icon"]		= "Nächstes Minikartensymbol"

elseif locale == "itIT" then
	FoxDB.L["Icon is not visible"]	= "L'icona non è visibile"
	FoxDB.L["Tooltip deactivated"]	= "Descrizione disattivata"
	FoxDB.L["Visible"]				= "Visibile"
	FoxDB.L["Tooltip"]				= "Descrizione"
	FoxDB.L["Mouse On"]				= "Mouse acceso"
	FoxDB.L["Mouse Out"]				= "Mouse fuori"
	FoxDB.L["Offset"]				= "Compensare"
	FoxDB.L["Next minimap icon"]		= "Icona successiva sulla minimappa"

elseif locale == "esES" or locale == "esMX" then
	FoxDB.L["Icon is not visible"]	= "El icono no es visible"
	FoxDB.L["Tooltip deactivated"]	= "Información desactivada"
	FoxDB.L["Visible"]				= "Visible"
	FoxDB.L["Tooltip"]				= "Información"
	FoxDB.L["Mouse On"]				= "Ratón encendido"
	FoxDB.L["Mouse Out"]				= "Ratón fuera"
	FoxDB.L["Offset"]				= "Compensar"
	FoxDB.L["Next minimap icon"]		= "Siguiente icono del minimapa"

elseif locale == "frFR" then
	FoxDB.L["Icon is not visible"]	= "L'icône n'est pas visible"
	FoxDB.L["Tooltip deactivated"]	= "Info-bulle désactivée"
	FoxDB.L["Visible"]				= "Visible"
	FoxDB.L["Tooltip"]				= "Info-bulle"
	FoxDB.L["Mouse On"]				= "Souris dessus"
	FoxDB.L["Mouse Out"]				= "Souris dehors"
	FoxDB.L["Offset"]				= "Offset"
	FoxDB.L["Next minimap icon"]		= "Prochaine Icône de minimap"

elseif locale == "koKR" then
	FoxDB.L["Icon is not visible"]	= "아이콘이 보이지 않습니다"
	FoxDB.L["Tooltip deactivated"]	= "툴팁 비활성화됨"
	FoxDB.L["Visible"]				= "보이는"
	FoxDB.L["Tooltip"]				= "툴팁"
	FoxDB.L["Mouse On"]				= "마우스 온"
	FoxDB.L["Mouse Out"]				= "마우스 아웃"
	FoxDB.L["Offset"]				= "오프셋"
	FoxDB.L["Next minimap icon"]		= "다음 미니맵 아이콘"

elseif locale == "ptBR" then
	FoxDB.L["Icon is not visible"]	= "O ícone não está visível"
	FoxDB.L["Tooltip deactivated"]	= "Dica desativada"
	FoxDB.L["Visible"]				= "Visível"
	FoxDB.L["Tooltip"]				= "Dica"
	FoxDB.L["Mouse On"]				= "Mouse entrar"
	FoxDB.L["Mouse Out"]				= "Mouse sair"
	FoxDB.L["Offset"]				= "Desvio"
	FoxDB.L["Next minimap icon"]		= "Próximo ícone do minimapa"

elseif locale == "ruRU" then
	FoxDB.L["Icon is not visible"]	= "Значок не виден"
	FoxDB.L["Tooltip deactivated"]	= "Подсказка отключена"
	FoxDB.L["Visible"]				= "Видимый"
	FoxDB.L["Tooltip"]				= "Подсказка"
	FoxDB.L["Mouse On"]				= "Мышь включена"
	FoxDB.L["Mouse Out"]				= "Мышь выведена"
	FoxDB.L["Offset"]				= "Компенсировать"
	FoxDB.L["Next minimap icon"]		= "Следующий значок"

elseif locale == "zhCN" or locale == "zhTW" then
	FoxDB.L["Icon is not visible"]	= "图标不可见"
	FoxDB.L["Tooltip deactivated"]	= "提示关闭"
	FoxDB.L["Visible"]				= "可见的"
	FoxDB.L["Tooltip"]				= "工具提示"
	FoxDB.L["Mouse On"]				= "鼠标打开"
	FoxDB.L["Mouse Out"]				= "鼠标移出"
	FoxDB.L["Offset"]				= "抵消"
	FoxDB.L["Next minimap icon"]		= "下一个小地图图标"

else
	FoxDB.L["Icon is not visible"]	= true
	FoxDB.L["Tooltip deactivated"]	= true
	FoxDB.L["Visible"]				= true
	FoxDB.L["Tooltip"]				= true
	FoxDB.L["Mouse On"]				= true
	FoxDB.L["Mouse Out"]				= true
	FoxDB.L["Offset"]				= true
	FoxDB.L["Next minimap icon"]		= true
end
local function L(text) return FoxDB.L[text] == true and text or FoxDB.L[text] end


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
-- self.db = FoxDB:New("MyAddonDB", useProfiles)
local firstdatabase = true
local maindb
function addon:New(MyAddonDB, useProfiles)
----------------------------------------------------------------------------------------------------
	if not MyAddonDB						then error("Usage: FoxDB:New(MyAddonDB, useProfiles): 'MyAddonDB', is required", 2) end
	if type(MyAddonDB) ~= "string"			then error("Usage: FoxDB:New(MyAddonDB, useProfiles): 'MyAddonDB', string is required", 2) end
	if useProfiles and useProfiles ~= true	then error("Usage: FoxDB:New(MyAddonDB, useProfiles): 'useProfiles', true is required or leave empty", 2) end

	-- Database initialization
	local database = _G[MyAddonDB]
	if not database then
		database = {}
		_G[MyAddonDB] = database
	end

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
							if not database.global		then database.global	= {} end
							if not database.layouts		then database.layouts	= {} end
							if not database.profiles	then database.profiles	= {} end
	if firstdatabase then	if not database.icon		then database.icon		= {} end end

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
--		["layout"]		= false,		-- known only after the launch of EditMode
--		["profile"]		= false,		-- set while New("MyAddonDB") function
	}

	-- Add properties
	db.keys				= keys
	db.keys.main		= firstdatabase
	db.keys.profiles	= useProfiles
	db.keys.dbname		= MyAddonDB
	db.keys.chat		= 0
	db.keys.locked		= true			-- An operation is in progress concerning the current layout or profile
	db.keys.editmode	= false			-- Whether EditMode is active or not

	db.keys.name		= nameKey
	db.keys.race		= raceKey
	db.keys.class		= classKey
	db.keys.faction		= factionKey
	db.keys.realm		= realmKey
	db.keys.char		= charKey
	db.keys.frealm		= frealmKey

	db.database			= database

	-- Generate the database keys for each dynamic section
	for k,v in pairs(keys) do
		if v ~= false then if not db.database[k] then db.database[k] = {} end end
		if type(v) ~= "boolean" then
			if not db.database[k][v] then db.database[k][v] = {} end
			rawset(db, k, db.database[k][v])
		end
	end

	if firstdatabase then
		firstdatabase = nil
		maindb = db
		db.icon.button = FoxDB.Icon
		for name, Function in pairs(FunctionsDB) do db[name] = Function end
	end

	-- locally add layouts functions
	for name, Function in pairs(FunctionsL) do db[name] = Function end

	-- Add profile
	database.profile = nil
	if useProfiles then

		-- locally add profiles functions
		for name, Function in pairs(FunctionsP) do db[name] = Function end

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

		-- Indicate if the profile was created to launch onNewProfile before onProfileChanged
		db.keys.newprofile = newprofile

	end

	-- Store in registry
	FoxDB.Registry[db] = true

	db.keys.locked = false

	return db
end


--▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
--										CHAT COMMAND
--▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓


--▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
----------------------------------------------------------------------------------------------------
-- Register one or several Chat Commands, receive splitted arguments
function FunctionsDB:RegisterChatCommand(cmd)
----------------------------------------------------------------------------------------------------
	if not cmd									then error("Usage: RegisterChatCommand(cmd): 'cmd', is required", 2) end
	if type(cmd) ~= "string"					then error("Usage: RegisterChatCommand(cmd): 'cmd', string is required", 2) end
	if not addon.onChatCommand					then error("Usage: RegisterChatCommand(cmd): you have not defined 'onChatCommand' function in your file", 2) end
	if type(addon.onChatCommand) ~= "function"	then error("Usage: RegisterChatCommand(cmd): 'onChatCommand' function is required", 2) end

	if self.keys.chat == 0 then

		local function ChatCommand(msg, editbox)
			msg = msg:gsub("%s*/"..cmd:lower().."%s*", "\n")
			msg = msg:gsub("[\r\n]+", "\n")
			msg = msg:gsub("[\n\n]+", "\n")
			for i,line in ipairs({split("\n", msg)}) do
				local _, _, arg1, line = find(line or "", "%s*(%S+)(.*)")
				local _, _, arg2, line = find(line or "", "%s*(%S+)(.*)")
				local _, _, arg3, line = find(line or "", "%s*(%S+)(.*)")
				local _, _, arg4 = find(line or "", "%s*(.*)")
				addon.onChatCommand(addon, cmd, arg1 or "", arg2 or "", arg3 or "", arg4 or "")
			end
		end
		SlashCmdList[self.keys.dbname] = ChatCommand

	end

	self.keys.chat = self.keys.chat+1
	_G["SLASH_"..self.keys.dbname..tostring(self.keys.chat)] = "/"..cmd:lower()
end


--▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
--										GLOBAL
--▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓


--▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
----------------------------------------------------------------------------------------------------
-- Clear the global variables.
function FunctionsDB:ResetGlobal()
----------------------------------------------------------------------------------------------------
	self.keys.locked = true

		-- Clear the current global variables
		for k,v in pairs(self.global) do self.global[k] = nil end
		if addon.onInitialize then securecall(addon.onInitialize, addon, true) end

	self.keys.locked = false
	if addon.onLayoutChanged then securecall(addon.onLayoutChanged, addon, self.keys.dbname) end
end


--▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
--										PROFILES
--▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓


--▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
---------------------------------------------------------------------------------------------------
-- Returns a table with the names of existing profiles - Current in 1st place, or not there if "nocurrent".
function FunctionsP:GetProfiles(nocurrent)
----------------------------------------------------------------------------------------------------
	local profiles = {}

	local i = 1
	if not nocurrent and self.keys.profile then
		i = 2
		profiles[1] = self.keys.profile
	end

	for profile,_ in pairs(self.database.profiles) do
		if profile ~= self.keys.profile then
			profiles[i] = profile
			i = i + 1
		end
	end

	return profiles
end
--▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
----------------------------------------------------------------------------------------------------
-- Deletes a profile, except current.
function FunctionsP:DeleteProfile(profilename)
----------------------------------------------------------------------------------------------------
	if not profilename or type(profilename) ~= "string"	then error(("DeleteProfile(profilename): 'profilename' - string expected."), 2) end
	if not self.database.profiles[profilename]			then error(("DeleteProfile error: %q does not exist."):format(profilename), 2) end
	if profilename == self.keys.profile					then error(("Current profile, Use ResetProfile() instead."), 2) end

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
	if self.keys.profiles and addon.onNewProfile then securecall(addon.onNewProfile, addon, self.keys.dbname) end

	self.keys.locked = false
	if self.keys.profiles and addon.onProfileChanged then securecall(addon.onProfileChanged, addon, self.keys.dbname) end
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
	if self.keys.profiles and addon.onProfileChanged then securecall(addon.onProfileChanged, addon, self.keys.dbname) end
end


--▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
--										LAYOUTS
--▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓


--▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
---------------------------------------------------------------------------------------------------
-- Returns a table with the names of existing layouts - current in 1st place, or not there if "nocurrent".
function FunctionsL:GetLayouts(nocurrent)
----------------------------------------------------------------------------------------------------
	local layouts = {}

	local i = 1
	if not nocurrent and self.keys.layout then
		i = 2
		layouts[1] = self.keys.layout
	end

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
-- Deletes a layout, except current.
function FunctionsL:DeleteLayout(layoutename)
----------------------------------------------------------------------------------------------------
	if not layoutename or type(layoutename) ~= "string"	then error(("DeleteLayout(layoutename): 'layoutename' - string expected."), 2) end
	if not self.database.layouts[layoutename]			then error(("DeleteLayout error: %q does not exist."):format(layoutename), 2) end
	if layoutename == self.keys.layout					then error(("Current layout, Use ResetLayout() instead."), 2) end

	-- Remove the profile
	self.database.layouts[layoutename] = nil
end
--▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
----------------------------------------------------------------------------------------------------
-- Clear the current layout.
function FunctionsL:ResetLayout()
----------------------------------------------------------------------------------------------------
	self.keys.locked = true

		-- Clear the current layout
		for k,v in pairs(self.layout) do self.layout[k] = nil end
		if addon.onNewLayout then securecall(addon.onNewLayout, addon, self.keys.dbname) end

	self.keys.locked = false
	if addon.onLayoutChanged then securecall(addon.onLayoutChanged, addon, self.keys.dbname) end
end
--▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
----------------------------------------------------------------------------------------------------
-- Replace current layout by another.
function FunctionsL:CopyLayout(from)
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
	if addon.onLayoutChanged then securecall(addon.onLayoutChanged, addon, self.keys.dbname) end
end


--▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
--										EDITMODE FRAMES
--▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓


local Overlays = {}
local CurrentIcon

--▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
----------------------------------------------------------------------------------------------------
-- Callback to know if a frame has been clicked while EditMode; all addons, not only System frames.
local function onFrameClicked(frame)
----------------------------------------------------------------------------------------------------
	if not InCombatLockdown() then
		if IconManager then IconManager:Hide() end

		for editmodeframe,enabled in pairs(FoxDB.Frames) do
			if enabled then
				editmodeframe:SetMovable(false)
				editmodeframe:ShowHighlighted()		-- Displays in white
			end
		end

		if FoxDB.Frames[frame] then
			EditModeManagerFrame:ClearSelectedSystem()
			frame:ShowSelected(true)				-- Displays in yellow
			frame:SetMovable(true)
		end
	end

	if maindb then
		if addon.onEditModeFrame then securecall(addon.onEditModeFrame, addon, frame, false) end
	end
end
--hooksecurefunc(EditModeManagerFrame, 'SelectSystem', onFrameClicked)
--▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
----------------------------------------------------------------------------------------------------
-- Callback to know if an icon has been clicked while EditMode; all addons, not only our.
local function onIconClicked(icon, closeonly)
----------------------------------------------------------------------------------------------------
	CurrentIcon = icon

	if not InCombatLockdown() then
		if IconManager then IconManager:Hide() end

		-- Close the current system menu, if it exists. Taint if InCombat.
		EditModeManagerFrame:ClearSelectedSystem()

		if closeonly then return end

		IconManager.Title:SetText(icon.label)
		IconManager.Tooltip.Button:SetChecked(icon.Tooltip())
		IconManager.Visibility.Button:SetChecked(icon.Visibility())
		IconManager.MouseOn.Slider:SetValue(icon.Alpha1())
		IconManager.MouseOut.Slider:SetValue(icon.Alpha2())
		IconManager.Offset.Slider:SetValue(icon.Offset())

		IconManager:Show()
		IconManager:SetSize(383, 239)
	end

	if maindb then
		if addon.onEditModeFrame then securecall(addon.onEditModeFrame, addon, icon, true) end
	end
end
--▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
----------------------------------------------------------------------------------------------------
function FunctionsL:RegisterSystemFrame(frame)
----------------------------------------------------------------------------------------------------
	FoxDB.Frames[frame] = true
	frame:SetScript('OnMouseDown', onFrameClicked)
	if EditModeOn then frame:Show() else frame:Hide() end
end
--▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
----------------------------------------------------------------------------------------------------
function FunctionsL:UnregisterSystemFrame(frame)
----------------------------------------------------------------------------------------------------
	FoxDB.Frames[frame] = false
	frame:SetScript('OnMouseDown', nil)
	frame:Hide()
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
local firstOverlays = true
local function onEditModeEnter()
----------------------------------------------------------------------------------------------------
	EditModeOn = true

	if not InCombatLockdown() then

		if firstOverlays then
		firstOverlays = false

			local frame = EnumerateFrames()
			while frame do
				if frame.selectedTextureKit == "editmode-actionbar-selected" then
					if not Overlays[frame] then
						Overlays[frame] = true
						if not FoxDB.Frames[frame] then
							frame:HookScript('OnMouseDown', function(self) onFrameClicked(self) end)
						end
					end
				else
					if not Overlays[frame] then
						local name = frame:GetDebugName()
						if name:match("FoxDB_Icon_") then
							Overlays[frame] = true
							if name ~= "FoxDB_Icon_"..addonname then
								frame:HookScript('OnClick', function(self, btn) if EditModeOn then securecall(onIconClicked, self, true) end end)
							end
						end
					end
				end
				frame = EnumerateFrames(frame)
			end
		end

		for editmodeframe,enabled in pairs(FoxDB.Frames) do
			if enabled then
				securecall(editmodeframe.Show, editmodeframe)
				securecall(editmodeframe.ShowHighlighted, editmodeframe)		-- Displays in white
			end
		end

		local icon = maindb and maindb.icon and maindb.icon.button
		if icon then
			icon:EnableMouseWheel(true)
			icon:SetScript("OnMouseWheel", function(self, wheel) securecall(icon.onMouseWheel, icon, wheel) end)
			icon:SetFrameStrata("DIALOG")
			icon:Show()
		end
	end

	local grid = Grid:IsControlChecked() or false
	local snap = Snap:IsControlChecked() or false
	for db in pairs(FoxDB.Registry) do
		db.keys.editmode = true
	end
	if maindb then
		if addon.onEditModeEnter then securecall(addon.onEditModeEnter, addon, grid, snap) end
	end
end
EventRegistry:RegisterCallback("EditMode.Enter", onEditModeEnter)
--▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
----------------------------------------------------------------------------------------------------
local function onEditModeGrid()
----------------------------------------------------------------------------------------------------
	local grid = Grid:IsControlChecked() or false
	if maindb then
		if addon.onEditModeGrid then securecall(addon.onEditModeGrid, addon, grid) end
	end
end
hooksecurefunc(EditModeManagerFrame.ShowGridCheckButton, "OnCheckButtonClick", onEditModeGrid)
--▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
----------------------------------------------------------------------------------------------------
local function onEditModeSnap()
----------------------------------------------------------------------------------------------------
	local snap = Snap:IsControlChecked() or false

	if maindb then
		if dbaddononEditModeGrid then securecall(addon.onEditModeSnap, addon, snap) end
	end
end
hooksecurefunc(EditModeManagerFrame.EnableSnapCheckButton, "OnCheckButtonClick", onEditModeSnap)
--▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
----------------------------------------------------------------------------------------------------
local function onEditModeExit()
----------------------------------------------------------------------------------------------------
	EditModeOn = false

	if not InCombatLockdown() then
		if IconManager then IconManager:Hide() end

		for editmodeframe,enabled in pairs(FoxDB.Frames) do
			if enabled then
				editmodeframe:Hide()
			end
		end

		local icon = maindb and maindb.icon and maindb.icon.button
		if icon then
			icon:EnableMouseWheel(false)
			icon:SetScript("OnMouseWheel", nil)
			icon:SetFrameStrata("MEDIUM")
			if icon:Visibility() == false then icon:Hide() end
		end
	end

	for db in pairs(FoxDB.Registry) do
		db.keys.editmode = false
	end
	if maindb then
		if addon.onEditModeExit then securecall(addon.onEditModeExit, addon) end
	end
end
EventRegistry:RegisterCallback("EditMode.Exit", onEditModeExit)
EventRegistry:RegisterFrameEventAndCallback("PLAYER_REGEN_DISABLED", onEditModeExit)
--▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
----------------------------------------------------------------------------------------------------
local function onLayoutSaved()
----------------------------------------------------------------------------------------------------
	local GetLayouts = GetLayouts()
	local Layouts = GetLayouts.layouts
	local LayoutIndex = GetLayouts.activeLayout
	local LayoutNumber = #Layouts + 2

	if LayoutNumber == FoxDBLayoutNumber then		-- Filter other events of onLayoutUpdated()
		local index = nil
		for i = 1, LayoutNumber - 2 do
			if Layouts[i].layoutName ~= FoxDBLayouts[i].layoutName then index = i end
		end
		if index then
			local oldname = FoxDBLayouts[index].layoutName
			local newname = Layouts[index].layoutName
			if index == FoxDBLayoutIndex - 2 then	-- If Current layout
				for db in pairs(FoxDB.Registry) do
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
				for db in pairs(FoxDB.Registry) do
					-- Remove the new layout if exists
					db.database.layouts[newname] = nil

					-- Copy the old named layout to new destination
					rawset(db.database.layouts, newname, db.database.layouts[oldname])

					-- Remove the old layout
					db.database.layouts[oldname] = nil
				end
			end
			FoxDBLayouts = Layouts
			for db in pairs(FoxDB.Registry) do
				if addon.onLayoutRenamed then securecall(addon.onLayoutRenamed, addon, db.keys.dbname) end
			end
		else
			for db in pairs(FoxDB.Registry) do
				if addon.onLayoutSaved then securecall(addon.onLayoutSaved, addon, db.keys.dbname) end
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

	if FoxDBLayoutName == nil then					-- Loading the layout while edit mode initialization
		if LayoutName then
			for db in pairs(FoxDB.Registry) do
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
					if created then if addon.onNewLayout then securecall(addon.onNewLayout, addon, db.keys.dbname) end end

				db.keys.locked = false

				if db.keys.newprofile then
					if db.onNewProfile and db.keys.profiles and addon.onNewProfile then securecall(addon.onNewProfile, addon, db.keys.dbname) end
					db.keys.newprofile = false
				end
				if db.keys.profiles and	addon.onProfileChanged	then securecall(addon.onProfileChanged, addon, db.keys.dbname)	end
				if						addon.onLayoutLoaded	then securecall(addon.onLayoutLoaded, addon, db.keys.dbname)	end
			end
			FoxDBLayoutName = LayoutName
		end
	elseif LayoutNumber > FoxDBLayoutNumber then	-- Adding a layout swap automatically to it
		for db in pairs(FoxDB.Registry) do
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
			if addon.onLayoutChanged then securecall(addon.onLayoutChanged, addon, db.keys.dbname) end
		end
	elseif LayoutNumber < FoxDBLayoutNumber then	-- Romoving a layout swap automatically to a preset if we were on that layout, else we stay on actual layout
		if LayoutNumber == 2 then					-- If the layout was the last non preset layout
			for db in pairs(FoxDB.Registry) do
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
				if addon.onLayoutChanged then securecall(addon.onLayoutChanged, addon, db.keys.dbname) end
			end
		else	
			local nameold = nil
			local Layoutfound = false
			for index = 3, LayoutNumber do			-- Else if not latest non preset layout
				if not Layoutfound then
					nameold = FoxDBLayouts[index - 2].layoutName
					local namenew = Layouts[index - 2].layoutName

					if nameold ~= namenew then
						Layoutfound = true
					end
				end
			end
			if not Layoutfound then					-- Else if the latest non preset layout
				nameold = FoxDBLayouts[FoxDBLayoutNumber - 2].layoutName
			end
			for db in pairs(FoxDB.Registry) do
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
				if db.onLayoutChanged then securecall(db.onLayoutChanged) end
			end
		end
	else
		for db in pairs(FoxDB.Registry) do
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
			if addon.onLayoutChanged then securecall(addon.onLayoutChanged, addon, db.keys.dbname) end
		end
	end

	FoxDBLayouts = Layouts
	FoxDBLayoutIndex = LayoutIndex
	FoxDBLayoutName = LayoutName
	FoxDBLayoutNumber = LayoutNumber
end
EventRegistry:RegisterFrameEventAndCallback("EDIT_MODE_LAYOUTS_UPDATED", onLayoutUpdated, FoxDB)
--▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
----------------------------------------------------------------------------------------------------
local function onPlayerLogout()
----------------------------------------------------------------------------------------------------
	for db in pairs(FoxDB.Registry) do
		if addon.onPlayerLogout then securecall(addon.onPlayerLogout, addon, db.keys.dbname) end
		for _,v in pairs(db) do
			if type(v) == "table" and v ~= db.profile and v ~= db.layout then clearTable(v) end
		end
	end
end
EventRegistry:RegisterFrameEventAndCallback("PLAYER_LOGOUT", onPlayerLogout, FoxDB)


--▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
--										ICONS
--▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓


--▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
----------------------------------------------------------------------------------------------------
-- Populate the table with all FoxDB minimap icons.
local GetAllIconsfirst = true
local function GetAllIcons()
----------------------------------------------------------------------------------------------------
	GetAllIconsfirst = nil

	local frame = EnumerateFrames()
	while frame do
		local name = frame:GetDebugName()
		if name:match("FoxDB_Icon_") then
			insert(FoxDB.Icons, frame)
		end
		frame = EnumerateFrames(frame)
	end
end
--▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
----------------------------------------------------------------------------------------------------
-- Returns the table with all FoxDB minimap icons.
function FunctionsDB:GetIcons()
----------------------------------------------------------------------------------------------------
	if GetAllIconsfirst then GetAllIcons() end

	return FoxDB.Icons
end
--▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
----------------------------------------------------------------------------------------------------
-- Sends the next icon from current icon.
function FunctionsDB:GetNextIcon()
----------------------------------------------------------------------------------------------------
	if GetAllIconsfirst then GetAllIcons() end
	if not EditModeOn then return end

	local nicons = #FoxDB.Icons
	if nicons < 2 then return end

	if FoxDB.Icons[nicons] == CurrentIcon then
		securecall(onIconClicked, FoxDB.Icons[1])
	else
		local found
		for i=1,nicons do
			local icon = FoxDB.Icons[i]
			if found then
				securecall(onIconClicked, icon)
			elseif icon == CurrentIcon then
				found = true
			end
		end
	end
end
--▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
----------------------------------------------------------------------------------------------------
function FunctionsDB:IconSquare(isSquare)
----------------------------------------------------------------------------------------------------
	if GetAllIconsfirst then GetAllIcons() end

	for _,icon in next, FoxDB.Icons do
		securecallfunction(icon.Square, isSquare)
	end
end
--▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
----------------------------------------------------------------------------------------------------
function FunctionsDB:IconStart()
----------------------------------------------------------------------------------------------------
	local IconName = "FoxDB_Icon_"..addonname
	local icon = self.icon
	icon.label = icon.label or addonname

	-- Errors
	if not icon.file then error("Can't start icon without icon object, use self.db.icon.file =") end

	-- Variables
	if type(icon.tooltip)	~= "boolean"	then icon.tooltip	= true					end
	if type(icon.visible)	~= "boolean"	then icon.visible	= true					end
	if type(icon.alpha1)	~= "number"		then icon.alpha1	= 0.8					end
	if type(icon.alpha2)	~= "number"		then icon.alpha2	= min(0.6, icon.alpha1)	end
	if type(icon.scale)		~= "number"		then icon.scale		= 0.9					end
	if type(icon.square)	~= "boolean"	then icon.square	= false					end
	if type(icon.angle)		~= "number"		then icon.angle		= rand(-pi, pi)			end
	if type(icon.offset)	~= "number"		then icon.offset	= 0						end
	if type(icon.line1)		~= "string"		then icon.line1		= ""					end
	if type(icon.line2)		~= "string"		then icon.line2		= ""					end
	if type(icon.line3)		~= "string"		then icon.line3		= ""					end

	-- Button
	local button = FoxDB.Icon or CreateFrame("Button", IconName, UIParent)
	button.label = icon.label
	button:SetSize(30, 30)
	button:SetFrameStrata("MEDIUM")
	button:SetFixedFrameStrata(false)
	button:SetFrameLevel(1002)
	button:SetFixedFrameLevel(true)
	-- Icon
	button.texture = button.icon or button:CreateTexture(IconName.."_icon", "BACKGROUND")
	button.texture:SetSize(25, 25)
	button.texture:SetPoint("CENTER", 0.34, 0)
	button.texture:SetTexture(icon.file)
	button.texture:SetMask("Interface\\Masks\\CircleMaskScalable")
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
	button.Tooltip = function(tooltip) if type(tooltip) ~= "boolean" then return icon.tooltip else icon.tooltip = tooltip end end
	button.onIconEnter = function(btn)
		if not btn then return end
		btn:SetAlpha(icon.alpha1)
		if GameTooltip and (icon.tooltip or EditModeOn) then
			GameTooltip:ClearLines()
			GameTooltip:SetOwner(button, "ANCHOR_RIGHT")
			GameTooltip:AddLine(icon.label, 0, 1, 0)
			if EditModeOn then
				GameTooltip:AddDoubleLine("|cff69ccf0Scale:|r",	("|cffffffff%s|r"):format(icon.scale))
				if icon.visible == false then
					GameTooltip:AddLine(L"Icon is not visible", 1, 1, 1)
				end
			end
			if icon.tooltip then
				local line1 = type(icon.line1) == "string" and icon.line1 ~= ""
				local line2 = type(icon.line2) == "string" and icon.line2 ~= ""
				local line3 = type(icon.line3) == "string" and icon.line3 ~= ""
				if not (line1 or line2 or line3) then return end
				if line1 then GameTooltip:AddDoubleLine("|cff69ccf0Left:|r", 	("|cffffffff%s|r"):format(icon.line1)) end
				if line2 then GameTooltip:AddDoubleLine("|cff69ccf0Middle:|r",	("|cffffffff%s|r"):format(icon.line2)) end
				if line3 then GameTooltip:AddDoubleLine("|cff69ccf0Right:|r",	("|cffffffff%s|r"):format(icon.line3)) end
			else
				GameTooltip:AddLine(L"Tooltip deactivated", 1, 1, 1)
			end
			GameTooltip:Show()
		end
	end
	button.onIconLeave = function(btn)
		if not btn then return end
		btn:SetAlpha(icon.alpha2)
		if (icon.tooltip or EditModeOn == true) and GameTooltip then if GameTooltip then GameTooltip:Hide() end end
	end
	button:SetScript("OnEnter", function(btn) securecall(button.onIconEnter, btn) end)
	button:SetScript("OnLeave", function(btn) securecall(button.onIconLeave, btn) end)

	-- Visibility
	button.Visibility = function(visible)
			if visible ~= "_" then if type(visible) ~= "boolean" then return icon.visible else icon.visible = visible end end
			if addon.onIconVisibility then securecall(addon.onIconVisibility, addon, icon.visible) end
			if EditModeOn then return end
			if icon.visible then
				button:Show()
				securecall(button.Minimap)
			else
				button:Hide()
			end
		end

	-- Transparency
	button.Alpha1 = function(alpha1)
			if alpha1 ~= "_" then if type(alpha1) ~= "number" then return icon.alpha1 else icon.alpha1 = min(max(alpha1, 0.2), 1) end end
			icon.alpha2 = min(max(icon.alpha2, 0), icon.alpha1)
			button:SetAlpha(icon.alpha1)
		end
	button.Alpha2 = function(alpha2)
			if alpha2 ~= "_" then if type(alpha2) ~= "number" then return icon.alpha2 else icon.alpha2 = min(max(alpha2, 0), 1) end end
			icon.alpha1 = min(max(icon.alpha1, icon.alpha2), 1)
			button:SetAlpha(icon.alpha2)
		end

	-- Scale
	button.Scale = function(scale)
			if scale ~= "_" then if type(scale) ~= "number" then return icon.scale else icon.scale = min(max(scale, 0.8), 3) end end
			button:ClearAllPoints()
			button:SetScale(icon.scale*MinimapCluster:GetScale()*Minimap:GetScale())
			securecall(button.Minimap)
		end

	-- Position
	button:SetDontSavePosition(true)
	button:SetClampedToScreen(true)
	button:SetMovable(true)
	button:RegisterForDrag("LeftButton")
	button.Minimap = function()
			if not Minimap then button:ClearAllPoints() button:Hide() end
			icon.angle = min(max(icon.angle, -pi), pi)
			local w = Minimap:GetWidth()/2	+ icon.offset
			local h = Minimap:GetHeight()/2	+ icon.offset
			local x = cos(icon.angle)*w
			local y = sin(icon.angle)*h
			if icon.square then
				x = max(-w, min(sqrt(2)*x, w))
				y = max(-h, min(sqrt(2)*y, h))
			end
			button:ClearAllPoints()
			local scale = button:GetEffectiveScale()
			button:SetPoint("CENTER", Minimap, "CENTER", x/icon.scale, y/icon.scale)
		end
	button.Square = function(square)
			if square ~= "_" then if type(square) ~= "boolean" then return icon.square
				else
					icon.square = square
					securecall(button.Scale, "_")
					return
				end
			end
			securecall(button.Minimap)
		end
	button.Offset = function(offset)
			if offset ~= "_" then if type(offset) ~= "number" then return icon.offset else icon.offset = min(max(offset, -35), 35) end end
			securecall(button.Minimap)
		end
	button.onReceiveDrag = function(btn)
		local x, y = GetCursorPosition()
		if Minimap then
			local scale = Minimap:GetEffectiveScale()
			local z, t = Minimap:GetCenter()
			z, t = z*scale, t*scale
			icon.angle = atan2(y-t, x-z)
			securecall(button.Minimap)
		end
	end
	button.onDragStart = function(btn)
			if icon.tooltip then if GameTooltip then GameTooltip:Hide() end end
			if EditModeOn then securecall(onIconClicked, button, true) end
			button:SetScript("OnUpdate", function(self) if self.onReceiveDrag then securecall(self.onReceiveDrag, button) end end)
			button:StartMoving()
		end
	button.onDragStop = function(btn)
			button:StopMovingOrSizing()
			button:SetScript("OnUpdate", nil)
		end
	button.onEditModeEnter = function(btn)
			button:SetScript("OnDragStart", function(self) if self.onDragStart then securecall(self.onDragStart, button) end end)
			button:SetScript("OnDragStop", function(self) if self.onDragStop then securecall(self.onDragStop, button) end end)
		end
	button.onEditModeExit = function(btn)
			button:SetScript("OnDragStart", nil)
			button:SetScript("OnDragStop", nil)
		end
	EventRegistry:RegisterCallback("EditMode.Enter", button.onEditModeEnter, button)
	EventRegistry:RegisterCallback("EditMode.Exit", button.onEditModeExit, button)

	-- Mouse
	button:RegisterForClicks("anyUp")
	button:SetScript("OnClick", function(self, btn)
			if EditModeOn														then securecall(onIconClicked, button)
			else
				if		btn == "LeftButton"		then if addon.onIconLeftClick	then securecall(addon.onIconLeftClick,		addon) end
				elseif	btn == "RightButton"	then if addon.onIconRightClick	then securecall(addon.onIconRightClick,		addon) end
				elseif	btn == "MiddleButton"	then if addon.onIconMiddleClick	then securecall(addon.onIconMiddleClick,	addon) end
				end
			end
		end)
	button.onMouseWheel = function(btn, wheel)
			securecall(button.Scale, icon.scale+wheel*0.05)
			securecall(button.onIconEnter, button)
		end

	-- Initialization
	button.onInit = function()
			EventRegistry:UnregisterFrameEventAndCallback("PLAYER_LOGIN", button)
			securecall(button.Visibility, "_")
			securecall(button.Alpha2, "_")
			securecall(button.Scale, "_")
			securecall(button.Offset, "_")
			securecall(button.Minimap)
			Minimap:HookScript("OnSizeChanged",			function(mm, w, h)	securecall(button.Scale, "_")		end)
			MinimapCluster:HookScript("OnSizeChanged",	function(cl, w, h)	securecall(button.Scale, "_")		end)
			MinimapBackdrop:HookScript("OnHide",		function(bd)		securecall(button.Hide, button)		end)
			MinimapBackdrop:HookScript("OnShow",		function(bd)		securecall(button.Visibility, "_")	end)
		end
	EventRegistry:RegisterFrameEventAndCallback("PLAYER_LOGIN", function() button:onInit() end, button)

	FoxDB.Icon = button
end


--▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
--										ICON MANAGER
--▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓


--▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
----------------------------------------------------------------------------------------------------
local IconManagerInitialized
local function IconManagerInit()
----------------------------------------------------------------------------------------------------
	if IconManagerInitialized then return else IconManagerInitialized = true end
	EventRegistry:UnregisterFrameEventAndCallback("PLAYER_LOGIN", IconManager)

	IconManager:SetSize(383, 239)
	IconManager:SetFrameStrata("DIALOG")
	IconManager:SetFrameLevel(200)
	IconManager.heightPadding = 39
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
	IconManager.Visibility.Button:SetScript("OnClick", function(self, event, ...) securecall(CurrentIcon.Visibility, self:GetChecked()) end)
	IconManager.Visibility:Show()

	IconManager.Tooltip = IconManager.Tooltip or CreateFrame("Frame", nil, IconManager, "EditModeSettingCheckboxTemplate")
	IconManager.Tooltip.Label:SetWidth(165)
	IconManager.Tooltip.Label:SetText(L"Tooltip")
	IconManager.Tooltip:SetPoint("TOPLEFT", IconManager.Visibility, "TOPRIGHT", 0, 0)
	IconManager.Tooltip.Button:SetScript("OnClick", function(self, event, ...) securecall(CurrentIcon.Tooltip, self:GetChecked()) end)
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
					securecall(CurrentIcon.Alpha1, value)
					IconManager.MouseOut.Slider:SetValue(CurrentIcon.Alpha2())
					return ("%d%%"):format(value*100)
				end
			end)
	IconManager.MouseOn.Slider:Init(-1, 0.2, 1, 80, IconManager.MouseOn.formatters)
	IconManager.MouseOn.Slider.Slider:SetScript("OnMouseUp", function(self)
			if not InCombatLockdown() then securecall(CurrentIcon.Alpha2, "_") end
		end)
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
					securecall(CurrentIcon.Alpha2, value)
					IconManager.MouseOn.Slider:SetValue(CurrentIcon.Alpha1())
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
				if value ~= -1 then securecall(CurrentIcon.Offset, value) return value end
			end)
	IconManager.Offset.Slider:Init(-1, -35, 35, 70, IconManager.Offset.formatters)
	IconManager.Offset:Show()

	IconManager.Divider = IconManager.Divider2 or CreateFrame("Frame", nil, IconManager)
	IconManager.Divider:SetSize(330,16)
	IconManager.Divider:SetPoint("TOPLEFT", IconManager.Offset, "BOTTOMLEFT", 0, 3)
	IconManager.Divider.divider = IconManager.Divider:CreateTexture(nil, "ARTWORK")
	IconManager.Divider.divider:SetTexture("Interface\\FriendsFrame\\UI-FriendsFrame-OnlineDivider") --389194
	IconManager.Divider.divider:SetSize(330,16)
	IconManager.Divider.divider:SetPoint("TOPLEFT")
	IconManager.Divider:Show()

	IconManager.Next = IconManager.Next or CreateFrame("Button", nil, IconManager, "EditModeSystemSettingsDialogButtonTemplate")
	IconManager.Next:SetWidth(330)
	IconManager.Next:SetText(L"Next minimap icon")
	IconManager.Next:SetPoint("TOPLEFT", IconManager.Divider, "BOTTOMLEFT", -1, -2)	-- 0, -12 after divider if CheckBox
	IconManager.Next:SetOnClickHandler(function() securecallfunction(FunctionsDB.GetNextIcon, FoxDB) end)
	IconManager.Next:Show()
end
EventRegistry:RegisterFrameEventAndCallback("PLAYER_LOGIN", IconManagerInit, IconManager)
