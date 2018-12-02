local _, BasicUILite = ...
local cfg = BasicUILite.EXTRAS

if cfg.enable ~= true then return end

----------------------------------------------------------------------
-- Alt Buy Full Stacks borrowed from NeavUI
----------------------------------------------------------------------
if cfg.altbuy == true then
	local NEW_ITEM_VENDOR_STACK_BUY = ITEM_VENDOR_STACK_BUY
	ITEM_VENDOR_STACK_BUY = '|cffa9ff00'..NEW_ITEM_VENDOR_STACK_BUY..'|r'

		-- alt-click to buy a stack

	local origMerchantItemButton_OnModifiedClick = _G.MerchantItemButton_OnModifiedClick
	local function MerchantItemButton_OnModifiedClickHook(self, ...)
		origMerchantItemButton_OnModifiedClick(self, ...)

		if (IsAltKeyDown()) then
			local maxStack = select(8, GetItemInfo(GetMerchantItemLink(self:GetID())))

			local numAvailable = select(5, GetMerchantItemInfo(self:GetID()))

			-- -1 means an item has unlimited supply.
			if (numAvailable ~= -1) then
				BuyMerchantItem(self:GetID(), numAvailable)
			else
				BuyMerchantItem(self:GetID(), GetMerchantItemMaxStack(self:GetID()))
			end
		end
	end
	MerchantItemButton_OnModifiedClick = MerchantItemButton_OnModifiedClickHook

		-- Google translate ftw...NOT

	local function GetAltClickString()
		if (GetLocale() == 'enUS') then
			return '<Alt-click, to buy an stack>'
		elseif (GetLocale() == 'frFR') then
			return '<Alt-clic, d acheter une pile>'
		elseif (GetLocale() == 'esES') then
			return '<Alt-clic, para comprar una pila>'
		elseif (GetLocale() == 'deDE') then
			return '<Alt-klicken, um einen ganzen Stapel zu kaufen>'
		else
			return '<Alt-click, to buy an stack>'
		end
	end

		-- add a hint to the tooltip

	local function IsMerchantButtonOver()
		return GetMouseFocus():GetName() and GetMouseFocus():GetName():find('MerchantItem%d')
	end

	GameTooltip:HookScript('OnTooltipSetItem', function(self)
		if (MerchantFrame:IsShown() and IsMerchantButtonOver()) then
			for i = 2, GameTooltip:NumLines() do
				if (_G['GameTooltipTextLeft'..i]:GetText():find('<[sS]hift')) then
					GameTooltip:AddLine('|cff00ffcc'..GetAltClickString()..'|r')
				end
			end
		end
	end)
end

----------------------------------------------------------------------
-- Auction borrowed from daftAuction by Daftwise - US Destromath
----------------------------------------------------------------------
if cfg.auction == true then

	-----------START CONFIG------------

	local UNDERCUT = .97; -- .97 is a 3% undercut
	local PRICE_BY = "QUALITY" -- When no matches are found, set price based on QUALITY or VENDOR

	-- PRICE BY QUALITY, where 1000 = 1 gold
		local POOR_PRICE = 100000
		local COMMON_PRICE = 200000
		local UNCOMMON_PRICE = 2500000
		local RARE_PRICE = 5000000
		local EPIC_PRICE = 10000000

	-- PRICE BY VENDOR, where formula is vendor price * number
		local POOR_MULTIPLIER = 20
		local COMMON_MULTIPLIER = 30
		local UNCOMMMON_MULTIPLIER = 40
		local RARE_MULTIPLIER = 50
		local EPIC_MULTIPLIER = 60

	local STARTING_MULTIPLIER = 0.9

	---------END CONFIG---------

	local cAuction = CreateFrame("Frame", "cAuction", UIParent)

	cAuction:RegisterEvent("AUCTION_HOUSE_SHOW")
	cAuction:RegisterEvent("AUCTION_ITEM_LIST_UPDATE")

	local selectedItem
	local selectedItemVendorPrice
	local selectedItemQuality
	local currentPage = 0
	local myBuyoutPrice, myStartPrice
	local myName = UnitName("player")

	cAuction:SetScript("OnEvent", function(self, event)
		
		if event == "AUCTION_HOUSE_SHOW" then
				
			AuctionsItemButton:HookScript("OnEvent", function(self, event)
				
				if event=="NEW_AUCTION_UPDATE" then -- user placed an item into auction item box
					self:SetScript("OnUpdate", nil)
					myBuyoutPrice = nil
					myStartPrice = nil
					currentPage = 0
					selectedItem = nil
					selectedItem, texture, count, quality, canUse, price, _, stackCount, totalCount, selectedItemID = GetAuctionSellItemInfo();
					local canQuery = CanSendAuctionQuery()
					
					if canQuery and selectedItem then -- query auction house based on item name
						ResetCursor()
						QueryAuctionItems(selectedItem)
					end
				end
			end)

		elseif event == "AUCTION_ITEM_LIST_UPDATE" then -- the auction list was updated or sorted
			
			if (selectedItem ~= nil) then -- an item was placed in the auction item box
				local batch, totalAuctions = GetNumAuctionItems("list")
				
				if totalAuctions == 0 then -- No matches
					_, _, selectedItemQuality, selectedItemLevel, _, _, _, _, _, _, selectedItemVendorPrice = GetItemInfo(selectedItem)
								
					if PRICE_BY == "QUALITY" then
					
						if selectedItemQuality == 0 then myBuyoutPrice = POOR_PRICE end
						if selectedItemQuality == 1 then myBuyoutPrice = COMMON_PRICE end
						if selectedItemQuality == 2 then myBuyoutPrice = UNCOMMON_PRICE end
						if selectedItemQuality == 3 then myBuyoutPrice = RARE_PRICE end
						if selectedItemQuality == 4 then myBuyoutPrice = EPIC_PRICE end
					
					elseif PRICE_BY == "VENDOR" then
					
						if selectedItemQuality == 0 then myBuyoutPrice = selectedItemVendorPrice * POOR_MULTIPLIER end
						if selectedItemQuality == 1 then myBuyoutPrice = selectedItemVendorPrice * COMMON_MULTIPLIER end
						if selectedItemQuality == 2 then myBuyoutPrice = selectedItemVendorPrice * UNCOMMMON_MULTIPLIER end
						if selectedItemQuality == 3 then myBuyoutPrice = selectedItemVendorPrice * RARE_MULTIPLIER end
						if selectedItemQuality == 4 then myBuyoutPrice = selectedItemVendorPrice * EPIC_MULTIPLIER end
					end
					
					myStartPrice = myBuyoutPrice * STARTING_MULTIPLIER
				end
				
				local currentPageCount = floor(totalAuctions/50)
				
				for i=1, batch do -- SCAN CURRENT PAGE
					local postedItem, _, count, _, _, _, _, minBid, _, buyoutPrice, _, _, _, owner = GetAuctionItemInfo("list",i)
					
					if postedItem == selectedItem and owner ~= myName and buyoutPrice ~= nil then -- selected item matches the one found on auction list
						
						if myBuyoutPrice == nil and myStartPrice == nil then
							myBuyoutPrice = (buyoutPrice/count) * UNDERCUT;
							myStartPrice = (minBid/count) * UNDERCUT;
							
						elseif myBuyoutPrice > (buyoutPrice/count) then
							myBuyoutPrice = (buyoutPrice/count) * UNDERCUT;
							myStartPrice = (minBid/count) * UNDERCUT;
						end;
					end;
				end;
				
				if currentPage < currentPageCount then -- GO TO NEXT PAGES
					
					self:SetScript("OnUpdate", function(self, elapsed)
						
						if not self.timeSinceLastUpdate then 
							self.timeSinceLastUpdate = 0 ;
						end;
						self.timeSinceLastUpdate = self.timeSinceLastUpdate + elapsed;
						
						if self.timeSinceLastUpdate > .1 then -- a cycle has passed, run this
							selectedItem = GetAuctionSellItemInfo();
							local canQuery = CanSendAuctionQuery();
							
							if canQuery then -- check the next page of auctions
								currentPage = currentPage + 1;
								QueryAuctionItems(selectedItem, nil, nil, currentPage);
								self:SetScript("OnUpdate", nil);
							end
							self.timeSinceLastUpdate = 0;
						end;
					end);
				
				else -- ALL PAGES SCANNED
					self:SetScript("OnUpdate", nil)
					local stackSize = AuctionsStackSizeEntry:GetNumber();
						
					if myStartPrice ~= nil then
							
						if stackSize > 1 then -- this is a stack of items
								
							if UIDropDownMenu_GetSelectedValue(PriceDropDown) == PRICE_TYPE_UNIT then -- input price per item
								MoneyInputFrame_SetCopper(StartPrice, myStartPrice);
								MoneyInputFrame_SetCopper(BuyoutPrice, myBuyoutPrice);
								
							else -- input price for entire stack
								MoneyInputFrame_SetCopper(StartPrice, myStartPrice*stackSize);
								MoneyInputFrame_SetCopper(BuyoutPrice, myBuyoutPrice*stackSize);
							end
							
						else -- this is not a stack
							MoneyInputFrame_SetCopper(StartPrice, myStartPrice);
							MoneyInputFrame_SetCopper(BuyoutPrice, myBuyoutPrice);
						end
						
						if UIDropDownMenu_GetSelectedValue(DurationDropDown) ~= 3 then 
							UIDropDownMenu_SetSelectedValue(DurationDropDown, 3); -- set duration to 3 (48h)
							DurationDropDownText:SetText("48 Hours"); -- set duration text since it keeps bugging to "Custom"
						end;
					end
						
					myBuyoutPrice = nil;
					myStartPrice = nil;
					currentPage = 0;
					selectedItem = nil;
					stackSize = nil;
				end
			end
		end
	end)
