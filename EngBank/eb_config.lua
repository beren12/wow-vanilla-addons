
EngBank_ConfigOptions_Default = {
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
				return EngBankConfig["frameWindowScale"];
			end,
		  ["func"] = function(v)
				EngBankConfig["frameWindowScale"] = tonumber(v);
				EngBank_SetDefaultValues(0);
				EngBank_window_update_required = EngBank_MANDATORY;
				EngBank_UpdateWindow();
			end
		},
		{ ["type"] = "Text", ["ID"] = 3, ["width"] = 0.1, ["color"] = { 0,1,0.5 }, ["align"] = "left", ["text"] = "1.00" }
	},

	{	-- Window Columns
		{ ["type"] = "Text", ["ID"] = 1, ["width"] = 0.4, ["color"] = { 1,1,0.25 }, ["text"] = "Columns:" },
		{ ["type"] = "Text", ["ID"] = 2, ["width"] = 0.1, ["color"] = { 0,1,0.5 }, ["align"] = "right", ["text"] = EngBank_MAXCOLUMNS_MIN },
		{ ["type"] = "Slider", ["ID"] = 1, ["width"] = 0.4, ["minValue"] = EngBank_MAXCOLUMNS_MIN, ["maxValue"] = EngBank_MAXCOLUMNS_MAX, ["valueStep"] = 1,
		  ["defaultValue"] = function()
				return EngBankConfig["maxColumns"];
			end,
		  ["func"] = function(v)
				EngBankConfig["maxColumns"] = tonumber(v);
				EngBank_SetDefaultValues(0);
				EngBank_window_update_required = EngBank_MANDATORY;
				EngBank_UpdateWindow();
			end
		},
		{ ["type"] = "Text", ["ID"] = 3, ["width"] = 0.1, ["color"] = { 0,1,0.5 }, ["align"] = "left", ["text"] = EngBank_MAXCOLUMNS_MAX }
	},

	{	-- Button Size
		{ ["type"] = "Text", ["ID"] = 1, ["width"] = 0.4, ["color"] = { 1,1,0.25 }, ["text"] = "Button Size:" },
		{ ["type"] = "Text", ["ID"] = 2, ["width"] = 0.1, ["color"] = { 0,1,0.5 }, ["align"] = "right", ["text"] = EngBank_BUTTONSIZE_MIN },
		{ ["type"] = "Slider", ["ID"] = 1, ["width"] = 0.4, ["minValue"] = EngBank_BUTTONSIZE_MIN, ["maxValue"] = EngBank_BUTTONSIZE_MAX, ["valueStep"] = 1,
		  ["defaultValue"] = function()
				return EngBankConfig["frameButtonSize"];
			end,
		  ["func"] = function(v)
				EngBankConfig["frameButtonSize"] = tonumber(v);
				EngBank_SetDefaultValues(0);
				EngBank_window_update_required = EngBank_MANDATORY;
				EngBank_UpdateWindow();
			end
		},
		{ ["type"] = "Text", ["ID"] = 3, ["width"] = 0.1, ["color"] = { 0,1,0.5 }, ["align"] = "left", ["text"] = EngBank_BUTTONSIZE_MAX }
	},

	{	-- Font Size / item count
		{ ["type"] = "Text", ["ID"] = 1, ["width"] = 0.4, ["color"] = { 1,1,0.25 }, ["text"] = "Item count font size:" },
		{ ["type"] = "Text", ["ID"] = 2, ["width"] = 0.1, ["color"] = { 0,1,0.5 }, ["align"] = "right", ["text"] = EngBank_FONTSIZE_MIN },
		{ ["type"] = "Slider", ["ID"] = 1, ["width"] = 0.4, ["minValue"] = EngBank_FONTSIZE_MIN, ["maxValue"] = EngBank_FONTSIZE_MAX, ["valueStep"] = 1,
		  ["defaultValue"] = function()
				return EngBankConfig["button_size_opts"]["EngBank_BUTTONFONTHEIGHT"];
			end,
		  ["func"] = function(v)
				EngBankConfig["button_size_opts"]["EngBank_BUTTONFONTHEIGHT"] = tonumber(v);
				EngBank_SetDefaultValues(0);
				EngBank_window_update_required = EngBank_MANDATORY;
				EngBank_UpdateWindow();
			end
		},
		{ ["type"] = "Text", ["ID"] = 3, ["width"] = 0.1, ["color"] = { 0,1,0.5 }, ["align"] = "left", ["text"] = EngBank_FONTSIZE_MAX }
	},

	{	-- Font Size / New text
		{ ["type"] = "Text", ["ID"] = 1, ["width"] = 0.4, ["color"] = { 1,1,0.25 }, ["text"] = "New tag font size:" },
		{ ["type"] = "Text", ["ID"] = 2, ["width"] = 0.1, ["color"] = { 0,1,0.5 }, ["align"] = "right", ["text"] = EngBank_FONTSIZE_MIN },
		{ ["type"] = "Slider", ["ID"] = 1, ["width"] = 0.4, ["minValue"] = EngBank_FONTSIZE_MIN, ["maxValue"] = EngBank_FONTSIZE_MAX, ["valueStep"] = 1,
		  ["defaultValue"] = function()
				return EngBankConfig["button_size_opts"]["EngBank_BUTTONFONTHEIGHT2"];
			end,
		  ["func"] = function(v)
				EngBankConfig["button_size_opts"]["EngBank_BUTTONFONTHEIGHT2"] = tonumber(v);
				EngBank_SetDefaultValues(0);
				EngBank_window_update_required = EngBank_MANDATORY;
				EngBank_UpdateWindow();
			end
		},
		{ ["type"] = "Text", ["ID"] = 3, ["width"] = 0.1, ["color"] = { 0,1,0.5 }, ["align"] = "left", ["text"] = EngBank_FONTSIZE_MAX }
	},

	{	-- Font alignment / X
		{ ["type"] = "Text", ["ID"] = 1, ["width"] = 0.4, ["color"] = { 1,1,0.25 }, ["text"] = "Font position - X:" },
		{ ["type"] = "Text", ["ID"] = 2, ["width"] = 0.1, ["color"] = { 0,1,0.5 }, ["align"] = "right", ["text"] = 0 },
		{ ["type"] = "Slider", ["ID"] = 1, ["width"] = 0.4, ["minValue"] = 0, ["maxValue"] = 10, ["valueStep"] = 1,
		  ["defaultValue"] = function()
				return EngBankConfig["button_size_opts"]["EngBank_BUTTONFONTDISTANCE_X"];
			end,
		  ["func"] = function(v)
				EngBankConfig["button_size_opts"]["EngBank_BUTTONFONTDISTANCE_X"] = tonumber(v);
				EngBank_SetDefaultValues(0);
				EngBank_window_update_required = EngBank_MANDATORY;
				EngBank_UpdateWindow();
			end
		},
		{ ["type"] = "Text", ["ID"] = 3, ["width"] = 0.1, ["color"] = { 0,1,0.5 }, ["align"] = "left", ["text"] = 10 }
	},

	{	-- Font alignment / Y
		{ ["type"] = "Text", ["ID"] = 1, ["width"] = 0.4, ["color"] = { 1,1,0.25 }, ["text"] = "Font position - Y:" },
		{ ["type"] = "Text", ["ID"] = 2, ["width"] = 0.1, ["color"] = { 0,1,0.5 }, ["align"] = "right", ["text"] = 0 },
		{ ["type"] = "Slider", ["ID"] = 1, ["width"] = 0.4, ["minValue"] = 0, ["maxValue"] = 10, ["valueStep"] = 1,
		  ["defaultValue"] = function()
				return EngBankConfig["button_size_opts"]["EngBank_BUTTONFONTDISTANCE_Y"];
			end,
		  ["func"] = function(v)
				EngBankConfig["button_size_opts"]["EngBank_BUTTONFONTDISTANCE_Y"] = tonumber(v);
				EngBank_SetDefaultValues(0);
				EngBank_window_update_required = EngBank_MANDATORY;
				EngBank_UpdateWindow();
			end
		},
		{ ["type"] = "Text", ["ID"] = 3, ["width"] = 0.1, ["color"] = { 0,1,0.5 }, ["align"] = "left", ["text"] = 10 }
	},

	{	-- Frame spacing / X
		{ ["type"] = "Text", ["ID"] = 1, ["width"] = 0.4, ["color"] = { 1,1,0.25 }, ["text"] = "Frame spacing - X:" },
		{ ["type"] = "Text", ["ID"] = 2, ["width"] = 0.1, ["color"] = { 0,1,0.5 }, ["align"] = "right", ["text"] = 0 },
		{ ["type"] = "Slider", ["ID"] = 1, ["width"] = 0.4, ["minValue"] = 0, ["maxValue"] = 10, ["valueStep"] = 1,
		  ["defaultValue"] = function()
				return EngBankConfig["frameXSpace"];
			end,
		  ["func"] = function(v)
				EngBankConfig["frameXSpace"] = tonumber(v);
				EngBank_SetDefaultValues(0);
				EngBank_window_update_required = EngBank_MANDATORY;
				EngBank_UpdateWindow();
			end
		},
		{ ["type"] = "Text", ["ID"] = 3, ["width"] = 0.1, ["color"] = { 0,1,0.5 }, ["align"] = "left", ["text"] = 10 }
	},

	{	-- Frame spacing / Y
		{ ["type"] = "Text", ["ID"] = 1, ["width"] = 0.4, ["color"] = { 1,1,0.25 }, ["text"] = "Frame spacing - Y:" },
		{ ["type"] = "Text", ["ID"] = 2, ["width"] = 0.1, ["color"] = { 0,1,0.5 }, ["align"] = "right", ["text"] = 0 },
		{ ["type"] = "Slider", ["ID"] = 1, ["width"] = 0.4, ["minValue"] = 0, ["maxValue"] = 10, ["valueStep"] = 1,
		  ["defaultValue"] = function()
				return EngBankConfig["frameYSpace"];
			end,
		  ["func"] = function(v)
				EngBankConfig["frameYSpace"] = tonumber(v);
				EngBank_SetDefaultValues(0);
				EngBank_window_update_required = EngBank_MANDATORY;
				EngBank_UpdateWindow();
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
				return EngBankConfig["newItemText"];
			end,
		  ["func"] = function(v)
				EngBankConfig["newItemText"] = v;
				EngBank_window_update_required = EngBank_MANDATORY;
				EngBank_UpdateWindow();
			end
		},
	},
	{	-- Item count increased text
		{ ["type"] = "Text", ["ID"] = 1, ["width"] = 0.5, ["color"] = { 1,1,0.25 },
		  ["text"] = "Item count increased:" },
		{ ["type"] = "Edit", ["ID"] = 1, ["width"] = 0.2, ["letters"]=10,
		  ["defaultValue"] = function()
				return EngBankConfig["newItemTextPlus"];
			end,
		  ["func"] = function(v)
				EngBankConfig["newItemTextPlus"] = v;
				EngBank_window_update_required = EngBank_MANDATORY;
				EngBank_UpdateWindow();
			end
		},
	},
	{	-- Item count decreased text
		{ ["type"] = "Text", ["ID"] = 1, ["width"] = 0.5, ["color"] = { 1,1,0.25 },
		  ["text"] = "Item count decreased:" },
		{ ["type"] = "Edit", ["ID"] = 1, ["width"] = 0.2, ["letters"]=10,
		  ["defaultValue"] = function()
				return EngBankConfig["newItemTextMinus"];
			end,
		  ["func"] = function(v)
				EngBankConfig["newItemTextMinus"] = v;
				EngBank_window_update_required = EngBank_MANDATORY;
				EngBank_UpdateWindow();
			end
		},
	},
	{	-- New Tag timing
		{ ["type"] = "Text", ["ID"] = 1, ["width"] = 0.5, ["color"] = { 1,1,0.25 }, ["text"] = "Timeout for new tag - older (Minutes):" },
		{ ["type"] = "Slider", ["ID"] = 1, ["width"] = 0.5, ["minValue"] = 0, ["maxValue"] = 60*6, ["valueStep"] = 1,
		  ["defaultValue"] = function()
				return ceil(EngBankConfig["newItemTimeout"] / 60);
			end,
		  ["func"] = function(v)
				EngBankConfig["newItemTimeout"] = tonumber(v) * 60;
				EngBank_SetDefaultValues(0);
				EngBank_window_update_required = EngBank_MANDATORY;
				EngBank_UpdateWindow();
			end
		}
	},
	{	-- New Tag timing
		{ ["type"] = "Text", ["ID"] = 1, ["width"] = 0.5, ["color"] = { 1,1,0.25 }, ["text"] = "Timeout for new tag - newer (Minutes):" },
		{ ["type"] = "Slider", ["ID"] = 1, ["width"] = 0.5, ["minValue"] = 0, ["maxValue"] = 60*1, ["valueStep"] = 1,
		  ["defaultValue"] = function()
				return ceil(EngBankConfig["newItemTimeout2"] / 60);
			end,
		  ["func"] = function(v)
				EngBankConfig["newItemTimeout2"] = tonumber(v) * 60;
				EngBank_SetDefaultValues(0);
				EngBank_window_update_required = EngBank_MANDATORY;
				EngBank_UpdateWindow();
			end
		}
	},


	{},	---------------------------------------------------------------------------------------
	{
		{ ["type"] = "Text", ["ID"] = 1, ["width"] = 1.0, ["color"] = { 1,0,0.25 }, ["align"] = "center",
		  ["text"] = "Bag Hooks" },
	},
	{},	---------------------------------------------------------------------------------------
	{	-- Hook "Bank"
		{ ["type"] = "Text", ["ID"] = 1, ["width"] = 0.4, ["color"] = { 1,1,0.25 }, ["text"] = "Bank:" },
		{ ["type"] = "Text", ["ID"] = 2, ["width"] = 0.1, ["color"] = { 0,1,0.5 }, ["align"] = "right", ["text"] = "Off" },
		{ ["type"] = "Slider", ["ID"] = 1, ["width"] = 0.4, ["minValue"] = 0, ["maxValue"] = 1, ["valueStep"] = 1,
		  ["defaultValue"] = function()
				return EngBankConfig["hook_BANKFRAME_OPENED"];
			end,
		  ["func"] = function(v)
				EngBankConfig["hook_BANKFRAME_OPENED"] = tonumber(v);
				EngBank_SetDefaultValues(0);
			end
		},
		{ ["type"] = "Text", ["ID"] = 3, ["width"] = 0.1, ["color"] = { 0,1,0.5 }, ["align"] = "left", ["text"] = "On" }
	},

	{	-- Show "Bank"
		{ ["type"] = "Text", ["ID"] = 1, ["width"] = 0.4, ["color"] = { 1,1,0.25 }, ["text"] = "Include Bank:" },
		{ ["type"] = "Text", ["ID"] = 2, ["width"] = 0.1, ["color"] = { 0,1,0.5 }, ["align"] = "right", ["text"] = "Off" },
		{ ["type"] = "Slider", ["ID"] = 1, ["width"] = 0.4, ["minValue"] = 0, ["maxValue"] = 1, ["valueStep"] = 1,
		  ["defaultValue"] = function()
				return EngBankConfig["show_Bag-1"];
			end,
		  ["func"] = function(v)
				EngBankConfig["show_Bag-1"] = tonumber(v);
				EngBank_SetDefaultValues(0);
			end
		},
		{ ["type"] = "Text", ["ID"] = 3, ["width"] = 0.1, ["color"] = { 0,1,0.5 }, ["align"] = "left", ["text"] = "On" }
	},
	{	-- Show "Bag 5"
		{ ["type"] = "Text", ["ID"] = 1, ["width"] = 0.4, ["color"] = { 1,1,0.25 }, ["text"] = "Include Bag 1 Contents:" },
		{ ["type"] = "Text", ["ID"] = 2, ["width"] = 0.1, ["color"] = { 0,1,0.5 }, ["align"] = "right", ["text"] = "Off" },
		{ ["type"] = "Slider", ["ID"] = 1, ["width"] = 0.4, ["minValue"] = 0, ["maxValue"] = 1, ["valueStep"] = 1,
		  ["defaultValue"] = function()
				return EngBankConfig["show_Bag5"];
			end,
		  ["func"] = function(v)
				EngBankConfig["show_Bag5"] = tonumber(v);
				EngBank_SetDefaultValues(0);
			end
		},
		{ ["type"] = "Text", ["ID"] = 3, ["width"] = 0.1, ["color"] = { 0,1,0.5 }, ["align"] = "left", ["text"] = "On" }
	},

	{	-- Show "Bag 6"
		{ ["type"] = "Text", ["ID"] = 1, ["width"] = 0.4, ["color"] = { 1,1,0.25 }, ["text"] = "Include Bag 2 Contents:" },
		{ ["type"] = "Text", ["ID"] = 2, ["width"] = 0.1, ["color"] = { 0,1,0.5 }, ["align"] = "right", ["text"] = "Off" },
		{ ["type"] = "Slider", ["ID"] = 1, ["width"] = 0.4, ["minValue"] = 0, ["maxValue"] = 1, ["valueStep"] = 1,
		  ["defaultValue"] = function()
				return EngBankConfig["show_Bag6"];
			end,
		  ["func"] = function(v)
				EngBankConfig["show_Bag6"] = tonumber(v);
				EngBank_SetDefaultValues(0);
			end
		},
		{ ["type"] = "Text", ["ID"] = 3, ["width"] = 0.1, ["color"] = { 0,1,0.5 }, ["align"] = "left", ["text"] = "On" }
	},

	{	-- Show "Bag 7"
		{ ["type"] = "Text", ["ID"] = 1, ["width"] = 0.4, ["color"] = { 1,1,0.25 }, ["text"] = "Include Bag 3 Contents:" },
		{ ["type"] = "Text", ["ID"] = 2, ["width"] = 0.1, ["color"] = { 0,1,0.5 }, ["align"] = "right", ["text"] = "Off" },
		{ ["type"] = "Slider", ["ID"] = 1, ["width"] = 0.4, ["minValue"] = 0, ["maxValue"] = 1, ["valueStep"] = 1,
		  ["defaultValue"] = function()
				return EngBankConfig["show_Bag7"];
			end,
		  ["func"] = function(v)
				EngBankConfig["show_Bag7"] = tonumber(v);
				EngBank_SetDefaultValues(0);
			end
		},
		{ ["type"] = "Text", ["ID"] = 3, ["width"] = 0.1, ["color"] = { 0,1,0.5 }, ["align"] = "left", ["text"] = "On" }
	},

	{	-- Show "Bag 8"
		{ ["type"] = "Text", ["ID"] = 1, ["width"] = 0.4, ["color"] = { 1,1,0.25 }, ["text"] = "Include Bag 4 Contents:" },
		{ ["type"] = "Text", ["ID"] = 2, ["width"] = 0.1, ["color"] = { 0,1,0.5 }, ["align"] = "right", ["text"] = "Off" },
		{ ["type"] = "Slider", ["ID"] = 1, ["width"] = 0.4, ["minValue"] = 0, ["maxValue"] = 1, ["valueStep"] = 1,
		  ["defaultValue"] = function()
				return EngBankConfig["show_Bag8"];
			end,
		  ["func"] = function(v)
				EngBankConfig["show_Bag8"] = tonumber(v);
				EngBank_SetDefaultValues(0);
			end
		},
		{ ["type"] = "Text", ["ID"] = 3, ["width"] = 0.1, ["color"] = { 0,1,0.5 }, ["align"] = "left", ["text"] = "On" }
	},

	{	-- Show "Bag 9"
		{ ["type"] = "Text", ["ID"] = 1, ["width"] = 0.4, ["color"] = { 1,1,0.25 }, ["text"] = "Include Bag 5 Contents:" },
		{ ["type"] = "Text", ["ID"] = 2, ["width"] = 0.1, ["color"] = { 0,1,0.5 }, ["align"] = "right", ["text"] = "Off" },
		{ ["type"] = "Slider", ["ID"] = 1, ["width"] = 0.4, ["minValue"] = 0, ["maxValue"] = 1, ["valueStep"] = 1,
		  ["defaultValue"] = function()
				return EngBankConfig["show_Bag9"];
			end,
		  ["func"] = function(v)
				EngBankConfig["show_Bag9"] = tonumber(v);
				EngBank_SetDefaultValues(0);
			end
		},
		{ ["type"] = "Text", ["ID"] = 3, ["width"] = 0.1, ["color"] = { 0,1,0.5 }, ["align"] = "left", ["text"] = "On" }
	},

	{	-- Show "Bag 10"
		{ ["type"] = "Text", ["ID"] = 1, ["width"] = 0.4, ["color"] = { 1,1,0.25 }, ["text"] = "Include Bag 6 Contents:" },
		{ ["type"] = "Text", ["ID"] = 2, ["width"] = 0.1, ["color"] = { 0,1,0.5 }, ["align"] = "right", ["text"] = "Off" },
		{ ["type"] = "Slider", ["ID"] = 1, ["width"] = 0.4, ["minValue"] = 0, ["maxValue"] = 1, ["valueStep"] = 1,
		  ["defaultValue"] = function()
				return EngBankConfig["show_Bag10"];
			end,
		  ["func"] = function(v)
				EngBankConfig["show_Bag10"] = tonumber(v);
				EngBank_SetDefaultValues(0);
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
				return EngBankConfig["build_trade_list"];
			end,
		  ["func"] = function(v)
				EngBankConfig["build_trade_list"] = tonumber(v);
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

EngBank_ConfigOptions = EngBank_ConfigOptions_Default;

function EngBank_Config_GetItemSearchList(key, idx)
	return EngBankConfig["item_search_list"][key][idx]
end
function EngBank_Config_AssignItemSearchList(v, key, idx)
	if (key ~= nil) then
		EngBankConfig["item_search_list"][key][idx] = v;
	end
end

function EngBank_Config_GetItemSearchListLower(key, idx)
	return string.lower(EngBankConfig["item_search_list"][key][idx]);
end
function EngBank_Config_AssignItemSearchListUpper(v, key, idx)
	if (key ~= nil) then
		EngBankConfig["item_search_list"][key][idx] = string.upper(v);
	end
end

function EngBank_Config_SwapSearchListItems(unused_value, key1, key2)
	local tmp;

	if ( (EngBankConfig["item_search_list"][key1] ~= nil) and (EngBankConfig["item_search_list"][key2] ~= nil) ) then
		tmp = EngBankConfig["item_search_list"][key1];
		EngBankConfig["item_search_list"][key1] = EngBankConfig["item_search_list"][key2];
		EngBankConfig["item_search_list"][key2] = tmp;

		if (key1 > key2) then
			EngBank_Opts_CurrentPosition = EngBank_Opts_CurrentPosition - 1;
		else
			EngBank_Opts_CurrentPosition = EngBank_Opts_CurrentPosition + 1;
		end

		EngBank_Options_UpdateWindow();
	end
end

function EngBank_CreateConfigOptions()
	local key,value;

	EngBank_ConfigOptions = EngBank_ConfigOptions_Default;

	for key,value in EngBankConfig["item_search_list"] do
		table.insert( EngBank_ConfigOptions,
			{
{ ["type"] = "Text", ["ID"] = 1, ["width"] = 0.025, ["color"] = { 1,0,1 }, ["text"] = key.."." },
{ ["type"] = "UpButton", ["ID"] = 1, ["width"] = 0.025,
  ["param1"] = key, ["param2"] = key-1,
  ["func"] = EngBank_Config_SwapSearchListItems
},
{ ["type"] = "DownButton", ["ID"] = 1, ["width"] = 0.025,
  ["param1"] = key, ["param2"] = key+1,
  ["func"] = EngBank_Config_SwapSearchListItems
},
{ ["type"] = "Edit", ["ID"] = 1, ["width"] = 0.20, ["letters"]=50, ["param1"] = key, ["param2"] = 1,
  ["defaultValue"] = EngBank_Config_GetItemSearchListLower, ["func"] = EngBank_Config_AssignItemSearchListUpper
},
{ ["type"] = "Edit", ["ID"] = 2, ["width"] = 0.20, ["letters"]=50, ["param1"] = key, ["param2"] = 2,
  ["defaultValue"] = EngBank_Config_GetItemSearchListLower, ["func"] = EngBank_Config_AssignItemSearchListUpper
},
{ ["type"] = "Edit", ["ID"] = 3, ["width"] = 0.35, ["letters"]=50, ["param1"] = key, ["param2"] = 3,
  ["defaultValue"] = EngBank_Config_GetItemSearchList, ["func"] = EngBank_Config_AssignItemSearchList
},
{ ["type"] = "Edit", ["ID"] = 4, ["width"] = 0.175, ["letters"]=50, ["param1"] = key, ["param2"] = 4,
  ["defaultValue"] = EngBank_Config_GetItemSearchList, ["func"] = EngBank_Config_AssignItemSearchList
}
			}  );
	
	end

end
