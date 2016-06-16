--[[
	Auctioneer Addon for World of Warcraft(tm).
	Version: 3.9.0.1000 (Kangaroo)
	Revision: $Id: AHScanning.lua 970 2006-08-22 02:58:29Z mentalpower $

	AHScanning
	Functions for scanning the AH
	Thanks to Telo for the LootLink code from which this was based.

	License:
		This program is free software; you can redistribute it and/or
		modify it under the terms of the GNU General Public License
		as published by the Free Software Foundation; either version 2
		of the License, or (at your option) any later version.

		This program is distributed in the hope that it will be useful,
		but WITHOUT ANY WARRANTY; without even the implied warranty of
		MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
		GNU General Public License for more details.

		You should have received a copy of the GNU General Public License
		along with this program(see GPL.txt); if not, write to the Free Software
		Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
]]

--Local function Prototypes
local nextIndex, stopAuctionScan, auctionSubmitQuery, auctionNextQuery, checkCompleteScan, queryAuctionItemsHook, scanAuction, canSendAuctionQuery, startAuctionScan, canScan, requestAuctionScan;

-- local variables
local isScanningRequested = false;
local lCurrentAuctionPage;
local lMajorAuctionCategories;
local lCurrentCategoryIndex;
local lIsPageScanned;
local lScanInProgress;
local lFullScan;
local lScanStartedAt;
local lPageStartedAt;

-- function hooks
local lOriginal_CanSendAuctionQuery;
local lOriginal_AuctionFrameBrowse_OnEvent;
local lOriginal_AuctionFrameBrowse_Update;

-- TODO: If all categories are selected, then we should do a complete scan rather than a one-by-one scan.

-- get the next category index to based on what categories have been configured to be scanned
function nextIndex() --Local
	if (lCurrentCategoryIndex == nil) then lCurrentCategoryIndex = 0 end
	for i = lCurrentCategoryIndex + 1, table.getn(lMajorAuctionCategories) do
		if tostring(Auctioneer.Command.GetFilterVal("scan-class"..i)) == "on" then
			return i;
		end
	end

	return nil;
end

function stopAuctionScan()
	Auctioneer.Event.StopAuctionScan();

	-- Unhook the scanning functions
	if( lOriginal_CanSendAuctionQuery ) then
		CanSendAuctionQuery = lOriginal_CanSendAuctionQuery;
		lOriginal_CanSendAuctionQuery = nil;
	end

	if( lOriginal_AuctionFrameBrowse_OnEvent ) then
		AuctionFrameBrowse_OnEvent = lOriginal_AuctionFrameBrowse_OnEvent;
		lOriginal_AuctionFrameBrowse_OnEvent = nil;
	end

	if( lOriginal_AuctionFrameBrowse_Update ) then
		AuctionFrameBrowse_Update = lOriginal_AuctionFrameBrowse_Update;
		lOriginal_AuctionFrameBrowse_Update = nil;
	end

	Auctioneer.Scanning.IsScanningRequested = false;
	lScanInProgress = false;
	lCurrentCategoryIndex = 0;
	lPageStartedAt = nil;
	lCurrentAuctionPage = nil;

	-- Unprotect AuctionFrame if we should
	if (Auctioneer.Command.GetFilterVal('protect-window') == 1) then
		Auctioneer.Util.ProtectAuctionFrame(false);
	end
end

function auctionSubmitQuery() --Local
	if not lCurrentAuctionPage or lCurrentAuctionPage == 0 then
		if not lCurrentAuctionPage then lCurrentAuctionPage = 0 end
		if lFullScan then
			BrowseNoResultsText:SetText(string.format(_AUCT('AuctionScanStart'), _AUCT('TextAuction')));
		else
			BrowseNoResultsText:SetText(string.format(_AUCT('AuctionScanStart'), lMajorAuctionCategories[lCurrentCategoryIndex]));
		end
	end
	if (lFullScan) then
		QueryAuctionItems("", "", "", nil, nil, nil, lCurrentAuctionPage, nil, nil);
	else
		QueryAuctionItems("", "", "", nil, lCurrentCategoryIndex, nil, lCurrentAuctionPage, nil, nil);
	end
	lPageStartedAt = time();

	lIsPageScanned = false;
	Auctioneer.Event.AuctionQuery(lCurrentAuctionPage);