end

----------------------------------------------------------------------
-- Coords borrowed from NeavUI
----------------------------------------------------------------------
if cfg.coords == true  then
    -- Temp fix until Blizzard removed the ! icon from the global string.
    local _, MOUSE_LABEL = strsplit("1", MOUSE_LABEL, 2)
	
	local MapRects = {};
    local TempVec2D = CreateVector2D(0,0);
    local function GetPlayerMapPos(mapID)
        local R,P,_ = MapRects[mapID],TempVec2D;
        if not R then
            R = {};
            _, R[1] = C_Map.GetWorldPosFromMapPos(mapID,CreateVector2D(0,0));
            _, R[2] = C_Map.GetWorldPosFromMapPos(mapID,CreateVector2D(1,1));
            R[2]:Subtract(R[1]);
            MapRects[mapID] = R;
        end
        P.x, P.y = UnitPosition("Player");
        P:Subtract(R[1]);
        return (1/R[2].y)*P.y, (1/R[2].x)*P.x;
    end
	
	local CoordsFrame = CreateFrame('Frame', nil, WorldMapFrame)
	CoordsFrame:SetParent(WorldMapFrame.BorderFrame)

	CoordsFrame.Player = CoordsFrame:CreateFontString(nil, 'OVERLAY')
	CoordsFrame.Player:SetFont([[Fonts\FRIZQT__.ttf]], 15, 'THINOUTLINE')
	CoordsFrame.Player:SetJustifyH('LEFT')
	CoordsFrame.Player:SetPoint('BOTTOM', WorldMapFrame.BorderFrame, "BOTTOM", -100, 8)
	CoordsFrame.Player:SetTextColor(1, 0.82, 0)

	CoordsFrame.Mouse = CoordsFrame:CreateFontString(nil, 'OVERLAY')
	CoordsFrame.Mouse:SetFont([[Fonts\FRIZQT__.ttf]], 15, 'THINOUTLINE')
	CoordsFrame.Mouse:SetJustifyH('LEFT')
	CoordsFrame.Mouse:SetPoint('BOTTOMLEFT', CoordsFrame.Player, "BOTTOMLEFT", 120, 0)
	CoordsFrame.Mouse:SetTextColor(1, 0.82, 0)

	CoordsFrame:SetScript('OnUpdate', function(self, elapsed)
        if IsInInstance() then return end

        local mapID = C_Map.GetBestMapForUnit("player")
        local px, py = GetPlayerMapPos(mapID)

        if px then
            if px ~= 0 and py ~= 0 then
                self.Player:SetText(PLAYER..format(': %.0f x %.0f', px * 100, py * 100).." / ")
            else
                self.Player:SetText("")
            end
        end

        if WorldMapFrame.ScrollContainer:IsMouseOver() then
            local mx, my = WorldMapFrame.ScrollContainer:GetNormalizedCursorPosition()

            if mx then
                if mx >= 0 and my >= 0 and mx <= 1 and my <= 1 then
                    self.Mouse:SetText(MOUSE_LABEL..format(': %.0f x %.0f', mx * 100, my * 100))
                else
                    self.Mouse:SetText("")
                end
            end
        else
            self.Mouse:SetText("")
        end
    end)
