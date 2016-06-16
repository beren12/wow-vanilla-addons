----------------------------------
--      Module Declaration      --
----------------------------------

local boss = BB["Lethon"]
local mod = BigWigs:New(boss, "$Revision: 200 $")
if not mod then return end
mod.zonename = {BZ["Ashenvale"], BZ["Duskwood"], BZ["The Hinterlands"], BZ["Feralas"]}
mod.otherMenu = "Azeroth"
mod.enabletrigger = boss
mod.guid = 14888
mod.toggleOptions = {"engage", -1, "noxious", "bosskill"}

----------------------------
--      Localization      --
----------------------------

local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

L:RegisterTranslations("enUS", function() return {
	cmd = "Lethon",

	engage = "Engage Alert",
	engage_desc = ("Warn when %s is engaged"):format(boss),
	engage_message = "%s Engaged! - Noxious Breath in ~10seconds",
	engage_trigger = "I can sense the SHADOW on your hearts. There can be no rest for the wicked!",

	noxious = "Noxious breath alert",
	noxious_desc = "Warn for noxious breath",
	noxious_warn = "5 seconds until Noxious Breath!",
	noxious_message = "Noxious Breath - 30 seconds till next!",
	noxious_bar = "Noxious Breath",
} end )

L:RegisterTranslations("zhCN", function() return {
	engage = "激活警报",
	engage_desc = ("当%s激活时发出警报"):format(boss),
	engage_message = "莱索恩激活！ - 毒性吐息大约在10秒后发动",
	engage_trigger = "我能感受到你内心的阴影。邪恶的侵蚀永远不会停止！",

	noxious = "毒性吐息",
	noxious_desc = "毒性吐息警报",
	noxious_warn = "5秒后发动毒性吐息！",
	noxious_message = "毒性吐息 - 30秒后再次发动！",
	noxious_bar = "毒性吐息",
} end )
L:RegisterTranslations("zhTW", function() return {
	engage = "狂怒警報",
	engage_desc = ("當%s狂怒時發出警報"):format(boss),
	engage_message = "%s狂怒！ 10 秒後可能發動毒性吐息",
	engage_trigger = "I can sense the SHADOW on your hearts. There can be no rest for the wicked!",

	noxious = "毒性吐息警報",
	noxious_desc = "毒性吐息警報",
	noxious_warn = "5 秒後發動毒性吐息！",
	noxious_message = "毒性吐息 - 30 秒後再次發動",
	noxious_bar = "毒性吐息",
} end )

L:RegisterTranslations("frFR", function() return {
	engage = "Engagement",
	engage_desc = ("Préviens quand %s est engagé."):format(boss),
	engage_message = "%s engagé ! - Souffle nauséabond dans ~10 sec.",
	engage_trigger = "Je sens l'OMBRE dans vos cœurs. Il ne peut y avoir de repos pour les vilains !",

	noxious = "Souffle nauséabond",
	noxious_desc = "Préviens de l'arrivée des Souffles nauséabonds.",
	noxious_warn = "5 sec. avant le Souffle nauséabond !",
	noxious_message = "Souffle nauséabond - 30 sec. avant le suivant !",
	noxious_bar = "Souffle nauséabond",
} end )

L:RegisterTranslations("deDE", function() return {
	noxious = "Giftiger Atem",
	noxious_desc = "Warnung vor Giftiger Atem.",
	noxious_bar = "Giftiger Atem",
} end )

L:RegisterTranslations("koKR", function() return {
	engage = "전투 시작",
	engage_desc = ("%s의 전투 시작을 알립니다."):format(boss),
	engage_message = "%s 전투 시작! - 약 10초 이내 산성 숨결",
	engage_trigger = "네놈들의 마음속에서 어둠이 느껴지는구나. 사악한 존재가 쉴 곳은 없다!",

	noxious = "산성 숨결",
	noxious_desc = "산성 숨결에 대한 경고입니다.",
	noxious_warn = "산성 숨결 5초 전!",
	noxious_message = "산성 숨결 - 다음은 30 초 후!",
	noxious_bar = "산성 숨결",
} end )

L:RegisterTranslations("ruRU", function() return {
	engage = "Ярость",
	engage_desc = ("Предупреждать, когда %s впадает в ярость"):format(boss),
	engage_message = "%s в ярости! - Пагубное дыхание через ~10секунд",
	engage_trigger = "I can sense the SHADOW on your hearts. There can be no rest for the wicked!",

	noxious = "Пагубное дыхание",
	noxious_desc = "Предупреждать о пагубном дыхании",
	noxious_warn = "5 секунд до пагубного дыхания!",
	noxious_message = "Пагубное дыхание - 30 секунд до следующего!",
	noxious_bar = "Пагубное дыхание",
} end )

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:AddSyncListener("SPELL_MISSED", 24818, "LethNox")
	self:AddSyncListener("SPELL_AURA_APPLIED", 24818, "LethNox")
	self:AddCombatListener("UNIT_DIED", "BossDeath")

	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")

	self:RegisterEvent("BigWigs_RecvSync")
	self:Throttle(7, "LethNox")
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if self.db.profile.engage and msg == L["engage_trigger"] then
		self:Message(L["engage_message"]:format(boss), "Attention")
		self:Bar(L["noxious_bar"], 10, 24818)
	end
end

function mod:BigWigs_RecvSync(sync)
	if sync == "LethNox" and self.db.profile.noxious then
		self:IfMessage(L["noxious_message"], "Important", 24818)
		--self:DelayedMessage(25, L["noxious_warn"], "Urgent")
		self:Bar(L["noxious_bar"], 30, 24818)
	end
end

