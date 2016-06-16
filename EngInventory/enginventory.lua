ENGINVENTORY_VERSION = "20050919";
--[[ Inventory replacement - By Engival of Shadowsong

 This mod is heavily inspired by AllInOneInventory. (basically learning how to script mods as AIOI as a base)

 Current Features:
 Sort your items into seperate sub-windows (known through the code as "bars").  automatically place 3 bars in a row, changeing the
 size dynamically.  Since placement is completely automatic, I figure it could get annoying when you move temporary stuff into
 your inventory.  (ex: take out your enchanting stuff to do something, then have to hunt for the items to put it back), so I've
 put a label on items that are "new" in your inventory.

Version history

 20050804 - Initial development - what the hell is this lua crap?  You call this a scripting language?  :(
 20050808 - It works!  Made 2nd design of UpdateWindow, and now I'm somewhat happy with how it looks.  Buttons work too.
 20050809 - Initial release on curse-gaming.  Bag bindings done, got auctioneer working.  Must be forgetting something...
 20050810 - Bug fixes
            - Fixed issue where bank bags were being overridden as well.
            - Added localization file, need translators now.
            - Changed auto-layout code a bit.  Should look a bit cleaner.
 20050811 - Buttons!  Close button, lock/unlock, Hilight New Items (actually gray out not-new items),
            Edit mode: Let's you move catagories arround just by clicking,  increase/decrease # of columns
	    Fixes to localization.
	    Added Roktarr's german translations.
 20050812 - Added right click menus (right click on main window, buttons, or numbered targets)
            Window position is now saved at scale 1.00, so if you change the scale of the window, the anchor point
	    won't move.  (saved window position will be trashed in the config file)
            /ei scale #.##
	    Hook for ToggleDropDownMenu() to fix popups from going off the screen.  I noticed that titan panel does this also,
	    but it shouldn't affect anything.
 20050818 - Fixed bug in EngInventory_NumericRange which would cause an error when a config value was out of range
 20050822 - oops, forgot to track my changes.  I'll try to write something here later.           
 20050822b - quick bug fix, problem with initilization of some fields
 20050919 - Added dressing room support
            Fixed bug/interface change in code that called lootlink
	    Added some code to see if some "putinslot" values aren't assigned to a bar
	    Added options to add/remove hooks for specific bags
	    Added a keybinding to toggle bags
            Created hooks for AxuItemMenus.  For the current version, I'll be calling AxuItemMenus directly.  If the author wants
            to support EngInventory, and has a need to change things, he can define ENGINVENTORY_DONT_CALL_AXUITEM, and a hook
	    function named AxuItemMenus_EngInventoryHook(bag,slot) which will be called in my handler.  If he returns a value of
	    1 from that hook, my handler will do a return right away.
	    *** note, I won't call dressing room functions if AuxItemMenu is hooked
 20060329 - Updated TOC for 1.10
            Fixed bug with gametooltip changes in 1.10
            Integrated changes from the modified version of EngInventory posted on auctioneer's site
	    Fixed error with hunter training window


Credits
-------

Roktarr
	- German localization!
Sarf of AllInOneInventory
	- Used AIOI as a learning base, and some pieces of code have been completely cut'n'pasted.
Lozareth of Discord Action Bars
	- Ripped your font and learned how to make a big number inside a button
Everyone on Curse-gaming
	- Excellent feedback and suggestions


Notes to self

 Why does AIOI hook the following functions:
  SellValue_OnShow
  UseContainerItem


Todo   ***** UPDATE THIS LATER *****

 general

  Add BAG's to the window for people who hide their default art

  Create a quick bar for new items



 enginventory.lua
  --


 tooltip.lua
  --


function list  (this is my quick navigation using find)

** need to rebuild this

--]]


-- Constants
ENGINVENTORY_DEBUGMESSAGES = 0;         -- 0 = off, 1 = on
ENGINVENTORY_SHOWITEMDEBUGINFO = 1;
ENGINVENTORY_WIPECONFIGONLOAD = 0;	-- for debugging, test it out on a new config every load


ENGINVENTORY_MAX_BARS = 15;

BINDING_HEADER_ENGINVENTORY = "EngInventory "..ENGINVENTORY_VERSION;
BINDING_NAME_EI_TOGGLE = "Toggle Inventory Window";

ENGINVENTORY_MAXBUTTONS = 109;
ENGINVENTORY_BUTTONFRAME_X_PADDING = 2;
ENGINVENTORY_BUTTONFRAME_BUTTONWIDTH = 30;
ENGINVENTORY_BUTTONFRAME_WIDTH = ENGINVENTORY_BUTTONFRAME_BUTTONWIDTH + (ENGINVENTORY_BUTTONFRAME_X_PADDING*2);
ENGINVENTORY_BUTTONFRAME_Y_PADDING = 1;
ENGINVENTORY_BUTTONFRAME_BUTTONHEIGHT = 30;
ENGINVENTORY_BUTTONFONTHEIGHT = 0.35 * ENGINVENTORY_BUTTONFRAME_BUTTONHEIGHT;
ENGINVENTORY_BUTTONFRAME_HEIGHT = ENGINVENTORY_BUTTONFRAME_BUTTONHEIGHT + (ENGINVENTORY_BUTTONFRAME_Y_PADDING*2);
ENGINVENTORY_BKGRFRAME_WIDTH = ENGINVENTORY_BUTTONFRAME_BUTTONWIDTH * 1.6;  -- 40 -> 64
ENGINVENTORY_BKGRFRAME_HEIGHT = ENGINVENTORY_BUTTONFRAME_BUTTONHEIGHT * 1.6;
ENGINVENTORY_COOLDOWN_SCALE = 0.85;
ENGINVENTORY_TOP_PADWINDOW = 25;

ENGINVENTORY_SORTLOWESTVALUE = 0;
ENGINVENTORY_NOSORT = 0;
ENGINVENTORY_SORTBYNAME = 1;
ENGINVENTORY_SORTBYNAMEREV = 2; -- reverses the name then sorts it:  ie:   "Potion Mana Major" vs "Major Mana Potion"
ENGINVENTORY_SORTHIGHESTVALUE = 2;

ENGINVENTORY_MAXCOLUMNS_MAX = 20;
ENGINVENTORY_MAXCOLUMNS_MIN = 8;

ENGINVENTORY_BUTTONSIZE_MIN = 25;
ENGINVENTORY_BUTTONSIZE_MAX = 50;

ENGINVENTORY_FONTSIZE_MIN = 8;
ENGINVENTORY_FONTSIZE_MAX = 20;

ENGINVENTORY_MAINWINDOWCOLORIDX = 17;

EngInventory_ShowPrice = 1;     -- ???

ENGINVENTORY_WINDOWBOTTOMPADDING_EDITMODE = 25;
ENGINVENTORY_WINDOWBOTTOMPADDING_NORMALMODE = 0;

EngInventory_WindowBottomPadding = ENGINVENTORY_WINDOWBOTTOMPADDING_NORMALMODE;

--[[ New data layout:

	bar, position = refers to the virtual locations
	bagnum, slotnum = refers to physical bag/slot

	EngInventory_item_cache[ bag ][ bag_slot ]
		- Contains all the data we collect from the items in the bags.
		- We collect this data before sorting!
	EngInventory_bar_positions[ bar_number ][ position ] = { ["bagnum"]=bagnum, ["slotnum"]=slotnum }
		- Contains the final locations in my window after sorting
	EngInventory_buttons[ frame_name ] = { ["bagnum"]=bagnum, ["slotnum"]=slotnum }
--]]

EngInventory_item_cache = { {}, {}, {}, {}, {} };	-- cache of all the items as they appear in bags
EngInventory_bar_positions = {};
--EngInventory_inventory_cache = {};	-- old cacheing system, remove all traces of it from the code!
EngInventory_buttons = {};
EngInventory_hilight_new = 0;
EngInventory_edit_mode = 0;
EngInventory_edit_hilight = "";         -- when editmode is 1, which items do you want to hilight
EngInventory_edit_selected = "";        -- when editmode is 1, this is the class of item you clicked on
EngInventory_RightClickMenu_mode = "";
EngInventory_RightClickMenu_opts = {};

ENGINVENTORY_NOTNEEDED = 0;	-- when items haven't changed, or only item counts
ENGINVENTORY_REQUIRED = 1;	-- when items have changed location, but it's been sorted once and won't break if we don't sort again
ENGINVENTORY_MANDATORY = 2;	-- it's never been sorted, the window is in an unstable state, you MUST sort.

EngInventory_resort_required = ENGINVENTORY_MANDATORY;
EngInventory_window_update_required = ENGINVENTORY_MANDATORY;

EngInventory_BuildTradeList = {};	-- only build a full list of trade skill info once

-- These are catagories to leave off the right click menu.  just trying to make space
--	** not needed anymore, since I created a 3rd level of the dropdown
--[[ EngInventory_Catagories_Exclude_List = {
	["BANDAGES"] = 1,
	["EMPTY_PROJECTILE_SLOTS"] = 1,
	["EMPTY_SLOTS"] = 1,
	["HEALTHSTONE"] = 1,
	["JUJU"] = 1
	}; --]]
EngInventory_Catagories_Exclude_List = {};
------------------------

EngInventory_ConfigOptions_Default = {
	{
		{ ["type"] = "Text", ["ID"] = 1, ["width"] = 1.0, ["color"] = { 1,0,0.25 }, ["align"] = "center",
		  ["text"] = "Window Options" },
	},
	{},	---------------------------------------------------------------------------------------
	{	-- Window Scale
		{ ["type"] = "Text", ["ID"] = 1, ["width"] = 0.4, ["color"] = { 1,1,0.25 }, ["text"] = "Window Scale:" },
		{ ["type"] = "Text", ["ID"] = 2, ["width"] = 0.1, ["color"] = { 0,1,0.5 }, ["align"] = "right", ["text"] = "0.64" },
		{ ["type"] = "Slider", ["ID"] = 1, ["width"] = 0.4, ["minValue"] = 0.64, ["maxValue"] = 1.00, ["valueStep"] = 0.01,
		  ["defaultValue"] = function()
				return EngInventoryConfig["frameWindowScale"];
			end,
		  ["func"] = function(v)
				EngInventoryConfig["frameWindowScale"] = tonumber(v);
				EngInventory_SetDefaultValues(0);
				EngInventory_window_update_required = ENGINVENTORY_MANDATORY;
				EngInventory_UpdateWindow();
			end
		},
		{ ["type"] = "Text", ["ID"] = 3, ["width"] = 0.1, ["color"] = { 0,1,0.5 }, ["align"] = "left", ["text"] = "1.00" }
	},

	{	-- Window Columns
		{ ["type"] = "Text", ["ID"] = 1, ["width"] = 0.4, ["color"] = { 1,1,0.25 }, ["text"] = "Columns:" },
		{ ["type"] = "Text", ["ID"] = 2, ["width"] = 0.1, ["color"] = { 0,1,0.5 }, ["align"] = "right", ["text"] = ENGINVENTORY_MAXCOLUMNS_MIN },
		{ ["type"] = "Slider", ["ID"] = 1, ["width"] = 0.4, ["minValue"] = ENGINVENTORY_MAXCOLUMNS_MIN, ["maxValue"] = ENGINVENTORY_MAXCOLUMNS_MAX, ["valueStep"] = 1,
		  ["defaultValue"] = function()
				return EngInventoryConfig["maxColumns"];
			end,
		  ["func"] = function(v)
				EngInventoryConfig["maxColumns"] = tonumber(v);
				EngInventory_SetDefaultValues(0);
				EngInventory_window_update_required = ENGINVENTORY_MANDATORY;
				EngInventory_UpdateWindow();
			end
		},
		{ ["type"] = "Text", ["ID"] = 3, ["width"] = 0.1, ["color"] = { 0,1,0.5 }, ["align"] = "left", ["text"] = ENGINVENTORY_MAXCOLUMNS_MAX }
	},

	{	-- Button Size
		{ ["type"] = "Text", ["ID"] = 1, ["width"] = 0.4, ["color"] = { 1,1,0.25 }, ["text"] = "Button Size:" },
		{ ["type"] = "Text", ["ID"] = 2, ["width"] = 0.1, ["color"] = { 0,1,0.5 }, ["align"] = "right", ["text"] = ENGINVENTORY_BUTTONSIZE_MIN },
		{ ["type"] = "Slider", ["ID"] = 1, ["width"] = 0.4, ["minValue"] = ENGINVENTORY_BUTTONSIZE_MIN, ["maxValue"] = ENGINVENTORY_BUTTONSIZE_MAX, ["valueStep"] = 1,
		  ["defaultValue"] = function()
				return EngInventoryConfig["frameButtonSize"];
			end,
		  ["func"] = function(v)
				EngInventoryConfig["frameButtonSize"] = tonumber(v);
				EngInventory_SetDefaultValues(0);
				EngInventory_window_update_required = ENGINVENTORY_MANDATORY;
				EngInventory_UpdateWindow();
			end
		},
		{ ["type"] = "Text", ["ID"] = 3, ["width"] = 0.1, ["color"] = { 0,1,0.5 }, ["align"] = "left", ["text"] = ENGINVENTORY_BUTTONSIZE_MAX }
	},

	{	-- Font Size / item count
		{ ["type"] = "Text", ["ID"] = 1, ["width"] = 0.4, ["color"] = { 1,1,0.25 }, ["text"] = "Item count font size:" },
		{ ["type"] = "Text", ["ID"] = 2, ["width"] = 0.1, ["color"] = { 0,1,0.5 }, ["align"] = "right", ["text"] = ENGINVENTORY_FONTSIZE_MIN },
		{ ["type"] = "Slider", ["ID"] = 1, ["width"] = 0.4, ["minValue"] = ENGINVENTORY_FONTSIZE_MIN, ["maxValue"] = ENGINVENTORY_FONTSIZE_MAX, ["valueStep"] = 1,
		  ["defaultValue"] = function()
				return EngInventoryConfig["button_size_opts"]["ENGINVENTORY_BUTTONFONTHEIGHT"];
			end,
		  ["func"] = function(v)
				EngInventoryConfig["button_size_opts"]["ENGINVENTORY_BUTTONFONTHEIGHT"] = tonumber(v);
				EngInventory_SetDefaultValues(0);
				EngInventory_window_update_required = ENGINVENTORY_MANDATORY;
				EngInventory_UpdateWindow();
			end
		},
		{ ["type"] = "Text", ["ID"] = 3, ["width"] = 0.1, ["color"] = { 0,1,0.5 }, ["align"] = "left", ["text"] = ENGINVENTORY_FONTSIZE_MAX }
	},

	{	-- Font Size / New text
		{ ["type"] = "Text", ["ID"] = 1, ["width"] = 0.4, ["color"] = { 1,1,0.25 }, ["text"] = "New tag font size:" },
		{ ["type"] = "Text", ["ID"] = 2, ["width"] = 0.1, ["color"] = { 0,1,0.5 }, ["align"] = "right", ["text"] = ENGINVENTORY_FONTSIZE_MIN },
		{ ["type"] = "Slider", ["ID"] = 1, ["width"] = 0.4, ["minValue"] = ENGINVENTORY_FONTSIZE_MIN, ["maxValue"] = ENGINVENTORY_FONTSIZE_MAX, ["valueStep"] = 1,
		  ["defaultValue"] = function()
				return EngInventoryConfig["button_size_opts"]["ENGINVENTORY_BUTTONFONTHEIGHT2"];
			end,
		  ["func"] = function(v)
				EngInventoryConfig["button_size_opts"]["ENGINVENTORY_BUTTONFONTHEIGHT2"] = tonumber(v);
				EngInventory_SetDefaultValues(0);
				EngInventory_window_update_required = ENGINVENTORY_MANDATORY;
				EngInventory_UpdateWindow();
			end
		},
		{ ["type"] = "Text", ["ID"] = 3, ["width"] = 0.1, ["color"] = { 0,1,0.5 }, ["align"] = "left", ["text"] = ENGINVENTORY_FONTSIZE_MAX }
	},

	{	-- Font alignment / X
		{ ["type"] = "Text", ["ID"] = 1, ["width"] = 0.4, ["color"] = { 1,1,0.25 }, ["text"] = "Font position - X:" },
		{ ["type"] = "Text", ["ID"] = 2, ["width"] = 0.1, ["color"] = { 0,1,0.5 }, ["align"] = "right", ["text"] = 0 },
		{ ["type"] = "Slider", ["ID"] = 1, ["width"] = 0.4, ["minValue"] = 0, ["maxValue"] = 10, ["valueStep"] = 1,
		  ["defaultValue"] = function()
				return EngInventoryConfig["button_size_opts"]["ENGINVENTORY_BUTTONFONTDISTANCE_X"];
			end,
		  ["func"] = function(v)
				EngInventoryConfig["button_size_opts"]["ENGINVENTORY_BUTTONFONTDISTANCE_X"] = tonumber(v);
				EngInventory_SetDefaultValues(0);
				EngInventory_window_update_required = ENGINVENTORY_MANDATORY;
				EngInventory_UpdateWindow();
			end
		},
		{ ["type"] = "Text", ["ID"] = 3, ["width"] = 0.1, ["color"] = { 0,1,0.5 }, ["align"] = "left", ["text"] = 10 }
	},

	{	-- Font alignment / Y
		{ ["type"] = "Text", ["ID"] = 1, ["width"] = 0.4, ["color"] = { 1,1,0.25 }, ["text"] = "Font position - Y:" },
		{ ["type"] = "Text", ["ID"] = 2, ["width"] = 0.1, ["color"] = { 0,1,0.5 }, ["align"] = "right", ["text"] = 0 },
		{ ["type"] = "Slider", ["ID"] = 1, ["width"] = 0.4, ["minValue"] = 0, ["maxValue"] = 10, ["valueStep"] = 1,
		  ["defaultValue"] = function()
				return EngInventoryConfig["button_size_opts"]["ENGINVENTORY_BUTTONFONTDISTANCE_Y"];
			end,
		  ["func"] = function(v)
				EngInventoryConfig["button_size_opts"]["ENGINVENTORY_BUTTONFONTDISTANCE_Y"] = tonumber(v);
				EngInventory_SetDefaultValues(0);
				EngInventory_window_update_required = ENGINVENTORY_MANDATORY;
				EngInventory_UpdateWindow();
			end
		},
		{ ["type"] = "Text", ["ID"] = 3, ["width"] = 0.1, ["color"] = { 0,1,0.5 }, ["align"] = "left", ["text"] = 10 }
	},

	{	-- Frame spacing / X
		{ ["type"] = "Text", ["ID"] = 1, ["width"] = 0.4, ["color"] = { 1,1,0.25 }, ["text"] = "Frame spacing - X:" },
		{ ["type"] = "Text", ["ID"] = 2, ["width"] = 0.1, ["color"] = { 0,1,0.5 }, ["align"] = "right", ["text"] = 0 },
		{ ["type"] = "Slider", ["ID"] = 1, ["width"] = 0.4, ["minValue"] = 0, ["maxValue"] = 10, ["valueStep"] = 1,
		  ["defaultValue"] = function()
				return EngInventoryConfig["frameXSpace"];
			end,
		  ["func"] = function(v)
				EngInventoryConfig["frameXSpace"] = tonumber(v);
				EngInventory_SetDefaultValues(0);
				EngInventory_window_update_required = ENGINVENTORY_MANDATORY;
				EngInventory_UpdateWindow();
			end
		},
		{ ["type"] = "Text", ["ID"] = 3, ["width"] = 0.1, ["color"] = { 0,1,0.5 }, ["align"] = "left", ["text"] = 10 }
	},

	{	-- Frame spacing / Y
		{ ["type"] = "Text", ["ID"] = 1, ["width"] = 0.4, ["color"] = { 1,1,0.25 }, ["text"] = "Frame spacing - Y:" },
		{ ["type"] = "Text", ["ID"] = 2, ["width"] = 0.1, ["color"] = { 0,1,0.5 }, ["align"] = "right", ["text"] = 0 },
		{ ["type"] = "Slider", ["ID"] = 1, ["width"] = 0.4, ["minValue"] = 0, ["maxValue"] = 10, ["valueStep"] = 1,
		  ["defaultValue"] = function()
				return EngInventoryConfig["frameYSpace"];
			end,
		  ["func"] = function(v)
				EngInventoryConfig["frameYSpace"] = tonumber(v);
				EngInventory_SetDefaultValues(0);
				EngInventory_window_update_required = ENGINVENTORY_MANDATORY;
				EngInventory_UpdateWindow();
			end
		},
		{ ["type"] = "Text", ["ID"] = 3, ["width"] = 0.1, ["color"] = { 0,1,0.5 }, ["align"] = "left", ["text"] = 10 }
	},

	{},	---------------------------------------------------------------------------------------
	{
		{ ["type"] = "Text", ["ID"] = 1, ["width"] = 1.0, ["color"] = { 1,0,0.25 }, ["align"] = "center",
		  ["text"] = "Display Strings & New Item Settings" },
	},
	{},	---------------------------------------------------------------------------------------
	{	-- "New" Text
		{ ["type"] = "Text", ["ID"] = 1, ["width"] = 0.5, ["color"] = { 1,1,0.25 },
		  ["text"] = "New item text:" },
		{ ["type"] = "Edit", ["ID"] = 1, ["width"] = 0.2, ["letters"]=10,
		  ["defaultValue"] = function()
				return EngInventoryConfig["newItemText"];
			end,
		  ["func"] = function(v)
				EngInventoryConfig["newItemText"] = v;
				EngInventory_window_update_required = ENGINVENTORY_MANDATORY;
				EngInventory_UpdateWindow();
			end
		},
	},
	{	-- Item count increased text
		{ ["type"] = "Text", ["ID"] = 1, ["width"] = 0.5, ["color"] = { 1,1,0.25 },
		  ["text"] = "Item count increased:" },
		{ ["type"] = "Edit", ["ID"] = 1, ["width"] = 0.2, ["letters"]=10,
		  ["defaultValue"] = function()
				return EngInventoryConfig["newItemTextPlus"];
			end,
		  ["func"] = function(v)
				EngInventoryConfig["newItemTextPlus"] = v;
				EngInventory_window_update_required = ENGINVENTORY_MANDATORY;
				EngInventory_UpdateWindow();
			end
		},
	},
	{	-- Item count decreased text
		{ ["type"] = "Text", ["ID"] = 1, ["width"] = 0.5, ["color"] = { 1,1,0.25 },
		  ["text"] = "Item count decreased:" },
		{ ["type"] = "Edit", ["ID"] = 1, ["width"] = 0.2, ["letters"]=10,
		  ["defaultValue"] = function()
				return EngInventoryConfig["newItemTextMinus"];
			end,
		  ["func"] = function(v)
				EngInventoryConfig["newItemTextMinus"] = v;
				EngInventory_window_update_required = ENGINVENTORY_MANDATORY;
				EngInventory_UpdateWindow();
			end
		},
	},
	{	-- New Tag timing
		{ ["type"] = "Text", ["ID"] = 1, ["width"] = 0.5, ["color"] = { 1,1,0.25 }, ["text"] = "Timeout for new tag - older (Minutes):" },
		{ ["type"] = "Slider", ["ID"] = 1, ["width"] = 0.5, ["minValue"] = 0, ["maxValue"] = 60*6, ["valueStep"] = 1,
		  ["defaultValue"] = function()
				return ceil(EngInventoryConfig["newItemTimeout"] / 60);
			end,
		  ["func"] = function(v)
				EngInventoryConfig["newItemTimeout"] = tonumber(v) * 60;
				EngInventory_SetDefaultValues(0);
				EngInventory_window_update_required = ENGINVENTORY_MANDATORY;
				EngInventory_UpdateWindow();
			end
		}
	},
	{	-- New Tag timing
		{ ["type"] = "Text", ["ID"] = 1, ["width"] = 0.5, ["color"] = { 1,1,0.25 }, ["text"] = "Timeout for new tag - newer (Minutes):" },
		{ ["type"] = "Slider", ["ID"] = 1, ["width"] = 0.5, ["minValue"] = 0, ["maxValue"] = 60*1, ["valueStep"] = 1,
		  ["defaultValue"] = function()
				return ceil(EngInventoryConfig["newItemTimeout2"] / 60);
			end,
		  ["func"] = function(v)
				EngInventoryConfig["newItemTimeout2"] = tonumber(v) * 60;
				EngInventory_SetDefaultValues(0);
				EngInventory_window_update_required = ENGINVENTORY_MANDATORY;
				EngInventory_UpdateWindow();
			end
		}
	},


	{},	---------------------------------------------------------------------------------------
	{
		{ ["type"] = "Text", ["ID"] = 1, ["width"] = 1.0, ["color"] = { 1,0,0.25 }, ["align"] = "center",
		  ["text"] = "Bag Hooks" },
	},
	{},	---------------------------------------------------------------------------------------
	{	-- Hook "Open All Bags"
		{ ["type"] = "Text", ["ID"] = 1, ["width"] = 0.4, ["color"] = { 1,1,0.25 }, ["text"] = "Open all bags:" },
		{ ["type"] = "Text", ["ID"] = 2, ["width"] = 0.1, ["color"] = { 0,1,0.5 }, ["align"] = "right", ["text"] = "Off" },
		{ ["type"] = "Slider", ["ID"] = 1, ["width"] = 0.4, ["minValue"] = 0, ["maxValue"] = 1, ["valueStep"] = 1,
		  ["defaultValue"] = function()
				return EngInventoryConfig["hook_OpenAllBags"];
			end,
		  ["func"] = function(v)
				EngInventoryConfig["hook_OpenAllBags"] = tonumber(v);
				EngInventory_SetDefaultValues(0);
			end
		},
		{ ["type"] = "Text", ["ID"] = 3, ["width"] = 0.1, ["color"] = { 0,1,0.5 }, ["align"] = "left", ["text"] = "On" }
	},
	{	-- Hook "Backpack"
		{ ["type"] = "Text", ["ID"] = 1, ["width"] = 0.4, ["color"] = { 1,1,0.25 }, ["text"] = "Backpack:" },
		{ ["type"] = "Text", ["ID"] = 2, ["width"] = 0.1, ["color"] = { 0,1,0.5 }, ["align"] = "right", ["text"] = "Off" },
		{ ["type"] = "Slider", ["ID"] = 1, ["width"] = 0.4, ["minValue"] = 0, ["maxValue"] = 1, ["valueStep"] = 1,
		  ["defaultValue"] = function()
				return EngInventoryConfig["hook_Bag0"];
			end,
		  ["func"] = function(v)
				EngInventoryConfig["hook_Bag0"] = tonumber(v);
				EngInventory_SetDefaultValues(0);
			end
		},
		{ ["type"] = "Text", ["ID"] = 3, ["width"] = 0.1, ["color"] = { 0,1,0.5 }, ["align"] = "left", ["text"] = "On" }
	},
	{	-- Hook "Bag 1"
		{ ["type"] = "Text", ["ID"] = 1, ["width"] = 0.4, ["color"] = { 1,1,0.25 }, ["text"] = "Bag 1:" },
		{ ["type"] = "Text", ["ID"] = 2, ["width"] = 0.1, ["color"] = { 0,1,0.5 }, ["align"] = "right", ["text"] = "Off" },
		{ ["type"] = "Slider", ["ID"] = 1, ["width"] = 0.4, ["minValue"] = 0, ["maxValue"] = 1, ["valueStep"] = 1,
		  ["defaultValue"] = function()
				return EngInventoryConfig["hook_Bag1"];
			end,
		  ["func"] = function(v)
				EngInventoryConfig["hook_Bag1"] = tonumber(v);
				EngInventory_SetDefaultValues(0);
			end
		},
		{ ["type"] = "Text", ["ID"] = 3, ["width"] = 0.1, ["color"] = { 0,1,0.5 }, ["align"] = "left", ["text"] = "On" }
	},
	{	-- Hook "Bag 2"
		{ ["type"] = "Text", ["ID"] = 1, ["width"] = 0.4, ["color"] = { 1,1,0.25 }, ["text"] = "Bag 2:" },
		{ ["type"] = "Text", ["ID"] = 2, ["width"] = 0.1, ["color"] = { 0,1,0.5 }, ["align"] = "right", ["text"] = "Off" },
		{ ["type"] = "Slider", ["ID"] = 1, ["width"] = 0.4, ["minValue"] = 0, ["maxValue"] = 1, ["valueStep"] = 1,
		  ["defaultValue"] = function()
				return EngInventoryConfig["hook_Bag2"];
			end,
		  ["func"] = function(v)
				EngInventoryConfig["hook_Bag2"] = tonumber(v);
				EngInventory_SetDefaultValues(0);
			end
		},
		{ ["type"] = "Text", ["ID"] = 3, ["width"] = 0.1, ["color"] = { 0,1,0.5 }, ["align"] = "left", ["text"] = "On" }
	},
	{	-- Hook "Bag 3"
		{ ["type"] = "Text", ["ID"] = 1, ["width"] = 0.4, ["color"] = { 1,1,0.25 }, ["text"] = "Bag 3:" },
		{ ["type"] = "Text", ["ID"] = 2, ["width"] = 0.1, ["color"] = { 0,1,0.5 }, ["align"] = "right", ["text"] = "Off" },
		{ ["type"] = "Slider", ["ID"] = 1, ["width"] = 0.4, ["minValue"] = 0, ["maxValue"] = 1, ["valueStep"] = 1,
		  ["defaultValue"] = function()
				return EngInventoryConfig["hook_Bag3"];
			end,
		  ["func"] = function(v)
				EngInventoryConfig["hook_Bag3"] = tonumber(v);
				EngInventory_SetDefaultValues(0);
			end
		},
		{ ["type"] = "Text", ["ID"] = 3, ["width"] = 0.1, ["color"] = { 0,1,0.5 }, ["align"] = "left", ["text"] = "On" }
	},
	{	-- Hook "Bag 4"
		{ ["type"] = "Text", ["ID"] = 1, ["width"] = 0.4, ["color"] = { 1,1,0.25 }, ["text"] = "Bag 4:" },
		{ ["type"] = "Text", ["ID"] = 2, ["width"] = 0.1, ["color"] = { 0,1,0.5 }, ["align"] = "right", ["text"] = "Off" },
		{ ["type"] = "Slider", ["ID"] = 1, ["width"] = 0.4, ["minValue"] = 0, ["maxValue"] = 1, ["valueStep"] = 1,
		  ["defaultValue"] = function()
				return EngInventoryConfig["hook_Bag4"];
			end,
		  ["func"] = function(v)
				EngInventoryConfig["hook_Bag4"] = tonumber(v);
				EngInventory_SetDefaultValues(0);
			end
		},
		{ ["type"] = "Text", ["ID"] = 3, ["width"] = 0.1, ["color"] = { 0,1,0.5 }, ["align"] = "left", ["text"] = "On" }
	},


	{	-- Show "Backpack"
		{ ["type"] = "Text", ["ID"] = 1, ["width"] = 0.4, ["color"] = { 1,1,0.25 }, ["text"] = "Include Backpack Contents:" },
		{ ["type"] = "Text", ["ID"] = 2, ["width"] = 0.1, ["color"] = { 0,1,0.5 }, ["align"] = "right", ["text"] = "Off" },
		{ ["type"] = "Slider", ["ID"] = 1, ["width"] = 0.4, ["minValue"] = 0, ["maxValue"] = 1, ["valueStep"] = 1,
		  ["defaultValue"] = function()
				return EngInventoryConfig["show_Bag0"];
			end,
		  ["func"] = function(v)
				EngInventoryConfig["show_Bag0"] = tonumber(v);
				EngInventory_SetDefaultValues(0);
			end
		},
		{ ["type"] = "Text", ["ID"] = 3, ["width"] = 0.1, ["color"] = { 0,1,0.5 }, ["align"] = "left", ["text"] = "On" }
	},
	{	-- Show "Bag 1"
		{ ["type"] = "Text", ["ID"] = 1, ["width"] = 0.4, ["color"] = { 1,1,0.25 }, ["text"] = "Include Bag 1 Contents:" },
		{ ["type"] = "Text", ["ID"] = 2, ["width"] = 0.1, ["color"] = { 0,1,0.5 }, ["align"] = "right", ["text"] = "Off" },
		{ ["type"] = "Slider", ["ID"] = 1, ["width"] = 0.4, ["minValue"] = 0, ["maxValue"] = 1, ["valueStep"] = 1,
		  ["defaultValue"] = function()
				return EngInventoryConfig["show_Bag1"];
			end,
		  ["func"] = function(v)
				EngInventoryConfig["show_Bag1"] = tonumber(v);
				EngInventory_SetDefaultValues(0);
			end
		},
		{ ["type"] = "Text", ["ID"] = 3, ["width"] = 0.1, ["color"] = { 0,1,0.5 }, ["align"] = "left", ["text"] = "On" }
	},
	{	-- Show "Bag 2"
		{ ["type"] = "Text", ["ID"] = 1, ["width"] = 0.4, ["color"] = { 1,1,0.25 }, ["text"] = "Include Bag 2 Contents:" },
		{ ["type"] = "Text", ["ID"] = 2, ["width"] = 0.1, ["color"] = { 0,1,0.5 }, ["align"] = "right", ["text"] = "Off" },
		{ ["type"] = "Slider", ["ID"] = 1, ["width"] = 0.4, ["minValue"] = 0, ["maxValue"] = 1, ["valueStep"] = 1,
		  ["defaultValue"] = function()
				return EngInventoryConfig["show_Bag2"];
			end,
		  ["func"] = function(v)
				EngInventoryConfig["show_Bag2"] = tonumber(v);
				EngInventory_SetDefaultValues(0);
			end
		},
		{ ["type"] = "Text", ["ID"] = 3, ["width"] = 0.1, ["color"] = { 0,1,0.5 }, ["align"] = "left", ["text"] = "On" }
	},
	{	-- Show "Bag 3"
		{ ["type"] = "Text", ["ID"] = 1, ["width"] = 0.4, ["color"] = { 1,1,0.25 }, ["text"] = "Include Bag 3 Contents:" },
		{ ["type"] = "Text", ["ID"] = 2, ["width"] = 0.1, ["color"] = { 0,1,0.5 }, ["align"] = "right", ["text"] = "Off" },
		{ ["type"] = "Slider", ["ID"] = 1, ["width"] = 0.4, ["minValue"] = 0, ["maxValue"] = 1, ["valueStep"] = 1,
		  ["defaultValue"] = function()
				return EngInventoryConfig["show_Bag3"];
			end,
		  ["func"] = function(v)
				EngInventoryConfig["show_Bag3"] = tonumber(v);
				EngInventory_SetDefaultValues(0);
			end
		},
		{ ["type"] = "Text", ["ID"] = 3, ["width"] = 0.1, ["color"] = { 0,1,0.5 }, ["align"] = "left", ["text"] = "On" }
	},
	{	-- Show "Bag 4"
		{ ["type"] = "Text", ["ID"] = 1, ["width"] = 0.4, ["color"] = { 1,1,0.25 }, ["text"] = "Include Bag 4 Contents:" },
		{ ["type"] = "Text", ["ID"] = 2, ["width"] = 0.1, ["color"] = { 0,1,0.5 }, ["align"] = "right", ["text"] = "Off" },
		{ ["type"] = "Slider", ["ID"] = 1, ["width"] = 0.4, ["minValue"] = 0, ["maxValue"] = 1, ["valueStep"] = 1,
		  ["defaultValue"] = function()
				return EngInventoryConfig["show_Bag4"];
			end,
		  ["func"] = function(v)
				EngInventoryConfig["show_Bag4"] = tonumber(v);
				EngInventory_SetDefaultValues(0);
			end
		},
		{ ["type"] = "Text", ["ID"] = 3, ["width"] = 0.1, ["color"] = { 0,1,0.5 }, ["align"] = "left", ["text"] = "On" }
	},


	{},	---------------------------------------------------------------------------------------
	{
		{ ["type"] = "Text", ["ID"] = 1, ["width"] = 1.0, ["color"] = { 1,0,0.25 }, ["align"] = "center",
		  ["text"] = "Misc Options" },
	},
	{},	---------------------------------------------------------------------------------------
	{	-- Build trade skill list for export
		{ ["type"] = "Text", ["ID"] = 1, ["width"] = 0.4, ["color"] = { 1,1,0.25 }, ["text"] = "Build trade skill list for export:" },
		{ ["type"] = "Text", ["ID"] = 2, ["width"] = 0.1, ["color"] = { 0,1,0.5 }, ["align"] = "right", ["text"] = "Off" },
		{ ["type"] = "Slider", ["ID"] = 1, ["width"] = 0.4, ["minValue"] = 0, ["maxValue"] = 1, ["valueStep"] = 1,
		  ["defaultValue"] = function()
				return EngInventoryConfig["build_trade_list"];
			end,
		  ["func"] = function(v)
				EngInventoryConfig["build_trade_list"] = tonumber(v);
			end
		},
		{ ["type"] = "Text", ["ID"] = 3, ["width"] = 0.1, ["color"] = { 0,1,0.5 }, ["align"] = "left", ["text"] = "On" }
	},


	{},	---------------------------------------------------------------------------------------
	{
		{ ["type"] = "Text", ["ID"] = 1, ["width"] = 1.0, ["color"] = { 1,0,0.25 }, ["align"] = "center",
		  ["text"] = "Item Search and Assignment" },
	},
	{},	---------------------------------------------------------------------------------------
	{
		{ ["type"] = "Text", ["ID"] = 1, ["width"] = 0.025+0.025+0.025 + 0.005, ["color"] = { 1,0,0.25 }, ["text"] = "" },
		{ ["type"] = "Text", ["ID"] = 2, ["width"] = 0.20, ["color"] = { 1,0,0.25 }, ["text"] = "Catagory" },
		{ ["type"] = "Text", ["ID"] = 3, ["width"] = 0.20, ["color"] = { 1,0,0.25 }, ["text"] = "Keywords" },
		{ ["type"] = "Text", ["ID"] = 4, ["width"] = 0.35, ["color"] = { 1,0,0.25 }, ["text"] = "Tooltip Search" },
		{ ["type"] = "Text", ["ID"] = 5, ["width"] = 0.170, ["color"] = { 1,0,0.25 }, ["text"] = "ItemType" }
	}
};

EngInventory_ConfigOptions = EngInventory_ConfigOptions_Default;

function EngInventory_Config_GetItemSearchList(key, idx)
	return EngInventoryConfig["item_search_list"][key][idx]
end
function EngInventory_Config_AssignItemSearchList(v, key, idx)
	if (key ~= nil) then
		EngInventoryConfig["item_search_list"][key][idx] = v;
	end
end

function EngInventory_Config_GetItemSearchListLower(key, idx)
	return string.lower(EngInventoryConfig["item_search_list"][key][idx]);
end
function EngInventory_Config_AssignItemSearchListUpper(v, key, idx)
	if (key ~= nil) then
		EngInventoryConfig["item_search_list"][key][idx] = string.upper(v);
	end
end

function EngInventory_Config_SwapSearchListItems(unused_value, key1, key2)
	local tmp;

	if ( (EngInventoryConfig["item_search_list"][key1] ~= nil) and (EngInventoryConfig["item_search_list"][key2] ~= nil) ) then
		tmp = EngInventoryConfig["item_search_list"][key1];
		EngInventoryConfig["item_search_list"][key1] = EngInventoryConfig["item_search_list"][key2];
		EngInventoryConfig["item_search_list"][key2] = tmp;

		if (key1 > key2) then
			EngInventory_Opts_CurrentPosition = EngInventory_Opts_CurrentPosition - 1;
		else
			EngInventory_Opts_CurrentPosition = EngInventory_Opts_CurrentPosition + 1;
		end

		EngInventory_Options_UpdateWindow();
	end
end

function EngInventory_CreateConfigOptions()
	local key,value;

	EngInventory_ConfigOptions = EngInventory_ConfigOptions_Default;

	for key,value in EngInventoryConfig["item_search_list"] do
		table.insert( EngInventory_ConfigOptions,
			{
{ ["type"] = "Text", ["ID"] = 1, ["width"] = 0.025, ["color"] = { 1,0,1 }, ["text"] = key.."." },
{ ["type"] = "UpButton", ["ID"] = 1, ["width"] = 0.025,
  ["param1"] = key, ["param2"] = key-1,
  ["func"] = EngInventory_Config_SwapSearchListItems
},
{ ["type"] = "DownButton", ["ID"] = 1, ["width"] = 0.025,
  ["param1"] = key, ["param2"] = key+1,
  ["func"] = EngInventory_Config_SwapSearchListItems
},
{ ["type"] = "Edit", ["ID"] = 1, ["width"] = 0.20, ["letters"]=50, ["param1"] = key, ["param2"] = 1,
  ["defaultValue"] = EngInventory_Config_GetItemSearchListLower, ["func"] = EngInventory_Config_AssignItemSearchListUpper
},
{ ["type"] = "Edit", ["ID"] = 2, ["width"] = 0.20, ["letters"]=50, ["param1"] = key, ["param2"] = 2,
  ["defaultValue"] = EngInventory_Config_GetItemSearchListLower, ["func"] = EngInventory_Config_AssignItemSearchListUpper
},
{ ["type"] = "Edit", ["ID"] = 3, ["width"] = 0.35, ["letters"]=50, ["param1"] = key, ["param2"] = 3,
  ["defaultValue"] = EngInventory_Config_GetItemSearchList, ["func"] = EngInventory_Config_AssignItemSearchList
},
{ ["type"] = "Edit", ["ID"] = 4, ["width"] = 0.175, ["letters"]=50, ["param1"] = key, ["param2"] = 4,
  ["defaultValue"] = EngInventory_Config_GetItemSearchList, ["func"] = EngInventory_Config_AssignItemSearchList
}
			}  );
	
	end

end

------------------------

function EngInventory_CalcButtonSize(newsize)
	local k = "button_size_opts";
	-- constants
	ENGINVENTORY_BUTTONFRAME_X_PADDING = 2;
	ENGINVENTORY_BUTTONFRAME_Y_PADDING = 1;
	ENGINVENTORY_BUTTONFRAME_BUTTONWIDTH = newsize;
	ENGINVENTORY_BUTTONFRAME_BUTTONHEIGHT = newsize;
	ENGINVENTORY_BUTTONFRAME_WIDTH = ENGINVENTORY_BUTTONFRAME_BUTTONWIDTH + (ENGINVENTORY_BUTTONFRAME_X_PADDING*2);
	ENGINVENTORY_BUTTONFRAME_HEIGHT = ENGINVENTORY_BUTTONFRAME_BUTTONHEIGHT + (ENGINVENTORY_BUTTONFRAME_Y_PADDING*2);
	ENGINVENTORY_BKGRFRAME_WIDTH = ENGINVENTORY_BUTTONFRAME_BUTTONWIDTH * 1.6;
	ENGINVENTORY_BKGRFRAME_HEIGHT = ENGINVENTORY_BUTTONFRAME_BUTTONHEIGHT * 1.6;
	ENGINVENTORY_COOLDOWN_SCALE = 0.02125 * ENGINVENTORY_BUTTONFRAME_BUTTONWIDTH;

	if (EngInventoryConfig[k] == nil) then
		EngInventoryConfig[k] = {
			["ENGINVENTORY_BUTTONFONTHEIGHT"] = 0.35 * ENGINVENTORY_BUTTONFRAME_BUTTONHEIGHT,
			["ENGINVENTORY_BUTTONFONTHEIGHT2"] = 0.30 * ENGINVENTORY_BUTTONFRAME_BUTTONHEIGHT,
			["ENGINVENTORY_BUTTONFONTDISTANCE_Y"] = (0.08 * ENGINVENTORY_BUTTONFRAME_WIDTH),
			["ENGINVENTORY_BUTTONFONTDISTANCE_X"] = (0.10 * ENGINVENTORY_BUTTONFRAME_HEIGHT)
		};

		if (newsize == 40) then
			EngInventoryConfig[k]["ENGINVENTORY_BUTTONFONTHEIGHT"] = 14;
			EngInventoryConfig[k]["ENGINVENTORY_BUTTONFONTHEIGHT2"] = 12;
			EngInventoryConfig[k]["ENGINVENTORY_BUTTONFONTDISTANCE_Y"] = 2;
			EngInventoryConfig[k]["ENGINVENTORY_BUTTONFONTDISTANCE_X"] = 5;
		end
	end

	ENGINVENTORY_BUTTONFONTHEIGHT = math.ceil(EngInventoryConfig[k]["ENGINVENTORY_BUTTONFONTHEIGHT"]);
	ENGINVENTORY_BUTTONFONTHEIGHT2 = math.ceil(EngInventoryConfig[k]["ENGINVENTORY_BUTTONFONTHEIGHT2"]);
	ENGINVENTORY_BUTTONFONTDISTANCE_Y = EngInventoryConfig[k]["ENGINVENTORY_BUTTONFONTDISTANCE_Y"];
	ENGINVENTORY_BUTTONFONTDISTANCE_X = EngInventoryConfig[k]["ENGINVENTORY_BUTTONFONTDISTANCE_X"];
end

-- scan the config and build a list of catagories
function EngInventory_Catagories(exclude_list, select_bar)
	local clist, key, value;

	clist = {};

	for key,value in EngInventoryConfig do
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


function EngInventory_NumericRange(value, lowest, highest)
        
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

function EngInventory_StringChoices(value, choices_array)
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
function EI_SetDefault(varname, defaultvalue, resetversion, cleanupfunction, cleanup_param1, cleanup_param2)
	local orig_value = EngInventoryConfig[varname];

if (orig_value == nil) then
		orig_value = "";
	end

        if (resetversion == nil) then
                -- more debugging
                message("* Warning, EngInventory EI_SetDefault called with nil reset version: "..varname.." *");
                resetversion = 0;
        end

        if (cleanupfunction ~= nil) then
                EngInventoryConfig[varname] = cleanupfunction(EngInventoryConfig[varname], cleanup_param1, cleanup_param2);
        end

        if (EngInventoryConfig[varname] == nil) then
                EngInventoryConfig[varname] = defaultvalue;
        elseif (EngInventoryConfig[varname.."__version"] == nil) then
                EngInventoryConfig[varname] = defaultvalue;
        elseif (EngInventoryConfig[varname.."__version"] < resetversion) then
		EngInventory_PrintDEBUG("old version: "..EngInventoryConfig[varname.."__version"]..", resetversion: "..resetversion);
                EngInventory_Print( varname.." was reset to it's default value.  Changed from '"..orig_value.."' to "..EngInventoryConfig[varname], 1,0,0 );
                EngInventoryConfig[varname] = defaultvalue;
        end

        EngInventoryConfig[varname.."__version"] = resetversion;
end

function EngInventory_SetClassBars()
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

	EngInventoryConfig["putinslot--SOULSHARDS"] = c["WARLOCK"].."1";
	EngInventoryConfig["putinslot--WARLOCK_REAGENTS"] = c["WARLOCK"].."2";

	EngInventoryConfig["putinslot--ROGUE_POISON"] = c["ROGUE"].."1";
	EngInventoryConfig["putinslot--ROGUE_POWDER"] = c["ROGUE"].."1";

	EngInventoryConfig["putinslot--MAGE_REAGENT"] = c["MAGE"].."1";

	EngInventoryConfig["putinslot--SHAMAN_REAGENTS"] = c["SHAMAN"].."1";
end

-- set "re" to 1 to restore all default values
function EngInventory_SetDefaultValues(re)
        local i, key, value, newEngInventoryConfig;
	local current_config_version = 1;	-- increase this number to wipe everyone's settings

        if ( (EngInventoryConfig == nil) or (EngInventoryConfig["configVersion"] == nil) or (EngInventoryConfig["configVersion"] ~= current_config_version) ) then
                EngInventoryConfig = { ["configVersion"] = current_config_version };
        end

        EI_SetDefault("maxColumns", 9, 1+re, EngInventory_NumericRange, ENGINVENTORY_MAXCOLUMNS_MIN,ENGINVENTORY_MAXCOLUMNS_MAX);

        EI_SetDefault("moveLock", 1, 1+re, EngInventory_NumericRange, 0,1);

	EI_SetDefault("hook_OpenAllBags", 1, 1+re, EngInventory_NumericRange, 0, 1);
	EI_SetDefault("hook_Bag0", 1, 1+re, EngInventory_NumericRange, 0, 1);
	EI_SetDefault("hook_Bag1", 1, 1+re, EngInventory_NumericRange, 0, 1);
	EI_SetDefault("hook_Bag2", 1, 1+re, EngInventory_NumericRange, 0, 1);
	EI_SetDefault("hook_Bag3", 1, 1+re, EngInventory_NumericRange, 0, 1);
	EI_SetDefault("hook_Bag4", 1, 1+re, EngInventory_NumericRange, 0, 1);
	EI_SetDefault("show_Bag0", 1, 1+re, EngInventory_NumericRange, 0, 1);
	EI_SetDefault("show_Bag1", 1, 1+re, EngInventory_NumericRange, 0, 1);
	EI_SetDefault("show_Bag2", 1, 1+re, EngInventory_NumericRange, 0, 1);
	EI_SetDefault("show_Bag3", 1, 1+re, EngInventory_NumericRange, 0, 1);
	EI_SetDefault("show_Bag4", 1, 1+re, EngInventory_NumericRange, 0, 1);

        EI_SetDefault("frameWindowScale", 0.64, 1+re, EngInventory_NumericRange, 0.64, 1.0);
	EI_SetDefault("frameButtonSize", 40, 1+re, EngInventory_NumericRange, 15, 80);

	EngInventory_CalcButtonSize(EngInventoryConfig["frameButtonSize"]);

        EI_SetDefault("frameLEFT", UIParent:GetRight() * UIParent:GetScale() * 0.5, 2+re, EngInventory_NumericRange);
        EI_SetDefault("frameRIGHT", UIParent:GetRight() * UIParent:GetScale() * 0.975, 2+re, EngInventory_NumericRange);
        EI_SetDefault("frameTOP", UIParent:GetTop() * UIParent:GetScale() * 0.90, 2+re, EngInventory_NumericRange);
        EI_SetDefault("frameBOTTOM", UIParent:GetTop() * UIParent:GetScale() * 0.19, 2+re, EngInventory_NumericRange);
        EI_SetDefault("frameXRelativeTo", "RIGHT", 1+re, EngInventory_StringChoices, {"RIGHT","LEFT"} );
        EI_SetDefault("frameYRelativeTo", "BOTTOM", 1+re, EngInventory_StringChoices, {"TOP","BOTTOM"} );

	EI_SetDefault("frameXSpace", 5, 1+re, EngInventory_NumericRange, 0, 20);
        EI_SetDefault("frameYSpace", 5, 1+re, EngInventory_NumericRange, 0, 20);

	EI_SetDefault("show_top_graphics", 1, 1+re, EngInventory_NumericRange, 0, 1);
	EI_SetDefault("build_trade_list", 0, 1+re, EngInventory_NumericRange, 0, 1);

        EI_SetDefault("newItemText", "*New*", 1+re);
        EI_SetDefault("newItemTextPlus", "++", 1+re);
        EI_SetDefault("newItemTextMinus", "--", 1+re);
	EI_SetDefault("newItemText_Off", "", 1+re);
        EI_SetDefault("newItemTimeout", 60*60*3 , 1+re, EngInventory_NumericRange);     -- 3 hours for an item to lose "new" status
        EI_SetDefault("newItemTimeout2", 60*10 , 1+re, EngInventory_NumericRange);      -- 10 minutes
        EI_SetDefault("newItemColor1_R", 0.9 , 1+re, EngInventory_NumericRange, 0, 1.0);
        EI_SetDefault("newItemColor1_G", 0.9 , 1+re, EngInventory_NumericRange, 0, 1.0);
        EI_SetDefault("newItemColor1_B", 0.2 , 1+re, EngInventory_NumericRange, 0, 1.0);
        EI_SetDefault("newItemColor2_R", 0.0 , 1+re, EngInventory_NumericRange, 0, 1.0);
        EI_SetDefault("newItemColor2_G", 1.0 , 1+re, EngInventory_NumericRange, 0, 1.0);
        EI_SetDefault("newItemColor2_B", 0.4 , 1+re, EngInventory_NumericRange, 0, 1.0);

	for i = 1, ENGINVENTORY_MAINWINDOWCOLORIDX do
		EI_SetDefault("bar_colors_"..i.."_background_r", 0.0, 1+re, EngInventory_NumericRange, 0, 1.0);
		EI_SetDefault("bar_colors_"..i.."_background_g", 0.25, 1+re, EngInventory_NumericRange, 0, 1.0);
		EI_SetDefault("bar_colors_"..i.."_background_b", 0.5, 1+re, EngInventory_NumericRange, 0, 1.0);
		EI_SetDefault("bar_colors_"..i.."_background_a", 0.5, 1+re, EngInventory_NumericRange, 0, 1.0);

		EI_SetDefault("bar_colors_"..i.."_border_r", 0.0, 1+re, EngInventory_NumericRange, 0, 1.0);
		EI_SetDefault("bar_colors_"..i.."_border_g", 0.5, 1+re, EngInventory_NumericRange, 0, 1.0);
		EI_SetDefault("bar_colors_"..i.."_border_b", 1.0, 1+re, EngInventory_NumericRange, 0, 1.0);
		EI_SetDefault("bar_colors_"..i.."_border_a", 0.5, 1+re, EngInventory_NumericRange, 0, 1.0);
	end

	EngInventory_SetClassBars();

        -- default slot locations for items
	EI_SetDefault("putinslot--CLASS_ITEMS1", 15, 1+re, EngInventory_NumericRange, 1, ENGINVENTORY_MAX_BARS);
        --EI_SetDefault("putinslot--SOULSHARDS", 15, 1+re, EngInventory_NumericRange, 1, ENGINVENTORY_MAX_BARS);
        EI_SetDefault("putinslot--EMPTY_PROJECTILE_SLOTS", 15, 1+re, EngInventory_NumericRange, 1, ENGINVENTORY_MAX_BARS);
        EI_SetDefault("putinslot--USED_PROJECTILE_SLOTS", 15, 1+re, EngInventory_NumericRange, 1, ENGINVENTORY_MAX_BARS);
        EI_SetDefault("putinslot--PROJECTILE", 14, 1+re, EngInventory_NumericRange, 1, ENGINVENTORY_MAX_BARS);          -- arrows and bullets that AREN'T in your shot bags
        EI_SetDefault("putinslot--EMPTY_SLOTS", 13, 1+re, EngInventory_NumericRange, 1, ENGINVENTORY_MAX_BARS);         -- Empty slots go in this bar
        EI_SetDefault("putinslot--GRAY_ITEMS", 13, 1+re, EngInventory_NumericRange, 1, ENGINVENTORY_MAX_BARS);          -- Gray items go in this bar
        --
        EI_SetDefault("putinslot--OTHERORUNKNOWN", 12, 1+re, EngInventory_NumericRange, 1, ENGINVENTORY_MAX_BARS);      -- if not soulbound, but doesn't match any other catagory, it goes here
        EI_SetDefault("putinslot--TRADEGOODS", 12, 1+re, EngInventory_NumericRange, 1, ENGINVENTORY_MAX_BARS);
	--EI_SetDefault("putinslot--NON_CLASS_ITEMS1", 12, 1+re, EngInventory_NumericRange, 1, ENGINVENTORY_MAX_BARS);
	EI_SetDefault("putinslot--RECIPE", 12, 1+re, EngInventory_NumericRange, 1, ENGINVENTORY_MAX_BARS);
	EI_SetDefault("putinslot--PATTERN", 12, 1+re, EngInventory_NumericRange, 1, ENGINVENTORY_MAX_BARS);
	EI_SetDefault("putinslot--SCHEMATIC", 12, 1+re, EngInventory_NumericRange, 1, ENGINVENTORY_MAX_BARS);
	EI_SetDefault("putinslot--FORMULA", 12, 1+re, EngInventory_NumericRange, 1, ENGINVENTORY_MAX_BARS);
	EI_SetDefault("putinslot--TRADESKILL_COOKING", 12, 1+re, EngInventory_NumericRange, 1, ENGINVENTORY_MAX_BARS);
	EI_SetDefault("putinslot--TRADESKILL_FIRSTAID", 12, 1+re, EngInventory_NumericRange, 1, ENGINVENTORY_MAX_BARS);
	--EI_SetDefault("putinslot--NON_CLASS_ITEMS2", 12, 1+re, EngInventory_NumericRange, 1, ENGINVENTORY_MAX_BARS);
        EI_SetDefault("putinslot--OTHERSOULBOUND", 11, 1+re, EngInventory_NumericRange, 1, ENGINVENTORY_MAX_BARS);       -- this will usually be soulbound equipment
	EI_SetDefault("putinslot--CUSTOM_01", 10, 1+re, EngInventory_NumericRange, 1, ENGINVENTORY_MAX_BARS);
	EI_SetDefault("putinslot--CUSTOM_02", 10, 1+re, EngInventory_NumericRange, 1, ENGINVENTORY_MAX_BARS);
	EI_SetDefault("putinslot--CUSTOM_03", 10, 1+re, EngInventory_NumericRange, 1, ENGINVENTORY_MAX_BARS);
	EI_SetDefault("putinslot--CUSTOM_04", 10, 1+re, EngInventory_NumericRange, 1, ENGINVENTORY_MAX_BARS);
	EI_SetDefault("putinslot--CUSTOM_05", 10, 1+re, EngInventory_NumericRange, 1, ENGINVENTORY_MAX_BARS);
	EI_SetDefault("putinslot--CUSTOM_06", 10, 1+re, EngInventory_NumericRange, 1, ENGINVENTORY_MAX_BARS);
	--
        EI_SetDefault("putinslot--CONSUMABLE", 9, 1+re, EngInventory_NumericRange, 1, ENGINVENTORY_MAX_BARS);
        EI_SetDefault("putinslot--TRADESKILL_2", 8, 1+re, EngInventory_NumericRange, 1, ENGINVENTORY_MAX_BARS);
        EI_SetDefault("putinslot--TRADESKILL_1", 8, 1+re, EngInventory_NumericRange, 1, ENGINVENTORY_MAX_BARS);
        EI_SetDefault("putinslot--TRADESKILL_2_CREATED", 8, 1+re, EngInventory_NumericRange, 1, ENGINVENTORY_MAX_BARS);
        EI_SetDefault("putinslot--TRADESKILL_1_CREATED", 8, 1+re, EngInventory_NumericRange, 1, ENGINVENTORY_MAX_BARS);
        EI_SetDefault("putinslot--EQUIPPED", 7, 1+re, EngInventory_NumericRange, 1, ENGINVENTORY_MAX_BARS);
        --
        EI_SetDefault("putinslot--FOOD", 6, 1+re, EngInventory_NumericRange, 1, ENGINVENTORY_MAX_BARS);
        EI_SetDefault("putinslot--DRINK", 5, 1+re, EngInventory_NumericRange, 1, ENGINVENTORY_MAX_BARS);
        EI_SetDefault("putinslot--QUESTITEMS", 4, 1+re, EngInventory_NumericRange, 1, ENGINVENTORY_MAX_BARS);
        --
        EI_SetDefault("putinslot--HEALINGPOTION", 3, 1+re, EngInventory_NumericRange, 1, ENGINVENTORY_MAX_BARS);
        EI_SetDefault("putinslot--HEALTHSTONE", 3, 1+re, EngInventory_NumericRange, 1, ENGINVENTORY_MAX_BARS);
        EI_SetDefault("putinslot--MANAPOTION", 2, 1+re, EngInventory_NumericRange, 1, ENGINVENTORY_MAX_BARS);
        EI_SetDefault("putinslot--BANDAGE", 1, 1+re, EngInventory_NumericRange, 1, ENGINVENTORY_MAX_BARS);
        EI_SetDefault("putinslot--REAGENT", 1, 1+re, EngInventory_NumericRange, 1, ENGINVENTORY_MAX_BARS);
        EI_SetDefault("putinslot--JUJU", 1, 1+re, EngInventory_NumericRange, 1, ENGINVENTORY_MAX_BARS);
        EI_SetDefault("putinslot--MISC", 1, 1+re, EngInventory_NumericRange, 1, ENGINVENTORY_MAX_BARS);
        EI_SetDefault("putinslot--TRADETOOLS", 1, 1+re, EngInventory_NumericRange, 1, ENGINVENTORY_MAX_BARS);
	EI_SetDefault("putinslot--MINIPET", 1, 1+re, EngInventory_NumericRange, 1, ENGINVENTORY_MAX_BARS);
        EI_SetDefault("putinslot--HEARTH", 1, 1+re, EngInventory_NumericRange, 1, ENGINVENTORY_MAX_BARS);
        EI_SetDefault("putinslot--KEYS", 1, 1+re, EngInventory_NumericRange, 1, ENGINVENTORY_MAX_BARS);
	EI_SetDefault("putinslot--CLASS_ITEMS2", 1, 1+re, EngInventory_NumericRange, 1, ENGINVENTORY_MAX_BARS);

	-- okay, I defined too many catagories...  Time to cleanup the config:

	--EngInventoryConfig = EngInventory_Table_RemoveKey(EngInventoryConfig, "putinslot--RECIPE" );
	--EngInventoryConfig = EngInventory_Table_RemoveKey(EngInventoryConfig, "putinslot--SCHEMATIC" );
	--EngInventoryConfig = EngInventory_Table_RemoveKey(EngInventoryConfig, "putinslot--PATTERN" );

        -- default item overrides
	EI_SetDefault("itemoverride_loaddefaults", 1, 3+re, EngInventory_NumericRange, 0, 1);
	if (EngInventoryConfig["itemoverride_loaddefaults"] == 1) then
		EngInventoryConfig["item_overrides"] = EngInventory_DefaultItemOverrides;
		EngInventoryConfig["item_search_list"] = EngInventory_DefaultSearchList;

		for key,value in EngInventoryConfig["item_search_list"] do
			if (string.sub(value[4], 1, 5) == "loc::") then
				EngInventoryConfig["item_search_list"][key][4] = EILocal[ string.sub(value[4],6) ];
			end
		end

		for key,value in EILocal["string_searches"] do
			table.insert(EngInventoryConfig["item_search_list"], EngInventory_DefaultSearchItemsINSERTTO,
				{ value[1], "", value[2], "" } );
		end

		EngInventoryConfig["itemoverride_loaddefaults"] = 0;
	end

	-- cleanup old overrides that shouldn't be in the config anymore
	newEngInventoryConfig = EngInventoryConfig;
	for key,value in EngInventoryConfig do
		if (string.find(key, "itemoverride--")) then
			newEngInventoryConfig = EngInventory_Table_RemoveKey(newEngInventoryConfig, key);
		end
	end
	EngInventoryConfig = newEngInventoryConfig;

        -- default sort views / default "allow new items in bar" settings
        EI_SetDefault("bar_sort_"..EngInventoryConfig["putinslot--EMPTY_SLOTS"], ENGINVENTORY_SORTBYNAMEREV, 2+re, EngInventory_NumericRange, ENGINVENTORY_SORTLOWESTVALUE, ENGINVENTORY_SORTHIGHESTVALUE);
        EI_SetDefault("bar_sort_"..EngInventoryConfig["putinslot--HEALINGPOTION"], ENGINVENTORY_SORTBYNAMEREV, 2+re, EngInventory_NumericRange, ENGINVENTORY_SORTLOWESTVALUE, ENGINVENTORY_SORTHIGHESTVALUE);
        EI_SetDefault("bar_sort_"..EngInventoryConfig["putinslot--MANAPOTION"], ENGINVENTORY_SORTBYNAMEREV, 2+re, EngInventory_NumericRange, ENGINVENTORY_SORTLOWESTVALUE, ENGINVENTORY_SORTHIGHESTVALUE);
        EI_SetDefault("bar_sort_"..EngInventoryConfig["putinslot--TRADEGOODS"], ENGINVENTORY_SORTBYNAMEREV, 2+re, EngInventory_NumericRange, ENGINVENTORY_SORTLOWESTVALUE, ENGINVENTORY_SORTHIGHESTVALUE);

	--EI_SetDefault("allow_new_in_bar_"..EngInventoryConfig["putinslot--HEALINGPOTION"], 0, 1+re, EngInventory_NumericRange, 0, 1);
	--EI_SetDefault("allow_new_in_bar_"..EngInventoryConfig["putinslot--MANAPOTION"], 0, 1+re, EngInventory_NumericRange, 0, 1);
	--EI_SetDefault("allow_new_in_bar_"..EngInventoryConfig["putinslot--FOOD"], 0, 1+re, EngInventory_NumericRange, 0, 1);
	--EI_SetDefault("allow_new_in_bar_"..EngInventoryConfig["putinslot--DRINK"], 0, 1+re, EngInventory_NumericRange, 0, 1);
	--EI_SetDefault("allow_new_in_bar_"..EngInventoryConfig["putinslot--SOULSHARDS"], 0, 1+re, EngInventory_NumericRange, 0, 1);

	for i = 1, ENGINVENTORY_MAX_BARS do
                EI_SetDefault("bar_sort_"..i, ENGINVENTORY_SORTBYNAME, 2+re, EngInventory_NumericRange, ENGINVENTORY_SORTLOWESTVALUE, ENGINVENTORY_SORTHIGHESTVALUE);
		EI_SetDefault("allow_new_in_bar_"..i, 1, 1+re, EngInventory_NumericRange, 0, 1);
	end

	-- find matching catagories that are not assigned
	for key,value in EngInventoryConfig["item_search_list"] do
		if (EngInventoryConfig["putinslot--"..value[1]] == nil) then
			message("EngInventory: Unassigned catagory: "..value[1].." -- It has been assigned to slot 1");
			EngInventoryConfig["putinslot--"..value[1]] = 1;
		end
	end

        if (re>0) then
                EngInventory_SetDefaultValues(0);
        end
end

function EngInventory_SetTradeSkills()
	local k,v;

	ENGINVENTORY_TRADE1 = "";
	ENGINVENTORY_TRADE2 = "";

	for k,v in EngInventoryConfig[ENGINVENTORY_PLAYERID]["tradeskills"] do
		if ((k ~= EILocal["Cooking"]) and (k ~= EILocal["First Aid"])) then
			ENGINVENTORY_TRADE1 = ENGINVENTORY_TRADE2;
			ENGINVENTORY_TRADE2 = k;
		end
	end
end

function EngInventory_init()
	ENGINVENTORY_PLAYERID = UnitName("player").." of "..GetCVar("realmName");

	-- change imported from auctioneer team..  what does it do?
	UIPanelWindows["EngInventory_frame"] = { area = "left", pushable = 6 };

	if ( ENGINVENTORY_WIPECONFIGONLOAD == 1 ) then
		EngInventoryConfig = {};
	end

        -- Load localization -- ERR_BADATTACKPOS is a blizzard defined constant for displaying an error message.
        --                      it should be good enough to determine what language the game is running in.
        if ( ERR_BADATTACKPOS == ERR_BADATTACKPOS_LOCAL_EN ) then
                -- US/English
                EngInventory_load_Localization("EN");
        elseif ( ERR_BADATTACKPOS == ERR_BADATTACKPOS_LOCAL_FR ) then
                -- French
                EngInventory_load_Localization("FR");
        elseif ( ERR_BADATTACKPOS == ERR_BADATTACKPOS_LOCAL_DE ) then
                -- German
                EngInventory_load_Localization("DE");
        else
                -- have to load something...  :(
                --EngInventory_Print("*** No localization found, stuff won't work properly ***", 1,0.25,0.25 );
		message("EngInventory: No localization found, stuff won't work properly");
                EngInventory_load_Localization("EN");
        end

        -- register slash command
        SlashCmdList["ENGINVENTORY"] = EngInventory_cmd;
        SLASH_ENGINVENTORY1 = "/einv";
        SLASH_ENGINVENTORY2 = "/ei";

        -- load default values
        EngInventory_SetDefaultValues(0);
        
	-- go through the tradeskill list, and remove what shouldn't be there
	-- bah, do it in a lazy way, just wipe it
	if (EngInventoryConfig[ENGINVENTORY_PLAYERID] == nil) then
		EngInventoryConfig[ENGINVENTORY_PLAYERID] = {};
	end
	if (EngInventoryConfig[ENGINVENTORY_PLAYERID]["tradeskills"] == nil) then
		EngInventoryConfig[ENGINVENTORY_PLAYERID]["tradeskills"] = {};
	end
	local max_skills = 2;
	if (EngInventoryConfig[ENGINVENTORY_PLAYERID]["tradeskills"][EILocal["Cooking"]] ~= nil) then
		max_skills = max_skills + 1;
	end
	if (EngInventoryConfig[ENGINVENTORY_PLAYERID]["tradeskills"][EILocal["First Aid"]] ~= nil) then
		max_skills = max_skills + 1;
	end
	if (table.getn(EngInventoryConfig[ENGINVENTORY_PLAYERID]["tradeskills"]) > max_skills) then
		EngInventoryConfig[ENGINVENTORY_PLAYERID]["tradeskills"] = {};	-- wipe it out
		EngInventoryConfig[ENGINVENTORY_PLAYERID]["tradeskill_items"] = {};
	end

	-- detailed info about tradeskills
	if (EngInventoryConfig[ENGINVENTORY_PLAYERID]["trades"] == nil) then
		EngInventoryConfig[ENGINVENTORY_PLAYERID]["trades"] = {};
	end

	EngInventory_SetTradeSkills();

        -- setup hooks
        EngInventory_RegisterHooks(ENGINVENTORY_HOOKS_REGISTER);


        EngInventory_Button_HighlightToggle:SetText(EILocal["EngInventory_Button_HighlightToggle_off"]);
        EngInventory_Button_ChangeEditMode:SetText(EILocal["EngInventory_Button_ChangeEditMode_off"]);

        if (EngInventoryConfig["moveLock"] == 0) then
                EngInventory_Button_MoveLockToggle:SetText(EILocal["EngInventory_Button_MoveLock_locked"]);
        else
                EngInventory_Button_MoveLockToggle:SetText(EILocal["EngInventory_Button_MoveLock_unlocked"]);
        end

	EngInventory_OnEvent("UPDATE_INVENTORY_ALERTS");	-- reload the items currently equipped
end

function EngInventory_ExtractTooltip(tooltipframe)
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

		if (ENGINVENTORY_ENABLE_GETTEXTCOLOR) then
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

function EngInventory_OnEvent__old(event)

        EngInventory_PrintDEBUG("event: '"..event.."'");

        if ( event == "BAG_UPDATE" ) then
                EngInventory_UpdateWindow();
        elseif ( event == "BAG_UPDATE_COOLDOWN" ) then
                EngInventory_UpdateWindow();
        elseif ( event == "ITEM_LOCK_CHANGED" ) then
                EngInventory_UpdateWindow();
	elseif ( event == "CRAFT_SHOW" ) then
		-- load craft info (Enchanting)
		if (GetNumCrafts() > 0) then
			local craftName, craftSubSpellName, craftType, numAvailable, isExpanded;
			local craftItemLink;
			local tradeskillName, currentLevel, maxLevel = GetCraftDisplaySkillLine();
			local a,b,c,d;
			local reagentItemLink;

			if (EngInventoryConfig[ENGINVENTORY_PLAYERID] == nil) then
				EngInventoryConfig[ENGINVENTORY_PLAYERID] = {};
			end
			if (EngInventoryConfig[ENGINVENTORY_PLAYERID]["tradeskills"] == nil) then
				EngInventoryConfig[ENGINVENTORY_PLAYERID]["tradeskills"] = {};
			end
			EngInventoryConfig[ENGINVENTORY_PLAYERID]["tradeskills"][tradeskillName] = date("%y%m%d%H%M%S");
			EngInventory_SetTradeSkills();
			if (EngInventoryConfig[ENGINVENTORY_PLAYERID]["tradeskill_items"] == nil) then
				EngInventoryConfig[ENGINVENTORY_PLAYERID]["tradeskill_items"] = {};
			end
			if ( EngInventoryConfig[ENGINVENTORY_PLAYERID]["tradeskill_production"] == nil ) then
				EngInventoryConfig[ENGINVENTORY_PLAYERID]["tradeskill_production"] = {};
			end

			for i = 1, GetNumCrafts() do
				craftName, craftSubSpellName, craftType, numAvailable, isExpanded = GetCraftInfo(i);
				craftItemLink = GetCraftItemLink(i);
				if ( (craftItemLink ~= nil) and (type(craftItemLink) == "string") ) then
					for a,b,c,d in string.gfind(craftItemLink, "(%d+):(%d+):(%d+):(%d+)") do
						craftItemLink = ""..a..":0:"..c..":0";
					end

					if ( EngInventoryConfig[ENGINVENTORY_PLAYERID]["tradeskill_production"][craftItemLink] == nil ) then
						EngInventoryConfig[ENGINVENTORY_PLAYERID]["tradeskill_production"][craftItemLink] = {};
					end
					EngInventoryConfig[ENGINVENTORY_PLAYERID]["tradeskill_production"][craftItemLink][tradeskillName] = 1;
				end

				if (GetCraftNumReagents(i) > 0) then
					for i2 = 1, GetCraftNumReagents(i) do
						reagentItemLink = GetCraftReagentItemLink(i,i2);
						if (reagentItemLink ~= nil) then
							for a,b,c,d in string.gfind(reagentItemLink, "(%d+):(%d+):(%d+):(%d+)") do
								reagentItemLink = ""..a..":0:"..c..":0";
							end						
							
							if (EngInventoryConfig[ENGINVENTORY_PLAYERID]["tradeskill_items"][reagentItemLink] == nil) then
								EngInventoryConfig[ENGINVENTORY_PLAYERID]["tradeskill_items"][reagentItemLink] = {};
							end
							EngInventoryConfig[ENGINVENTORY_PLAYERID]["tradeskill_items"][reagentItemLink][tradeskillName] = 1;
						end
					end
				end
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

			if (EngInventoryConfig[ENGINVENTORY_PLAYERID] == nil) then
				EngInventoryConfig[ENGINVENTORY_PLAYERID] = {};
			end
			if (EngInventoryConfig[ENGINVENTORY_PLAYERID]["tradeskills"] == nil) then
				EngInventoryConfig[ENGINVENTORY_PLAYERID]["tradeskills"] = {};
			end
			EngInventoryConfig[ENGINVENTORY_PLAYERID]["tradeskills"][tradeskillName] = date("%Y%m%d%H%M%S");
			EngInventory_SetTradeSkills();
			if (EngInventoryConfig[ENGINVENTORY_PLAYERID]["tradeskill_items"] == nil) then
				EngInventoryConfig[ENGINVENTORY_PLAYERID]["tradeskill_items"] = {};
			end
			if (EngInventoryConfig[ENGINVENTORY_PLAYERID]["tradeskill_production"] == nil) then
				EngInventoryConfig[ENGINVENTORY_PLAYERID]["tradeskill_production"] = {};
			end

			for i = 1, GetNumTradeSkills() do
				craftName, craftSubSpellName, craftType, numAvailable, isExpanded = GetTradeSkillInfo(i);
				craftItemLink = GetTradeSkillItemLink(i);
				if ( (craftItemLink ~= nil) and (type(craftItemLink) == "string") ) then
					for a,b,c,d in string.gfind(craftItemLink, "(%d+):(%d+):(%d+):(%d+)") do
						craftItemLink = ""..a..":0:"..c..":0";
					end

					if ( EngInventoryConfig[ENGINVENTORY_PLAYERID]["tradeskill_production"][craftItemLink] == nil ) then
						EngInventoryConfig[ENGINVENTORY_PLAYERID]["tradeskill_production"][craftItemLink] = {};
					end
					EngInventoryConfig[ENGINVENTORY_PLAYERID]["tradeskill_production"][craftItemLink][tradeskillName] = 1;
				end

				if (GetTradeSkillNumReagents(i) > 0) then
					for i2 = 1, GetTradeSkillNumReagents(i) do
						reagentItemLink = GetTradeSkillReagentItemLink(i,i2);
						if (reagentItemLink ~= nil) then
							for a,b,c,d in string.gfind(reagentItemLink, "(%d+):(%d+):(%d+):(%d+)") do
								reagentItemLink = ""..a..":0:"..c..":0";
							end						
							
							if (EngInventoryConfig[ENGINVENTORY_PLAYERID]["tradeskill_items"][reagentItemLink] == nil) then
								EngInventoryConfig[ENGINVENTORY_PLAYERID]["tradeskill_items"][reagentItemLink] = {};
							end
							EngInventoryConfig[ENGINVENTORY_PLAYERID]["tradeskill_items"][reagentItemLink][tradeskillName] = 1;
						end
					end
				end
			end
		end
	elseif ( event == "UPDATE_INVENTORY_ALERTS" ) then
		local itemLink;
		local a,b,c,d;

		EngInventory_PrintDEBUG("About to scan inventory");

		if (EngInventoryConfig[ENGINVENTORY_PLAYERID]["equipped_items"] == nil) then
			EngInventoryConfig[ENGINVENTORY_PLAYERID]["equipped_items"] = {};
		end

		for key,value in { "HeadSlot","NeckSlot","ShoulderSlot","BackSlot","ChestSlot",
			"ShirtSlot","TabardSlot","WristSlot","HandsSlot","WaistSlot","LegsSlot",
			"FeetSlot","Finger0Slot","Finger1Slot","Trinket0Slot","Trinket1Slot",
			"MainHandSlot","SecondaryHandSlot","RangedSlot" } do

			EngInventory_PrintDEBUG( "Scanning: "..value );
			itemLink = GetInventoryItemLink("player", GetInventorySlotInfo(value) );
			if ( (itemLink ~= nil) and (type(itemLink) == "string") ) then
				for a,b,c,d in string.gfind(itemLink, "(%d+):(%d+):(%d+):(%d+)") do
					itemLink = ""..a..":0:"..c..":0";
				end
				
				EngInventoryConfig[ENGINVENTORY_PLAYERID]["equipped_items"][itemLink] = 1;
			end
		end

                EngInventory_UpdateWindow();
	else
		EngInventory_PrintDEBUG("OnEvent: No event handler found.");
        end

	EngInventory_PrintDEBUG("OnEvent: Finished "..event);
end

function EngInventory_OnEvent(event)
        EngInventory_PrintDEBUG("event: '"..event.."'");

        if ( event == "BAG_UPDATE" ) then
                EngInventory_UpdateWindow();
        elseif ( event == "BAG_UPDATE_COOLDOWN" ) then
                EngInventory_UpdateWindow();
        elseif ( event == "ITEM_LOCK_CHANGED" ) then
                EngInventory_UpdateWindow();
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

				if (EngInventoryConfig[ENGINVENTORY_PLAYERID] == nil) then
					EngInventoryConfig[ENGINVENTORY_PLAYERID] = {};
				end
				if (EngInventoryConfig[ENGINVENTORY_PLAYERID]["tradeskills"] == nil) then
					EngInventoryConfig[ENGINVENTORY_PLAYERID]["tradeskills"] = {};
				end
				EngInventoryConfig[ENGINVENTORY_PLAYERID]["tradeskills"][tradeskillName] = date("%y%m%d%H%M%S");
				EngInventory_SetTradeSkills();
				if (EngInventoryConfig[ENGINVENTORY_PLAYERID]["tradeskill_items"] == nil) then
					EngInventoryConfig[ENGINVENTORY_PLAYERID]["tradeskill_items"] = {};
				end

				EngInventoryConfig[ENGINVENTORY_PLAYERID]["trades"][tradeskillName] = {};	-- wipe it out, we're refreshing it now anyway

				if (GetNumCrafts() > 0) then
					for i = 1, GetNumCrafts() do
						craftName, craftSubSpellName, craftType, numAvailable, isExpanded = GetCraftInfo(i);
						craftItemLink = GetCraftItemLink(i);
						-- remember: a craft might just be a skill and not a physical item
						if ( (craftItemLink ~= nil) and (type(craftItemLink) == "string") ) then
							for a,b,c,d in string.gfind(craftItemLink, "(%d+):(%d+):(%d+):(%d+)") do
								craftItemLink = ""..a..":0:"..c..":0";
							end

							if ( EngInventoryConfig[ENGINVENTORY_PLAYERID]["tradeskill_production"][craftItemLink] == nil ) then
								EngInventoryConfig[ENGINVENTORY_PLAYERID]["tradeskill_production"][craftItemLink] = {};
							end
							EngInventoryConfig[ENGINVENTORY_PLAYERID]["tradeskill_production"][craftItemLink][tradeskillName] = 1;
						end

						-- build the complete info about tradeskills, this is for exporting data
						-- so now I store by craftName instead of craftItemLink
						if ( (EngInventory_BuildTradeList[tradeskillName] == nil) and (EngInventoryConfig["build_trade_list"] == 1) ) then
							EngInventory_tt:SetCraftSpell(i);
							if (EngInventoryConfig[ENGINVENTORY_PLAYERID]["trades"][tradeskillName][craftName] == nil) then
								EngInventoryConfig[ENGINVENTORY_PLAYERID]["trades"][tradeskillName][craftName] = {};
							end
							EngInventoryConfig[ENGINVENTORY_PLAYERID]["trades"][tradeskillName][craftName]["item"] = EngInventory_ExtractTooltip("EngInventory_tt");
						end

						if (GetCraftNumReagents(i) > 0) then
							for i2 = 1, GetCraftNumReagents(i) do
								reagentItemLink = GetCraftReagentItemLink(i,i2);
								if (reagentItemLink ~= nil) then
									for a,b,c,d in string.gfind(reagentItemLink, "(%d+):(%d+):(%d+):(%d+)") do
										reagentItemLink = ""..a..":0:"..c..":0";
									end						
									
									if (EngInventoryConfig[ENGINVENTORY_PLAYERID]["tradeskill_items"][reagentItemLink] == nil) then
										EngInventoryConfig[ENGINVENTORY_PLAYERID]["tradeskill_items"][reagentItemLink] = {};
									end
									EngInventoryConfig[ENGINVENTORY_PLAYERID]["tradeskill_items"][reagentItemLink][tradeskillName] = 1;

									if ( (EngInventory_BuildTradeList[tradeskillName] == nil) and (EngInventoryConfig["build_trade_list"] == 1) ) then
										EngInventory_tt:SetCraftItem(i,i2);
										EngInventoryConfig[ENGINVENTORY_PLAYERID]["trades"][tradeskillName][craftName][reagentItemLink] = EngInventory_ExtractTooltip("EngInventory_tt");
										EngInventoryConfig[ENGINVENTORY_PLAYERID]["trades"][tradeskillName][craftName][reagentItemLink]["n"],
										EngInventoryConfig[ENGINVENTORY_PLAYERID]["trades"][tradeskillName][craftName][reagentItemLink]["t"],
										EngInventoryConfig[ENGINVENTORY_PLAYERID]["trades"][tradeskillName][craftName][reagentItemLink]["c"] = GetCraftReagentInfo(i,i2);
									end
								end
							end
						end
					end
				end

				EngInventory_BuildTradeList[tradeskillName] = 1;	-- only do the exhaustive load once
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

			if (EngInventoryConfig[ENGINVENTORY_PLAYERID] == nil) then
				EngInventoryConfig[ENGINVENTORY_PLAYERID] = {};
			end
			if (EngInventoryConfig[ENGINVENTORY_PLAYERID]["tradeskills"] == nil) then
				EngInventoryConfig[ENGINVENTORY_PLAYERID]["tradeskills"] = {};
			end
			EngInventoryConfig[ENGINVENTORY_PLAYERID]["tradeskills"][tradeskillName] = date("%Y%m%d%H%M%S");
			EngInventory_SetTradeSkills();
			if (EngInventoryConfig[ENGINVENTORY_PLAYERID]["tradeskill_items"] == nil) then
				EngInventoryConfig[ENGINVENTORY_PLAYERID]["tradeskill_items"] = {};
			end
			if (EngInventoryConfig[ENGINVENTORY_PLAYERID]["tradeskill_production"] == nil) then
				EngInventoryConfig[ENGINVENTORY_PLAYERID]["tradeskill_production"] = {};
			end

			EngInventoryConfig[ENGINVENTORY_PLAYERID]["trades"][tradeskillName] = {};

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

						if ( EngInventoryConfig[ENGINVENTORY_PLAYERID]["tradeskill_production"][craftItemLink] == nil ) then
							EngInventoryConfig[ENGINVENTORY_PLAYERID]["tradeskill_production"][craftItemLink] = {};
						end
						EngInventoryConfig[ENGINVENTORY_PLAYERID]["tradeskill_production"][craftItemLink][tradeskillName] = 1;

						-- build the complete info about tradeskills, this is for exporting data
						if ( (EngInventory_BuildTradeList[tradeskillName] == nil) and (EngInventoryConfig["build_trade_list"] == 1) ) then
							if (EngInventoryConfig[ENGINVENTORY_PLAYERID]["trades"][tradeskillName][craftName] == nil) then
								EngInventoryConfig[ENGINVENTORY_PLAYERID]["trades"][tradeskillName][craftName] = {};
							end
							EngInventory_tt:SetTradeSkillItem(i);
							EngInventoryConfig[ENGINVENTORY_PLAYERID]["trades"][tradeskillName][craftName]["item"] = EngInventory_ExtractTooltip("EngInventory_tt");
						end

						if (GetTradeSkillNumReagents(i) > 0) then
							for i2 = 1, GetTradeSkillNumReagents(i) do
								reagentItemLink = GetTradeSkillReagentItemLink(i,i2);
								if (reagentItemLink ~= nil) then
									for a,b,c,d in string.gfind(reagentItemLink, "(%d+):(%d+):(%d+):(%d+)") do
										reagentItemLink = ""..a..":0:"..c..":0";
									end						
									
									if (EngInventoryConfig[ENGINVENTORY_PLAYERID]["tradeskill_items"][reagentItemLink] == nil) then
										EngInventoryConfig[ENGINVENTORY_PLAYERID]["tradeskill_items"][reagentItemLink] = {};
									end
									EngInventoryConfig[ENGINVENTORY_PLAYERID]["tradeskill_items"][reagentItemLink][tradeskillName] = 1;

									if ( (EngInventory_BuildTradeList[tradeskillName] == nil) and (EngInventoryConfig["build_trade_list"] == 1) ) then
										EngInventory_tt:SetTradeSkillItem(i,i2);
										EngInventoryConfig[ENGINVENTORY_PLAYERID]["trades"][tradeskillName][craftName][reagentItemLink] = EngInventory_ExtractTooltip("EngInventory_tt");
										EngInventoryConfig[ENGINVENTORY_PLAYERID]["trades"][tradeskillName][craftName][reagentItemLink]["n"],
										EngInventoryConfig[ENGINVENTORY_PLAYERID]["trades"][tradeskillName][craftName][reagentItemLink]["t"],
										EngInventoryConfig[ENGINVENTORY_PLAYERID]["trades"][tradeskillName][craftName][reagentItemLink]["c"] = GetTradeSkillReagentInfo(i,i2);
									end
								end
							end
						end
					end
				end
			end

			EngInventory_BuildTradeList[tradeskillName] = 1;	-- only do the exhaustive load once
		end
	elseif ( event == "UPDATE_INVENTORY_ALERTS" ) then
		local itemLink;
		local a,b,c,d;

		EngInventory_PrintDEBUG("About to scan inventory");

		if (EngInventoryConfig[ENGINVENTORY_PLAYERID]["equipped_items"] == nil) then
			EngInventoryConfig[ENGINVENTORY_PLAYERID]["equipped_items"] = {};
		end

		for key,value in { "HeadSlot","NeckSlot","ShoulderSlot","BackSlot","ChestSlot",
			"ShirtSlot","TabardSlot","WristSlot","HandsSlot","WaistSlot","LegsSlot",
			"FeetSlot","Finger0Slot","Finger1Slot","Trinket0Slot","Trinket1Slot",
			"MainHandSlot","SecondaryHandSlot","RangedSlot" } do

			EngInventory_PrintDEBUG( "Scanning: "..value );
			itemLink = GetInventoryItemLink("player", GetInventorySlotInfo(value) );
			if ( (itemLink ~= nil) and (type(itemLink) == "string") ) then
				for a,b,c,d in string.gfind(itemLink, "(%d+):(%d+):(%d+):(%d+)") do
					itemLink = ""..a..":0:"..c..":0";
				end
				
				EngInventoryConfig[ENGINVENTORY_PLAYERID]["equipped_items"][itemLink] = 1;
			end
		end

                EngInventory_UpdateWindow();
	else
		EngInventory_PrintDEBUG("OnEvent: No event handler found.");
        end

	EngInventory_PrintDEBUG("OnEvent: Finished "..event);
end

function EngInventory_StartMoving(frame)
        if ( not frame.isMoving ) and ( EngInventoryConfig["moveLock"] == 1 ) then
                frame:StartMoving();
                frame.isMoving = true;
        end
end

function EngInventory_StopMoving(frame)
        if ( frame.isMoving ) then
                frame:StopMovingOrSizing();
                frame.isMoving = false;

                -- save the position
                EngInventoryConfig["frameLEFT"] = frame:GetLeft() * frame:GetScale();
                EngInventoryConfig["frameRIGHT"] = frame:GetRight() * frame:GetScale();
                EngInventoryConfig["frameTOP"] = frame:GetTop() * frame:GetScale();
                EngInventoryConfig["frameBOTTOM"] = frame:GetBottom() * frame:GetScale();

                EngInventory_PrintDEBUG("new position:  top="..EngInventoryConfig["frameTOP"]..", bottom="..EngInventoryConfig["frameBOTTOM"]..", left="..EngInventoryConfig["frameLEFT"]..", right="..EngInventoryConfig["frameRIGHT"] );
        end
end

function EngInventory_OnMouseDown(button, frame)

	if ( button == "LeftButton" ) then
		EngInventory_StartMoving(frame);
	elseif ( button == "RightButton" ) then
		HideDropDownMenu(1);
		EngInventory_RightClickMenu_mode = "mainwindow";
		EngInventory_RightClickMenu_opts = {};
		ToggleDropDownMenu(1, nil, EngInventory_frame_RightClickMenu, "cursor", 0, 0);
	end

end


--	EngInventory_resort_required: ENGINVENTORY_NOTNEEDED, ENGINVENTORY_REQUIRED, ENGINVENTORY_MANDATORY
--	EngInventory_window_update_required: ENGINVENTORY_NOTNEEDED, ENGINVENTORY_REQUIRED, ENGINVENTORY_MANDATORY
--	EngInventory_item_cache[ bag ][ slot ]
function EngInventory_Update_item_cache()
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

	for bagnum = 0, 4 do
		if (EngInventoryConfig["show_Bag"..bagnum] == 1) then
			if (EngInventory_item_cache[bagnum] == nil) then
				EngInventory_item_cache[bagnum] = {};
			end

			bagNumSlots = GetContainerNumSlots(bagnum);

			if (bagNumSlots > 0) then
				is_shot_bag = EngInventory_IsShotBag(bagnum);
				for slotnum = 1, bagNumSlots do
					if (EngInventory_item_cache[bagnum][slotnum] == nil) then
						EngInventory_item_cache[bagnum][slotnum] = { ["keywords"] = {} };
					end

					sequencial_slot_num = sequencial_slot_num + 1;
					itm = {
						["itemlink"] = GetContainerItemLink(bagnum, slotnum);
						["bagnum"] = bagnum,
						["slotnum"] = slotnum,
						["sequencial_slot_num"] = sequencial_slot_num,
						-- take items from old position
						["bar"] = EngInventory_item_cache[bagnum][slotnum]["bar"],
						["button_num"] = EngInventory_item_cache[bagnum][slotnum]["button_num"],
						["indexed_on"] = EngInventory_item_cache[bagnum][slotnum]["indexed_on"],
						["display_string"] = EngInventory_item_cache[bagnum][slotnum]["display_string"],
						["barClass"] = EngInventory_item_cache[bagnum][slotnum]["barClass"],
						["button_num"] = EngInventory_item_cache[bagnum][slotnum]["button_num"],	-- assigned when drawing
						["keywords"] = EngInventory_item_cache[bagnum][slotnum]["keywords"],
						["itemlink_override_key"] = EngInventory_item_cache[bagnum][slotnum]["itemlink_override_key"],
						-- misc junk
						["search_match"] = EngInventory_item_cache[bagnum][slotnum]["search_match"],
						["gametooltip"] = EngInventory_item_cache[bagnum][slotnum]["gametooltip"]
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

					if (itm["locked"] ~= EngInventory_item_cache[bagnum][slotnum]["locked"]) then
						update_suggested = 1;
					end

					if (
						(itm["itemlink"] ~= EngInventory_item_cache[bagnum][slotnum]["itemlink"]) or
						(itm["keywords"]["SHOT_BAG"] ~= EngInventory_item_cache[bagnum][slotnum]["keywords"]["SHOT_BAG"])
						) then
						-- the item changed
						if (itm["indexed_on"] ~= nil) then
							resort_suggested = 1;
							itm["indexed_on"] = GetTime();
							itm["display_string"] = "newItemText";
						end
					else
						-- item has not changed, maybe the count did?
						if ( (itm["itemcount"] ~= EngInventory_item_cache[bagnum][slotnum]["itemcount"]) and (EngInventory_item_cache[bagnum][slotnum]["itemcount"] ~= nil) ) then
							update_suggested = 1;
							if (itm["itemcount"] < EngInventory_item_cache[bagnum][slotnum]["itemcount"]) then
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

					EngInventory_item_cache[bagnum][slotnum] = itm;	-- save updated information
				end
			else
				-- bagNumSlots = 0, make sure you wipe the cache entry
				if (table.getn(EngInventory_item_cache[bagnum]) ~= 0) then
					resort_mandatory = 1;
				end
				EngInventory_item_cache[bagnum] = {};
			end
		end
	end

	if (resort_mandatory == 1) then
		EngInventory_resort_required = ENGINVENTORY_MANDATORY;
		EngInventory_window_update_required = ENGINVENTORY_MANDATORY;
	elseif (resort_suggested == 1) then
		EngInventory_resort_required = math.max(EngInventory_resort_required, ENGINVENTORY_REQUIRED);
		EngInventory_window_update_required = ENGINVENTORY_MANDATORY;
	elseif (update_suggested == 1) then
		EngInventory_window_update_required = ENGINVENTORY_MANDATORY;
	end
end



-- Take an item and figure out what "bar" you want to place it in
--              return selected_bar, barClass;
function EngInventory_PickBar(itm)
        if (itm["itemlink"] == nil) then
                if (itm["keywords"]["SHOT_BAG"]) then
			itm["bar"] = EngInventoryConfig["putinslot--EMPTY_PROJECTILE_SLOTS"];
			while (type(itm["bar"]) ~= "number") do
				itm["bar"] = EngInventoryConfig[itm["bar"]];
			end
			itm["barClass"] = "EMPTY_PROJECTILE_SLOTS";
                        return itm;
                else
			itm["bar"] = EngInventoryConfig["putinslot--EMPTY_SLOTS"];
			while (type(itm["bar"]) ~= "number") do
				itm["bar"] = EngInventoryConfig[itm["bar"]];
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
		if ( (EngInventoryConfig[ENGINVENTORY_PLAYERID]["tradeskill_items"] ~= nil) and (EngInventoryConfig[ENGINVENTORY_PLAYERID]["tradeskill_items"][ itm["itemlink_noninstance"] ] ~= nil) ) then
			-- the item exists in our cache
			if (EngInventoryConfig[ENGINVENTORY_PLAYERID]["tradeskill_items"][ itm["itemlink_noninstance"] ][ENGINVENTORY_TRADE1] ~= nil) then
				itm["keywords"]["TRADESKILL_1"] = 1;
			elseif (EngInventoryConfig[ENGINVENTORY_PLAYERID]["tradeskill_items"][ itm["itemlink_noninstance"] ][ENGINVENTORY_TRADE2] ~= nil) then
				itm["keywords"]["TRADESKILL_2"] = 1;
			elseif (EngInventoryConfig[ENGINVENTORY_PLAYERID]["tradeskill_items"][ itm["itemlink_noninstance"] ][EILocal["Cooking"]] ~= nil) then
				itm["keywords"]["TRADESKILL_COOKING"] = 1;
			elseif (EngInventoryConfig[ENGINVENTORY_PLAYERID]["tradeskill_items"][ itm["itemlink_noninstance"] ][EILocal["First Aid"]] ~= nil) then
				itm["keywords"]["TRADESKILL_FIRSTAID"] = 1;
			end
		end

		-- setup tradeskill produced items keywords
		if ( (EngInventoryConfig[ENGINVENTORY_PLAYERID]["tradeskill_production"] ~= nil) and (EngInventoryConfig[ENGINVENTORY_PLAYERID]["tradeskill_production"][ itm["itemlink_noninstance"] ] ~= nil) ) then
			if (EngInventoryConfig[ENGINVENTORY_PLAYERID]["tradeskill_production"][ itm["itemlink_noninstance"] ][ENGINVENTORY_TRADE1] ~= nil) then
				itm["keywords"]["TRADESKILL_1_CREATED"] = 1;
			elseif (EngInventoryConfig[ENGINVENTORY_PLAYERID]["tradeskill_production"][ itm["itemlink_noninstance"] ][ENGINVENTORY_TRADE2] ~= nil) then
				itm["keywords"]["TRADESKILL_2_CREATED"] = 1;
			end
			-- not doing cooking or first aid.
		end

		-- setup equipped items keywords
		if ( EngInventoryConfig[ENGINVENTORY_PLAYERID]["equipped_items"] ~= nil ) then
			if (EngInventoryConfig[ENGINVENTORY_PLAYERID]["equipped_items"][ itm["itemlink_noninstance"] ] ~= nil) then
				itm["keywords"]["EQUIPPED"] = 1;
			end
		end

		-- Load tooltip
		EngInventory_tt:SetOwner(UIParent, "ANCHOR_NONE");	-- this makes sure that tooltip.valid = true

		EngInventory_tt:SetBagItem(itm["bagnum"],itm["slotnum"]);
		idx = 1;
		tmptooltip = getglobal("EngInventory_ttTextLeft"..idx);
		tooltip_info_concat = "";
		itm["gametooltip"] = {};
		repeat
			tmpval = tmptooltip:GetText();

			if (tmpval ~= nil) then
				tooltip_info_concat = tooltip_info_concat.." "..tmpval;
				itm["gametooltip"][idx] = tmpval;
			end

			idx=idx+1;
			tmptooltip = getglobal("EngInventory_ttTextLeft"..idx);
		until (tmpval==nil) or (tmptooltip==nil);

		if (string.find(tooltip_info_concat, EILocal["soulbound_search"] )) then
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
		itm["barClass"] = EngInventoryConfig["item_overrides"][itm["itemlink_override_key"]];
		if (itm["barClass"] ~= nil) then
			itm["search_match"] = "item_override found";

			itm["bar"] = EngInventoryConfig["putinslot--"..itm["barClass"]];
			while ( (itm["bar"] ~= nil) and (type(itm["bar"]) ~= "number") ) do
				itm["bar"] = EngInventoryConfig[itm["bar"]];
			end
			if (type(itm["bar"]) ~= "number") then
				itm["barClass"] = nil;
			end
		end

		if (itm["barClass"] == nil) then
			for key,value in EngInventoryConfig["item_search_list"] do
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
						itm["bar"] = EngInventoryConfig["putinslot--"..itm["barClass"]];
						while ( (itm["bar"] ~= nil) and (type(itm["bar"]) ~= "number") ) do
							itm["bar"] = EngInventoryConfig[itm["bar"]];
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

			itm["bar"] = EngInventoryConfig["putinslot--"..itm["barClass"]];
			while ( (itm["bar"] ~= nil) and (type(itm["bar"]) ~= "number") ) do
				itm["bar"] = EngInventoryConfig[itm["bar"]];
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
	Call EngInventory_Update_item_cache() before calling this

	EngInventory_item_cache[ bagnum ][ slotnum ]
	EngInventory_bar_positions[ bar_number ][ position ] = { ["bagnum"]=bagnum, ["slotnum"]=slotnum }
--]]
function EngInventory_Sort_item_cache()
	local i;
	local bagnum, slotnum;
	-- variables used in outer loop
	local bagNumSlots;
	-- variables used in inner loop
	----- 2nd loop
	local barnum;

	--Print("Resorting Items");

	-- wipe the current bar positions table
	EngInventory_bar_positions = {};
	for i = 1, ENGINVENTORY_MAX_BARS do
		EngInventory_bar_positions[i] = {};
	end

	for bagnum = 0, 4 do
		if (EngInventoryConfig["show_Bag"..bagnum] == 1) then
			bagNumSlots = table.getn( EngInventory_item_cache[bagnum] );
			if (bagNumSlots > 0) then
				for slotnum = 1, bagNumSlots do
					EngInventory_item_cache[bagnum][slotnum] = EngInventory_PickBar( EngInventory_item_cache[bagnum][slotnum] );

					table.insert( EngInventory_bar_positions[ EngInventory_item_cache[bagnum][slotnum]["bar"] ], { ["bagnum"]=bagnum, ["slotnum"]=slotnum } );
				end
			end
		end
	end

        -- sort the cache now
        for barnum = 1, ENGINVENTORY_MAX_BARS do
                if (EngInventoryConfig["bar_sort_"..barnum] == ENGINVENTORY_SORTBYNAME) then
                        table.sort(EngInventory_bar_positions[barnum],
                                function(a,b)
                                        return  EngInventory_item_cache[a["bagnum"]][a["slotnum"]]["barClass"]..
						EngInventory_item_cache[a["bagnum"]][a["slotnum"]]["itemsubtype"]..
						EngInventory_item_cache[a["bagnum"]][a["slotnum"]]["itemname"]..
						string.format("%04s", EngInventory_item_cache[a["bagnum"]][a["slotnum"]]["itemcount"])
							>
                                                EngInventory_item_cache[b["bagnum"]][b["slotnum"]]["barClass"]..
						EngInventory_item_cache[b["bagnum"]][b["slotnum"]]["itemsubtype"]..
						EngInventory_item_cache[b["bagnum"]][b["slotnum"]]["itemname"]..
						string.format("%04s", EngInventory_item_cache[b["bagnum"]][b["slotnum"]]["itemcount"])
                                end);
                elseif (EngInventoryConfig["bar_sort_"..barnum] == ENGINVENTORY_SORTBYNAMEREV) then
                        table.sort(EngInventory_bar_positions[barnum],
                                function(a,b)
                                        return  EngInventory_item_cache[a["bagnum"]][a["slotnum"]]["barClass"]..
						EngInventory_item_cache[a["bagnum"]][a["slotnum"]]["itemsubtype"]..
						EngInventory_ReverseString(
							EngInventory_item_cache[a["bagnum"]][a["slotnum"]]["itemname"])..
							string.format("%04s",EngInventory_item_cache[a["bagnum"]][a["slotnum"]]["itemcount"]
							)
								>
                                                EngInventory_item_cache[b["bagnum"]][b["slotnum"]]["barClass"]..
						EngInventory_item_cache[b["bagnum"]][b["slotnum"]]["itemsubtype"]..
						EngInventory_ReverseString(
							EngInventory_item_cache[b["bagnum"]][b["slotnum"]]["itemname"])..
							string.format("%04s",EngInventory_item_cache[b["bagnum"]][b["slotnum"]]["itemcount"]
							)
                                end);
                end
        end

	EngInventory_resort_required = ENGINVENTORY_NOTNEEDED;
	EngInventory_window_update_required = ENGINVENTORY_MANDATORY;
end


-- Make an inventory slot usable with the item specified in itm
-- cache entry is the array that comes directly from the cache
function EngInventory_UpdateButton(itemframe, itm)
        local ic_start, ic_duration, ic_enable;
        local showSell = nil;
        local itemframe_texture = getglobal(itemframe:GetName().."IconTexture");
	local itemframe_normaltexture = getglobal(itemframe:GetName().."NormalTexture");
        local itemframe_font = getglobal(itemframe:GetName().."Count");
        local itemframe_bkgr = getglobal(itemframe:GetName().."_bkgr");
        local itemframe_stock = getglobal(itemframe:GetName().."Stock");
        local cooldownFrame = getglobal(itemframe:GetName().."_Cooldown");

        if ( EILocal["_loaded"]==0 ) then
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

        if ( EngInventory_edit_mode == 1 ) then
                -- we should be hilighting an entire class of item
                if ( itm["barClass"] ~= EngInventory_edit_hilight ) then
                        -- dim this item
                        itemframe_texture:SetVertexColor(1,1,1,0.15);
                        itemframe_font:SetVertexColor(1,1,1,0.5);
                        itemframe_bkgr:SetVertexColor(0.4,0.4,0.4,1);
                else
                        -- hilight this item
                        itemframe_texture:SetVertexColor(1,1,0,1);
                        itemframe_font:SetVertexColor(1,1,0,1);
                        itemframe_bkgr:SetVertexColor(1,1,1,1);
                end
        else
                -- no hilights, just do your normal work

                if ( (EngInventoryConfig["allow_new_in_bar_"..itm["bar"]] == 1) and (itm["itemlink"] ~= nil) and (itm["indexed_on"]>1) and ((GetTime()-itm["indexed_on"]) < EngInventoryConfig["newItemTimeout"]) ) then
                        -- item is still new, display the "new" text.
                        itemframe_stock:SetText( EngInventoryConfig[itm["display_string"]] );
                        if ( (GetTime()-itm["indexed_on"]) < EngInventoryConfig["newItemTimeout2"]) then
                                -- use color #2
                                itemframe_stock:SetTextColor(
                                        EngInventoryConfig["newItemColor2_R"],
                                        EngInventoryConfig["newItemColor2_G"],
                                        EngInventoryConfig["newItemColor2_B"] );
                                itemframe_font:SetVertexColor(
                                        EngInventoryConfig["newItemColor2_R"],
                                        EngInventoryConfig["newItemColor2_G"],
                                        EngInventoryConfig["newItemColor2_B"], 1 );
                        else
                                -- use color #1
                                itemframe_stock:SetTextColor(
                                        EngInventoryConfig["newItemColor1_R"],
                                        EngInventoryConfig["newItemColor1_G"],
                                        EngInventoryConfig["newItemColor1_B"] );
                                itemframe_font:SetVertexColor(
                                        EngInventoryConfig["newItemColor1_R"],
                                        EngInventoryConfig["newItemColor1_G"],
                                        EngInventoryConfig["newItemColor1_B"], 1 );
                        end
                        itemframe_stock:Show();
                        itemframe_texture:SetVertexColor(1,1,1,1);
                else
                        itemframe_stock:Hide();
                        if (EngInventory_hilight_new == 1) then
                                itemframe_texture:SetVertexColor(1,1,1,0.15);
                                itemframe_font:SetVertexColor(1,1,1,0.5);
                        else
                                itemframe_texture:SetVertexColor(1,1,1,1);
                                itemframe_font:SetVertexColor(1,1,1,1);
                        end
                end

                if (itm["itemRarity"] == nil) then
                        itemframe_bkgr:SetVertexColor(0.4,0.4,0.4,1);
			itemframe_normaltexture:SetVertexColor(0.4,0.4,0.4, 0.5);
                elseif (itm["itemRarity"] == 0) then     -- gray item
                        itemframe_bkgr:SetVertexColor(1,1,1,1);
			itemframe_normaltexture:SetVertexColor(1,1,1,1);
                elseif (itm["itemRarity"] == 1) then     -- white item
                        itemframe_bkgr:SetVertexColor(0.4,0.4,0.4,1);
			itemframe_normaltexture:SetVertexColor(0.4,0.4,0.4, 0.5);
                elseif (itm["itemRarity"] == 2) then     -- green item
                        itemframe_bkgr:SetVertexColor(0,1,0.25,1);
			itemframe_normaltexture:SetVertexColor(0,1,0.25, 0.5);
                elseif (itm["itemRarity"] == 3) then     -- blue item
                        itemframe_bkgr:SetVertexColor(0.5,0.5,1,1);
			itemframe_normaltexture:SetVertexColor(0.5,0.5,1, 0.5);
                elseif (itm["itemRarity"] == 4) then     -- purple item
                        itemframe_bkgr:SetVertexColor(1,0,1,1);
			itemframe_normaltexture:SetVertexColor(1,0,1, 0.5);
                else    -- ?!
                        itemframe_bkgr:SetVertexColor(1,0,0,1);
			itemframe_normaltexture:SetVertexColor(1,0,0, 0.5);
                end
        end

        SetItemButtonDesaturated(itemframe, itm["locked"], 0.5, 0.5, 0.5);
        SetItemButtonCount(itemframe, itm["itemcount"]);

	-- resize itemframe texture (this is the little border)
	itemframe_normaltexture:SetWidth(ENGINVENTORY_BKGRFRAME_WIDTH);
	itemframe_normaltexture:SetHeight(ENGINVENTORY_BKGRFRAME_HEIGHT);

	-- resize and position fonts
	--itemframe_font.font = "Interface\Addons\EngInventory\DAB_CooldownFont.ttf";
	itemframe_font:SetTextHeight( ENGINVENTORY_BUTTONFONTHEIGHT );	-- count, bottomright
	itemframe_font:ClearAllPoints();
	itemframe_font:SetPoint("BOTTOMRIGHT", itemframe:GetName(), "BOTTOMRIGHT", 0-ENGINVENTORY_BUTTONFONTDISTANCE_X, ENGINVENTORY_BUTTONFONTDISTANCE_Y );
	
	--itemframe_stock.font = "Interface\Addons\EngInventory\DAB_CooldownFont.ttf";
	itemframe_stock:SetTextHeight( ENGINVENTORY_BUTTONFONTHEIGHT2 );	-- stock, topleft
	itemframe_stock:ClearAllPoints();
	itemframe_stock:SetPoint("TOPLEFT", itemframe:GetName(), "TOPLEFT", (ENGINVENTORY_BUTTONFONTDISTANCE_X / 2), 0-ENGINVENTORY_BUTTONFONTDISTANCE_Y );
	
        -- Set cooldown
        CooldownFrame_SetTimer(cooldownFrame, ic_start, ic_duration, ic_enable);
        if ( ( ic_duration > 0 ) and ( ic_enable == 0 ) ) then
                SetItemButtonTextureVertexColor(itemframe, 0.4, 0.4, 0.4);
        end

	cooldownFrame:SetScale(ENGINVENTORY_COOLDOWN_SCALE);

end


function EngInventory_GetBarPositionAndCache()
        local bar, position, itm;
	local bagnum, slotnum;

        if (EngInventory_buttons[this:GetName()] ~= nil) then
                bar = EngInventory_buttons[this:GetName()]["bar"];
                position = EngInventory_buttons[this:GetName()]["position"];

		bagnum = EngInventory_bar_positions[bar][position]["bagnum"];
		slotnum = EngInventory_bar_positions[bar][position]["slotnum"];

                itm = EngInventory_item_cache[bagnum][slotnum];

                return bar,position,itm;
        else
                return nil,nil,nil;
        end

end

function EngInventory_ItemButton_OnEnter()
        --AllInOneInventory_Patching_Tooltip = 1;
        local bar,position,itm = EngInventory_GetBarPositionAndCache();

        if (EngInventory_edit_selected == "") then
                EngInventory_edit_hilight = itm["barClass"];
        end

        if ( not itm["itemlink"]) then
                if ( EngInventory_edit_mode == 1 ) then
                        GameTooltip:SetOwner(this, "ANCHOR_LEFT");
                        GameTooltip:ClearLines();
                        GameTooltip:AddLine("Empty Slot", 1,1,1 );

                        -- move by class
                        if (itm["barClass"] ~= nil) then
				if (EngInventory_edit_selected ~= "") then
		                        GameTooltip:AddLine("|cFF00FF7FLeft click to move catagory |r"..EngInventory_edit_selected.."|cFF00FF7F to bar |r"..bar, 1,0.25,0.5 );
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
                if ( EngInventory_edit_mode == 1 ) then
			-- redraw the window to show the hilighting of entire class items
			EngInventory_window_update_required = ENGINVENTORY_MANDATORY;
                        EngInventory_UpdateWindow();
                end
                return;
        end
        GameTooltip:SetOwner(this, "ANCHOR_LEFT");

        local hasCooldown, repairCost = GameTooltip:SetBagItem(itm["bagnum"], itm["slotnum"]);
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
                EngInventory_RegisterCurrentTooltipSellValue(GameTooltip, itm["bagnum"], itm["slotnum"], itm);
        elseif ( this.readable ) then
                ShowInspectCursor();
        end

        if ( EngInventory_edit_mode == 1 ) then
                -- move by class
                if (itm["barClass"] ~= nil) then
			if (EngInventory_edit_selected ~= "") then
				GameTooltip:AddLine("|cFF00FF7FLeft click to move catagory |r"..EngInventory_edit_selected.."|cFF00FF7F to bar |r"..bar, 1,0.25,0.5 );
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

        EngInventory_ModifyItemTooltip(itm["bagnum"], itm["slotnum"], "GameTooltip", itm);

        if ( EngInventory_edit_mode == 1 ) then
		-- redraw the window to show the hllighting of entire class items
		EngInventory_window_update_required = ENGINVENTORY_MANDATORY;
                EngInventory_UpdateWindow();
        end
        --AllInOneInventory_Patching_Tooltip = 0;
end

function EngInventory_OnUpdate(elapsed)
        if ( not this.updateTooltip ) then
                return;
        end

        this.updateTooltip = this.updateTooltip - elapsed;
        if ( this.updateTooltip > 0 ) then
                return;
        end

        if ( GameTooltip:IsOwned(this) ) then
                EngInventory_ItemButton_OnEnter();
        else
                this.updateTooltip = nil;
        end
end

function EngInventory_ItemButton_OnLeave()
        EngInventory_PrintDEBUG("ei_button: OnLeave()  this="..this:GetName() );

        if (EngInventory_edit_selected == "") then
                EngInventory_edit_hilight = "";
        end
        this.updateTooltip = nil;
        if ( GameTooltip:IsOwned(this) ) then
                GameTooltip:Hide();
                ResetCursor();
        end

        if ( EngInventory_edit_mode == 1 ) then
		-- redraw the window to remove the hilighting of entire class items
		EngInventory_window_update_required = ENGINVENTORY_MANDATORY;
                EngInventory_UpdateWindow();
        end
end

function EngInventory_ItemButton_OnClick(button, ignoreShift)
        local bar, position, itm, bagnum, slotnum;

        if (EngInventory_buttons[this:GetName()] ~= nil) then
                bar = EngInventory_buttons[this:GetName()]["bar"];
                position = EngInventory_buttons[this:GetName()]["position"];

		bagnum = EngInventory_bar_positions[bar][position]["bagnum"];
		slotnum = EngInventory_bar_positions[bar][position]["slotnum"];

                itm = EngInventory_item_cache[bagnum][slotnum];
        end

        if (EngInventory_edit_mode == 1) then
                -- don't do normal actions to this button, we're in edit mode
                if ( button == "LeftButton" ) then
                        if (EngInventory_edit_selected == "") then
                                -- you clicked, we selected
                                EngInventory_edit_selected = itm["barClass"];
                                EngInventory_edit_hilight = itm["barClass"];
                        else
                                -- we got a click, and we already had one selected.  let's move the items
                                EngInventoryConfig["putinslot--"..EngInventory_edit_selected] = bar;
				EngInventory_resort_required = ENGINVENTORY_MANDATORY;

                                EngInventory_edit_selected = "";
                                EngInventory_edit_hilight = itm["barClass"];

				-- resort will force a window update
                                EngInventory_UpdateWindow();
                        end
		elseif ( button == "RightButton" ) then
			HideDropDownMenu(1);
			EngInventory_RightClickMenu_mode = "item";
			EngInventory_RightClickMenu_opts = {
				["bar"] = bar,
				["position"] = position,
				["bagnum"] = bagnum,
				["slotnum"] = slotnum
				};
			ToggleDropDownMenu(1, nil, EngInventory_frame_RightClickMenu, this:GetName(), -50, 0);
                end
        else
                -- process normal clicks
		if (getglobal("AxuItemMenus_FillUtilityVariables") ~= nil) then
			if ( ENGINVENTORY_DONT_CALL_AXUITEM == nil ) then
				if (AxuItemMenus_EvocationTest(button)) then
					AxuItemMenus_FillUtilityVariables(itm["bagnum"], itm["slotnum"]);
					AxuItemMenus_OpenMenu();
					return;
				end
			else
				if (getglobal("AxuItemMenus_EngInventoryHook") ~= nil) then
					if (AxuItemMenus_EngInventoryHook(itm["bagnum"], itm["slotnum"]) == 1) then
						return;
					end
				end
			end
		--else
		--	EngInventory_PrintDEBUG("AxuItemMenus not detected");
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

                                                        if (EngInventory_buttons[this:GetName()] ~= nil) then
								bar = EngInventory_buttons[this:GetName()]["bar"];
								position = EngInventory_buttons[this:GetName()]["position"];

								bagnum = EngInventory_bar_positions[bar][position]["bagnum"];
								slotnum = EngInventory_bar_positions[bar][position]["slotnum"];

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
		EngInventory_window_update_required = ENGINVENTORY_MANDATORY;
		EngInventory_UpdateWindow();
        end
end

function EngInventory_RightClick_PickupItem()
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

function EngInventory_Button_HighlightToggle_OnClick()
	PlaySound("igMainMenuOptionCheckBoxOn");
	if (EngInventory_hilight_new == 0) then
		EngInventory_hilight_new = 1;
		EngInventory_Button_HighlightToggle:SetText(EILocal["EngInventory_Button_HighlightToggle_on"]);
	else
		EngInventory_hilight_new = 0;
		EngInventory_Button_HighlightToggle:SetText(EILocal["EngInventory_Button_HighlightToggle_off"]);
	end
	EngInventory_window_update_required = ENGINVENTORY_MANDATORY;
	EngInventory_UpdateWindow();
end

function EngInventory_Button_ChangeEditMode_OnClick()
	PlaySound("igMainMenuOptionCheckBoxOn");
	if (EngInventory_edit_mode == 0) then
		EngInventory_edit_mode = 1;
		EngInventory_Button_ChangeEditMode:SetText(EILocal["EngInventory_Button_ChangeEditMode_MoveClass"]);
	--elseif (EngInventory_edit_mode == 1) then
	--	EngInventory_edit_mode = 2;
	--	this:SetText(EILocal["EngInventory_Button_ChangeEditMode_MoveItem"]);
	else
		EngInventory_edit_mode = 0;
		EngInventory_Button_ChangeEditMode:SetText(EILocal["EngInventory_Button_ChangeEditMode_off"]);
	end
	EngInventory_resort_required = ENGINVENTORY_MANDATORY;
	-- resort will force a window redraw
	EngInventory_UpdateWindow();
end

function EngInventory_Button_MoveLockToggle_OnClick()
	PlaySound("igMainMenuOptionCheckBoxOn");
	if (EngInventoryConfig["moveLock"] == 0) then
		EngInventoryConfig["moveLock"] = 1;
		EngInventory_Button_MoveLockToggle:SetText(EILocal["EngInventory_Button_MoveLock_unlocked"]);
	else
		EngInventoryConfig["moveLock"] = 0;
		EngInventory_Button_MoveLockToggle:SetText(EILocal["EngInventory_Button_MoveLock_locked"]);
	end
end

function EngInventory_SlotTargetButton_OnClick(button, ignoreShift)
        local bar, tmp;

        if (EngInventory_edit_mode == 1) then
                for tmp in string.gfind(this:GetName(), "EngInventory_frame_SlotTarget_(%d+)") do
                        bar = tonumber(tmp);
                end

                if ( (bar == nil) or (bar < 1) or (bar > ENGINVENTORY_MAX_BARS) ) then
                        return;
                end

                if ( button == "LeftButton" ) then

                        if (EngInventory_edit_selected ~= "") then
                                -- we got a click, and we already had one selected.  let's move the items
                                EngInventoryConfig["putinslot--"..EngInventory_edit_selected] = bar;

                                EngInventory_edit_selected = "";
                                EngInventory_edit_hilight = "";

				EngInventory_resort_required = ENGINVENTORY_MANDATORY;
				-- resort will force a window redraw as well
                                EngInventory_UpdateWindow();
                        end

		elseif ( button == "RightButton" ) then

			HideDropDownMenu(1);
			EngInventory_RightClickMenu_mode = "slot_target";
			EngInventory_RightClickMenu_opts = {
				["bar"] = bar
				};
			ToggleDropDownMenu(1, nil, EngInventory_frame_RightClickMenu, this:GetName(), -50, 0);

                end
        end
end

function EngInventory_SlotTargetButton_OnEnter()
        local bar, tmp, key, value;

        if (EngInventory_edit_mode == 1) then
                for tmp in string.gfind(this:GetName(), "EngInventory_frame_SlotTarget_(%d+)") do
                        bar = tonumber(tmp);
                end

                if (EngInventory_edit_selected ~= "") then
                        GameTooltip:SetOwner(this, "ANCHOR_LEFT");
                        GameTooltip:ClearLines();
                        GameTooltip:AddLine("|cFF00FF7FLeft click to move catagory |r"..EngInventory_edit_selected.."|cFF00FF7F to bar |r"..bar, 1,0.25,0.5 );
                        GameTooltip:Show();
                        return;
		else
                        GameTooltip:SetOwner(this, "ANCHOR_LEFT");
                        GameTooltip:ClearLines();
                        GameTooltip:AddLine("|cFF00FF7FBar |r"..bar, 1,0.25,0.5 );
			--GameTooltip:AddLine(" ");
			for key,value in EngInventoryConfig do
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

function EngInventory_SlotTargetButton_OnLeave()
        this.updateTooltip = nil;
        if ( GameTooltip:IsOwned(this) ) then
                GameTooltip:Hide();
                ResetCursor();
        end
end

function EngInventory_SlotTargetButton_OnUpdate(elapsed)
        if ( not this.updateTooltip ) then
                return;
        end

        this.updateTooltip = this.updateTooltip - elapsed;
        if ( this.updateTooltip > 0 ) then
                return;
        end

        if ( GameTooltip:IsOwned(this) ) then
                EngInventory_SlotTargetButton_OnEnter();
        else
                this.updateTooltip = nil;
        end
end

function EngInventory_SetNewColor(previousValues)
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
			EngInventoryConfig["bar_colors_"..(UIDROPDOWNMENU_MENU_VALUE["bar"]).."_"..(UIDROPDOWNMENU_MENU_VALUE["element"]).."_r"] = r;
		end
		if (g ~= nil) then
			EngInventoryConfig["bar_colors_"..(UIDROPDOWNMENU_MENU_VALUE["bar"]).."_"..(UIDROPDOWNMENU_MENU_VALUE["element"]).."_g"] = g;
		end
		if (b ~= nil) then
			EngInventoryConfig["bar_colors_"..(UIDROPDOWNMENU_MENU_VALUE["bar"]).."_"..(UIDROPDOWNMENU_MENU_VALUE["element"]).."_b"] = b;
		end
		if (opacity ~= nil) then
			EngInventoryConfig["bar_colors_"..(UIDROPDOWNMENU_MENU_VALUE["bar"]).."_"..(UIDROPDOWNMENU_MENU_VALUE["element"]).."_a"] = opacity;
		end
		EngInventory_window_update_required = ENGINVENTORY_MANDATORY;
		EngInventory_UpdateWindow();
	end
end

function EngInventory_RightClick_DeleteItemOverride()
	local bagnum, slotnum, itm;

	bagnum = this.value["bagnum"];
	slotnum = this.value["slotnum"];

	if ( (bagnum ~= nil) and (slotnum ~= nil) ) then
		itm = EngInventory_item_cache[bagnum][slotnum];

		if ( (itm["itemlink_override_key"] ~= nil) and (EngInventoryConfig["item_overrides"][itm["itemlink_override_key"]] ~= nil) ) then
			EngInventoryConfig["item_overrides"] = EngInventory_Table_RemoveKey(EngInventoryConfig["item_overrides"], itm["itemlink_override_key"] );
			HideDropDownMenu(1);
			EngInventory_resort_required = ENGINVENTORY_MANDATORY;
			-- resort will force a window redraw as well
			EngInventory_UpdateWindow();
		end
	end
end

function EngInventory_RightClick_SetItemOverride()
	local bagnum, slotnum, itm, new_barclass;

	bagnum = this.value["bagnum"];
	slotnum = this.value["slotnum"];
	new_barclass = this.value["barclass"];

	if ( (bagnum ~= nil) and (slotnum ~= nil) and (new_barclass ~= nil) ) then
		itm = EngInventory_item_cache[bagnum][slotnum];

		EngInventoryConfig["item_overrides"][itm["itemlink_override_key"]] = new_barclass;
		HideDropDownMenu(2);
		HideDropDownMenu(1);
		EngInventory_resort_required = ENGINVENTORY_MANDATORY;
		EngInventory_UpdateWindow();
	end
end

function EngInventory_frame_RightClickMenu_populate(level)
	local bar, position, bagnum, slotnum;
	local info, itm, barclass, tmp, checked, i;
	local key, value, key2, value2;


	-------------------------------------------------------------------------------------------------
	------------------------------- ITEM CONTEXT MENU -----------------------------------------------
	-------------------------------------------------------------------------------------------------
	if (EngInventory_RightClickMenu_mode == "item") then
		-- we have a right click on a button

		bar = EngInventory_RightClickMenu_opts["bar"];
		position = EngInventory_RightClickMenu_opts["position"];
		bagnum = EngInventory_bar_positions[bar][position]["bagnum"];
		slotnum = EngInventory_bar_positions[bar][position]["slotnum"];
		itm = EngInventory_item_cache[bagnum][slotnum];

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
			if (EngInventoryConfig["item_overrides"][itm["itemlink_override_key"]] ~= nil) then
				info["checked"] = 1;
			end
			UIDropDownMenu_AddButton(info, level);

			info = {
				["text"] = "Use default catagory assignment",
				["value"] = { ["bagnum"]=bagnum, ["slotnum"]=slotnum },
				["func"] = EngInventory_RightClick_DeleteItemOverride
				};
			if (EngInventoryConfig["item_overrides"][itm["itemlink_override_key"]] == nil) then
				info["checked"] = 1;
			end
			UIDropDownMenu_AddButton(info, level);

			if (ENGINVENTORY_SHOWITEMDEBUGINFO==1) then
				info = { ["disabled"] = 1 };
				UIDropDownMenu_AddButton(info, level);

				info = { ["text"] = "Debug Info: ", ["hasArrow"] = 1, ["value"] = "show_debug" };
				UIDropDownMenu_AddButton(info, level);
			end
		elseif (level == 2) then
			if ( this.value == "override_placement" ) then
				for i = ENGINVENTORY_MAX_BARS, 1, -1 do
					info = {
						["text"] = "Catagories within bar "..i;
						["value"] = { ["opt"]="override_placement_select", ["bagnum"]=bagnum, ["slotnum"]=slotnum, ["select_bar"]=i },
						["hasArrow"] = 1
						};
					if ( (EngInventoryConfig["item_overrides"][itm["itemlink_override_key"]] ~= nil) and (EngInventoryConfig["putinslot--"..EngInventoryConfig["item_overrides"][itm["itemlink_override_key"]]] == i) ) then
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
					for key,barclass in EngInventory_Catagories(EngInventory_Catagories_Exclude_List, this.value["select_bar"]) do
						info = {
							["text"] = barclass;
							["value"] = { ["bagnum"]=bagnum, ["slotnum"]=slotnum, ["barclass"]=barclass },
							["func"] = EngInventory_RightClick_SetItemOverride
							};
						if (EngInventoryConfig["item_overrides"][itm["itemlink_override_key"]] == barclass) then
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
	elseif (EngInventory_RightClickMenu_mode == "slot_target") then
		-- right click on a slot
		bar = EngInventory_RightClickMenu_opts["bar"];

		info = { ["text"] = "Bar "..bar, ["notClickable"] = 1, ["isTitle"] = 1, ["notCheckable"] = nil };
		UIDropDownMenu_AddButton(info, level);

		info = { ["disabled"] = 1 };
		UIDropDownMenu_AddButton(info, level);

		for key,value in EngInventoryConfig do
			if ( (string.find(key, "putinslot--")) and (value==bar) and (not string.find(key, "__version")) ) then
				barclass = string.sub(key, 12);

				if ( type(value)=="number" ) then
					info = {
						["text"] = "Select: "..barclass;
						["value"] = barclass;
						["func"] = function()
								EngInventory_edit_selected = (this.value);
								EngInventory_edit_hilight = (this.value);
								EngInventory_window_update_required = ENGINVENTORY_MANDATORY;
								EngInventory_UpdateWindow();
							end
						};
					UIDropDownMenu_AddButton(info, level);
				else
					info = {
						["text"] = "Select: "..barclass.." => "..value,
						["value"] = value;
						["func"] = function()
								EngInventory_edit_selected = (this.value);
								EngInventory_edit_hilight = (this.value);
								EngInventory_window_update_required = ENGINVENTORY_MANDATORY;
								EngInventory_UpdateWindow();
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
			[ENGINVENTORY_NOSORT] = "No sort",
			[ENGINVENTORY_SORTBYNAME] = "Sort by name",
			[ENGINVENTORY_SORTBYNAMEREV] = "Sort last words first"
			} do

			if (EngInventoryConfig["bar_sort_"..bar] == key) then
				checked = 1;
			else
				checked = nil;
			end

			info = {
				["text"] = value;
				["value"] = { ["bar"]=bar, ["sortmode"]=key };
				["func"] = function()
						EngInventoryConfig["bar_sort_"..(this.value["bar"])] = (this.value["sortmode"]);
						EngInventory_resort_required = ENGINVENTORY_MANDATORY;
						EngInventory_UpdateWindow();			
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

			if (EngInventoryConfig["allow_new_in_bar_"..bar] == key) then
				checked = 1;
			else
				checked = nil;
			end

			info = {
				["text"] = value;
				["value"] = { ["bar"]=bar, ["value"]=key };
				["func"] = function()
						EngInventoryConfig["allow_new_in_bar_"..(this.value["bar"])] = (this.value["value"]);
						EngInventory_resort_required = ENGINVENTORY_MANDATORY;
						EngInventory_UpdateWindow();
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
			["r"] = EngInventoryConfig["bar_colors_"..bar.."_background_r"],
			["g"] = EngInventoryConfig["bar_colors_"..bar.."_background_g"],
			["b"] = EngInventoryConfig["bar_colors_"..bar.."_background_b"],
			["opacity"] = EngInventoryConfig["bar_colors_"..bar.."_background_a"],
			["notClickable"] = 1,
			["value"] = { ["bar"]=bar, ["element"] = "background" },
			["swatchFunc"] = EngInventory_SetNewColor,
			["cancelFunc"] = EngInventory_SetNewColor,
			["opacityFunc"] = EngInventory_SetNewColor
			};
		UIDropDownMenu_AddButton(info, level);
		info = {
			["text"] = "Border Color",
			["hasColorSwatch"] = 1,
			["hasOpacity"] = 1,
			["r"] = EngInventoryConfig["bar_colors_"..bar.."_border_r"],
			["g"] = EngInventoryConfig["bar_colors_"..bar.."_border_g"],
			["b"] = EngInventoryConfig["bar_colors_"..bar.."_border_b"],
			["opacity"] = EngInventoryConfig["bar_colors_"..bar.."_border_a"],
			["notClickable"] = 1,
			["value"] = { ["bar"]=bar, ["element"] = "border" },
			["swatchFunc"] = EngInventory_SetNewColor,
			["cancelFunc"] = EngInventory_SetNewColor,
			["opacityFunc"] = EngInventory_SetNewColor
			};
		UIDropDownMenu_AddButton(info, level);

	-------------------------------------------------------------------------------------------------
	------------------------ MAIN WINDOW CONTEXT MENU -----------------------------------------------
	-------------------------------------------------------------------------------------------------
	elseif (EngInventory_RightClickMenu_mode == "mainwindow") then
		if (level == 1) then

			info = { ["text"] = EILocal["RightClick_MenuTitle"], ["notClickable"] = 1, ["isTitle"] = 1, ["notCheckable"] = nil };
			UIDropDownMenu_AddButton(info, level);


			info = { ["disabled"] = 1 };
			UIDropDownMenu_AddButton(info, level);

			info = {
				["text"] = "Hilight New Items",
				["value"] = nil,
				["func"] = EngInventory_Button_HighlightToggle_OnClick
				};
			if (EngInventory_hilight_new == 1) then
				info["checked"] = 1;
			end
			UIDropDownMenu_AddButton(info, level);

			info = {
				["text"] = "Edit Mode",
				["value"] = nil,
				["func"] = EngInventory_Button_ChangeEditMode_OnClick
				};
			if (EngInventory_edit_mode == 1) then
				info["checked"] = 1;
			end
			UIDropDownMenu_AddButton(info, level);

			info = {
				["text"] = "Lock window",
				["value"] = nil,
				["func"] = EngInventory_Button_MoveLockToggle_OnClick
				};
			if (EngInventoryConfig["moveLock"] == 0) then
				info["checked"] = 1;
			end
			UIDropDownMenu_AddButton(info, level);

			info = {
				["text"] = "Show top buttons",
				["value"] = nil,
				["func"] = function()
						if (EngInventoryConfig["show_top_graphics"] == 0) then
							EngInventoryConfig["show_top_graphics"] = 1;
						else
							EngInventoryConfig["show_top_graphics"] = 0;
						end
						EngInventory_window_update_required = ENGINVENTORY_MANDATORY;
						EngInventory_UpdateWindow();
					end
				};
			if (EngInventoryConfig["show_top_graphics"] == 1) then
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

						for bagnum = 0, 4 do
							if (EngInventoryConfig["show_Bag"..bagnum] == 1) then
								if (table.getn(EngInventory_item_cache[bagnum]) > 0) then
									for slotnum = 1, table.getn(EngInventory_item_cache[bagnum]) do
										EngInventory_item_cache[bagnum][slotnum]["indexed_on"] = 1;
										EngInventory_item_cache[bagnum][slotnum]["display_string"] = "NewItemText_Off";
									end
								end
							end
						end

						EngInventory_window_update_required = ENGINVENTORY_MANDATORY;
						EngInventory_UpdateWindow();
					end
				};
			UIDropDownMenu_AddButton(info, level);

			info = { ["disabled"] = 1 };
			UIDropDownMenu_AddButton(info, level);

			info = {
				["text"] = "Advanced Configuration",
				["value"] = nil,
				["func"] = function()
						EngInventory_OptsFrame:Show();
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
				["r"] = EngInventoryConfig["bar_colors_"..ENGINVENTORY_MAINWINDOWCOLORIDX.."_background_r"],
				["g"] = EngInventoryConfig["bar_colors_"..ENGINVENTORY_MAINWINDOWCOLORIDX.."_background_g"],
				["b"] = EngInventoryConfig["bar_colors_"..ENGINVENTORY_MAINWINDOWCOLORIDX.."_background_b"],
				["opacity"] = EngInventoryConfig["bar_colors_"..ENGINVENTORY_MAINWINDOWCOLORIDX.."_background_a"],
				["notClickable"] = 1,
				["value"] = { ["bar"]=ENGINVENTORY_MAINWINDOWCOLORIDX, ["element"] = "background" },
				["swatchFunc"] = EngInventory_SetNewColor,
				["cancelFunc"] = EngInventory_SetNewColor,
				["opacityFunc"] = EngInventory_SetNewColor
				};
			UIDropDownMenu_AddButton(info, level);
			info = {
				["text"] = "Border Color",
				["hasColorSwatch"] = 1,
				["hasOpacity"] = 1,
				["r"] = EngInventoryConfig["bar_colors_"..ENGINVENTORY_MAINWINDOWCOLORIDX.."_border_r"],
				["g"] = EngInventoryConfig["bar_colors_"..ENGINVENTORY_MAINWINDOWCOLORIDX.."_border_g"],
				["b"] = EngInventoryConfig["bar_colors_"..ENGINVENTORY_MAINWINDOWCOLORIDX.."_border_b"],
				["opacity"] = EngInventoryConfig["bar_colors_"..ENGINVENTORY_MAINWINDOWCOLORIDX.."_border_a"],
				["notClickable"] = 1,
				["value"] = { ["bar"]=ENGINVENTORY_MAINWINDOWCOLORIDX, ["element"] = "border" },
				["swatchFunc"] = EngInventory_SetNewColor,
				["cancelFunc"] = EngInventory_SetNewColor,
				["opacityFunc"] = EngInventory_SetNewColor
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
										EngInventoryConfig["frameButtonSize"] = this.value;
										EngInventory_CalcButtonSize(EngInventoryConfig["frameButtonSize"]);
										EngInventory_window_update_required = ENGINVENTORY_MANDATORY;
										EngInventory_UpdateWindow();
									end
								end
							};
						if (EngInventoryConfig["frameButtonSize"] == value) then
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
function EngInventory_frame_RightClickMenu_OnLoad()
	UIDropDownMenu_Initialize(this, EngInventory_frame_RightClickMenu_populate, "MENU");
end


function EngInventory_IncreaseColumns()
	if (EngInventoryConfig["maxColumns"] < ENGINVENTORY_MAXCOLUMNS_MAX) then
		EngInventoryConfig["maxColumns"] = EngInventoryConfig["maxColumns"] + 1;
		EngInventory_window_update_required = ENGINVENTORY_MANDATORY;
		EngInventory_UpdateWindow();
	end
end

function EngInventory_DecreaseColumns()
	if (EngInventoryConfig["maxColumns"] > ENGINVENTORY_MAXCOLUMNS_MIN) then
		EngInventoryConfig["maxColumns"] = EngInventoryConfig["maxColumns"] - 1;
		EngInventory_window_update_required = ENGINVENTORY_MANDATORY;
		EngInventory_UpdateWindow();
	end
end

function EngInventory_MoveAndSizeFrame(frameName, childAttachPoint, parentFrameName, parentAttachPoint, xoffset, yoffset, width, height)
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
function EngInventory_AssignButtonsToFrame(barnum, currentbutton, frame, width, height)
        local cur_x, cur_y, tmpframe;
	local position;
	local bagnum, slotnum;

        cur_x = 0;
        cur_y = 0;

        if (table.getn(EngInventory_bar_positions[barnum]) > 0) then
                for position = 1, table.getn(EngInventory_bar_positions[barnum]) do
			bagnum = EngInventory_bar_positions[barnum][position]["bagnum"];
			slotnum = EngInventory_bar_positions[barnum][position]["slotnum"];

                        EngInventory_item_cache[bagnum][slotnum]["button_num"] = currentbutton;

                        EngInventory_MoveAndSizeFrame("EngInventory_frame_Item_"..currentbutton, "BOTTOMRIGHT",
                                frame, "BOTTOMRIGHT",
                                0-(
                                ((cur_x*ENGINVENTORY_BUTTONFRAME_WIDTH )+ENGINVENTORY_BUTTONFRAME_X_PADDING) + EngInventoryConfig["frameXSpace"]
                                ),
                                ((cur_y*ENGINVENTORY_BUTTONFRAME_HEIGHT)+ENGINVENTORY_BUTTONFRAME_Y_PADDING) + EngInventoryConfig["frameYSpace"],
                                ENGINVENTORY_BUTTONFRAME_BUTTONWIDTH,
                                ENGINVENTORY_BUTTONFRAME_BUTTONHEIGHT );
                        EngInventory_MoveAndSizeFrame("EngInventory_frame_Item_"..currentbutton.."_bkgr", "TOPLEFT",
                                "EngInventory_frame_Item_"..currentbutton, "TOPLEFT",
                                0-ENGINVENTORY_BUTTONFRAME_X_PADDING,
                                ENGINVENTORY_BUTTONFRAME_Y_PADDING,
                                ENGINVENTORY_BKGRFRAME_WIDTH,
                                ENGINVENTORY_BKGRFRAME_HEIGHT );

                        EngInventory_buttons["EngInventory_frame_Item_"..currentbutton] = { ["bar"]=barnum, ["position"]=position, ["bagnum"]=bagnum, ["slotnum"]=slotnum };
                        EngInventory_UpdateButton( getglobal("EngInventory_frame_Item_"..currentbutton), EngInventory_item_cache[bagnum][slotnum] );

                        cur_x = cur_x + 1;
                        if (cur_x == width) then
                                cur_x = 0;
                                cur_y = cur_y + 1;
                        end

                        currentbutton = currentbutton + 1;
                end
        end

        if (EngInventory_edit_mode == 1) then
                -- add extra button for targetting
                EngInventory_MoveAndSizeFrame("EngInventory_frame_SlotTarget_"..barnum, "BOTTOMRIGHT",
                        frame, "BOTTOMRIGHT",
                        0-(
                        (((width-1)*ENGINVENTORY_BUTTONFRAME_WIDTH )+ENGINVENTORY_BUTTONFRAME_X_PADDING) + EngInventoryConfig["frameXSpace"]
                        ),
                        (((height-1)*ENGINVENTORY_BUTTONFRAME_HEIGHT)+ENGINVENTORY_BUTTONFRAME_Y_PADDING) + EngInventoryConfig["frameYSpace"],
                        ENGINVENTORY_BUTTONFRAME_BUTTONWIDTH,
                        ENGINVENTORY_BUTTONFRAME_BUTTONHEIGHT );
                EngInventory_MoveAndSizeFrame("EngInventory_frame_SlotTarget_"..barnum.."_bkgr", "TOPLEFT",
                        "EngInventory_frame_SlotTarget_"..barnum, "TOPLEFT",
                        0-ENGINVENTORY_BUTTONFRAME_X_PADDING,
                        ENGINVENTORY_BUTTONFRAME_Y_PADDING,
                        ENGINVENTORY_BKGRFRAME_WIDTH,
                        ENGINVENTORY_BKGRFRAME_HEIGHT );
                
                tmpframe = getglobal("EngInventory_frame_SlotTarget_"..barnum.."_BigText");
                tmpframe:SetText( barnum );
                tmpframe:Show();
                tmpframe = getglobal("EngInventory_frame_SlotTarget_"..barnum.."_bkgr");
                tmpframe:SetVertexColor( 1,0,0.25, 0.5 );
        end

        return currentbutton;
end

EngInventory_WindowIsUpdating = 0;
function EngInventory_UpdateWindow()
        local frame = getglobal("EngInventory_frame");
        
        local currentbutton, barnum, slotnum;
        local barframe_one, barframe_two, barframe_three, tmpframe;
        local calc_dat, tmpcalc, cur_y;
        local available_width, width_in_between, mid_point;

        EngInventory_PrintDEBUG("ei: UpdateWindow()  WindowIsUpdating="..EngInventory_WindowIsUpdating );

        if (EngInventory_WindowIsUpdating == 1) then
                return;
        end
        EngInventory_WindowIsUpdating = 1;

        if ( EILocal["_loaded"]==0 ) then
                EngInventory_WindowIsUpdating = 0;
                return;
        end

        EngInventory_Update_item_cache();
	if (EngInventory_resort_required == ENGINVENTORY_MANDATORY) then
		EngInventory_Sort_item_cache();
	end

	if (EngInventory_edit_mode == 1) then
		EngInventory_WindowBottomPadding = ENGINVENTORY_WINDOWBOTTOMPADDING_EDITMODE;
	else
		EngInventory_WindowBottomPadding = ENGINVENTORY_WINDOWBOTTOMPADDING_NORMALMODE;
	end

	if (EngInventory_window_update_required > ENGINVENTORY_NOTNEEDED) then

		currentbutton = 1;
		cur_y = EngInventoryConfig["frameYSpace"] + EngInventory_WindowBottomPadding;
		for barnum = 1, ENGINVENTORY_MAX_BARS, 3 do
			barframe_one = getglobal("EngInventory_frame_bar_"..barnum);
			barframe_two = getglobal("EngInventory_frame_bar_"..(barnum+1));
			barframe_three = getglobal("EngInventory_frame_bar_"..(barnum+2));

			calc_dat = {};
			calc_dat = {
				["first"] = table.getn(EngInventory_bar_positions[barnum]),
				["second"] = table.getn(EngInventory_bar_positions[barnum+1]),
				["third"] = table.getn(EngInventory_bar_positions[barnum+2])
				};
			if (EngInventory_edit_mode == 1) then
				-- add an extra slot if we're in edit mode
				calc_dat["first"] = calc_dat["first"] + 1;
				calc_dat["second"] = calc_dat["second"] + 1;
				calc_dat["third"] = calc_dat["third"] + 1;
			else
				-- we're not in edit mode, make sure the SlotTarget button and texture is hidden
				tmpframe = getglobal("EngInventory_frame_SlotTarget_"..(barnum));
				tmpframe:Hide();
				tmpframe = getglobal("EngInventory_frame_SlotTarget_"..(barnum).."_bkgr");
				tmpframe:Hide();
				tmpframe = getglobal("EngInventory_frame_SlotTarget_"..(barnum+1));
				tmpframe:Hide();
				tmpframe = getglobal("EngInventory_frame_SlotTarget_"..(barnum+1).."_bkgr");
				tmpframe:Hide();
				tmpframe = getglobal("EngInventory_frame_SlotTarget_"..(barnum+2));
				tmpframe:Hide();
				tmpframe = getglobal("EngInventory_frame_SlotTarget_"..(barnum+2).."_bkgr");
				tmpframe:Hide();
			end
			calc_dat["total_in_row"] = calc_dat["first"] + calc_dat["second"] + calc_dat["third"];

			calc_dat["first_heighttable"] = {};
			if calc_dat["first"] > 0 then
				for tmpcalc = 1, calc_dat["first"] do
					calc_dat["first_heighttable"][tmpcalc] = math.ceil( calc_dat["first"] / tmpcalc );
				end
			end
			calc_dat["second_heighttable"] = {};
			if calc_dat["second"] > 0 then
				for tmpcalc = 1, calc_dat["second"] do
					calc_dat["second_heighttable"][tmpcalc] = math.ceil( calc_dat["second"] / tmpcalc );
				end
			end
			calc_dat["third_heighttable"] = {};
			if calc_dat["third"] > 0 then
				for tmpcalc = 1, calc_dat["third"] do
					calc_dat["third_heighttable"][tmpcalc] = math.ceil( calc_dat["third"] / tmpcalc );
				end
			end

			calc_dat["height"] = 0;
			repeat
				calc_dat["height"] = calc_dat["height"] + 1;
				tmpcalc = 0;
				if (calc_dat["first"] > 0) then
					if (calc_dat["first_heighttable"][calc_dat["height"]]) then
						tmpcalc = tmpcalc + calc_dat["first_heighttable"][calc_dat["height"]];
					else
						tmpcalc = tmpcalc + 1;
					end
				end
				if (calc_dat["second"] >        0) then
					if (calc_dat["second_heighttable"][calc_dat["height"]]) then
						tmpcalc = tmpcalc + calc_dat["second_heighttable"][calc_dat["height"]];
					else
						tmpcalc = tmpcalc + 1;
					end
				end
				if (calc_dat["third"] > 0) then
					if (calc_dat["third_heighttable"][calc_dat["height"]]) then
						tmpcalc = tmpcalc + calc_dat["third_heighttable"][calc_dat["height"]];
					else
						tmpcalc = tmpcalc + 1;
					end
				end
			until tmpcalc <= EngInventoryConfig["maxColumns"];

			if tmpcalc == 0 then
				calc_dat["height"] = 0;
			else

				-- at calc_dat["height"], everything fits
				if calc_dat["first"] > 0 then
					if (calc_dat["first_heighttable"][calc_dat["height"]]) then
						calc_dat["first_width"] = calc_dat["first_heighttable"][calc_dat["height"]];
					else
						calc_dat["first_width"] = 1;
					end
				else
					calc_dat["first_width"] = 0;
				end
				if calc_dat["second"] > 0 then
					if (calc_dat["second_heighttable"][calc_dat["height"]]) then
						calc_dat["second_width"] = calc_dat["second_heighttable"][calc_dat["height"]];
					else
						calc_dat["second_width"] = 1;
					end
				else
					calc_dat["second_width"] = 0;
				end
				if calc_dat["third"] > 0 then
					if (calc_dat["third_heighttable"][calc_dat["height"]]) then
						calc_dat["third_width"] = calc_dat["third_heighttable"][calc_dat["height"]];
					else
						calc_dat["third_width"] = 1;
					end
				else
					calc_dat["third_width"] = 0;
				end
			end

			--- now we know the size and height of all 3 bars for this line

			if (calc_dat["height"] == 0) then
				-- all 3 bars are not visible
				barframe_one:Hide();
				barframe_two:Hide();
				barframe_three:Hide();
			else
				available_width = (EngInventoryConfig["maxColumns"]*ENGINVENTORY_BUTTONFRAME_WIDTH) + (10*EngInventoryConfig["frameXSpace"]);

				------------------------------------------------------------------------------------------
				--------- FIRST BAR
				EngInventory_MoveAndSizeFrame("EngInventory_frame_bar_"..barnum, "BOTTOMRIGHT",
					"EngInventory_frame", "BOTTOMRIGHT",
					0-EngInventoryConfig["frameXSpace"],
					cur_y,
					(calc_dat["first_width"]*ENGINVENTORY_BUTTONFRAME_WIDTH)+(2*EngInventoryConfig["frameXSpace"]),
					(calc_dat["height"]*ENGINVENTORY_BUTTONFRAME_HEIGHT)+(2*EngInventoryConfig["frameYSpace"]) );
				barframe_one:SetBackdropColor(
					EngInventoryConfig["bar_colors_"..barnum.."_background_r"],
					EngInventoryConfig["bar_colors_"..barnum.."_background_g"],
					EngInventoryConfig["bar_colors_"..barnum.."_background_b"],
					EngInventoryConfig["bar_colors_"..barnum.."_background_a"] );
				barframe_one:SetBackdropBorderColor(
					EngInventoryConfig["bar_colors_"..barnum.."_border_r"],
					EngInventoryConfig["bar_colors_"..barnum.."_border_g"],
					EngInventoryConfig["bar_colors_"..barnum.."_border_b"],
					EngInventoryConfig["bar_colors_"..barnum.."_border_a"] );

				------------------------------------------------------------------------------------------
				--------- SECOND BAR
				if (calc_dat["second_width"] > 0) then
					width_in_between = available_width - (
						(EngInventoryConfig["frameXSpace"] * 4) +       -- border on both sides + borders between frames
						((calc_dat["first_width"]*ENGINVENTORY_BUTTONFRAME_WIDTH)+(2*EngInventoryConfig["frameXSpace"])) +      -- bar 1 size
						((calc_dat["third_width"]*ENGINVENTORY_BUTTONFRAME_WIDTH)+(2*EngInventoryConfig["frameXSpace"]))        -- bar 3 size
						);
					mid_point = (width_in_between/2) +
						((calc_dat["first_width"]*ENGINVENTORY_BUTTONFRAME_WIDTH)+(2*EngInventoryConfig["frameXSpace"])) +
						(EngInventoryConfig["frameXSpace"] * 2);


					EngInventory_MoveAndSizeFrame("EngInventory_frame_bar_"..(barnum+1), "BOTTOMRIGHT",
						"EngInventory_frame", "BOTTOMRIGHT",
						0-( mid_point - (((calc_dat["second_width"]*ENGINVENTORY_BUTTONFRAME_WIDTH)+(2*EngInventoryConfig["frameXSpace"]))/2) ),
						cur_y,
						(calc_dat["second_width"]*ENGINVENTORY_BUTTONFRAME_WIDTH)+(2*EngInventoryConfig["frameXSpace"]),
						(calc_dat["height"]*ENGINVENTORY_BUTTONFRAME_HEIGHT)+(2*EngInventoryConfig["frameYSpace"]) );
					barframe_two:SetBackdropColor(
						EngInventoryConfig["bar_colors_"..(barnum+1).."_background_r"],
						EngInventoryConfig["bar_colors_"..(barnum+1).."_background_g"],
						EngInventoryConfig["bar_colors_"..(barnum+1).."_background_b"],
						EngInventoryConfig["bar_colors_"..(barnum+1).."_background_a"] );
					barframe_two:SetBackdropBorderColor(
						EngInventoryConfig["bar_colors_"..(barnum+1).."_border_r"],
						EngInventoryConfig["bar_colors_"..(barnum+1).."_border_g"],
						EngInventoryConfig["bar_colors_"..(barnum+1).."_border_b"],
						EngInventoryConfig["bar_colors_"..(barnum+1).."_border_a"] );
				else
					barframe_two:Hide();
				end

				------------------------------------------------------------------------------------------
				--------- THIRD BAR
				EngInventory_MoveAndSizeFrame("EngInventory_frame_bar_"..(barnum+2), "BOTTOMRIGHT",
					"EngInventory_frame", "BOTTOMRIGHT",
					(0-available_width) +(calc_dat["third_width"]*ENGINVENTORY_BUTTONFRAME_WIDTH)+(3*EngInventoryConfig["frameXSpace"]),
					cur_y,
					(calc_dat["third_width"]*ENGINVENTORY_BUTTONFRAME_WIDTH)+(2*EngInventoryConfig["frameXSpace"]),
					(calc_dat["height"]*ENGINVENTORY_BUTTONFRAME_HEIGHT)+(2*EngInventoryConfig["frameYSpace"]) );
				barframe_three:SetBackdropColor(
					EngInventoryConfig["bar_colors_"..(barnum+2).."_background_r"],
					EngInventoryConfig["bar_colors_"..(barnum+2).."_background_g"],
					EngInventoryConfig["bar_colors_"..(barnum+2).."_background_b"],
					EngInventoryConfig["bar_colors_"..(barnum+2).."_background_a"] );
				barframe_three:SetBackdropBorderColor(
					EngInventoryConfig["bar_colors_"..(barnum+2).."_border_r"],
					EngInventoryConfig["bar_colors_"..(barnum+2).."_border_g"],
					EngInventoryConfig["bar_colors_"..(barnum+2).."_border_b"],
					EngInventoryConfig["bar_colors_"..(barnum+2).."_border_a"] );

				-----
				currentbutton = EngInventory_AssignButtonsToFrame(barnum, currentbutton,
					"EngInventory_frame_bar_"..(barnum),
					calc_dat["first_width"], calc_dat["height"] );
				currentbutton = EngInventory_AssignButtonsToFrame(barnum+1, currentbutton,
					"EngInventory_frame_bar_"..(barnum+1),
					calc_dat["second_width"], calc_dat["height"] );
				currentbutton = EngInventory_AssignButtonsToFrame(barnum+2, currentbutton,
					"EngInventory_frame_bar_"..(barnum+2),
					calc_dat["third_width"], calc_dat["height"] );

				cur_y = cur_y + (calc_dat["height"]*ENGINVENTORY_BUTTONFRAME_HEIGHT)+(3*EngInventoryConfig["frameYSpace"]);
			end
		end

		-- hide unused buttons
		if (currentbutton <= ENGINVENTORY_MAXBUTTONS) then
			for currentbutton = currentbutton, ENGINVENTORY_MAXBUTTONS do
				tmpframe = getglobal("EngInventory_frame_Item_"..(currentbutton));
				tmpframe:Hide();
				tmpframe = getglobal("EngInventory_frame_Item_"..(currentbutton).."_bkgr");
				tmpframe:Hide();
			end
		end

		local new_width = (EngInventoryConfig["maxColumns"]*ENGINVENTORY_BUTTONFRAME_WIDTH) + (10*EngInventoryConfig["frameXSpace"]);
		local new_height;
		
		if (EngInventoryConfig["show_top_graphics"] == 1) then
			new_height = cur_y + ENGINVENTORY_TOP_PADWINDOW;
		else
			new_height = cur_y;
		end

		frame:SetScale(EngInventoryConfig["frameWindowScale"]);
		frame:SetWidth( new_width );
		frame:SetHeight( new_height );

		frame:ClearAllPoints();
		frame:SetPoint(EngInventoryConfig["frameYRelativeTo"]..EngInventoryConfig["frameXRelativeTo"],
			"UIParent", "BOTTOMLEFT",
			EngInventoryConfig["frame"..EngInventoryConfig["frameXRelativeTo"]] / frame:GetScale(),
			EngInventoryConfig["frame"..EngInventoryConfig["frameYRelativeTo"]] / frame:GetScale());

		frame:SetBackdropColor(
			EngInventoryConfig["bar_colors_"..ENGINVENTORY_MAINWINDOWCOLORIDX.."_background_r"],
			EngInventoryConfig["bar_colors_"..ENGINVENTORY_MAINWINDOWCOLORIDX.."_background_g"],
			EngInventoryConfig["bar_colors_"..ENGINVENTORY_MAINWINDOWCOLORIDX.."_background_b"],
			EngInventoryConfig["bar_colors_"..ENGINVENTORY_MAINWINDOWCOLORIDX.."_background_a"] );
		frame:SetBackdropBorderColor(
			EngInventoryConfig["bar_colors_"..ENGINVENTORY_MAINWINDOWCOLORIDX.."_border_r"],
			EngInventoryConfig["bar_colors_"..ENGINVENTORY_MAINWINDOWCOLORIDX.."_border_g"],
			EngInventoryConfig["bar_colors_"..ENGINVENTORY_MAINWINDOWCOLORIDX.."_border_b"],
			EngInventoryConfig["bar_colors_"..ENGINVENTORY_MAINWINDOWCOLORIDX.."_border_a"] );

		EngInventory_MoneyFrame:Show();

		if (EngInventory_edit_mode == 1) then
			EngInventory_Button_ColumnsAdd:SetText(EILocal["EngInventory_Button_ColumnsAdd_buttontitle"]);
			EngInventory_Button_ColumnsAdd:Show();
			EngInventory_Button_ColumnsDel:SetText(EILocal["EngInventory_Button_ColumnsDel_buttontitle"]);
			EngInventory_Button_ColumnsDel:Show();
		else
			EngInventory_Button_ColumnsAdd:Hide();
			EngInventory_Button_ColumnsDel:Hide();
		end

		if (EngInventoryConfig["show_top_graphics"] == 1) then
			EngInventory_Button_Close:Show();
			EngInventory_Button_MoveLockToggle:Show();
			EngInventory_MoneyFrame:Show();
			EngInventory_Button_ChangeEditMode:Show();
			EngInventory_Button_HighlightToggle:Show();
		else
			-- hide all the top graphics
			EngInventory_Button_Close:Hide();
			EngInventory_Button_MoveLockToggle:Hide();
			EngInventory_MoneyFrame:Hide();
			EngInventory_Button_ChangeEditMode:Hide();
			EngInventory_Button_HighlightToggle:Hide();
		end
	end

	EngInventory_window_update_required = ENGINVENTORY_NOTNEEDED;

        EngInventory_WindowIsUpdating = 0;
end

