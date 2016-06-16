
EngBank_OPTIONS_UPDATE_HAPPENING = 0;

EngBank_OPTIONS_FRAME_WIDTH = 800;
EngBank_OPTIONS_FRAME_BOTTOMPADDING = 30;
EngBank_OPTIONS_FRAME_BORDER = 5;
EngBank_OPTIONS_FRAME_LINE_HEIGHT = 20;
EngBank_OPTS_SCROLLBARBUTTONWIDTH = 16;
EngBank_OPTS_SCROLLBARBUTTONHEIGHT = 16;

-- Height of some default controls
EngBank_OPTS_CONTROL_SLIDER_HEIGHT = 17;

EngBank_OPTS_SCROLL_LINES = 15;	-- max number of lines inside the scroll

EngBank_OPTIONS_FRAME_HEIGHT = (EngBank_OPTIONS_FRAME_LINE_HEIGHT*(EngBank_OPTS_SCROLL_LINES+1)) +
	(EngBank_OPTIONS_FRAME_BORDER*2) +
	EngBank_OPTIONS_FRAME_BOTTOMPADDING;

EngBank_Opts_CurrentPosition = 1;
EngBank_Config_MaxScroll = 1;

EngBank_OPTIONS_LIST_FRAMES = {
	"Text_1",
	"Text_2",
	"Text_3",
	"Text_4",
	"Text_5",
	"Text_6",
	"Text_7",
	"Text_8",
	"Slider_1",
	"Slider_2",
	"Slider_3",
	"Slider_3",
	"Edit_1",
	"Edit_2",
	"Edit_3",
	"Edit_4",
	"Button_1",
	"Button_2",
	"Button_3",
	"Button_4",
	"UpButton_1",
	"DownButton_1"
	};

function EngBank_Opts_ControlValueChanged(v)
	if ( (EngBank_OPTIONS_UPDATE_HAPPENING == 0) and (this.change_value_func ~= nil) ) then
		this.change_value_func(v, this.func_param1, this.func_param2, this.func_param3, this.func_param4);
	end
end