end

----------------------------------------------------------------------
-- Merchant borrowed from Tukui and NeavUI
----------------------------------------------------------------------
if cfg.merchant == true then
	local merchantUseGuildRepair = false	-- let your guild pay for your repairs if they allow.

	local MerchantFilter = {
		[6289]  = true, -- Raw Longjaw Mud Snapper
		[6291]  = true, -- Raw Brilliant Smallfish
		[6308]  = true, -- Raw Bristle Whisker Catfish
		[6309]  = true, -- 17 Pound Catfish
		[6310]  = true, -- 19 Pound Catfish
		[41808] = true, -- Bonescale Snapper
		[42336] = true, -- Bloodstone Band
		[42337] = true, -- Sun Rock Ring
		[43244] = true, -- Crystal Citrine Necklace
		[43571] = true, -- Sewer Carp
		[43572] = true, -- Magic Eater		
	}

	local Merchant_Frame = CreateFrame("Frame")
	Merchant_Frame:SetScript("OnEvent", function()
		local Cost = 0
		
		for Bag = 0, 4 do
			for Slot = 1, GetContainerNumSlots(Bag) do
				local Link, ID = GetContainerItemLink(Bag, Slot), GetContainerItemID(Bag, Slot)
				
				if (Link and ID) then
					local Price = 0
					local Mult1, Mult2 = select(11, GetItemInfo(Link)), select(2, GetContainerItemInfo(Bag, Slot))
					
					if (Mult1 and Mult2) then
						Price = Mult1 * Mult2
					end
					
					if (select(3, GetItemInfo(Link)) == 0 and Price > 0) then
						UseContainerItem(Bag, Slot)
						PickupMerchantItem()
						Cost = Cost + Price
					end
					
					if MerchantFilter[ID] then
						UseContainerItem(Bag, Slot)
						PickupMerchantItem()
						Cost = Cost + Price
					end
				end
			end
		end
		
		if (Cost > 0) then
			local Gold, Silver, Copper = math.floor(Cost / 10000) or 0, math.floor((Cost % 10000) / 100) or 0, Cost % 100
			
			DEFAULT_CHAT_FRAME:AddMessage("|cff33ff99BasicUILite:|r Your grey item's have been sold for".." |cffffffff"..Gold.."|cffffd700g|r".." |cffffffff"..Silver.."|cffc7c7cfs|r".." |cffffffff"..Copper.."|cffeda55fc|r"..".",255,255,0)
		end
		
		if (not IsShiftKeyDown()) then
			if CanMerchantRepair() then
				local Cost, Possible = GetRepairAllCost()
				
				if (Cost > 0) then
					if (IsInGuild() and merchantUseGuildRepair) then
						local CanGuildRepair = (CanGuildBankRepair() and (Cost <= GetGuildBankWithdrawMoney()))
						
						if CanGuildRepair then
							RepairAllItems(1)
							
							return
						end
					end
					
					if Possible then
						RepairAllItems()
						
						local Copper = Cost % 100
						local Silver = math.floor((Cost % 10000) / 100)
						local Gold = math.floor(Cost / 10000)
						if guildRepairFlag == 1 then
							DEFAULT_CHAT_FRAME:AddMessage("|cff33ff99BasicUILite:|r Your guild payed".." |cffffffff"..Gold.."|cffffd700g|r".." |cffffffff"..Silver.."|cffc7c7cfs|r".." |cffffffff"..Copper.."|cffeda55fc|r".." to repair your gear.",255,255,0)
						else
							DEFAULT_CHAT_FRAME:AddMessage("|cff33ff99BasicUILite:|r You payed".." |cffffffff"..Gold.."|cffffd700g|r".." |cffffffff"..Silver.."|cffc7c7cfs|r".." |cffffffff"..Copper.."|cffeda55fc|r".." to repair your gear.",255,255,0)
						end
					else
						DEFAULT_CHAT_FRAME:AddMessage("|cff33ff99BasicUILite:|r You don't have enough money for repair!", 255, 0, 0)
					end
				end
			end
		end		
	end)

	Merchant_Frame:RegisterEvent("MERCHANT_SHOW")
end

----------------------------------------------------------------------
-- Minimap Modifacations
----------------------------------------------------------------------
if cfg.minimap == true then

    -- Bigger Minimap
	MinimapCluster:SetScale(1.2) 
	MinimapCluster:EnableMouse(false)
	
	-- Garrison Button
	GarrisonLandingPageMinimapButton:SetSize(36, 36)

    -- Hide all Unwanted Things	
	MinimapZoomIn:Hide()
	MinimapZoomOut:Hide()
	 	 
	MiniMapTracking:UnregisterAllEvents()
	MiniMapTracking:Hide()

	
	-- Enable Mousewheel Zooming
	Minimap:EnableMouseWheel(true)
	Minimap:SetScript('OnMouseWheel', function(self, delta)
		if (delta > 0) then
			_G.MinimapZoomIn:Click()
		elseif delta < 0 then
			_G.MinimapZoomOut:Click()
		end
	end)

	-- Modify the Minimap Tracking		
	Minimap:SetScript('OnMouseUp', function(self, button)
		if (button == 'RightButton') then
			ToggleDropDownMenu(1, nil, MiniMapTrackingDropDown, self, - (Minimap:GetWidth() * 0.7), -3)
		else
			Minimap_OnClick(self)
		end
	end)
end

