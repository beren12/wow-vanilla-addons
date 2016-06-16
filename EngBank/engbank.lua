EngBank_VERSION = "20060412";



-- Constants
EngBank_DEBUGMESSAGES = 0;         -- 0 = off, 1 = on
EngBank_SHOWITEMDEBUGINFO = 0;
EngBank_WIPECONFIGONLOAD = 0;	-- for debugging, test it out on a new config every load

EngBank_MAX_BARS = 15;

BINDING_HEADER_EngBank = "EngBank "..EngBank_VERSION;
BINDING_NAME_EB_TOGGLE = "Toggle Inventory Window";

EngBank_MAXBUTTONS = 144;
EngBank_BUTTONFRAME_X_PADDING = 2;
EngBank_BUTTONFRAME_BUTTONWIDTH = 30;
EngBank_BUTTONFRAME_WIDTH = EngBank_BUTTONFRAME_BUTTONWIDTH + (EngBank_BUTTONFRAME_X_PADDING*2);
EngBank_BUTTONFRAME_Y_PADDING = 1;
EngBank_BUTTONFRAME_BUTTONHEIGHT = 30;
EngBank_BUTTONFONTHEIGHT = 0.35 * EngBank_BUTTONFRAME_BUTTONHEIGHT;
EngBank_BUTTONFRAME_HEIGHT = EngBank_BUTTONFRAME_BUTTONHEIGHT + (EngBank_BUTTONFRAME_Y_PADDING*2);
EngBank_BKGRFRAME_WIDTH = EngBank_BUTTONFRAME_BUTTONWIDTH * 1.6;  -- 40 -> 64
EngBank_BKGRFRAME_HEIGHT = EngBank_BUTTONFRAME_BUTTONHEIGHT * 1.6;
EngBank_COOLDOWN_SCALE = 0.85;

EngBank_TOP_PADWINDOW = 75;

EngBank_SORTLOWESTVALUE = 0;
EngBank_NOSORT = 0;
EngBank_SORTBYNAME = 1;
EngBank_SORTBYNAMEREV = 2; -- reverses the name then sorts it:  ie:   "Potion Mana Major" vs "Major Mana Potion"
EngBank_SORTHIGHESTVALUE = 2;

EngBank_MAXCOLUMNS_MAX = 20;
EngBank_MAXCOLUMNS_MIN = 8;

EngBank_BUTTONSIZE_MIN = 25;
EngBank_BUTTONSIZE_MAX = 50;

EngBank_FONTSIZE_MIN = 8;
EngBank_FONTSIZE_MAX = 20;

EngBank_MAINWINDOWCOLORIDX = 17;

EngBank_ShowPrice = 1;     -- ???

EngBank_WINDOWBOTTOMPADDING_EDITMODE = 50;
EngBank_WINDOWBOTTOMPADDING_NORMALMODE = 25;

EngBank_WindowBottomPadding = EngBank_WINDOWBOTTOMPADDING_NORMALMODE;

EngReplaceBank          = 1;
local BankFrame_Saved = nil;

--[[ New data layout:

	bar, position = refers to the virtual locations
	bagnum, slotnum = refers to physical bag/slot

	EngBank_item_cache[ bag ][ bag_slot ]
		- Contains all the data we collect from the items in the bags.
		- We collect this data before sorting!
	EngBank_bar_positions[ bar_number ][ position ] = { ["bagnum"]=bagnum, ["slotnum"]=slotnum }
		- Contains the final locations in my window after sorting
	EngBank_buttons[ frame_name ] = { ["bagnum"]=bagnum, ["slotnum"]=slotnum }
--]]

EngBank_item_cache = { {}, {}, {}, {}, {}, {}, {} };	-- cache of all the items as they appear in bags
EngBank_bar_positions = {};
EngBank_buttons = {};
EngBank_hilight_new = 0;
EngBank_edit_mode = 0;
EngBank_edit_hilight = "";         -- when editmode is 1, which items do you want to hilight
EngBank_edit_selected = "";        -- when editmode is 1, this is the class of item you clicked on
EngBank_RightClickMenu_mode = "";
EngBank_RightClickMenu_opts = {};

EngBank_NOTNEEDED = 0;	-- when items haven't changed, or only item counts
EngBank_REQUIRED = 1;	-- when items have changed location, but it's been sorted once and won't break if we don't sort again
EngBank_MANDATORY = 2;	-- it's never been sorted, the window is in an unstable state, you MUST sort.

EngBank_resort_required = EngBank_MANDATORY;
EngBank_window_update_required = EngBank_MANDATORY;

EngBank_BuildTradeList = {};	-- only build a full list of trade skill info once

-- These are catagories to leave off the right click menu.  just trying to make space
--	** not needed anymore, since I created a 3rd level of the dropdown
--[[ EngBank_Catagories_Exclude_List = {
	["BANDAGES"] = 1,
	["EMPTY_PROJECTILE_SLOTS"] = 1,
	["EMPTY_SLOTS"] = 1,
	["HEALTHSTONE"] = 1,
	["JUJU"] = 1
	}; --]]
EngBank_Catagories_Exclude_List = {};
------------------------

------------------------

function EngBank_CalcButtonSize(newsize)
	local k = "button_size_opts";
	-- constants
	EngBank_BUTTONFRAME_X_PADDING = 2;
	EngBank_BUTTONFRAME_Y_PADDING = 1;
	EngBank_BUTTONFRAME_BUTTONWIDTH = newsize;
	EngBank_BUTTONFRAME_BUTTONHEIGHT = newsize;
	EngBank_BUTTONFRAME_WIDTH = EngBank_BUTTONFRAME_BUTTONWIDTH + (EngBank_BUTTONFRAME_X_PADDING*2);
	EngBank_BUTTONFRAME_HEIGHT = EngBank_BUTTONFRAME_BUTTONHEIGHT + (EngBank_BUTTONFRAME_Y_PADDING*2);
	EngBank_BKGRFRAME_WIDTH = EngBank_BUTTONFRAME_BUTTONWIDTH * 1.6;
	EngBank_BKGRFRAME_HEIGHT = EngBank_BUTTONFRAME_BUTTONHEIGHT * 1.6;
	EngBank_COOLDOWN_SCALE = 0.02125 * EngBank_BUTTONFRAME_BUTTONWIDTH;

	if (EngBankConfig[k] == nil) then
		EngBankConfig[k] = {
			["EngBank_BUTTONFONTHEIGHT"] = 0.35 * EngBank_BUTTONFRAME_BUTTONHEIGHT,
			["EngBank_BUTTONFONTHEIGHT2"] = 0.30 * EngBank_BUTTONFRAME_BUTTONHEIGHT,
			["EngBank_BUTTONFONTDISTANCE_Y"] = (0.08 * EngBank_BUTTONFRAME_WIDTH),
			["EngBank_BUTTONFONTDISTANCE_X"] = (0.10 * EngBank_BUTTONFRAME_HEIGHT)
		};

		if (newsize == 40) then
			EngBankConfig[k]["EngBank_BUTTONFONTHEIGHT"] = 14;
			EngBankConfig[k]["EngBank_BUTTONFONTHEIGHT2"] = 12;
			EngBankConfig[k]["EngBank_BUTTONFONTDISTANCE_Y"] = 2;
			EngBankConfig[k]["EngBank_BUTTONFONTDISTANCE_X"] = 5;
		end
	end

	EngBank_BUTTONFONTHEIGHT = math.ceil(EngBankConfig[k]["EngBank_BUTTONFONTHEIGHT"]);
	EngBank_BUTTONFONTHEIGHT2 = math.ceil(EngBankConfig[k]["EngBank_BUTTONFONTHEIGHT2"]);
	EngBank_BUTTONFONTDISTANCE_Y = EngBankConfig[k]["EngBank_BUTTONFONTDISTANCE_Y"];
	EngBank_BUTTONFONTDISTANCE_X = EngBankConfig[k]["EngBank_BUTTONFONTDISTANCE_X"];
end

-- scan the config and build a list of catagories
function EngBank_Catagories(exclude_list, select_bar)
	local clist, key, value;

	clist = {};

	for key,value in EngBankConfig do
		if ( (string.find(key, "putinslot--")) and (not string.find(key, "__version")) ) then
			barclass = string.sub(key, 12);

			if ( (exclude_list ~= nil) and (not exclude_list[barclass]) ) then
				if ( (select_bar == nil) or (value==select_bar) ) then
					table.insert(clist, barclass);
				end
			end
		end
	end

	table.sort(clist);

	return(clist);
end


function EngBank_NumericRange(value, lowest, highest)
        
        if (value == nil) then return nil; end

        if (type(value) ~= "number") then
                value = tonumber(value);
        end

        if ( (value ~= nil) and (lowest ~= nil) and (value < lowest) ) then
                value = nil;
        end
        if ( (value ~= nil) and (highest ~= nil) and (value > highest) ) then
                value = nil;
        end

        return value;
end

function EngBank_StringChoices(value, choices_array)
        local found = 0;

        if (value == nil) then
                return nil;
        end

        for key,cvalue in choices_array do
                if (value == cvalue) then
                        found = 1;
                end
        end

        if (found == 0) then
                return nil;
        else
                return value;
        end
end

-- sets a default value in the config if the current value is nil.  Increment "resetversion" to override saved values
-- and force a new setting.
function EB_SetDefault(varname, defaultvalue, resetversion, cleanupfunction, cleanup_param1, cleanup_param2)
	local orig_value = EngBankConfig[varname];

if (orig_value == nil) then
		orig_value = "";
	end

        if (resetversion == nil) then
                -- more debugging
                message("* Warning, EngBank EB_SetDefault called with nil reset version: "..varname.." *");
                resetversion = 0;
        end

        if (cleanupfunction ~= nil) then
                EngBankConfig[varname] = cleanupfunction(EngBankConfig[varname], cleanup_param1, cleanup_param2);
        end

        if (EngBankConfig[varname] == nil) then
                EngBankConfig[varname] = defaultvalue;
        elseif (EngBankConfig[varname.."__version"] == nil) then
                EngBankConfig[varname] = defaultvalue;
        elseif (EngBankConfig[varname.."__version"] < resetversion) then
		EngBank_PrintDEBUG("old version: "..EngBankConfig[varname.."__version"]..", resetversion: "..resetversion);
                EngBank_Print( varname.." was reset to it's default value.  Changed from '"..orig_value.."' to "..EngBankConfig[varname], 1,0,0 );
                EngBankConfig[varname] = defaultvalue;
        end

        EngBankConfig[varname.."__version"] = resetversion;
end

function EngBank_SetClassBars()
	local c = {};
	local localizedPlayerClass, englishClass = UnitClass("player");

	--[[
	c["Warlock"] = "putinslot--NON_CLASS_ITEMS";
	c["Mage"] = "putinslot--NON_CLASS_ITEMS";
	c["Priest"] = "putinslot--NON_CLASS_ITEMS";
	c["Hunter"] = "putinslot--NON_CLASS_ITEMS";
	c["Rogue"] = "putinslot--NON_CLASS_ITEMS";
	c["Shaman"] = "putinslot--NON_CLASS_ITEMS";
	c["Druid"] = "putinslot--NON_CLASS_ITEMS";
	c["Warrior"] = "putinslot--NON_CLASS_ITEMS";
	c["Paladin"] = "putinslot--NON_CLASS_ITEMS";
	--]]

	c["WARLOCK"] = "";
	c["MAGE"] = "";
	c["PRIEST"] = "";
	c["HUNTER"] = "";
	c["ROGUE"] = "";
	c["SHAMAN"] = "";
	c["DRUID"] = "";
	c["WARRIOR"] = "";
	c["PALADIN"] = "";

	c[englishClass] = "putinslot--CLASS_ITEMS";

	EngBankConfig["putinslot--SOULSHARDS"] = c["WARLOCK"].."1";
	EngBankConfig["putinslot--WARLOCK_REAGENTS"] = c["WARLOCK"].."2";

	EngBankConfig["putinslot--ROGUE_POISON"] = c["ROGUE"].."1";
	EngBankConfig["putinslot--ROGUE_POWDER"] = c["ROGUE"].."1";

	EngBankConfig["putinslot--MAGE_REAGENT"] = c["MAGE"].."1";

	EngBankConfig["putinslot--SHAMAN_REAGENTS"] = c["SHAMAN"].."1";
end

