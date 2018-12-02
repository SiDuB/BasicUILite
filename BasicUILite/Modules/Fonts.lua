local _, BasicUILite = ...
local cfg = BasicUILite.FONTS

if cfg.enable ~= true then return end

local function SetFont(obj, font, size, style, r, g, b, sr, sg, sb, sox, soy)
	obj:SetFont(font, size, style)
	if sr and sg and sb then obj:SetShadowColor(sr, sg, sb) end
	if sox and soy then obj:SetShadowOffset(sox, soy) end
	if r and g and b then obj:SetTextColor(r, g, b)
	elseif r then obj:SetAlpha(r) end
end


UIDROPDOWNMENU_DEFAULT_TEXT_HEIGHT = 14
CHAT_FONT_HEIGHTS = {12, 13, 14, 15, 16, 17}

local FONTZ = false -- Set to true only if you have not changed your master fonts.

if FONTZ == true then
	UNIT_NAME_FONT     			= cfg.NormalFont
	DAMAGE_TEXT_FONT   			= cfg.NormalFont
	STANDARD_TEXT_FONT			= cfg.NormalFont
	NAMEPLATE_SPELLCAST_FONT    = cfg.NormalFont
end


-- Font Normally Used FRIZQT__.TTF
SetFont(SystemFont_Tiny,                	cfg.NormalFont, 11);
SetFont(SystemFont_Small,                	cfg.NormalFont, 13);
SetFont(SystemFont_Outline_Small,           cfg.NormalFont, 13, "OUTLINE");
SetFont(SystemFont_Outline,                	cfg.NormalFont, 15);					-- Pet level on World map
SetFont(SystemFont_Shadow_Small,            cfg.NormalFont, 13);
SetFont(SystemFont_InverseShadow_Small,		cfg.NormalFont, 13);
SetFont(SystemFont_Med1,                	cfg.NormalFont, 15);
SetFont(SystemFont_Shadow_Med1,             cfg.NormalFont, 15);
SetFont(SystemFont_Med2,                	cfg.NormalFont, 15, nil, 0.15, 0.09, 0.04);
SetFont(SystemFont_Shadow_Med2,             cfg.NormalFont, 15);
SetFont(SystemFont_Med3,                	cfg.NormalFont, 15);
SetFont(SystemFont_Shadow_Med3,             cfg.NormalFont, 15);
SetFont(SystemFont_Large,                	cfg.BoldFont, 	17);
SetFont(SystemFont_Shadow_Large,            cfg.BoldFont, 	17);
SetFont(SystemFont_Huge1,                	cfg.BoldFont, 	20);
SetFont(SystemFont_Shadow_Huge1,            cfg.BoldFont, 	20);
SetFont(SystemFont_OutlineThick_Huge2,      cfg.BoldFont, 	22, "THICKOUTLINE");
SetFont(SystemFont_Shadow_Outline_Huge2,    cfg.BoldFont, 	22, "OUTLINE");
SetFont(SystemFont_Shadow_Huge3,            cfg.BoldFont, 	25);
SetFont(SystemFont_OutlineThick_Huge4,      cfg.BoldFont, 	26, "THICKOUTLINE");
SetFont(SystemFont_OutlineThick_WTF,        cfg.BoldFont, 	32, "THICKOUTLINE");	-- World Map
SetFont(SubZoneTextFont,					cfg.BoldFont, 	26, "OUTLINE");			-- World Map(SubZone)
SetFont(GameTooltipHeader,                	cfg.BoldFont, 	18);
SetFont(SpellFont_Small,                	cfg.NormalFont, 13);
SetFont(InvoiceFont_Med,                	cfg.NormalFont, 15, nil, 0.15, 0.09, 0.04);
SetFont(InvoiceFont_Small,                	cfg.NormalFont, 13, nil, 0.15, 0.09, 0.04);
SetFont(Tooltip_Med,                		cfg.NormalFont, 15);
SetFont(Tooltip_Small,                		cfg.NormalFont, 13);
SetFont(AchievementFont_Small,              cfg.NormalFont, 13);
SetFont(ReputationDetailFont,               cfg.NormalFont, 12, nil, nil, nil, nil, 0, 0, 0, 1, -1);
SetFont(GameFont_Gigantic,                	cfg.BoldFont, 	32, nil, nil, nil, nil, 0, 0, 0, 1, -1);

-- Font Normally Used ARIALN.TTF
SetFont(NumberFont_Shadow_Small,			cfg.BoldFont, 13);
SetFont(NumberFont_OutlineThick_Mono_Small,	cfg.BoldFont, 13, "OUTLINE");
SetFont(NumberFont_Shadow_Med,              cfg.BoldFont, 15);
SetFont(NumberFont_Outline_Med,             cfg.BoldFont, 15, "OUTLINE");
SetFont(NumberFont_Outline_Large,           cfg.BoldFont, 17, "OUTLINE");
SetFont(NumberFont_GameNormal,				cfg.BoldFont, 13);
SetFont(FriendsFont_UserText,               cfg.BoldFont, 15);

-- Font Normally Used skurri.ttf
SetFont(NumberFont_Outline_Huge,            cfg.BoldFont, 30, "THICKOUTLINE");

-- Font Normally Used MORPHEUS.ttf
SetFont(QuestFont_Large,                	cfg.ItalicFont, 17)
SetFont(QuestFont_Shadow_Huge,              cfg.ItalicFont, 18, nil, nil, nil, nil, 0.54, 0.4, 0.1);
SetFont(QuestFont_Shadow_Small,             cfg.ItalicFont, 13)
SetFont(MailFont_Large,                		cfg.ItalicFont, 17, nil, 0.15, 0.09, 0.04, 0.54, 0.4, 0.1, 1, -1);

-- Font Normally Used FRIENDS.TTF
SetFont(FriendsFont_Normal,                	cfg.NormalFont, 15, nil, nil, nil, nil, 0, 0, 0, 1, -1);
SetFont(FriendsFont_Small,                	cfg.NormalFont, 13, nil, nil, nil, nil, 0, 0, 0, 1, -1);
SetFont(FriendsFont_Large,                	cfg.BoldFont, 	17, nil, nil, nil, nil, 0, 0, 0, 1, -1);


SetFont(GameFontNormalSmall,                cfg.BoldFont, 	13);
SetFont(GameFontNormal,                		cfg.NormalFont, 15);
SetFont(GameFontNormalLarge,                cfg.BoldFont, 	17);
SetFont(GameFontNormalHuge,                	cfg.BoldFont, 	20);
SetFont(GameFontHighlightSmallLeft,			cfg.NormalFont, 15);
SetFont(GameNormalNumberFont,               cfg.BoldFont, 	13);



for i=1,7 do
	local f = _G["ChatFrame"..i]
	local font, size = f:GetFont()
	f:SetFont(cfg.NormalFont, size)
end

--[[ I have no idea why the channel list is getting fucked up
-- but re-setting the font obj seems to fix it
for i=1,20 do
	local f = _G["ChannelButton"..i.."Text"]
	f:SetFontObject(GameFontNormalSmallLeft)
	-- function f:SetFont(...) error("Attempt to set font on ChannelButton"..i) end
end]]

for _,butt in pairs(PaperDollTitlesPane.buttons) do butt.text:SetFontObject(GameFontHighlightSmallLeft) end
	