----------------------------------------------------------------------
-- Autogreed borrowed from NeavUI
----------------------------------------------------------------------
if cfg.autogreed == true then

	-- Option to only auto-greed at max level.
	local maxLevelOnly = true

	-- A skip list for green stuff you might not wanna auto-greed on
	local skipList = {
		--['Stone Scarab'] = true,
		--['Silver Scarab'] = true,
	}

	local AutoGreedFrame = CreateFrame('Frame')
	AutoGreedFrame:RegisterEvent('START_LOOT_ROLL')
	AutoGreedFrame:SetScript('OnEvent', function(_, _, rollID)
		if (maxLevelOnly and UnitLevel('player') == MAX_PLAYER_LEVEL) then
			local _, name, _, quality, BoP, _, _, canDisenchant = GetLootRollItemInfo(rollID)
			if (quality == 2 and not BoP and not skipList[name]) then
				RollOnLoot(rollID, canDisenchant and 3 or 2)
			end
		end
	end)
end

----------------------------------------------------------------------
-- Powerbar borrowed from NeavUI
----------------------------------------------------------------------
if cfg.powerbar.enable == true then

	local format = string.format
	local floor = math.floor

	local function FormatValue(self)
		if (self >= 10000) then
			return ('%.1fk'):format(self / 1e3)
		else
			return self
		end
	end

	local function PowerRound(num, idp)
		local mult = 10^(idp or 0)
		return floor(num * mult + 0.5) / mult
	end

	local function PowerFade(frame, timeToFade, startAlpha, endAlpha)
		if (PowerRound(frame:GetAlpha(), 1) ~= endAlpha) then
			local mode = startAlpha > endAlpha and 'In' or 'Out'
			securecall('UIFrameFade'..mode, frame, timeToFade, startAlpha, endAlpha)
		end
	end

	local playerClass = select(2, UnitClass('player'))

	local PBFrame = CreateFrame('Frame', nil, UIParent)

	PBFrame:SetScale(cfg.powerbar.scale)
	PBFrame:SetSize(18, 18)
	PBFrame:SetPoint(unpack(cfg.powerbar.position))
	PBFrame:EnableMouse(false)

	PBFrame:RegisterEvent('PLAYER_REGEN_ENABLED')
	PBFrame:RegisterEvent('PLAYER_REGEN_DISABLED')
	PBFrame:RegisterEvent('PLAYER_ENTERING_WORLD')
	PBFrame:RegisterEvent('PLAYER_TARGET_CHANGED')
	PBFrame:RegisterUnitEvent('UNIT_DISPLAYPOWER', 'player')
	PBFrame:RegisterUnitEvent('UNIT_POWER_UPDATE', 'player')
	PBFrame:RegisterUnitEvent('UNIT_POWER_FREQUENT', 'player')
	PBFrame:RegisterEvent('UPDATE_SHAPESHIFT_FORM')

	if (cfg.powerbar.showCombatRegen) then
		PBFrame:RegisterUnitEvent('UNIT_AURA', 'player')
	end

	if (cfg.powerbar.hp.show) then
		PBFrame:RegisterUnitEvent('UNIT_HEALTH', 'player')
		PBFrame:RegisterUnitEvent('UNIT_MAX_HEALTH', 'player')
		PBFrame:RegisterUnitEvent('UNIT_HEALTH_FREQUENT', 'player')
	end

	PBFrame:RegisterUnitEvent('UNIT_ENTERED_VEHICLE', 'player')
	PBFrame:RegisterUnitEvent('UNIT_ENTERING_VEHICLE', 'player')
	PBFrame:RegisterUnitEvent('UNIT_EXITED_VEHICLE', 'player')
	PBFrame:RegisterUnitEvent('UNIT_EXITING_VEHICLE', 'player')

	if (playerClass == 'WARLOCK' and cfg.powerbar.showSoulshards
		or playerClass == 'PALADIN' and cfg.powerbar.showHolypower
		or playerClass == 'ROGUE' and cfg.powerbar.showComboPoints
		or playerClass == 'DRUID' and cfg.powerbar.showComboPoints
		or playerClass == 'MONK' and cfg.powerbar.showChi
		or playerClass == 'MAGE' and cfg.powerbar.showArcaneCharges) then

		PBFrame.extraPoints = PBFrame:CreateFontString(nil, 'ARTWORK')

		if (cfg.powerbar.extraFontOutline) then
			PBFrame.extraPoints:SetFont(cfg.powerbar.extraFont, cfg.powerbar.extraFontSize, 'THINOUTLINE')
			PBFrame.extraPoints:SetShadowOffset(0, 0)
		else
			PBFrame.extraPoints:SetFont(cfg.powerbar.extraFont, cfg.powerbar.extraFontSize)
			PBFrame.extraPoints:SetShadowOffset(1, -1)
		end

		PBFrame.extraPoints:SetParent(PBFrame)
		PBFrame.extraPoints:SetPoint('CENTER', 0, 0)
	end

	if (playerClass == 'DEATHKNIGHT' and cfg.powerbar.showRunes) then

		-- Hide the Runes on the Player Frame
		RuneFrame.Rune1:Hide()
		RuneFrame.Rune2:Hide()
		RuneFrame.Rune3:Hide()
		RuneFrame.Rune4:Hide()
		RuneFrame.Rune5:Hide()
		RuneFrame.Rune6:Hide()
		
		PBFrame.Rune = {}

		for i = 1, 6 do
			PBFrame.Rune[i] = PBFrame:CreateFontString(nil, 'ARTWORK')

			if (cfg.powerbar.rune.runeFontOutline) then
				PBFrame.Rune[i]:SetFont(cfg.powerbar.rune.runeFont, cfg.powerbar.rune.runeFontSize, 'THINOUTLINE')
				PBFrame.Rune[i]:SetShadowOffset(0, 0)
			else
				PBFrame.Rune[i]:SetFont(cfg.powerbar.rune.runeFont, cfg.powerbar.rune.runeFontSize)
				PBFrame.Rune[i]:SetShadowOffset(1, -1)
			end

			PBFrame.Rune[i]:SetShadowOffset(0, 0)
			PBFrame.Rune[i]:SetParent(PBFrame)
		end

 		PBFrame.Rune[1]:SetPoint('CENTER', -65, 0) 
 		PBFrame.Rune[2]:SetPoint('CENTER', -39, 0) 
 		PBFrame.Rune[3]:SetPoint('CENTER', 39, 0) 
 		PBFrame.Rune[4]:SetPoint('CENTER', 65, 0) 
 		PBFrame.Rune[5]:SetPoint('CENTER', -13, 0) 
 		PBFrame.Rune[6]:SetPoint('CENTER', 13, 0) 
	end

	if (cfg.powerbar.hp.show) then
		PBFrame.HPText = PBFrame:CreateFontString(nil, 'ARTWORK')
		if (cfg.powerbar.hp.hpFontOutline) then
			PBFrame.HPText:SetFont(cfg.powerbar.hp.hpFont, cfg.powerbar.hp.hpFontSize, 'THINOUTLINE')
			PBFrame.HPText:SetShadowOffset(0, 0)
		else
			PBFrame.HPText:SetFont(cfg.powerbar.hp.hpFont, cfg.powerbar.hp.hpFontSize)
			PBFrame.HPText:SetShadowOffset(1, -1)
		end
		PBFrame.HPText:SetParent(PBFrame)
		if (PBFrame.extraPoints) then
			PBFrame.HPText:SetPoint('CENTER', 0, cfg.powerbar.extraFontSize + cfg.powerbar.hp.hpFontHeightAdjustment)
		else
			PBFrame.HPText:SetPoint('CENTER', 0, 0)
		end

	end

	PBFrame.Power = CreateFrame('StatusBar', nil, UIParent)
	PBFrame.Power:SetScale(PBFrame:GetScale())
	PBFrame.Power:SetSize(cfg.powerbar.sizeWidth, 8)
	PBFrame.Power:SetPoint('CENTER', PBFrame, 0, -28)
	PBFrame.Power:SetStatusBarTexture([[Interface\TargetingFrame\UI-StatusBar]])
	PBFrame.Power:SetAlpha(0)

	PBFrame.Power.Value = PBFrame.Power:CreateFontString(nil, 'ARTWORK')

	if (cfg.powerbar.valueFontOutline) then
		PBFrame.Power.Value:SetFont(cfg.powerbar.valueFont, cfg.powerbar.valueFontSize, 'THINOUTLINE')
		PBFrame.Power.Value:SetShadowOffset(0, 0)
	else
		PBFrame.Power.Value:SetFont(cfg.powerbar.valueFont, cfg.powerbar.valueFontSize)
		PBFrame.Power.Value:SetShadowOffset(1, -1)
	end

	PBFrame.Power.Value:SetPoint('CENTER', PBFrame.Power, 0, cfg.powerbar.valueFontAdjustmentX)
	PBFrame.Power.Value:SetVertexColor(1, 1, 1)

	PBFrame.Power.Background = PBFrame.Power:CreateTexture(nil, 'BACKGROUND')
	PBFrame.Power.Background:SetAllPoints(PBFrame.Power)
	PBFrame.Power.Background:SetTexture([[Interface\DialogFrame\UI-DialogBox-Background]])
	PBFrame.Power.Background:SetVertexColor(0.25, 0.25, 0.25, 1)

	PBFrame.Power.Below = PBFrame.Power:CreateTexture(nil, 'BACKGROUND')
	PBFrame.Power.Below:SetHeight(14)
	PBFrame.Power.Below:SetWidth(14)
	PBFrame.Power.Below:SetTexture([[Interface\AddOns\BasicUILite\Media\textureArrowBelow]])

	PBFrame.Power.Above = PBFrame.Power:CreateTexture(nil, 'BACKGROUND')
	PBFrame.Power.Above:SetHeight(14)
	PBFrame.Power.Above:SetWidth(14)
	PBFrame.Power.Above:SetTexture([[Interface\AddOns\BasicUILite\Media\textureArrowAbove]])
	PBFrame.Power.Above:SetPoint('BOTTOM', PBFrame.Power.Below, 'TOP', 0, PBFrame.Power:GetHeight())

	if (cfg.powerbar.showCombatRegen) then
		PBFrame.mpreg = PBFrame.Power:CreateFontString(nil, 'ARTWORK')
		PBFrame.mpreg:SetFont(cfg.powerbar.valueFont, 12, 'THINOUTLINE')
		PBFrame.mpreg:SetShadowOffset(0, 0)
		PBFrame.mpreg:SetPoint('TOP', PBFrame.Power.Below, 'BOTTOM', 0, 4)
		PBFrame.mpreg:SetParent(PBFrame.Power)
		PBFrame.mpreg:Show()
	end

	local function GetRealMpFive()
		local _, activeRegen = GetPowerRegen()
		local realRegen = activeRegen * 5
		local _, powerType = UnitPowerType('player')

		if (powerType == 'MANA' or UnitHasVehicleUI('player')) then
			return math.floor(realRegen)
		else
			return ''
		end
	end

	local function SetPowerColor()
		local powerType
		if ( playerClass == 'ROGUE' or playerClass == 'DRUID' ) then
			powerType = Enum.PowerType.ComboPoints
		elseif ( playerClass == 'MONK' ) then
			powerType = Enum.PowerType.Chi
		elseif ( playerClass == 'MAGE' ) then
			powerType = Enum.PowerType.ArcaneCharges
		elseif ( playerClass == 'PALADIN' ) then
			powerType = Enum.PowerType.HolyPower
		elseif ( playerClass == 'WARLOCK' ) then
			powerType = Enum.PowerType.SoulShards
		end

		local currentPower = UnitPower("player", powerType)
		local maxPower = UnitPowerMax("player", powerType)

		if ( UnitIsDeadOrGhost('target') ) then
			return 1, 1, 1
		elseif ( currentPower == maxPower-1 ) then
			return 0.9, 0.7, 0.0
		elseif ( currentPower == maxPower ) then
			return 1, 0, 0
		else
			return 1, 1, 1
		end
	end

	local function GetHPPercentage()
		local currentHP = UnitHealth('player')
		local maxHP = UnitHealthMax('player')
		return math.floor(100*currentHP/maxHP)
	end


	local function CalcRuneCooldown(self)
		local start, duration, runeReady = GetRuneCooldown(self)
		local time = floor(GetTime() - start)
		local cooldown = ceil(duration - time)

		if (runeReady or UnitIsDeadOrGhost('player')) then
			return '#'
		elseif (not UnitIsDeadOrGhost('player') and cooldown) then
			return cooldown
		end
	end

	local function UpdateBarVisibility()
		local _, powerType = UnitPowerType('player')
		local newAlpha = nil

		if ((not cfg.powerbar.energy.show and powerType == 'ENERGY')
			or (not cfg.powerbar.focus.show and powerType == 'FOCUS')
			or (not cfg.powerbar.rage.show and powerType == 'RAGE')
			or (not cfg.powerbar.mana.show and powerType == 'MANA')
			or (not cfg.powerbar.rune.show and powerType == 'RUNEPOWER')
			or (not cfg.powerbar.fury.show and powerType == 'FURY')
			or (not cfg.powerbar.pain.show and powerType == 'PAIN')
			or (not cfg.powerbar.lunarPower.show and powerType == 'LUNAR_POWER')
			or (not cfg.powerbar.insanity.show and powerType == 'INSANITY')
			or (not cfg.powerbar.maelstrom.show and powerType == 'MAELSTROM')
			or UnitIsDeadOrGhost('player') or UnitHasVehicleUI('player')) then
			PBFrame.Power:SetAlpha(0)
		elseif (InCombatLockdown()) then
			newAlpha = cfg.powerbar.activeAlpha
		elseif (not InCombatLockdown() and UnitPower('player') > 0) then
			newAlpha = cfg.powerbar.inactiveAlpha
		else
			newAlpha = cfg.powerbar.emptyAlpha
		end

		if (newAlpha) then
			PowerFade(PBFrame.Power, 0.3, PBFrame.Power:GetAlpha(), newAlpha)
		end
	end

	local function UpdateArrow()
		if (UnitPower('player') == 0) then
			PBFrame.Power.Below:SetAlpha(0.3)
			PBFrame.Power.Above:SetAlpha(0.3)
		else
			PBFrame.Power.Below:SetAlpha(1)
			PBFrame.Power.Above:SetAlpha(1)
		end

		local newPosition = UnitPower('player') / UnitPowerMax('player') * PBFrame.Power:GetWidth()
		PBFrame.Power.Below:SetPoint('TOP', PBFrame.Power, 'BOTTOMLEFT', newPosition, 0)
	end

	local function UpdateBarValue()
		local min = UnitPower('player')
		PBFrame.Power:SetMinMaxValues(0, UnitPowerMax('player'))
		PBFrame.Power:SetValue(min)

		if (cfg.powerbar.valueAbbrev) then
			PBFrame.Power.Value:SetText(min > 0 and FormatValue(min) or '')
		else
			PBFrame.Power.Value:SetText(min > 0 and min or '')
		end
	end

	local function UpdateBarColor()
		local powerType, powerToken, altR, altG, altB = UnitPowerType('player')
		local unitPower = PowerBarColor[powerToken]

		if (unitPower) then
			if ( powerType == 0 ) then
				PBFrame.Power:SetStatusBarColor(0,0.55,1)
			else
				PBFrame.Power:SetStatusBarColor(unitPower.r, unitPower.g, unitPower.b)
			end
		else
			PBFrame.Power:SetStatusBarColor(altR, altG, altB)
		end
	end

	local function UpdateBar()
		UpdateBarColor()
		UpdateBarValue()
		UpdateArrow()
	end

	PBFrame:SetScript('OnEvent', function(self, event, arg1)
		if (PBFrame.extraPoints) then
			if (UnitHasVehicleUI('player')) then
				if (PBFrame.extraPoints:IsShown()) then
					PBFrame.extraPoints:Hide()
				end
			else
				local nump
				if (playerClass == 'WARLOCK') then
					nump = WarlockPowerBar_UnitPower('player')
				elseif (playerClass == 'PALADIN') then
					nump = UnitPower('player', Enum.PowerType.HolyPower)
				elseif (playerClass == 'ROGUE' or playerClass == 'DRUID' ) then
					nump = UnitPower('player', Enum.PowerType.ComboPoints)
				elseif (playerClass == 'MONK' ) then
					nump = UnitPower('player', Enum.PowerType.Chi)
				elseif (playerClass == 'MAGE' ) then
					nump = UnitPower('player', Enum.PowerType.ArcaneCharges)
				end

				PBFrame.extraPoints:SetTextColor(SetPowerColor())
				PBFrame.extraPoints:SetText(nump == 0 and '' or nump)

				if (not PBFrame.extraPoints:IsShown()) then
					PBFrame.extraPoints:Show()
				end

				-- move the hp text if no points
				if (PBFrame.HPText) then
					if (nump == 0) then
						PBFrame.HPText:SetPoint('CENTER', 0, 0)
					else
						PBFrame.HPText:SetPoint('CENTER', 0, cfg.powerbar.extraFontSize + cfg.powerbar.hp.hpFontHeightAdjustment)
					end
				end
			end
		end

		if (PBFrame.mpreg and (event == 'UNIT_AURA' or event == 'PLAYER_ENTERING_WORLD')) then
			PBFrame.mpreg:SetText(GetRealMpFive())
		end

		if (PBFrame.HPText) then
			if (UnitHasVehicleUI('player')) then
				if (PBFrame.HPText:IsShown()) then
					PBFrame.HPText:Hide()
				end
			else
				PBFrame.HPText:SetTextColor(unpack(cfg.powerbar.hp.hpFontColor))
				PBFrame.HPText:SetText(GetHPPercentage())

				if (not PBFrame.HPText:IsShown()) then
					PBFrame.HPText:Show()
				end
			end
		end

		UpdateBar()
		UpdateBarVisibility()

		if (event == 'PLAYER_ENTERING_WORLD') then
			if (InCombatLockdown()) then
				securecall('UIFrameFadeIn', f, 0.35, PBFrame:GetAlpha(), 1)
			else
				securecall('UIFrameFadeOut', f, 0.35, PBFrame:GetAlpha(), cfg.powerbar.inactiveAlpha)
			end
		end

		if (event == 'PLAYER_REGEN_DISABLED') then
			securecall('UIFrameFadeIn', f, 0.35, PBFrame:GetAlpha(), 1)
		end

		if (event == 'PLAYER_REGEN_ENABLED') then
			securecall('UIFrameFadeOut', f, 0.35, PBFrame:GetAlpha(), cfg.powerbar.inactiveAlpha)
		end
	end)

	if (PBFrame.Rune) then
		local updateTimer = 0
		PBFrame:SetScript('OnUpdate', function(self, elapsed)
			updateTimer = updateTimer + elapsed

			if (updateTimer > 0.1) then
				for i = 1, 6 do
					if (UnitHasVehicleUI('player')) then
						if (PBFrame.Rune[i]:IsShown()) then
							PBFrame.Rune[i]:Hide()
						end
					else
						if (not PBFrame.Rune[i]:IsShown()) then
							PBFrame.Rune[i]:Show()
						end
					end

					PBFrame.Rune[i]:SetText(CalcRuneCooldown(i))
					PBFrame.Rune[i]:SetTextColor(0.0, 0.6, 0.8)
				end

				updateTimer = 0
			end
		end)
	end