function EngBank_Options_EnableLine(frame, elements, y, x_start, available_width, fade )
	local key, value, e, width_start, width;
	local tmpframe, tmpframe_name;
	local tmpframe_text, tmpframe_text2, tmpframe_text3;
	local used_frames = {};

	EngBank_MoveAndSizeFrame( frame:GetName(), "TOPLEFT",
		"EngBank_OptsFrame", "TOPLEFT",
		x_start, 0-y,
		available_width, EngBank_OPTIONS_FRAME_LINE_HEIGHT );
	y = y + EngBank_OPTIONS_FRAME_LINE_HEIGHT;

	if ((elements ~= nil) and (table.getn(elements) > 0)) then
		width_start = 0;
		for key,e in elements do
			width = e["width"] * available_width;

			tmpframe_name = frame:GetName().."_"..e["type"].."_"..e["ID"];
			tmpframe = getglobal(tmpframe_name);

			tmpframe.change_value_func = e["func"];
			tmpframe.func_param1 = e["param1"];
			tmpframe.func_param2 = e["param2"];
			tmpframe.func_param3 = e["param3"];
			tmpframe.func_param4 = e["param4"];

			if (e["type"] == "Slider") then
				tmpframe_text = getglobal( tmpframe:GetName().."_disp_text" );
				tmpframe:SetMinMaxValues(e["minValue"], e["maxValue"]);
				tmpframe:SetValueStep(e["valueStep"]);
				tmpframe:SetValue( e["defaultValue"](e["param1"], e["param2"], e["param3"], e["param4"]) );
				tmpframe_text:SetText( tmpframe:GetValue() );
				tmpframe_text:SetJustifyH("LEFT");

				EngBank_MoveAndSizeFrame( tmpframe_name, "TOPLEFT",
					frame:GetName(), "TOPLEFT",
					width_start+5, 0-((EngBank_OPTIONS_FRAME_LINE_HEIGHT-EngBank_OPTS_CONTROL_SLIDER_HEIGHT)/2),
					(width-5)-30, EngBank_OPTS_CONTROL_SLIDER_HEIGHT );
				EngBank_MoveAndSizeFrame( tmpframe_text:GetName(), "LEFT",
					tmpframe_name.."Thumb", "RIGHT",
					-10, 0,
					55, 20);
			elseif (e["type"] == "Edit") then
				tmpframe:SetMaxLetters(e["letters"]);
				tmpframe:SetText( e["defaultValue"](e["param1"], e["param2"], e["param3"], e["param4"]) );

				EngBank_MoveAndSizeFrame( tmpframe_name, "TOPLEFT",
					frame:GetName(), "TOPLEFT",
					width_start+10, 0,
					width, EngBank_OPTIONS_FRAME_LINE_HEIGHT );
			elseif (e["type"] == "Text") then
				tmpframe:SetText(e["text"]);
				if (e["align"] ~= nil) then
					tmpframe:SetJustifyH(e["align"]);	-- valid values: LEFT, RIGHT,  CENTER?
				else
					tmpframe:SetJustifyH("LEFT");
				end
				if (e["alignv"] ~= nil) then
					tmpframe:SetJustifyV(e["alignv"]);	-- valid values: TOP, BOTTOM,  CENTER?
				else
					tmpframe:SetJustifyV("CENTER");
				end
				if (e["color"] ~= nil) then
					--tmpframe:SetVertexColor(e["color"][1], e["color"][2], e["color"][3], fade);
					tmpframe:SetTextColor(e["color"][1], e["color"][2], e["color"][3]);
				else
					--tmpframe:SetVertexColor(1,1,0,fade);	-- yellow, default text
					tmpframe:SetTextColor(1,1,0);	-- yellow, default text
				end

				EngBank_MoveAndSizeFrame( tmpframe_name, "TOPLEFT",
					frame:GetName(), "TOPLEFT",
					width_start, 0,
					width, EngBank_OPTIONS_FRAME_LINE_HEIGHT );
			elseif (e["type"] == "Button") then
				tmpframe:SetText(e["text"]);

				EngBank_MoveAndSizeFrame( tmpframe_name, "TOPLEFT",
					frame:GetName(), "TOPLEFT",
					width_start, 0,
					width, EngBank_OPTIONS_FRAME_LINE_HEIGHT );
			elseif (e["type"] == "UpButton") then
				EngBank_MoveAndSizeFrame( tmpframe_name, "TOPLEFT",
					frame:GetName(), "TOPLEFT",
					width_start, 0,
					width, EngBank_OPTIONS_FRAME_LINE_HEIGHT );
			elseif (e["type"] == "DownButton") then
				EngBank_MoveAndSizeFrame( tmpframe_name, "TOPLEFT",
					frame:GetName(), "TOPLEFT",
					width_start, 0,
					width, EngBank_OPTIONS_FRAME_LINE_HEIGHT );
			end

			tmpframe:SetAlpha(fade);
			used_frames[e["type"].."_"..e["ID"]] = 1;

			width_start = width_start + width;
		end
	end

	for key,value in EngBank_OPTIONS_LIST_FRAMES do
		if ( used_frames[value] == nil ) then
			tmpframe = getglobal( frame:GetName().."_"..value );
			tmpframe:Hide();
		end
	end

	return y;
end

