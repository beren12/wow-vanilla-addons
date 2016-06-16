
-- split a string by the first space found, or return two blank strings
function EngBank_SplitSpace(strtosplit)
	if (strtosplit) then
		local str1 = strtosplit;
	        local str2 = "";
	        local idx = strfind(strtosplit, " ");

		if ( idx ) then
	                str1 = strsub(strtosplit, 1, idx-1);
	                str2 = strsub(strtosplit, idx+1);
	        end

	        return str1, str2;
	else
		return "", "";
	end
end

function EngBank_ReverseString(strtorev,toggle)


	local out = "", s1, s2;

	s2 = strtorev;

	if toggle==2 then
	repeat
		s1, s2 = EngBank_SplitSpace(s2);
		if out == "" then
			out = s1..out;
		else
			out = s1.." "..out;
		end

	until s2 == "";
	else
	out = strtorev;
	end
	
	return(out);
end

-- Prints out text to a chat box.
-- (Copied directly from AllInOneInventory)
function EngBank_Print(msg,r,g,b,frame,id,unknown4th)
        if (not r) then r = 1.0; end
        if (not g) then g = 1.0; end
        if (not b) then b = 0.0; end
        if ( Print ) then
                Print(msg, r, g, b, frame, id, unknown4th);
                return;
        end
        if(unknown4th) then
                local temp = id;
                id = unknown4th;
                unknown4th = id;
        end
                                
        if ( frame ) then 
                frame:AddMessage(msg,r,g,b,id,unknown4th);
        else
                if ( DEFAULT_CHAT_FRAME ) then 
                        DEFAULT_CHAT_FRAME:AddMessage(msg, r, g, b,id,unknown4th);
                end
        end
end

function EngBank_PrintDEBUG(msg,r,g,b,frame,id,unknown4th)
	if (EngBank_DEBUGMESSAGES == 1) then
		EngBank_Print(msg,r,g,b,frame,id,unknown4th)
	end
end

-- ripped from lootlink
function EngBank_NameFromLink(link)
	local name;
	if( not link ) then
		return nil;
	end
	for name in string.gfind(link, "|c%x+|Hitem:%d+:%d+:%d+:%d+|h%[(.-)%]|h|r") do
		return name;
	end
	return nil;
end

-- ripped directly from AIOI
function EngBank_IsShotBag(bag) 
        if ( bag < 5 ) or ( bag > 10 ) then
                return false;
        end
        local name = "MainMenuBarBackpackButton";
        if ( bag > 0 ) then
                name = "CharacterBag"..(bag-1).."Slot";
        end
        local objCount = getglobal(name.."Count");
        if ( objCount ) and ( objCount:IsVisible() ) then
                local tmp = objCount:GetText();
                if ( ( tmp ) and ( strlen(tmp) > 0) ) then
                        return true;
                end
        end
        return false;
end

-- Debugging function
function EngBank_DisplayItemCache()

	for barnum = 1, EngBank_MAX_BARS do
		EngBank_Print("Bar # "..barnum, 1,0.2,0.2);
		if (table.getn(EngBank_inventory_cache[barnum]) > 0) then
			for slotnum = 1, table.getn(EngBank_inventory_cache[barnum]) do
				if (EngBank_inventory_cache[barnum][slotnum]["itemlink"] ~= nil) then
					EngBank_Print("  "..slotnum.." ("..EngBank_inventory_cache[barnum][slotnum]["bag"]..","..EngBank_inventory_cache[barnum][slotnum]["slot"].."): "..EngBank_inventory_cache[barnum][slotnum]["itemlink"].." = "..EngBank_inventory_cache[barnum][slotnum]["itemname"]..", indexed on="..EngBank_inventory_cache[barnum][slotnum]["indexed_on"]);
				else
					EngBank_Print("  "..slotnum.." ("..EngBank_inventory_cache[barnum][slotnum]["bag"]..","..EngBank_inventory_cache[barnum][slotnum]["slot"].."): - empty -");
				end
			end
		end
	end

end

function EngBank_UpdateBagState()
        local shouldBeChecked = EngBank_frame:IsVisible();
	if (EngBankConfig["hook_Bag0"] == 1) then
	        MainMenuBarBackpackButton:SetChecked(shouldBeChecked);
	end
        local bagButton = nil;
        for i = 0, 3 do 
		if (EngBankConfig["hook_Bag"..(i+1)] == 1) then
			bagButton = getglobal("CharacterBag"..i.."Slot");
			if ( bagButton ) then
				bagButton:SetChecked(shouldBeChecked);
			end
		end
        end
end

-- there must be a lib function to do this..  ??!
function EngBank_Table_RemoveKey(tab, key)
	local temptab = {};

	for k,v in tab do
		if (k ~= key) then
			temptab[k] = v;
		end
	end

	return temptab;
end


function EngBank_SetReplaceBank()
	if BankFrame_Saved == nil then
		BankFrame_Saved = getglobal("BankFrame");
	end
	if ( EngReplaceBank == 0 ) then
		BankFrame_Saved:RegisterEvent("BANKFRAME_OPENED");
		BankFrame_Saved:RegisterEvent("BANKFRAME_CLOSED");
		setglobal("BankFrame", BankFrame_Saved);
		BankFrame_Saved = nil;
	else
		if BankFrame_Saved:IsVisible() then
			BankFrame_Saved:Hide();
		end
		BankFrame_Saved:UnregisterEvent("BANKFRAME_OPENED");
		BankFrame_Saved:UnregisterEvent("BANKFRAME_CLOSED");
		setglobal("BankFrame", EngBank_frame);
	end
end

function list_iter(t)
      local i = 0
      local n = table.getn(t)
      return function()
               i = i + 1
               if i <= n then return t[i] end
             end
end


