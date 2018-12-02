local _, BasicUILite = ...
local cfg = BasicUILite.NAMEPLATES

if cfg.enable ~= true then return end

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
	return ((val<0 and "-" or "").."%0."..precision.."f%s"):format(val/1000^factor,NumberCaps[factor] or "e"..(factor*3));
end

-------------------------------------------------
-- Borrowerd from nPlates by Grimsbain
-------------------------------------------------
local nameplateFrame = CreateFrame("Frame")

local len = string.len
local gsub = string.gsub

---------------
-- Functions
---------------

	-- PvP Icon
local pvpIcons = {
	Alliance = "\124TInterface/PVPFrame/PVP-Currency-Alliance:16\124t",
	Horde = "\124TInterface/PVPFrame/PVP-Currency-Horde:16\124t",
}

nameplateFrame.PvPIcon = function(unit)
	if ( cfg.ShowPvP and UnitIsPlayer(unit) ) then
		local isPVP = UnitIsPVP(unit)
		local faction = UnitFactionGroup(unit)
		local icon = (isPVP and faction) and pvpIcons[faction] or ""

		return icon
	end
	return ""
end

	-- Check for "Larger Nameplates"

nameplateFrame.IsUsingLargerNamePlateStyle = function()
	local namePlateVerticalScale = tonumber(GetCVar("NamePlateVerticalScale"))
	return namePlateVerticalScale > 1.0
end

	-- Check if the frame is a nameplate.

nameplateFrame.FrameIsNameplate = function(frame)
	if ( string.match(frame.displayedUnit,"nameplate") ~= "nameplate") then
		return false
	else
		return true
	end
end

	-- Checks to see if target has tank role.

nameplateFrame.PlayerIsTank = function(target)
	local assignedRole = UnitGroupRolesAssigned(target)

	return assignedRole == "TANK"
end

	-- Abbreviate Function

nameplateFrame.Abbrev = function(str,length)
	if ( str ~= nil and length ~= nil ) then
		str = (len(str) > length) and gsub(str, "%s?(.[\128-\191]*)%S+%s", "%1. ") or str
		return str
	end
	return ""
end

	-- RBG to Hex Colors

nameplateFrame.RGBHex = function(r, g, b)
	if ( type(r) == "table" ) then
		if ( r.r ) then
			r, g, b = r.r, r.g, r.b
		else
			r, g, b = unpack(r)
		end
	end

	return ("|cff%02x%02x%02x"):format(r * 255, g * 255, b * 255)
end

-- Off Tank Color Checks

nameplateFrame.UseOffTankColor = function(target)
	if ( cfg.UseOffTankColor and (UnitPlayerOrPetInRaid(target) or UnitPlayerOrPetInParty(target)) ) then
		if ( not UnitIsUnit("player",target) and nameplateFrame.PlayerIsTank(target) and nameplateFrame.PlayerIsTank("player") ) then
			return true
		end
	end
	return false
end

	-- Totem Data and Functions

local function TotemName(SpellID)
	local name = GetSpellInfo(SpellID)
	return name
end

local totemData = {
	[TotemName(192058)] = "Interface\\Icons\\spell_nature_brilliance",          -- Lightning Surge Totem
	[TotemName(98008)]  = "Interface\\Icons\\spell_shaman_spiritlink",          -- Spirit Link Totem
	[TotemName(192077)] = "Interface\\Icons\\ability_shaman_windwalktotem",     -- Wind Rush Totem
	[TotemName(204331)] = "Interface\\Icons\\spell_nature_wrathofair_totem",    -- Counterstrike Totem
	[TotemName(204332)] = "Interface\\Icons\\spell_nature_windfury",            -- Windfury Totem
	[TotemName(204336)] = "Interface\\Icons\\spell_nature_groundingtotem",      -- Grounding Totem
	-- Water
	[TotemName(157153)] = "Interface\\Icons\\ability_shaman_condensationtotem", -- Cloudburst Totem
	[TotemName(5394)]   = "Interface\\Icons\\INV_Spear_04",                     -- Healing Stream Totem
	[TotemName(108280)] = "Interface\\Icons\\ability_shaman_healingtide",       -- Healing Tide Totem
	-- Earth
	[TotemName(207399)] = "Interface\\Icons\\spell_nature_reincarnation",       -- Ancestral Protection Totem
	[TotemName(198838)] = "Interface\\Icons\\spell_nature_stoneskintotem",      -- Earthen Shield Totem
	[TotemName(51485)]  = "Interface\\Icons\\spell_nature_stranglevines",       -- Earthgrab Totem
	[TotemName(61882)]  = "Interface\\Icons\\spell_shaman_earthquake",          -- Earthquake Totem
	[TotemName(196932)] = "Interface\\Icons\\spell_totem_wardofdraining",       -- Voodoo Totem
	-- Fire
	[TotemName(192222)] = "Interface\\Icons\\spell_shaman_spewlava",            -- Liquid Magma Totem
	[TotemName(204330)] = "Interface\\Icons\\spell_fire_totemofwrath",          -- Skyfury Totem
	-- Totem Mastery
	[TotemName(202188)] = "Interface\\Icons\\spell_nature_stoneskintotem",      -- Resonance Totem
	[TotemName(210651)] = "Interface\\Icons\\spell_shaman_stormtotem",          -- Storm Totem
	[TotemName(210657)] = "Interface\\Icons\\spell_fire_searingtotem",          -- Ember Totem
	[TotemName(210660)] = "Interface\\Icons\\spell_nature_invisibilitytotem",   -- Tailwind Totem
}