end

local lCheckPage = nil;
function auctionNextQuery() --Local
	lCheckPage = nil;
	if lCurrentAuctionPage then
		local numBatchAuctions, totalAuctions = GetNumAuctionItems("list");
		local maxPages = floor(totalAuctions / NUM_AUCTION_ITEMS_PER_PAGE);

		local auctionsPerSecond = ( Auctioneer.Core.Variables.TotalAuctionsScannedCount / ( GetTime() - lScanStartedAt ) );
		local auctionETA = ( ( totalAuctions - Auctioneer.Core.Variables.TotalAuctionsScannedCount ) / auctionsPerSecond );
		auctionsPerSecond = floor( auctionsPerSecond * 100 ) / 100;
		if ( type(auctionsPerSecond) ~= "number" ) then
			auctionsPerSecond = "";
		else
			auctionsPerSecond = tostring(auctionsPerSecond);
		end
		local ETAString = SecondsToTime(auctionETA);

		if( lCurrentAuctionPage < maxPages ) then
			lPageStartedAt = time();
			lCurrentAuctionPage = lCurrentAuctionPage + 1;
			if lFullScan then
				BrowseNoResultsText:SetText(string.format(_AUCT('AuctionPageN'), _AUCT('TextAuction'), lCurrentAuctionPage + 1, maxPages + 1, auctionsPerSecond, ETAString));
			else
				BrowseNoResultsText:SetText(string.format(_AUCT('AuctionPageN'), lMajorAuctionCategories[lCurrentCategoryIndex],lCurrentAuctionPage + 1, maxPages + 1, auctionsPerSecond, ETAString));
			end
		elseif nextIndex() then
			lPageStartedAt = time();
			lCurrentCategoryIndex = nextIndex();
			lCurrentAuctionPage = 0;
		else
			stopAuctionScan();
			if( totalAuctions > 0 ) then
				BrowseNoResultsText:SetText(_AUCT('AuctionScanDone'));
				Auctioneer.Event.FinishedAuctionScan();
			end
			return;
		end
	end
	auctionSubmitQuery();
end

local lCheckStartTime = nil;
function checkCompleteScan()
	lCheckStartTime = lCheckStartTime or time()
	if (time() - lCheckStartTime > 10) then
		-- Sometimes they never return an owner.
		return true
	end

	for index = 1, GetNumAuctionItems("list") do
		local _,_,_,_,_,_,_,_,_,_,_, owner = GetAuctionItemInfo("list", index);
		if (not owner) then
			return false
		end
	end

	return true
end

function queryAuctionItemsHook()
	lCheckStartTime = nil;
end

function scanAuction(nonScanUpdate)
	local numBatchAuctions, totalAuctions = GetNumAuctionItems("list");
	local auctionid;

	if( numBatchAuctions > 0 ) then
		if (nonScanUpdate) then
			for auctionid = 1, numBatchAuctions do
				Auctioneer.Event.ScanAuction(nil, auctionid, nil, true);
			end
		else
			for auctionid = 1, numBatchAuctions do
				Auctioneer.Event.ScanAuction(lCurrentAuctionPage, auctionid, lCurrentCategoryIndex);
			end
		end
	end

	lIsPageScanned = true;
end