end

----------------------------------------------------------------------
-- Rare Alert borrowed from
----------------------------------------------------------------------
if cfg.rarealert == true then
	local RareFrame = CreateFrame("Frame")
	RareFrame:RegisterEvent("VIGNETTE_MINIMAP_UPDATED")
	RareFrame:SetScript("OnEvent", function(self, event, vignetteInstanceID, onMiniMap)
		if vignetteInstanceID and onMiniMap then
			if SVInstanceID == vignetteInstanceID then
			else
				SVInstanceID = vignetteInstanceID;
				RareObjectName = "";
				local SV_Table = C_VignetteInfo.GetVignetteInfo(vignetteInstanceID)
				local name = SV_Table.name	
				if name then
	--				Excluded Items List follows
					if name == "Invasion Site"    
						or name == "Legion Structure"
						or name == "Kukuru's Treasure Cache"
						or name == "Scouting Map"
						or name == "Map of Zandalar"
						then return
					end
					if not svchests then
						if string.find (name, "Treasure") then
							return
						end
						if string.find (name, "Statue") then
							return
						end
						if string.find (name, "Garrison Cache") then
								return
						end
					end
					RareObjectName = name;
				end
				if not name then
					RareObjectName = "Rare";
				end
				PlaySoundFile("Sound\\Spells\\PVPFlagTaken.ogg")
				RaidNotice_AddMessage(RaidWarningFrame, "|cff00ff00"..RareObjectName.." spotted!|r", ChatTypeInfo["RAID_WARNING"])
			end
		end
	end)
	
	-- Riad Warning Font Size
	local font, size = [[Fonts\FRIZQT__.ttf]], 28 --{r,g,b}
	RaidWarningFrameSlot1:SetFont(font,size)
	RaidWarningFrameSlot2:SetFont(font,size)
	RaidWarningFrame.timings.RAID_NOTICE_MIN_HEIGHT = size
