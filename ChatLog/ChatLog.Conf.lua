--ADDON INFORMATION
CHAT_LOG_TITLE = "ChatLog";
CHAT_LOG_VERSION = "1.2.4";

--FUNCTIONS PARAMETERS & GLOBAL SETTINGS
--Global settings
CHAT_LOG_CHAT_ENABLED = 0;
CHAT_LOG_COMBATCHAT_ENABLED = 0;
CHAT_LOG_ALPHA = 1;
CHAT_LOG_MAXSIZE = 1000;
CHAT_LOG_COPY_MAXSIZE = 500;
CHAT_LOG_SCROLLING_MESSAGE_FRAME_MAXLINES = 31;
CHAT_LOG_DROPDOWN_MAXBUTTONS = 25;
CHAT_LOG_CURRENT_MAXLINE = 0;
CHAT_LOG_ENABLED_DEFAULT = 1;
--Chat IDs
CHAT_LOG_WHISPER_ID = "684170601";
CHAT_LOG_RAID_ID = "684170602";
CHAT_LOG_PARTY_ID = "684170603";
CHAT_LOG_SAY_ID = "684170604";
CHAT_LOG_YELL_ID = "684170605";
CHAT_LOG_OFFICER_ID = "684170606";
CHAT_LOG_GUILD_ID = "684170607";
--Chat index
CHAT_LOG_WHISPER_INDEX = 0;
CHAT_LOG_RAID_INDEX = 0;
CHAT_LOG_PARTY_INDEX = 0;
CHAT_LOG_SAY_INDEX = 0;
CHAT_LOG_YELL_INDEX = 0;
CHAT_LOG_OFFICER_INDEX = 0;
CHAT_LOG_GUILD_INDEX = 0;
--Current displayed index
CHAT_LOG_CURRENT_INDEX = 0;
CHAT_LOG_DEFAULT_INDEX = 1;
--ChatTypeInfo table correction 
CHAT_LOG_COLORS = {};
CHAT_LOG_COLORS["SYSTEM"] = {
	r = 1.0;
	g = 1.0;
	b = 0.0;
};
CHAT_LOG_COLORS["RAID_LEADER"] = {
	r = 1.0;
	g = 1.0;
	b = 0.0;
};

--LOGS
--Main structure
ChatLog_Logs = {};
--Default chats
ChatLog_Logs[1] = {};
ChatLog_Logs[2] = {};
ChatLog_Logs[3] = {};
ChatLog_Logs[4] = {};
ChatLog_Logs[5] = {};
ChatLog_Logs[6] = {};
ChatLog_Logs[7] = {};
--Logs for chats are enabled by default
ChatLog_Logs[1]["enabled"] = 1;
ChatLog_Logs[2]["enabled"] = 1;
ChatLog_Logs[3]["enabled"] = 1;
ChatLog_Logs[4]["enabled"] = 1;
ChatLog_Logs[5]["enabled"] = 1;
ChatLog_Logs[6]["enabled"] = 1;
ChatLog_Logs[7]["enabled"] = 1;
--Logs tables
ChatLog_Logs[1]["logs"] = {};
ChatLog_Logs[2]["logs"] = {};
ChatLog_Logs[3]["logs"] = {};
ChatLog_Logs[4]["logs"] = {};
ChatLog_Logs[5]["logs"] = {};
ChatLog_Logs[6]["logs"] = {};
ChatLog_Logs[7]["logs"] = {};

--STATUS
CHAT_LOG_NUM_PARTY_MEMBERS = 0;
CHAT_LOG_NUM_RAID_MEMBERS = 0;