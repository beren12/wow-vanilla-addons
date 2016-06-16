AutoMate = {
--Automate
	Dismount = true,
	DuelDecline = true,
	FilterAvailable = true,
	Nameplates = true,
	Repair = true,
	SellJunk = true,
	SkipGossip = true,
-- Chat
	ChatClean = true,
	ChatScroll = true,
	ShortenChannelNames = true,
-- RightClick
	AuctionHouse = true,
	MailBox = true,
	Trade = true,
-- Misc.
	ErrorFilter = true,
	EquipCompare = true,
	MinimapButton = true,
	PlayerLink = true,
	QuickLoot = true,
	RangeColor = true,
	UnitFrames = true,
}
function AutoMate_OnLoad()
	SLASH_AUTOMATE1 = "/auto"
	SLASH_AUTOMATE2 = "/automate"
	SlashCmdList["AUTOMATE"] = function(msg) AutoMate_Handler(msg) end
	--DEFAULT_CHAT_FRAME:AddMessage("AutoMate by Wayleran Loaded: |cffaaaaaaincludes AddOn Organizer in main menu, AutoDismount, AutoDuelDecline, AutoFilterAvailable, AutoNameplates, AutoRepair, AutoSellJunk, AutoSkipGossip, ChatClean, ChatScroll, ErrorFilter, EquipCompare, Improved RightClick, Improved UnitFrames, QuickLoot, RangeColor, and more...\nUse (/auto help) for more information.")
	this:RegisterEvent("ADDON_LOADED")
	this:RegisterEvent("AUCTION_HOUSE_CLOSED")
	this:RegisterEvent("AUCTION_HOUSE_SHOW")
	this:RegisterEvent("BANKFRAME_OPENED")
	this:RegisterEvent("BANKFRAME_CLOSED")
	this:RegisterEvent("DUEL_REQUESTED")
	this:RegisterEvent("GOSSIP_SHOW")
	this:RegisterEvent("LOOT_OPENED")
	this:RegisterEvent("MAIL_CLOSED")
	this:RegisterEvent("MAIL_INBOX_UPDATE")
	this:RegisterEvent("MAIL_SHOW")
	this:RegisterEvent("MAIL_SEND_SUCCESS")
	this:RegisterEvent("MERCHANT_SHOW")
	this:RegisterEvent("MERCHANT_CLOSED")
	this:RegisterEvent("PLAYER_REGEN_DISABLED")
	this:RegisterEvent("PLAYER_REGEN_ENABLED")
	this:RegisterEvent("PLAYER_ENTERING_WORLD")
	this:RegisterEvent("PLAYER_TARGET_CHANGED")
	this:RegisterEvent("SPELLS_CHANGED")
	this:RegisterEvent("SPELLCAST_CHANNEL_START")
	this:RegisterEvent("SPELLCAST_CHANNEL_STOP")
	this:RegisterEvent("TAXIMAP_OPENED")
	this:RegisterEvent("TRADE_CLOSED")
	this:RegisterEvent("TRADE_SHOW")
	this:RegisterEvent("TRAINER_SHOW")
	this:RegisterEvent("UI_ERROR_MESSAGE")
-- Chat
	Chat_UseCursorKeys = true
	Chat_SetupCursorMode(Chat_UseCursorKeys)
	Chat_Orig_ChatFrame_OnEvent = ChatFrame_OnEvent
	ChatFrame_OnEvent = Chat_ChatFrame_OnEvent
	-- ChatFilter
	ChatTypeGroup["CHANNEL"] = {}
	-- ChatScroll
	for i = 1, NUM_CHAT_WINDOWS do
		getglobal("ChatFrame" .. i):SetScript("OnMouseWheel", CleanScroll_OnMouseWheel)
		getglobal("ChatFrame" .. i):EnableMouseWheel()
	end
-- RightClick
	AutoMateItemUse_Save = UseContainerItem
    UseContainerItem = AutoMateItemUse
	-- MailBox
		AutoMateInbox_OnClick_Save = InboxFrame_OnClick
		InboxFrame_OnClick = AutoMateInbox_OnClick
		SaveMailRecipient = SendMailFrame_Reset
		SendMailFrame_Reset = SaveMailRecipient_Reset
		SaveMailRecipientState = {LastRecipient}
-- Misc.
	-- ErrorFilter
	SLASH_ERRORFILTER1 = "/ef"
	SLASH_ERRORFILTER2 = "/errorfilter"
	SlashCmdList["ERRORFILTER"] = function(msg) ErrorFilter_SlashHandler(msg, arg1, arg2) end
	EF_Old_UIErrorsFrame_OnEvent = UIErrorsFrame_OnEvent
	UIErrorsFrame_OnEvent = EF_New_UIErrorsFrame_OnEvent
	-- PlayerLink
	ori_unitpopup = UnitPopup_OnClick
	UnitPopup_OnClick = spl_unitpopup
	ori_SetItemRef = SetItemRef
	SetItemRef = spl_SetItemRef
	-- QuickLoot
	LootFrame_OnEvent = AutoMate_LootFrame_OnEvent
	LootFrame_Update = AutoMate_LootFrame_Update
	-- RangeColor
	ActionButton_OnUpdate = RangeColor_ActionButton_OnUpdate
	-- UnitFrames
	FONTS = {font = STANDARD_TEXT_FONT, height = 10, flags = "OUTLINE"}
	TextStatusBar_UpdateTextString_Org = TextStatusBar_UpdateTextString
	TextStatusBar_UpdateTextString = AutoMate_TextStatusBar_UpdateTextString
	HealthBar_OnValueChanged_Org = HealthBar_OnValueChanged
	HealthBar_OnValueChanged = AutoMate_HealthBar_OnValueChanged
end
function AutoMate_Handler(msg)
	if (msg == "help") then
		DEFAULT_CHAT_FRAME:AddMessage("/auto or /automate |cffaaaaaa- Toggles the options window.")
		DEFAULT_CHAT_FRAME:AddMessage("/addons |cffaaaaaa- Toggles the AddOn Manager or use the button in the main menu.")
		DEFAULT_CHAT_FRAME:AddMessage("/ef or /errorfilter |cffaaaaaa- Displays ErrorFilter options.")
	elseif (msg == "" or msg == nil) then
		if (AutoMateOptions:IsVisible()) then
			PlaySound("gsTitleOptionExit")
			AutoMateOptions:Hide()
		else
			PlaySound("igMainMenuOption")
			AutoMateOptions:Show()
		end
	end
