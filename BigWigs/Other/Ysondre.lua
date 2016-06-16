----------------------------------
--      Module Declaration      --
----------------------------------

local boss = BB["Ysondre"]
local mod = BigWigs:New(boss, "$Revision: 200 $")
if not mod then return end
mod.zonename = {BZ["Ashenvale"], BZ["Duskwood"], BZ["The Hinterlands"], BZ["Feralas"]}
mod.otherMenu = "Azeroth"
mod.enabletrigger = boss
mod.guid = 14887
mod.toggleOptions = {"engage", -1, "druids", "noxious", "bosskill"}

----------------------------
--      Localization      --
----------------------------

local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

L:RegisterTranslations("enUS", function() return {
	cmd = "Ysondre",

	engage = "Engage Alert",
	engage_desc = ("Warn when %s is engaged."):format(boss),
	engage_message = "%s Engaged! - Noxious Breath every ~10sec",
	engage_trigger = "The strands of LIFE have been severed! The Dreamers must be avenged!",

	druids = "Druids Alert",
	druids_desc = "Warn for incoming druids.",
	druids_trigger = "Come forth, ye Dreamers - and claim your vengeance!",
	druids_message = "Incoming Druids!",

	noxious = "Noxious breath alert",
	noxious_desc = "Warn for noxious breath.",
	noxious_bar = "~Next Noxious Breath",
} end )

L:RegisterTranslations("zhCN", function() return {
	engage = "激活警报",
	engage_desc = ("当%s激活时发出警报"):format(boss),
	engage_message = "%s 激活！ - 毒性吐息大约在10秒发动",
	engage_trigger = "生命的希翼已被切断！梦游者要展出开报复！",

	druids = "德鲁伊警报",
	druids_desc = "德鲁伊召唤警报",
	druids_trigger = "来吧，梦游者——复仇！",
	druids_message = "疯狂德鲁伊出现！",

	noxious = "毒性吐息",
	noxious_desc = "毒性吐息警报",
	noxious_bar = "毒性吐息",
} end )


L:RegisterTranslations("zhTW", function() return {
	engage = "狂怒警報",
	engage_desc = ("當%s狂怒時發出警報"):format(boss),
	engage_message = "%s狂怒！ 10 秒後可能發動毒性吐息",
	engage_trigger = "The strands of LIFE have been severed! The Dreamers must be avenged!",

	--druids = "Druids Alert",
	--druids_desc = "Warn for incoming druids",
	--druids_trigger = "Come forth, ye Dreamers - and claim your vengeance!",
	--druids_message = "Incoming Druids!",

	noxious = "毒性吐息警報",
	noxious_desc = "毒性吐息警報",
	noxious_bar = "毒性吐息",
} end )

L:RegisterTranslations("frFR", function() return {
	engage = "Engagement",
	engage_desc = ("Préviens quand %s est engagé."):format(boss),
	engage_message = "%s engagé ! - Souffle nauséabond toutes les ~10 sec.",
	engage_trigger = "Les fils de la VIE ont été coupés ! Les Rêveurs doivent être vengés !",

	druids = "Druides",
	druids_desc = "Préviens de l'arrivée des druides.",
	druids_trigger = "Venez, Rêveurs, et demandez vengeance !",
	druids_message = "Arrivée des druides !",

	noxious = "Souffle nauséabond",
	noxious_desc = "Préviens de l'arrivée des Souffles nauséabonds.",
	noxious_bar = "~Prochain Souffle",
} end )

L:RegisterTranslations("deDE", function() return {
	noxious = "Giftiger Atem",
	noxious_desc = "Warnung vor Giftiger Atem.",
	noxious_bar = "Giftiger Atem",
} end )

L:RegisterTranslations("koKR", function() return {
	engage = "전투 시작",
	engage_desc = ("%s의 전투 시작을 알립니다."):format(boss),
	engage_message = "%s 전투 시작! - 약 10초 마다 산성 숨결",
	engage_trigger = "생명의 끈이 끊어졌다! 꿈꾸는 자들이 복수하는 것이 틀림없다!",

	druids = "드루이드 소환",
	druids_desc = "드루이드 소환을 알립니다.",
	druids_trigger = "모습을 드러내라, 꿈꾸는 자들아. 당당히 복수를 외쳐라!",
	druids_message = "잠시 후 드루이드 등장!",

	noxious = "산성 숨결",
	noxious_desc = "산성 숨결을 알립니다.",
	noxious_bar = "~다음 산성 숨결",
} end )

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:AddSyncListener("SPELL_MISSED", 24818, "YsoNox")
	self:AddSyncListener("SPELL_AURA_APPLIED", 24818, "YsoNox")
	self:AddCombatListener("UNIT_DIED", "BossDeath")

	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")

	self:RegisterEvent("BigWigs_RecvSync")
	self:Throttle(7, "YsoNox")
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if self.db.profile.engage and msg == L["engage_trigger"] then
		self:Message(L["engage_message"]:format(boss), "Attention")
		self:Bar(L["noxious_bar"], 10, 24818)
	elseif self.db.profile.druids and msg == L["druids_trigger"] then
		self:Message(L["druids_message"], "Positive")
	end
end

function mod:BigWigs_RecvSync(sync)
	if sync == "YsoNox" and self.db.profile.noxious then
		self:Bar(L["noxious_bar"], 10, 24818)
	end
end

