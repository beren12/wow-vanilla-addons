
-- split a string by the first space found, or return two blank strings
function EngInventory_SplitSpace(strtosplit)
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

-- this leaves a trailing space at the end.  too lazy to fix it
function EngInventory_ReverseString(strtorev)
	local out = "", s1, s2;

	s2 = strtorev;
	repeat
		s1, s2 = EngInventory_SplitSpace(s2);
		out = s1.." "..out;
	until s2 == "";

	return(out);
end

-- Prints out text to a chat box.
-- (Copied directly from AllInOneInventory)
function EngInventory_Print(msg,r,g,b,frame,id,unknown4th)
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

function EngInventory_PrintDEBUG(msg,r,g,b,frame,id,unknown4th)
	if (ENGINVENTORY_DEBUGMESSAGES == 1) then
		EngInventory_Print(msg,r,g,b,frame,id,unknown4th)
	end
end

-- ripped from lootlink
function EngInventory_NameFromLink(link)
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
function EngInventory_IsShotBag(bag) 
        if ( bag < 0 ) or ( bag > 4 ) then
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
function EngInventory_DisplayItemCache()

	for barnum = 1, ENGINVENTORY_MAX_BARS do
		EngInventory_Print("Bar # "..barnum, 1,0.2,0.2);
		if (table.getn(EngInventory_inventory_cache[barnum]) > 0) then
			for slotnum = 1, table.getn(EngInventory_inventory_cache[barnum]) do
				if (EngInventory_inventory_cache[barnum][slotnum]["itemlink"] ~= nil) then
					EngInventory_Print("  "..slotnum.." ("..EngInventory_inventory_cache[barnum][slotnum]["bag"]..","..EngInventory_inventory_cache[barnum][slotnum]["slot"].."): "..EngInventory_inventory_cache[barnum][slotnum]["itemlink"].." = "..EngInventory_inventory_cache[barnum][slotnum]["itemname"]..", indexed on="..EngInventory_inventory_cache[barnum][slotnum]["indexed_on"]);
				else
					EngInventory_Print("  "..slotnum.." ("..EngInventory_inventory_cache[barnum][slotnum]["bag"]..","..EngInventory_inventory_cache[barnum][slotnum]["slot"].."): - empty -");
				end
			end
		end
	end

end

function EngInventory_UpdateBagState()
        local shouldBeChecked = EngInventory_frame:IsVisible();
	if (EngInventoryConfig["hook_Bag0"] == 1) then
	        MainMenuBarBackpackButton:SetChecked(shouldBeChecked);
	end
        local bagButton = nil;
        for i = 0, 3 do 
		if (EngInventoryConfig["hook_Bag"..(i+1)] == 1) then
			bagButton = getglobal("CharacterBag"..i.."Slot");
			if ( bagButton ) then
				bagButton:SetChecked(shouldBeChecked);
			end
		end
        end
end

-- there must be a lib function to do this..  ??!
function EngInventory_Table_RemoveKey(tab, key)
	local temptab = {};

	for k,v in tab do
		if (k ~= key) then
			temptab[k] = v;
		end
	end

	return temptab;
end