-- set "re" to 1 to restore all default values
function EngBank_SetDefaultValues(re)
        local i, key, value, newEngBankConfig;
	local current_config_version = 1;	-- increase this number to wipe everyone's settings

        if ( (EngBankConfig == nil) or (EngBankConfig["configVersion"] == nil) or (EngBankConfig["configVersion"] ~= current_config_version) ) then
                EngBankConfig = { ["configVersion"] = current_config_version };
        end

        EB_SetDefault("maxColumns", 9, 1+re, EngBank_NumericRange, EngBank_MAXCOLUMNS_MIN,EngBank_MAXCOLUMNS_MAX);

        EB_SetDefault("moveLock", 1, 1+re, EngBank_NumericRange, 0,1);

	EB_SetDefault("hook_BANKFRAME_OPENED", 1, 1+re, EngBank_NumericRange, 0, 1);
	EB_SetDefault("show_Bag-1", 1, 1+re, EngBank_NumericRange, 0, 1);
	EB_SetDefault("show_Bag5", 1, 1+re, EngBank_NumericRange, 0, 1);
	EB_SetDefault("show_Bag6", 1, 1+re, EngBank_NumericRange, 0, 1);
	EB_SetDefault("show_Bag7", 1, 1+re, EngBank_NumericRange, 0, 1);
	EB_SetDefault("show_Bag8", 1, 1+re, EngBank_NumericRange, 0, 1);
	EB_SetDefault("show_Bag9", 1, 1+re, EngBank_NumericRange, 0, 1);
	EB_SetDefault("show_Bag10", 1, 1+re, EngBank_NumericRange, 0, 1);


        EB_SetDefault("frameWindowScale", 0.85, 1+re, EngBank_NumericRange, 0.64, 1.0);
	EB_SetDefault("frameButtonSize", 40, 1+re, EngBank_NumericRange, 15, 80);

	EngBank_CalcButtonSize(EngBankConfig["frameButtonSize"]);

        EB_SetDefault("frameLEFT", UIParent:GetRight() * UIParent:GetScale() * 0.5, 2+re, EngBank_NumericRange);
        EB_SetDefault("frameRIGHT", UIParent:GetRight() * UIParent:GetScale() * 0.975, 2+re, EngBank_NumericRange);
        EB_SetDefault("frameTOP", UIParent:GetTop() * UIParent:GetScale() * 0.90, 2+re, EngBank_NumericRange);
        EB_SetDefault("frameBOTTOM", UIParent:GetTop() * UIParent:GetScale() * 0.19, 2+re, EngBank_NumericRange);
        EB_SetDefault("frameXRelativeTo", "RIGHT", 1+re, EngBank_StringChoices, {"RIGHT","LEFT"} );
        EB_SetDefault("frameYRelativeTo", "BOTTOM", 1+re, EngBank_StringChoices, {"TOP","BOTTOM"} );

	EB_SetDefault("frameXSpace", 5, 1+re, EngBank_NumericRange, 0, 20);
        EB_SetDefault("frameYSpace", 5, 1+re, EngBank_NumericRange, 0, 20);

	EB_SetDefault("show_top_graphics", 1, 1+re, EngBank_NumericRange, 0, 1);
	EB_SetDefault("build_trade_list", 0, 1+re, EngBank_NumericRange, 0, 1);

        EB_SetDefault("newItemText", "*New*", 1+re);
        EB_SetDefault("newItemTextPlus", "++", 1+re);
        EB_SetDefault("newItemTextMinus", "--", 1+re);
	EB_SetDefault("newItemText_Off", "", 1+re);
        EB_SetDefault("newItemTimeout", 60*60*3 , 1+re, EngBank_NumericRange);     -- 3 hours for an item to lose "new" status
        EB_SetDefault("newItemTimeout2", 60*10 , 1+re, EngBank_NumericRange);      -- 10 minutes
        EB_SetDefault("newItemColor1_R", 0.9 , 1+re, EngBank_NumericRange, 0, 1.0);
        EB_SetDefault("newItemColor1_G", 0.9 , 1+re, EngBank_NumericRange, 0, 1.0);
        EB_SetDefault("newItemColor1_B", 0.2 , 1+re, EngBank_NumericRange, 0, 1.0);
        EB_SetDefault("newItemColor2_R", 0.0 , 1+re, EngBank_NumericRange, 0, 1.0);
        EB_SetDefault("newItemColor2_G", 1.0 , 1+re, EngBank_NumericRange, 0, 1.0);
        EB_SetDefault("newItemColor2_B", 0.4 , 1+re, EngBank_NumericRange, 0, 1.0);

	for i = 1, EngBank_MAINWINDOWCOLORIDX do
		EB_SetDefault("bar_colors_"..i.."_background_r", 0.5, 1+re, EngBank_NumericRange, 0, 1.0);
		EB_SetDefault("bar_colors_"..i.."_background_g", 0.0, 1+re, EngBank_NumericRange, 0, 1.0);
		EB_SetDefault("bar_colors_"..i.."_background_b", 0.0, 1+re, EngBank_NumericRange, 0, 1.0);
		EB_SetDefault("bar_colors_"..i.."_background_a", 0.5, 1+re, EngBank_NumericRange, 0, 1.0);

		EB_SetDefault("bar_colors_"..i.."_border_r", 1.0, 1+re, EngBank_NumericRange, 0, 1.0);
		EB_SetDefault("bar_colors_"..i.."_border_g", 0.0, 1+re, EngBank_NumericRange, 0, 1.0);
		EB_SetDefault("bar_colors_"..i.."_border_b", 0.0, 1+re, EngBank_NumericRange, 0, 1.0);
		EB_SetDefault("bar_colors_"..i.."_border_a", 0.5, 1+re, EngBank_NumericRange, 0, 1.0);
	end

	EngBank_SetClassBars();

        -- default slot locations for items
	EB_SetDefault("putinslot--CLASS_ITEMS1", 15, 1+re, EngBank_NumericRange, 1, EngBank_MAX_BARS);
        --EB_SetDefault("putinslot--SOULSHARDS", 15, 1+re, EngBank_NumericRange, 1, EngBank_MAX_BARS);
        EB_SetDefault("putinslot--EMPTY_PROJECTILE_SLOTS", 15, 1+re, EngBank_NumericRange, 1, EngBank_MAX_BARS);
        EB_SetDefault("putinslot--USED_PROJECTILE_SLOTS", 15, 1+re, EngBank_NumericRange, 1, EngBank_MAX_BARS);
        EB_SetDefault("putinslot--PROJECTILE", 14, 1+re, EngBank_NumericRange, 1, EngBank_MAX_BARS);          -- arrows and bullets that AREN'T in your shot bags
        EB_SetDefault("putinslot--EMPTY_SLOTS", 13, 1+re, EngBank_NumericRange, 1, EngBank_MAX_BARS);         -- Empty slots go in this bar
        EB_SetDefault("putinslot--GRAY_ITEMS", 13, 1+re, EngBank_NumericRange, 1, EngBank_MAX_BARS);          -- Gray items go in this bar
        --
        EB_SetDefault("putinslot--OTHERORUNKNOWN", 12, 1+re, EngBank_NumericRange, 1, EngBank_MAX_BARS);      -- if not soulbound, but doesn't match any other catagory, it goes here
        EB_SetDefault("putinslot--TRADEGOODS", 12, 1+re, EngBank_NumericRange, 1, EngBank_MAX_BARS);
	--EB_SetDefault("putinslot--NON_CLASS_ITEMS1", 12, 1+re, EngBank_NumericRange, 1, EngBank_MAX_BARS);
	EB_SetDefault("putinslot--RECIPE", 12, 1+re, EngBank_NumericRange, 1, EngBank_MAX_BARS);
	EB_SetDefault("putinslot--PATTERN", 12, 1+re, EngBank_NumericRange, 1, EngBank_MAX_BARS);
	EB_SetDefault("putinslot--SCHEMATIC", 12, 1+re, EngBank_NumericRange, 1, EngBank_MAX_BARS);
	EB_SetDefault("putinslot--FORMULA", 12, 1+re, EngBank_NumericRange, 1, EngBank_MAX_BARS);
	EB_SetDefault("putinslot--TRADESKILL_COOKING", 12, 1+re, EngBank_NumericRange, 1, EngBank_MAX_BARS);
	EB_SetDefault("putinslot--TRADESKILL_FIRSTAID", 12, 1+re, EngBank_NumericRange, 1, EngBank_MAX_BARS);
	--EB_SetDefault("putinslot--NON_CLASS_ITEMS2", 12, 1+re, EngBank_NumericRange, 1, EngBank_MAX_BARS);
        EB_SetDefault("putinslot--OTHERSOULBOUND", 11, 1+re, EngBank_NumericRange, 1, EngBank_MAX_BARS);       -- this will usually be soulbound equipment
	EB_SetDefault("putinslot--CUSTOM_01", 10, 1+re, EngBank_NumericRange, 1, EngBank_MAX_BARS);
	EB_SetDefault("putinslot--CUSTOM_02", 10, 1+re, EngBank_NumericRange, 1, EngBank_MAX_BARS);
	EB_SetDefault("putinslot--CUSTOM_03", 10, 1+re, EngBank_NumericRange, 1, EngBank_MAX_BARS);
	EB_SetDefault("putinslot--CUSTOM_04", 10, 1+re, EngBank_NumericRange, 1, EngBank_MAX_BARS);
	EB_SetDefault("putinslot--CUSTOM_05", 10, 1+re, EngBank_NumericRange, 1, EngBank_MAX_BARS);
	EB_SetDefault("putinslot--CUSTOM_06", 10, 1+re, EngBank_NumericRange, 1, EngBank_MAX_BARS);
	--
        EB_SetDefault("putinslot--CONSUMABLE", 9, 1+re, EngBank_NumericRange, 1, EngBank_MAX_BARS);
        EB_SetDefault("putinslot--TRADESKILL_2", 8, 1+re, EngBank_NumericRange, 1, EngBank_MAX_BARS);
        EB_SetDefault("putinslot--TRADESKILL_1", 8, 1+re, EngBank_NumericRange, 1, EngBank_MAX_BARS);
        EB_SetDefault("putinslot--TRADESKILL_2_CREATED", 8, 1+re, EngBank_NumericRange, 1, EngBank_MAX_BARS);
        EB_SetDefault("putinslot--TRADESKILL_1_CREATED", 8, 1+re, EngBank_NumericRange, 1, EngBank_MAX_BARS);
        EB_SetDefault("putinslot--EQUIPPED", 7, 1+re, EngBank_NumericRange, 1, EngBank_MAX_BARS);
        --
        EB_SetDefault("putinslot--FOOD", 6, 1+re, EngBank_NumericRange, 1, EngBank_MAX_BARS);
        EB_SetDefault("putinslot--DRINK", 5, 1+re, EngBank_NumericRange, 1, EngBank_MAX_BARS);
        EB_SetDefault("putinslot--QUESTITEMS", 4, 1+re, EngBank_NumericRange, 1, EngBank_MAX_BARS);
        --
        EB_SetDefault("putinslot--HEALINGPOTION", 3, 1+re, EngBank_NumericRange, 1, EngBank_MAX_BARS);
        EB_SetDefault("putinslot--HEALTHSTONE", 3, 1+re, EngBank_NumericRange, 1, EngBank_MAX_BARS);
        EB_SetDefault("putinslot--MANAPOTION", 2, 1+re, EngBank_NumericRange, 1, EngBank_MAX_BARS);
        EB_SetDefault("putinslot--BANDAGE", 1, 1+re, EngBank_NumericRange, 1, EngBank_MAX_BARS);
        EB_SetDefault("putinslot--REAGENT", 1, 1+re, EngBank_NumericRange, 1, EngBank_MAX_BARS);
        EB_SetDefault("putinslot--JUJU", 1, 1+re, EngBank_NumericRange, 1, EngBank_MAX_BARS);
        EB_SetDefault("putinslot--MISC", 1, 1+re, EngBank_NumericRange, 1, EngBank_MAX_BARS);
        EB_SetDefault("putinslot--TRADETOOLS", 1, 1+re, EngBank_NumericRange, 1, EngBank_MAX_BARS);
	EB_SetDefault("putinslot--MINIPET", 1, 1+re, EngBank_NumericRange, 1, EngBank_MAX_BARS);
        EB_SetDefault("putinslot--HEARTH", 1, 1+re, EngBank_NumericRange, 1, EngBank_MAX_BARS);
        EB_SetDefault("putinslot--KEYS", 1, 1+re, EngBank_NumericRange, 1, EngBank_MAX_BARS);
	EB_SetDefault("putinslot--CLASS_ITEMS2", 1, 1+re, EngBank_NumericRange, 1, EngBank_MAX_BARS);

	-- okay, I defined too many catagories...  Time to cleanup the config:

	--EngBankConfig = EngBank_Table_RemoveKey(EngBankConfig, "putinslot--RECIPE" );
	--EngBankConfig = EngBank_Table_RemoveKey(EngBankConfig, "putinslot--SCHEMATIC" );
	--EngBankConfig = EngBank_Table_RemoveKey(EngBankConfig, "putinslot--PATTERN" );

        -- default item overrides
	EB_SetDefault("itemoverride_loaddefaults", 1, 3+re, EngBank_NumericRange, 0, 1);
	if (EngBankConfig["itemoverride_loaddefaults"] == 1) then
		EngBankConfig["item_overrides"] = EngBank_DefaultItemOverrides;
		EngBankConfig["item_search_list"] = EngBank_DefaultSearchList;

		for key,value in EngBankConfig["item_search_list"] do
			if (string.sub(value[4], 1, 5) == "loc::") then
				EngBankConfig["item_search_list"][key][4] = EBLocal[ string.sub(value[4],6) ];
			end
		end

		for key,value in EBLocal["string_searches"] do
			table.insert(EngBankConfig["item_search_list"], EngBank_DefaultSearchItemsINSERTTO,
				{ value[1], "", value[2], "" } );
		end

		EngBankConfig["itemoverride_loaddefaults"] = 0;
	end

	-- cleanup old overrides that shouldn't be in the config anymore
	newEngBankConfig = EngBankConfig;
	for key,value in EngBankConfig do
		if (string.find(key, "itemoverride--")) then
			newEngBankConfig = EngBank_Table_RemoveKey(newEngBankConfig, key);
		end
	end
	EngBankConfig = newEngBankConfig;

        -- default sort views / default "allow new items in bar" settings
        EB_SetDefault("bar_sort_"..EngBankConfig["putinslot--EMPTY_SLOTS"], EngBank_SORTBYNAMEREV, 2+re, EngBank_NumericRange, EngBank_SORTLOWESTVALUE, EngBank_SORTHIGHESTVALUE);
        EB_SetDefault("bar_sort_"..EngBankConfig["putinslot--HEALINGPOTION"], EngBank_SORTBYNAMEREV, 2+re, EngBank_NumericRange, EngBank_SORTLOWESTVALUE, EngBank_SORTHIGHESTVALUE);
        EB_SetDefault("bar_sort_"..EngBankConfig["putinslot--MANAPOTION"], EngBank_SORTBYNAMEREV, 2+re, EngBank_NumericRange, EngBank_SORTLOWESTVALUE, EngBank_SORTHIGHESTVALUE);
        EB_SetDefault("bar_sort_"..EngBankConfig["putinslot--TRADEGOODS"], EngBank_SORTBYNAMEREV, 2+re, EngBank_NumericRange, EngBank_SORTLOWESTVALUE, EngBank_SORTHIGHESTVALUE);

	--EB_SetDefault("allow_new_in_bar_"..EngBankConfig["putinslot--HEALINGPOTION"], 0, 1+re, EngBank_NumericRange, 0, 1);
	--EB_SetDefault("allow_new_in_bar_"..EngBankConfig["putinslot--MANAPOTION"], 0, 1+re, EngBank_NumericRange, 0, 1);
	--EB_SetDefault("allow_new_in_bar_"..EngBankConfig["putinslot--FOOD"], 0, 1+re, EngBank_NumericRange, 0, 1);
	--EB_SetDefault("allow_new_in_bar_"..EngBankConfig["putinslot--DRINK"], 0, 1+re, EngBank_NumericRange, 0, 1);
	--EB_SetDefault("allow_new_in_bar_"..EngBankConfig["putinslot--SOULSHARDS"], 0, 1+re, EngBank_NumericRange, 0, 1);

	for i = 1, EngBank_MAX_BARS do
                EB_SetDefault("bar_sort_"..i, EngBank_SORTBYNAME, 2+re, EngBank_NumericRange, EngBank_SORTLOWESTVALUE, EngBank_SORTHIGHESTVALUE);
		EB_SetDefault("allow_new_in_bar_"..i, 1, 1+re, EngBank_NumericRange, 0, 1);
	end

	-- find matching catagories that are not assigned
	for key,value in EngBankConfig["item_search_list"] do
		if (EngBankConfig["putinslot--"..value[1]] == nil) then
			message("EngBank: Unassigned catagory: "..value[1].." -- It has been assigned to slot 1");
			EngBankConfig["putinslot--"..value[1]] = 1;
		end
	end

        if (re>0) then
                EngBank_SetDefaultValues(0);
        end
end

function EngBank_SetTradeSkills()
	local k,v;

	EngBank_TRADE1 = "";
	EngBank_TRADE2 = "";

	for k,v in EngBankConfig[EngBank_PLAYERID]["tradeskills"] do
		if ((k ~= EBLocal["Cooking"]) and (k ~= EBLocal["First Aid"])) then
			EngBank_TRADE1 = EngBank_TRADE2;
			EngBank_TRADE2 = k;
		end
	end
end

