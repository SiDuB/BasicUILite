local _, BasicUILite = ...

SlashCmdList['RELOADUI'] = function()
	ReloadUI()
end
SLASH_RELOADUI1 = '/rl'

BasicUILite_DB = {}

BasicUILite.BUFFS ={
	enable = true,
	scale = 1.193,
}

BasicUILite.CHAT = {
	enable = true,
}

BasicUILite.DATATEXT = {
	enable = true,
	
	font = [[_retail_\Interface\AddOns\BasicUILite\Media\Expressway_Free_NORMAL.ttf]],
	fontSize = 17,
		
	bg_pvp = true,          	-- enable 3 stats in battleground only that replace stat1,stat2,stat3.
	bag = false,				-- True = Open Backpack; False = Open All bags			
	recountraiddps 	= false,	-- Enables tracking or Recounts Raid DPS
	
	
	-- Color Datatext	
	customcolor = { r = 1, g = 1, b = 1},				-- Color of Text for Datapanel
	classcolor = true,			-- Enable Class Color for Text
	
	-- Stat Locations
	bags			= 9,		-- show space used in bags on panel.	
	system 			= 1,		-- show total memory and others systems info (FPS/MS) on panel.	
	guild 			= 4,		-- show number on guildmate connected on panel.
	dur 			= 8,		-- show your equipment durability on panel.
	friends 		= 6,		-- show number of friends connected.
	spec 			= 5,		-- show your current spec on panel.
	coords 			= 0,		-- show your current coords on panel.
	pro 			= 7,		-- shows your professions and tradeskills
	stats 			= 3,		-- Stat Based on your Role (Avoidance-Tank, AP-Melee, SP/HP-Caster)
	recount 		= 2,		-- Stat Based on Recount"s DPS	
	calltoarms 		= 0,		-- Show Current Call to Arms.
	dps				= 0,		-- Show total dps.
}

BasicUILite.EXTRAS = {
	enable = true,
	altbuy = true,
	auction = true,
	autogreed = true,
	coords = true,
	ilvlchange = true,
	hpd = true,
	massprospect = true,
	merchant = true,
	minimap = true,
	orderhall = true,
	powerbar = {
		enable = true,
		position = {'CENTER', UIParent, 0, -110},
		sizeWidth = 200,
		scale = 1.0,

		showCombatRegen = true,

		activeAlpha = 1,
		inactiveAlpha = 0.3,
		emptyAlpha = 0,

		valueAbbrev = true,

		valueFont = [[_retail_\Interface\AddOns\BasicUILite\Media\Expressway_Free_NORMAL.ttf]],
		valueFontSize = 20,
		valueFontOutline = true,
		valueFontAdjustmentX = 0,

		showSoulshards = true,
		showHolypower = true,
		showComboPoints = true,
		showChi = true,
		showRunes = true,
		showArcaneCharges = true,

		-- Resource text shown above the bar.
		extraFont = [[_retail_\Interface\AddOns\BasicUILite\Media\Expressway_Free_NORMAL.ttf]],
		extraFontSize = 22,
		extraFontOutline = true,

		hp = {
			show = false,
			hpFont = [[_retail_\Interface\AddOns\BasicUILite\Media\Expressway_Free_NORMAL.ttf]],
			hpFontOutline = true,
			hpFontSize = 25,
			hpFontColor = {0.0, 1.0, 0.0},
			hpFontHeightAdjustment = 10,
		},

		mana = {
			show = true,
		},

		energy = {
			show = true,
		},

		focus = {
			show = true,
		},

		rage = {
			show = true,
		},

		lunarPower = {
			show = true,
		},

		rune = {
			show = true,

			runeFont = [[_retail_\Interface\AddOns\BasicUILite\Media\Expressway_Free_NORMAL.ttf]],
			runeFontSize = 22,
			runeFontOutline = true,
		},

		insanity = {
			show = true,
		},

		maelstrom = {
			show = true,
		},

		fury = {
			show = true,
		},

		pain = {
			show = true,
		},
	},
	rarealert = true,

}

BasicUILite.FONTS = {
	enable = true,
	NormalFont = [[_retail_\Interface\AddOns\BasicUILite\Media\Expressway_Free_NORMAL.ttf]],
	BoldFont = [[_retail_\Interface\AddOns\BasicUILite\Media\Expressway_Rg_BOLD.ttf]],
	ItalicFont 	= [[_retail_\Interface\AddOns\BasicUILite\Media\Expressway_Sb_ITALIC.ttf]],
}

BasicUILite.NAMEPLATES = {
	enable = true,
	ColorNameByThreat = false,
	ShowHP = true,
	ShowCurHP = true,
	ShowPercHP = true,
	ShowFullHP = true,
	ShowLevel = true,
	ShowServerName = false,
	AbrrevLongNames = true,
	HideFriendly = false,
	DontClamp = false,
	ShowTotemIcon = false,
	UseOffTankColor = false,
	OffTankColor = { r = 0.60, g = 0.20, b = 1.0},
	ShowPvP = false,	
}

BasicUILite.TOOLTIP = {
	enable = true,
    fontSize = 15,
    fontOutline = false,

    showOnMouseover = false,
    hideInCombat = false,                       -- Hide unit frame tooltips during combat

    reactionBorderColor = false,
    itemqualityBorderColor = true,

    abbrevRealmNames = false,
    showPlayerTitles = true,
    showUnitRole = true,
    showPVPIcons = false,                       -- Show pvp icons instead of just a prefix
    showMouseoverTarget = true,
    showSpecializationIcon = true,

    healthbar = {
        showHealthValue = true,

        healthFormat = "$cur / $max",           -- Possible: $cur, $max, $deficit, $perc, $smartperc, $smartcolorperc, $colorperc
        healthFullFormat = "$cur",              -- if the tooltip unit has 100% hp

        fontSize = 13,
        font = STANDARD_TEXT_FONT,
        showOutline = true,
        textPos = "CENTER",                     -- Possible "TOP" "BOTTOM" "CENTER"

        reactionColoring = false,               -- Overrides customColor
        customColor = {
            apply = false,
            r = 0,
            g = 1,
            b = 1
        }
    },
}

BasicUILite.UNITFRAMES = {
	enable = true,
	UnitScale = 1.2,
	UnitframeFont = [[_retail_\Interface\AddOns\BasicUILite\Media\Expressway_Rg_BOLD.ttf]],
}