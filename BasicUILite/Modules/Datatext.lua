local _, BasicUILite = ...
local cfg = BasicUILite.DATATEXT

if cfg.enable ~= true then return end

------------------------------------------------------------------------
-- Variables that point to frames or other objects:
------------------------------------------------------------------------
local DataP1, DataP2, DataP3, DataBGP
local currentFightDPS
local _, class = UnitClass("player")
local ccolor = (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS)[class]
local _G = _G
--local datapanel = CreateFrame("Frame")
------------------------------------------------------------------------
--	 Datatext Functions
------------------------------------------------------------------------


if DataP1 then return end -- already done

-- Create All Panels
------------------------------------------------------------------------
DataP1 = CreateFrame("Frame", "DataP1", UIParent)
DataP2 = CreateFrame("Frame", "DataP2", UIParent)
DataP3 = CreateFrame("Frame", "DataP3", UIParent)
DataBGP = CreateFrame("Frame", "DataBGP", UIParent)


-- Multi Panel Settings
------------------------------------------------------------------------
for _, panelz in pairs({
	DataP1,
	DataP2,
	DataP3,
	DataBGP,
}) do
	panelz:SetHeight(30)
	panelz:SetFrameStrata("LOW")	
	panelz:SetFrameLevel(1)
end


-- Stat Panel 1 Settings
------------------------------------------------------------------------
DataP1:SetPoint("BOTTOM", DataP2, "TOP", 0, 0)
DataP1:SetWidth(1300 / 3)
DataP1:SetBackdrop({ 
	bgFile = [[Interface\DialogFrame\UI-DialogBox-Background-Dark]], 
})
DataP1:SetBackdropColor(0, 0, 0, 0.60)
DataP1:RegisterEvent("PLAYER_ENTERING_WORLD")
DataP1:SetScript("OnEvent", function(self, event, ...)
	if event == 'PLAYER_ENTERING_WORLD' then
		local inInstance, instanceType = IsInInstance()
		if inInstance and (instanceType == 'pvp') then			
			self:Hide()
		else
			self:Show()
		end
	end
end)	

-- Stat Panel 2 Settings
-----------------------------------------------------------------------
DataP2:SetPoint("BOTTOM", DataP3, "TOP", 0, 0)
DataP2:SetWidth(1300 / 3)
DataP2:SetBackdrop({ 
	bgFile = [[Interface\DialogFrame\UI-DialogBox-Background-Dark]], 
})
DataP2:SetBackdropColor(0, 0, 0, 0.60)

-- Stat Panel 3 Settings
-----------------------------------------------------------------------
DataP3:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", 15, 5)
DataP3:SetWidth(1300 / 3)
DataP3:SetBackdrop({ 
	bgFile = [[Interface\DialogFrame\UI-DialogBox-Background-Dark]], 
})
DataP3:SetBackdropColor(0, 0, 0, 0.60)

-- Battleground Stat Panel Settings
-----------------------------------------------------------------------
DataBGP:SetAllPoints(DataP1)
DataBGP:SetBackdrop({ 
	bgFile = [[Interface\DialogFrame\UI-DialogBox-Background-Dark]], 
})
DataBGP:SetBackdropColor(0, 0, 0, 0.60)


local function SetBattlegroundPanel()


end

local function PlacePlugin(position, plugin)
	local left = DataP1
	local center = DataP2
	local right = DataP3

	-- Left Panel Data
	if position == 1 then
		plugin:SetParent(left)
		plugin:SetHeight(left:GetHeight())
		plugin:SetPoint('LEFT', left, 30, 0)
		plugin:SetPoint('TOP', left)
		plugin:SetPoint('BOTTOM', left)
	elseif position == 2 then
		plugin:SetParent(left)
		plugin:SetHeight(left:GetHeight())
		plugin:SetPoint('TOP', left)
		plugin:SetPoint('BOTTOM', left)
	elseif position == 3 then
		plugin:SetParent(left)
		plugin:SetHeight(left:GetHeight())
		plugin:SetPoint('RIGHT', left, -30, 0)
		plugin:SetPoint('TOP', left)
		plugin:SetPoint('BOTTOM', left)

	-- Center Panel Data
	elseif position == 4 then
		plugin:SetParent(center)
		plugin:SetHeight(center:GetHeight())
		plugin:SetPoint('LEFT', center, 30, 0)
		plugin:SetPoint('TOP', center)
		plugin:SetPoint('BOTTOM', center)
	elseif position == 5 then
		plugin:SetParent(center)
		plugin:SetHeight(center:GetHeight())
		plugin:SetPoint('TOP', center)
		plugin:SetPoint('BOTTOM', center)
	elseif position == 6 then
		plugin:SetParent(center)
		plugin:SetHeight(center:GetHeight())
		plugin:SetPoint('RIGHT', center, -30, 0)
		plugin:SetPoint('TOP', center)
		plugin:SetPoint('BOTTOM', center)

	-- Right Panel Data
	elseif position == 7 then
		plugin:SetParent(right)
		plugin:SetHeight(right:GetHeight())
		plugin:SetPoint('LEFT', right, 30, 0)
		plugin:SetPoint('TOP', right)
		plugin:SetPoint('BOTTOM', right)
	elseif position == 8 then
		plugin:SetParent(right)
		plugin:SetHeight(right:GetHeight())
		plugin:SetPoint('TOP', right)
		plugin:SetPoint('BOTTOM', right)
	elseif position == 9 then
		plugin:SetParent(right)
		plugin:SetHeight(right:GetHeight())
		plugin:SetPoint('RIGHT', right, -30, 0)
		plugin:SetPoint('TOP', right)
		plugin:SetPoint('BOTTOM', right)
	elseif position == 0 then
		return
	end
end

local function DataTextTooltipAnchor(self)
	local panel = self:GetParent()
	local anchor = 'GameTooltip'
	local xoff = 1
	local yoff = 3
	
	
	for _, panel in pairs ({
		DataP1,
		DataP2,
		DataP3,
	})	do
		anchor = 'ANCHOR_TOP'
	end	
	return anchor, panel, xoff, yoff
end

-- the Following Code was provided by Vrul from WoWInterface
----------------------------------------------------------------------------
--[[Check Player's Role

local playerRole, isCaster
local function CheckRole()
    local specIndex = GetSpecialization()
    if specIndex then
        local _, priStat
        _, _, _, _, _, playerRole, priStat = GetSpecializationInfo(specIndex)
        isCaster = priStat == 4
    else
        playerRole = nil
    end
end

local eventHandler = CreateFrame("Frame")
eventHandler:RegisterEvent("PLAYER_ENTERING_WORLD")
eventHandler:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
eventHandler:RegisterEvent("PLAYER_TALENT_UPDATE")
eventHandler:RegisterEvent("CHARACTER_POINTS_CHANGED")
eventHandler:SetScript("OnEvent", CheckRole)]]
---------------------------------------------------------------------------

--Check Player's Role

local classRoles = {

	DEATHKNIGHT = {
		[1] = "TANK", 		-- 250 - Blood - (TANK) 
		[2] = "DAMAGER", 	-- 251 - Frost - (MELEE_DPS)
		[3] = "DAMAGER", 	-- 252 - Unholy - (MELEE_DPS)
	},
	DEMONHUNTER = {
		[1] = "DAMAGER", 	-- 577 - Havoc - (MELEE_DPS)
		[2] = "TANK", 		-- 581 - Vengeance - (TANK)
	},
	DRUID = { 
		[1] = "CASTER", 	-- 102 - Balance - (CASTER_DPS)
		[2] = "DAMAGER",  	-- 103 - Feral - (MELEE_DPS)
		[3] = "TANK",  		-- 104 Guardian - (TANK)
		[4] = "HEALER", 	-- 105 Restoration - (HEALER)
	},
	HUNTER = {
		[1] = "DAMAGER", 	-- 253 - Beast Mastery - (RANGED_DPS)
		[2] = "DAMAGER", 	-- 254 - Marksmanship - (RANGED_DPS)
		[3] = "DAMAGER", 	-- 255 - Survival - (RANGED_DPS)
	},
	MAGE = { 
		[1] = "CASTER",	 	-- 62 - Arcane - (CASTER_DPS)
		[2] = "CASTER", 	-- 63 - Fire - (CASTER_DPS)
		[3] = "CASTER", 	-- 64 - Frost - (CASTER_DPS)
	}, 
	MONK = {
		[1] = "TANK", 		-- 268 - Brewmaster - (TANK)
		[2] = "DAMAGER", 	-- 269 - Windwalker - (MELEE_DPS)
		[3] = "HEALER", 	-- 270 - Mistweaver - (HEALER)
	}, 
	PALADIN = {
		[1] = "HEALER", 	-- 65 - Holy - (HEALER)
		[2] = "TANK", 		-- 66 - Protection - (TANK)
		[3] = "DAMAGER",	-- 70 - Retribution - (MELEE_DPS)
	},
	PRIEST = { 
		[1] = "HEALER", 	-- 256 - Discipline - (HEALER}
		[2] = "HEALER", 	-- 257 - Holy - (HEALER)
		[3] = "CASTER", 	-- 258 - Shadow - (CASTER_DPS)
	},
	ROGUE = {
		[1] = "DAMAGER",	-- 259 - Assassination - (MELEE_DPS)
		[2] = "DAMAGER",	-- 260 - Combat - (MELEE_DPS)
		[3] = "DAMAGER",	-- 261 - Subtlety - (MELEE_DPS)
	}, 
	SHAMAN = { 
		[1] = "CASTER",		-- 262 - Elemental - (CASTER_DPS)
		[2] = "DAMAGER",  	-- 263 - Enhancement - (MELEE_DPS)
		[3] = "HEALER", 	-- 264 - Restoration - (HEALER)
	},
	WARLOCK = { 
		[1] = "CASTER", 	-- 265 - Affliction - (CASTER_DPS)
		[2] = "CASTER", 	-- 266 - Demonology - (CASTER_DPS)
		[3] = "CASTER", 	-- 267 - Destruction - (CASTER_DPS)
	}, 
	WARRIOR = {
		[1] = "DAMAGER", 	-- 71 - Arms - (MELEE_DPS)
		[2] = "DAMAGER", 	-- 72 - Furry - (MELEE_DPS)
		[3] = "TANK", 		-- 73 - Protection - (TANK)
	},
}

local _, playerClass = UnitClass("player")
local playerRole
local function CheckRole()
	local talentTree = GetSpecialization()

	if(type(classRoles[playerClass]) == "string") then
		playerRole = classRoles[playerClass]
	elseif(talentTree) then
		playerRole = classRoles[playerClass][talentTree]
	end
end

local eventHandler = CreateFrame("Frame")
eventHandler:RegisterEvent("PLAYER_ENTERING_WORLD")
eventHandler:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
eventHandler:RegisterEvent("PLAYER_TALENT_UPDATE")
eventHandler:RegisterEvent("CHARACTER_POINTS_CHANGED")
eventHandler:SetScript("OnEvent", CheckRole)


-- This can be simplified hugely by using a table, instead of a bunch of if/end blocks.
local pluginConstructors = {}

local plugins = {}
for name, constructor in pairs(pluginConstructors) do
	local position = cfg[name]
	if position then
		local plugin = constructor()
		plugins[name] = plugin
		PlacePlugin(position, plugin)
	end
end

local playerName = UnitName("player")
	
if cfg.classcolor ~= true then
	local r, g, b = cfg.customcolor.r, cfg.customcolor.g, cfg.customcolor.b
	hexa = ("|cff%.2x%.2x%.2x"):format(r * 255, g * 255, b * 255)
	hexb = "|r"
else
	hexa = ("|cff%.2x%.2x%.2x"):format(ccolor.r * 255, ccolor.g * 255, ccolor.b * 255)
	hexb = "|r"
end

local function SetFontString(parent, file, size, flags)
	local fs = parent:CreateFontString(nil, "OVERLAY")
	fs:SetFont(file, size, flags)
	return fs
end


