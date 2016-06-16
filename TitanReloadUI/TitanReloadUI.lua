function TitanPanelReloadUIButton_OnLoad()
	this.registry = { 
		id = "ReloadUI",
		menuText = TITAN_RELOADUI_MENU_TEXT, 
		buttonTextFunction = "TitanPanelReloadUIButton_GetButtonText",
	
		tooltipTitle = TITAN_RELOADUI_TOOLTIP,
		tooltipTextFunction = "TitanPanelReloadUIButton_GetTooltipText",
 
		savedVariables = {
			ShowLabelText = 1,
		}
	};
end


function TitanPanelReloadUIButton_OnEvent()
	TitanPanelButton_UpdateButton("ReloadUI");	
	TitanPanelButton_UpdateTooltip();
end 


function TitanPanelReloadUIButton_OnClick(button)
	if ( button == "LeftButton" ) then
		ReloadUI();
	else
		GameTooltip:Hide();
		TitanPanelRightClickMenu_Toggle();
	end
end


function TitanPanelReloadUIButton_GetButtonText(id)
	local id = TitanUtils_GetButton(id, true);

	-- create string for Titan bar display
	--local buttonRichText = format(TITAN_RELOADUI_BUTTON_TEXT, TitanUtils_GetGreenText("ReloadUI"));
	local buttonRichText = "";
	return TITAN_RELOADUI_BUTTON_LABEL, buttonRichText;
end


function TitanPanelReloadUIButton_GetTooltipText()	
	local tooltipRichText = TitanUtils_GetHighlightText("Left click to reload the UI.");
	return tooltipRichText;
end

function TitanPanelRightClickMenu_PrepareReloadUIMenu()
	local id="ReloadUI";
	
	--TitanPanelRightClickMenu_AddTitle(TitanPlugins[id].menuText);

	local info = {};
	local info2 = {};

	TitanPanelRightClickMenu_AddSpacer();

	info.text = "ReloadUI";
	info.value = "ReloadUI";
	info.func = function ()
		ReloadUI();
	end
	UIDropDownMenu_AddButton(info);


	--TitanPanelRightClickMenu_AddToggleLabelText("ReloadUI");

	TitanPanelRightClickMenu_AddSpacer();

	--TitanPanelRightClickMenu_AddCommand(TITAN_PANEL_MENU_CUSTOMIZE..TITAN_PANEL_MENU_POPUP_IND,id,TITAN_PANEL_MENU_FUNC_CUSTOMIZE);
	TitanPanelRightClickMenu_AddCommand(TITAN_PANEL_MENU_HIDE,id,TITAN_PANEL_MENU_FUNC_HIDE);

	-- info about plugin
	info2.text = "About";
	info2.value = "DisplayAbout";
	info2.func = TitanPanelReloadUI_DisplayAbout;
	UIDropDownMenu_AddButton(info2);
end


function TitanPanelReloadUI_DisplayAbout()
	local AboutText = TitanUtils_GetGreenText("Titan Panel [ReloadUI]").."\n"..TitanUtils_GetNormalText("Version: ")..TitanUtils_GetHighlightText(TitanPanel_ReloadUI_Version).."\n"..TitanUtils_GetNormalText("Author: ")..TitanUtils_GetHighlightText("Corgi");

	StaticPopupDialogs["DisplayAbout"] = {
		text = TEXT(AboutText),
		button1 = TEXT(OKAY),
		timeout = 0,
	};
	StaticPopup_Show("DisplayAbout");
end