nameplateFrame.UpdateTotemIcon = function(frame)
	if ( not nameplateFrame.FrameIsNameplate(frame) ) then return end

	local name = UnitName(frame.displayedUnit)

	if name == nil then return end
	if (totemData[name] and cfg.ShowTotemIcon ) then
		if (not frame.TotemIcon) then
			frame.TotemIcon = CreateFrame("Frame", "$parentTotem", frame)
			frame.TotemIcon:EnableMouse(false)
			frame.TotemIcon:SetSize(24, 24)
			frame.TotemIcon:SetPoint("BOTTOM", frame.BuffFrame, "TOP", 0, 10)
		end

		if (not frame.TotemIcon.Icon) then
			frame.TotemIcon.Icon = frame.TotemIcon:CreateTexture("$parentIcon","BACKGROUND")
			frame.TotemIcon.Icon:SetSize(24,24)
			frame.TotemIcon.Icon:SetAllPoints(frame.TotemIcon)
			frame.TotemIcon.Icon:SetTexture(totemData[name])
			frame.TotemIcon.Icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
		end

		if (not frame.TotemIcon.Icon.Border) then
			frame.TotemIcon.Icon.Border = frame.TotemIcon:CreateTexture("$parentOverlay", "BORDER")
			frame.TotemIcon.Icon.Border:SetTexCoord(0, 1, 0, 1)
			frame.TotemIcon.Icon.Border:ClearAllPoints()
			frame.TotemIcon.Icon.Border:SetPoint("TOPRIGHT", frame.TotemIcon.Icon, 2.5, 2.5)
			frame.TotemIcon.Icon.Border:SetPoint("BOTTOMLEFT", frame.TotemIcon.Icon, -2.5, -2.5)
			frame.TotemIcon.Icon.Border:SetTexture(iconOverlay)
			frame.TotemIcon.Icon.Border:SetVertexColor(unpack(borderColor))
		end

		if ( frame.TotemIcon ) then
			frame.TotemIcon:Show()
		end
	else
		if (frame.TotemIcon) then
			frame.TotemIcon:Hide()
		end
	end
end

	-- Set Defaults

--[[nameplates.RegisterDefaultSetting = function(key,value)
	if ( BasicUILite_DB == nil ) then
		BasicUILite_DB = {}
	end
	if ( BasicUILite_DB[key] == nil ) then
		BasicUILite_DB[key] = value
	end
end	]]


C_Timer.After(.1, function()
		-- Set CVars
	if not InCombatLockdown() then
		-- Set min and max scale.
		SetCVar("namePlateMinScale", 1)
		SetCVar("namePlateMaxScale", 1)

		-- Set sticky nameplates.
		if ( not cfg.DontClamp ) then
			SetCVar("nameplateOtherTopInset", -1,true)
			SetCVar("nameplateOtherBottomInset", -1,true)
		else
			for _, v in pairs({"nameplateOtherTopInset", "nameplateOtherBottomInset"}) do SetCVar(v, GetCVarDefault(v),true) end
		end
	end
end)