------------------------------------------------------------------------
--	 Battleground Plugin Functions
------------------------------------------------------------------------
if cfg.bg_pvp then

	--WoW API / Variables
	local GetNumBattlefieldScores = GetNumBattlefieldScores
	local GetBattlefieldScore = GetBattlefieldScore
	local GetCurrentMapAreaID = GetCurrentMapAreaID
	local GetBattlefieldStatInfo = GetBattlefieldStatInfo
	local GetBattlefieldStatData = GetBattlefieldStatData
	
	--Map IDs
	local WSG = 443
	local TP = 626
	local AV = 401
	local SOTA = 512
	local IOC = 540
	local EOTS = 482
	local TBFG = 736
	local AB = 461
	local TOK = 856
	local SSM = 860
	local DG = 935

	DataBGP:SetScript('OnEnter', function(self)
		
		local CurrentMapID = GetCurrentMapAreaID()
		for index=1, GetNumBattlefieldScores() do
			name = GetBattlefieldScore(index)
			if name then
				GameTooltip:SetOwner(self, 'ANCHOR_TOPLEFT', 0, 4)
				GameTooltip:ClearLines()
				GameTooltip:SetPoint('BOTTOM', self, 'TOP', 0, 1)
				GameTooltip:ClearLines()
				GameTooltip:AddLine("Stats for : "..hexa..name..hexb)
				GameTooltip:AddLine(" ")

				--Add extra statistics to watch based on what BG you are in.
				if CurrentMapID == WSG or CurrentMapID == TP then
					GameTooltip:AddDoubleLine(GetBattlefieldStatInfo(1), GetBattlefieldStatData(index, 1),1,1,1)
					GameTooltip:AddDoubleLine(GetBattlefieldStatInfo(2), GetBattlefieldStatData(index, 2),1,1,1)
				elseif CurrentMapID == EOTS then
					GameTooltip:AddDoubleLine(GetBattlefieldStatInfo(1), GetBattlefieldStatData(index, 1),1,1,1)
				elseif CurrentMapID == AV then
					GameTooltip:AddDoubleLine(GetBattlefieldStatInfo(1), GetBattlefieldStatData(index, 1),1,1,1)
					GameTooltip:AddDoubleLine(GetBattlefieldStatInfo(2), GetBattlefieldStatData(index, 2),1,1,1)
					GameTooltip:AddDoubleLine(GetBattlefieldStatInfo(3), GetBattlefieldStatData(index, 3),1,1,1)
					GameTooltip:AddDoubleLine(GetBattlefieldStatInfo(4), GetBattlefieldStatData(index, 4),1,1,1)
				elseif CurrentMapID == SOTA then
					GameTooltip:AddDoubleLine(GetBattlefieldStatInfo(1), GetBattlefieldStatData(index, 1),1,1,1)
					GameTooltip:AddDoubleLine(GetBattlefieldStatInfo(2), GetBattlefieldStatData(index, 2),1,1,1)
				elseif CurrentMapID == IOC or CurrentMapID == TBFG or CurrentMapID == AB then
					GameTooltip:AddDoubleLine(GetBattlefieldStatInfo(1), GetBattlefieldStatData(index, 1),1,1,1)
					GameTooltip:AddDoubleLine(GetBattlefieldStatInfo(2), GetBattlefieldStatData(index, 2),1,1,1)
				elseif CurrentMapID == TOK then
					GameTooltip:AddDoubleLine(GetBattlefieldStatInfo(1), GetBattlefieldStatData(index, 1),1,1,1)
					GameTooltip:AddDoubleLine(GetBattlefieldStatInfo(2), GetBattlefieldStatData(index, 2),1,1,1)
				elseif CurrentMapID == SSM then
					GameTooltip:AddDoubleLine(GetBattlefieldStatInfo(1), GetBattlefieldStatData(index, 1),1,1,1)
				elseif CurrentMapID == DG then
					GameTooltip:AddDoubleLine(GetBattlefieldStatInfo(1), GetBattlefieldStatData(index, 1),1,1,1)
					GameTooltip:AddDoubleLine(GetBattlefieldStatInfo(2), GetBattlefieldStatData(index, 2),1,1,1)
					GameTooltip:AddDoubleLine(GetBattlefieldStatInfo(3), GetBattlefieldStatData(index, 3),1,1,1)
					GameTooltip:AddDoubleLine(GetBattlefieldStatInfo(4), GetBattlefieldStatData(index, 4),1,1,1)
				end
				break
			end
		end		
	end) 
	DataBGP:SetScript('OnLeave', function(self) GameTooltip:Hide() end)

	local f = CreateFrame('Frame', nil)
	f:EnableMouse(true)

	local Text1  = DataBGP:CreateFontString(nil, 'OVERLAY')
	Text1:SetFont(cfg.font, cfg.fontSize)
	Text1:SetPoint('LEFT', DataBGP, 30, 0)
	Text1:SetHeight(DataP1:GetHeight())

	local Text2  = DataBGP:CreateFontString(nil, 'OVERLAY')
	Text2:SetFont(cfg.font, cfg.fontSize)
	Text2:SetPoint('CENTER', DataBGP, 0, 0)
	Text2:SetHeight(DataP1:GetHeight())

	local Text3  = DataBGP:CreateFontString(nil, 'OVERLAY')
	Text3:SetFont(cfg.font, cfg.fontSize)
	Text3:SetPoint('RIGHT', DataBGP, -30, 0)
	Text3:SetHeight(DataP1:GetHeight())

	local int = 2
	local function Update(self, t)
		int = int - t
		if int < 0 then
			local dmgtxt
			RequestBattlefieldScoreData()
			local numScores = GetNumBattlefieldScores()
			for i=1, numScores do
				local name, killingBlows, honorableKills, deaths, honorGained, faction, race, class, classToken, damageDone, healingDone, bgRating, ratingChange = GetBattlefieldScore(i)
				if healingDone > damageDone then
					dmgtxt = (hexa.."Healing : "..hexb..healingDone)
				else
					dmgtxt = (hexa.."Damage : "..hexb..damageDone)
				end
				if ( name ) then
					if ( name == playerName ) then
						Text2:SetText(hexa.."Honor : "..hexb..format('%d', honorGained))
						Text1:SetText(dmgtxt)
						Text3:SetText(hexa.."Killing Blows : "..hexb..killingBlows)
					end   
				end
			end 
			int  = 0
		end
	end

	--hide text when not in an bg
	local function OnEvent(self, event)
		if event == 'PLAYER_ENTERING_WORLD' then
			local inInstance, instanceType = IsInInstance()
			if inInstance and (instanceType == 'pvp') then			
				DataBGP:Show()
			else
				Text1:SetText('')
				Text2:SetText('')
				Text3:SetText('')
				DataBGP:Hide()
			end
		end
	end

	f:RegisterEvent('PLAYER_ENTERING_WORLD')
	f:SetScript('OnEvent', OnEvent)
	f:SetScript('OnUpdate', Update)
	Update(f, 10)
end

------------------------------------------------------------------------
--	 Bags Plugin Functions
------------------------------------------------------------------------
if cfg.bags and cfg.bags > 0 then
	
	local plugin = CreateFrame('Frame', nil, Datapanel)
	plugin:EnableMouse(true)
	plugin:SetFrameStrata('BACKGROUND')
	plugin:SetFrameLevel(3)

	local Text = plugin:CreateFontString(nil, 'OVERLAY')
	Text:SetFont(cfg.font, cfg.fontSize,'THINOUTLINE')
	PlacePlugin(cfg.bags, Text)

	local Profit	= 0
	local Spent		= 0
	local OldMoney	= 0
	local myPlayerRealm = GetRealmName();
	
	
	local function formatMoney(c)
		local str = ""
		if not c or c < 0 then 
			return str 
		end
		
		if c >= 10000 then
			local g = math.floor(c/10000)
			c = c - g*10000
			str = str..BreakUpLargeNumbers(g).."|cFFFFD800g|r "
		end
		if c >= 100 then
			local s = math.floor(c/100)
			c = c - s*100
			str = str..s.."|cFFC7C7C7s|r "
		end
		if c >= 0 then
			str = str..c.."|cFFEEA55Fc|r"
		end
		
		return str
	end
	
	local function OnEvent(self, event)
		local totalSlots, freeSlots = 0, 0
		local itemLink, subtype, isBag
		for i = 0,NUM_BAG_SLOTS do
			isBag = true
			if i > 0 then
				itemLink = GetInventoryItemLink('player', ContainerIDToInventoryID(i))
				if itemLink then
					subtype = select(7, GetItemInfo(itemLink))
					if (subtype == 'Mining Bag') or (subtype == 'Gem Bag') or (subtype == 'Engineering Bag') or (subtype == 'Enchanting Bag') or (subtype == 'Herb Bag') or (subtype == 'Inscription Bag') or (subtype == 'Leatherworking Bag') or (subtype == 'Fishing Bag')then
						isBag = false
					end
				end
			end
			if isBag then
				totalSlots = totalSlots + GetContainerNumSlots(i)
				freeSlots = freeSlots + GetContainerNumFreeSlots(i)
			end
			Text:SetText(hexa.."Bags: "..hexb.. freeSlots.. '/' ..totalSlots)
				if freeSlots < 6 then
					Text:SetTextColor(1,0,0)
				elseif freeSlots < 10 then
					Text:SetTextColor(1,0,0)
				elseif freeSlots > 10 then
					Text:SetTextColor(1,1,1)
				end
			self:SetAllPoints(Text)
			
		end
		if event == "PLAYER_ENTERING_WORLD" then
			OldMoney = GetMoney()
		end
		
		local NewMoney	= GetMoney()
		local Change = NewMoney-OldMoney -- Positive if we gain money
		
		if OldMoney>NewMoney then		-- Lost Money
			Spent = Spent - Change
		else							-- Gained Money
			Profit = Profit + Change
		end
		
		self:SetAllPoints(Text)

		local myPlayerName  = UnitName("player")				
		if not BasicUILite_DB then BasicUILite_DB = {} end
		if not BasicUILite_DB.Currency then BasicUILite_DB.Currency = {} end
		if not BasicUILite_DB.Currency[myPlayerRealm] then BasicUILite_DB.Currency[myPlayerRealm]={} end
		BasicUILite_DB.Currency[myPlayerRealm][myPlayerName] = GetMoney()	
			
		OldMoney = NewMoney	
			
	end

	plugin:RegisterEvent("PLAYER_MONEY")
	plugin:RegisterEvent("SEND_MAIL_MONEY_CHANGED")
	plugin:RegisterEvent("SEND_MAIL_COD_CHANGED")
	plugin:RegisterEvent("PLAYER_TRADE_MONEY")
	plugin:RegisterEvent("TRADE_MONEY_CHANGED")
	plugin:RegisterEvent("PLAYER_ENTERING_WORLD")
	plugin:RegisterEvent("BAG_UPDATE")
	
	plugin:SetScript('OnMouseDown', 
		function()
			if cfg.bag ~= true then
				ToggleAllBags()
			else
				ToggleBag(0)
			end
		end
	)
	plugin:SetScript('OnEvent', OnEvent)	
	plugin:SetScript("OnEnter", function(self)
		local anchor, panel, xoff, yoff = DataTextTooltipAnchor(Text)
		GameTooltip:SetOwner(panel, anchor, xoff, yoff)
		GameTooltip:ClearLines()
		GameTooltip:AddDoubleLine(hexa..playerName.."'s"..hexb.."|cffffd700 Currency|r", formatMoney(OldMoney), 1, 1, 1, 1, 1, 1)
		GameTooltip:AddLine' '			
		GameTooltip:AddLine("This Session: ")				
		GameTooltip:AddDoubleLine("Earned:", formatMoney(Profit), 1, 1, 1, 1, 1, 1)
		GameTooltip:AddDoubleLine("Spent:", formatMoney(Spent), 1, 1, 1, 1, 1, 1)
		if Profit < Spent then
			GameTooltip:AddDoubleLine("Deficit:", formatMoney(Profit-Spent), 1, 0, 0, 1, 1, 1)
		elseif (Profit-Spent)>0 then
			GameTooltip:AddDoubleLine("Profit:", formatMoney(Profit-Spent), 0, 1, 0, 1, 1, 1)
		end				
		--GameTooltip:AddDoubleLine("Total:", formatMoney(OldMoney), 1, 1, 1, 1, 1, 1)
		GameTooltip:AddLine' '
		
		local totalGold = 0				
		GameTooltip:AddLine("Character's: ")			
		local thisRealmList = BasicUILite_DB.Currency[myPlayerRealm];
		for k,v in pairs(thisRealmList) do
			GameTooltip:AddDoubleLine(k, formatMoney(v), 1, 1, 1, 1, 1, 1)
			totalGold=totalGold+v;
		end  
		GameTooltip:AddLine' '
		GameTooltip:AddLine("Server:")
		GameTooltip:AddDoubleLine("Total: ", formatMoney(totalGold), 1, 1, 1, 1, 1, 1)

		for i = 1, GetNumWatchedTokens() do
			local name, count, extraCurrencyType, icon, itemID = GetBackpackCurrencyInfo(i)
			if name and i == 1 then
				GameTooltip:AddLine(" ")
				GameTooltip:AddLine(CURRENCY..":")
			end
			local r, g, b = 1,1,1
			if itemID then r, g, b = GetItemQualityColor(select(3, GetItemInfo(itemID))) end
			if name and count then GameTooltip:AddDoubleLine(name, count, r, g, b, 1, 1, 1) end
		end
		GameTooltip:AddLine' '
		GameTooltip:AddLine("|cffeda55fClick|r to Open Bags")
		GameTooltip:AddLine("|cffeda55fType|r /resetcurrency to Reset Currency Totals")	
		GameTooltip:Show()
	end)
	
	plugin:SetScript("OnLeave", function() GameTooltip:Hide() end)	
	
	-- reset gold data
	local function RESETCURRENCY()
		local myPlayerRealm = GetRealmName();
		local myPlayerName  = UnitName("player");
		
		BasicUILite_DB.Currency = {}
		BasicUILite_DB.Currency[myPlayerRealm]={}
		BasicUILite_DB.Currency[myPlayerRealm][myPlayerName] = GetMoney();
	end
	
	SLASH_RESETCURRENCY1 = "/resetcurrency"
	SlashCmdList["RESETCURRENCY"] = RESETCURRENCY	

	--return plugin -- important!