function EngBank_Options_InitWindow()
	EngBank_CreateConfigOptions();

	EngBank_Config_MaxScroll = math.max( 1, (table.getn(EngBank_ConfigOptions)-EngBank_OPTS_SCROLL_LINES)+2 );

	EngBank_MoveAndSizeFrame( EngBank_OptsFrame_ScrollBar:GetName(), "TOPRIGHT",
		EngBank_OptsFrame:GetName(), "TOPRIGHT",
		0-(EngBank_OPTIONS_FRAME_BORDER),
		0-(EngBank_OPTIONS_FRAME_BORDER+EngBank_OPTS_SCROLLBARBUTTONHEIGHT),
		EngBank_OPTS_SCROLLBARBUTTONWIDTH,
		EngBank_OPTIONS_FRAME_HEIGHT -( (EngBank_OPTIONS_FRAME_BORDER*2) + (EngBank_OPTS_SCROLLBARBUTTONHEIGHT*2) ) );
	--Print(" config options size: "..table.getn(EngBank_ConfigOptions) );
	--Print(" EngBank_OPTS_SCROLL_LINES: "..EngBank_OPTS_SCROLL_LINES );
	--Print(" Scroll bar max value set to: "..max_scroll );
	EngBank_OptsFrame_ScrollBar:SetMinMaxValues(1, EngBank_Config_MaxScroll);
	EngBank_OptsFrame_ScrollBar:SetValueStep(0.1);
	EngBank_OptsFrame_ScrollBar:SetValue(1);

	EngBank_OptsFrame:SetWidth( EngBank_OPTIONS_FRAME_WIDTH );
	EngBank_OptsFrame:SetHeight( EngBank_OPTIONS_FRAME_HEIGHT );

	EngBank_OptsFrame:SetBackdropColor(
		EngBankConfig["bar_colors_"..EngBank_MAINWINDOWCOLORIDX.."_background_r"],
		EngBankConfig["bar_colors_"..EngBank_MAINWINDOWCOLORIDX.."_background_g"],
		EngBankConfig["bar_colors_"..EngBank_MAINWINDOWCOLORIDX.."_background_b"],
		EngBankConfig["bar_colors_"..EngBank_MAINWINDOWCOLORIDX.."_background_a"] );
	EngBank_OptsFrame:SetBackdropBorderColor(
		EngBankConfig["bar_colors_"..EngBank_MAINWINDOWCOLORIDX.."_border_r"],
		EngBankConfig["bar_colors_"..EngBank_MAINWINDOWCOLORIDX.."_border_g"],
		EngBankConfig["bar_colors_"..EngBank_MAINWINDOWCOLORIDX.."_border_b"],
		EngBankConfig["bar_colors_"..EngBank_MAINWINDOWCOLORIDX.."_border_a"] );

	EngBank_Options_UpdateWindow();
end

function EngBank_Options_UpdateWindow()
	EngBank_OPTIONS_UPDATE_HAPPENING = 1;

	if (EngBank_Opts_CurrentPosition > EngBank_Config_MaxScroll) then
		EngBank_Opts_CurrentPosition = EngBank_Config_MaxScroll;
	end
	
	local y, x_start, x_width;
	local current_opt = math.floor(EngBank_Opts_CurrentPosition);
	local fade = 1 - (EngBank_Opts_CurrentPosition - current_opt);
	local use_fade;
	local i;
	local shift_y = (EngBank_Opts_CurrentPosition - current_opt) * EngBank_OPTIONS_FRAME_LINE_HEIGHT;

	x_start = EngBank_OPTIONS_FRAME_BORDER;
	x_width = EngBank_OPTIONS_FRAME_WIDTH -( (EngBank_OPTIONS_FRAME_BORDER*3) + EngBank_OPTS_SCROLLBARBUTTONWIDTH );
	y = EngBank_OPTIONS_FRAME_BORDER + EngBank_OPTIONS_FRAME_LINE_HEIGHT - shift_y;

	for i = 0, EngBank_OPTS_SCROLL_LINES-1 do
		if (i==0) then
			use_fade = fade;
		elseif (i==EngBank_OPTS_SCROLL_LINES-1) then
			use_fade = 1-fade;
		else
			use_fade = 1;
		end
		y = EngBank_Options_EnableLine( getglobal("EngBank_OptsFrame_Line_"..(i+1)), EngBank_ConfigOptions[i+current_opt], y, x_start, x_width, use_fade );
	end

	EngBank_OPTIONS_UPDATE_HAPPENING = 0;
end

function EngBank_Opts_Scroll_Update()

end