function EngBank_init()
	EngBank_PLAYERID = UnitName("player").." of "..GetCVar("realmName");

	-- change imported from auctioneer team..  what does it do?
	UIPanelWindows["EngBank_frame"] = { area = "left", pushable = 6 };

	if ( EngBank_WIPECONFIGONLOAD == 1 ) then
		EngBankConfig = {};
	end

        -- Load localization -- ERR_BADATTACKPOS is a blizzard defined constant for displaying an error message.
        --                      it should be good enough to determine what language the game is running in.
        if ( ERR_BADATTACKPOS == ERR_BADATTACKPOS_LOCAL_EN ) then
                -- US/English
                EngBank_load_Localization("EN");
        elseif ( ERR_BADATTACKPOS == ERR_BADATTACKPOS_LOCAL_FR ) then
                -- French
                EngBank_load_Localization("FR");
        elseif ( ERR_BADATTACKPOS == ERR_BADATTACKPOS_LOCAL_DE ) then
                -- German
                EngBank_load_Localization("DE");
        else
                -- have to load something...  :(
                --EngBank_Print("*** No localization found, stuff won't work properly ***", 1,0.25,0.25 );
		message("EngBank: No localization found, stuff won't work properly");
                EngBank_load_Localization("EN");
        end

        -- register slash command
        SlashCmdList["EngBank"] = EngBank_cmd;
        SLASH_EngBank1 = "/ebinv";
        SLASH_EngBank2 = "/eb";

        -- load default values
        EngBank_SetDefaultValues(0);
	EngBank_SetReplaceBank();
        
	-- go through the tradeskill list, and remove what shouldn't be there
	-- bah, do it in a lazy way, just wipe it
	if (EngBankConfig[EngBank_PLAYERID] == nil) then
		EngBankConfig[EngBank_PLAYERID] = {};
	end
	if (EngBankConfig[EngBank_PLAYERID]["tradeskills"] == nil) then
		EngBankConfig[EngBank_PLAYERID]["tradeskills"] = {};
	end
	local max_skills = 2;
	if (EngBankConfig[EngBank_PLAYERID]["tradeskills"][EBLocal["Cooking"]] ~= nil) then
		max_skills = max_skills + 1;
	end
	if (EngBankConfig[EngBank_PLAYERID]["tradeskills"][EBLocal["First Aid"]] ~= nil) then
		max_skills = max_skills + 1;
	end
	if (table.getn(EngBankConfig[EngBank_PLAYERID]["tradeskills"]) > max_skills) then
		EngBankConfig[EngBank_PLAYERID]["tradeskills"] = {};	-- wipe it out
		EngBankConfig[EngBank_PLAYERID]["tradeskill_items"] = {};
	end

	-- detailed info about tradeskills
	if (EngBankConfig[EngBank_PLAYERID]["trades"] == nil) then
		EngBankConfig[EngBank_PLAYERID]["trades"] = {};
	end

	EngBank_SetTradeSkills();

        -- setup hooks
        EngBank_RegisterHooks(EngBank_HOOKS_REGISTER);


        EngBank_Button_HighlightToggle:SetText(EBLocal["EngBank_Button_HighlightToggle_off"]);
        EngBank_Button_ChangeEditMode:SetText(EBLocal["EngBank_Button_ChangeEditMode_off"]);

        if (EngBankConfig["moveLock"] == 0) then
                EngBank_Button_MoveLockToggle:SetText(EBLocal["EngBank_Button_MoveLock_locked"]);
        else
                EngBank_Button_MoveLockToggle:SetText(EBLocal["EngBank_Button_MoveLock_unlocked"]);
        end

	EngBank_OnEvent("UPDATE_INVENTORY_ALERTS");	-- reload the items currently equipped
end

function EngBank_ExtractTooltip(tooltipframe)
	local txt_left, txt_right, frame_left, frame_right, idx, out, tt_hack;

	tt_hack = getglobal(tooltipframe);
	tt_hack:SetOwner(UIParent, "ANCHOR_NONE");	-- this makes sure that tooltip.valid = true

	out = {};

	for idx = 1, getglobal(tooltipframe):NumLines() do
		frame_left = getglobal(tooltipframe.."TextLeft"..idx);
		frame_right = getglobal(tooltipframe.."TextRight"..idx);

		out[idx] = {
			["l"] = frame_left:GetText(),
			["r"] = frame_right:GetText()
			};

		if ( not frame_left:IsVisible() ) then
			out[idx]["l"] = "";
		end
		if ( not frame_right:IsVisible() ) then
			out[idx]["r"] = "";
		end

		if (EngBank_ENABLE_GETTEXTCOLOR) then
			if (out[idx]["l"] ~= nil) then
				out[idx]["lr"],
				out[idx]["lg"],
				out[idx]["lb"] = frame_left:GetTextColor();
			end
			if (out[idx]["r"] ~= nil) then
				out[idx]["rr"],
				out[idx]["rg"],
				out[idx]["rb"] = frame_right:GetTextColor();
			end
		end
	end

	return out;
end




function EngBank_OnEvent(event)
        EngBank_PrintDEBUG("event: '"..event.."'");



        if ( event == "BAG_UPDATE" ) then
                EngBank_UpdateWindow();
        elseif ( event == "BAG_UPDATE_COOLDOWN" ) then
                EngBank_UpdateWindow();
	elseif ( event == "BANKFRAME_OPENED" ) then
		EngBank_UpdateWindow();
        elseif ( event == "ITEM_LOCK_CHANGED" ) then
                EngBank_UpdateWindow();
	elseif ( event == "CRAFT_SHOW" ) then
		-- load craft info (Enchanting)
		if (GetNumCrafts() > 0) then
			local craftName, craftSubSpellName, craftType, numAvailable, isExpanded;
			local craftItemLink;
			local tradeskillName, currentLevel, maxLevel = GetCraftDisplaySkillLine();
			local a,b,c,d;
			local reagentItemLink;
			local tmpval, tmptooltip, idx, tmptooltip2;

			-- hunter training window shows up as a craft with a nil tradeskillName
			if (tradeskillName ~= nil) then

				if (EngBankConfig[EngBank_PLAYERID] == nil) then
					EngBankConfig[EngBank_PLAYERID] = {};
				end
				if (EngBankConfig[EngBank_PLAYERID]["tradeskills"] == nil) then
					EngBankConfig[EngBank_PLAYERID]["tradeskills"] = {};
				end
				EngBankConfig[EngBank_PLAYERID]["tradeskills"][tradeskillName] = date("%y%m%d%H%M%S");
				EngBank_SetTradeSkills();
				if (EngBankConfig[EngBank_PLAYERID]["tradeskill_items"] == nil) then
					EngBankConfig[EngBank_PLAYERID]["tradeskill_items"] = {};
				end

				EngBankConfig[EngBank_PLAYERID]["trades"][tradeskillName] = {};	-- wipe it out, we're refreshing it now anyway

				if (GetNumCrafts() > 0) then
					for i = 1, GetNumCrafts() do
						craftName, craftSubSpellName, craftType, numAvailable, isExpanded = GetCraftInfo(i);
						craftItemLink = GetCraftItemLink(i);
						-- remember: a craft might just be a skill and not a physical item
						if ( (craftItemLink ~= nil) and (type(craftItemLink) == "string") ) then
							for a,b,c,d in string.gfind(craftItemLink, "(%d+):(%d+):(%d+):(%d+)") do
								craftItemLink = ""..a..":0:"..c..":0";
							end

							if ( EngBankConfig[EngBank_PLAYERID]["tradeskill_production"][craftItemLink] == nil ) then
								EngBankConfig[EngBank_PLAYERID]["tradeskill_production"][craftItemLink] = {};
							end
							EngBankConfig[EngBank_PLAYERID]["tradeskill_production"][craftItemLink][tradeskillName] = 1;
						end

						-- build the complete info about tradeskills, this is for exporting data
						-- so now I store by craftName instead of craftItemLink
						if ( (EngBank_BuildTradeList[tradeskillName] == nil) and (EngBankConfig["build_trade_list"] == 1) ) then
							EngBank_tt:SetCraftSpell(i);
							if (EngBankConfig[EngBank_PLAYERID]["trades"][tradeskillName][craftName] == nil) then
								EngBankConfig[EngBank_PLAYERID]["trades"][tradeskillName][craftName] = {};
							end
							EngBankConfig[EngBank_PLAYERID]["trades"][tradeskillName][craftName]["item"] = EngBank_ExtractTooltip("EngBank_tt");
						end

						if (GetCraftNumReagents(i) > 0) then
							for i2 = 1, GetCraftNumReagents(i) do
								reagentItemLink = GetCraftReagentItemLink(i,i2);
								if (reagentItemLink ~= nil) then
									for a,b,c,d in string.gfind(reagentItemLink, "(%d+):(%d+):(%d+):(%d+)") do
										reagentItemLink = ""..a..":0:"..c..":0";
									end						
									
									if (EngBankConfig[EngBank_PLAYERID]["tradeskill_items"][reagentItemLink] == nil) then
										EngBankConfig[EngBank_PLAYERID]["tradeskill_items"][reagentItemLink] = {};
									end
									EngBankConfig[EngBank_PLAYERID]["tradeskill_items"][reagentItemLink][tradeskillName] = 1;

									if ( (EngBank_BuildTradeList[tradeskillName] == nil) and (EngBankConfig["build_trade_list"] == 1) ) then
										EngBank_tt:SetCraftItem(i,i2);
										EngBankConfig[EngBank_PLAYERID]["trades"][tradeskillName][craftName][reagentItemLink] = EngBank_ExtractTooltip("EngBank_tt");
										EngBankConfig[EngBank_PLAYERID]["trades"][tradeskillName][craftName][reagentItemLink]["n"],
										EngBankConfig[EngBank_PLAYERID]["trades"][tradeskillName][craftName][reagentItemLink]["t"],
										EngBankConfig[EngBank_PLAYERID]["trades"][tradeskillName][craftName][reagentItemLink]["c"] = GetCraftReagentInfo(i,i2);
									end
								end
							end
						end
					end
				end

				EngBank_BuildTradeList[tradeskillName] = 1;	-- only do the exhaustive load once
			end
		end
	elseif ( event == "TRADE_SKILL_SHOW" ) then
		-- load tradeskill info (every other trade)
		if (GetNumTradeSkills() > 0) then
			local craftName, craftSubSpellName, craftType, numAvailable, isExpanded;
			local craftItemLink;
			local tradeskillName, currentLevel, maxLevel = GetTradeSkillLine();
			local a,b,c,d;
			local reagentItemLink;

			if (EngBankConfig[EngBank_PLAYERID] == nil) then
				EngBankConfig[EngBank_PLAYERID] = {};
			end
			if (EngBankConfig[EngBank_PLAYERID]["tradeskills"] == nil) then
				EngBankConfig[EngBank_PLAYERID]["tradeskills"] = {};
			end
			EngBankConfig[EngBank_PLAYERID]["tradeskills"][tradeskillName] = date("%Y%m%d%H%M%S");
			EngBank_SetTradeSkills();
			if (EngBankConfig[EngBank_PLAYERID]["tradeskill_items"] == nil) then
				EngBankConfig[EngBank_PLAYERID]["tradeskill_items"] = {};
			end
			if (EngBankConfig[EngBank_PLAYERID]["tradeskill_production"] == nil) then
				EngBankConfig[EngBank_PLAYERID]["tradeskill_production"] = {};
			end

			EngBankConfig[EngBank_PLAYERID]["trades"][tradeskillName] = {};

			for i = 1, GetNumTradeSkills() do
				craftName, craftType, numAvailable, isExpanded = GetTradeSkillInfo(i);
				craftItemLink = GetTradeSkillItemLink(i);
				if (craftType ~= "header") then
					TradeSkillFrame_SetSelection(i)
					TradeSkillFrame_Update();

					if ( (craftItemLink ~= nil) and (type(craftItemLink) == "string") ) then
						for a,b,c,d in string.gfind(craftItemLink, "(%d+):(%d+):(%d+):(%d+)") do
							craftItemLink = ""..a..":0:"..c..":0";
						end

						if ( EngBankConfig[EngBank_PLAYERID]["tradeskill_production"][craftItemLink] == nil ) then
							EngBankConfig[EngBank_PLAYERID]["tradeskill_production"][craftItemLink] = {};
						end
						EngBankConfig[EngBank_PLAYERID]["tradeskill_production"][craftItemLink][tradeskillName] = 1;

						-- build the complete info about tradeskills, this is for exporting data
						if ( (EngBank_BuildTradeList[tradeskillName] == nil) and (EngBankConfig["build_trade_list"] == 1) ) then
							if (EngBankConfig[EngBank_PLAYERID]["trades"][tradeskillName][craftName] == nil) then
								EngBankConfig[EngBank_PLAYERID]["trades"][tradeskillName][craftName] = {};
							end
							EngBank_tt:SetTradeSkillItem(i);
							EngBankConfig[EngBank_PLAYERID]["trades"][tradeskillName][craftName]["item"] = EngBank_ExtractTooltip("EngBank_tt");
						end

						if (GetTradeSkillNumReagents(i) > 0) then
							for i2 = 1, GetTradeSkillNumReagents(i) do
								reagentItemLink = GetTradeSkillReagentItemLink(i,i2);
								if (reagentItemLink ~= nil) then
									for a,b,c,d in string.gfind(reagentItemLink, "(%d+):(%d+):(%d+):(%d+)") do
										reagentItemLink = ""..a..":0:"..c..":0";
									end						
									
									if (EngBankConfig[EngBank_PLAYERID]["tradeskill_items"][reagentItemLink] == nil) then
										EngBankConfig[EngBank_PLAYERID]["tradeskill_items"][reagentItemLink] = {};
									end
									EngBankConfig[EngBank_PLAYERID]["tradeskill_items"][reagentItemLink][tradeskillName] = 1;

									if ( (EngBank_BuildTradeList[tradeskillName] == nil) and (EngBankConfig["build_trade_list"] == 1) ) then
										EngBank_tt:SetTradeSkillItem(i,i2);
										EngBankConfig[EngBank_PLAYERID]["trades"][tradeskillName][craftName][reagentItemLink] = EngBank_ExtractTooltip("EngBank_tt");
										EngBankConfig[EngBank_PLAYERID]["trades"][tradeskillName][craftName][reagentItemLink]["n"],
										EngBankConfig[EngBank_PLAYERID]["trades"][tradeskillName][craftName][reagentItemLink]["t"],
										EngBankConfig[EngBank_PLAYERID]["trades"][tradeskillName][craftName][reagentItemLink]["c"] = GetTradeSkillReagentInfo(i,i2);
									end
								end
							end
						end
					end
				end
			end

			EngBank_BuildTradeList[tradeskillName] = 1;	-- only do the exhaustive load once
		end
	elseif ( event == "UPDATE_INVENTORY_ALERTS" ) then
		local itemLink;
		local a,b,c,d;

		EngBank_PrintDEBUG("About to scan inventory");

		if (EngBankConfig[EngBank_PLAYERID]["equipped_items"] == nil) then
			EngBankConfig[EngBank_PLAYERID]["equipped_items"] = {};
		end

		for key,value in { "HeadSlot","NeckSlot","ShoulderSlot","BackSlot","ChestSlot",
			"ShirtSlot","TabardSlot","WristSlot","HandsSlot","WaistSlot","LegsSlot",
			"FeetSlot","Finger0Slot","Finger1Slot","Trinket0Slot","Trinket1Slot",
			"MainHandSlot","SecondaryHandSlot","RangedSlot" } do

			--EngBank_PrintDEBUG( "Scanning: "..value );
			itemLink = GetInventoryItemLink("player", GetInventorySlotInfo(value) );
			if ( (itemLink ~= nil) and (type(itemLink) == "string") ) then
				for a,b,c,d in string.gfind(itemLink, "(%d+):(%d+):(%d+):(%d+)") do
					itemLink = ""..a..":0:"..c..":0";
				end
				
				EngBankConfig[EngBank_PLAYERID]["equipped_items"][itemLink] = 1;
			end
		end

                EngBank_UpdateWindow();
	else
		EngBank_PrintDEBUG("OnEvent: No event handler found.");
        end



	if (event == "BANKFRAME_OPENED") then
		if EngReplaceBank == 1 then
			EngBank_resort_required = EngBank_MANDATORY;
			EngBank_edit_mode = 0;
			EngBankFrameTitleText:SetText(UnitName("npc"));
			SetPortraitTexture(EngBank_framePortrait, "npc");
			--PlayerName = UnitName("player").."|"..Eng_Trim(GetCVar("realmName"));
			--bankPlayer = Eng_GetPlayer(PlayerName);
			--Eng_InitializeProfile();
			EngBank_frame:Show();
		end
	elseif (event == "BANKFRAME_CLOSED") then
		CloseBackpack(); -- Close Backpack when leaving
	 	if EngReplaceBank == 1 then			
			EngBank_frame:Hide();
		end
	end


	EngBank_PrintDEBUG("OnEvent: Finished "..event);
end

function EngBank_StartMoving(frame)
        if ( not frame.isMoving ) and ( EngBankConfig["moveLock"] == 1 ) then
                frame:StartMoving();
                frame.isMoving = true;
        end
end

function EngBank_StopMoving(frame)
        if ( frame.isMoving ) then
                frame:StopMovingOrSizing();
                frame.isMoving = false;

                -- save the position
                EngBankConfig["frameLEFT"] = frame:GetLeft() * frame:GetScale();
                EngBankConfig["frameRIGHT"] = frame:GetRight() * frame:GetScale();
                EngBankConfig["frameTOP"] = frame:GetTop() * frame:GetScale();
                EngBankConfig["frameBOTTOM"] = frame:GetBottom() * frame:GetScale();

                EngBank_PrintDEBUG("new position:  top="..EngBankConfig["frameTOP"]..", bottom="..EngBankConfig["frameBOTTOM"]..", left="..EngBankConfig["frameLEFT"]..", right="..EngBankConfig["frameRIGHT"] );
        end
end

function EngBank_OnMouseDown(button, frame)

	if ( button == "LeftButton" ) then
		EngBank_StartMoving(frame);
	elseif ( button == "RightButton" ) then
		HideDropDownMenu(1);
		EngBank_RightClickMenu_mode = "mainwindow";
		EngBank_RightClickMenu_opts = {};
		ToggleDropDownMenu(1, nil, EngBank_frame_RightClickMenu, "cursor", 0, 0);
	end

end


--	EngBank_resort_required: EngBank_NOTNEEDED, EngBank_REQUIRED, EngBank_MANDATORY
--	EngBank_window_update_required: EngBank_NOTNEEDED, EngBank_REQUIRED, EngBank_MANDATORY
--	EngBank_item_cache[ bag ][ slot ]
function EngBank_Update_item_cache()
	local bag, slot;	-- used as "for loop" counters
	local itm;		-- entry that will be written to the cache
	local update_suggested = 0;
	local resort_suggested = 0;
	local resort_mandatory = 0;
	-- variables used in outer loop, bag:
	local bagNumSlots;
	local is_shot_bag;
	-- variables used in inner loop, slots:
	local a,b,c,d;
	local sequencial_slot_num = 0;

	for vbagnum = 4, 10 do
		if (vbagnum==4) then
			bagnum=-1;
		else
			bagnum=vbagnum;
		end
			
		if (EngBankConfig["show_Bag"..bagnum] == 1) then
			if (EngBank_item_cache[bagnum] == nil) then
				EngBank_item_cache[bagnum] = {};
			end

			bagNumSlots = GetContainerNumSlots(bagnum);

			if (bagNumSlots > 0) then
				is_shot_bag = EngBank_IsShotBag(bagnum);
				for slotnum = 1, bagNumSlots do
					if (EngBank_item_cache[bagnum][slotnum] == nil) then
						EngBank_item_cache[bagnum][slotnum] = { ["keywords"] = {} };
					end

					sequencial_slot_num = sequencial_slot_num + 1;
					itm = {
						["itemlink"] = GetContainerItemLink(bagnum, slotnum);
						["bagnum"] = bagnum,
						["slotnum"] = slotnum,
						["sequencial_slot_num"] = sequencial_slot_num,
						-- take items from old position
						["bar"] = EngBank_item_cache[bagnum][slotnum]["bar"],
						["button_num"] = EngBank_item_cache[bagnum][slotnum]["button_num"],
						["indexed_on"] = EngBank_item_cache[bagnum][slotnum]["indexed_on"],
						["display_string"] = EngBank_item_cache[bagnum][slotnum]["display_string"],
						["barClass"] = EngBank_item_cache[bagnum][slotnum]["barClass"],
						["button_num"] = EngBank_item_cache[bagnum][slotnum]["button_num"],	-- assigned when drawing
						["keywords"] = EngBank_item_cache[bagnum][slotnum]["keywords"],
						["itemlink_override_key"] = EngBank_item_cache[bagnum][slotnum]["itemlink_override_key"],
						-- misc junk
						["search_match"] = EngBank_item_cache[bagnum][slotnum]["search_match"],
						["gametooltip"] = EngBank_item_cache[bagnum][slotnum]["gametooltip"]
						};

					if (is_shot_bag) then
						itm["keywords"]["SHOT_BAG"]=1;
					end

					if (itm["itemlink"] ~= nil) then
						-- there's an item in the bag, let's find out more about it
						for a,b,c,d in string.gfind(itm["itemlink"], "(%d+):(%d+):(%d+):(%d+)") do
							itm["itemlink"] = "item:"..a..":"..b..":"..c..":"..d;
							-- I hope this is right.
							-- looklink says B is "instance specific"
							-- I'm guessing D is player specific
							-- I wonder what C is...
							itm["itemlink_noninstance"] = ""..a..":0:"..c..":0";
						end

						itm["itemname"], itm["itemlink2"], itm["itemRarity"], itm["itemMinLevel"], itm["itemtype"], itm["itemsubtype"], itm["itemstackcount"] = GetItemInfo(itm["itemlink"]);
						itm["texture"], itm["itemcount"], itm["locked"], itm["quality"], itm["readable"] = GetContainerItemInfo(bagnum, slotnum);
					else
						-- no item in bag, set the default values
						itm["itemlink_noninstance"] = nil;
						itm["itemname"] = "Empty Slot";
						itm["itemlink2"] = nil
						itm["itemRarity"] = nil;
						itm["itemMinLevel"] = nil;
						itm["itemtype"] = "";
						itm["itemsubtype"] = "";
						itm["itemstackcount"] = nil;

						itm["texture"] = nil;
						itm["itemcount"] = 0;
						itm["locked"] = 0;
						itm["quality"] = 0;
						itm["readable"] = 0;
					end

					if (itm["bar"] == nil) then
						resort_mandatory = 1;
					end

					if (itm["itemsubtype"] == nil) then itm["itemsubtype"] = ""; end
					if (itm["itemname"] == nil) then itm["itemname"] = ""; end

					if (itm["locked"] ~= EngBank_item_cache[bagnum][slotnum]["locked"]) then
						update_suggested = 1;
					end

					if (
						(itm["itemlink"] ~= EngBank_item_cache[bagnum][slotnum]["itemlink"]) or
						(itm["keywords"]["SHOT_BAG"] ~= EngBank_item_cache[bagnum][slotnum]["keywords"]["SHOT_BAG"])
						) then
						-- the item changed
						if (itm["indexed_on"] ~= nil) then
							resort_suggested = 1;
							itm["indexed_on"] = GetTime();
							itm["display_string"] = "newItemText";
						end
					else
						-- item has not changed, maybe the count did?
						if ( (itm["itemcount"] ~= EngBank_item_cache[bagnum][slotnum]["itemcount"]) and (EngBank_item_cache[bagnum][slotnum]["itemcount"] ~= nil) ) then
							update_suggested = 1;
							if (itm["itemcount"] < EngBank_item_cache[bagnum][slotnum]["itemcount"]) then
								itm["display_string"] = "newItemTextMinus";
							else
								itm["display_string"] = "newItemTextPlus";
							end
							itm["indexed_on"] = GetTime();
						end
					end

					if (itm["indexed_on"] == nil) then
						itm["indexed_on"] = 1;
						itm["display_string"] = "NewItemText_Off";
						
					end

					EngBank_item_cache[bagnum][slotnum] = itm;	-- save updated information
				end
			else
				-- bagNumSlots = 0, make sure you wipe the cache entry
				if (table.getn(EngBank_item_cache[bagnum]) ~= 0) then
					resort_mandatory = 1;
				end
				EngBank_item_cache[bagnum] = {};
			end
		end

	end

	if (resort_mandatory == 1) then
		EngBank_resort_required = EngBank_MANDATORY;
		EngBank_window_update_required = EngBank_MANDATORY;
	elseif (resort_suggested == 1) then
		EngBank_resort_required = math.max(EngBank_resort_required, EngBank_REQUIRED);
		EngBank_window_update_required = EngBank_MANDATORY;
	elseif (update_suggested == 1) then
		EngBank_window_update_required = EngBank_MANDATORY;
	end
end



-- Take an item and figure out what "bar" you want to place it in
--              return selected_bar, barClass;
function EngBank_PickBar(itm)
        if (itm["itemlink"] == nil) then
                if (itm["keywords"]["SHOT_BAG"]) then
			itm["bar"] = EngBankConfig["putinslot--EMPTY_PROJECTILE_SLOTS"];
			while (type(itm["bar"]) ~= "number") do
				itm["bar"] = EngBankConfig[itm["bar"]];
			end
			itm["barClass"] = "EMPTY_PROJECTILE_SLOTS";
                        return itm;
                else
			itm["bar"] = EngBankConfig["putinslot--EMPTY_SLOTS"];
			while (type(itm["bar"]) ~= "number") do
				itm["bar"] = EngBankConfig[itm["bar"]];
			end
			itm["barClass"] = "EMPTY_SLOTS";
                        return itm;
                end
        else
		-- vars used in tooltip creation
		local idx, tmptooltip, tmpval, tooltip_info_concat;
		-- vars used in array loops
		local key, value;
		local found;

		-- reset item keywords
		if (itm["keywords"]["SHOT_BAG"]) then
			itm["keywords"] = {
				["USED_PROJECTILE_SLOT"] = 1,	-- this indicates that the shot bag isn't empty
				["SHOT_BAG"] = 1
				};
		else
			itm["keywords"] = {};
		end
		if (itm["itemRarity"] ~= nil) then
			itm["keywords"]["ITEMRARITY_"..itm["itemRarity"]] = 1;
		end

		-- setup tradeskill keywords
		if ( (EngBankConfig[EngBank_PLAYERID]["tradeskill_items"] ~= nil) and (EngBankConfig[EngBank_PLAYERID]["tradeskill_items"][ itm["itemlink_noninstance"] ] ~= nil) ) then
			-- the item exists in our cache
			if (EngBankConfig[EngBank_PLAYERID]["tradeskill_items"][ itm["itemlink_noninstance"] ][EngBank_TRADE1] ~= nil) then
				itm["keywords"]["TRADESKILL_1"] = 1;
			elseif (EngBankConfig[EngBank_PLAYERID]["tradeskill_items"][ itm["itemlink_noninstance"] ][EngBank_TRADE2] ~= nil) then
				itm["keywords"]["TRADESKILL_2"] = 1;
			elseif (EngBankConfig[EngBank_PLAYERID]["tradeskill_items"][ itm["itemlink_noninstance"] ][EBLocal["Cooking"]] ~= nil) then
				itm["keywords"]["TRADESKILL_COOKING"] = 1;
			elseif (EngBankConfig[EngBank_PLAYERID]["tradeskill_items"][ itm["itemlink_noninstance"] ][EBLocal["First Aid"]] ~= nil) then
				itm["keywords"]["TRADESKILL_FIRSTAID"] = 1;
			end
		end

		-- setup tradeskill produced items keywords
		if ( (EngBankConfig[EngBank_PLAYERID]["tradeskill_production"] ~= nil) and (EngBankConfig[EngBank_PLAYERID]["tradeskill_production"][ itm["itemlink_noninstance"] ] ~= nil) ) then
			if (EngBankConfig[EngBank_PLAYERID]["tradeskill_production"][ itm["itemlink_noninstance"] ][EngBank_TRADE1] ~= nil) then
				itm["keywords"]["TRADESKILL_1_CREATED"] = 1;
			elseif (EngBankConfig[EngBank_PLAYERID]["tradeskill_production"][ itm["itemlink_noninstance"] ][EngBank_TRADE2] ~= nil) then
				itm["keywords"]["TRADESKILL_2_CREATED"] = 1;
			end
			-- not doing cooking or first aid.
		end

		-- setup equipped items keywords
		if ( EngBankConfig[EngBank_PLAYERID]["equipped_items"] ~= nil ) then
			if (EngBankConfig[EngBank_PLAYERID]["equipped_items"][ itm["itemlink_noninstance"] ] ~= nil) then
				itm["keywords"]["EQUIPPED"] = 1;
			end
		end

		-- Load tooltip
		EngBank_tt:SetOwner(UIParent, "ANCHOR_NONE");	-- this makes sure that tooltip.valid = true
		if itm["bagnum"] < 0 then
				EngBank_tt:SetHyperlink(itm["itemlink"]);
			else
				EngBank_tt:SetBagItem(itm["bagnum"],itm["slotnum"]);
		end
		
		idx = 1;
		tmptooltip = getglobal("EngBank_ttTextLeft"..idx);
		tooltip_info_concat = "";
		itm["gametooltip"] = {};
		repeat
			tmpval = tmptooltip:GetText();

			if (tmpval ~= nil) then
				tooltip_info_concat = tooltip_info_concat.." "..tmpval;
				itm["gametooltip"][idx] = tmpval;
			end

			idx=idx+1;
			tmptooltip = getglobal("EngBank_ttTextLeft"..idx);
		until (tmpval==nil) or (tmptooltip==nil);

		if (string.find(tooltip_info_concat, EBLocal["soulbound_search"] )) then
			itm["keywords"]["SOULBOUND"] = 1;
		end

		itm["barClass"] = nil;

		-- step 1, check item overrides
		if (itm["keywords"]["SOULBOUND"] == nil) then
			itm["itemlink_override_key"] = itm["itemlink_noninstance"];
		else
			itm["itemlink_override_key"] = itm["itemlink_noninstance"].."-SB";
		end

		-- load an item override
		itm["barClass"] = EngBankConfig["item_overrides"][itm["itemlink_override_key"]];
		if (itm["barClass"] ~= nil) then
			itm["search_match"] = "item_override found";

			itm["bar"] = EngBankConfig["putinslot--"..itm["barClass"]];
			while ( (itm["bar"] ~= nil) and (type(itm["bar"]) ~= "number") ) do
				itm["bar"] = EngBankConfig[itm["bar"]];
			end
			if (type(itm["bar"]) ~= "number") then
				itm["barClass"] = nil;
			end
		end

		if (itm["barClass"] == nil) then
			for key,value in EngBankConfig["item_search_list"] do
				if (value[1] ~= "") then
					local found = 1;
					
					-- value[1] == catagory to place it in

					-- check keywords
					if ( (value[2] ~= "") and (itm["keywords"][value[2]] == nil) ) then
						found = nil;
					end
					-- check tooltip
					if ( (value[3] ~= "") and (not string.find(tooltip_info_concat, value[3])) ) then
						found = nil;
					end
					-- check itemType
					if ( (value[4] ~= "") and (itm["itemtype"] ~= value[4]) ) then
						found = nil;
					end

					if (found) then
						itm["search_match"] = ""..key..": "..value[1];
						itm["barClass"] = value[1];
						itm["bar"] = EngBankConfig["putinslot--"..itm["barClass"]];
						while ( (itm["bar"] ~= nil) and (type(itm["bar"]) ~= "number") ) do
							itm["bar"] = EngBankConfig[itm["bar"]];
						end
						if (type(itm["bar"]) == "number") then
							break;
						else
							itm["barClass"] = nil;
						end
					end
				end
			end
		end

		if (itm["barClass"] == nil) then
			itm["barClass"] = "OTHERORUNKNOWN";

			itm["bar"] = EngBankConfig["putinslot--"..itm["barClass"]];
			while ( (itm["bar"] ~= nil) and (type(itm["bar"]) ~= "number") ) do
				itm["bar"] = EngBankConfig[itm["bar"]];
			end
			if (type(itm["bar"]) ~= "number") then
				itm["barClass"] = "UNKNOWN";
				itm["bar"] = 1;
			end
		end

                return itm;
        end
end

--[[
	Call EngBank_Update_item_cache() before calling this

	EngBank_item_cache[ bagnum ][ slotnum ]
	EngBank_bar_positions[ bar_number ][ position ] = { ["bagnum"]=bagnum, ["slotnum"]=slotnum }
--]]


function EngBank_Sort_item_cache()
	local i;
	local bagnum, slotnum;
	-- variables used in outer loop
	local bagNumSlots;
	-- variables used in inner loop
	----- 2nd loop
	local barnum;

	--Print("Resorting Items");

	-- wipe the current bar positions table
	EngBank_bar_positions = {};
	for i = 1, EngBank_MAX_BARS do
		EngBank_bar_positions[i] = {};
	end

	for vbagnum = 4, 10 do
		if (vbagnum==4) then
				bagnum=-1;
			else
				bagnum=vbagnum;
		end
		if (EngBankConfig["show_Bag"..bagnum] == 1) then
			bagNumSlots = table.getn( EngBank_item_cache[bagnum] );
			if (bagNumSlots > 0) then
				for slotnum = 1, bagNumSlots do
					EngBank_item_cache[bagnum][slotnum] = EngBank_PickBar( EngBank_item_cache[bagnum][slotnum] );

					table.insert( EngBank_bar_positions[ EngBank_item_cache[bagnum][slotnum]["bar"] ], { ["bagnum"]=bagnum, ["slotnum"]=slotnum } );
				end
			end
		end
	end

        -- sort the cache now
        for barnum = 1, EngBank_MAX_BARS do
		local toggle;

		if (EngBankConfig["bar_sort_"..barnum] == EngBank_SORTBYNAME) then
			toggle=1
			elseif (EngBankConfig["bar_sort_"..barnum] == EngBank_SORTBYNAMEREV) then
			toggle=2
		end
		
                if (toggle==1 or toggle==2) then
                        table.sort(EngBank_bar_positions[barnum],
                                function(a,b)
                                        return  EngBank_item_cache[a["bagnum"]][a["slotnum"]]["barClass"]..
						EngBank_item_cache[a["bagnum"]][a["slotnum"]]["itemsubtype"]..
						EngBank_ReverseString(
							EngBank_item_cache[a["bagnum"]][a["slotnum"]]["itemname"],toggle)..
							string.format("%04s",EngBank_item_cache[a["bagnum"]][a["slotnum"]]["itemcount"]
							)
								>
                                                EngBank_item_cache[b["bagnum"]][b["slotnum"]]["barClass"]..
						EngBank_item_cache[b["bagnum"]][b["slotnum"]]["itemsubtype"]..
						EngBank_ReverseString(
							EngBank_item_cache[b["bagnum"]][b["slotnum"]]["itemname"],toggle)..
							string.format("%04s",EngBank_item_cache[b["bagnum"]][b["slotnum"]]["itemcount"]
							)
                                end);
                end
        end

	EngBank_resort_required = EngBank_NOTNEEDED;
	EngBank_window_update_required = EngBank_MANDATORY;
end


-- Make an inventory slot usable with the item specified in itm
-- cache entry is the array that comes directly from the cache
function EngBank_UpdateButton(itemframe, itm)
        local ic_start, ic_duration, ic_enable;
        local showSell = nil;
        local itemframe_texture = getglobal(itemframe:GetName().."IconTexture");
	local itemframe_normaltexture = getglobal(itemframe:GetName().."NormalTexture");
        local itemframe_font = getglobal(itemframe:GetName().."Count");
        local itemframe_stock = getglobal(itemframe:GetName().."Stock");
        local cooldownFrame = getglobal(itemframe:GetName().."_Cooldown");

        if ( EBLocal["_loaded"]==0 ) then
                return;
        end

        if (itm["itemlink"] ~= nil) then
                ic_start, ic_duration, ic_enable = GetContainerItemCooldown(itm["bagnum"], itm["slotnum"]);
        else
                ic_start = 0;
                ic_duration = 0;
                ic_enable = nil;
        end

        SetItemButtonTexture(itemframe, itm["texture"]);

        if ( EngBank_edit_mode == 1 ) then
                -- we should be hilighting an entire class of item
                if ( itm["barClass"] ~= EngBank_edit_hilight ) then
                        -- dim this item
                        itemframe_texture:SetVertexColor(1,1,1,0.15);
                        itemframe_font:SetVertexColor(1,1,1,0.5);
                else
                        -- hilight this item
                        itemframe_texture:SetVertexColor(1,1,0,1);
                        itemframe_font:SetVertexColor(1,1,0,1);
                end
        else
                -- no hilights, just do your normal work

                if ( (EngBankConfig["allow_new_in_bar_"..itm["bar"]] == 1) and (itm["itemlink"] ~= nil) and (itm["indexed_on"]>1) and ((GetTime()-itm["indexed_on"]) < EngBankConfig["newItemTimeout"]) ) then
                        -- item is still new, display the "new" text.
                        itemframe_stock:SetText( EngBankConfig[itm["display_string"]] );
                        if ( (GetTime()-itm["indexed_on"]) < EngBankConfig["newItemTimeout2"]) then
                                -- use color #2
                                itemframe_stock:SetTextColor(
                                        EngBankConfig["newItemColor2_R"],
                                        EngBankConfig["newItemColor2_G"],
                                        EngBankConfig["newItemColor2_B"] );
                                itemframe_font:SetVertexColor(
                                        EngBankConfig["newItemColor2_R"],
                                        EngBankConfig["newItemColor2_G"],
                                        EngBankConfig["newItemColor2_B"], 1 );
                        else
                                -- use color #1
                                itemframe_stock:SetTextColor(
                                        EngBankConfig["newItemColor1_R"],
                                        EngBankConfig["newItemColor1_G"],
                                        EngBankConfig["newItemColor1_B"] );
                                itemframe_font:SetVertexColor(
                                        EngBankConfig["newItemColor1_R"],
                                        EngBankConfig["newItemColor1_G"],
                                        EngBankConfig["newItemColor1_B"], 1 );
                        end
                        itemframe_stock:Show();
                        itemframe_texture:SetVertexColor(1,1,1,1);
                else
                        itemframe_stock:Hide();
                        if (EngBank_hilight_new == 1) then
                                itemframe_texture:SetVertexColor(1,1,1,0.15);
                                itemframe_font:SetVertexColor(1,1,1,0.5);
                        else
                                itemframe_texture:SetVertexColor(1,1,1,1);
                                itemframe_font:SetVertexColor(1,1,1,1);
                        end
                end

                if (itm["itemRarity"] == nil) then
			itemframe_normaltexture:SetVertexColor(0.4,0.4,0.4, 0.5);
                elseif (itm["itemRarity"] == 0) then     -- gray item
			itemframe_normaltexture:SetVertexColor(1,1,1,1);
                elseif (itm["itemRarity"] == 1) then     -- white item
			itemframe_normaltexture:SetVertexColor(0.4,0.4,0.4, 0.5);
                elseif (itm["itemRarity"] == 2) then     -- green item
			itemframe_normaltexture:SetVertexColor(0,1,0.25, 0.5);
                elseif (itm["itemRarity"] == 3) then     -- blue item
			itemframe_normaltexture:SetVertexColor(0.5,0.5,1, 0.5);
                elseif (itm["itemRarity"] == 4) then     -- purple item
			itemframe_normaltexture:SetVertexColor(1,0,1, 0.5);
                else    -- ?!
			itemframe_normaltexture:SetVertexColor(1,0,0, 0.5);
                end
        end

        SetItemButtonDesaturated(itemframe, itm["locked"], 0.5, 0.5, 0.5);
        SetItemButtonCount(itemframe, itm["itemcount"]);

	-- resize itemframe texture (this is the little border)
	itemframe_normaltexture:SetWidth(EngBank_BKGRFRAME_WIDTH);
	itemframe_normaltexture:SetHeight(EngBank_BKGRFRAME_HEIGHT);

	-- resize and position fonts
	--itemframe_font.font = "Interface\Addons\EngBank\DAB_CooldownFont.ttf";
	itemframe_font:SetTextHeight( EngBank_BUTTONFONTHEIGHT );	-- count, bottomright
	itemframe_font:ClearAllPoints();
	itemframe_font:SetPoint("BOTTOMRIGHT", itemframe:GetName(), "BOTTOMRIGHT", 0-EngBank_BUTTONFONTDISTANCE_X, EngBank_BUTTONFONTDISTANCE_Y );
	
	--itemframe_stock.font = "Interface\Addons\EngBank\DAB_CooldownFont.ttf";
	itemframe_stock:SetTextHeight( EngBank_BUTTONFONTHEIGHT2 );	-- stock, topleft
	itemframe_stock:ClearAllPoints();
	itemframe_stock:SetPoint("TOPLEFT", itemframe:GetName(), "TOPLEFT", (EngBank_BUTTONFONTDISTANCE_X / 2), 0-EngBank_BUTTONFONTDISTANCE_Y );
	
        -- Set cooldown
        CooldownFrame_SetTimer(cooldownFrame, ic_start, ic_duration, ic_enable);
        if ( ( ic_duration > 0 ) and ( ic_enable == 0 ) ) then
                SetItemButtonTextureVertexColor(itemframe, 0.4, 0.4, 0.4);
        end

	cooldownFrame:SetScale(EngBank_COOLDOWN_SCALE);

end


function EngBank_GetBarPositionAndCache()
        local bar, position, itm;
	local bagnum, slotnum;

        if (EngBank_buttons[this:GetName()] ~= nil) then
                bar = EngBank_buttons[this:GetName()]["bar"];
                position = EngBank_buttons[this:GetName()]["position"];

		bagnum = EngBank_bar_positions[bar][position]["bagnum"];
		slotnum = EngBank_bar_positions[bar][position]["slotnum"];

                itm = EngBank_item_cache[bagnum][slotnum];

                return bar,position,itm;
        else
                return nil,nil,nil;
        end

end

function EngBank_ItemButton_OnEnter()
        --AllInOneInventory_Patching_Tooltip = 1;
        local bar,position,itm = EngBank_GetBarPositionAndCache();

        if (EngBank_edit_selected == "") then
                EngBank_edit_hilight = itm["barClass"];
        end

        if ( not itm["itemlink"]) then
                if ( EngBank_edit_mode == 1 ) then
                        GameTooltip:SetOwner(this, "ANCHOR_LEFT");
                        GameTooltip:ClearLines();
                        GameTooltip:AddLine("Empty Slot", 1,1,1 );

                        -- move by class
                        if (itm["barClass"] ~= nil) then
				if (EngBank_edit_selected ~= "") then
		                        GameTooltip:AddLine("|cFF00FF7FLeft click to move catagory |r"..EngBank_edit_selected.."|cFF00FF7F to bar |r"..bar, 1,0.25,0.5 );
				else
		                        GameTooltip:AddLine("|cFF00FF7FLeft click to select catagory to move:|r "..itm["barClass"], 1,0.25,0.5 );
					--GameTooltip:AddLine("Right click to assign this item to a different class", 1,0,0 );
				end
                        else
                                GameTooltip:AddLine("error: Item has no catagory", 1,0,0 );
                        end

                        GameTooltip:Show();
                else
                        GameTooltip:Hide();
                end
                if ( EngBank_edit_mode == 1 ) then
			-- redraw the window to show the hilighting of entire class items
			EngBank_window_update_required = EngBank_MANDATORY;
                        EngBank_UpdateWindow();
                end
                return;
        end
        GameTooltip:SetOwner(this, "ANCHOR_LEFT");
		if itm["bagnum"] < 0 then
				GameTooltip:SetHyperlink(itm["itemlink"]);
			else
				hasCooldown, repairCost = GameTooltip:SetBagItem(itm["bagnum"], itm["slotnum"]);
		end

        if ( hasCooldown ) then
                this.updateTooltip = 1;
        else
                this.updateTooltip = nil;
        end

        if ( InRepairMode() and (repairCost and repairCost > 0) ) then
                GameTooltip:AddLine(TEXT(REPAIR_COST), 1, 1, 1);
                SetTooltipMoney(GameTooltip, repairCost);
                GameTooltip:Show();
        elseif ( MerchantFrame:IsVisible() ) then
                ShowContainerSellCursor(itm["bagnum"], itm["slotnum"]);
                EngBank_RegisterCurrentTooltipSellValue(GameTooltip, itm["bagnum"], itm["slotnum"], itm);
        elseif ( this.readable ) then
                ShowInspectCursor();
        end

        if ( EngBank_edit_mode == 1 ) then
                -- move by class
                if (itm["barClass"] ~= nil) then
			if (EngBank_edit_selected ~= "") then
				GameTooltip:AddLine("|cFF00FF7FLeft click to move catagory |r"..EngBank_edit_selected.."|cFF00FF7F to bar |r"..bar, 1,0.25,0.5 );
			else
				GameTooltip:AddLine(" ", 0,0,0);
				GameTooltip:AddLine("|cFF00FF7FLeft click to select catagory to move:|r "..itm["barClass"], 1,0.25,0.5 );
				GameTooltip:AddLine("Right click to assign this item to a different catagory", 1,0,0 );
				GameTooltip:AddLine(" ", 0,0,0);
			end
                else
                        GameTooltip:AddLine("Item has no catagory", 1,0,0 );
                end
        end

        EngBank_ModifyItemTooltip(itm["bagnum"], itm["slotnum"], "GameTooltip", itm);

        if ( EngBank_edit_mode == 1 ) then
		-- redraw the window to show the hllighting of entire class items
		EngBank_window_update_required = EngBank_MANDATORY;
                EngBank_UpdateWindow();
        end
        --AllInOneInventory_Patching_Tooltip = 0;
end

function EngBank_OnUpdate(elapsed)
        if ( not this.updateTooltip ) then
                return;
        end

        this.updateTooltip = this.updateTooltip - elapsed;
        if ( this.updateTooltip > 0 ) then
                return;
        end

        if ( GameTooltip:IsOwned(this) ) then
                EngBank_ItemButton_OnEnter();
        else
                this.updateTooltip = nil;
        end
end

function EngBank_ItemButton_OnLeave()
        EngBank_PrintDEBUG("EB_button: OnLeave()  this="..this:GetName() );

        if (EngBank_edit_selected == "") then
                EngBank_edit_hilight = "";
        end
        this.updateTooltip = nil;
        if ( GameTooltip:IsOwned(this) ) then
                GameTooltip:Hide();
                ResetCursor();
        end

        if ( EngBank_edit_mode == 1 ) then
		-- redraw the window to remove the hilighting of entire class items
		EngBank_window_update_required = EngBank_MANDATORY;
                EngBank_UpdateWindow();
        end
end

function EngBank_ItemButton_OnClick(button, ignoreShift)
        local bar, position, itm, bagnum, slotnum;

        if (EngBank_buttons[this:GetName()] ~= nil) then
                bar = EngBank_buttons[this:GetName()]["bar"];
                position = EngBank_buttons[this:GetName()]["position"];

		bagnum = EngBank_bar_positions[bar][position]["bagnum"];
		slotnum = EngBank_bar_positions[bar][position]["slotnum"];

                itm = EngBank_item_cache[bagnum][slotnum];
        end

        if (EngBank_edit_mode == 1) then
                -- don't do normal actions to this button, we're in edit mode
                if ( button == "LeftButton" ) then
                        if (EngBank_edit_selected == "") then
                                -- you clicked, we selected
                                EngBank_edit_selected = itm["barClass"];
                                EngBank_edit_hilight = itm["barClass"];
                        else
                                -- we got a click, and we already had one selected.  let's move the items
                                EngBankConfig["putinslot--"..EngBank_edit_selected] = bar;
				EngBank_resort_required = EngBank_MANDATORY;

                                EngBank_edit_selected = "";
                                EngBank_edit_hilight = itm["barClass"];

				-- resort will force a window update
                                EngBank_UpdateWindow();
                        end
		elseif ( button == "RightButton" ) then
			HideDropDownMenu(1);
			EngBank_RightClickMenu_mode = "item";
			EngBank_RightClickMenu_opts = {
				["bar"] = bar,
				["position"] = position,
				["bagnum"] = bagnum,
				["slotnum"] = slotnum
				};
			ToggleDropDownMenu(1, nil, EngBank_frame_RightClickMenu, this:GetName(), -50, 0);
                end
        else
                -- process normal clicks
		if (getglobal("AxuItemMenus_FillUtilityVariables") ~= nil) then
			if ( EngBank_DONT_CALL_AXUITEM == nil ) then
				if (AxuItemMenus_EvocationTest(button)) then
					AxuItemMenus_FillUtilityVariables(itm["bagnum"], itm["slotnum"]);
					AxuItemMenus_OpenMenu();
					return;
				end
			else
				if (getglobal("AxuItemMenus_EngBankHook") ~= nil) then
					if (AxuItemMenus_EngBankHook(itm["bagnum"], itm["slotnum"]) == 1) then
						return;
					end
				end
			end
		--else
		--	EngBank_PrintDEBUG("AxuItemMenus not detected");
		end

		-- process normal clicks
                if (itm) then
                        if ( button == "LeftButton" ) then
				if ( IsControlKeyDown() ) then
					DressUpItemLink(itm["itemlink"]);
				elseif ( IsShiftKeyDown() and not ignoreShift ) then
					if ( ChatFrameEditBox:IsVisible() ) then
						ChatFrameEditBox:Insert(GetContainerItemLink(itm["bagnum"], itm["slotnum"]));
					else
						--local texture, itemCount, locked, quality, readable = GetContainerItemInfo(itm["bag"], itm["slot"]);

						if ( not itm["locked"] ) then
							this.SplitStack = function(button, split)
								SplitContainerItem(itm["bagnum"], itm["slotnum"], split);
							end
							OpenStackSplitFrame(this.count, this, "BOTTOMRIGHT", "TOPRIGHT");
						end
					end
				else
					--AllInOneInventory_HandleQuickMount(bag, slot);

					PickupContainerItem(itm["bagnum"], itm["slotnum"]);
				end
                        elseif ( button == "RightButton" ) then
                                if ( Cosmos_ShiftToSell == true ) then
                                        if ( MerchantFrame:IsVisible() ) then
                                                if ( IsShiftKeyDown() ) then
                                                        UseContainerItem(itm["bagnum"], itm["slotnum"]);
                                                end
                                        else
                                                UseContainerItem(itm["bagnum"], itm["slotnum"]);
                                        end
                                else 
                                        if ( IsShiftKeyDown() and MerchantFrame:IsVisible() and not ignoreShift ) then
                                                this.SplitStack = function(button, split)
							local bar, position, bagnum, slotnum;

                                                        if (EngBank_buttons[this:GetName()] ~= nil) then
								bar = EngBank_buttons[this:GetName()]["bar"];
								position = EngBank_buttons[this:GetName()]["position"];

								bagnum = EngBank_bar_positions[bar][position]["bagnum"];
								slotnum = EngBank_bar_positions[bar][position]["slotnum"];

                                                                SplitContainerItem(bagnum, slotnum, split);
                                                                MerchantItemButton_OnClick("LeftButton");
                                                        end
                                                end
                                                OpenStackSplitFrame(this.count, this, "BOTTOMRIGHT", "TOPRIGHT");
                                        else
                                                UseContainerItem(itm["bagnum"], itm["slotnum"]);
                                        end
                                end
                        end
                end
		EngBank_window_update_required = EngBank_MANDATORY;
		EngBank_UpdateWindow();
        end
end

function EngBank_RightClick_PickupItem()
	local bagnum, slotnum;

	bagnum = this.value["bagnum"];
	slotnum = this.value["slotnum"];

	HideDropDownMenu(2);
	HideDropDownMenu(1);

	if ( (bagnum ~= nil) and (slotnum ~= nil) ) then
		PickupContainerItem(bagnum, slotnum);
	else
		message("Error, value not found.");
	end
end

function EngBank_Button_HighlightToggle_OnClick()
	PlaySound("igMainMenuOptionCheckBoxOn");
	if (EngBank_hilight_new == 0) then
		EngBank_hilight_new = 1;
		EngBank_Button_HighlightToggle:SetText(EBLocal["EngBank_Button_HighlightToggle_on"]);
	else
		EngBank_hilight_new = 0;
		EngBank_Button_HighlightToggle:SetText(EBLocal["EngBank_Button_HighlightToggle_off"]);
	end
	EngBank_window_update_required = EngBank_MANDATORY;
	EngBank_UpdateWindow();
end

function EngBank_Button_ChangeEditMode_OnClick()
	PlaySound("igMainMenuOptionCheckBoxOn");
	if (EngBank_edit_mode == 0) then
		EngBank_edit_mode = 1;
		EngBank_Button_ChangeEditMode:SetText(EBLocal["EngBank_Button_ChangeEditMode_MoveClass"]);
	--elseif (EngBank_edit_mode == 1) then
	--	EngBank_edit_mode = 2;
	--	this:SetText(EBLocal["EngBank_Button_ChangeEditMode_MoveItem"]);
	else
		EngBank_edit_mode = 0;
		EngBank_Button_ChangeEditMode:SetText(EBLocal["EngBank_Button_ChangeEditMode_off"]);
	end
	EngBank_resort_required = EngBank_MANDATORY;
	-- resort will force a window redraw
	EngBank_UpdateWindow();
end

function EngBank_Button_MoveLockToggle_OnClick()
	PlaySound("igMainMenuOptionCheckBoxOn");
	if (EngBankConfig["moveLock"] == 0) then
		EngBankConfig["moveLock"] = 1;
		EngBank_Button_MoveLockToggle:SetText(EBLocal["EngBank_Button_MoveLock_unlocked"]);
	else
		EngBankConfig["moveLock"] = 0;
		EngBank_Button_MoveLockToggle:SetText(EBLocal["EngBank_Button_MoveLock_locked"]);
	end
end

function EngBank_SlotTargetButton_OnClick(button, ignoreShift)
        local bar, tmp;

        if (EngBank_edit_mode == 1) then
                for tmp in string.gfind(this:GetName(), "EngBank_frame_SlotTarget_(%d+)") do
                        bar = tonumber(tmp);
                end

                if ( (bar == nil) or (bar < 1) or (bar > EngBank_MAX_BARS) ) then
                        return;
                end

                if ( button == "LeftButton" ) then

                        if (EngBank_edit_selected ~= "") then
                                -- we got a click, and we already had one selected.  let's move the items
                                EngBankConfig["putinslot--"..EngBank_edit_selected] = bar;

                                EngBank_edit_selected = "";
                                EngBank_edit_hilight = "";

				EngBank_resort_required = EngBank_MANDATORY;
				-- resort will force a window redraw as well
                                EngBank_UpdateWindow();
                        end

		elseif ( button == "RightButton" ) then

			HideDropDownMenu(1);
			EngBank_RightClickMenu_mode = "slot_target";
			EngBank_RightClickMenu_opts = {
				["bar"] = bar
				};
			ToggleDropDownMenu(1, nil, EngBank_frame_RightClickMenu, this:GetName(), -50, 0);

                end
        end
end

function EngBank_SlotTargetButton_OnEnter()
        local bar, tmp, key, value;

        if (EngBank_edit_mode == 1) then
                for tmp in string.gfind(this:GetName(), "EngBank_frame_SlotTarget_(%d+)") do
                        bar = tonumber(tmp);
                end

                if (EngBank_edit_selected ~= "") then
                        GameTooltip:SetOwner(this, "ANCHOR_LEFT");
                        GameTooltip:ClearLines();
                        GameTooltip:AddLine("|cFF00FF7FLeft click to move catagory |r"..EngBank_edit_selected.."|cFF00FF7F to bar |r"..bar, 1,0.25,0.5 );
                        GameTooltip:Show();
                        return;
		else
                        GameTooltip:SetOwner(this, "ANCHOR_LEFT");
                        GameTooltip:ClearLines();
                        GameTooltip:AddLine("|cFF00FF7FBar |r"..bar, 1,0.25,0.5 );
			--GameTooltip:AddLine(" ");
			for key,value in EngBankConfig do
				if ( (string.find(key, "putinslot--")) and (value==bar) and (not string.find(key, "__version")) ) then
					barclass = string.sub(key, 12);
					GameTooltip:AddLine(barclass);
				end
			end
                        GameTooltip:Show();
			return;
                end
        end
        if ( GameTooltip:IsOwned(this) ) then
                GameTooltip:Hide();
                ResetCursor();
        end
end

function EngBank_SlotTargetButton_OnLeave()
        this.updateTooltip = nil;
        if ( GameTooltip:IsOwned(this) ) then
                GameTooltip:Hide();
                ResetCursor();
        end
end

function EngBank_SlotTargetButton_OnUpdate(elapsed)
        if ( not this.updateTooltip ) then
                return;
        end

        this.updateTooltip = this.updateTooltip - elapsed;
        if ( this.updateTooltip > 0 ) then
                return;
        end

        if ( GameTooltip:IsOwned(this) ) then
                EngBank_SlotTargetButton_OnEnter();
        else
                this.updateTooltip = nil;
        end
end

function EngBank_SetNewColor(previousValues)
	local r,g,b,opacity;

	r = nil;
	g = nil;
	b = nil;
	opacity = nil;

	if (this:GetName() == "ColorPickerFrame") then
		r,g,b = this:GetColorRGB();
		opacity = OpacitySliderFrame:GetValue();
	elseif (this:GetName() == "OpacitySliderFrame") then
		opacity = OpacitySliderFrame:GetValue();
	else
		if (previousValues ~= nil) then
			r = previousValues["r"];
			g = previousValues["g"];
			b = previousValues["b"];
			opacity = previousValues["opacity"];
		else
			return;
		end
	end

	if (UIDROPDOWNMENU_MENU_VALUE ~= nil) then
		if (r ~= nil) then
			EngBankConfig["bar_colors_"..(UIDROPDOWNMENU_MENU_VALUE["bar"]).."_"..(UIDROPDOWNMENU_MENU_VALUE["element"]).."_r"] = r;
		end
		if (g ~= nil) then
			EngBankConfig["bar_colors_"..(UIDROPDOWNMENU_MENU_VALUE["bar"]).."_"..(UIDROPDOWNMENU_MENU_VALUE["element"]).."_g"] = g;
		end
		if (b ~= nil) then
			EngBankConfig["bar_colors_"..(UIDROPDOWNMENU_MENU_VALUE["bar"]).."_"..(UIDROPDOWNMENU_MENU_VALUE["element"]).."_b"] = b;
		end
		if (opacity ~= nil) then
			EngBankConfig["bar_colors_"..(UIDROPDOWNMENU_MENU_VALUE["bar"]).."_"..(UIDROPDOWNMENU_MENU_VALUE["element"]).."_a"] = opacity;
		end
		EngBank_window_update_required = EngBank_MANDATORY;
		EngBank_UpdateWindow();
	end
end

function EngBank_RightClick_DeleteItemOverride()
	local bagnum, slotnum, itm;

	bagnum = this.value["bagnum"];
	slotnum = this.value["slotnum"];

	if ( (bagnum ~= nil) and (slotnum ~= nil) ) then
		itm = EngBank_item_cache[bagnum][slotnum];

		if ( (itm["itemlink_override_key"] ~= nil) and (EngBankConfig["item_overrides"][itm["itemlink_override_key"]] ~= nil) ) then
			EngBankConfig["item_overrides"] = EngBank_Table_RemoveKey(EngBankConfig["item_overrides"], itm["itemlink_override_key"] );
			HideDropDownMenu(1);
			EngBank_resort_required = EngBank_MANDATORY;
			-- resort will force a window redraw as well
			EngBank_UpdateWindow();
		end
	end
end

function EngBank_RightClick_SetItemOverride()
	local bagnum, slotnum, itm, new_barclass;

	bagnum = this.value["bagnum"];
	slotnum = this.value["slotnum"];
	new_barclass = this.value["barclass"];

	if ( (bagnum ~= nil) and (slotnum ~= nil) and (new_barclass ~= nil) ) then
		itm = EngBank_item_cache[bagnum][slotnum];

		EngBankConfig["item_overrides"][itm["itemlink_override_key"]] = new_barclass;
		HideDropDownMenu(2);
		HideDropDownMenu(1);
		EngBank_resort_required = EngBank_MANDATORY;
		EngBank_UpdateWindow();
	end
end

function EngBank_frame_RightClickMenu_populate(level)
	local bar, position, bagnum, slotnum;
	local info, itm, barclass, tmp, checked, i;
	local key, value, key2, value2;


	-------------------------------------------------------------------------------------------------
	------------------------------- ITEM CONTEXT MENU -----------------------------------------------
	-------------------------------------------------------------------------------------------------
	if (EngBank_RightClickMenu_mode == "item") then
		-- we have a right click on a button

		bar = EngBank_RightClickMenu_opts["bar"];
		position = EngBank_RightClickMenu_opts["position"];
		bagnum = EngBank_bar_positions[bar][position]["bagnum"];
		slotnum = EngBank_bar_positions[bar][position]["slotnum"];
		itm = EngBank_item_cache[bagnum][slotnum];

		if (level == 1) then
			-- top level of menu

			info = { ["text"] = itm["itemname"], ["notClickable"] = 1, ["isTitle"] = 1, ["notCheckable"] = nil };
			UIDropDownMenu_AddButton(info, level);

			info = { ["disabled"] = 1 };
			UIDropDownMenu_AddButton(info, level);

			info = { ["text"] = "Current Catagory: "..itm["barClass"], ["notClickable"] = 1, ["isTitle"] = 1, ["notCheckable"] = nil };
			UIDropDownMenu_AddButton(info, level);

			info = { ["disabled"] = 1 };
			UIDropDownMenu_AddButton(info, level);

			info = { ["text"] = "Assign item to catagory:", ["hasArrow"] = 1, ["value"] = "override_placement" };
			if (EngBankConfig["item_overrides"][itm["itemlink_override_key"]] ~= nil) then
				info["checked"] = 1;
			end
			UIDropDownMenu_AddButton(info, level);

			info = {
				["text"] = "Use default catagory assignment",
				["value"] = { ["bagnum"]=bagnum, ["slotnum"]=slotnum },
				["func"] = EngBank_RightClick_DeleteItemOverride
				};
			if (EngBankConfig["item_overrides"][itm["itemlink_override_key"]] == nil) then
				info["checked"] = 1;
			end
			UIDropDownMenu_AddButton(info, level);

			if (EngBank_SHOWITEMDEBUGINFO==1) then
				info = { ["disabled"] = 1 };
				UIDropDownMenu_AddButton(info, level);

				info = { ["text"] = "Debug Info: ", ["hasArrow"] = 1, ["value"] = "show_debug" };
				UIDropDownMenu_AddButton(info, level);
			end
		elseif (level == 2) then
			if ( this.value == "override_placement" ) then
				for i = EngBank_MAX_BARS, 1, -1 do
					info = {
						["text"] = "Catagories within bar "..i;
						["value"] = { ["opt"]="override_placement_select", ["bagnum"]=bagnum, ["slotnum"]=slotnum, ["select_bar"]=i },
						["hasArrow"] = 1
						};
					if ( (EngBankConfig["item_overrides"][itm["itemlink_override_key"]] ~= nil) and (EngBankConfig["putinslot--"..EngBankConfig["item_overrides"][itm["itemlink_override_key"]]] == i) ) then
						info["checked"] = 1;
					end
					UIDropDownMenu_AddButton(info, level);
				end
			elseif ( this.value == "show_debug" ) then
				for key,value in itm do
					if (value == nil) then
						info = { ["text"] = "|cFFFF7FFF"..key.."|r = |cFF007FFFNil|r", ["notClickable"] = 1 };
						UIDropDownMenu_AddButton(info, level);
					else
						if ( (type(value) == "number") or (type(value) == "string") ) then
							info = { ["text"] = "|cFFFF7FFF"..key.."|r = |cFF007FFF"..value.."|r", ["notClickable"] = 1 };
							UIDropDownMenu_AddButton(info, level);
						else
							info = { ["text"] = "|cFFFF7FFF"..key.."|r|cFF338FFF=>Array()|r", ["notClickable"] = 1 };
							UIDropDownMenu_AddButton(info, level);
							for key2,value2 in value do
								info = { ["text"] = "    |cFFFF7FFF["..key2.."]|r = |cFF338FFF"..value2.."|r", ["notClickable"] = 1 };
								UIDropDownMenu_AddButton(info, level);
							end
						end
					end
				end
			end
		elseif (level == 3) then
			if ( this.value ~= nil ) then
				if ( this.value["opt"] == "override_placement_select" ) then
					for key,barclass in EngBank_Catagories(EngBank_Catagories_Exclude_List, this.value["select_bar"]) do
						info = {
							["text"] = barclass;
							["value"] = { ["bagnum"]=bagnum, ["slotnum"]=slotnum, ["barclass"]=barclass },
							["func"] = EngBank_RightClick_SetItemOverride
							};
						if (EngBankConfig["item_overrides"][itm["itemlink_override_key"]] == barclass) then
							info["checked"] = 1;
						end
						UIDropDownMenu_AddButton(info, level);
					end
				end
			end
		end

	-------------------------------------------------------------------------------------------------
	------------------------ SLOT TARGET CONTEXT MENU -----------------------------------------------
	-------------------------------------------------------------------------------------------------
	elseif (EngBank_RightClickMenu_mode == "slot_target") then
		-- right click on a slot
		bar = EngBank_RightClickMenu_opts["bar"];

		info = { ["text"] = "Bar "..bar, ["notClickable"] = 1, ["isTitle"] = 1, ["notCheckable"] = nil };
		UIDropDownMenu_AddButton(info, level);

		info = { ["disabled"] = 1 };
		UIDropDownMenu_AddButton(info, level);

		for key,value in EngBankConfig do
			if ( (string.find(key, "putinslot--")) and (value==bar) and (not string.find(key, "__version")) ) then
				barclass = string.sub(key, 12);

				if ( type(value)=="number" ) then
					info = {
						["text"] = "Select: "..barclass;
						["value"] = barclass;
						["func"] = function()
								EngBank_edit_selected = (this.value);
								EngBank_edit_hilight = (this.value);
								EngBank_window_update_required = EngBank_MANDATORY;
								EngBank_UpdateWindow();
							end
						};
					UIDropDownMenu_AddButton(info, level);
				else
					info = {
						["text"] = "Select: "..barclass.." => "..value,
						["value"] = value;
						["func"] = function()
								EngBank_edit_selected = (this.value);
								EngBank_edit_hilight = (this.value);
								EngBank_window_update_required = EngBank_MANDATORY;
								EngBank_UpdateWindow();
							end
						};
					UIDropDownMenu_AddButton(info, level);
				end
			end
		end

		info = { ["disabled"] = 1 };
		UIDropDownMenu_AddButton(info, level);

		info = { ["text"] = "Sort Mode:", ["notClickable"] = 1, ["isTitle"] = 1, ["notCheckable"] = nil };
		UIDropDownMenu_AddButton(info, level);

		for key,value in {
			[EngBank_NOSORT] = "No sort",
			[EngBank_SORTBYNAME] = "Sort by name",
			[EngBank_SORTBYNAMEREV] = "Sort last words first"
			} do
	
			if (EngBankConfig["bar_sort_"..bar] == key) then
				checked = 1;
			else
				checked = nil;
			end
			info = {
				["text"] = value;
				["value"] = { ["bar"]=bar, ["sortmode"]=key };
				["func"] = function()
						EngBankConfig["bar_sort_"..(this.value["bar"])] = (this.value["sortmode"]);
						EngBank_resort_required = EngBank_MANDATORY;
						EngBank_UpdateWindow();			
					end,
				["checked"] = checked
				};
			UIDropDownMenu_AddButton(info, level);
		end

		info = { ["disabled"] = 1 };
		UIDropDownMenu_AddButton(info, level);

		info = { ["text"] = "Hilight new items:", ["notClickable"] = 1, ["isTitle"] = 1, ["notCheckable"] = nil };
		UIDropDownMenu_AddButton(info, level);

		for key,value in {
			[0] = "Don't tag new items",
			[1] = "Tag new items"
			} do

			if (EngBankConfig["allow_new_in_bar_"..bar] == key) then
				checked = 1;
			else
				checked = nil;
			end

			info = {
				["text"] = value;
				["value"] = { ["bar"]=bar, ["value"]=key };
				["func"] = function()
						EngBankConfig["allow_new_in_bar_"..(this.value["bar"])] = (this.value["value"]);
						EngBank_resort_required = EngBank_MANDATORY;
						EngBank_UpdateWindow();
					end,
				["checked"] = checked
				};
			UIDropDownMenu_AddButton(info, level);
		end

		info = { ["disabled"] = 1 };
		UIDropDownMenu_AddButton(info, level);

		info = { ["text"] = "Color:", ["notClickable"] = 1, ["isTitle"] = 1, ["notCheckable"] = nil };
		UIDropDownMenu_AddButton(info, level);
		info = {
			["text"] = "Background Color",
			["hasColorSwatch"] = 1,
			["hasOpacity"] = 1,
			["r"] = EngBankConfig["bar_colors_"..bar.."_background_r"],
			["g"] = EngBankConfig["bar_colors_"..bar.."_background_g"],
			["b"] = EngBankConfig["bar_colors_"..bar.."_background_b"],
			["opacity"] = EngBankConfig["bar_colors_"..bar.."_background_a"],
			["notClickable"] = 1,
			["value"] = { ["bar"]=bar, ["element"] = "background" },
			["swatchFunc"] = EngBank_SetNewColor,
			["cancelFunc"] = EngBank_SetNewColor,
			["opacityFunc"] = EngBank_SetNewColor
			};
		UIDropDownMenu_AddButton(info, level);
		info = {
			["text"] = "Border Color",
			["hasColorSwatch"] = 1,
			["hasOpacity"] = 1,
			["r"] = EngBankConfig["bar_colors_"..bar.."_border_r"],
			["g"] = EngBankConfig["bar_colors_"..bar.."_border_g"],
			["b"] = EngBankConfig["bar_colors_"..bar.."_border_b"],
			["opacity"] = EngBankConfig["bar_colors_"..bar.."_border_a"],
			["notClickable"] = 1,
			["value"] = { ["bar"]=bar, ["element"] = "border" },
			["swatchFunc"] = EngBank_SetNewColor,
			["cancelFunc"] = EngBank_SetNewColor,
			["opacityFunc"] = EngBank_SetNewColor
			};
		UIDropDownMenu_AddButton(info, level);

	-------------------------------------------------------------------------------------------------
	------------------------ MAIN WINDOW CONTEXT MENU -----------------------------------------------
	-------------------------------------------------------------------------------------------------
	elseif (EngBank_RightClickMenu_mode == "mainwindow") then
		if (level == 1) then

			info = { ["text"] = EBLocal["RightClick_MenuTitle"], ["notClickable"] = 1, ["isTitle"] = 1, ["notCheckable"] = nil };
			UIDropDownMenu_AddButton(info, level);


			info = { ["disabled"] = 1 };
			UIDropDownMenu_AddButton(info, level);

			info = {
				["text"] = "Hilight New Items",
				["value"] = nil,
				["func"] = EngBank_Button_HighlightToggle_OnClick
				};
			if (EngBank_hilight_new == 1) then
				info["checked"] = 1;
			end
			UIDropDownMenu_AddButton(info, level);

			info = {
				["text"] = "Edit Mode",
				["value"] = nil,
				["func"] = EngBank_Button_ChangeEditMode_OnClick
				};
			if (EngBank_edit_mode == 1) then
				info["checked"] = 1;
			end
			UIDropDownMenu_AddButton(info, level);

			info = {
				["text"] = "Lock window",
				["value"] = nil,
				["func"] = EngBank_Button_MoveLockToggle_OnClick
				};
			if (EngBankConfig["moveLock"] == 0) then
				info["checked"] = 1;
			end
			UIDropDownMenu_AddButton(info, level);

			info = {
				["text"] = "Show Graphics",
				["value"] = nil,
				["func"] = function()
						if (EngBankConfig["show_top_graphics"] == 0) then
							EngBankConfig["show_top_graphics"] = 1;
						else
							EngBankConfig["show_top_graphics"] = 0;
						end
						EngBank_window_update_required = EngBank_MANDATORY;
						EngBank_UpdateWindow();
					end
				};
			if (EngBankConfig["show_top_graphics"] == 1) then
				info["checked"] = 1;
			end
			UIDropDownMenu_AddButton(info, level);

			info = { ["disabled"] = 1 };
			UIDropDownMenu_AddButton(info, level);

			info = {
				["text"] = "Reset NEW tag",
				["value"] = nil,
				["func"] = function()
						local bagnum, slotnum;

							for vbagnum = 4, 10 do
								if (vbagnum==4) then
									bagnum=-1;
								else
									bagnum=vbagnum;
								end
							if (EngBankConfig["show_Bag"..bagnum] == 1) then
								if (table.getn(EngBank_item_cache[bagnum]) > 0) then
									for slotnum = 1, table.getn(EngBank_item_cache[bagnum]) do
										EngBank_item_cache[bagnum][slotnum]["indexed_on"] = 1;
										EngBank_item_cache[bagnum][slotnum]["display_string"] = "NewItemText_Off";
									end
								end
							end
						end

						EngBank_window_update_required = EngBank_MANDATORY;
						EngBank_UpdateWindow();
					end
				};
			UIDropDownMenu_AddButton(info, level);

			info = { ["disabled"] = 1 };
			UIDropDownMenu_AddButton(info, level);

			info = {
				["text"] = "Advanced Configuration",
				["value"] = nil,
				["func"] = function()
						EngBank_OptsFrame:Show();
					end
				};
			UIDropDownMenu_AddButton(info, level);

			info = { ["disabled"] = 1 };
			UIDropDownMenu_AddButton(info, level);

			
			info = {
				["text"] = "Set button size";
				["value"] = { ["opt"]="set_button_size" },
				["hasArrow"] = 1
				};
			UIDropDownMenu_AddButton(info, level);

			info = { ["disabled"] = 1 };
			UIDropDownMenu_AddButton(info, level);
			

			info = {
				["text"] = "Background Color",
				["hasColorSwatch"] = 1,
				["hasOpacity"] = 1,
				["r"] = EngBankConfig["bar_colors_"..EngBank_MAINWINDOWCOLORIDX.."_background_r"],
				["g"] = EngBankConfig["bar_colors_"..EngBank_MAINWINDOWCOLORIDX.."_background_g"],
				["b"] = EngBankConfig["bar_colors_"..EngBank_MAINWINDOWCOLORIDX.."_background_b"],
				["opacity"] = EngBankConfig["bar_colors_"..EngBank_MAINWINDOWCOLORIDX.."_background_a"],
				["notClickable"] = 1,
				["value"] = { ["bar"]=EngBank_MAINWINDOWCOLORIDX, ["element"] = "background" },
				["swatchFunc"] = EngBank_SetNewColor,
				["cancelFunc"] = EngBank_SetNewColor,
				["opacityFunc"] = EngBank_SetNewColor
				};
			UIDropDownMenu_AddButton(info, level);
			info = {
				["text"] = "Border Color",
				["hasColorSwatch"] = 1,
				["hasOpacity"] = 1,
				["r"] = EngBankConfig["bar_colors_"..EngBank_MAINWINDOWCOLORIDX.."_border_r"],
				["g"] = EngBankConfig["bar_colors_"..EngBank_MAINWINDOWCOLORIDX.."_border_g"],
				["b"] = EngBankConfig["bar_colors_"..EngBank_MAINWINDOWCOLORIDX.."_border_b"],
				["opacity"] = EngBankConfig["bar_colors_"..EngBank_MAINWINDOWCOLORIDX.."_border_a"],
				["notClickable"] = 1,
				["value"] = { ["bar"]=EngBank_MAINWINDOWCOLORIDX, ["element"] = "border" },
				["swatchFunc"] = EngBank_SetNewColor,
				["cancelFunc"] = EngBank_SetNewColor,
				["opacityFunc"] = EngBank_SetNewColor
				};
			UIDropDownMenu_AddButton(info, level);
		elseif (level == 2) then
			if (this.value ~= nil) then
				if (this.value["opt"] == "set_button_size") then
					for key,value in { 20,30,35,40,50 } do
						info = {
							["text"] = value.."x"..value;
							["value"] = value;
							["func"] = function()
									if ( (type(this.value) == "number") and (this.value > 19) ) then
										EngBankConfig["frameButtonSize"] = this.value;
										EngBank_CalcButtonSize(EngBankConfig["frameButtonSize"]);
										EngBank_window_update_required = EngBank_MANDATORY;
										EngBank_UpdateWindow();
									end
								end
							};
						if (EngBankConfig["frameButtonSize"] == value) then
							info["checked"] = 1;
						end
						UIDropDownMenu_AddButton(info, level);
					end
				end
			end
		end
	end
end


-- Main "right click menu"
function EngBank_frame_RightClickMenu_OnLoad()
	UIDropDownMenu_Initialize(this, EngBank_frame_RightClickMenu_populate, "MENU");
end


function EngBank_IncreaseColumns()
	if (EngBankConfig["maxColumns"] < EngBank_MAXCOLUMNS_MAX) then
		EngBankConfig["maxColumns"] = EngBankConfig["maxColumns"] + 1;
		EngBank_window_update_required = EngBank_MANDATORY;
		EngBank_UpdateWindow();
	end
end

function EngBank_DecreaseColumns()
	if (EngBankConfig["maxColumns"] > EngBank_MAXCOLUMNS_MIN) then
		EngBankConfig["maxColumns"] = EngBankConfig["maxColumns"] - 1;
		EngBank_window_update_required = EngBank_MANDATORY;
		EngBank_UpdateWindow();
	end
end

function EngBank_MoveAndSizeFrame(frameName, childAttachPoint, parentFrameName, parentAttachPoint, xoffset, yoffset, width, height)
        local frame = getglobal(frameName);

        if (frame) then
                frame:ClearAllPoints();
                frame:SetPoint(childAttachPoint, parentFrameName, parentAttachPoint, xoffset, yoffset);
                frame:SetWidth(width);
                frame:SetHeight(height);
                frame:Show();
        else
                message("Attempt to find frame '"..frameName.."' failed.");
        end
end


-- bar == current bar
-- currentbutton == next button to use
-- frame == name of background frame to be relative to
-- width/height == max number of buttons to place into frame
function EngBank_AssignButtonsToFrame(barnum, currentbutton, frame, width, height)
        local cur_x, cur_y, tmpframe;
	local position;
	local bagnum, slotnum;

        cur_x = 0;
        cur_y = 0;

        if (table.getn(EngBank_bar_positions[barnum]) > 0) then
                for position = 1, table.getn(EngBank_bar_positions[barnum]) do
			bagnum = EngBank_bar_positions[barnum][position]["bagnum"];
			slotnum = EngBank_bar_positions[barnum][position]["slotnum"];

                        EngBank_item_cache[bagnum][slotnum]["button_num"] = currentbutton;

                        EngBank_MoveAndSizeFrame("EngBank_frame_Item_"..currentbutton, "BOTTOMRIGHT",
                                frame, "BOTTOMRIGHT",
                                0-(
                                ((cur_x*EngBank_BUTTONFRAME_WIDTH )+EngBank_BUTTONFRAME_X_PADDING) + EngBankConfig["frameXSpace"]
                                ),
                                ((cur_y*EngBank_BUTTONFRAME_HEIGHT)+EngBank_BUTTONFRAME_Y_PADDING) + EngBankConfig["frameYSpace"],
                                EngBank_BUTTONFRAME_BUTTONWIDTH,
                                EngBank_BUTTONFRAME_BUTTONHEIGHT );

                        EngBank_buttons["EngBank_frame_Item_"..currentbutton] = { ["bar"]=barnum, ["position"]=position, ["bagnum"]=bagnum, ["slotnum"]=slotnum };
                        EngBank_UpdateButton( getglobal("EngBank_frame_Item_"..currentbutton), EngBank_item_cache[bagnum][slotnum] );

                        cur_x = cur_x + 1;
                        if (cur_x == width) then
                                cur_x = 0;
                                cur_y = cur_y + 1;
                        end

                        currentbutton = currentbutton + 1;
                end
        end

        if (EngBank_edit_mode == 1) then
                -- add extra button for targetting
                EngBank_MoveAndSizeFrame("EngBank_frame_SlotTarget_"..barnum, "BOTTOMRIGHT",
                        frame, "BOTTOMRIGHT",
                        0-(
                        (((width-1)*EngBank_BUTTONFRAME_WIDTH )+EngBank_BUTTONFRAME_X_PADDING) + EngBankConfig["frameXSpace"]
                        ),
                        (((height-1)*EngBank_BUTTONFRAME_HEIGHT)+EngBank_BUTTONFRAME_Y_PADDING) + EngBankConfig["frameYSpace"],
                        EngBank_BUTTONFRAME_BUTTONWIDTH,
                        EngBank_BUTTONFRAME_BUTTONHEIGHT );
                EngBank_MoveAndSizeFrame("EngBank_frame_SlotTarget_"..barnum.."_bkgr", "TOPLEFT",
                        "EngBank_frame_SlotTarget_"..barnum, "TOPLEFT",
                        0-EngBank_BUTTONFRAME_X_PADDING,
                        EngBank_BUTTONFRAME_Y_PADDING,
                        EngBank_BKGRFRAME_WIDTH,
                        EngBank_BKGRFRAME_HEIGHT );
                
                tmpframe = getglobal("EngBank_frame_SlotTarget_"..barnum.."_BigText");
                tmpframe:SetText( barnum );
                tmpframe:Show();
                tmpframe = getglobal("EngBank_frame_SlotTarget_"..barnum.."_bkgr");
                tmpframe:SetVertexColor( 1,0,0.25, 0.5 );
        end

        return currentbutton;
end

EngBank_WindowIsUpdating = 0;
function EngBank_UpdateWindow()
        local frame = getglobal("EngBank_frame");
        
        local currentbutton, barnum, slotnum;
        local barframe_one, barframe_two, barframe_three, tmpframe;
        local calc_dat, tmpcalc, cur_y;
        local available_width, width_in_between, mid_point;

        EngBank_PrintDEBUG("ei: UpdateWindow()  WindowIsUpdating="..EngBank_WindowIsUpdating );

        if (EngBank_WindowIsUpdating == 1) then
                return;
        end
        EngBank_WindowIsUpdating = 1;

        if ( EBLocal["_loaded"]==0 ) then
                EngBank_WindowIsUpdating = 0;
                return;
        end

        EngBank_Update_item_cache();
	if (EngBank_resort_required == EngBank_MANDATORY) then
		EngBank_Sort_item_cache();
	end

	if (EngBank_edit_mode == 1) then
		EngBank_WindowBottomPadding = EngBank_WINDOWBOTTOMPADDING_EDITMODE;
	else
		EngBank_WindowBottomPadding = EngBank_WINDOWBOTTOMPADDING_NORMALMODE;
	end

	if (EngBank_window_update_required > EngBank_NOTNEEDED) then

		currentbutton = 1;
		cur_y = EngBankConfig["frameYSpace"] + EngBank_WindowBottomPadding;
		for barnum = 1, EngBank_MAX_BARS, 3 do
			barframe_one = getglobal("EngBank_frame_bar_"..barnum);
			barframe_two = getglobal("EngBank_frame_bar_"..(barnum+1));
			barframe_three = getglobal("EngBank_frame_bar_"..(barnum+2));

			calc_dat = {};
			calc_dat = {
				["first"] = table.getn(EngBank_bar_positions[barnum]),
				["second"] = table.getn(EngBank_bar_positions[barnum+1]),
				["third"] = table.getn(EngBank_bar_positions[barnum+2])
				};
			if (EngBank_edit_mode == 1) then
				-- add an extra slot if we're in edit mode
				calc_dat["first"] = calc_dat["first"] + 1;
				calc_dat["second"] = calc_dat["second"] + 1;
				calc_dat["third"] = calc_dat["third"] + 1;
			else
				-- we're not in edit mode, make sure the SlotTarget button and texture is hidden
				for vbarnum = 0, 2 do
				tmpframe = getglobal("EngBank_frame_SlotTarget_"..(barnum+vbarnum));
				tmpframe:Hide();
				tmpframe = getglobal("EngBank_frame_SlotTarget_"..(barnum+vbarnum).."_bkgr");
				tmpframe:Hide();
				end
			end
			--calc_dat["total_in_row"] = calc_dat["first"] + calc_dat["second"] + calc_dat["third"];
  			sbarnum = {"first", "second", "third"}
    			for element in list_iter(sbarnum) do

				calc_dat[element.."_heighttable"] = {};
				if calc_dat[element] > 0 then
					for tmpcalc = 1, calc_dat[element] do
						calc_dat[element.."_heighttable"][tmpcalc] = math.ceil( calc_dat[element] / tmpcalc );
					end
				end
			end

			calc_dat["height"] = 0;
			repeat
				calc_dat["height"] = calc_dat["height"] + 1;
				tmpcalc = 0;
				for element in list_iter(sbarnum) do
					if (calc_dat[element] > 0) then
						if (calc_dat[element.."_heighttable"][calc_dat["height"]]) then
							tmpcalc = tmpcalc + calc_dat[element.."_heighttable"][calc_dat["height"]];
						else
							tmpcalc = tmpcalc + 1;
						end
					end
				end

			until tmpcalc <= EngBankConfig["maxColumns"];

			if tmpcalc == 0 then
				calc_dat["height"] = 0;
			else

				-- at calc_dat["height"], everything fits
				for element in list_iter(sbarnum) do
				if calc_dat[element] > 0 then
					if (calc_dat[element.."_heighttable"][calc_dat["height"]]) then
						calc_dat[element.."_width"] = calc_dat[element.."_heighttable"][calc_dat["height"]];
					else
						calc_dat[element.."_width"] = 1;
					end
				else
					calc_dat[element.."_width"] = 0;
				end
				end

			end

			--- now we know the size and height of all 3 bars for this line

			if (calc_dat["height"] == 0) then
				-- all 3 bars are not visible
				barframe_one:Hide();
				barframe_two:Hide();
				barframe_three:Hide();
			else
				available_width = (EngBankConfig["maxColumns"]*EngBank_BUTTONFRAME_WIDTH) + (10*EngBankConfig["frameXSpace"]);

				------------------------------------------------------------------------------------------
				--------- FIRST BAR
				if (calc_dat["first_width"] > 0) then
				EngBank_MoveAndSizeFrame("EngBank_frame_bar_"..barnum, "BOTTOMRIGHT",
					"EngBank_frame", "BOTTOMRIGHT",
					0-EngBankConfig["frameXSpace"],
					cur_y,
					(calc_dat["first_width"]*EngBank_BUTTONFRAME_WIDTH)+(2*EngBankConfig["frameXSpace"]),
					(calc_dat["height"]*EngBank_BUTTONFRAME_HEIGHT)+(2*EngBankConfig["frameYSpace"]) );
				barframe_one:SetBackdropColor(
					EngBankConfig["bar_colors_"..barnum.."_background_r"],
					EngBankConfig["bar_colors_"..barnum.."_background_g"],
					EngBankConfig["bar_colors_"..barnum.."_background_b"],
					EngBankConfig["bar_colors_"..barnum.."_background_a"] );
				barframe_one:SetBackdropBorderColor(
					EngBankConfig["bar_colors_"..barnum.."_border_r"],
					EngBankConfig["bar_colors_"..barnum.."_border_g"],
					EngBankConfig["bar_colors_"..barnum.."_border_b"],
					EngBankConfig["bar_colors_"..barnum.."_border_a"] );
				else
					barframe_one:Hide();
				end
				------------------------------------------------------------------------------------------
				--------- SECOND BAR
				if (calc_dat["second_width"] > 0) then
					width_in_between = available_width - (
						(EngBankConfig["frameXSpace"] * 4) +       -- border on both sides + borders between frames
						((calc_dat["first_width"]*EngBank_BUTTONFRAME_WIDTH)+(2*EngBankConfig["frameXSpace"])) +      -- bar 1 size
						((calc_dat["third_width"]*EngBank_BUTTONFRAME_WIDTH)+(2*EngBankConfig["frameXSpace"]))        -- bar 3 size
						);
					mid_point = (width_in_between/2) +
						((calc_dat["first_width"]*EngBank_BUTTONFRAME_WIDTH)+(2*EngBankConfig["frameXSpace"])) +
						(EngBankConfig["frameXSpace"] * 2);


					EngBank_MoveAndSizeFrame("EngBank_frame_bar_"..(barnum+1), "BOTTOMRIGHT",
						"EngBank_frame", "BOTTOMRIGHT",
						0-( mid_point - (((calc_dat["second_width"]*EngBank_BUTTONFRAME_WIDTH)+(2*EngBankConfig["frameXSpace"]))/2) ),
						cur_y,
						(calc_dat["second_width"]*EngBank_BUTTONFRAME_WIDTH)+(2*EngBankConfig["frameXSpace"]),
						(calc_dat["height"]*EngBank_BUTTONFRAME_HEIGHT)+(2*EngBankConfig["frameYSpace"]) );
					barframe_two:SetBackdropColor(
						EngBankConfig["bar_colors_"..(barnum+1).."_background_r"],
						EngBankConfig["bar_colors_"..(barnum+1).."_background_g"],
						EngBankConfig["bar_colors_"..(barnum+1).."_background_b"],
						EngBankConfig["bar_colors_"..(barnum+1).."_background_a"] );
					barframe_two:SetBackdropBorderColor(
						EngBankConfig["bar_colors_"..(barnum+1).."_border_r"],
						EngBankConfig["bar_colors_"..(barnum+1).."_border_g"],
						EngBankConfig["bar_colors_"..(barnum+1).."_border_b"],
						EngBankConfig["bar_colors_"..(barnum+1).."_border_a"] );
				else
					barframe_two:Hide();
				end

				------------------------------------------------------------------------------------------
				--------- THIRD BAR
				if (calc_dat["third_width"] > 0) then
				EngBank_MoveAndSizeFrame("EngBank_frame_bar_"..(barnum+2), "BOTTOMRIGHT",
					"EngBank_frame", "BOTTOMRIGHT",
					(0-available_width) +(calc_dat["third_width"]*EngBank_BUTTONFRAME_WIDTH)+(3*EngBankConfig["frameXSpace"]),
					cur_y,
					(calc_dat["third_width"]*EngBank_BUTTONFRAME_WIDTH)+(2*EngBankConfig["frameXSpace"]),
					(calc_dat["height"]*EngBank_BUTTONFRAME_HEIGHT)+(2*EngBankConfig["frameYSpace"]) );
				barframe_three:SetBackdropColor(
					EngBankConfig["bar_colors_"..(barnum+2).."_background_r"],
					EngBankConfig["bar_colors_"..(barnum+2).."_background_g"],
					EngBankConfig["bar_colors_"..(barnum+2).."_background_b"],
					EngBankConfig["bar_colors_"..(barnum+2).."_background_a"] );
				barframe_three:SetBackdropBorderColor(
					EngBankConfig["bar_colors_"..(barnum+2).."_border_r"],
					EngBankConfig["bar_colors_"..(barnum+2).."_border_g"],
					EngBankConfig["bar_colors_"..(barnum+2).."_border_b"],
					EngBankConfig["bar_colors_"..(barnum+2).."_border_a"] );
				else
					barframe_three:Hide();
				end
				-----
				currentbutton = EngBank_AssignButtonsToFrame(barnum, currentbutton,
					"EngBank_frame_bar_"..(barnum),
					calc_dat["first_width"], calc_dat["height"] );
				currentbutton = EngBank_AssignButtonsToFrame(barnum+1, currentbutton,
					"EngBank_frame_bar_"..(barnum+1),
					calc_dat["second_width"], calc_dat["height"] );
				currentbutton = EngBank_AssignButtonsToFrame(barnum+2, currentbutton,
					"EngBank_frame_bar_"..(barnum+2),
					calc_dat["third_width"], calc_dat["height"] );

				cur_y = cur_y + (calc_dat["height"]*EngBank_BUTTONFRAME_HEIGHT)+(3*EngBankConfig["frameYSpace"]);
			end
		end

		-- hide unused buttons
		if (currentbutton <= EngBank_MAXBUTTONS) then
			for currentbutton = currentbutton, EngBank_MAXBUTTONS do
				tmpframe = getglobal("EngBank_frame_Item_"..(currentbutton));
				tmpframe:Hide();
			end
		end

		local new_width = (EngBankConfig["maxColumns"]*EngBank_BUTTONFRAME_WIDTH) + (10*EngBankConfig["frameXSpace"]);
		local new_height;
		
		if (EngBankConfig["show_top_graphics"] == 1) then
			new_height = cur_y + EngBank_TOP_PADWINDOW;
		else
			new_height = cur_y;
		end

		frame:SetScale(EngBankConfig["frameWindowScale"]);
		frame:SetWidth( new_width );
		frame:SetHeight( new_height );

		frame:ClearAllPoints();
		frame:SetPoint(EngBankConfig["frameYRelativeTo"]..EngBankConfig["frameXRelativeTo"],
			"UIParent", "BOTTOMLEFT",
			EngBankConfig["frame"..EngBankConfig["frameXRelativeTo"]] / frame:GetScale(),
			EngBankConfig["frame"..EngBankConfig["frameYRelativeTo"]] / frame:GetScale());

		frame:SetBackdropColor(
			EngBankConfig["bar_colors_"..EngBank_MAINWINDOWCOLORIDX.."_background_r"],
			EngBankConfig["bar_colors_"..EngBank_MAINWINDOWCOLORIDX.."_background_g"],
			EngBankConfig["bar_colors_"..EngBank_MAINWINDOWCOLORIDX.."_background_b"],
			EngBankConfig["bar_colors_"..EngBank_MAINWINDOWCOLORIDX.."_background_a"] );
		frame:SetBackdropBorderColor(
			EngBankConfig["bar_colors_"..EngBank_MAINWINDOWCOLORIDX.."_border_r"],
			EngBankConfig["bar_colors_"..EngBank_MAINWINDOWCOLORIDX.."_border_g"],
			EngBankConfig["bar_colors_"..EngBank_MAINWINDOWCOLORIDX.."_border_b"],
			EngBankConfig["bar_colors_"..EngBank_MAINWINDOWCOLORIDX.."_border_a"] );

		EngBank_MoneyFrame:Show();


		if (EngBank_edit_mode == 1) then
			EngBank_Button_ColumnsAdd:SetText(EBLocal["EngBank_Button_ColumnsAdd_buttontitle"]);
			EngBank_Button_ColumnsAdd:Show();
			EngBank_Button_ColumnsDel:SetText(EBLocal["EngBank_Button_ColumnsDel_buttontitle"]);
			EngBank_Button_ColumnsDel:Show();
		else
			EngBank_Button_ColumnsAdd:Hide();
			EngBank_Button_ColumnsDel:Hide();
		end

		if (EngBankConfig["show_top_graphics"] == 1) then
			EngBank_Button_Close:Show();
			EngBank_Button_MoveLockToggle:Show();
			EngBank_Button_ChangeEditMode:Show();
			EngBank_Button_HighlightToggle:Show();

			EngBank_framePortrait:Show();
			EngBank_frameTextureTopLeft:Show();
			EngBank_frameTextureTopCenter:Show();
			EngBank_frameTextureTopRight:Show();
			EngBank_frameTextureLeft:Show();
--			EngBank_frameTextureCenter:Show();
			EngBank_frameTextureRight:Show();
			EngBank_frameTextureBottomLeft:Show();
			EngBank_frameTextureBottomCenter:Show();
			EngBank_frameTextureBottomRight:Show();

		else
			-- hide all the top graphics
			EngBank_Button_Close:Hide();
			EngBank_Button_MoveLockToggle:Hide();
			EngBank_Button_ChangeEditMode:Hide();
			EngBank_Button_HighlightToggle:Hide();

			EngBank_framePortrait:Hide();
			EngBank_frameTextureTopLeft:Hide();
			EngBank_frameTextureTopCenter:Hide();
			EngBank_frameTextureTopRight:Hide();
			EngBank_frameTextureLeft:Hide();
--			EngBank_frameTextureCenter:Hide();
			EngBank_frameTextureRight:Hide();
			EngBank_frameTextureBottomLeft:Hide();
			EngBank_frameTextureBottomCenter:Hide();
			EngBank_frameTextureBottomRight:Hide();
		end
	end

	EngBank_window_update_required = EngBank_NOTNEEDED;

        EngBank_WindowIsUpdating = 0;
end