end

------------------------------------------------------------------------
--	 Call-To-Arms Plugin Functions
------------------------------------------------------------------------
if cfg.calltoarms and cfg.calltoarms > 0 then
	
	local plugin = CreateFrame('Frame', nil, Datapanel)
	plugin:EnableMouse(true)
	plugin:SetFrameStrata("MEDIUM")
	plugin:SetFrameLevel(3)

	local Text = plugin:CreateFontString(nil, "OVERLAY")
	Text:SetFont(cfg.font, cfg.fontSize,'THINOUTLINE')
	PlacePlugin(cfg.calltoarms, Text)
	
	local function MakeIconString(tank, healer, damage)
		local str = ""
		if tank then 
			str = str..'T'
		end
		if healer then
			str = str..', H'
		end
		if damage then
			str = str..', D'
		end	
		
		return str
	end
	
	local function MakeString(tank, healer, damage)
		local str = ""
		if tank then 
			str = str..'Tank'
		end
		if healer then
			str = str..', Healer'
		end
		if damage then
			str = str..', DPS'
		end	
		
		return str
	end

	local function OnEvent(self, event, ...)
		local tankReward = false
		local healerReward = false
		local dpsReward = false
		local unavailable = true		
		for i=1, GetNumRandomDungeons() do
			local id, name = GetLFGRandomDungeonInfo(i)
			for x = 1,LFG_ROLE_NUM_SHORTAGE_TYPES do
				local eligible, forTank, forHealer, forDamage, itemCount = GetLFGRoleShortageRewards(id, x)
				if eligible then unavailable = false end
				if eligible and forTank and itemCount > 0 then tankReward = true end
				if eligible and forHealer and itemCount > 0 then healerReward = true end
				if eligible and forDamage and itemCount > 0 then dpsReward = true end				
			end
		end	
		
		if unavailable then
			Text:SetText(QUEUE_TIME_UNAVAILABLE)
		else
			Text:SetText(hexa..'C to A'..hexb.." : "..MakeIconString(tankReward, healerReward, dpsReward).." ")
		end
		
		self:SetAllPoints(Text)
	end

	local function OnEnter(self)	
		local anchor, panel, xoff, yoff = DataTextTooltipAnchor(Text)
		GameTooltip:SetOwner(panel, anchor, xoff, yoff)
		GameTooltip:ClearLines()
		GameTooltip:AddLine(hexa..playerName.."'s"..hexb.." Call to Arms")
		GameTooltip:AddLine(' ')
		
		local allUnavailable = true
		local numCTA = 0
		for i=1, GetNumRandomDungeons() do
			local id, name = GetLFGRandomDungeonInfo(i)
			local tankReward = false
			local healerReward = false
			local dpsReward = false
			local unavailable = true
			for x=1, LFG_ROLE_NUM_SHORTAGE_TYPES do
				local eligible, forTank, forHealer, forDamage, itemCount = GetLFGRoleShortageRewards(id, x)
				if eligible then unavailable = false end
				if eligible and forTank and itemCount > 0 then tankReward = true end
				if eligible and forHealer and itemCount > 0 then healerReward = true end
				if eligible and forDamage and itemCount > 0 then dpsReward = true end
			end
			if not unavailable then
				allUnavailable = false
				local rolesString = MakeString(tankReward, healerReward, dpsReward)
				if rolesString ~= ""  then 
					GameTooltip:AddDoubleLine(name.." : ", rolesString..' ', 1, 1, 1)
				end
				if tankReward or healerReward or dpsReward then numCTA = numCTA + 1 end
			end
		end
		
		if allUnavailable then 
			GameTooltip:AddLine("Could not get Call To Arms information.")
		elseif numCTA == 0 then 
			GameTooltip:AddLine("Could not get Call To Arms information.") 
		end
		GameTooltip:AddLine' '
		GameTooltip:AddLine("|cffeda55fLeft Click|r to Open Dungeon Finder")	
		GameTooltip:AddLine("|cffeda55fRight Click|r to Open PvP Finder")			
		GameTooltip:Show()	
	end
	
	plugin:RegisterEvent("LFG_UPDATE_RANDOM_INFO")
	plugin:RegisterEvent("PLAYER_LOGIN")
	plugin:SetScript("OnEvent", OnEvent)
	plugin:SetScript("OnMouseDown", function(self, btn)
		if btn == "LeftButton" then
			ToggleLFDParentFrame(1)
		elseif btn == "RightButton" then
			TogglePVPUI(1)
		end
	end)		
	plugin:SetScript("OnEnter", OnEnter)
	plugin:SetScript("OnLeave", function() GameTooltip:Hide() end)
	
	--return plugin -- important!
end

------------------------------------------------------------------------
--	 Coordinates Plugin Functions
------------------------------------------------------------------------
if cfg.coords and cfg.coords > 0 then

	local plugin = CreateFrame('Frame', nil, Datapanel)
	plugin:EnableMouse(true)
	plugin:SetFrameStrata('BACKGROUND')
	plugin:SetFrameLevel(3)

	local Text = plugin:CreateFontString(nil, "OVERLAY")
	Text:SetFont(cfg.font, cfg.fontSize,'THINOUTLINE')
	PlacePlugin(cfg.coords, Text)

	plugin:SetScript("OnUpdate", function(self, elapsed)	
		local px, py = GetPlayerMapPos(mapID)
		if (px ~= 0 and py ~= 0) then
 			Text:SetText(hexa.."Loc: "..hexb..format('%.0f x %.0f', px * 100, py * 100))
		else
			Text:SetText(hexa..'Loc:'..hexb.." Instance")
		end
	end)
	Update(plugin, 10)
	
	--return plugin -- important!
end

------------------------------------------------------------------------
--	 Damage Per Second Plugin Functions
------------------------------------------------------------------------

if cfg.dps and cfg.dps > 0 then

	local plugin = CreateFrame('Frame', nil, Datapanel)
	plugin:EnableMouse(true)
	plugin:SetFrameStrata('BACKGROUND')
	plugin:SetFrameLevel(3)

	local Text = plugin:CreateFontString(nil, "OVERLAY")
	Text:SetFont(cfg.font, cfg.fontSize,'THINOUTLINE')
	PlacePlugin(cfg.dps, Text)

	local events = {SWING_DAMAGE = true, RANGE_DAMAGE = true, SPELL_DAMAGE = true, SPELL_PERIODIC_DAMAGE = true, DAMAGE_SHIELD = true, DAMAGE_SPLIT = true, SPELL_EXTRA_ATTACKS = true}
	local player_id = UnitGUID('player')
	local dmg_total, last_dmg_amount = 0, 0
	local cmbt_time = 0

	local pet_id = UnitGUID('pet')
    

	plugin:SetScript('OnEvent', function(self, event, ...) self[event](self, ...) end)
	plugin:RegisterEvent('PLAYER_LOGIN')

	plugin:SetScript('OnUpdate', function(self, elap)
		if UnitAffectingCombat('player') then
			cmbt_time = cmbt_time + elap
		end
       
		Text:SetText(getDPS())
	end)
     
	function plugin:PLAYER_LOGIN()
		plugin:RegisterEvent('COMBAT_LOG_EVENT_UNFILTERED')
		plugin:RegisterEvent('PLAYER_REGEN_ENABLED')
		plugin:RegisterEvent('PLAYER_REGEN_DISABLED')
		plugin:RegisterEvent('UNIT_PET')
		player_id = UnitGUID('player')
		plugin:UnregisterEvent('PLAYER_LOGIN')
	end
     
	function plugin:UNIT_PET(unit)
		if unit == 'player' then
			pet_id = UnitGUID('pet')
		end
	end
	
	-- handler for the combat log. used http://www.wowwiki.com/API_COMBAT_LOG_EVENT for api
	function plugin:COMBAT_LOG_EVENT_UNFILTERED(...)		   
		-- filter for events we only care about. i.e heals
		if not events[select(2, ...)] then return end

		-- only use events from the player
		local id = select(4, ...)
		   
		if id == player_id or id == pet_id then
			if select(2, ...) == "SWING_DAMAGE" then
				last_dmg_amount = select(12, ...)
			else
				last_dmg_amount = select(15, ...)
			end
			dmg_total = dmg_total + last_dmg_amount
		end       
	end
     
	function getDPS()
		if (dmg_total == 0) then
			return (hexa.."DPS"..hexb..' 0')
		else
			return string.format(hexa.."DPS: "..hexb..'%.1f ', (dmg_total or 0) / (cmbt_time or 1))
		end
	end

	function plugin:PLAYER_REGEN_ENABLED()
		Text:SetText(getDPS())
	end
	
	function plugin:PLAYER_REGEN_DISABLED()
		cmbt_time = 0
		dmg_total = 0
		last_dmg_amount = 0
	end
     
	plugin:SetScript("OnEnter", function(self)
		local anchor, panel, xoff, yoff = DataTextTooltipAnchor(Text)
		GameTooltip:SetOwner(panel, anchor, xoff, yoff)
		GameTooltip:ClearLines()
		GameTooltip:AddDoubleLine(hexa..playerName.."'s"..hexb.."|cffffd700 DPS|r")
		GameTooltip:AddLine' '
		GameTooltip:AddDoubleLine("Combat Time:", cmbt_time, 1, 0, 0, 1, 1, 1)
		GameTooltip:AddDoubleLine("Total Damage:", dmg_total, 1, 0, 0, 1, 1, 1)
		GameTooltip:AddDoubleLine("Last Damage:", last_dmg_amount, 1, 0, 0, 1, 1, 1)
		GameTooltip:Show()
	end)
	
	--return plugin -- important!
end

------------------------------------------------------------------------
--	 Durability Plugin Functions
------------------------------------------------------------------------
if cfg.dur and cfg.dur > 0 then
	
	Slots = {
		[1] = {1, "Head", 1000},
		[2] = {3, "Shoulder", 1000},
		[3] = {5, "Chest", 1000},
		[4] = {6, "Waist", 1000},
		[5] = {9, "Wrist", 1000},
		[6] = {10, "Hands", 1000},
		[7] = {7, "Legs", 1000},
		[8] = {8, "Feet", 1000},
		[9] = {16, "Main Hand", 1000},
		[10] = {17, "Off Hand", 1000},
		[11] = {18, "Ranged", 1000}
	}


	local plugin = CreateFrame('Frame', nil, Datapanel)
	plugin:EnableMouse(true)
	plugin:SetFrameStrata("MEDIUM")
	plugin:SetFrameLevel(3)

	local Text  = plugin:CreateFontString(nil, "OVERLAY")
	Text:SetFont(cfg.font, cfg.fontSize,'THINOUTLINE')
	PlacePlugin(cfg.dur, Text)

	local function OnEvent(self)
		local Total = 0
		local current, max
		
		for i = 1, 11 do
			if GetInventoryItemLink("player", Slots[i][1]) ~= nil then
				current, max = GetInventoryItemDurability(Slots[i][1])
				if current then 
					Slots[i][3] = current/max
					Total = Total + 1
				end
			end
		end
		table.sort(Slots, function(a, b) return a[3] < b[3] end)
		
		if Total > 0 then
			Text:SetText(hexa.."Armor: "..hexb..floor(Slots[1][3]*100).."% |r")
		else
			Text:SetText(hexa.."Armor: "..hexb.."100% |r")
		end
		-- Setup Durability Tooltip
		self:SetAllPoints(Text)
		Total = 0
	end

	plugin:RegisterEvent("UPDATE_INVENTORY_DURABILITY")
	plugin:RegisterEvent("MERCHANT_SHOW")
	plugin:RegisterEvent("PLAYER_ENTERING_WORLD")
	plugin:SetScript("OnMouseDown",function(self,btn)
		if btn == "LeftButton" then
			ToggleCharacter("PaperDollFrame")
		elseif btn == "RightButton" then
			if not IsShiftKeyDown() then
				CastSpellByName("Traveler's Tundra Mammoth")
			else
				CastSpellByName("Grand Expedition Yak")
			end
		end
	end)
	plugin:SetScript("OnEvent", OnEvent)
	plugin:SetScript("OnEnter", function(self)
		local anchor, panel, xoff, yoff = DataTextTooltipAnchor(Text)
		GameTooltip:SetOwner(panel, anchor, xoff, yoff)
		GameTooltip:ClearLines()
		GameTooltip:AddLine(hexa..playerName.."'s"..hexb.." Durability")
		GameTooltip:AddLine' '
		GameTooltip:AddDoubleLine("Current "..STAT_AVERAGE_ITEM_LEVEL, format("%.1f", GetAverageItemLevel("player")))
		GameTooltip:AddLine' '
		for i = 1, 11 do
			if Slots[i][3] ~= 1000 then
				local green, red
				green = Slots[i][3]*2
				red = 1 - green
				GameTooltip:AddDoubleLine(Slots[i][2], floor(Slots[i][3]*100).."%",1 ,1 , 1, red + 1, green, 0)
			end
		end
		GameTooltip:AddLine(" ")
		GameTooltip:AddLine("|cffeda55fLeft Click|r opens Character Panel.")
		GameTooltip:AddLine("|cffeda55fRight Click|r summon's Traveler's Tundra Mammoth.")
		GameTooltip:AddLine("|cffeda55fHold Shift + Right Click|r summon's Grand Expedition Yak.")
		GameTooltip:Show()
	end)
	plugin:SetScript("OnLeave", function() GameTooltip:Hide() end)

	--return plugin -- important!