end
function AutoMate_OnEvent(event)
	-- SkipGossip
	if (AutoMate.SkipGossip == true) then
		if (event == "GOSSIP_SHOW") and not (IsShiftKeyDown()) then
			if (GetGossipAvailableQuests() == nil) and (GetGossipActiveQuests() == nil) then
				SelectGossipOption(1)
			end
		end
	end
	-- Auto Open/Close Bags
	if (event == "AUCTION_HOUSE_SHOW") or (event == "BANKFRAME_OPENED") or (event == "TRADE_SHOW") or (event == "MAIL_SHOW") then
		OpenAllBags(true)
	end
	if (event == "AUCTION_HOUSE_CLOSED") or (event == "BANKFRAME_CLOSED") or (event == "TRADE_CLOSED") or (event == "MAIL_CLOSED") then
		CloseAllBags(true)
	end
	if (event == "MERCHANT_SHOW") then
		OpenAllBags(true)
	-- Repair
		if (AutoMate.Repair == true) then
			if CanMerchantRepair() then
				local repairCost = GetRepairAllCost()
				if repairCost > 0 then
					local gold = mod(floor(repairCost/(10000)),100)
					local silver = mod(floor(repairCost/100),100)
					local copper = mod(floor(repairCost + .5),100)
					if (gold   > 0) then repairGold = gold .. "g " else repairGold = "" end
					if (silver > 0) then repairSilver = silver .. "s " else repairSilver = "" end
					if (copper > 0) then repairCopper = copper .. "c " end
				DEFAULT_CHAT_FRAME:AddMessage("AutoMate: Repair Costs "..repairGold..""..repairSilver..""..repairCopper.."")
				RepairAllItems()
				end
			end
		end
	-- SellJunk
		if (AutoMate.SellJunk == true) then
			AtMerchant = true
		end
	end
	if (event == "MERCHANT_CLOSED") then
		CloseAllBags(true)
		AtMerchant = false
	end
	-- Dismount
	if (AutoMate.Dismount) then
		if (event == "TAXIMAP_OPENED") or (event == "UI_ERROR_MESSAGE") then
			for i=0,15 do
				if GetPlayerBuffTexture(i) then
					if string.find(GetPlayerBuffTexture(i),"Mount") and not string.find(GetPlayerBuffTexture(i),"Tiger") then
						UIErrorsFrame:Clear()
						CancelPlayerBuff(i)
					end
				end
			end
		end
		if not UnitPlayerControlled("target") and UnitIsFriend("player", "target") and (event == "UI_ERROR_MESSAGE") then
			for i=0,15 do
				if GetPlayerBuffTexture(i) then
					if string.find(GetPlayerBuffTexture(i),"Form") then
						UIErrorsFrame:Clear()
						CancelPlayerBuff(i)
					end
				end
			end
		end
	end
	-- DuelDecline
	if (AutoMate.DuelDecline == true) and (event == "DUEL_REQUESTED") then
		CancelDuel()
		StaticPopup_Hide("DUEL_REQUESTED")
	end
	-- FilterAvailable
	if (AutoMate.FilterAvailable == true) and (event == "TRAINER_SHOW") then
		SetTrainerServiceTypeFilter("unavailable", 0)
	else
		SetTrainerServiceTypeFilter("unavailable", 1)
	end
	-- Nameplates
	if (AutoMate.Nameplates == true) and not IsInInstance() then
		if (event == "PLAYER_ENTERING_WORLD") then
			HideNameplates()
		elseif (event == "PLAYER_REGEN_DISABLED") then
			ShowNameplates()
		elseif (event == "PLAYER_REGEN_ENABLED") then
			HideNameplates()
		end
	end
-- RightClick
	-- MailBox
	if (AutoMate.MailBox == true) then
		if (event == "MAIL_CLOSED") then
			if SaveMailRecipientState.LastRecipient then
				SendMailNameEditBox:SetText("")
			end
		elseif (event == "MAIL_SEND_SUCCESS") then
			local txt = SendMailNameEditBox:GetText()
			if txt == "" then return
			else SaveMailRecipientState.LastRecipient = txt
			end
		end
	end
	-- PlayerLink
	if (event == "ADDON_LOADED") and (AutoMate.PlayerLink == true) then
		UnitPopupButtons["ADD_FRIEND"] = { text = TEXT(ADD_FRIEND), dist = 0 }
		UnitPopupButtons["ADD_IGNORE"] = { text = TEXT(IGNORE), dist = 0 }
		UnitPopupButtons["WHO"] = { text = TEXT(WHO), dist = 0 }
		UnitPopupButtons["ADD_GUILD"] = { text = "Guild Invite", dist = 0 }
		UnitPopupButtons["GET_NAME"] = { text = "Get Name", dist = 0 }
		UnitPopupMenus["FRIEND"] = { "WHISPER", "INVITE", "TARGET", "GET_NAME", "ADD_FRIEND", "ADD_IGNORE", "WHO", "ADD_GUILD", "GUILD_PROMOTE", "GUILD_LEAVE", "CANCEL" }
		UnitPopupMenus["PARTY"] = { "WHISPER", "PROMOTE", "LOOT_PROMOTE", "UNINVITE", "INSPECT", "TRADE", "FOLLOW", "DUEL", "ADD_FRIEND", "WHO", "ADD_GUILD", "GET_NAME", "RAID_TARGET_ICON", "CANCEL" }
		UnitPopupMenus["PLAYER"] = { "WHISPER", "INSPECT", "INVITE", "TRADE", "FOLLOW", "DUEL", "ADD_FRIEND", "ADD_IGNORE", "WHO", "ADD_GUILD", "GET_NAME", "RAID_TARGET_ICON", "CANCEL" }
	end
-- Misc.
	-- QuickLoot
	if (event == "ADDON_LOADED") and (AutoMate.QuickLoot == true) then
		UIPanelWindows["LootFrame"] = nil
		LootFrame:SetMovable(1)
		LootFrame:SetFrameStrata("DIALOG")
		LootFrame:SetScript("OnMouseUp", function () this:StopMovingOrSizing() end)
		LootFrame:SetScript("OnMouseDown", function () this:StartMoving() end)
	end
	-- UnitFrames
	if (event == "ADDON_LOADED") or (event == "PLAYER_TARGET_CHANGED") then
		AutoMate_UnitFramesSetup()
	end
end
function AutoMate_OnUpdate()
	-- SellJunk
	if AtMerchant and not CursorHasItem() then
		AutoMate_SellJunk()
	end
	-- MinimapButton
	if (AutoMate.MinimapButton == true) then
		AutoMateMinimapButton:Show()
	else
		AutoMateMinimapButton:Hide()
	end
end
-- Chat
	-- ChatClean
function Chat_ChatFrame_OnEvent()
	if (AutoMate.ChatClean == true) and (strsub(event, 1, 8) == "CHAT_MSG") then
		CHAT_FLAG_AFK = ""
		CHAT_FLAG_DND = ""
		CHAT_GUILD_GET = "%s:\32"
		CHAT_PARTY_GET = "%s:\32"
		CHAT_RAID_GET = "%s:\32"
		CHAT_TAB_SHOW_DELAY = 1
	else
		CHAT_GUILD_GET = "[Guild] %s:\32"
		CHAT_PARTY_GET = "[Party] %s:\32"
		CHAT_RAID_GET = "[Raid] %s:\32"
	end
	if(not this.Original_AddMessage) then
		this.Original_AddMessage = this.AddMessage
		this.AddMessage = ChatClean_AddMessage
	end
	Chat_Orig_ChatFrame_OnEvent(event)
end
function ChatClean_AddMessage(this, msg, r, g, b, id)
	-- ChatClean
	if (AutoMate.ChatClean == true) then
		msg = string.gsub(msg, "LookingForGroup", "LFG")
		msg = string.gsub(msg, "world%]", "World]")
		msg = string.gsub(msg, "global%]", "Global]")
		--msg = string.gsub(msg, "%[Server Broadcast..", "%")
	end
	-- ShortenChannelNames
	if (AutoMate.ShortenChannelNames == true) then
		msg = string.gsub(msg, "%[(%d)%..-%]%s", "[%1.]")
	end
	this:Original_AddMessage(msg, r, g, b, id)
end
	-- ChatScroll
function CleanScroll_OnMouseWheel()
	if (AutoMate.ChatScroll == true) then
		if (IsShiftKeyDown()) then
			if (arg1 == 1) then
				this:ScrollToTop()
			else
				PlaySound("igChatBottom")
				this:ScrollToBottom()
			end
		else
			if (arg1 == 1) then
				this:ScrollUp()
			else
				this:ScrollDown()
			end
		end
	end