end


----------------------------------------------------------------------
-- borrowed from Leatrix.Plus Hide PlayerFrame Damage
----------------------------------------------------------------------
if cfg.hpd == true then

	-- Hide hit indicators (portrait text)
	hooksecurefunc(PlayerHitIndicator, "Show", PlayerHitIndicator.Hide)
	hooksecurefunc(PetHitIndicator, "Show", PetHitIndicator.Hide)
end

----------------------------------------------------------------------
-- Order Hall Resource In Tooltip from Neb
----------------------------------------------------------------------
if cfg.orderhall == true then
	-- Order Resources
	local currencyId = C_Garrison.GetCurrencyTypes(LE_GARRISON_TYPE_7_0)

	-- follower info is async and ephemeral, so cache it
	local categoryInfo = {}
	do
		local frame = CreateFrame("Frame")
		frame:SetScript("OnEvent", function(self, event)
			if C_Garrison.GetLandingPageGarrisonType() ~= LE_GARRISON_TYPE_7_0 then return end

			if event == "GARRISON_FOLLOWER_CATEGORIES_UPDATED" then
				categoryInfo = C_Garrison.GetClassSpecCategoryInfo(LE_FOLLOWER_TYPE_GARRISON_7_0)
			else
				C_Garrison.RequestClassSpecCategoryInfo(LE_FOLLOWER_TYPE_GARRISON_7_0)
			end
		end)
		frame:RegisterEvent("GARRISON_FOLLOWER_CATEGORIES_UPDATED")
		frame:RegisterEvent("GARRISON_FOLLOWER_ADDED")
		frame:RegisterEvent("GARRISON_FOLLOWER_REMOVED")
		frame:RegisterEvent("GARRISON_TALENT_COMPLETE")
		frame:RegisterEvent("GARRISON_TALENT_UPDATE")
		frame:RegisterEvent("GARRISON_SHOW_LANDING_PAGE")
	end

	-- from LibLDBIcon-1.0
	local function getAnchors(frame)
		local x, y = frame:GetCenter()
		if not x or not y then return "CENTER" end
		local hhalf = (x > UIParent:GetWidth()*2/3) and "RIGHT" or (x < UIParent:GetWidth()/3) and "LEFT" or ""
		local vhalf = (y > UIParent:GetHeight()/2) and "TOP" or "BOTTOM"
		return vhalf..hhalf, frame, (vhalf == "TOP" and "BOTTOM" or "TOP")..hhalf
	end

	GarrisonLandingPageMinimapButton:HookScript("OnEnter", function(self)
		if C_Garrison.GetLandingPageGarrisonType() ~= LE_GARRISON_TYPE_7_0 then return end

		GameTooltip:SetOwner(self, "ANCHOR_NONE")
		GameTooltip:SetPoint(getAnchors(self))
		GameTooltip:SetText(self.title, 1, 1, 1)
		GameTooltip:AddLine(self.description, nil, nil, nil, true)
		GameTooltip:AddLine(" ")

		local currency, amount, icon = GetCurrencyInfo(currencyId)
		GameTooltip:AddDoubleLine(currency, ("%s |T%s:0:0:0:2:64:64:4:60:4:60|t"):format(BreakUpLargeNumbers(amount), icon), 1, 1, 1, 1, 1, 1)

		if #categoryInfo > 0 then
			GameTooltip:AddLine(" ")
			for _, info in ipairs(categoryInfo) do
				GameTooltip:AddDoubleLine(info.name, ("%d/%d |T%d:0|t"):format(info.count, info.limit, info.icon), 1, 1, 1, 1, 1, 1)
			end
		end

		GameTooltip:Show()
	end)