end

------------------------------------------------------------------------
--	 Friends Plugin Functions
------------------------------------------------------------------------
if cfg.friends and cfg.friends > 0 then

	--Cache global variables
	--Lua functions
	local type, pairs, select = type, pairs, select
	local sort, wipe = table.sort, wipe
	local format, find, join, gsub = string.format, string.find, string.join, string.gsub
	--WoW API / Variables
	local BNSetCustomMessage = BNSetCustomMessage
	local BNGetInfo = BNGetInfo
	local IsChatAFK = IsChatAFK
	local IsChatDND = IsChatDND
	local SendChatMessage = SendChatMessage
	local InviteUnit = InviteUnit
	local BNInviteFriend = BNInviteFriend
	local ChatFrame_SendSmartTell = ChatFrame_SendSmartTell
	local SetItemRef = SetItemRef
	local GetFriendInfo = GetFriendInfo
	local BNGetFriendInfo = BNGetFriendInfo
	local BNGetGameAccountInfo = BNGetGameAccountInfo
	local BNet_GetValidatedCharacterName = BNet_GetValidatedCharacterName
	local GetNumFriends = GetNumFriends
	local BNGetNumFriends = BNGetNumFriends
	local GetQuestDifficultyColor = GetQuestDifficultyColor
	local UnitFactionGroup = UnitFactionGroup
	local UnitInParty = UnitInParty
	local UnitInRaid = UnitInRaid
	local ToggleFriendsFrame = ToggleFriendsFrame
	local EasyMenu = EasyMenu
	local IsShiftKeyDown = IsShiftKeyDown
	local GetRealmName = GetRealmName
	local AFK = AFK
	local DND = DND
	local LOCALIZED_CLASS_NAMES_MALE = LOCALIZED_CLASS_NAMES_MALE
	local LOCALIZED_CLASS_NAMES_FEMALE = LOCALIZED_CLASS_NAMES_FEMALE
	local CUSTOM_CLASS_COLORS = CUSTOM_CLASS_COLORS
	local RAID_CLASS_COLORS = RAID_CLASS_COLORS	
	
	StaticPopupDialogs["SET_BN_BROADCAST"] = {
		preferredIndex = STATICPOPUP_NUMDIALOGS,
		text = BN_BROADCAST_TOOLTIP,
		button1 = ACCEPT,
		button2 = CANCEL,
		hasEditBox = 1,
		editBoxWidth = 350,
		maxLetters = 127,
		OnAccept = function(self)
			BNSetCustomMessage(self.editBox:GetText())
		end,
		OnShow = function(self)
			self.editBox:SetText(select(4, BNGetInfo()) )
			self.editBox:SetFocus()
		end,
		OnHide = ChatEdit_FocusActiveWindow,
		EditBoxOnEnterPressed = function(self)
			BNSetCustomMessage(self:GetText())
			self:GetParent():Hide()
		end,
		EditBoxOnEscapePressed = function(self)
			self:GetParent():Hide()
		end,
		timeout = 0,
		exclusive = 1,
		whileDead = 1,
		hideOnEscape = 1
	}

	local plugin = CreateFrame('Frame', nil, Datapanel)
	plugin:EnableMouse(true)
	plugin:SetFrameStrata("MEDIUM")
	plugin:SetFrameLevel(3)

	local Text  = plugin:CreateFontString(nil, "OVERLAY")
	Text:SetFont(cfg.font, cfg.fontSize,'THINOUTLINE')
	PlacePlugin(cfg.friends, Text)

	local menuFrame = CreateFrame("Frame", "FriendDatatextRightClickMenu", UIParent, "UIDropDownMenuTemplate")
	local menuList = {
		{ text = OPTIONS_MENU, isTitle = true,notCheckable=true},
		{ text = INVITE, hasArrow = true,notCheckable=true, },
		{ text = CHAT_MSG_WHISPER_INFORM, hasArrow = true,notCheckable=true, },
		{ text = PLAYER_STATUS, hasArrow = true, notCheckable=true,
			menuList = {
				{ text = "|cff2BC226"..AVAILABLE.."|r", notCheckable=true, func = function() if IsChatAFK() then SendChatMessage("", "AFK") elseif IsChatDND() then SendChatMessage("", "DND") end end },
				{ text = "|cffE7E716"..DND.."|r", notCheckable=true, func = function() if not IsChatDND() then SendChatMessage("", "DND") end end },
				{ text = "|cffFF0000"..AFK.."|r", notCheckable=true, func = function() if not IsChatAFK() then SendChatMessage("", "AFK") end end },
			},
		},
		{ text = BN_BROADCAST_TOOLTIP, notCheckable=true, func = function() StaticPopup_Show("SET_BN_BROADCAST") end },
	}

	local function GetTableIndex(table, fieldIndex, value)
		for k,v in ipairs(table) do
			if v[fieldIndex] == value then return k end
		end
		return -1
	end	
	
	local function inviteClick(self, name)
		menuFrame:Hide()
		
		if type(name) ~= 'number' then
			InviteUnit(name)
		else
			BNInviteFriend(name);
		end
	end

	local function whisperClick(self, name, battleNet)
		menuFrame:Hide() 
		
		if battleNet then
			ChatFrame_SendSmartTell(name)
		else
			SetItemRef( "player:"..name, ("|Hplayer:%1$s|h[%1$s]|h"):format(name), "LeftButton" )		 
		end
	end

	local levelNameString = "|cff%02x%02x%02x%d|r |cff%02x%02x%02x%s|r"
	local clientLevelNameString = "%s (|cff%02x%02x%02x%d|r |cff%02x%02x%02x%s|r%s) |cff%02x%02x%02x%s|r"
	local levelNameClassString = "|cff%02x%02x%02x%d|r %s%s%s"
	local worldOfWarcraftString = WORLD_OF_WARCRAFT
	local battleNetString = BATTLENET_OPTIONS_LABEL
	local wowString, scString, d3String, wtcgString, appString, hotsString  = BNET_CLIENT_WOW, BNET_CLIENT_SC2, BNET_CLIENT_D3, BNET_CLIENT_WTCG, "App", BNET_CLIENT_HEROES
	local totalOnlineString = string.join("", FRIENDS_LIST_ONLINE, ": %s/%s")
	local tthead, ttsubh, ttoff = {r=0.4, g=0.78, b=1}, {r=0.75, g=0.9, b=1}, {r=.3,g=1,b=.3}
	local activezone, inactivezone = {r=0.3, g=1.0, b=0.3}, {r=0.65, g=0.65, b=0.65}
	local displayString = string.join("", hexa.."%s:|r %d|r"..hexb)
	local statusTable = { "|cffff0000[AFK]|r", "|cffff0000[DND]|r", "" }
	local groupedTable = { "|cffaaaaaa*|r", "" } 
	local friendTable, BNTable, BNTableWoW, BNTableD3, BNTableSC, BNTableWTCG, BNTableApp, BNTableHOTS = {}, {}, {}, {}, {}, {}, {}, {}
	local tableList = {[wowString] = BNTableWoW, [d3String] = BNTableD3, [scString] = BNTableSC, [wtcgString] = BNTableWTCG, [appString] = BNTableApp, [hotsString] = BNTableHOTS}
	local totalOnline, BNTotalOnline = 0, 0
	local dataValid = false

	local function SortAlphabeticName(a, b)
		if a[1] and b[1] then
			return a[1] < b[1]
		end
	end	
	
	local function BuildFriendTable(total)
		totalOnline = 0
		wipe(friendTable)
		local name, level, class, area, connected, status, note
		for i = 1, total do
			name, level, class, area, connected, status, note = GetFriendInfo(i)

			if status == "<"..AFK..">" then
				status = "|cffFFFFFF[|r|cffFF0000"..'AFK'.."|r|cffFFFFFF]|r"
			elseif status == "<"..DND..">" then
				status = "|cffFFFFFF[|r|cffFF0000"..'DND'.."|r|cffFFFFFF]|r"
			end
			
			if connected then 
				for k,v in pairs(LOCALIZED_CLASS_NAMES_MALE) do if class == v then class = k end end
				for k,v in pairs(LOCALIZED_CLASS_NAMES_FEMALE) do if class == v then class = k end end
				friendTable[i] = { name, level, class, area, connected, status, note }
			end
		end
		sort(friendTable, SortAlphabeticName)
	end

	--Sort alphabetic by accountName or characterName
	local function Sort(a, b)
		if a[2] and b[2] and a[3] and b[3] then
			if a[2] == b[2] then return a[3] < b[3] end
			return a[2] < b[2]
		end
	end	

	local function BuildBNTable(total)
		wipe(BNTable)
		wipe(BNTableWoW)
		wipe(BNTableD3)
		wipe(BNTableSC)
		wipe(BNTableWTCG)
		wipe(BNTableApp)
		wipe(BNTableHOTS)

		local _, bnetIDAccount, accountName, battleTag, characterName, bnetIDGameAccount, client, isOnline, isAFK, isDND, noteText
		local hasFocus, realmName, realmID, faction, race, class, guild, zoneName, level, gameText
		for i = 1, total do
			bnetIDAccount, accountName, battleTag, _, characterName, bnetIDGameAccount, client, isOnline, _, isAFK, isDND, _, noteText = BNGetFriendInfo(i)
			hasFocus, _, _, realmName, realmID, faction, race, class, guild, zoneName, level, gameText = BNGetGameAccountInfo(bnetIDGameAccount or bnetIDAccount);

			if isOnline then
				characterName = BNet_GetValidatedCharacterName(characterName, battleTag, client) or "";
				for k,v in pairs(LOCALIZED_CLASS_NAMES_MALE) do if class == v then class = k end end
				for k,v in pairs(LOCALIZED_CLASS_NAMES_FEMALE) do if class == v then class = k end end
				BNTable[i] = { bnetIDAccount, accountName, battleTag, characterName, bnetIDGameAccount, client, isOnline, isAFK, isDND, noteText, realmName, faction, race, class, zoneName, level }

				if client == scString then
					BNTableSC[#BNTableSC + 1] = { bnetIDAccount, accountName, characterName, bnetIDGameAccount, client, isOnline, isAFK, isDND, noteText, realmName, faction, race, class, zoneName, level }
				elseif client == d3String then
					BNTableD3[#BNTableD3 + 1] = { bnetIDAccount, accountName, characterName, bnetIDGameAccount, client, isOnline, isAFK, isDND, noteText, realmName, faction, race, class, zoneName, level }
				elseif client == wtcgString then
					BNTableWTCG[#BNTableWTCG + 1] = { bnetIDAccount, accountName, characterName, bnetIDGameAccount, client, isOnline, isAFK, isDND, noteText, realmName, faction, race, class, zoneName, level }
				elseif client == appString then
					BNTableApp[#BNTableApp + 1] = { bnetIDAccount, accountName, characterName, bnetIDGameAccount, client, isOnline, isAFK, isDND, noteText, realmName, faction, race, class, zoneName, level }
				elseif client == hotsString then
					BNTableHOTS[#BNTableHOTS + 1] = { bnetIDAccount, accountName, characterName, bnetIDGameAccount, client, isOnline, isAFK, isDND, noteText, realmName, faction, race, class, zoneName, level }
				else
					BNTableWoW[#BNTableWoW + 1] = { bnetIDAccount, accountName, characterName, bnetIDGameAccount, client, isOnline, isAFK, isDND, noteText, realmName, faction, race, class, zoneName, level }
				end
			end
		end

		sort(BNTable, Sort)
		sort(BNTableWoW, Sort)
		sort(BNTableSC, Sort)
		sort(BNTableD3, Sort)
		sort(BNTableWTCG, Sort)
		sort(BNTableApp, Sort)
		sort(BNTableHOTS, Sort)
	end
		

	plugin:SetScript("OnEvent", function(self, event, ...)
		local _, onlineFriends = GetNumFriends()
		local _, numBNetOnline = BNGetNumFriends()

		-- special handler to detect friend coming online or going offline
		-- when this is the case, we invalidate our buffered table and update the
		-- datatext information
		if event == "CHAT_MSG_SYSTEM" then
			local message = select(1, ...)
			if not (find(message, friendOnline) or find(message, friendOffline)) then return end
		end

		-- force update when showing tooltip
		dataValid = false

		Text:SetFormattedText(displayString, "Friends", onlineFriends + numBNetOnline)
		self:SetAllPoints(Text)
	end)

	plugin:SetScript("OnMouseDown", function(self, btn)
	
		GameTooltip:Hide()
		
		if btn == "RightButton" then
			local menuCountWhispers = 0
			local menuCountInvites = 0
			local factionc, classc, levelc, info
			
			menuList[2].menuList = {}
			menuList[3].menuList = {}
			
			if #friendTable > 0 then
				for i = 1, #friendTable do
					info = friendTable[i]
					if (info[5]) then
						menuCountInvites = menuCountInvites + 1
						menuCountWhispers = menuCountWhispers + 1

						classc, levelc = (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS)[info[3]], GetQuestDifficultyColor(info[2])
						classc = classc or GetQuestDifficultyColor(info[2]);

						menuList[2].menuList[menuCountInvites] = {text = format(levelNameString,levelc.r*255,levelc.g*255,levelc.b*255,info[2],classc.r*255,classc.g*255,classc.b*255,info[1]), arg1 = info[1],notCheckable=true, func = inviteClick}
						menuList[3].menuList[menuCountWhispers] = {text = format(levelNameString,levelc.r*255,levelc.g*255,levelc.b*255,info[2],classc.r*255,classc.g*255,classc.b*255,info[1]), arg1 = info[1],notCheckable=true, func = whisperClick}
					end
				end
			end
			if #BNTable > 0 then
				local realID, grouped
				for i = 1, #BNTable do
					info = BNTable[i]
					if (info[5]) then
						realID = info[2]
						menuCountWhispers = menuCountWhispers + 1
						menuList[3].menuList[menuCountWhispers] = {text = realID, arg1 = realID, arg2 = true, notCheckable=true, func = whisperClick}

						if info[6] == wowString and UnitFactionGroup("player") == info[12] then
							classc, levelc = (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS)[info[14]], GetQuestDifficultyColor(info[16])
							classc = classc or GetQuestDifficultyColor(info[16])

							if UnitInParty(info[4]) or UnitInRaid(info[4]) then grouped = 1 else grouped = 2 end
							menuCountInvites = menuCountInvites + 1

							menuList[2].menuList[menuCountInvites] = {text = format(levelNameString,levelc.r*255,levelc.g*255,levelc.b*255,info[16],classc.r*255,classc.g*255,classc.b*255,info[4]), arg1 = info[5], notCheckable=true, func = inviteClick}
						end
					end
				end
			end

			EasyMenu(menuList, menuFrame, "cursor", 0, 0, "MENU", 2)
		else
			ToggleFriendsFrame()
		end
	end)


	plugin:SetScript("OnEnter", function(self)
		
		local numberOfFriends, onlineFriends = GetNumFriends()
		local totalBNet, numBNetOnline = BNGetNumFriends()
		local totalfriends = #friendTable + #BNTable	
		local totalonline = onlineFriends + numBNetOnline
		
		-- no friends online, quick exit
		if totalonline == 0 then return end

		if not dataValid then
			-- only retrieve information for all on-line members when we actually view the tooltip
			if numberOfFriends > 0 then BuildFriendTable(numberOfFriends) end
			if totalBNet > 0 then BuildBNTable(totalBNet) end
			dataValid = true
		end
		if totalonline > 0 then
			local anchor, panel, xoff, yoff = DataTextTooltipAnchor(Text)
			GameTooltip:SetOwner(panel, anchor, xoff, yoff)
			GameTooltip:ClearLines()
			GameTooltip:AddDoubleLine(hexa..playerName.."'s"..hexb.." Friends", format(totalOnlineString, totalonline, totalfriends))
			if onlineFriends > 0 then
				local anchor, panel, xoff, yoff = DataTextTooltipAnchor(Text)
				GameTooltip:SetOwner(panel, anchor, xoff, yoff)		
				GameTooltip:AddLine(' ')
				GameTooltip:AddLine(worldOfWarcraftString)
				for i = 1, #friendTable do
					info = friendTable[i]
					if info[5] then
						if GetZoneText(C_Map.GetBestMapForUnit("player")) == info[4] then zonec = activezone else zonec = inactivezone end
						classc, levelc = (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS)[info[3]], GetQuestDifficultyColor(info[2])

						classc = classc or GetQuestDifficultyColor(info[2])

						if UnitInParty(info[1]) or UnitInRaid(info[1]) then grouped = 1 else grouped = 2 end
						GameTooltip:AddDoubleLine(format(levelNameClassString,levelc.r*255,levelc.g*255,levelc.b*255,info[2],info[1],groupedTable[grouped]," "..info[6]),info[4],classc.r,classc.g,classc.b,zonec.r,zonec.g,zonec.b)
					end
				end
			end
			if numBNetOnline > 0 then
				local status = 0
				for client, BNTable in pairs(tableList) do
					if #BNTable > 0 then
						GameTooltip:AddLine(' ')
						GameTooltip:AddLine(battleNetString..' ('..client..')')
						for i = 1, #BNTable do
							info = BNTable[i]
							if info[6] then
								if info[5] == wowString then
									if (info[7] == true) then status = 1 elseif (info[8] == true) then status = 2 else status = 3 end
									classc = (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS)[info[13]]
									if info[15] ~= '' then
										levelc = GetQuestDifficultyColor(info[15])
									else
										levelc = RAID_CLASS_COLORS["PRIEST"]
										classc = RAID_CLASS_COLORS["PRIEST"]
									end

									if UnitInParty(info[4]) or UnitInRaid(info[4]) then grouped = 1 else grouped = 2 end
									GameTooltip:AddDoubleLine(format(levelNameString,levelc.r*255,levelc.g*255,levelc.b*255,info[15],classc.r*255,classc.g*255,classc.b*255,info[3],groupedTable[grouped], 255, 0, 0, statusTable[status]),info[2],238,238,238,238,238,238)
									if IsShiftKeyDown() then
										if GetZoneText(C_Map.GetBestMapForUnit("player")) == info[14] then zonec = activezone else zonec = inactivezone end
										if GetRealmName() == info[10] then realmc = activezone else realmc = inactivezone end
										GameTooltip:AddDoubleLine(info[14], info[10], zonec.r, zonec.g, zonec.b, realmc.r, realmc.g, realmc.b)
									end
								else
									GameTooltip:AddDoubleLine(info[3], info[2], .9, .9, .9, .9, .9, .9)
								end
							end
						end
					end
				end
			end
			GameTooltip:AddLine' '
			GameTooltip:AddLine("|cffeda55fLeft Click|r to Open Friends List")
			GameTooltip:AddLine("|cffeda55fShift + Mouseover|r to Show Zone and Realm of Friend")
			GameTooltip:AddLine("|cffeda55fRight Click|r to Access Option Menu")			
			GameTooltip:Show()
		else 
			GameTooltip:Hide() 
		end
	end)

	plugin:RegisterEvent("BN_FRIEND_ACCOUNT_ONLINE")
	plugin:RegisterEvent("BN_FRIEND_ACCOUNT_OFFLINE")
	plugin:RegisterEvent("BN_FRIEND_INFO_CHANGED")
	--plugin:RegisterEvent("BN_FRIEND_TOON_ONLINE")
	--plugin:RegisterEvent("BN_FRIEND_TOON_OFFLINE")
	--plugin:RegisterEvent("BN_TOON_NAME_UPDATED")
	plugin:RegisterEvent("FRIENDLIST_UPDATE")
	plugin:RegisterEvent("PLAYER_ENTERING_WORLD")

	plugin:SetScript("OnLeave", function() GameTooltip:Hide() end)

	--return plugin -- important!
end

------------------------------------------------------------------------
--	 Guild Plugin Functions
------------------------------------------------------------------------
local function RGBToHex(r, g, b)
	if r > 1 then r = 1 elseif r < 0 then r = 0 end
	if g > 1 then g = 1 elseif g < 0 then g = 0 end
	if b > 1 then b = 1 elseif b < 0 then b = 0 end
	return format("|cff%02x%02x%02x", r*255, g*255, b*255)
end

local function ShortValue(v)
	if v >= 1e6 then
		return format("%.1fm", v / 1e6):gsub("%.?0+([km])$", "%1")
	elseif v >= 1e3 or v <= -1e3 then
		return format("%.1fk", v / 1e3):gsub("%.?0+([km])$", "%1")
	else
		return v
	end
end

if cfg.guild and cfg.guild > 0 then

	local plugin = CreateFrame('Frame', nil, Datapanel)
	plugin:EnableMouse(true)
	plugin:SetFrameStrata("MEDIUM")
	plugin:SetFrameLevel(3)

	local Text  = plugin:CreateFontString(nil, "OVERLAY")
	Text:SetFont(cfg.font, cfg.fontSize,'THINOUTLINE')
	PlacePlugin(cfg.guild, Text)
	
	local join 		= string.join
	local format 	= string.format
	local split 	= string.split	

	local tthead, ttsubh, ttoff = {r=0.4, g=0.78, b=1}, {r=0.75, g=0.9, b=1}, {r=.3,g=1,b=.3}
	local activezone, inactivezone = {r=0.3, g=1.0, b=0.3}, {r=0.65, g=0.65, b=0.65}
	local displayString = join("", hexa, GUILD, ":|r ", "%d")
	local noGuildString = join("", hexa, 'No Guild')
	local guildInfoString = "%s [%d]"
	local guildInfoString2 = join("", "Online", ": %d/%d")
	local guildMotDString = "%s |cffaaaaaa- |cffffffff%s"
	local levelNameString = "|cff%02x%02x%02x%d|r |cff%02x%02x%02x%s|r %s"
	local levelNameStatusString = "|cff%02x%02x%02x%d|r %s %s"
	local nameRankString = "%s |cff999999-|cffffffff %s"
	local guildXpCurrentString = gsub(join("", RGBToHex(ttsubh.r, ttsubh.g, ttsubh.b), GUILD_EXPERIENCE_CURRENT), ": ", ":|r |cffffffff", 1)
	local guildXpDailyString = gsub(join("", RGBToHex(ttsubh.r, ttsubh.g, ttsubh.b), GUILD_EXPERIENCE_DAILY), ": ", ":|r |cffffffff", 1)
	local standingString = join("", RGBToHex(ttsubh.r, ttsubh.g, ttsubh.b), "%s:|r |cFFFFFFFF%s/%s (%s%%)")
	local moreMembersOnlineString = join("", "+ %d ", FRIENDS_LIST_ONLINE, "...")
	local noteString = join("", "|cff999999   ", LABEL_NOTE, ":|r %s")
	local officerNoteString = join("", "|cff999999   ", GUILD_RANK1_DESC, ":|r %s")
	local groupedTable = { "|cffaaaaaa*|r", "" } 
	local MOBILE_BUSY_ICON = "|TInterface\\ChatFrame\\UI-ChatIcon-ArmoryChat-BusyMobile:14:14:0:0:16:16:0:16:0:16|t";
	local MOBILE_AWAY_ICON = "|TInterface\\ChatFrame\\UI-ChatIcon-ArmoryChat-AwayMobile:14:14:0:0:16:16:0:16:0:16|t";
	
	local guildTable, guildXP, guildMotD = {}, {}, ""
	local totalOnline = 0
	
	local function SortGuildTable(shift)
		sort(guildTable, function(a, b)
			if a and b then
				if shift then
					return a[10] < b[10]
				else
					return a[1] < b[1]
				end
			end
		end)
	end	

	local chatframetexture = ChatFrame_GetMobileEmbeddedTexture(73/255, 177/255, 73/255)
	local onlinestatusstring = "|cffFFFFFF[|r|cffFF0000%s|r|cffFFFFFF]|r"
	local onlinestatus = {
		[0] = function () return '' end,
		[1] = function () return format(onlinestatusstring, 'AFK') end,
		[2] = function () return format(onlinestatusstring, 'DND') end,
	}
	local mobilestatus = {
		[0] = function () return chatframetexture end,
		[1] = function () return MOBILE_AWAY_ICON end,
		[2] = function () return MOBILE_BUSY_ICON end,
	}

	local function BuildGuildTable()
		wipe(guildTable)
		local statusInfo
		local _, name, rank, level, zone, note, officernote, connected, memberstatus, class, isMobile
		
		local totalMembers = GetNumGuildMembers()
		for i = 1, totalMembers do
			name, rank, rankIndex, level, _, zone, note, officernote, connected, memberstatus, class, _, _, isMobile = GetGuildRosterInfo(i)

			statusInfo = isMobile and mobilestatus[memberstatus]() or onlinestatus[memberstatus]()
			zone = (isMobile and not connected) and REMOTE_CHAT or zone

			if connected or isMobile then 
				guildTable[#guildTable + 1] = { name, rank, level, zone, note, officernote, connected, statusInfo, class, rankIndex, isMobile }
			end
		end
	end

	local function UpdateGuildMessage()
		guildMotD = GetGuildRosterMOTD()
	end
	
	local FRIEND_ONLINE = select(2, split(" ", ERR_FRIEND_ONLINE_SS, 2))
	local resendRequest = false
	local eventHandlers = {
		['CHAT_MSG_SYSTEM'] = function(self, arg1)
			if(FRIEND_ONLINE ~= nil and arg1 and arg1:find(FRIEND_ONLINE)) then
				resendRequest = true
			end
		end,
		-- when we enter the world and guildframe is not available then
		-- load guild frame, update guild message and guild xp	
		["PLAYER_ENTERING_WORLD"] = function (self, arg1)
		
			if not GuildFrame and IsInGuild() then 
				LoadAddOn("Blizzard_GuildUI")
				GuildRoster() 
			end
		end,
		-- Guild Roster updated, so rebuild the guild table
		["GUILD_ROSTER_UPDATE"] = function (self)
			if(resendRequest) then
				resendRequest = false;
				return GuildRoster()
			else
				BuildGuildTable()
				UpdateGuildMessage()
				if GetMouseFocus() == self then
					self:GetScript("OnEnter")(self, nil, true)
				end
			end
		end,
		-- our guild xp changed, recalculate it	
		["PLAYER_GUILD_UPDATE"] = function (self, arg1)
			GuildRoster()
		end,
		-- our guild message of the day changed
		["GUILD_MOTD"] = function (self, arg1)
			guildMotD = arg1
		end,
		--["ELVUI_FORCE_RUN"] = function() end,
		--["ELVUI_COLOR_UPDATE"] = function() end,
	}	

	local function Update(self, event, ...)
		if IsInGuild() then
			eventHandlers[event](self, select(1, ...))

			Text:SetFormattedText(displayString, #guildTable)
		else
			Text:SetText(noGuildString)
		end
		
		self:SetAllPoints(Text)
	end
		
	local menuFrame = CreateFrame("Frame", "GuildRightClickMenu", UIParent, "UIDropDownMenuTemplate")
	local menuList = {
		{ text = OPTIONS_MENU, isTitle = true,notCheckable=true},
		{ text = INVITE, hasArrow = true,notCheckable=true,},
		{ text = CHAT_MSG_WHISPER_INFORM, hasArrow = true,notCheckable=true,}
	}

	local function inviteClick(self, arg1, arg2, checked)
		menuFrame:Hide()
		InviteUnit(arg1)
	end

	local function whisperClick(self,arg1,arg2,checked)
		menuFrame:Hide()
		SetItemRef( "player:"..arg1, ("|Hplayer:%1$s|h[%1$s]|h"):format(arg1), "LeftButton" )
	end

	local function ToggleGuildFrame()
		if IsInGuild() then 
			if not GuildFrame then LoadAddOn("Blizzard_GuildUI") end 
			GuildFrame_Toggle()
			GuildFrame_TabClicked(GuildFrameTab2)
		else 
			if not LookingForGuildFrame then LoadAddOn("Blizzard_LookingForGuildUI") end 
			LookingForGuildFrame_Toggle() 
		end
	end

	plugin:SetScript("OnMouseUp", function(self, btn)
		if btn ~= "RightButton" or not IsInGuild() then return end
		
		GameTooltip:Hide()

		local classc, levelc, grouped
		local menuCountWhispers = 0
		local menuCountInvites = 0

		menuList[2].menuList = {}
		menuList[3].menuList = {}

		for i = 1, #guildTable do
			if (guildTable[i][7] and guildTable[i][1] ~= BasicUILitemyname) then
				local classc, levelc = (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS)[guildTable[i][9]], GetQuestDifficultyColor(guildTable[i][3])

				if UnitInParty(guildTable[i][1]) or UnitInRaid(guildTable[i][1]) then
					grouped = "|cffaaaaaa*|r"
				else
					grouped = ""
					if not guildTable[i][10] then
						menuCountInvites = menuCountInvites + 1
						menuList[2].menuList[menuCountInvites] = {text = format(levelNameString, levelc.r*255,levelc.g*255,levelc.b*255, guildTable[i][3], classc.r*255,classc.g*255,classc.b*255, guildTable[i][1], ""), arg1 = guildTable[i][1],notCheckable=true, func = inviteClick}
					end
				end
				menuCountWhispers = menuCountWhispers + 1
				menuList[3].menuList[menuCountWhispers] = {text = format(levelNameString, levelc.r*255,levelc.g*255,levelc.b*255, guildTable[i][3], classc.r*255,classc.g*255,classc.b*255, guildTable[i][1], grouped), arg1 = guildTable[i][1],notCheckable=true, func = whisperClick}
			end
		end

		EasyMenu(menuList, menuFrame, "cursor", 0, 0, "MENU", 2)
	end)

	plugin:SetScript("OnEnter", function(self)
		if not IsInGuild() then return end
		
		local total, _, online = GetNumGuildMembers()
		if #guildTable == 0 then BuildGuildTable() end
		
		local anchor, panel, xoff, yoff = DataTextTooltipAnchor(Text)
		local guildName, guildRank = GetGuildInfo('player')
		
		GameTooltip:SetOwner(panel, anchor, xoff, yoff)
		GameTooltip:ClearLines()		
		GameTooltip:AddDoubleLine(hexa..playerName.."'s"..hexb.." Guild", format(guildInfoString2, online, total))
		
		SortGuildTable(IsShiftKeyDown())
		
		if guildMotD ~= "" then 
			GameTooltip:AddLine(' ')
			GameTooltip:AddLine(format(guildMotDString, GUILD_MOTD, guildMotD), ttsubh.r, ttsubh.g, ttsubh.b, 1) 
		end
		
		local col = RGBToHex(ttsubh.r, ttsubh.g, ttsubh.b)
		
		local _, _, standingID, barMin, barMax, barValue = GetGuildFactionInfo()
		if standingID ~= 8 then -- Not Max Rep
			barMax = barMax - barMin
			barValue = barValue - barMin
			barMin = 0
			GameTooltip:AddLine(format(standingString, COMBAT_FACTION_CHANGE, ShortValue(barValue), ShortValue(barMax), ceil((barValue / barMax) * 100)))
		end
		
		local zonec, classc, levelc, info, grouped
		local shown = 0
		
		GameTooltip:AddLine(' ')
		for i = 1, #guildTable do
			-- if more then 30 guild members are online, we don't Show any more, but inform user there are more
			if 30 - shown <= 1 then
				if online - 30 > 1 then GameTooltip:AddLine(format(moreMembersOnlineString, online - 30), ttsubh.r, ttsubh.g, ttsubh.b) end
				break
			end

			info = guildTable[i]
			if GetRealZoneText() == info[4] then zonec = activezone else zonec = inactivezone end
			classc, levelc = (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS)[info[9]], GetQuestDifficultyColor(info[3])
			
			if (UnitInParty(info[1]) or UnitInRaid(info[1])) then grouped = 1 else grouped = 2 end

			if IsShiftKeyDown() then
				GameTooltip:AddDoubleLine(format(nameRankString, info[1], info[2]), info[4], classc.r, classc.g, classc.b, zonec.r, zonec.g, zonec.b)
				if info[5] ~= "" then GameTooltip:AddLine(format(noteString, info[5]), ttsubh.r, ttsubh.g, ttsubh.b, 1) end
				if info[6] ~= "" then GameTooltip:AddLine(format(officerNoteString, info[6]), ttoff.r, ttoff.g, ttoff.b, 1) end
			else
				GameTooltip:AddDoubleLine(format(levelNameStatusString, levelc.r*255, levelc.g*255, levelc.b*255, info[3], split("-", info[1]), groupedTable[grouped], info[8]), info[4], classc.r,classc.g,classc.b, zonec.r,zonec.g,zonec.b)
			end
			shown = shown + 1
		end	
		
		GameTooltip:Show()
		
		if not noUpdate then
			GuildRoster()
		end		
		GameTooltip:AddLine' '
		GameTooltip:AddLine("|cffeda55fLeft Click|r to Open Guild Roster")
		GameTooltip:AddLine("|cffeda55fHold Shift & Mouseover|r to See Guild and Officer Note's")
		GameTooltip:AddLine("|cffeda55fRight Click|r to open Options Menu")		
		GameTooltip:Show()
	end)

	plugin:SetScript("OnLeave", function() GameTooltip:Hide() end)
	plugin:SetScript("OnMouseDown", function(self, btn)
		if btn ~= "LeftButton" then return end
		ToggleGuildFrame()
	end)

	--plugin:RegisterEvent("GUILD_ROSTER_SHOW")
	plugin:RegisterEvent("PLAYER_ENTERING_WORLD")
	plugin:RegisterEvent("GUILD_ROSTER_UPDATE")
	plugin:RegisterEvent("PLAYER_GUILD_UPDATE")
	plugin:SetScript("OnEvent", Update)

	--return plugin -- important!
end

------------------------------------------------------------------------
--	 Professions Plugin Functions
------------------------------------------------------------------------
if cfg.pro and cfg.pro > 0 then

	local plugin = CreateFrame('Button', nil, Datapanel)
	plugin:RegisterEvent('PLAYER_ENTERING_WORLD')
	plugin:SetFrameStrata('BACKGROUND')
	plugin:SetFrameLevel(3)
	plugin:EnableMouse(true)
	plugin.tooltip = false

	local Text = plugin:CreateFontString(nil, 'OVERLAY')
	Text:SetFont(cfg.font, cfg.fontSize,'THINOUTLINE')
	PlacePlugin(cfg.pro, Text)

	local function Update(self)
		Text:SetFormattedText(hexa.."Professions"..hexb)
		self:SetAllPoints(Text)
	end

	plugin:SetScript('OnEnter', function()		
		local anchor, panel, xoff, yoff = DataTextTooltipAnchor(Text)
		GameTooltip:SetOwner(panel, anchor, xoff, yoff)
		GameTooltip:ClearLines()
		GameTooltip:AddLine(hexa..playerName.."'s"..hexb.." Professions")
		GameTooltip:AddLine' '
		for i = 1, select("#", GetProfessions()) do
			local v = select(i, GetProfessions());
			if v ~= nil then
				local name, texture, rank, maxRank = GetProfessionInfo(v)
				GameTooltip:AddDoubleLine(name, rank..' / '..maxRank,.75,.9,1,.3,1,.3)
			end
		end
		GameTooltip:AddLine' '
		GameTooltip:AddLine("|cffeda55fLeft Click|r to Open Profession #1")
		GameTooltip:AddLine("|cffeda55fMiddle Click|r to Open Spell Book")
		GameTooltip:AddLine("|cffeda55fRight Click|r to Open Profession #2")
		
		GameTooltip:Show()
	end)


	plugin:SetScript("OnClick",function(self,btn)
		local prof1, prof2 = GetProfessions()
		if btn == "LeftButton" then
			if prof1 then
				if(GetProfessionInfo(prof1) == ('Skinning')) then
					CastSpellByName("Skinning Skills")
				elseif(GetProfessionInfo(prof1) == ('Mining')) then
					CastSpellByName("Mining Skills")
				elseif(GetProfessionInfo(prof1) == ('Herbalism')) then
					CastSpellByName("Herbalism Skills")					
				else	
					CastSpellByName((GetProfessionInfo(prof1)))
				end
			else
				print('|cff33ff99BasicUILite:|r |cffFF0000No Profession Found!|r')
			end
		elseif btn == 'MiddleButton' then
			ToggleSpellBook(BOOKTYPE_PROFESSION)	
		elseif btn == "RightButton" then
			if prof2 then
				if(GetProfessionInfo(prof2) == ('Skinning')) then
					CastSpellByName("Skinning Skills")
				elseif(GetProfessionInfo(prof2) == ('Mining')) then
					CastSpellByName("Mining Skills")
				elseif(GetProfessionInfo(prof2) == ('Herbalism')) then
					CastSpellByName("Herbalism Skills")						
				else
					CastSpellByName((GetProfessionInfo(prof2)))
				end
			else
				print('|cff33ff99BasicUILite:|r |cffFF0000No Profession Found!|r')
			end
		end
	end)


	plugin:RegisterForClicks("AnyUp")
	plugin:SetScript('OnUpdate', Update)
	plugin:SetScript('OnLeave', function() GameTooltip:Hide() end)

	--return plugin -- important!
end

------------------------------------------------------------------------
--	 Recount DPS Plugin Functions
------------------------------------------------------------------------
if cfg.recount and cfg.recount > 0 then
		

	local math_abs=math.abs;
	local math_floor=math.floor;
	local math_log10=math.log10;
	local math_max=math.max;
	local tostring=tostring;
	 
	local NumberCaps={"K","M","B","T"};
	local function AbbreviateNumber(val)
		local exp=math_max(0,math_floor(math_log10(math_abs(val))));
		if exp<3 then return tostring(math_floor(val)); end
	 
		local factor=math_floor(exp/3);
		local precision=math_max(0,2-exp%3);
		return ((val<0 and "-" or "").."%0."..precision.."f%s"):format(val/1000^factor,NumberCaps[factor] or "e "..(factor*3));
	end

	
	local plugin = CreateFrame('Frame', nil, Datapanel)
	plugin:EnableMouse(true)
	plugin:SetFrameStrata("MEDIUM")
	plugin:SetFrameLevel(3)
	
	
	local Text  = plugin:CreateFontString(nil, "OVERLAY")
	Text:SetFont(cfg.font, cfg.fontSize,'THINOUTLINE')
	PlacePlugin(cfg.recount, Text)
	plugin:SetAllPoints(Text)
		

	function OnEvent(self, event, ...)
		if event == "PLAYER_LOGIN" then
			if IsAddOnLoaded("Recount") then
				plugin:RegisterEvent("PLAYER_REGEN_ENABLED")
				plugin:RegisterEvent("PLAYER_REGEN_DISABLED")
				playerName = UnitName("player")
				currentFightDPS = 0
			else
				return
			end
			plugin:UnregisterEvent("PLAYER_LOGIN")
			
		elseif event == "PLAYER_ENTERING_WORLD" then
			self.updateDPS()
			plugin:UnregisterEvent("PLAYER_ENTERING_WORLD")
		end
	end

	function plugin:RecountHook_UpdateText()
		self:updateDPS()
	end

	function plugin:updateDPS()
		if IsAddOnLoaded("Recount") then 
			Text:SetText(hexa.."DPS: "..hexb.. AbbreviateNumber(plugin.getDPS()) .. "|r")
		else
			Text:SetText(hexa.."DPS: "..hexb.. "N/A".."|r")
		end
	end

	function plugin:getDPS()
		if not IsAddOnLoaded("Recount") then return "N/A" end
		if cfg.recountraiddps == true then
			-- show raid dps
			_, dps = plugin:getRaidValuePerSecond(Recount.db.profile.CurDataSet)
			return dps
		else
			return plugin.getValuePerSecond()
		end
	end

	-- quick dps calculation from recount's data
	function plugin:getValuePerSecond()
		local _, dps = Recount:MergedPetDamageDPS(Recount.db2.combatants[playerName], Recount.db.profile.CurDataSet)
		return math.floor(10 * dps + 0.5) / 10
	end

	function plugin:getRaidValuePerSecond(tablename)
		local dps, curdps, data, damage, temp = 0, 0, nil, 0, 0
		for _,data in pairs(Recount.db2.combatants) do
			if data.Fights and data.Fights[tablename] and (data.type=="Self" or data.type=="Grouped" or data.type=="Pet" or data.type=="Ungrouped") then
				temp, curdps = Recount:MergedPetDamageDPS(data,tablename)
				if data.type ~= "Pet" or (not Recount.db.profile.MergePets and data.Owner and (Recount.db2.combatants[data.Owner].type=="Self" or Recount.db2.combatants[data.Owner].type=="Grouped" or Recount.db2.combatants[data.Owner].type=="Ungrouped")) or (not Recount.db.profile.MergePets and data.Name and data.GUID and self:matchUnitGUID(data.Name, data.GUID)) then
					dps = dps + 10 * curdps
					damage = damage + temp
				end
			end
		end
		return math.floor(damage + 0.5) / 10, math.floor(dps + 0.5)/10
	end

	-- tracked events
	plugin:RegisterEvent("PLAYER_LOGIN")
	plugin:RegisterEvent("PLAYER_ENTERING_WORLD")

	-- scripts
	plugin:SetScript("OnEnter", function(self)	
		local anchor, panel, xoff, yoff = DataTextTooltipAnchor(Text)
		GameTooltip:SetOwner(panel, anchor, xoff, yoff)
		GameTooltip:ClearLines()
		GameTooltip:AddLine(hexa..playerName.."'s"..hexb.." Damage")
		GameTooltip:AddLine' '		
		if IsAddOnLoaded("Recount") then
			local damage, dps = Recount:MergedPetDamageDPS(Recount.db2.combatants[playerName], Recount.db.profile.CurDataSet)
			local raid_damage, raid_dps = plugin:getRaidValuePerSecond(Recount.db.profile.CurDataSet)
			-- format the number
			dps = math.floor(10 * dps + 0.5) / 10
			GameTooltip:AddLine("Recount")
			GameTooltip:AddDoubleLine("Personal Damage:", AbbreviateNumber(damage), 1, 1, 1, 0.8, 0.8, 0.8)
			GameTooltip:AddDoubleLine("Personal DPS:", AbbreviateNumber(dps), 1, 1, 1, 0.8, 0.8, 0.8)
			GameTooltip:AddLine(" ")
			GameTooltip:AddDoubleLine("Raid Damage:", AbbreviateNumber(raid_damage), 1, 1, 1, 0.8, 0.8, 0.8)
			GameTooltip:AddDoubleLine("Raid DPS:", AbbreviateNumber(raid_dps), 1, 1, 1, 0.8, 0.8, 0.8)
			GameTooltip:AddLine(" ")
			GameTooltip:AddLine("|cffeda55fLeft Click|r to toggle Recount")
			GameTooltip:AddLine("|cffeda55fRight Click|r to reset data")
			GameTooltip:AddLine("|cffeda55fShift + Right Click|r to open config")
		else
			GameTooltip:AddLine("Recount is not loaded.", 255, 0, 0)
			GameTooltip:AddLine("Enable Recount and reload your UI.")
		end
		GameTooltip:Show()
	end)
	plugin:SetScript("OnMouseUp", function(self, button)
		if button == "RightButton" then
			if not IsShiftKeyDown() then
				Recount:ShowReset()
			else
				Recount:ShowConfig()
			end
		elseif button == "LeftButton" then
			if Recount.MainWindow:IsShown() then
				Recount.MainWindow:Hide()
			else
				Recount.MainWindow:Show()
				Recount:RefreshMainWindow()
			end
		end
	end)
	plugin:SetScript("OnEvent", OnEvent)
	plugin:SetScript("OnLeave", function() GameTooltip:Hide() end)
	plugin:SetScript("OnUpdate", function(self, t)
		local int = -1
		int = int - t
		if int < 0 then
			self.updateDPS()
			int = 1
		end
	end)

	--return plugin -- important!
end

------------------------------------------------------------------------
--	 Talent Spec Swap Plugin Functions
------------------------------------------------------------------------
if cfg.spec and cfg.spec > 0 then
	
	local plugin = CreateFrame('Frame', nil, Datapanel)
	plugin:EnableMouse(true)
	plugin:SetFrameStrata('BACKGROUND')
	plugin:SetFrameLevel(3)

	local Text = plugin:CreateFontString(nil, 'OVERLAY')
	Text:SetFont(cfg.font, cfg.fontSize,'THINOUTLINE')
	PlacePlugin(cfg.spec, Text)

	local talent = {}
	local active
	local talentString = string.join('', '|cffFFFFFF%s|r ')
	local activeString = string.join('', '|cff00FF00' , ACTIVE_PETS, '|r')
	local inactiveString = string.join('', '|cffFF0000', FACTION_INACTIVE, '|r')



	local function LoadTalentTrees()
		for i = 1, GetNumSpecGroups(false, false) do
			talent[i] = {} -- init talent group table
			for j = 1, GetNumSpecializations(false, false) do
				talent[i][j] = select(5, GetSpecializationInfo(j, false, false, i))
			end
		end
	end

	local int = 5
	local function Update(self, t)
		
		int = int - t
		if int > 0 then return end
		active = GetActiveSpecGroup(false, false)
		if playerRole~= nil then
			Text:SetFormattedText(talentString, hexa..select(2, GetSpecializationInfo(GetSpecialization(false, false, active)))..hexb)
		else
			Text:SetText(hexa.."No Spec"..hexb)
		end
		int = 2

		-- disable script	
		--self:SetScript('OnUpdate', nil)
		
	end


	plugin:SetScript('OnEnter', function(self)
		local anchor, panel, xoff, yoff = DataTextTooltipAnchor(Text)
		GameTooltip:SetOwner(panel, anchor, xoff, yoff)

		GameTooltip:ClearLines()
		GameTooltip:AddLine(hexa..playerName.."'s"..hexb.." Spec")
		GameTooltip:AddLine' '
		if playerRole ~= nil then
			for i = 1, GetNumSpecGroups() do
				if GetSpecialization(false, false, i) then
					GameTooltip:AddLine(string.join('- ', string.format(talentString, select(2, GetSpecializationInfo(GetSpecialization(false, false, i)))), (i == active and activeString or inactiveString)),1,1,1)
				end
			end
		else
			GameTooltip:AddLine("You have not chosen a Spec yet.")
		end
		GameTooltip:AddLine' '		
		GameTooltip:AddLine("|cffeda55fClick|r to Open Talent Tree")
		GameTooltip:Show()
	end)

	plugin:SetScript('OnLeave', function() GameTooltip:Hide() end)

	local function OnEvent(self, event, ...)
		if event == 'PLAYER_ENTERING_WORLD' then
			self:UnregisterEvent('PLAYER_ENTERING_WORLD')
		end
		
		-- load talent information
		LoadTalentTrees()

		-- Setup Talents Tooltip
		self:SetAllPoints(Text)

		-- update datatext
		if event ~= 'PLAYER_ENTERING_WORLD' then
			self:SetScript('OnUpdate', Update)
		end
	end



	plugin:RegisterEvent('PLAYER_ENTERING_WORLD');
	plugin:RegisterEvent('CHARACTER_POINTS_CHANGED');
	plugin:RegisterEvent('PLAYER_TALENT_UPDATE');
	plugin:RegisterEvent('ACTIVE_TALENT_GROUP_CHANGED')
	plugin:RegisterEvent("EQUIPMENT_SETS_CHANGED")
	plugin:SetScript('OnEvent', OnEvent)
	plugin:SetScript('OnUpdate', Update)

	plugin:SetScript("OnMouseDown", function() ToggleTalentFrame() end)

	--return plugin -- important!
end

------------------------------------------------------------------------
--	 Statistics Plugin Functions
------------------------------------------------------------------------
if cfg.stats and cfg.stats > 0 then
	
	local plugin = CreateFrame('Frame', nil, Datapanel)
	plugin:RegisterEvent("PLAYER_ENTERING_WORLD")
	plugin:SetFrameStrata("BACKGROUND")
	plugin:SetFrameLevel(3)
	plugin:EnableMouse(true)

	local Text = plugin:CreateFontString(nil, "OVERLAY")
	Text:SetFont(cfg.font, cfg.fontSize,'THINOUTLINE')
	PlacePlugin(cfg.stats, Text)

	local playerClass, englishClass = UnitClass("player");

	local function ShowTooltip(self)	
		local anchor, panel, xoff, yoff = DataTextTooltipAnchor(Text)
		GameTooltip:SetOwner(panel, anchor, xoff, yoff)
		GameTooltip:ClearLines()
		GameTooltip:AddLine(hexa..playerName.."'s"..hexb.." Statistics")
		GameTooltip:AddLine' '		
		if playerRole == nil then
			GameTooltip:AddLine("Choose a Specialization to see Stats")
		else
			if playerRole == "TANK" then
				local Total_Dodge = GetDodgeChance()
				local Total_Parry = GetParryChance()
				local Total_Block = GetBlockChance()
				
				GameTooltip:AddLine(STAT_CATEGORY_DEFENSE)
				GameTooltip:AddDoubleLine(DODGE_CHANCE, format("%.2f%%", Total_Dodge),1,1,1)
				GameTooltip:AddDoubleLine(PARRY_CHANCE, format("%.2f%%", Total_Parry),1,1,1)
				GameTooltip:AddDoubleLine(BLOCK_CHANCE, format("%.2f%%", Total_Block),1,1,1)				
				
			elseif playerRole == "HEALER" or playerRole == "CASTER" then
				local SC = GetSpellCritChance("2")
				local Total_Spell_Haste = UnitSpellHaste("player")
				local base, casting = GetManaRegen()
				local manaRegenString = "%d / %d"				
				
				GameTooltip:AddLine(STAT_CATEGORY_SPELL)
				GameTooltip:AddDoubleLine(STAT_CRITICAL_STRIKE, format("%.2f%%", SC), 1, 1, 1)
				GameTooltip:AddDoubleLine(STAT_HASTE, format("%.2f%%", Total_Spell_Haste), 1, 1, 1)		
				GameTooltip:AddDoubleLine(MANA_REGEN, format(manaRegenString, base * 5, casting * 5), 1, 1, 1)

			elseif playerRole == "DAMAGER" then			
				if englishClass == "HUNTER" then
					local Total_Range_Haste = GetRangedHaste("player")
					--local Range_Armor_Pen = GetArmorPenetration();
					local Range_Crit = GetRangedCritChance("25")
					local speed = UnitRangedDamage("player")
					local Total_Range_Speed = speed
					
					GameTooltip:AddLine(STAT_CATEGORY_RANGED)					
					--GameTooltip:AddDoubleLine("Armor Penetration", format("%.2f%%", Range_Armor_Pen), 1, 1, 1)
					GameTooltip:AddDoubleLine(STAT_CRITICAL_STRIKE, format("%.2f%%", Range_Crit), 1, 1, 1)	
					GameTooltip:AddDoubleLine(STAT_HASTE, format("%.2f%%", Total_Range_Haste), 1, 1, 1)
					GameTooltip:AddDoubleLine(STAT_ATTACK_SPEED, format("%.2f".." (sec)", Total_Range_Speed), 1, 1, 1)					
				else
					local Melee_Crit = GetCritChance("player")
					--local Melee_Armor_Pen = GetArmorPenetration();
					local Total_Melee_Haste = GetMeleeHaste("player")
					local mainSpeed = UnitAttackSpeed("player");
					local MH = mainSpeed
					
					GameTooltip:AddLine(STAT_CATEGORY_MELEE)
					--GameTooltip:AddDoubleLine("Armor Penetration", format("%.2f%%", Melee_Armor_Pen), 1, 1, 1)
					GameTooltip:AddDoubleLine(STAT_CRITICAL_STRIKE, format("%.2f%%", Melee_Crit), 1, 1, 1)		
					GameTooltip:AddDoubleLine(STAT_HASTE, format("%.2f%%", Total_Melee_Haste), 1, 1, 1)
					GameTooltip:AddDoubleLine(STAT_ATTACK_SPEED, format("%.2f".." (sec)", MH), 1, 1, 1)
				end
			end
			if GetCombatRating(CR_MASTERY) ~= 0 and GetSpecialization() then
				local masteryspell = GetSpecializationMasterySpells(GetSpecialization())
				local Mastery = GetMasteryEffect("player")
				local masteryName, _, _, _, _, _, _, _, _ = GetSpellInfo(masteryspell)
				if masteryName then
					GameTooltip:AddDoubleLine(masteryName, format("%.2f%%", Mastery), 1, 1, 1)
				end
			end
				
			GameTooltip:AddLine' '
			GameTooltip:AddLine(STAT_CATEGORY_GENERAL)
			
			local Life_Steal = GetLifesteal();
			--local Versatility = GetVersatility();
			local Versatility_Damage_Bonus = GetCombatRatingBonus(CR_VERSATILITY_DAMAGE_DONE) + GetVersatilityBonus(CR_VERSATILITY_DAMAGE_DONE);
			local Avoidance = GetAvoidance();
			--local bonusArmor, isNegatedForSpec = UnitBonusArmor("player");
			
			--GameTooltip:AddDoubleLine(STAT_BONUS_ARMOR, format("%s", bonusArmor), 1, 1, 1)
			GameTooltip:AddDoubleLine(STAT_LIFESTEAL, format("%.2f%%", Life_Steal), 1, 1, 1)
			GameTooltip:AddDoubleLine(STAT_VERSATILITY, format("%.2f%%", Versatility_Damage_Bonus), 1, 1, 1)
			--GameTooltip:AddDoubleLine(STAT_VERSATILITY, format("%d", Versatility), 1, 1, 1)
			GameTooltip:AddDoubleLine(STAT_AVOIDANCE, format("%.2f%%", Avoidance), 1, 1, 1)			
		end

		GameTooltip:Show()
	end

	local function UpdateTank(self)
		local armorString = hexa..ARMOR..hexb..": "
		local displayNumberString = string.join("", "%s", "%d|r");
		local base, effectiveArmor, armor, posBuff, negBuff = UnitArmor("player");
		local Melee_Reduction = effectiveArmor
		
		Text:SetFormattedText(displayNumberString, armorString, effectiveArmor)
		--Setup Tooltip
		self:SetAllPoints(Text)
	end

	local function UpdateCaster(self)
		local spellpwr = GetSpellBonusDamage("2");
		local displayNumberString = string.join("", "%s", "%d|r");
		
		Text:SetFormattedText(displayNumberString, hexa.."SP: "..hexb, spellpwr)
		--Setup Tooltip
		self:SetAllPoints(Text)
	end

	local function UpdateDamager(self)	
		local displayNumberString = string.join("", "%s", "%d|r");
			
		if englishClass == "HUNTER" then
			local base, posBuff, negBuff = UnitRangedAttackPower("player")
			local Range_AP = base + posBuff + negBuff	
			pwr = Range_AP
		else
			local base, posBuff, negBuff = UnitAttackPower("player")
			local Melee_AP = base + posBuff + negBuff		
			pwr = Melee_AP
		end
		
		Text:SetFormattedText(displayNumberString, hexa.."AP: "..hexb, pwr)      
		--Setup Tooltip
		self:SetAllPoints(Text)
	end

	-- initial delay for update (let the ui load)
	local int = 5	
	local function Update(self, t)
		int = int - t
		if int > 0 then return end
		if playerRole == nil then
			Text:SetText(hexa.."No Stats"..hexb)
		else
			if playerRole == "TANK" then 
				UpdateTank(self)
			elseif playerRole == "HEALER" or playerRole == "CASTER" then
				UpdateCaster(self)
			elseif playerRole == "DAMAGER" then
				UpdateDamager(self)
			end
		end
		int = 2
	end

	plugin:SetScript("OnEnter", function() ShowTooltip(plugin) end)
	plugin:SetScript("OnLeave", function() GameTooltip:Hide() end)
	plugin:SetScript("OnUpdate", Update)
	Update(plugin, 10)

	--return plugin -- important!
end

------------------------------------------------------------------------
--	 System Settings Plugin Functions
------------------------------------------------------------------------
if cfg.system and cfg.system > 0 then
	
	local plugin = CreateFrame('Frame', nil, Datapanel)
	plugin:RegisterEvent("PLAYER_ENTERING_WORLD")
	plugin:SetFrameStrata("BACKGROUND")
	plugin:SetFrameLevel(3)
	plugin:EnableMouse(true)
	plugin.tooltip = false

	local Text = plugin:CreateFontString(nil, "OVERLAY")
	Text:SetFont(cfg.font, cfg.fontSize,'THINOUTLINE')
	PlacePlugin(cfg.system, Text)

		local bandwidthString = "%.2f Mbps"
		local percentageString = "%.2f%%"
		local homeLatencyString = "%d ms"
		local worldLatencyString = "%d ms"
		local kiloByteString = "%d kb"
		local megaByteString = "%.2f mb"

		local function formatMem(memory)
			local mult = 10^1
			if memory > 999 then
				local mem = ((memory/1024) * mult) / mult
				return string.format(megaByteString, mem)
			else
				local mem = (memory * mult) / mult
				return string.format(kiloByteString, mem)
			end
		end

		local memoryTable = {}

		local function RebuildAddonList(self)
			local addOnCount = GetNumAddOns()
			if (addOnCount == #memoryTable) or self.tooltip == true then return end

			-- Number of loaded addons changed, create new memoryTable for all addons
			memoryTable = {}
			for i = 1, addOnCount do
				memoryTable[i] = { i, select(2, GetAddOnInfo(i)), 0, IsAddOnLoaded(i) }
			end
			self:SetAllPoints(Text)
		end

		local function UpdateMemory()
			-- Update the memory usages of the addons
			UpdateAddOnMemoryUsage()
			-- Load memory usage in table
			local addOnMem = 0
			local totalMemory = 0
			for i = 1, #memoryTable do
				addOnMem = GetAddOnMemoryUsage(memoryTable[i][1])
				memoryTable[i][3] = addOnMem
				totalMemory = totalMemory + addOnMem
			end
			-- Sort the table to put the largest addon on top
			table.sort(memoryTable, function(a, b)
				if a and b then
					return a[3] > b[3]
				end
			end)
			
			return totalMemory
		end

		-- initial delay for update (let the ui load)
		local int, int2 = 6, 5
		local statusColors = {
			"|cff0CD809",
			"|cffE8DA0F",
			"|cffFF9000",
			"|cffD80909"
		}

		local function Update(self, t)
			int = int - t
			int2 = int2 - t
			
			if int < 0 then
				RebuildAddonList(self)
				int = 10
			end
			if int2 < 0 then
				local framerate = floor(GetFramerate())
				local fpscolor = 4
				local latency = select(4, GetNetStats()) 
				local latencycolor = 4
							
				if latency < 150 then
					latencycolor = 1
				elseif latency >= 150 and latency < 300 then
					latencycolor = 2
				elseif latency >= 300 and latency < 500 then
					latencycolor = 3
				end
				if framerate >= 30 then
					fpscolor = 1
				elseif framerate >= 20 and framerate < 30 then
					fpscolor = 2
				elseif framerate >= 10 and framerate < 20 then
					fpscolor = 3
				end
				local displayFormat = string.join("", hexa.."Framerate: "..hexb, statusColors[fpscolor], "%d|r")
				Text:SetFormattedText(displayFormat, framerate, latency)
				int2 = 1
			end
		end
		plugin:SetScript("OnMouseDown", function () collectgarbage("collect") Update(plugin, 20) end)
		plugin:SetScript("OnEnter", function(self)		
			local bandwidth = GetAvailableBandwidth()
			local _, _, latencyHome, latencyWorld = GetNetStats() 
			local anchor, panel, xoff, yoff = DataTextTooltipAnchor(Text)
			GameTooltip:SetOwner(panel, anchor, xoff, yoff)
			GameTooltip:ClearLines()
			GameTooltip:AddLine(hexa..playerName.."'s"..hexb.." Latency")
			GameTooltip:AddLine' '			
			GameTooltip:AddDoubleLine("Home Latency: ", string.format(homeLatencyString, latencyHome), 0.80, 0.31, 0.31,0.84, 0.75, 0.65)
			GameTooltip:AddDoubleLine("World Latency: ", string.format(worldLatencyString, latencyWorld), 0.80, 0.31, 0.31,0.84, 0.75, 0.65)

			if bandwidth ~= 0 then
				GameTooltip:AddDoubleLine(L.datatext_bandwidth , string.format(bandwidthString, bandwidth),0.69, 0.31, 0.31,0.84, 0.75, 0.65)
				GameTooltip:AddDoubleLine("Download: " , string.format(percentageString, GetDownloadedPercentage() *100),0.69, 0.31, 0.31, 0.84, 0.75, 0.65)
				GameTooltip:AddLine(" ")
			end
			local totalMemory = UpdateMemory()
			GameTooltip:AddDoubleLine("Total Memory Usage:", formatMem(totalMemory), 0.69, 0.31, 0.31,0.84, 0.75, 0.65)
			GameTooltip:AddLine(" ")
			for i = 1, #memoryTable do
				if (memoryTable[i][4]) then
					local red = memoryTable[i][3] / totalMemory
					local green = 1 - red
					GameTooltip:AddDoubleLine(memoryTable[i][2], formatMem(memoryTable[i][3]), 1, 1, 1, red, green + .5, 0)
				end						
			end
			GameTooltip:Show()
		end)
		plugin:SetScript("OnLeave", function() GameTooltip:Hide() end)
		plugin:SetScript("OnUpdate", Update)
		Update(plugin, 10)

	--return plugin -- important!
end		