end
function Chat_SetupCursorMode(isCursorUsedDirectly)
  ChatFrameEditBox:SetAltArrowKeyMode(not isCursorUsedDirectly)
end
--RightClick
	-- AuctionHouse
local function AuctionSearch(link)
	if not AuctionFrameBrowse or not AuctionFrameBrowse:IsVisible() then return end
	if (AutoMate.AuctionHouse == true) then
		if link and not strfind(link,"item:") then return end
		BrowseMinLevel:SetText('')
		BrowseMaxLevel:SetText('')
		UIDropDownMenu_SetText('',BrowseDropDown)
		UIDropDownMenu_SetSelectedName(BrowseDropDown)
		local name,il,ir,iml,class,sub
		if link then
			local i,j,name = strfind(link,"%[(.+)%]")
			BrowseName:SetText(name)
			BrowseName:HighlightText(0,-1)
			IsUsableCheckButton:SetChecked(false)
			if(not IsShiftKeyDown()) then return 1 end
			local i,j,item = strfind(link,"(item:%d+:%d+:%d+:%d+)")
			name,il,ir,iml,class,sub = GetItemInfo(item)
		else
			BrowseName:SetText('')
			IsUsableCheckButton:SetChecked(true)
			if(not IsShiftKeyDown()) then return 1 end
			class = 'Recipe'
			sub = class
		end
		AuctionFrameBrowse.selectedClass = class
		for ix,name in CLASS_FILTERS do
			if name==class then
				AuctionFrameBrowse.selectedClassIndex = ix
				i = ix
			break
			end
		end
		if class~=sub then
			AuctionFrameBrowse.selectedSubclass = HIGHLIGHT_FONT_COLOR_CODE..sub..FONT_COLOR_CODE_CLOSE
			for ix,name in {GetAuctionItemSubClasses(i)} do
				if name==sub then
					AuctionFrameBrowse.selectedSubclassIndex = ix
				break
				end
			end
		else
		AuctionFrameBrowse.selectedSubclass = nil
		AuctionFrameBrowse.selectedSubclassIndex = nil
		end
		AuctionFrameBrowse.selectedInvtype = nil
		AuctionFrameBrowse.selectedInvtypeIndex = nil
		AuctionFrameFilters_Update()
		BrowseSearchButton:Click()
		return 1
	end
end
	-- MailBox
function AutoMateInbox_OnClick(index)
	local item,icon,from,sub,money,cod = GetInboxHeaderInfo(index)
	if (AutoMate.MailBox == true) and (cod == 0) and (IsShiftKeyDown()) then
		if (money > 0) then
			GetInboxText(index)
			TakeInboxMoney(index)
		elseif (item) then
			GetInboxText(index)
			TakeInboxItem(index)
		end
	else
		AutoMateInbox_OnClick_Save(index)
	end
end
local SaveMailRecipient
function SaveMailRecipient_Reset()
	if (AutoMate.MailBox == true) then
		if (SendMailNameEditBox:GetText() and SendMailNameEditBox:GetText() ~= "") then
			SendMailSubjectEditBox:SetFocus()
		else SendMailNameEditBox:SetFocus()
		end
		SendMailSubjectEditBox:SetText("")
		SendMailBodyEditBox:SetText("")
		StationeryPopupFrame.selectedIndex = nil
		SendMailFrame_Update()
		StationeryPopupButton_OnClick(1)
		MoneyInputFrame_ResetMoney(SendMailMoney)
		SendMailRadioButton_OnClick(1)
	end
end
function AutoMateItemUse(ParentID,ItemID)
	if (not CursorHasItem() and not IsControlKeyDown() and not IsAltKeyDown()) then
		-- AuctionHouse
		if (AuctionFrameAuctions and AuctionFrameAuctions:IsVisible()) and (AutoMate.AuctionHouse == true) then
			if (IsShiftKeyDown()) then
				for slot = 1,16 do
					if (not GetContainerItemInfo(0,slot)) then
						SplitContainerItem(ParentID,ItemID,1)
						PickupContainerItem(0,slot)
					return
					end
				end
			return
			end
		PickupContainerItem(ParentID,ItemID)
		ClickAuctionSellItemButton()
		return
		end
		-- MailBox
		if(SendMailFrame:IsVisible()) and (AutoMate.MailBox == true) then
			PickupContainerItem(ParentID,ItemID)
			ClickSendMailItemButton()
			if(IsShiftKeyDown()) then
				SendMailMailButton:Click()
				this:Enable()
			end
		return
		end
		-- Trade
		if(TradeFrame:IsVisible()) and (AutoMate.Trade == true) then
			PickupContainerItem(ParentID,ItemID)
			local slot = TradeFrame_GetAvailableSlot()
			if slot then ClickTradeButton(slot) end
			return
		end
	end
	if AuctionSearch(GetContainerItemLink(ParentID,ItemID)) then return end
	AutoMateItemUse_Save(ParentID,ItemID)
end
-- Misc.
	-- ErrorFilter
Error_Filters = {
	[1] = "Interrupted",
	[2] = "There is nothing to attack.",
	[3] = "That ability requires combo points",
	[4] = "You cannot attack that target.",
	[5] = "Out of range.",
	[6] = "You are too far away!",
	[7] = "You must be behind your target",
	[8] = "Ability is not ready yet.",
	[9] = "You have no target.",
	[10] = "Target needs to be in front of you",
	[11] = "Can't do that while moving",
	[12] = "Not enough rage",
	[13] = "You are facing the wrong way!",
	[14] = "Not enough energy",
	[15] = "Not enough mana",
	[16] = "Target too close",
	[17] = "Your target is dead",
	[18] = "Can't do that while stunned",
	[19] = "Spell is not ready yet.",
	[20] = "You are dead",
	[21] = "You must be in stealth mode",
	[22] = "Can't attack while fleeing.",
	[23] = "Can't attack while stunned.",
	[24] = "You are not in control of your actions",
	[25] = "Item is not ready yet.",
	[26] = "Can't attack while confused.",
	[27] = "Target not in line of sight",
	[28] = "Another action is in progress",
	[29] = "Invalid target",
	[30] = "You are too far away.",
	[31] = "You cannot raid target enemy players",
	[32] = "Target is not a player",
	[33] = "No path available",
	[34] = "You can't do that yet",
	[35] = "Target is in combat",
	[36] = "Can't attack while dead.",
}
function ErrorFilter_SlashHandler(msg, arg1, arg2)
	local omsg = msg
	if (msg) then
		msg = string.lower(msg)
		if (msg == "" or msg == "help") then
			DEFAULT_CHAT_FRAME:AddMessage("ErrorFilter: Type /ef followed by one of the following commands:")
			DEFAULT_CHAT_FRAME:AddMessage("   toggle - Toggles ErrorFilter on/off")
			DEFAULT_CHAT_FRAME:AddMessage("   list - Shows the current filters and their ID number")
			DEFAULT_CHAT_FRAME:AddMessage("   add [message] - Adds [message] to the filter list")
			DEFAULT_CHAT_FRAME:AddMessage("   remove [id] - Removes the message [id] from the filter list")
		elseif (msg == "disable") then
			AutoMate.ErrorFilter = false
		elseif (msg == "enable") then
			AutoMate.ErrorFilter = true
		elseif (msg == "list") then
			DEFAULT_CHAT_FRAME:AddMessage("Current ErrorFilter filters:")
			for key, text in Error_Filters do
			DEFAULT_CHAT_FRAME:AddMessage("  ["..key.."] "..text)
			end
		elseif (msg == "toggle") then
			if (AutoMate.ErrorFilter == true) then
				AutoMate.ErrorFilter = false
				DEFAULT_CHAT_FRAME:AddMessage("ErrorFilter is currently disabled")
			else
				AutoMate.ErrorFilter = true
				DEFAULT_CHAT_FRAME:AddMessage("ErrorFilter is currently enabled")
			end
		elseif (string.sub(msg, 1, string.len("add")) == "add") then
			if (string.sub(msg, 1, (string.len("add")+1)) ~= ("add".." ")) then
				DEFAULT_CHAT_FRAME:AddMessage("Usage: /ef add [msg]")
			else str = string.sub(omsg, (string.len("add")+2), -1)
				table.insert(Error_Filters, str)
				DEFAULT_CHAT_FRAME:AddMessage("ErrorFilter added filter: "..str)
			end
		elseif (string.sub(msg, 1, string.len("remove")) == "remove") then
			if (string.sub(msg, 1, (string.len("remove")+1)) ~= ("remove".." ")) then
				DEFAULT_CHAT_FRAME:AddMessage("Usage: /ef remove [id]")
				DEFAULT_CHAT_FRAME:AddMessage("Example: /ef remove 2")
				DEFAULT_CHAT_FRAME:AddMessage("Use /ef list to see the ID's of every filter")
			else str = string.sub(omsg, (string.len("remove")+2), -1)
				for key, text in Error_Filters do
					if (key == tonumber(str)) then
						table.remove(Error_Filters, key)
						DEFAULT_CHAT_FRAME:AddMessage("Removed filter "..text)
					return
				end
			end
			DEFAULT_CHAT_FRAME:AddMessage("ErrorFilter: filter not found")
		end
		else
			DEFAULT_CHAT_FRAME:AddMessage("ErrorFilter: Unknown command. Type /ef or /errorfilter for help.")
		end
	end
