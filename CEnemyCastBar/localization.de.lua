-- WARNING
-- THE COMMENTED OUT ABILITIES ARE THERE FOR A REASON
-- PLEASE DO NOT UNCOMMENT THEM, OTHERWISE THINGS WILL PROBABLY BREAK

if ( GetLocale() == "deDE" ) then

	CEnemyCastBar_Spells = {

		-- IMPORTANT: Maybe some spells which cause debuffs have to be moved to CEnemyCastBar_Afflicitions to be shown
		-- "t=x" defines the normal length of the castbar. "d=x" will add a cooldown timer for spells with a casttime and for gains.
		-- "g=0" prevents a bar if a player gains this spell. "g=x" shows a bar of x seconds instead of "t=x" if it's a gain.
		-- "i=x" shows a bar of x seconds additional to "t" (everytime)

		-- All Classes
			-- General
		["Ruhestein"] = {t=10.0, icontex="INV_Misc_Rune_01"};

			-- Trinkets & Racials
		["Spr\195\182der R\195\188stung"] = 	{t=20.0, d=120, icontex="Spell_Shadow_GrimWard"}; -- gain
		["Instabile Macht"] = 			{t=20.0, d=120, icontex="Spell_Lightning_LightningBolt01"}; -- gain
		["Ruhelose St\195\164rke"] = 		{t=20.0, d=120, icontex="Spell_Shadow_GrimWard"}; -- gain
		["Ephemere Macht"] = 			{t=15.0, d=90, icontex="Spell_Holy_MindVision"}; -- gain
		["Arkane Macht"] = 			{t=15.0, d=180, icontex="Spell_Nature_Lightning"}; -- gain
		["Massive Zerst\195\182rung"] = 	{t=20.0, d=180, icontex="Spell_Fire_WindsofWoe"}; -- gain
		["Arkane Kraft"] = 			{t=20.0, d=180, icontex="Spell_Arcane_StarFire"}; -- gain
		["Energiegeladener Schild"] = 		{t=20.0, d=180, icontex="Spell_Nature_CallStorm"}; -- gain
		["Glei\195\159endes Licht"] = 		{t=20.0, d=180, icontex="Spell_Holy_MindVision"}; -- gain
		["Wille der Vergessenen"] = 		{t=5.0, d=120, icontex="Spell_Shadow_RaiseDead"}; -- gain
		["Wachsamkeit"] = 			{t=20.0, d=180, icontex="Spell_Nature_Sleep"}; -- gain
		["Mar'lis fokussierte Gedanken"] = 	{t=30.0, d=180, icontex="INV_ZulGurubTrinket"}; -- gain
		["Kriegsstampfen"] = 			{t=0.5, d=120, icontex="Ability_WarStomp"};
		["Steinform"] = 			{t=8.0, d=180, icontex="Spell_Shadow_UnholyStrength"};

		["Erdsto\195\159"] = 			{t=20.0, d=120, icontex="Spell_Nature_AbolishMagic"}; -- gain
		["Geschenk des Lebens"] = 		{t=20.0, d=300, icontex="INV_Misc_Gem_Pearl_05"}; -- gain
		["Naturverbundenheit"] = 		{t=20.0, d=300, icontex="Spell_Nature_SpiritArmor"}; -- gain

			-- Engineering
		["Frostreflektor"] = 			{t=5.0, d=300.0, icontex="Spell_Frost_FrostWard"}; -- gain
		["Schattenreflektor"] = 		{t=5.0, d=300.0, icontex="Spell_Shadow_AntiShadow"}; -- gain
		["Feuerreflektor"] = 			{t=5.0, d=300.0, icontex="Spell_Fire_SealOfFire"}; -- gain

			-- First Aid
		["Erste Hilfe"] = 			{t=8.0, d=60, icontex="Spell_Holy_Heal"}; -- gain
		["Leinenstoffverband"] = 		{t=3.0, icontex="INV_Misc_Bandage_15"};
		["Schwerer Leinenstoffverband"] = 	{t=3.0, icontex="INV_Misc_Bandage_18"};
		["Wollstoffverband"] = 			{t=3.0, icontex="INV_Misc_Bandage_14"};
		["Schwerer Wollstoffverband"] = 	{t=3.0, icontex="INV_Misc_Bandage_17"};
		["Seidenstoffverbannd"] = 		{t=3.0, icontex="INV_Misc_Bandage_01"};
		["Schwerer Seidenstoffverband"] =	{t=3.0, icontex="INV_Misc_Bandage_02"};
		["Magiestoffverbannd"] =		{t=3.0, icontex="INV_Misc_Bandage_19"};
		["Schwerer Magiestoffverband"] =	{t=3.0, icontex="INV_Misc_Bandage_20"};
		["Runenstoffverband"] = 		{t=3.0, icontex="INV_Misc_Bandage_11"};
		["Schwerer Runenstoffverband"] = 	{t=3.0, icontex="INV_Misc_Bandage_12"};
		                                                                                                      
		-- Druid                                                                                              
		["Heilende Ber\195\188hrung"] = 	{t=3.0, icontex="Spell_Nature_HealingTouch"};
		["Nachwachsen"] = 			{t=2.0, g=21.0, icontex="Spell_Nature_ResistNature"};
		["Wiedergeburt"] = 			{t=2.0, d=1800.0, icontex="Spell_Nature_Reincarnation"};
		["Sternenfeuer"] = 			{t=3.5, icontex="Spell_Arcane_StarFire"};      
		["Zorn"] = 				{t=2.0, icontex="Spell_Nature_AbolishMagic"};
		["Wucherwurzeln"] = 			{t=1.5, icontex="Spell_Nature_StrangleVines"};
		["Spurt"] = 				{t=15.0, d=300.0, icontex="Ability_Druid_Dash"}; -- gain
		["Winterschlaf"] = 			{t=1.5, icontex="Spell_Nature_Sleep"};                        
		["Tier bes\195\164nftigen"] = 		{t=1.5, icontex="Ability_Hunter_BeastSoothe"};
		["Baumrinde"] = 			{t=15.0, d=60, icontex="Spell_Nature_StoneClawTotem"}; -- gain
		["Anregen"] = 				{t=20.0, icontex="Spell_Nature_Lightning"}; -- gain
		["Teleportieren: Moonglade"] = 		{t=10.0, icontex="Spell_Arcane_TeleportMoonglade"};
		["Tigerfuror"] = 			{t=6.0, icontex="Ability_Mount_JungleTiger"}; -- gain
		["Rasende Regeneration"] = 		{t=10.0, d=180.0, icontex="Ability_BullRush"}; -- gain
		["Verj\195\188ngung"] = 		{t=12.0, icontex="Spell_Nature_Rejuvenation"}; -- gain
		["Vergiftung aufheben"] = 		{t=8.0, icontex="Spell_Nature_NullifyPoison_02"}; -- gain

		["Gelassenheit"] = 			{t=10.0, d=300.0, icontex="Spell_Nature_Tranquility"};
		
		-- Hunter
		["Gezielter Schuss"] = 			{t=3.0, d=6.0, icontex="INV_Spear_07"};
		["Wildtier \195\164ngstigen"] = 	{t=1.0, d=30.0, icontex="Ability_Druid_Cower"};
		["Salve"] = 				{t=6.0, d=60.0, icontex="Ability_Marksmanship"};
		["Tier freigeben"] = 			{t=5.0, icontex="Spell_Nature_SpiritWolf"};
		["Tier wiederbeleben"] = 		{t=10.0, icontex="Ability_Hunter_BeastSoothe"};
		["Augen des Wildtiers"] = 		{t=2.0, icontex="Ability_EyeOfTheOwl"};
		["Schnellfeuer"] = 			{t=15.0, d=300.0, icontex="Ability_Hunter_RunningShot"}; -- gain
		["Abschreckung"] = 			{t=10, d=300.0, icontex="Ability_Whirlwind"}; -- gain

		["Mehrfachschuss"] = 			{d=10.0, icontex="Ability_UpgradeMoonGlaive"};

		
		-- Mage
		["Frostblitz"] = {t=2.5, icontex="Spell_Frost_FrostBolt02"};
		["Feuerball"] = {t=3.0, icontex="Spell_Fire_FlameBolt"};
		["Wasser herbeizaubern"] = {t=3.0, icontex="INV_Drink_18"};
		["Essen herbeizaubern"] = {t=3.0, icontex="INV_Misc_Food_33"};
		["Mana-Rubin herbeizaubern"] = {t=3.0, icontex="INV_Misc_Gem_Ruby_01"};
		["Mana-Citrin herbeizaubern"] = {t=3.0, icontex="INV_Misc_Gem_Opal_01"};
		["Mana-Jade herbeizaubern"] = {t=3.0, icontex="INV_Misc_Gem_Emerald_02"};
		["Mana-Achat herbeizaubern"] = {t=3.0, icontex="INV_Misc_Gem_Emerald_01"};
		["Verwandlung"] = {t=1.5, icontex="Spell_Nature_Polymorph"};
		["Verwandlung: Schwein"] = {t=1.5, icontex="Spell_Magic_PolymorphPig"};
		["Verwandlung: Schildkr\195\182te"] = {t=1.5, icontex="Ability_Hunter_Pet_Turtle"};
		["Pyroschlag"] = {t=6.0, icontex="Spell_Fire_Fireball02"};
		["Versenegen"] = {t=1.5, icontex="Spell_Fire_SoulBurn"};
		["Flammensto\195\159"] = {t=3.0, r="Brutw\195\164chter der Todeskrallen", a=2.5, icontex="Spell_Fire_SelfDestruct"};
		["Langsamer Fall"] = {t=30.0, icontex="Spell_Magic_FeatherFall"}; -- gain
		["Portal: Darnassus"] = {t=10.0, icontex="Spell_Arcane_PortalDarnassus"};
		["Portal: Thunder Bluff"] = {t=10.0, icontex="Spell_Arcane_PortalThunderBluff"};
		["Portal: Ironforge"] = {t=10.0, icontex="Spell_Arcane_PortalIronForge"};
		["Portal: Orgrimmar"] = {t=10.0, icontex="Spell_Arcane_PortalOrgrimmar"};
		["Portal: Stormwind"] = {t=10.0, icontex="Spell_Arcane_PortalStormWind"};
		["Portal: Undercity"] = {t=10.0, icontex="Spell_Arcane_PortalUnderCity"};
		["Teleportieren: Darnassus"] = {t=10.0, icontex="Spell_Arcane_TeleportDarnassus"};
		["Teleportieren: Thunder Bluff"] = {t=10.0, icontex="Spell_Arcane_TeleportThunderBluff"};
		["Teleportieren: Ironforge"] = {t=10.0, icontex="Spell_Arcane_TeleportIronForge"};
		["Teleportieren: Orgrimmar"] = {t=10.0, icontex="Spell_Arcane_TeleportOrgrimmar"};
		["Teleportieren: Stormwind"] = {t=10.0, icontex="Spell_Arcane_TeleportStormWind"};
		["Teleportieren: Undercity"] = {t=10.0, icontex="Spell_Arcane_TeleportUnderCity"};
		["Feuer-Zauberschutz"] = {t=30.0, icontex="Spell_Fire_FireArmor"}; -- gain
		["Frost-Zauberschutz"] = {t=30.0, icontex="Spell_Frost_FrostWard"}; -- gain
		["Hervorrufung"] = {t=8.0, icontex="Spell_Nature_Purge"}; -- gain
		["Eisblock"] = {t=10.0, d=300.0, icontex="Spell_Frost_Frost"}; -- gain
		["Arkane Macht"] = {t=15.0, d=180.0, icontex="Spell_Nature_Lightning"}; -- gain

		["Eis-Barriere"] = {d=30.0};
		["Blinzeln"] = {d=15.0, icontex="Spell_Arcane_Blink"};
		
		
		-- Paladin
		["Heiliges Licht"] = {t=2.5, icontex="Spell_Holy_HolyBolt"};
		["Lichtblitz"] = {t=1.5, icontex="Spell_Holy_FlashHeal"};
		["Streitross beschw\195\182ren"] = {t=3.0, g=0.0, icontex="Ability_Mount_Charger"};
		["Schlachtross beschw\195\182ren"] = {t=3.0, g=0.0, icontex="Spell_Nature_Swiftness"};
		["Hammer des Zorns"] = {t=1.0, d=6.0, icontex="Ability_ThunderClap"};
		["Heiliger Zorn"] = {t=2.0, d=60.0, icontex="Spell_Holy_Excorcism"};
		["Untote vertreiben"] = {t=1.5, d=30.0, icontex="Spell_Holy_TurnUndead"};
		["Erl\195\182sung"] = {t=10.0, icontex="Spell_Holy_Resurrection"};
		["G\195\182ttlicher Schutz"] = {t=8.0, d=300.0, icontex="Spell_Holy_Restoration"}; -- gain
		["Gottesschild"] = {t=12.0, d=300.0, icontex="Spell_Holy_DivineIntervention"}; -- gain
		["Segen der Freiheit"] = {t=16.0, icontex="Spell_Holy_SealOfValor"}; -- gain
		["Segen des Schutzes"] = {t=10.0, d=300.0, icontex="Spell_Holy_SealOfProtection"}; -- gain
		["Segen der Opferung"] = {t=30.0, icontex="Spell_Holy_SealOfSacrifice"}; -- gain
		["Rache"] = {t=8.0, icontex="Ability_Racial_Avatar"}; -- gain, Talent

		
		-- Priest
		["Gro\195\159e Heilung"] = {t=2.5, g=15, icontex="Spell_Holy_GreaterHeal"};
		["Heilen"] = {t=2.5, icontex="Spell_Holy_Heal"};
		["Blitzheilung"] = {t=1.5, icontex="Spell_Holy_FlashHeal"};
		["Auferstehung"] = {t=10.0, icontex="Spell_Holy_Resurrection"};
		["G\195\182ttliche Pein"] = {t=2.0, icontex="Spell_Holy_HolySmite"};
		["Gedankenschlag"] = {t=1.5, d=8.0, icontex="Spell_Shadow_UnholyFrenzy"};
		["Gedankenkontrolle"] = {t=3.0, g=0.0, icontex="Spell_Shadow_ShadowWordDominate"};
		["Manabrand"] = {t=3.0, icontex="Spell_Shadow_ManaBurn"};
		["Heiliges Feuer"] = {t=3.0, icontex="Spell_Holy_SearingLight"};
		["Gedankenbes\195\164nftigung"] = {t=1.5, icontex="Spell_Holy_MindSooth"};
		["Gebet der Heilung"] = {t=3.0, icontex="Spell_Holy_PrayerOfHealing02"};
		["Untote fesseln"] = {t=1.5, icontex="Spell_Nature_Slow"};
		["Verblassen"] = {t=10.0, d=30.0, icontex="Spell_Magic_LesserInvisibilty"}; -- gain
		["Erneuerung"] = {t=15.0, icontex="Spell_Holy_Renew"}; -- gain
		["Krankheit aufheben"] = {t=20.0, icontex="Spell_Nature_NullifyDisease"}; -- gain
		["R\195\188ckkopplung"] = {t=15.0, icontex="Spell_Shadow_RitualOfSacrifice"}; -- gain
		["Inspiration"] = {t=15.0, icontex="INV_Shield_06"}; -- gain (target), Talent
		["Seele der Macht"] = {t=15.0, d=180, icontex="Spell_Holy_PowerInfusion"}; -- gain, Talent
		["Fokussiertes Zauberwirken"] = {t=6.0, icontex="Spell_Arcane_Blink"}; -- gain, Talent

		["Machtwort: Schild"] = {t=30, d=15.0, icontex="Spell_Holy_PowerWordShield"}; -- gain


		-- Rogue
		["Falle entsch\195\164rfen"] = {t=2.0, icontex="Spell_Shadow_GrimWard"};
		["Sprinten"] = {t=15.0, d=300.0, icontex="Ability_Rogue_Sprint"}; -- gain
		["Schloss knacken"] = {t=5.0, icontex="Spell_Nature_MoonKey"};
		["Entrinnen"] = {t=15.0, d=300, icontex="Spell_Shadow_ShadowWard"}; -- gain
		["Verschwinden"] = {t=10.0, d=300, icontex="Ability_Vanish"}; -- gain
		["Klingenwirbel"] = {t=15.0, d=120, icontex="Ability_Rogue_SliceDice"}; -- gain

		["Sofort wirkendes Gift VI"] = {t=3.0, icontex="Ability_Poisons"};
		["T\195\182dliches Gift V"] = {t=3.0, icontex="Ability_Rogue_DualWeild"};
		["Verkr\195\188ppelndes Gift"] = {t=3.0, icontex="Ability_PoisonSting"};
		["Verkr\195\188ppelndes Gift II"] = {t=3.0, icontex="Ability_PoisonSting"};
		["Gedankenbenebelndes Gift"] = {t=3.0, icontex="Spell_Nature_NullifyDisease"};
		["Gedankenbenebelndes Gift II"] = {t=3.0, icontex="Spell_Nature_NullifyDisease"};
		["Gedankenbenebelndes Gift III"] = {t=3.0, icontex="Spell_Nature_NullifyDisease"};

		
		-- Shaman
		["Geringe Welle der Heilung"] = {t=1.5, icontex="Spell_Nature_HealingWaveLesser"};
		["Welle der Heilung"] = {t=2.5, icontex="Spell_Nature_MagicImmunity"}; -- talent
		["Geist der Ahnen"] = {t=10.0, icontex="Spell_Nature_Regenerate"};
		["Kettenblitzschlag"] = {t=2.5, d=6.0, icontex="Spell_Nature_ChainLightning"};
		["Geisterwolf"] = {t=3.0, icontex="Spell_Nature_SpiritWolf"};
		["Astraler R\195\188ckruf"] = {t=10.0, icontex="Spell_Nature_AstralRecal"};
		["Kettenheilung"] = {t=2.5, icontex="Spell_Nature_HealingWaveGreater"};
		["Blitzschlag"] = {t=3.0, icontex="Spell_Nature_Lightning"};
		["Fernsicht"] = {t=2.0, icontex="Spell_Nature_FarSight"};
		["Totem der Steinklaue"] = {t=15.0, d=30.0, icontex="Spell_Nature_StoneClawTotem"}; -- ?-- works? -- gain
		["Totem der Manaflut"] = {t=15.0, d=300.0, icontex="Spell_Frost_SummonWaterElemental"}; -- ?-- works? -- gain
		["Totem der Feuernova"] = {t=5.0, d=15.0, icontex="Spell_Fire_SealOfFire"}; -- ?-- works? -- gain
		["Sturmschlag"] = {t=12.0, d=25, icontex="Spell_Holy_SealOfMight"}; -- gain
		["Seelenst\195\164rke der Ahnen"] = {t=15.0, icontex="Spell_Nature_UndyingStrength"}; -- gain (target), Talent
		["Pfad der Heilung"] = {t=15.0, icontex="Spell_Nature_HealingWay"}; -- gain (target), Talent

		["Totem der Erdung"] = {d=15.0, icontex="Spell_Nature_GroundingTotem"}; -- works?

		
		-- Warlock
		["Schattenblitz"] = {t=2.5, icontex="Spell_Shadow_ShadowBolt"};
		["Feuerbrand"] = {t=1.5, icontex="Spell_Fire_Immolation"};
		["Seelenfeuer"] = {t=4.0, d=60.0, icontex="Spell_Fire_Fireball02"};
		["Sengender Schmerz"] = {t=1.5, icontex="Spell_Fire_SoulBurn"};
		["Schreckensross herbeirufen"] = {t=3.0, g=0.0, icontex="Ability_Mount_Dreadsteed"};
		["Teufelsross beschw\195\182ren"] = {t=3.0, g=0.0, icontex="Spell_Nature_Swiftness"};
		["Wichtel beschw\195\182ren"] = {t=6.0, icontex="Spell_Shadow_Imp"};
		["Sukkubus beschw\195\182ren"] = {t=6.0, icontex="Spell_Shadow_SummonSuccubus"};
		["Leerwandler beschw\195\182ren"] = {t=6.0, icontex="Spell_Shadow_SummonVoidWalker"};
		["Teufelsj\195\164ger beschw\195\182ren"] = {t=6.0, icontex="Spell_Shadow_SummonFelHunter"};
		["Furcht"] = {t=1.5, icontex="Spell_Shadow_Possession"};
		["Schreckgeheul"] = {t=2.0, d=40.0, g=0.0, icontex="Spell_Shadow_DeathScream"};
		["Verbannen"] = {t=1.5, icontex="Spell_Shadow_Cripple"};
		["Ritual der Beschw\195\182rung"] = {t=5.0, icontex="Spell_Shadow_Twilight"};
		["Ritual der Verdammnis"] = {t=10.0, icontex="Spell_Shadow_AntiMagicShell"};
		["Zauberstein herstellen"] = {t=5.0, icontex="INV_Misc_Gem_Sapphire_01"};
		["Seelenstein herstellen"] = {t=3.0, icontex="Spell_Shadow_SoulGem"};
		["Gesundheitsstein herstellen"] = {t=3.0, icontex="INV_Stone_04"};
		["Gesundheitsstein herstellen (erheblich)"] = {t=3.0, icontex="INV_Stone_04"};
		["Feuerstein herstellen"] = {t=3.0, icontex="INV_Ammo_FireTar"};
		["D\195\164monensklave"] = {t=3.0, icontex="Spell_Shadow_EnslaveDemon"};
		["Inferno"] = {t=2.0, d=3600, icontex="Spell_Fire_Incinerate"};
		["Schatten-Zauberschutz"] = {t=30.0, icontex="Spell_Shadow_AntiShadow"}; -- gain
		["Fluch verst\195\164rken"] = {t=30.0, d=180, icontex="Spell_Shadow_Contagion"}; -- gain

			-- Imp
			["Feuerblitz"] = {t=1.5, icontex="Spell_Fire_FireBolt"};
			
			-- Succubus
			["Verf\195\188hrung"] = {t=1.5, icontex="Spell_Shadow_MindSteal"};
			["Bes\195\164nftigender Kuss"] = {t=4.0, d=4.0, icontex="Spell_Shadow_SoothingKiss"};
			
			-- Voidwalker
			["Schatten verzehren"] = {t=10.0, icontex="Spell_Shadow_AntiShadow"}; -- gain

		
		-- Warrior
		["Blutrausch"] = {t=10.0, d=60, icontex="Ability_Racial_BloodRage"}; -- gain
		["Blutdurst"] = {t=8.0, icontex="Spell_Nature_BloodLust"}; -- gain
		["Schildwall"] = {t=10.0, d=1800.0, icontex="Ability_Warrior_ShieldWall"}; -- gain
		["Tollk\195\188hnheit"] = {t=15.0, d=1800.0, icontex="Ability_CriticalStrike"}; -- gain
		["Gegenschlag"] = {t=15.0, d=1800.0, icontex="Ability_Warrior_Challange"}; -- gain
		["Berserkerwut"] = {t=10.0, d=30, icontex="Spell_Nature_AncestralGuardian"}; -- gain
		["Letztes Gefecht"] = {t=20.0, d=600, icontex="Spell_Holy_AshesToAshes"}; -- gain
		["Todeswunsch"] = {t=30.0, d=180, icontex="Spell_Shadow_DeathPact"}; -- gain
		-- ["Wutanfall"] = {t=12.0, icontex="Spell_Shadow_UnholyFrenzy"}; -- gain
		["Schildblock"] = {t=5.5, icontex="Ability_Defend"}; -- gain, 1 Talent point in impr. block


		-- Mobs
		["Schrumpfen"] = {t=3.0, icontex="Spell_Ice_MagicDamage"};
		["Bansheefluch"] = {t=2.0, icontex="Spell_Nature_Drowsy"};
		["Schattenblitz-Salve"] = {t=3.0, icontex="Spell_Shadow_ShadowBolt"};
		["Verkr\195\188ppeln"] = {t=3.0, icontex="Spell_Shadow_Cripple"};
		["Dunkle Besserung"] = {t=3.5, icontex="Spell_Shadow_ChillTouch"}; -- gain
		["Willensverfall"] = {t=2.0, icontex="Spell_Holy_HarmUndeadAura"};
		["Windsto\195\159"] = {t=2.0, icontex="Spell_Nature_EarthBind"};
		["Schwarzer Schlamm"] = {t=3.0, icontex="Spell_Shadow_CallofBone"};
		["Toxischer Blitz"] = {t=2.0, icontex="Spell_Nature_CorrosiveBreath"};
		["Giftspucke"] = {t=2.0, icontex="Spell_Nature_CorrosiveBreath"};
		["Wilde Regeneration"] = {t=3.0, g=0, icontex="Spell_Nature_Rejuvenation"};
		["Fluch der Totenwaldfelle"] = {t=2.0, icontex="Spell_Shadow_GatherShadows"};
		["Blutfluch"] = {t=2.0, icontex="Spell_Shadow_RitualOfSacrifice"};
		["Dunkler Schlamm"] = {t=5.0, icontex="Spell_Shadow_CreepingPlague"};
		["Seuchenwolke"] = {t=2.0, icontex="Spell_Shadow_CallofBone"};
		["Wandernde Seuche"] = {t=2.0, icontex="Spell_Shadow_CallofBone"};

		
	}
	
	CEnemyCastBar_Raids = {
		-- "mcheck" to only show a bar if cast from this mob. Shows a spell if the mobname is a part of 'mcheck'. mcheck="Ragnaros - Princess Yauj" possible!
		-- "m" sets a mob's name for the castbar; "i" shows a second bar; "r" sets a different CastTime for this Mob (r = "Mob1 Mob2 Mob3" possible *g*)
		-- "active" only allows this spell to be an active cast, no afflictions and something else!
		-- "global" normally is used for afflictions to be shown even it's not your target, but here the important feature is that the castbar won't be updated if active!
		-- "checktarget" checks if the mob casted this spell is your current target. Normally this isn't done with RaidSpells.
		-- "icasted" guides this spell through the instant cast protection
		-- checkevent="Event1 - Event2" to bind spells to only trigger a castbar if these events were fired. (Example: checkevent="CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE - CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE" )
		-- checkengage="true" will only trigger a castbar if the engage protection is running! (Used for Yauj fear for example to prevent CBs at other Mobs that fear players within AQ!)
		-- aZone="InstanceName" to only allow this spell to trigger a CastBar in the specific (Main)Zone. (Not the minimap zone, but the big global Zone e.g. Stormwind, not Trade District! Example: aZone="Ahn'Qiraj"
		-- aBar="NextSpellName" will trigger the defined spell instantly when the source CastBar runs out (e.g. 'Dark Glare'). Will only do that if the User is in combat or dead! Won't broadcast the next triggered spell to the raid!
		-- pBar="NextSpellName" will trigger the defined spell instantly when the source CastBar APPEARS! (e.g. 'Web Spray'). Won't broadcast the next triggered spell to the raid!
		-- tchange={"SpellName", duration1, duration2} will change the duration of defined Spell when the CastBar runs out (e.g. tchange={"Inevitable Doom", 30, 15} for '15 sec Doom CD!' Bar). Duration1 is applied (reset) if the EngageProtection is disabled and the player enters combat the next time!

		-- Naxxramas

			-- Anub'Rekhan
			["First Locust Swarm"] = {t=90, c="cooldown", icontex="Spell_Nature_InsectSwarm"};
			["Heuschreckenschwarm"] = {t=23, i=3, c="gains", aBar="Heuschreckenschwarm CD", active="true", icontex="Spell_Nature_InsectSwarm"};
			["Heuschreckenschwarm CD"] = {t=70, c="cooldown", icontex="Spell_Nature_InsectSwarm"};

			-- Patchwerk
			["Enraged Mode"] = {t=420, c="cooldown", icontex="Spell_Shadow_UnholyFrenzy"}; -- don't translate, used internally!

			-- Razuvious
			["Unterbrechungsruf"] = {t=25, c="cooldown", active="true", icontex="Ability_Creature_Disease_02"};

			-- Gluth
			["Erschreckendes Gebr\195\188ll"] = {t=20.0, c="cooldown", m="Gluth", icontex="Ability_Devour"}; -- Gluth Fears every 20seconds
			["Dezimieren"] = {t=105, c="cooldown", active="true", icontex="Ability_Creature_Disease_02"};

			-- Maexxna
			["Gespinstschauer"] = {t=40, c="cooldown", pBar="Mini Spinnen", m="Maexxna", aZone="Naxxramas", icontex="Ability_Ensnare"};
			["Mini Spinnen"] = {t=30, c="cooldown", pBar="Fangnetz CD", icontex="INV_Misc_MonsterSpiderCarapace_01"};
			["Fangnetz CD"] = {t=20, c="cooldown", icontex="Spell_Nature_Web"};

			-- Thaddius
			["Polarity Shift"] = {t=30, i=3, c="cooldown", mcheck="Thaddius", icontex="Spell_Nature_Lightning"}; --! TRANSLATE SPELL!

			-- Faerlina
			["Wutanfall"] = {t=60, c="cooldown", mcheck="Gro\195\159witwe Faerlina", icontex="Spell_Shadow_UnholyFrenzy"};
			["Umarmung der Witwe"] = {t=30, c="cooldown", mcheck="Gro\195\159witwe Faerlina", icontex="Spell_Arcane_Blink"}; -- Fearlina

			-- Loatheb
			["15 sec Doom CD!"] = {t=299, tchange={"Inevitable Doom", 30, 15}, c="cooldown", m="Loatheb", icontex="Spell_Shadow_NightOfTheDead"}; -- don't translate, used internally! --! TRANSLATE 'tchange' ONLY!
			["First Inevitable Doom"] = {t=120, c="cooldown", m="Loatheb", icontex="Spell_Shadow_NightOfTheDead"}; -- don't translate, used internally!
			["Inevitable Doom"] = {t=30, c="cooldown", m="Loatheb", icontex="Spell_Shadow_NightOfTheDead"}; --! TRANSLATE SPELL!

			-- Gothik
			["Comes Down"] = {t=270, c="cooldown", icontex="Spell_Shadow_RaiseDead"}; -- don't translate, used internally!

			-- Noth
			["Blinzeln"] = {t=30, c="cooldown", mcheck="Noth der Seuchenf\195\188rst", aZone="Naxxramas", icontex="Spell_Arcane_Blink"}; --Noth blinks every 30sec, agro reset.
			["First Teleport"] = {t=90, c="cooldown", aBar="On Balcony 1", aZone="Naxxramas", icontex="Spell_Nature_AstralRecalGroup"};
			["On Balcony 1"] = {t=70, c="cooldown", aBar="Second Teleport", icontex="Spell_Nature_AstralRecalGroup"};
			["Second Teleport"] = {t=110, c="cooldown", aBar="On Balcony 2", icontex="Spell_Nature_AstralRecalGroup"};
			["On Balcony 2"] = {t=95, c="cooldown", aBar="Third Teleport", icontex="Spell_Nature_AstralRecalGroup"};
			["Third Teleport"] = {t=180, c="cooldown", aBar="On Balcony 3", icontex="Spell_Nature_AstralRecalGroup"};
			["On Balcony 3"] = {t=120, c="cooldown", icontex="Spell_Nature_AstralRecalGroup"};

			-- Heigan
			["On Platform"] = {t=45, c="cooldown", aBar="Teleport CD", icontex="INV_Enchant_EssenceAstralLarge"};
			["Teleport CD"] = {t=90, c="cooldown", icontex="INV_Enchant_EssenceAstralLarge"};

		-- Ahn'Qiraj

			-- 40 Man
				["Obsidianvernichter"] = {t=1800.0, c="cooldown", global="true", m="Respawn", icontex="Spell_Holy_Resurrection"};
	
				-- Twin Emperors
				["Zwillingsteleport"] = {t=30.0, c="cooldown", icasted="true", icontex="Spell_Arcane_Blink"};
				["K\195\164fer explodieren lassen"] = {t=5.0, c="gains", icontex="Spell_Fire_Fire"};
				["K\195\164fer mutieren"] = {t=5.0, c="gains", icontex="Ability_Hunter_Pet_Scorpid"};

				-- Ouro
				["Ouroh\195\188gel beschw\195\182ren"] = {t=30, c="cooldown", icasted="true", icontex="INV_Qiraj_OuroHide"};
				["Ouroskarab\195\164en beschw\195\182ren"] = {t=60, c="gains", icasted="true", icontex="INV_Scarab_Crystal"};
				["Sandsto\195\159"] = {t=2.0, c="hostile", mcheck="Ouro", icontex="Spell_Nature_Cyclone"};
				["Feger"] = {t=21, i=1.0, c="cooldown", mcheck="Ouro", icontex="Spell_Nature_Thorns"};

				-- C'Thun
				["First Dark Glare"] = {t=48, c="cooldown", aBar="Dark Glare", icontex="Spell_Nature_CallStorm"};  -- don't translate, used internally! +auto global="true" on engage!
				["Weakened!"] = {t=45, c="gains"};  -- don't translate, used internally!
				["Dark Glare"] = {t=86, i=40, c="cooldown", active="true", aBar="Dark Glare", icontex="Spell_Nature_CallStorm"};

				-- Skeram
				["Arkane Explosion"] = {t=1.2, c="hostile", mcheck="Der Prophet Skeram", icontex="Spell_Nature_WispSplode"};

				-- Sartura (Twin Emps enrage + Hakkar enrage)
				["Wirbelwind"] = {t=15.0, c="gains", mcheck="Schlachtwache Sartura", icontex="Ability_Whirlwind"};
				["Enraged mode"] = {t=900, r="Sartura Hakkar", a=600, c="cooldown", icontex="Spell_Shadow_UnholyFrenzy"}; -- don't translate, used internally! +if player enters combat and target are twins! +auto global="true" on engage!
				["Enters Enraged mode"] = {t=3, c="gains", icontex="Spell_Shadow_UnholyFrenzy"}; -- don't translate, used internally!

				-- Huhuran
				["Berserk mode"] = {t=300, c="cooldown", icontex="Racial_Troll_Berserk"}; -- don't translate, used internally! if player enters combat and target is Huhuran! +auto global="true" on engage!
				["Enters Berserk mode"] = {t=3, c="gains", icontex="Racial_Troll_Berserk"}; -- don't translate, used internally!
				["Stich des Fl\195\188geldrachen"] = {t=25, c="cooldown", m="Huhuran", aZone="Ahn'Qiraj", checkevent="CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE - CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE - CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", icontex="INV_Spear_02"};

				-- Yauj
				["Furcht"] = {t=20, c="cooldown", checkengage="true", m="Yauj", aZone="Ahn'Qiraj", checkevent="CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE - CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE - CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", icontex="Spell_Shadow_Possession"};
				["Gro\195\159es Heilen"] = {t=2.0, c="hostile", m="Yauj", mcheck="Prinzessin Yauj", icontex="Spell_Holy_Heal"};
			
			-- 20 Man

				["Explodieren"] = {t=6.0, c="hostile", icontex="Spell_Fire_SelfDestruct"};

				-- Ossirian
				["Arkanschw\195\164che"] = {t=45, c="gains", mcheck="Ossirian der Narbenlose", icontex="INV_Misc_QirajiCrystal_01"};
				["Feuerschw\195\164che"] = {t=45, c="gains", mcheck="Ossirian der Narbenlose", icontex="INV_Misc_QirajiCrystal_02"};
				["Naturschw\195\164che"] = {t=45, c="gains", mcheck="Ossirian der Narbenlose", icontex="INV_Misc_QirajiCrystal_03"};
				["Frostschw\195\164che"] = {t=45, c="gains", mcheck="Ossirian der Narbenlose", icontex="INV_Misc_QirajiCrystal_04"};
				["Schattenschw\195\164che"] = {t=45, c="gains", mcheck="Ossirian der Narbenlose", icontex="INV_Misc_QirajiCrystal_05"};
		
				-- Moam
				["Until Stoneform"] = {t=90, c="grey", icontex="Spell_Shadow_UnholyStrength"}; -- don't translate, used internally!
				["Energiezufuhr"] = {t=90, c="gains", icontex="Spell_Nature_Cyclone"};

		-- ZulGurub

			-- Hakkar
			["Bluttrinker"] = {t=90.0, c="cooldown", mcheck="Hakkar", checkevent="CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS", icontex="Spell_Shadow_LifeDrain02"};
		
		-- Molten Core
		
			-- Lucifron
			["Drohende Verdammnis"] = {t=20.0, c="cooldown", m="Lucifron", icontex="Spell_Shadow_NightOfTheDead"};
			["Lucifrons Fluch"] = {t=20.0, c="cooldown", m="Lucifron", icontex="Spell_Shadow_BlackPlague"};
		
			-- Magmadar
			["Panik"] = {t=30.0, c="cooldown", m="Magmadar", icontex="Spell_Shadow_DeathScream"};

			-- Gehennas
			["Gehennas Fluch"] = {t=30.0, c="cooldown", m="Gehennas", icontex="Spell_Shadow_GatherShadows"};

			-- Geddon
			["Inferno"] = {t=8.0, c="gains", mcheck="Baron Geddon", icontex="Spell_Fire_Incinerate"};

			-- Majordomo
			["Magiereflexion"] = {t=30.0, i=10.0, c="cooldown", m="Majordomo", aZone="Geschmolzener Kern", icontex="Spell_Frost_FrostShock"};
			["Schadenschild"] = {t=30.0, i=10.0, c="cooldown", m="Majordomo", icontex="Spell_Nature_LightningShield"};
			
			-- Ragnaros
			["Submerge"] = {t=180.0, c="cooldown", icontex="Spell_Fire_Volcano"}; -- don't translate, used internally!
			["Knockback"] = {t=28.0, c="cooldown", icontex="Ability_Kick"}; -- don't translate, used internally!
			["Sons of Flame"] = {t=90.0, c="cooldown", icontex="ell_Fire_LavaSpawn"}; -- don't translate, used internally!

		-- Onyxia
			["Flammenatem"] = {t=2.0, c="hostile", active="true", icontex="Spell_Fire_Fire"};
			
		-- Blackwing Lair

			-- Razorgore
			["Mob Spawn (45sec)"] = {t=45.0, c="cooldown", icontex="Spell_Shadow_RaiseDead"}; -- don't translate, used internally!

			-- Firemaw/Flamegor/Ebonroc
			["Fl\195\188gelsto\195\159"] = {t=31.5, i=1.2, c="cooldown", r="Onyxia", a=0, icontex="INV_Misc_MonsterScales_14"};
			["First Wingbuffet"] = {t=30.0, c="cooldown", icontex="INV_Misc_MonsterScales_14"}; -- don't translate, used internally! if player enters combat and target is firemaw or flamegor this castbar appears to catch the first wingbuffet!
			["Schattenflamme"] = {t=2.0, c="hostile", active="true", icontex="Spell_Fire_Incinerate"};
			
			-- Flamegor
			["Frenzy (CD)"] = {t=10.0, c="cooldown", icontex="INV_Misc_MonsterClaw_03"}; -- don't translate, used internally!
			
			-- Chromaggus
			["Frostbeulen"] = {t=60.0, i=2.0, c="cooldown", active="true", icontex="Spell_Frost_ChillingBlast"};
			["Zeitraffer"] = {t=60.0, i=2.0, c="cooldown", active="true", icontex="Spell_Arcane_PortalOrgrimmar"};
			["Fleisch entz\195\188nden"] = {t=60.0, i=2.0, c="cooldown", active="true", icontex="Spell_Fire_Fire"};
			["\195\132tzende S\195\164ure"] = {t=60.0, i=2.0, c="cooldown", active="true", icontex="Spell_Nature_Acid_01"};
			["Verbrennen"] = {t=60.0, i=2.0, c="cooldown", active="true", icontex="Spell_Fire_FlameShock"};
			["Killing Frenzy"] = {t=15.0, c="cooldown", icontex="INV_Misc_MonsterClaw_03"}; -- don't translate, used internally!
				-- Chromaggus, Flamegor, Magmadar etc.
			["Raserei"] = {t=8.0, c="gains", checktarget="true", icontex="INV_Misc_MonsterClaw_03"};

			-- Neferian/Onyxia
			["Dr\195\182hnendes Gebr\195\188ll"] = {t=2.0, c="hostile", r="Onyxia", a=1.5, active="true", icontex="Spell_Shadow_Charm"};
			
			-- Nefarian
			["Nefarian calls"] = {t=30.0, c="gains", icontex="INV_Misc_Head_Dragon_Black"}; -- don't translate, used internally!
			["Mob Spawn"] = {t=8.0, c="hostile", icontex="Spell_Shadow_RaiseDead"}; -- don't translate, used internally!
			["Landing"] = {t=10.0, c="hostile", icontex="INV_Misc_Head_Dragon_Black"}; -- don't translate, used internally!
			
		-- Outdoor
		
			-- Azuregos
			["Manasturm"] = {t=10.0, c="hostile", icontex="Spell_Frost_IceStorm"};

		-- Other

			["Boss incoming"] = {t=0}; -- don't translate, used internally!

	}


	CEnemyCastBar_Afflictions = {

	-- Warning: only add Spells with the "CEnemyCastBar_SPELL_AFFLICTED" pattern here!
	-- fragile="true", if mob with the same name dies, the bar won't be removed
	-- multi="true", the bar is not removed if debuff fades earlier (usefull if one spell is allowed to produce multiple afflictions)
	-- stun="true", flags all spells which use the same Diminishing Return timer. These 8 Spells were tested to use one and the same timer.
		-- stuntype="true", forces non stun="true" CastBars to use the stun-color
	-- death="true", removes the castbar although it is a "fragile"
	-- periodicdmg="true" -> don't update and remove those castbars, only allows periodic damage done by yourself
	-- spellDR="true", triggers a separate class DR Timer;
		-- always(!) use spellDR together with sclass="PlayersCLASS", or you will produce errors!
	-- affmob="true", this stun triggers a class specific DR Timer on a mob (not player), too
	-- drshare="name", all spells with the same drshare name will trigger the same DR Timer called 'name'
	-- checkclass="classname", will only show this spell to specified class
	-- tskill={talentTab, talentNumber, talentTimeBonus, talentClass, offset, relativeTimeBonus(optional) }, adds "talentTimeBonus" to the duration of this skill dependend on invested skillpoints! "Offset" is additionally added to the duration if more than one talentpoint is invested.
	-- more to tskill: if "talentTimeBonus" is 0 then the relativeTimeBonus(optional) is used (percentage), needed for hunters talent
	-- plevel={durationBonusPerSkillLevel, PlayerLevelAbleToLearnNewSkillLevel (e.g. 60, 40, 20), exchangeLowestLevelWith "0" ALWAYS!} (correct examples are below)
	-- aZone="InstanceName" to only allow this spell to trigger a CastBar in the specific (Main)Zone. (Not the minimap zone, but the big global Zone e.g. Stormwind, not Trade District! Example: aZone="Ahn'Qiraj"
	-- blockZone="ZoneName" blocks the spell for the specified Zone (example: blockZone="Ahn'Qiraj" for 'Entangling Roots')

		-- Naturfreund | Warrior Afflicions
		["Spott"] = {t=3.0, multi="true", icontex="Spell_Nature_Reincarnation"};
		["Sp\195\182ttischer Schlag"] = {t=6.0, multi="true", icontex="Ability_Warrior_PunishingBlow"};
		["Herausforderungsruf"] = {t=6, multi="true", icontex="Ability_BullRush"};
		["Kniesehne"] = {t=15.0, icontex="Ability_ShockWave"};
		["Durchdringendes Heulen"] = {t=6.0, icontex="Spell_Shadow_DeathScream"};
			["Schildhieb - zum Schweigen gebracht"] = {t=4, solo="true", icontex="Ability_Warrior_ShieldBash"};
			["Ersch\195\188tternder Schlag"] = {t=5, solo="true", stun="true", icontex="Ability_ThunderBolt"};
			["Sturmangriffsbet\195\164ubung"] = {t=1, solo="true", stun="true", icontex="Ability_Warrior_Charge"};
			["Bet\195\164ubung abfangen"] = {t=3, solo="true", stun="true", icontex="Ability_Rogue_Sprint"};
			["Rachebet\195\164ubung"] = {t=3, solo="true", stuntype="true", icontex="Ability_Warrior_Revenge"};
			["Drohruf"] = {t=8, solo="true", icontex="Ability_GolemThunderClap"};
			["Entwaffnen"] = {t=10, solo="true", icontex="Ability_Warrior_Disarm"};
			["T\195\182dlicher Sto\195\159"] = {t=10, solo="true", icontex="Ability_Warrior_SavageBlow"};
			-- periodic damage spells
				["Verwunden"] = {t=21, periodicdmg="true", icontex="Ability_Gouge"};

		-- Naturfreund | Mage Afflicions
		["Druckwelle"] = {t=6.0, solo="true", stuntype="true", icontex="Spell_Holy_Excorcism_02"};
			["Frostnova"] = {t=8.0, magecold="true", icontex="Spell_Frost_FrostNova"};
			["Erfrierung"] = {t=5.0, magecold="true", icontex="Spell_Frost_FrostArmor"};
			["K\195\164lte"] = {t=5.0, magecold="true", icontex="Spell_Frost_IceStorm"};
			["K\195\164ltekegel"] = {t=8.0, magecold="true", icontex="Spell_Frost_Glacier"};
			["Frostblitz"] = {t=9, magecold="true", icontex="Spell_Frost_FrostBolt02"};
			["Winterk\195\164lte"] = {t=15, magecold="true", icontex="Spell_Frost_ChillingBlast"};
			["Feuerverwundbarkeit"] = {t=30, magecold="true", icontex="Spell_Fire_SoulBurn"};
		["Verwandlung"] = {t=50, plevel={10, 60, 40, 20, 0}, fragile="true", spellDR="true", drshare="Verwandlung", sclass="MAGE", icontex="Spell_Nature_Polymorph"};
		["Verwandlung: Schwein"] = {t=50, plevel={10, 60, 40, 20, 0}, fragile="true", spellDR="true", drshare="Verwandlung", sclass="MAGE", icontex="Spell_Magic_PolymorphPig"};
		["Verwandlung: Schildkr\195\182te"] = {t=50, plevel={10, 60, 40, 20, 0}, fragile="true", spellDR="true", drshare="Verwandlung", sclass="MAGE", icontex="Ability_Hunter_Pet_Turtle"};
			["Gegenzauber - zum Schweigen gebracht"] = {t=4, solo="true", icontex="Spell_Frost_IceShock"};
			-- periodic damage spells
				["Flammensto\195\159"] = {t=8, periodicdmg="true", icontex="Spell_Fire_SelfDestruct"};

		-- Naturfreund | Hunter Afflicions
		["Zurechtstutzen"] = {t=10, icontex="Ability_Rogue_Trip"};
			["Verbesserter Ersch\195\188tternder Schuss"] = {t=3, solo="true", stuntype="true", icontex="Spell_Frost_Stun"};
		["Eisk\195\164ltefalle"] = {t=20.0, plevel={5, 60, 40, 0}, tskill={3, 7, 0, "HUNTER", 0, 0.15}, fragile="true", spellDR="true", sclass="HUNTER", icontex="Spell_Frost_ChainsOfIce"};
		["Schw\195\164che aufdecken"] = {t=7.0, checkclass="HUNTER", icontex="Ability_Hunter_SniperShot"};
		["Ersch\195\188tternder Schuss"] = {t=4, icontex="Spell_Frost_Stun"}; 
		["Vipernbiss"] = {t=8, checkclass="HUNTER", icontex="Ability_Hunter_AimedShot"}; 
			["Stich des Fl\195\188geldrachen"] = {t=12, solo="true", icontex="INV_Spear_02"};
			["Streuschuss"] = {t=4.0, solo="true", icontex="Ability_GolemStormBolt"};
			-- periodic damage spells
				["Schlangenbiss"] = {t=15, periodicdmg="true", icontex="Ability_Hunter_Quickshot"};

		-- Naturfreund | Priest Afflicions
		["Schattenverwundbarkeit"] = {t=15, magecold="true", icontex="Spell_Shadow_ShadowBolt"};
		["Gedankenbes\195\164nftigung"] = {t=15, icontex="Spell_Holy_MindSooth"};
		["Untote fesseln"] = {t=50, plevel={10, 60, 40, 0}, fragile="true", spellDR="true", sclass="PRIEST", icontex="Spell_Nature_Slow"};
			["Psychischer Schrei"] = {t=8, solo="true", icontex="Spell_Shadow_PsychicScream"};
			["Stille"] = {t=5, solo="true", icontex="Spell_Shadow_ImpPhaseShift"};
			-- periodic damage spells
				["Schattenwort: Schmerz"] = {t=18, tskill={3, 4, 3, "PRIEST", 0}, periodicdmg="true", icontex="Spell_Shadow_ShadowWordPain"};
				["Verschlingende Seuche"] = {t=24, periodicdmg="true", icontex="Spell_Shadow_BlackPlague"};
				["Heiliges Feuer"] = {t=10, periodicdmg="true", directhit="true", icontex="Spell_Holy_SearingLight"};

		-- Naturfreund | Warlock Afflicions
		["Verbannen"] = {t=30, plevel={10, 48, 0}, fragile="true", icontex="Spell_Shadow_Cripple"};
		-- Succubus
		["Verf\195\188hrung"] = {t=15, fragile="true", spellDR="true", sclass="WARLOCK", drshare="Verf., Furcht", icontex="Spell_Shadow_MindSteal"};
			["Furcht"] = {t=20, solo="true", spellDR="true", sclass="WARLOCK", drshare="Verf., Furcht", icontex="Spell_Shadow_Possession"};
		["Fluch der Ersch\195\182pfung"] = {t=12, icontex="Spell_Shadow_GrimWard"};
			["Fluch der Zungen"] = {t=30, checkclass="WARLOCK", icontex="Spell_Shadow_CurseOfTounges"};
			["Fluch der Verdammnis"] = {t=60, checkclass="WARLOCK", icontex="Spell_Shadow_AuraOfDarkness"};
			-- periodic damage spells
				["Fluch der Pein"] = {t=24, periodicdmg="true", icontex="Spell_Shadow_CurseOfSargeras"};
				["Verderbnis"] = {t=18, periodicdmg="true", icontex="Spell_Shadow_AbominationExplosion"};
				["Feuerbrand"] = {t=15, periodicdmg="true", directhit="true", icontex="Spell_Fire_Immolation"};
				["Lebensentzug"] = {t=30, periodicdmg="true", icontex="Spell_Shadow_Requiem"};
			["Schattenbrand"] = {t=5, periodicdmg="true", icontex="Spell_Shadow_ScourgeBuild"}; -- special case

		-- Naturfreund | Rogue Afflicions
		["Verkr\195\188ppelndes Gift"] = {t=12, icontex="Ability_PoisonSting"};
		["Kopfnuss"] = {t=45, plevel={10, 48, 28, 0}, fragile="true", spellDR="true", sclass="ROGUE", drshare="Kopfn., Solarpl.", icontex="Ability_Sap"};
			["Nierenhieb"] = {t=6, cpinterval=1, solo="true", stuntype="true", spellDR="true", sclass="ROGUE", affmob="true", icontex="Ability_Rogue_KidneyShot"}; -- own DR
			["Fieser Trick"] = {t=4, solo="true", stun="true", icontex="Ability_CheapShot"};
			["Solarplexus"] = {t=4, tskill={2, 1, 0.5, "ROGUE", 0}, solo="true", stuntype="true", spellDR="true", sclass="ROGUE", drshare="Kopfn., Solarpl.", icontex="Ability_Gouge"}; -- normal 4sec verbessert 5.5sec (no DR)
			["Blenden"] = {t=10, solo="true", spellDR="true", sclass="ROGUE", icontex="Spell_Shadow_MindSteal"};
			["Tritt - zum Schweigen gebracht"] = {t=2, solo="true", icontex="Ability_Kick"};
			["Riposte"] = {t=6, solo="true", icontex="Ability_Warrior_Disarm"};
			["R\195\188stung schw\195\164chen"] = { t=30.0, checkclass="ROGUE", icontex="Ability_Warrior_Riposte" };
			-- periodic damage spells
				["Erdrosseln"] = {t=18, periodicdmg="true", icontex="Ability_Rogue_Garrote"};
				["Blutung"] = {t=22, cpinterval=4, periodicdmg="true", icontex="Ability_Rogue_Rupture"};

		-- Naturfreund | Druid Afflicions
		["Knurren"] = {t=3, multi="true", icontex="Ability_Physical_Taunt"};
		["Herausforderndes Gebr\195\188ll"] = {t=6, multi="true", icontex="Ability_Druid_ChallangingRoar"};
		["Wucherwurzeln"] = {t=27, fragile="true", death="true", blockZone="Ahn'Qiraj", spellDR="true", sclass="DRUID", icontex="Spell_Nature_StrangleVines"};
		["Winterschlaf"] = {t=40, plevel={10, 58, 38, 0}, fragile="true", icontex="Spell_Nature_Sleep"};
			["Hieb"] = {t=4, tskill={2, 4, 0.5, "DRUID", 0}, solo="true", stun="true", icontex="Ability_Druid_Bash"};
			["Anspringen"] = {t=2, tskill={2, 4, 0.5, "DRUID", 0}, solo="true", stun="true", icontex="Ability_Druid_SupriseAttack"};
			["Wilde Attacke - Effekt"] = {t=4, solo="true", stun="true", icontex="Ability_Hunter_Pet_Bear"};
			-- periodic damage spells
				["Insektenschwarm"] = {t=12, periodicdmg="true", icontex="Spell_Nature_InsectSwarm"};
				["Mondfeuer"] = {t=12, periodicdmg="true", directhit="true", icontex="Spell_Nature_StarFall"};
				["Zerfetzen"] = {t=12, periodicdmg="true", icontex="Ability_GhoulFrenzy"};

		-- Naturfreund | Paladin Afflicions
			["Hammer der Gerechtigkeit"] = {t=6, solo="true", stun="true", icontex="Spell_Holy_SealOfMight"};
			["Bu\195\159e"] = {t=6, solo="true", icontex="Spell_Holy_PrayerOfHealing"};

		-- Naturfreund | Shaman Afflicions
		["Frostschock"] = {t=8.0, magecold="true", spellDR="true", sclass="SHAMAN", icontex="Spell_Frost_FrostShock"};
			-- periodic damage spells
				["Flammenschock"] = {t=12, periodicdmg="true", directhit="true", icontex="Spell_Fire_FlameShock"};


	-- Naturfreund | Raidencounter Afflicions
	-- gobal="true" creates a castbar even without a target!

		-- Naxxramas
		["T\195\182dliche Wunde"] = {t=15, global="true", icontex="Ability_CriticalStrike"}; -- Gluth's Healing Debuff
		["Mutagene Injektion"] = {t=10.0, global="true", icontex="Spell_Shadow_CallofBone"}; -- Grobbulus' Mutagen --! VALIDATE TRANSLATION!
		["Fangnetz"] = {t=60.0, global="true", icontex="Spell_Nature_Web"}; --! VALIDATE TRANSLATION! -- Maexxna Web Wraps 3 people after a random ammount of time
		["Necrotic Poison"] = {t=30.0, global="true", icontex="Ability_Creature_Poison_03"}; --! TRANSLATE -- Maexxna MT -healing Debuff(poison)

		-- Zul'Gurub
		["Irrbilder von Jin'do"] = {t=20, global="true", icontex="Spell_Shadow_UnholyFrenzy"}; -- Delusions of Jin'do
		["Wahnsinn verursachen"] = {t=9.5, global="true", icontex="Spell_Shadow_ShadowWordDominate"}; -- Hakkars Mind Control
		["Bedrohlicher Blick"] = {t=5.7, global="true", icontex="Spell_Shadow_Charm"}; -- Mandokir's Gaze

		-- MC
		["Lebende Bombe"] = {t=8, global="true", icontex="INV_Enchant_EssenceAstralSmall"}; -- Geddon's Bomb

		-- BWL
		["Gro\195\159brand"] = {t=10.0, global="true", icontex="Spell_Fire_Incinerate"}; -- Razorgores (and Drakkisaths) Burning!
		["Brennendes Adrenalin"] = {t=20.0, global="true", icontex="INV_Gauntlets_03"}; -- Vaelastrasz BA!
		["Schattenschwinges Schatten"] = {t=8.0, global="true", icontex="Spell_Shadow_GatherShadows"}; -- Ebonroc selfheal debuff

		-- AQ40
		["Wahre Erf\195\188llung"] = {t=20, global="true", icontex="Spell_Shadow_Charm"}; -- Skeram MindControl
		["Seuche"] = {t=40, global="true", icontex="Spell_Shadow_CurseOfTounges"}; -- Anubisath Defenders Plague
		["Umschlingen"] = {t=10, global="true", icontex="Spell_Nature_StrangleVines"}; -- Fankriss the Unyielding's Entangle

		-- AQ20
		["Paralisieren"] = {t=10, global="true", aZone="Ruinen von Ahn'Qiraj", icontex="Ability_Creature_Poison_05"}; -- Ayamiss the Hunter

		-- Non Boss DeBuffs:
		["Gro\195\159e Verwandlung"] = {t=20.0, fragile="true", icontex="Spell_Nature_Brilliance"}; -- Polymorph of BWL Spellbinders


	-- REMOVALS
	-- just to remove the bar if this spell fades (t is useless here) | only the spells in "CEnemyCastBar_Afflictions" are checked by the "fade-engine"
		-- Moam
		["Energiezufuhr"] = {t=0, global="true"};
		-- Other
		["Raserei"] = {t=0, global="true"};
		["Stun DR"] = {t=0}; -- don't translate, used internally! clear the dimishing return timer if mob dies


	}


	-- Zul'Gurub
	CEnemyCastBar_HAKKAR_YELL			= "EURE \195\156BERHEBLICHKEIT K\195\156NDET BEREITS VOM ENDE DIESER WELT";

	-- Naxxramas
	CEnemyCastBar_HEIGAN_YELL1 = "Ihr entgeht mir nicht...";
	CEnemyCastBar_HEIGAN_YELL2 = "Ihr geh\195\182rt mir...";
	CEnemyCastBar_HEIGAN_YELL3 = "Ihr seid.... als n\195\164chstes dran.";
	CEnemyCastBar_HEIGAN_TELEPORT_YELL = "Euer Ende naht.";

	CEnemyCastBar_FAER_YELL1 = "Kniet nieder, Wurm!";
	CEnemyCastBar_FAER_YELL2 = "Ihr k\195\182nnt euch nicht vor mir verstecken!";
	CEnemyCastBar_FAER_YELL3 = "Flieht, solange ihr noch k\195\182nnt";
	CEnemyCastBar_FAER_YELL4 = "T\195\182tet sie im Namen des Meisters!";

	CEnemyCastBar_PATCHWERK_NAME			= "Flickwerk";

	CEnemyCastBar_GOTHIK_YELL			= "Ihr Narren habt euren eigenen Untergang heraufbeschworen.";

	CEnemyCastBar_ANUB_YELL1			= "Nur einmal kosten...";
	CEnemyCastBar_ANUB_YELL2			= "Rennt! Das bringt das Blut in Wallung!";
	CEnemyCastBar_ANUB_YELL3			= "Es gibt kein Entkommen.";

	-- AQ40
	CEnemyCastBar_SARTURA_CALL			= "Ich verurteile";
	CEnemyCastBar_SARTURA_CRAZY			= "wird w\195\188tend";

	CEnemyCastBar_HUHURAN_CRAZY			= "verf\195\164llt in Berserkerwut";
	CEnemyCastBar_HUHURAN_FRENZY			= "ger\195\164t in Raserei";

	CEnemyCastBar_CTHUN_NAME1	 		= "Auge von C'Thun";
	CEnemyCastBar_CTHUN_WEAKENED			= "ist geschw\195\164cht!";

	-- Ruins of AQ
	CEnemyCastBar_MOAM_STARTING			= "sp\195\188rt Eure Angst.";

	-- MC
	CEnemyCastBar_RAGNAROS_STARTING			= "NUN ZU EUCH, INSEKTEN";
	CEnemyCastBar_RAGNAROS_KICKER			= "SP\195\156RT DIE FLAMMEN";
	CEnemyCastBar_RAGNAROS_SONS	 		= "KOMMT HERBEI, MEINE DIENER";

	-- BWL	
	CEnemyCastBar_RAZORGORE_CALL			= "Eindringlinge sind in die";

	CEnemyCastBar_FIREMAW_NAME			= "Feuerschwinge";
	CEnemyCastBar_EBONROC_NAME			= "Schattenschwinge";
	CEnemyCastBar_FLAMEGOR_NAME			= "Flammenmaul";
	CEnemyCastBar_FLAMEGOR_FRENZY			= "ger\195\164t in Raserei!";
	CEnemyCastBar_CHROMAGGUS_FRENZY			= "ger\195\164t in t\195\182dliche Raserei!";
	
	CEnemyCastBar_NEFARIAN_STARTING			= "Lasst die Spiele beginnen!";
	CEnemyCastBar_NEFARIAN_LAND			= "Sehr gut, meine Diener";
	CEnemyCastBar_NEFARIAN_SHAMAN_CALL		= "Schamanen";
	CEnemyCastBar_NEFARIAN_DRUID_CALL		= "Druiden und ihre l\195\164cherliche";
	CEnemyCastBar_NEFARIAN_WARLOCK_CALL		= "Hexenmeister, Ihr solltet nicht";
	CEnemyCastBar_NEFARIAN_PRIEST_CALL		= "Priester! Wenn Ihr weiterhin";
	CEnemyCastBar_NEFARIAN_HUNTER_CALL		= "J\195\164ger und ihre l\195\164stigen";
	CEnemyCastBar_NEFARIAN_WARRIOR_CALL		= "Krieger, Ich bin mir";
	CEnemyCastBar_NEFARIAN_ROGUE_CALL		= "Schurken";
	CEnemyCastBar_NEFARIAN_PALADIN_CALL		= "Paladine";
	CEnemyCastBar_NEFARIAN_MAGE_CALL		= "Auch Magier";


	-- Event Patterns	
	CEnemyCastBar_MOB_DIES					= "(.+) stirbt"
	CEnemyCastBar_SPELL_GAINS 				= "(.+) bekommt (.+)."
	CEnemyCastBar_SPELL_CAST 				= "(.+) beginnt (.+) zu wirken."
	CEnemyCastBar_SPELL_PERFORM				= "(.+) beginnt (.+) auszuf\195\188hren."
	CEnemyCastBar_SPELL_CASTS				= "(.+) wirkt (.+)."
	CEnemyCastBar_SPELL_AFFLICTED				= "(.+) ist von (.+) betroffen.";
	CEnemyCastBar_SPELL_AFFLICTED2				= "(.+) seid von (.+) betroffen.";
	CEnemyCastBar_SPELL_DAMAGE 				= "(.+) erleidet (.+) von (.+) %(durch (.+)%).";
	--							mob		damage	ddealer	spell
	-- Natufreund
	CEnemyCastBar_SPELL_HITS 				= "(.+)'s (.+) trifft (.+) f\195\188r (.+) Schaden.";
	--							mob	spell		target		damage
	CEnemyCastBar_SPELL_DAMAGE_SELFOTHER			= "(.+) erleidet (.+) %(durch (.+)%).";

	CEnemyCastBar_SPELL_FADE 				= "(.+) schwindet von (.+).";
	--							effect			mob

	CEnemyCastBar_SPELL_REMOVED 				= "(.+) von (.+) wurde entfernt."
	--							spell		mob
								
	CEnemyCastBar_SPELL_HITS_SELFOTHER			= "Euer (.+) trifft (.+). Schaden: (.+).";
	--								spell	 	mob	(damage)
	CEnemyCastBar_SPELL_CRITS_SELFOTHER			= "Euer (.+) trifft (.+) kritisch. Schaden: (.+).";

	CECB_SELF1	= "Ihr";
	CECB_SELF2	= "Euch";


-- Options Menue
CECB_status_txt = "EnemyCastBar Mod aktivieren";
CECB_pvp_txt = "|cffffffaaPvP/Allgemeine|r CastBars aktivieren";
 CECB_globalpvp_txt = "CastBars auch ohne Target zeigen";
  CECB_gainsonly_txt = "Ohne Ziel nur 'gains' anzeigen";
 CECB_gains_txt = "Spelltypus 'gains' aktivieren";
 CECB_cdown_txt = "Einige CoolDownBars aktivieren";
  CECB_cdownshort_txt = "NUR kurze CDs anzeigen";
CECB_pve_txt = "|cffffffaaPvE/Raid|r CastBars aktivieren";
 CECB_pvew_txt = "Sound abspielen bei 'Flash'";
CECB_afflict_txt = "|cffffffaaDebuffs|r anzeigen";
 CECB_globalfrag_txt = "'Mob Outs' ohne Ziel anzeigen";
 CECB_magecold_txt = "K\195\164lte + Verwundbarkeit anzeigen";
 CECB_solod_txt = "'Solo Debuffs' (Stuns) anzeigen";
  CECB_drtimer_txt = "'Diminishing Return' einbeziehen";
  CECB_classdr_txt = "Klassenspez. 'DRs' einbeziehen";
 CECB_sdots_txt = "Eigene DoTs \195\188berwachen";
 CECB_affuni_txt = "NUR Debuffs von RaidBossen zeigen";
CECB_parsec_txt = "Raid/Party/AddOnChat analysieren";
 CECB_broadcast_txt = "CastBars per AddOn Kanal senden";
CECB_targetm_txt = "Ziel w\195\164hlen mit LinksKlick auf Bars";
CECB_timer_txt = "Timer neben CastBars anzeigen";
CECB_tsize_txt = "Kleine Textgr\195\182\195\159e benutzen";
CECB_flipb_txt = "Aufbau der CastBars umdrehen";
CECB_flashit_txt = "CastBars gegen Ende 'flashen'";
CECB_showicon_txt = "Icon neben CastBars anzeigen";
CECB_scale_txt = "Skalierung: ";
CECB_alpha_txt = "Transparenz: ";
CECB_numbars_txt = "Max. Anzahl an CastBars: ";
CECB_space_txt = "Icongr\195\182\195\159e, Abstand der CastBars: ";
CECB_blength_txt = "Breite der CastBars ";
CECB_minimap_txt = "Position an der MiniMap: ";

CECB_status_tooltip = "Aktiviert/ Deaktiviert das Erscheinen von CastBars w\195\164hrend des Spielens und schaltet alle Events ab, um die CPU zu entlasten.";
CECB_pvp_tooltip = "Aktiviert die CastBars f\195\188r alle unterst\195\188tzten, herk\195\182mmlichen Spr\195\188che von Spielern.";
 CECB_globalpvp_tooltip = "Zeigt alle PvP CastBars in Reichweite des CombatLogs an, anstelle nur CastBars des aktuellen Ziels anzuzeigen.\n\n|cffff0000Warnung:|r Diese Einstellung kann zu sehr vielen CastBars f\195\188hren!\n\n|cffff0000Freund-/Feind-Erkennung funktioniert damit nicht!";
  CECB_gainsonly_tooltip = "Zeigt von Einheiten, die sich nicht im Ziel befinden nur sog. 'Gains' an. Das Wirken von Zaubern wird ignoriert.";
 CECB_gains_tooltip = "Aktiviert CastBars f\195\188r sogenannte 'gains'.\nDas sind Spr\195\188che wie 'Eisblock', 'Blutrausch' und Heilung \195\188ber Zeit (HoTs).";
 CECB_cdown_tooltip = "Aktiviert die CoolDown-Zeiten f\195\188r einige(!) Spr\195\188che, die CastZeiten haben oder sog. 'gains' sind.";
  CECB_cdownshort_tooltip = "Zeigt nur Cooldowns an, wenn diese 60 oder weniger Sekunden lang sind.";
CECB_pve_tooltip = "Aktiviert die CastBars f\195\188r PvE/Raid-Encounter";
 CECB_pvew_tooltip = "Spielt einen 'Fump'-Sound ab, wenn eine Raid-CastBar anf\195\164ngt zu 'flashen'.";
CECB_afflict_tooltip = "Zeigt bewegungseinschr\195\164nkende Debuffs, wie z.B. 'Verwandlung' oder 'Kniesehne' an. Aktiviert zugleich viele Debuffs, die Bosse auf Spieler wirken k\195\182nnen, z.B. 'Brennendes Adrenalin'.";
 CECB_globalfrag_tooltip = "Erzeugt CastBars bei 'Mob Outs', selbst wenn es nicht das aktuelle Ziel ist.\n\n'Mob Outs' sind 'Untote fesseln', 'Verbannen', 'Verwandlung' etc.";
 CECB_magecold_tooltip = "Zeigt folgende K\195\164lte Effekte an:\n'Frostnova', 'Erfrierung', 'K\195\164lte', 'K\195\164ltekegel' und 'Frostblitz'.\nDar\195\188berhinaus werden auch Verwundbarkeiten (Schatten, Feuer, K\195\164lte) angezeigt.";
 CECB_solod_tooltip = "Zeigt eine Vielzahl von Bet\195\164ubungseffekten an. Aktiviert auch Schweigen-, Furcht-, Entwaffnen- und Aggro-Effekte!";
  CECB_drtimer_tooltip = "Ber\195\188cksichtigt den 'Diminishing Return' f\195\188r die gr\195\182\195\159te Stun-Gruppe, die den selben Timer benutzt.\nDiese besteht aus 3 Krieger-, 3 Druiden-, 1 Paladin- and 1 Schurken-Stun(s).\n\nZeigt einen Cooldown an bis die volle Stun-L\195\164nge erneut m\195\182glich ist.";
  CECB_classdr_tooltip = "Ber\195\188cksichtigt klassenspezifische 'Diminishing Returns' wie z.B. 'Kopfnuss' und 'Verwandlung'.\n\n|cffff0000Wird in der Regel nur gegen andere Spieler aktiv|r und wird nur der passenden Charakterklasse angezeigt.";
 CECB_sdots_tooltip = "Zeigt die Wirkungsdauer der eigens verursachten DoTs, wie z.B. |cffffffff'Verderbnis' |r-|cffffffff 'Schlangenbiss'|r an.\nDie CastBars erneuern sich nicht, wenn der DoT erneut gesprochen wird, bevor die Wirkungsdauer abl\195\164uft! |cffff0000\nAm besten erst am Ende der Dauer die DoTs erneuern, sonst wird der Timer verr\195\188ckt!|r\n\nDoTs, die zus\195\164tzlich einen Sofort-Schaden verursachen erneuern die CastBar und haben dieses Problem nicht (z.B. |cffffffff'Feuerbrand'|r)!";
 CECB_affuni_tooltip = "Schaltet zur besseren \195\156bersicht alle Debuffs ab, die nicht von RaidBossen stammen.";
CECB_timer_tooltip = "Zeigt die Restzeit der CastBars zus\195\164tzlich als Nummer an.";
CECB_targetm_tooltip = "Erlaubt es, den Mob von dem die CastBar stammt mit einem LinksKlick auf die CastBar anzuw\195\164hlen.";
CECB_parsec_tooltip = "Alle Benutzer, die diese Option aktivieren, erhalten eine CastBar auf dem Bildschirm, wenn im Raid-/Party-/AddOn-Kanal am Anfang folgende Befehle mit Zeitangaben auftauchen: '|cffffffff.countmin|r', '|cffffffff.countsec|r', '|cffffffff.repeat|r' oder '|cffffffff.stopcount|r' (s. Hilfe).\n\nBeispiel:\n|cffffffff.countsec 45 Bis Spawn|r\n\nAnstelle von:\n|cffffffff/necb countsec 45 Bis Spawn";
CECB_broadcast_tooltip = "Raidspr\195\188che und Debuffs werden \195\188ber den AddOn Kanal ausgetauscht.\nFunktioniert nur, wenn Sender und Empf\195\164nger die selbe Sprache benutzen!|cffff0000\n\nACHTUNG:|r Diese Option sollten nur wenige, gezielte Spieler im Raid benutzen!\nPvP Spr\195\188che werden nicht \195\188bertragen.";
CECB_tsize_tooltip = "Verkleinert die Textgr\195\182\195\159e, so da\195\159 mehr Zeichen in die CastBars passen.";
CECB_flipb_tooltip = "Dreht die Richtung in der sich mehrere CastBars aufbauen um.\nNormal: Von unten nach oben.\nEingeschaltet: Von oben nach unten.";
CECB_flashit_tooltip = "CastBars mit einer Gesamtanzeigedauer von wenigstens 20 Sekunden fangen bei 20% Restdauer an zu 'flashen'.\nAber fr\195\188hestens 10 Sekunden vor Ende beginnt dieser Effekt.";
CECB_showicon_tooltip = "Zeigt das Spruch-Icon neben der CastBar an.\n\nDie Gr\195\182\195\159e passt sich der Einstellung 'Icongr\195\182\195\159e, Abstand der CastBars' an.";
CECB_scale_tooltip = "Erlaubt eine Gr\195\182\195\159enanpassung der CastBars von 30 bis 130 Prozent.";
CECB_alpha_tooltip = "Erlaubt es, die Transparenz der CastBars zu justieren.";
CECB_numbars_tooltip = "Gibt die maximale Anzahl an CastBars an, die auf dem Bildschirm zugelassen sind.";
CECB_space_tooltip = "Gibt den Platz zwischen den CastBars an.\n(Standard ist 20)";
CECB_blength_tooltip = "Gibt die zus\195\164tzliche Breite der CastBars an.\n(Standard ist 0)";
CECB_minimap_tooltip = "Bewegt den NECB Knopf an der MiniMap.\n\nNach ganz links schieben, um den Button auszuschalten!";
CECB_fps_tooltip = "Erzeugt ein eigenst\195\164ndiges Dublikat des FPS-Balkens zur freien Platzierung.\n\n|cffff0000Diese Einstellung wird NICHT gespeichert.";


CECB_menue_txt = "Optionen";
CECB_menuesub1_txt = "Welche CastBars anzeigen?";
CECB_menuesub2_txt = "Aussehen der CastBars/ Sonstiges";
CECB_menue_reset = "Standard";
CECB_menue_help = "Hilfe";
CECB_menue_colors = "Farben";
CECB_menue_mbar = "Bewegl. Bar";
--CECB_menue_close = "Schlie\195\159en";
CECB_menue_rwarning = "|cffff0000WARNUNG!|r\n\nAlle Werte und Positionen werden auf \ndie Standardwerte zur\195\188ckgesetzt!\n\nWillst du wirklich einen vollen Reset?";
CECB_menue_ryes = "Ja";
CECB_menue_rno = "NEIN!";
CECB_minimapoff_txt = "aus";


end