-----------------
-- Update Name
-----------------
hooksecurefunc("CompactUnitFrame_UpdateName", function(frame)
	if ( not nameplateFrame.FrameIsNameplate(frame) ) then return end

		-- Totem Icon

	if ( cfg.ShowTotemIcon ) then
		nameplateFrame.UpdateTotemIcon(frame)
	end

		-- Hide Friendly Nameplates

	if ( UnitIsFriend(frame.displayedUnit,"player") and not UnitCanAttack(frame.displayedUnit,"player") and cfg.HideFriendly ) then
		frame.healthBar:Hide()
	else
		frame.healthBar:Show()
	end

	if ( not ShouldShowName(frame) ) then
		frame.name:Hide()
	else

			-- PvP Icon

		local pvpIcon = nameplateFrame.PvPIcon(frame.displayedUnit)

			-- Class Color Names

		if ( UnitIsPlayer(frame.displayedUnit) ) then
			local r,g,b = frame.healthBar:GetStatusBarColor()
			frame.name:SetTextColor(r,g,b)
		end

			-- Shorten Long Names

		local newName, realm = UnitName(frame.displayedUnit) or UNKNOWN

		if ( cfg.ShowServerName ) then
			name = name.." - "..realm
		end
		if ( cfg.AbrrevLongNames ) then
			newName = nameplateFrame.Abbrev(newName,20)
		end

			-- Level

		if ( cfg.ShowLevel ) then
			local playerLevel = UnitLevel("player")
			local targetLevel = UnitLevel(frame.displayedUnit)
			local difficultyColor = GetRelativeDifficultyColor(playerLevel, targetLevel)
			local levelColor = nameplateFrame.RGBHex(difficultyColor.r, difficultyColor.g, difficultyColor.b)

			if ( targetLevel == -1 ) then
				frame.name:SetText(pvpIcon..newName)
			else
				frame.name:SetText(pvpIcon.."|cffffff00|r"..levelColor..targetLevel.."|r "..newName)
			end
		else
			frame.name:SetText(pvpIcon..newName or newName)
		end

			-- Color Name To Threat Status

		if ( cfg.ColorNameByThreat ) then
			local isTanking, threatStatus = UnitDetailedThreatSituation("player", frame.displayedUnit)
			if ( isTanking and threatStatus ) then
				if ( threatStatus >= 3 ) then
					frame.name:SetTextColor(0,1,0)
				elseif ( threatStatus == 2 ) then
					frame.name:SetTextColor(1,0.6,0.2)
				end
			else
				local target = frame.displayedUnit.."target"
				if ( nameplateFrame.UseOffTankColor(target) ) then
					frame.name:SetTextColor(cfg.OffTankColor.r, cfg.OffTankColor.g, cfg.OffTankColor.b)
				end
			end
		end
	end
end)

	-- Updated Health Text

hooksecurefunc("CompactUnitFrame_UpdateStatusText", function(frame)
	if ( not nameplateFrame.FrameIsNameplate(frame) ) then return end

	local font = select(1,frame.name:GetFont())
	local hexa = ("|cff%.2x%.2x%.2x"):format(255, 255, 51)
	local hexb = "|r"

	if ( cfg.ShowHP ) then
		if ( not frame.healthBar.healthString ) then
			frame.healthBar.healthString = frame.healthBar:CreateFontString("$parentHeathValue", "OVERLAY")
			frame.healthBar.healthString:Hide()
			frame.healthBar.healthString:SetPoint("CENTER", frame.healthBar, 0, .5)
			frame.healthBar.healthString:SetFont(font, 12)
			frame.healthBar.healthString:SetShadowOffset(.5, -.5)
		end
	else
		if ( frame.healthBar.healthString ) then frame.healthBar.healthString:Hide() end
		return
	end

	local health = UnitHealth(frame.displayedUnit)
	local maxHealth = UnitHealthMax(frame.displayedUnit)
	local perc = (health/maxHealth)*100

	if ( perc >= 100 and health > 5 and cfg.ShowFullHP ) then
		if ( cfg.ShowCurHP and perc >= 100 ) then
			frame.healthBar.healthString:SetFormattedText(hexa.."%s"..hexb, AbbreviateNumber(health))
		elseif ( cfg.ShowCurHP and cfg.ShowPercHP ) then
			frame.healthBar.healthString:SetFormattedText(hexa.."%s - %s%%"..hexb, AbbreviateNumber(health), AbbreviateNumber(perc))
		elseif ( cfg.ShowCurHP ) then
			frame.healthBar.healthString:SetFormattedText(hexa.."%s"..hexb, AbbreviateNumber(health))
		elseif ( cfg.ShowPercHP ) then
			frame.healthBar.healthString:SetFormattedText(hexa.."%s%%"..hexb, AbbreviateNumber(perc))
		else
			frame.healthBar.healthString:SetText("")
		end
	elseif ( perc < 100 and health > 5 ) then
		if ( cfg.ShowCurHP and cfg.ShowPercHP ) then
			frame.healthBar.healthString:SetFormattedText(hexa.."%s - %s%%"..hexb, AbbreviateNumber(health), AbbreviateNumber(perc))
		elseif ( cfg.ShowCurHP ) then
			frame.healthBar.healthString:SetFormattedText(hexa.."%s"..hexb, AbbreviateNumber(health))
		elseif ( cfg.ShowPercHP ) then
			frame.healthBar.healthString:SetFormattedText(hexa.."%s%%"..hexb, AbbreviateNumber(perc))
		else
			frame.healthBar.healthString:SetText("")
		end
	else
		frame.healthBar.healthString:SetText("")
	end
	frame.healthBar.healthString:Show()
end)	