end
function EF_New_UIErrorsFrame_OnEvent(event, message, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
	if (AutoMate.ErrorFilter == true) then
		for key, text in Error_Filters do
			if (text and message) then
				if (message == text) then return end
			end
		end
	end
	EF_Old_UIErrorsFrame_OnEvent(event, message, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
end
	-- PlayerLink
function spl_unitpopup()
	local dropdownFrame = getglobal(UIDROPDOWNMENU_INIT_MENU)
	local button = this.value
	local unit = dropdownFrame.unit
	local name = dropdownFrame.name
	local server = dropdownFrame.server
	if (button == "ADD_FRIEND") then
		AddFriend(name)
	elseif (button == "ADD_IGNORE") then
		AddIgnore(name)
	elseif (button == "WHO") then
		SendWho("n-"..name)
	elseif (button == "ADD_GUILD") then
		GuildInviteByName(name)
	elseif (button == "GET_NAME") then
		spl_GetName(name)
	else
		return ori_unitpopup()
	end
	PlaySound("UChatScrollButton")
end
function spl_SetItemRef(link, text, button)
	if (not link) then
			link = arg1
	end
	if (not text) then
			text = arg2
	end
	if (not button) then
			button = arg3
	end
	if ( strsub(link, 1, 6) == "player" ) then
		local name = strsub(link, 8)
		if ( name and (strlen(name) > 0) ) then
			name = gsub(name, "([^%s]*)%s+([^%s]*)%s+([^%s]*)", "%3")
			name = gsub(name, "([^%s]*)%s+([^%s]*)", "%2")
			if ( IsShiftKeyDown() ) then
				local staticPopup
				staticPopup = StaticPopup_Visible("ADD_IGNORE")
				if ( staticPopup ) then
					getglobal(staticPopup.."EditBox"):SetText(name)
					return
				end
				staticPopup = StaticPopup_Visible("ADD_FRIEND")
				if ( staticPopup ) then
					getglobal(staticPopup.."EditBox"):SetText(name)
					return
				end
				staticPopup = StaticPopup_Visible("ADD_GUILDMEMBER")
				if ( staticPopup ) then
					getglobal(staticPopup.."EditBox"):SetText(name)
					return
				end
				staticPopup = StaticPopup_Visible("ADD_RAIDMEMBER")
				if ( staticPopup ) then
					getglobal(staticPopup.."EditBox"):SetText(name)
					return
				end
				if ( ChatFrameEditBox:IsVisible() ) then
					ChatFrameEditBox:Insert(name)
				else
					SendWho("n-"..name)
				end
			elseif ( IsControlKeyDown() ) then
				TargetByName(name)
			elseif ( IsAltKeyDown() ) then
				spl_GetName(name)
			elseif ( button == "RightButton" ) then
				FriendsFrame_ShowDropdown(name, 1)
			else
				ChatFrame_SendTell(name)
			end
		end
		return
	end
	return ori_SetItemRef(link, text, button)
end
function spl_GetName(name)
	if (ChatFrameEditBox:IsVisible()) then
		ChatFrameEditBox:Insert(name)
	else
		DEFAULT_CHAT_FRAME.editBox:Hide()
		DEFAULT_CHAT_FRAME.editBox.chatType = "SAY"
		ChatEdit_UpdateHeader(DEFAULT_CHAT_FRAME.editBox)
		if (not DEFAULT_CHAT_FRAME.editBox:IsVisible()) then
			ChatFrame_OpenChat(name, DEFAULT_CHAT_FRAME)
		end
	end
end
	-- QuickLoot
local OriginalLootFrame_OnEvent = LootFrame_OnEvent
local OriginalLootFrame_Update = LootFrame_Update
local function LootFrame_SetLootFramePoint(x, y)
	if (AutoMate.QuickLoot == true) then
		local screenWidth = GetScreenWidth()
		if (UIParent:GetWidth() > screenWidth) then
			screenWidth = UIParent:GetWidth()
		end
		local screenHeight = GetScreenHeight()
		local windowWidth = 191
		local windowHeight = 256
		if ( (x + windowWidth) > screenWidth ) then
			x = screenWidth - windowWidth
		end
		if ( y > screenHeight ) then
			y = screenHeight
		end
		if ( x < 0 ) then
			x = 0
		end
		if ( (y - windowHeight) < 0 ) then
			y = windowHeight
		end
	end
	LootFrame:ClearAllPoints()
	LootFrame:SetPoint("TOPLEFT", "UIParent", "BOTTOMLEFT", x, y)
end
local function AutoMate_ItemUnderCursor()
	if (AutoMate.QuickLoot == true) then
		local index
		local x, y = GetCursorPosition()
		local scale = LootFrame:GetEffectiveScale()
		x = x / scale
		y = y / scale
		LootFrame:ClearAllPoints()
		for index = 1, LOOTFRAME_NUMBUTTONS, 1 do
			local button = getglobal("LootButton"..index)
			if( button:IsVisible() ) then
				x = x - 42
				y = y + 56 + (40 * index)
				LootFrame:SetPoint("TOPLEFT", "UIParent", "BOTTOMLEFT", x, y)
				return
			end
		end
		if LootFrameDownButton:IsVisible() then
			x = x - 158
			y = y + 223
		else
			if GetNumLootItems() == 0  then
				HideUIPanel(LootFrame)
			return
			end
			x = x - 173
			y = y + 25
		end
		LootFrame:SetPoint("TOPLEFT", "UIParent", "BOTTOMLEFT", x, y)
	end
end
function AutoMate_LootFrame_OnEvent(event)
	OriginalLootFrame_OnEvent(event)
	if(event == "LOOT_SLOT_CLEARED") then
		AutoMate_ItemUnderCursor()
	end
end
function AutoMate_LootFrame_Update()
	OriginalLootFrame_Update()
	AutoMate_ItemUnderCursor()
end
	-- RangeColor
function RangeColor_ActionButton_OnUpdate(elapsed)
	local icon = getglobal(this:GetName().."Icon")
	local normalTexture = getglobal(this:GetName().."NormalTexture")
	local hotkey = getglobal(this:GetName().."HotKey")
	if (AutoMate.RangeColor == true) then
		if (IsActionInRange(ActionButton_GetPagedID(this)) == 0) then
			icon:SetVertexColor(0.4,0.4,0.4)
			normalTexture:SetVertexColor(0.4,0.4,0.4)
			hotkey:SetVertexColor(0.6,0.6,0.6)
		elseif (IsUsableAction(ActionButton_GetPagedID(this))) then
			icon:SetVertexColor(1,1,1)
			normalTexture:SetVertexColor(1,1,1)
			hotkey:SetVertexColor(1,1,1)
		end
	else
		if (IsActionInRange(ActionButton_GetPagedID(this)) == 0) then
			icon:SetVertexColor(1,1,1)
			normalTexture:SetVertexColor(1,1,1)
			hotkey:SetVertexColor(1,0,0)
		elseif (IsUsableAction(ActionButton_GetPagedID(this))) then
			icon:SetVertexColor(1,1,1)
			normalTexture:SetVertexColor(1,1,1)
			hotkey:SetVertexColor(1,1,1)
		end
	end
end
	-- SellJunk
function AutoMate_BagReturn(find)
	local link = nil
	local bagslots = nil
	for bag=0,NUM_BAG_FRAMES do
		bagslots = GetContainerNumSlots(bag)
		if bagslots and bagslots > 0 then
			for slot=1,bagslots do
				link = GetContainerItemLink(bag, slot)
				if not find and not link or find and link and string.find(link, find) then
					return bag, slot
				end
			end
		end
	end
	return nil
end
function AutoMate_SellJunk()
	local bag, slot = AutoMate_BagReturn("ff9d9d9d")
	if bag and slot then
		local _, _, locked = GetContainerItemInfo(bag, slot)
		if bag and slot and not locked then
			UseContainerItem(bag,slot)
			DEFAULT_CHAT_FRAME:AddMessage("AutoMate: Selling "..GetContainerItemLink(bag, slot))
		end
	end
end
	-- UnitFrames
function AutoMate_UnitFramesSetup()
		TextStatusBar_UpdateTextString(TargetFrameHealthBar)
		AutoMate_TargetFrameHealthBarText:SetFont(FONTS.font, FONTS.height, FONTS.flags)
		TargetFrameHealthBar.TextString = AutoMate_TargetFrameHealthBarText
		TargetFrameHealthBar.lockShow = 1
end
function AutoMate_TextStatusBar_UpdateTextString(textStatusBar)
	TextStatusBar_UpdateTextString_Org(textStatusBar)
	if not textStatusBar then textStatusBar = this end
	if textStatusBar.TextString == nil then return end
	if UnitIsDead("target") then textStatusBar.TextString:Hide() end
	local value = textStatusBar:GetValue()
	local min, max = textStatusBar:GetMinMaxValues()
	local percent = AutoMate_Percent(value, max)
	if (textStatusBar == TargetFrameHealthBar) then
		if (AutoMate.UnitFrames == true) then
			textStatusBar.TextString:SetText(percent .. "%")
		else textStatusBar.TextString:SetText("")
		end
	end
end
function AutoMate_HealthBar_OnValueChanged(value, smooth)
	HealthBar_OnValueChanged_Org(value, true)
end
function AutoMate_Percent(value, maxValue)
	if maxValue == 0 then return 0
	else return math.floor(value * 100 / maxValue)
	end
end
	-- AddOns Manager
AddOns_ADDONS_DISPLAYED = 22
AddOns_ADDONSLINE_HEIGHT = 16
AddOns_Profiles = {}
BINDING_HEADER_AddOns_SEP = "AddOns"
BINDING_NAME_AddOns_CONFIG = "Show / Hide"
local id
local AddOns_AddOnList = {}
function AddOns_OnLoad()
	tinsert(UISpecialFrames,"AddOns_List")
	SLASH_AddOns1 = "/addons"
	SlashCmdList["AddOns"] = function(msg)
	AddOns_ListShowHide()
	end
end
function AddOns_ListShowHide()
	if (AddOns_List:IsVisible()) then
		HideUIPanel(AddOns_List_Profiles)
		HideUIPanel(AddOns_List)
	else
		AddOns_List_Title:SetText ("AddOns")
		ShowUIPanel(AddOns_List)
		AddOns_GetList()
		AddOns_List_Update()
	end
end
function AddOns_GetList()
	local i
	for i=1, GetNumAddOns(), 1 do
		local name, title, notes, enabled, loadable, reason, security = GetAddOnInfo(i)
		AddOns_AddOnList[i] = enabled
	end
end
function AddOns_List_Update()
	local numaddons = GetNumAddOns()
	local i
	AddOns_List_AddOnCount:SetText("AddOns: |CFFFFFFFF"..numaddons.."|r")
	AddOns_List_CountMiddle:SetWidth(AddOns_List_AddOnCount:GetWidth())
	FauxScrollFrame_Update(AddOns_List_Scroll, numaddons, AddOns_ADDONS_DISPLAYED, AddOns_ADDONSLINE_HEIGHT, nil, nil, nil, AddOns_List_HighlightFrame, 293, 316 )
	for i=1, AddOns_ADDONS_DISPLAYED, 1 do
		local addonIndex = i + FauxScrollFrame_GetOffset(AddOns_List_Scroll)
		if ( addonIndex <= numaddons ) then
			local addonLogTitle = getglobal("AddOns_List_Title"..i)
			local addonTitleTag = getglobal("AddOns_List_Title"..i.."Tag")
			local name, title, notes, enabled, loadable, reason, security = GetAddOnInfo(addonIndex)
			addonLogTitle:SetText(title)
			addonLogTitle:SetNormalTexture("")
			local color = {r=0.7,g=0.7,b=0.7}
			if(enabled and loadable)then
				color = {r=1.0,g=1.0,b=0.5}
			elseif(enabled and not loadable)then
				color = {r=1.0,g=0.0,b=0.0}
			end
			if(AddOns_AddOnList[addonIndex] == 1) then
				addonTitleTag:SetText("Enabled")
				if(enabled)then
					addonTitleTag:SetTextColor(1.0,0.7,0.0)
				else
					addonTitleTag:SetTextColor(0.0,1.0,0.0)
				end
			else
				addonTitleTag:SetText("Disabled")
				if(not enabled)then
					addonTitleTag:SetTextColor(1.0,0.7,0.0)
				else
					addonTitleTag:SetTextColor(1.0,0.0,0.0)
				end
			end
			addonLogTitle:SetTextColor(color.r, color.g, color.b)
			addonLogTitle.r = color.r
			addonLogTitle.g = color.g
			addonLogTitle.b = color.b
			addonLogTitle:Show()
		end
	end
end
function AddOns_TitleButton_OnClick()
	local AddOnID = this:GetID() + FauxScrollFrame_GetOffset(AddOns_List_Scroll)
	local buttonID = this:GetID()
	local addonTitleTag = getglobal("AddOns_List_Title"..buttonID.."Tag")
	local name, title, notes, enabled, loadable, reason, security = GetAddOnInfo(AddOnID)
	if(AddOns_AddOnList[AddOnID] == 1) then
		addonTitleTag:SetText("Disabled")
		if(not enabled)then
			addonTitleTag:SetTextColor(1.0,0.7,0.0)
		else
			addonTitleTag:SetTextColor(1.0,0.0,0.0)
		end
		AddOns_AddOnList[AddOnID] = 0
	else
		addonTitleTag:SetText("Enabled")
		if(enabled)then
			addonTitleTag:SetTextColor(1.0,0.7,0.0)
		else
			addonTitleTag:SetTextColor(0.0,1.0,0.0)
		end
		AddOns_AddOnList[AddOnID] = 1
	end
end
function AddOns_TitleButton_OnEnter()
	local buttonID = this:GetID() + FauxScrollFrame_GetOffset(AddOns_List_Scroll)
	local name, title, notes, enabled, loadable, reason, security = GetAddOnInfo(buttonID)
	local dependencies = GetAddOnDependencies(buttonID)
	local loadondemand = IsAddOnLoadOnDemand(buttonID)
	if (title == nil) then
		title = "No Title"
	end
	if (dependencies == nil) then
		dependencies = "No Dependencies"
	end
	if(notes == nil) then
		notes = "No Notes"
	end
	if(loadondemand) then
		loadondemand = "|CFF00FF00True|r"
	else
		loadondemand = "|CFFFF0000False|r"
	end
	if(loadable ~= nil)then
		GameTooltip_AddNewbieTip(name, 1.0, 1.0, 1.0, title.."\n"..notes.."\n|CFFFFFFFFAddon is Loadable:|r|CFF00FF00True|r\n".."|CFFFFFFFFLoadOnDemand:|r "..loadondemand.."\n|CFFFFFFFFDependencies:|r "..dependencies, 1)
	elseif(reason == "DISABLED") then
		GameTooltip_AddNewbieTip(name, 1.0, 1.0, 1.0, title.."\n"..notes.."\n|CFFFFFFFFAddon is Loadable:|r |CFFFF0000False|r\n|CFFFFFFFFReason:|r |CFFFF0000"..reason.."|r\n|CFFFFFFFFYou might still enable this addon.|r\n".."|CFFFFFFFFLoadOnDemand:|r "..loadondemand.."\n|CFFFFFFFFDependencies:|r "..dependencies, 1)
	else
		GameTooltip_AddNewbieTip(name, 1.0, 1.0, 1.0, title.."\n"..notes.."\n|CFFFFFFFFAddon is Loadable:|r|CFFFF0000 False|r\n|CFFFFFFFFReason:|r |CFFFF0000"..reason.."|r\n".."|CFFFFFFFFLoadOnDemand:|r "..loadondemand.."\n|CFFFFFFFFDependencies:|r "..dependencies, 1)
	end
end
function AddOns_AcceptButton_OnClick()
	local i
	local numaddons = GetNumAddOns()
	local IsChanges = 0
	local SaveIndex = 1
	for i=1, numaddons, 1 do
		local name, title, notes, enabled, loadable, reason, security = GetAddOnInfo(i)
		if(AddOns_AddOnList[i] ~= enabled) then
			if (AddOns_AddOnList[i] == 1) then
				EnableAddOn(i)
			else
				DisableAddOn(i)
			end
			IsChanges = 1
		end
	end
	AddOns_ListShowHide()
	if(IsChanges == 1)then
		ReloadUI()
	end
end
function AddOns_ReloadUIButton()
	ReloadUI()
end
function AddOns_EnableAll()
	local i
	local numaddons = GetNumAddOns()
	for i=1, numaddons, 1 do
		AddOns_AddOnList[i] = 1
		if( i <= AddOns_ADDONS_DISPLAYED)then
			local addonTitleTag = getglobal("AddOns_List_Title"..i.."Tag")
			local name, title, notes, enabled, loadable, reason, security = GetAddOnInfo(i)
			addonTitleTag:SetText("Enabled")
			if(enabled)then
				addonTitleTag:SetTextColor(1.0,0.7,0.0)
			else
				addonTitleTag:SetTextColor(0.0,1.0,0.0)
			end
		end
	end
end
function AddOns_DisableAll()
	local i
	local numaddons = GetNumAddOns()
	for i=1, numaddons, 1 do
		AddOns_AddOnList[i] = 0
		if( i <= AddOns_ADDONS_DISPLAYED)then
			local addonTitleTag = getglobal("AddOns_List_Title"..i.."Tag")
			local name, title, notes, enabled, loadable, reason, security = GetAddOnInfo(i)
			addonTitleTag:SetText("Disabled")
			if(not enabled)then
				addonTitleTag:SetTextColor(1.0,0.7,0.0)
			else
				addonTitleTag:SetTextColor(1.0,0.0,0.0)
			end
		end
	end
end
function AddOns_ProfilesShowHide()
	if (AddOns_List_Profiles:IsVisible()) then
		HideUIPanel(AddOns_List_Profiles)
	else
		ShowUIPanel(AddOns_List_Profiles)
	end
end
function AddOns_Profiles_ProfilesDropDown_OnLoad()
	UIDropDownMenu_SetWidth(220)
	UIDropDownMenu_Initialize(this,AddOns_InitializeDropDown)
end
function AddOns_InitializeDropDown()
	local info
	for i=1,table.getn(AddOns_Profiles) do
		info = {}
		info.text = AddOns_Profiles[i][1]
		info.func = AddOns_LoadProfile
		UIDropDownMenu_AddButton(info)
	end
end
function AddOns_LoadProfile()
	UIDropDownMenu_SetSelectedID(ProfilesDropDown, this:GetID())
	AddOns_DisableAll()
	local i
	local numaddons = GetNumAddOns()
	id = this:GetID()
	for j=2,table.getn(AddOns_Profiles[this:GetID()]) do
		local loadname = AddOns_Profiles[this:GetID()][j]
		for i=1, numaddons, 1 do
			local name, title, notes, enabled, loadable, reason, security = GetAddOnInfo(i)
			local addonTitleTag = getglobal("AddOns_List_Title"..i.."Tag")
			if (name == loadname) then
				AddOns_AddOnList[i] = 1
			end
		end
	end
	AddOns_List_Update()
	SaveProfileEditBox:SetText(AddOns_Profiles[this:GetID()][1])
end
function AddOns_SaveProfile()
	local i,j
	local ProfileText = SaveProfileEditBox:GetText()
	local newKey
	local found = false
	if(not(ProfileText == "")) then
		newKey = table.getn(AddOns_Profiles) + 1
		for i=1, table.getn(AddOns_Profiles) do
			if (AddOns_Profiles[i][1] == ProfileText) then
				newKey = i
				found = true
			end
		end
		if(not(found))then
			AddOns_Profiles[newKey] = {[1] = SaveProfileEditBox:GetText()}
			DEFAULT_CHAT_FRAME:AddMessage("|CFF00FF00AddOns|r - |CFFFFFFFF"..SaveProfileEditBox:GetText().."|r has been |CFF00FF00ADDED|r to profiles list!")
		else
			DEFAULT_CHAT_FRAME:AddMessage("|CFF00FF00AddOns|r - |CFFFFFFFF"..SaveProfileEditBox:GetText().."|r has been |CFF00FF00MODIFIED|r in the profiles list!")
		end
		local numaddons = GetNumAddOns()
		j=2
		for i=1, numaddons, 1 do
			if(AddOns_AddOnList[i] == 1) then
				AddOns_Profiles[newKey][j] = GetAddOnInfo(i)
				j = j+1
			end
		end
	else
		DEFAULT_CHAT_FRAME:AddMessage("|CFF00FF00AddOns|r - |CFFFF0000You have to write a name for the profile!|r")
	end
end
function AddOns_DeleteProfile()
	if (not(id == nil)) then
		DEFAULT_CHAT_FRAME:AddMessage("|CFF00FF00AddOns|r - |CFFFF0000DELETED ID#"..id.."!|r")
		table.remove(AddOns_Profiles,id)
		if(table.getn(AddOns_Profiles) == 0) then
			AddOns_Profiles = {}
			id=nil
		end
	end
end
	-- EquipCompare
EQUIPCOMPARE_EQUIPPED_LABEL = "Currently Equipped"
EQUIPCOMPARE_INVTYPE_WAND = "Wand"
EQUIPCOMPARE_INVTYPE_GUN = "Gun"
EQUIPCOMPARE_INVTYPE_GUNPROJECTILE = "Projectile"
EQUIPCOMPARE_INVTYPE_BOWPROJECTILE = "Projectile"
EQUIPCOMPARE_INVTYPE_CROSSBOW = "Crossbow"
EQUIPCOMPARE_INVTYPE_THROWN = "Thrown"
if (not INVTYPE_WAND) then INVTYPE_WAND = EQUIPCOMPARE_INVTYPE_WAND end
if (not INVTYPE_GUN) then INVTYPE_GUN = EQUIPCOMPARE_INVTYPE_GUN end
if (not INVTYPE_GUNPROJECTILE) then INVTYPE_GUNPROJECTILE = EQUIPCOMPARE_INVTYPE_GUNPROJECTILE end
if (not INVTYPE_BOWPROJECTILE) then INVTYPE_BOWPROJECTILE = EQUIPCOMPARE_INVTYPE_BOWPROJECTILE end
if (not INVTYPE_CROSSBOW) then INVTYPE_CROSSBOW = EQUIPCOMPARE_INVTYPE_CROSSBOW end
if (not INVTYPE_THROWN) then INVTYPE_THROWN = EQUIPCOMPARE_INVTYPE_THROWN end
INVTYPE_WEAPON_OTHER = INVTYPE_WEAPON.."_other"
INVTYPE_FINGER_OTHER = INVTYPE_FINGER.."_other"
INVTYPE_TRINKET_OTHER = INVTYPE_TRINKET.."_other"
EquipCompare_ItemTypes = {
	[INVTYPE_2HWEAPON] = "MainHandSlot",
	[INVTYPE_BODY] = "ShirtSlot",
	[INVTYPE_CHEST] = "ChestSlot",
	[INVTYPE_CLOAK] = "BackSlot",
	[INVTYPE_FEET] = "FeetSlot",
	[INVTYPE_FINGER] = "Finger0Slot",
	[INVTYPE_FINGER_OTHER] = "Finger1Slot",
	[INVTYPE_HAND] = "HandsSlot",
	[INVTYPE_HEAD] = "HeadSlot",
	[INVTYPE_HOLDABLE] = "SecondaryHandSlot",
	[INVTYPE_LEGS] = "LegsSlot",
	[INVTYPE_NECK] = "NeckSlot",
	[INVTYPE_RANGED] = "RangedSlot",
	[INVTYPE_RELIC] = "RangedSlot",
	[INVTYPE_ROBE] = "ChestSlot",
	[INVTYPE_SHIELD] = "SecondaryHandSlot",
	[INVTYPE_SHOULDER] = "ShoulderSlot",
	[INVTYPE_TABARD] = "TabardSlot",
	[INVTYPE_TRINKET] = "Trinket0Slot",
	[INVTYPE_TRINKET_OTHER] = "Trinket1Slot",
	[INVTYPE_WAIST] = "WaistSlot",
	[INVTYPE_WEAPON] = "MainHandSlot",
	[INVTYPE_WEAPON_OTHER] = "SecondaryHandSlot",
	[INVTYPE_WEAPONMAINHAND] = "MainHandSlot",
	[INVTYPE_WEAPONOFFHAND] = "SecondaryHandSlot",
	[INVTYPE_WRIST] = "WristSlot",
	[INVTYPE_WAND] = "RangedSlot",
	[INVTYPE_GUN] = "RangedSlot",
	[INVTYPE_GUNPROJECTILE] = "AmmoSlot",
	[INVTYPE_BOWPROJECTILE] = "AmmoSlot",
	[INVTYPE_CROSSBOW] = "RangedSlot",
	[INVTYPE_THROWN] = "RangedSlot",
}
function EquipCompare_RegisterTooltip(object, priority)
	local i
	if ( not priority ) then
		priority = "low"
	end
	if ( not object or priority ~= "high" and priority ~= "low" ) then
		return false
	end
	if ( not EquipCompare_TooltipList ) then
		EquipCompare_InitializeTooltipList()
	end
	for i = 1, table.getn(EquipCompare_TooltipList) do
		if ( EquipCompare_TooltipList[i] == object ) then
			return true
		end
	end
	if ( priority == "high" ) then
		table.insert(EquipCompare_TooltipList, 1, object)
	else
		table.insert(EquipCompare_TooltipList, object)
	end
	local oldHandler = object:GetScript("OnTooltipCleared")
	object:SetScript("OnTooltipCleared", function(a1,a2,a3,a4,a5)
		local r1,r2,r3,r4,r5
		if ( oldHandler ) then
			r1,r2,r3,r4,r5 = oldHandler(a1,a2,a3,a4,a5)
		end
		EquipCompare_PostClearTooltip()
		return r1,r2,r3,r4,r5
	end)
	return true
end
function EquipCompare_GetComparisonAnchor()
	EquipCompare_CheckCompare()
	if ( not IsShiftKeyDown() ) then
		EquipCompare_HideTips()
	end
	return EquipCompare_TargetTooltip, EquipCompare_Alignment
end
function EquipCompare_OnLoad()
	EquipCompare_SetupHooks()
	EquipCompare_InitializeTooltipList()
end
function EquipCompare_OnEvent()
end
function EquipCompare_PostClearTooltip()
	if ( not EquipCompare_Protected ) then
		EquipCompare_Recheck = true
	end
end
function EquipCompare_OnUpdate()
	if (not AutoMate.EquipCompare == true) then
		return
	end
	if ( not IsShiftKeyDown() ) then
		if (EquipCompare_TargetTooltip) then
			EquipCompare_Recheck = true
			EquipCompare_TargetTooltip = nil
			EquipCompare_HideTips()
		end
		return
	end
	if (EquipCompare_TargetTooltip and not EquipCompare_TargetTooltip:IsVisible()) then
		EquipCompare_Recheck = true
		EquipCompare_TargetTooltip = nil
		EquipCompare_HideTips()
	end
	if ( not EquipCompare_Recheck ) then
	 	return
	end
	EquipCompare_CheckCompare()
end
function EquipCompare_SetupHooks()
	EquipCompare_old_SetAuctionCompareItem1 = ShoppingTooltip1.SetAuctionCompareItem
	EquipCompare_old_SetAuctionCompareItem2 = ShoppingTooltip2.SetAuctionCompareItem
	ShoppingTooltip1.SetAuctionCompareItem = function(a1,a2,a3,a4,a5)
		if (AutoMate.EquipCompare == true) then
			return false
		else
			return EquipCompare_old_SetAuctionCompareItem1(a1,a2,a3,a4,a5)
		end
	end
	ShoppingTooltip2.SetAuctionCompareItem = function(a1,a2,a3,a4,a5)
		if (AutoMate.EquipCompare == true) then
			return false
		else
			return EquipCompare_old_SetAuctionCompareItem2(a1,a2,a3,a4,a5)
		end
	end
	EquipCompare_old_SetMerchantCompareItem1 = ShoppingTooltip1.SetMerchantCompareItem
	EquipCompare_old_SetMerchantCompareItem2 = ShoppingTooltip2.SetMerchantCompareItem
	ShoppingTooltip1.SetMerchantCompareItem = function(a1,a2,a3,a4,a5)
		if (AutoMate.EquipCompare == true) then
			return false
		else
			return EquipCompare_old_SetMerchantCompareItem1(a1,a2,a3,a4,a5)
		end
	end
	ShoppingTooltip2.SetMerchantCompareItem = function(a1,a2,a3,a4,a5)
		if (AutoMate.EquipCompare == true) then
			return false
		else
			return EquipCompare_old_SetMerchantCompareItem2(a1,a2,a3,a4,a5)
		end
	end
end
local function EquipCompare_EmptyFunction() end
function EquipCompare_InitializeTooltipList()
	if ( not EquipCompare_TooltipList ) then
		EquipCompare_TooltipList = {}
	end
	EquipCompare_RegisterTooltip(ItemRefTooltip, "high")
	EquipCompare_RegisterTooltip(LootLinkTooltip)
	EquipCompare_RegisterTooltip(GameTooltip, "low")
end
local showedTip = false
function EquipCompare_HideTips()
	ComparisonTooltip1:Hide()
	ComparisonTooltip2:Hide()
end
local function AddLabel(tooltip, slot)
	local tLabel, tLabel1
	if (not tooltip or not tooltip:IsVisible()) then
		return
	end
	tLabel = getglobal(tooltip:GetName().."TextLeft0")
	tLabel:SetText(EQUIPCOMPARE_EQUIPPED_LABEL)
	tLabel:SetTextColor(0.5, 0.5, 0.5)
	tLabel:Show()
	tLabel1 = getglobal(tooltip:GetName().."TextLeft1")
	if ( tLabel:IsVisible() and tLabel1:IsVisible() ) then
		if ( tLabel:GetWidth() > tLabel1:GetWidth() ) then
			tLabel1:SetWidth(tLabel:GetWidth())
			tooltip:Show()
		end
	end
end
local function ShowComparisonTooltip(parent, slotid)
	local leftAlign, donePlacing
	local left, right, i
	ComparisonTooltip1:SetOwner(parent, "ANCHOR_LEFT")
	ComparisonTooltip1:SetInventoryItem("player", slotid)
	AddLabel(ComparisonTooltip1, slotid)
	if ( not ComparisonTooltip1:IsVisible() ) then
		return
	end
	leftAlign = false
	if ( parent == GameTooltip and GetMouseFocus() ) then
		local mfocus = GetMouseFocus():GetName()
		if ( mfocus and string.find(mfocus,"^ContainerFrame.*Item") ) then
			leftAlign = true
		end
	end
	donePlacing = true
	repeat
		ComparisonTooltip1:ClearAllPoints()
		if (leftAlign) then
			ComparisonTooltip1:SetPoint("TOPRIGHT", parent:GetName(), "TOPLEFT", 0, 0)
		else
			ComparisonTooltip1:SetPoint("TOPLEFT", parent:GetName(), "TOPRIGHT", 0, 0)
		end
		local left = ComparisonTooltip1:GetLeft()
		local right = ComparisonTooltip1:GetRight()
		if ( left and right ) then
			left, right = left - (right-left), right + (right-left)
		end
		if ( donePlacing ) then
			if ( left and left<0 ) then
				leftAlign = false
				donePlacing = false
			elseif ( right and right>UIParent:GetRight() ) then
				leftAlign = true
				donePlacing = false
			end
		else
			donePlacing = true
		end
	until donePlacing
	return leftAlign
end
function EquipCompare_CheckCompare()
	local tooltip = nil
	local i = 1
	if ( not EquipCompare_TooltipList ) then
		EquipCompare_InitializeTooltipList()
	end
	repeat
		tooltip = EquipCompare_TooltipList[i]
		if ( not tooltip:IsVisible() ) then
			tooltip = nil
		end
		i = i + 1
	until tooltip or i > table.getn(EquipCompare_TooltipList)
	EquipCompare_TargetTooltip = tooltip
	EquipCompare_Alignment = nil
	if ( tooltip ) then
		EquipCompare_ShowCompare(tooltip)
	end
end
local function GetSlotID(slotName)
	if (slotName) then
		return GetInventorySlotInfo(slotName)
	end
end
function EquipCompare_ShowCompare(tooltip)
	local OverrideTooltips = nil
	local ttext, itype, slotid, other, leftAlign
	local i, cvplayer
	local shift, comptipclose, comptipfar, point, relative
	local mfocus
	EquipCompare_Recheck = false
	EquipCompare_HideTips()
	if ( tooltip == GameTooltip ) then
		if ( GetMouseFocus() ) then
			mfocus = GetMouseFocus():GetName()
		end
	end
	slotid = nil
	i = 2
	repeat
		ttext = getglobal(tooltip:GetName().."TextLeft"..i)
		if ( ttext and ttext:IsVisible() ) then
			itype = ttext:GetText()
			if ( itype ) then
				slotid = GetSlotID(EquipCompare_ItemTypes[itype])
			end
		end
		i = i + 1
	until (slotid or i > 5)
	if ( slotid ) then
		EquipCompare_Protected = true
		local oldFunction = GameTooltip_ClearMoney
		GameTooltip_ClearMoney = EquipCompare_EmptyFunction
		leftAlign = ShowComparisonTooltip(tooltip, slotid)
		other = false
		if ( itype == INVTYPE_FINGER ) then
			other = GetSlotID(EquipCompare_ItemTypes[INVTYPE_FINGER_OTHER])
		end
		if ( itype == INVTYPE_TRINKET ) then
			other = GetSlotID(EquipCompare_ItemTypes[INVTYPE_TRINKET_OTHER])
		end
		if ( itype == INVTYPE_WEAPON ) then
			other = GetSlotID(EquipCompare_ItemTypes[INVTYPE_WEAPON_OTHER])
		end
		if ( itype == INVTYPE_2HWEAPON ) then
			other = GetSlotID(EquipCompare_ItemTypes[INVTYPE_SHIELD])
		end
		if ( other ) then
			if ( ComparisonTooltip1:IsVisible() ) then
				ComparisonTooltip2:SetOwner(ComparisonTooltip1, "ANCHOR_LEFT")
				ComparisonTooltip2:SetInventoryItem("player", other)
				AddLabel(ComparisonTooltip2, other)
				if ( ComparisonTooltip2:IsVisible() ) then
					ComparisonTooltip2:ClearAllPoints()
					if ( leftAlign ) then
						ComparisonTooltip1:ClearAllPoints()
						ComparisonTooltip2:SetPoint("TOPRIGHT", tooltip:GetName(), "TOPLEFT", 0, 0)
						ComparisonTooltip1:SetPoint("TOPRIGHT", "ComparisonTooltip2", "TOPLEFT", 0, 0)
					else
						ComparisonTooltip2:SetPoint("TOPLEFT", "ComparisonTooltip1", "TOPRIGHT", 0, 0)
					end
				end
			else
				ShowComparisonTooltip(tooltip, other)
			end
		end
		if ( leftAlign ) then
			EquipCompare_Alignment = "left"
		else
			EquipCompare_Alignment = "right"
		end
		GameTooltip_ClearMoney = oldFunction
		EquipCompare_Protected = false
	end
end