local retryCount = 0
function canSendAuctionQuery() --Local
	local value = lOriginal_CanSendAuctionQuery();
	if (value and lIsPageScanned) or (retryCount >= 3) then
		auctionNextQuery();
		retryCount = 0
		return nil;
	end
	if (lPageStartedAt) then
		local pageElapsed = time() - lPageStartedAt;
		if (pageElapsed > 20) then
			if (Auctioneer.Command.GetFilter('show-warning')) then
				Auctioneer.Util.ChatPrint(string.format(_AUCT('AuctionScanRedo'), 20));
			end
			auctionSubmitQuery();
			retryCount = retryCount  + 1;
			return nil;
		end
		return false;
	end
end

Auctioneer.AuctionFrameBrowse = {
	OnEvent = function()
		-- Intentionally empty; don't allow the auction UI to update while we're scanning
	end,
	Update = function()
		-- Intentionally empty; don't allow the auction UI to update while we're scanning
	end
};

function startAuctionScan()
	lMajorAuctionCategories = {GetAuctionItemClasses()};

	lFullScan = true;
	for i = 1, table.getn(lMajorAuctionCategories) do
		if tostring(Auctioneer.Command.GetFilterVal("scan-class"..i)) ~= "on" then
			lFullScan = false;
		end
	end

	if (lFullScan) then
		lCurrentCategoryIndex = table.getn(lMajorAuctionCategories);
	else
		-- first make sure that we have at least one category to scan
		lCurrentCategoryIndex = nextIndex();
		if not lCurrentCategoryIndex then
			lCurrentCategoryIndex = 0;
			Auctioneer.Util.ChatPrint(_AUCT('AuctionScanNocat'));
			return;
		end
	end

	-- Start with the first page
	lCurrentAuctionPage = nil;
	lScanInProgress = true;

	-- Hook the functions that we need for the scan
	if( not lOriginal_CanSendAuctionQuery ) then
		lOriginal_CanSendAuctionQuery = CanSendAuctionQuery;
		CanSendAuctionQuery = canSendAuctionQuery;
	end

	if( not lOriginal_AuctionFrameBrowse_OnEvent ) then
		lOriginal_AuctionFrameBrowse_OnEvent = AuctionFrameBrowse_OnEvent;
		AuctionFrameBrowse_OnEvent = Auctioneer.AuctionFrameBrowse.OnEvent;
	end

	if( not lOriginal_AuctionFrameBrowse_Update ) then
		lOriginal_AuctionFrameBrowse_Update = AuctionFrameBrowse_Update;
		AuctionFrameBrowse_Update = Auctioneer.AuctionFrameBrowse.Update;
	end

	Auctioneer.Event.StartAuctionScan();

	lScanStartedAt = GetTime();
	auctionNextQuery();
end

function canScan()
	if (lScanInProgress) then
		return false;
	end
	if (not CanSendAuctionQuery()) then
		return false;
	end
	if (AucBidManager.IsProcessingRequest()) then
		return false;
	end
	return true;
end

function requestAuctionScan(chatPrint)
	Auctioneer.Scanning.IsScanningRequested = true;
	if (AuctionFrame and AuctionFrame:IsVisible()) then
		local iButton;
		local button;

		-- Hide the UI from any current results, show the no results text so we can use it
		BrowseNoResultsText:Show();
		for iButton = 1, NUM_BROWSE_TO_DISPLAY do
			button = getglobal("BrowseButton"..iButton);
			button:Hide();
		end
		BrowsePrevPageButton:Hide();
		BrowseNextPageButton:Hide();
		BrowseSearchCountText:Hide();

		startAuctionScan();
	else
		if (chatPrint) then
			Auctioneer.Util.ChatPrint(_AUCT('AuctionScanNexttime'));
		end
	end
end

Auctioneer.Scanning = {
	IsScanningRequested = isScanningRequested,
	StopAuctionScan = stopAuctionScan,
	CheckCompleteScan = checkCompleteScan,
	QueryAuctionItemsHook = queryAuctionItemsHook,
	ScanAuction = scanAuction,
	StartAuctionScan = startAuctionScan,
	CanScan = canScan,
	RequestAuctionScan = requestAuctionScan,
}