end

if cfg.massprospect == true then
	SLASH_BasicUILite_MP1 = '/mp';

	-- by Kaemin

	function SlashCmdList.BasicUILite_MP(msg, editbox)
		if msg == nil or msg == "" or msg == "menu" or msg == "options" or msg == "?" or msg == "help" then
			BasicUILite_MP_Define();
		end
		if msg == "reset" then
			DeleteMacro("BasicUILite_MP");
			BasicUILite_DB_Per_Character = false;
	--		BasicUILite_MP_Define();
		end
	end

	function BasicUILite_MP_Define()
		local prof1, prof2, archaeology, fishing, cooking, firstAid = GetProfessions();
		local name, icon, skillLevel, maxSkillLevel, numAbilities, spelloffset, skillLine, skillModifier, specializationIndex, specializationOffset = GetProfessionInfo(prof1);
		local aname, aicon, askillLevel, amaxSkillLevel, anumAbilities, aspelloffset, askillLine, askillModifier, aspecializationIndex, aspecializationOffset = GetProfessionInfo(prof2);
		if aname=="Jewelcrafting" then name=aname end
		if name == "Jewelcrafting" then
			SPProfCheck = "true";
			MPMacroString = "/run local f,l,n=MPB or CreateFrame(".."\"".."Button".."\""..",".."\"".."MPB".."\""..",nil,".."\"".."SecureActionButtonTemplate".."\""..") f:SetAttribute(".."\"".."type".."\""..",".."\"".."macro".."\""..") l,n=BasicUILite_MP_Ore() if l then f:SetAttribute(".."\"".."macrotext".."\""..",".."\"".."/cast Prospecting\\n/use ".."\"".."..l) SetMacroItem(".."\"".."BasicUILite_MP".."\""..",n) end\n/click MPB"
			if BasicUILite_DB_Per_Character == false then
				local index = CreateMacro("BasicUILite_MP", "Inv_misc_gem_bloodgem_01", MPMacroString, 1);
				BasicUILite_DB_Per_Character = true;
			else
			local newIndex = EditMacro("BasicUILite_MP", "BasicUILite_MP", "Inv_misc_gem_bloodgem_01", MPMacroString);
			end
		else
			SPProfCheck = "false";
			DEFAULT_CHAT_FRAME:AddMessage("|cff25bfdaBasicUILite:|r|cffffff00 You are |r|cffff0000NOT|r |cffffff00a jewelcrafter! Please disable this addon for this character.|r");
		end
	end

	function BasicUILite_MP_Ore()
		OreInBags = 0;
		for i=0,4 do 
			for j=1,GetContainerNumSlots(i) do local t={GetItemInfo(GetContainerItemLink(i,j) or 0)}
				if t[7]=="Metal & Stone" and select(2,GetContainerItemInfo(i,j))>=5 then
					OreInBags = OreInBags + 1;
					return i.." "..j,t[1]
				end 
			end 
		end
		if OreInBags == 0 and SPProfCheck == "true" then
			DEFAULT_CHAT_FRAME:AddMessage("|cff25bfdaBasicUILite:|r|cffffff00 There is |r|cffff0000NOT ENOUGH|r |cffffff00ore in your bags!|r");
		end
	end

	function BasicUILite_MP_OnLoad()
		local fframe = CreateFrame("Frame")
			fframe:RegisterEvent("ADDON_LOADED");
			fframe:SetScript("OnEvent", function(self, event, arg1)
			if event == "ADDON_LOADED" and arg1 == "_addon" then
				local prof1, prof2, archaeology, fishing, cooking, firstAid = GetProfessions();
				local name, icon, skillLevel, maxSkillLevel, numAbilities, spelloffset, skillLine, skillModifier, specializationIndex, specializationOffset = GetProfessionInfo(prof1);
				local aname, aicon, askillLevel, amaxSkillLevel, anumAbilities, aspelloffset, askillLine, askillModifier, aspecializationIndex, aspecializationOffset = GetProfessionInfo(prof2);
				if aname == "Jewelcrafting" then name = aname end
				if name == "Jewelcrafting" then
					SPProfCheck = "true";
					MPMacroString = "/run local f,l,n=MPB or CreateFrame(".."\"".."Button".."\""..",".."\"".."MPB".."\""..",nil,".."\"".."SecureActionButtonTemplate".."\""..") f:SetAttribute(".."\"".."type".."\""..",".."\"".."macro".."\""..") l,n=BasicUILite_MP_Ore() if l then f:SetAttribute(".."\"".."macrotext".."\""..",".."\"".."/cast Prospecting\\n/use ".."\"".."..l) SetMacroItem(".."\"".."BasicUILite_MP".."\""..",n) end\n/click MPB"
					if BasicUILite_DB_Per_Character == false then
						local index = CreateMacro("BasicUILite_MP", "Inv_misc_gem_bloodgem_01", MPMacroString, 1);
						BasicUILite_DB_Per_Character = true;
					else
					local newIndex = EditMacro("BasicUILite_MP", "BasicUILite_MP", "Inv_misc_gem_bloodgem_01", MPMacroString);
					end
				else
					SPProfCheck = "false";
					DEFAULT_CHAT_FRAME:AddMessage("|cff33ff99BasicUILite:|r|cffffff00 You are |r|cffff0000NOT|r |cffffff00a jewelcrafter! Please disable this addon for this character.|r");
				end
			end
		end)
	end
end

if cfg.ilvlchange == true then
	local ilvl = -1

	local f = CreateFrame("Frame")
	f:RegisterEvent("PLAYER_LOGIN")
	f:RegisterEvent("PLAYER_AVG_ITEM_LEVEL_UPDATE")
	f:SetScript("OnEvent", function()
		local total, equipped = GetAverageItemLevel()
		total = math.floor(total)
		if total == ilvl then
			return
		end
		local color = ChatTypeInfo["SYSTEM"]
		if total > ilvl then
			DEFAULT_CHAT_FRAME:AddMessage("|cff33ff99BasicUILite:|r Your average item level is now |cff99ff99" .. total .. "|r, up from " .. ilvl, color.r, color.g, color.b)
		else
			DEFAULT_CHAT_FRAME:AddMessage("|cff33ff99BasicUILite:|r Your average item level is now |cffff9999" .. total .. "|r, down from " .. ilvl, color.r, color.g, color.b)
		end
		ilvl = total
	end)
end