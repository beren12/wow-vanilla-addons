--[[
	AutoSave Main Program
	
	By: Jebus
	Original Code Written: Nov. 13 2007
	
	AddOn will issue a ".save" command:
		- every 5 minutes
		- When a level up occurrs
		- When a vendor window closes
		- When the bank frame closes
		- When the Trainer window closes
]]--

-- Constants
AS_VERSION = "3.0a";
SAVE_MIN = 60; -- 5min * 60sec = 300sec

-- local variables
local TimeSinceLastSave = 0;
local EventSaves = 0;
local DeferSave = false;

-- Utility functions
function AutoSave_SaveChar(suppress)
	--DEFAULT_CHAT_FRAME:AddMessage("DEBUG: suppress="..tostring(suppress).." EventSaves="..AutoSaveFrame.EventSaves);
	if(suppress == false) then
		AutoSaveFrame.EventSaves = AutoSaveFrame.EventSaves + 1;
	end
	if(suppress == true or mod(AutoSaveFrame.EventSaves, 2) == 0) then
		if(UnitIsDeadOrGhost("player")) then
			DEFAULT_CHAT_FRAME:AddMessage(AS_MSG_DEAD_SKIP);
			DeferSave = true;
		else
			SendChatMessage(".save", "SAY");
			DEFAULT_CHAT_FRAME:AddMessage(AS_MSG_SAVED);
		end
	end
end

-- OnFoo functions
function AutoSave_OnLoad()
	AutoSaveFrame.TimeSinceLastSave = 0;
	AutoSaveFrame.EventSaves = 0;
	
	-- Register Events
	this:RegisterEvent("ADDON_LOADED");
	this:RegisterEvent("PLAYER_LEVEL_UP");
	this:RegisterEvent("MERCHANT_CLOSED");
	this:RegisterEvent("BANKFRAME_CLOSED");
	this:RegisterEvent("TRAINER_CLOSED");
	this:RegisterEvent("PLAYER_CAMPING");
	this:RegisterEvent("CHARACTER_POINTS_CHANGED");
	this:RegisterEvent("PLAYER_UNGHOST");
	
	-- Register slash command
	SLASH_AUTOSAVE1 = "/save";
	SlashCmdList["AUTOSAVE"] = AutoSave_OnSlashSave;
end

function AutoSave_OnUpdate(arg1)
	AutoSaveFrame.TimeSinceLastSave = AutoSaveFrame.TimeSinceLastSave + arg1;
	if( AutoSaveFrame.TimeSinceLastSave >= SAVE_MIN ) then
		AutoSave_SaveChar(true);
		--AutoSaveFrame.TimeSinceLastSave = 0;
		AutoSaveFrame.TimeSinceLastSave = AutoSaveFrame.TimeSinceLastSave - SAVE_MIN;
	end
end

function AutoSave_OnEvent(arg1)
	--DEFAULT_CHAT_FRAME:AddMessage("DEBUG: Event Received: "..event.." arg1="..arg1.." AutoSaveFrame.isLoaded: "..tostring(AutoSaveFrame.isLoaded));
	if(event == "ADDON_LOADED" and arg1=="AutoSave") then
		DEFAULT_CHAT_FRAME:AddMessage("AutoSave v"..AS_VERSION.." loaded.", 0.9, 0.6, 0.2);
		
	elseif(event == "MERCHANT_CLOSED" or event=="BANKFRAME_CLOSED" ) then
		-- These events fire twice, so suppress the 2nd event
		AutoSave_SaveChar(false);
		
	elseif(event == "PLAYER_LEVEL_UP" or event == "TRAINER_CLOSED" or event == "PLAYER_CAMPING") then
		-- these events fire once.
		AutoSave_SaveChar(true);
		
	elseif(event == "CHARACTER_POINTS_CHANGED") then
		if(arg1 < 0) then
			AutoSave_SaveChar(true);
		end
		
	elseif(event == "PLAYER_UNGHOST") then
		if(DeferSave) then
			DeferSave = false;
			DEFAULT_CHAT_FRAME:AddMessage(AS_MSG_RES_SAVE);
			AutoSave_SaveChar(true);
		end
	end
end

function AutoSave_OnSlashSave()
	AutoSave_SaveChar(true);
end
