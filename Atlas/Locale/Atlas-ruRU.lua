--[[

-- Atlas Data Alpha (Russian)
-- Compiled by Eugene Filatov
-- dadesign@mail.ru
-- Last Update: 06.07.2008

--]]


if ( GetLocale() == "ruRU" ) then

--AtlasSortIgnore = {"the (.+)"};




ATLAS_TITLE = "Атлас";
ATLAS_SUBTITLE = "Обозреватель карт подземелий";
ATLAS_DESC = "Атлас это обозреватель карт подземелий.";

BINDING_HEADER_ATLAS_TITLE = "Клавиатурные привязки Атласа";
BINDING_NAME_ATLAS_TOGGLE = "Атлас";
BINDING_NAME_ATLAS_OPTIONS = "Настройки Атласа";
BINDING_NAME_ATLAS_AUTOSEL = "Автоматический выбор поздемелья";

ATLAS_SLASH = "/atlas";
ATLAS_SLASH_OPTIONS = "options";

ATLAS_STRING_LOCATION = "Расположение";
ATLAS_STRING_LEVELRANGE = "Диапазон уровней";
ATLAS_STRING_PLAYERLIMIT = "Лимит игроков";
ATLAS_STRING_SELECT_CAT = "Выбор категории";
ATLAS_STRING_SELECT_MAP = "Выбор карты";
ATLAS_STRING_SEARCH = "Поиск";
ATLAS_STRING_CLEAR = "Сбросить";
ATLAS_STRING_MINLEVEL = "Минимальный уровень";

ATLAS_OPTIONS_BUTTON = "Настройки";
ATLAS_OPTIONS_TITLE = "Настройки Атласа";
ATLAS_OPTIONS_SHOWBUT = "Показывать кнопку на мини-карте";
ATLAS_OPTIONS_AUTOSEL = "Автоматический выбор поздемелья";
ATLAS_OPTIONS_BUTPOS = "Расположение кнопки";
ATLAS_OPTIONS_TRANS = "Прозрачность";
ATLAS_OPTIONS_DONE = "Готово";
ATLAS_OPTIONS_REPMAP = "Замена карты мира";
ATLAS_OPTIONS_RCLICK = "Правая кнопка мыши для показа карты мира";
ATLAS_OPTIONS_SHOWMAPNAME = "Отображать имя карты";
ATLAS_OPTIONS_RESETPOS = "Сбросить позиции";
ATLAS_OPTIONS_ACRONYMS = "Отображать короткие названия";
ATLAS_OPTIONS_SCALE = "Размер";
ATLAS_OPTIONS_BUTRAD = "Радиус расположения кнопки";
ATLAS_OPTIONS_CLAMPED = "Не заходить за размеры экрана"
ATLAS_OPTIONS_HELP = "Перемещение этого окна - левая клавиша мыши"
ATLAS_OPTIONS_CTRL = "Удерживайте клавишу Control для сравнений"
ATLAS_OPTIONS_COORDS = "Показывать координаты на карте мира"

ATLAS_BUTTON_TOOLTIP_TITLE = "Атлас";
ATLAS_BUTTON_TOOLTIP_HINT = "Нажмите левую клавишу мыши, чтобы открыть Атлас.\nНажмите среднуюю клавишу мыши, чтобы открыть настройки Атласа.\nНажмите правую клавишу и перемещайте кнопку Атласа.";
ATLAS_TITAN_HINT = "Нажмите левую клавишу мыши, чтобы открыть Атлас.\nНажмите среднуюю клавишу мыши, чтобы открыть настройки Атласа.\nНажмите правую клавишу для вывода меню.";

ATLAS_OPTIONS_CATDD = "Сортировать подземелья по:";
ATLAS_DDL_CONTINENT = "Контитенту";
ATLAS_DDL_CONTINENT_EASTERN = "Подземелья Восточных королевств";
ATLAS_DDL_CONTINENT_KALIMDOR = "Подземелья Калимдора";
ATLAS_DDL_CONTINENT_OUTLAND = "Подземелья Запределья";
ATLAS_DDL_LEVEL = "Уровню";
ATLAS_DDL_LEVEL_UNDER45 = "Подземелья уровня ниже 45";
ATLAS_DDL_LEVEL_45TO60 = "Подземелья уровня 45-60";
ATLAS_DDL_LEVEL_60TO70 = "Подземелья уровня 60-70";
ATLAS_DDL_LEVEL_70PLUS = "Подземелья уровня 70+";
ATLAS_DDL_PARTYSIZE = "Размеру группы";
ATLAS_DDL_PARTYSIZE_5 = "Подземелья на 5 игроков";
ATLAS_DDL_PARTYSIZE_10 = "Подземелья на 10 игроков";
ATLAS_DDL_PARTYSIZE_20TO40 = "Подземелья на 20-40 игроков";
ATLAS_DDL_EXPANSION = "Дополнению";
ATLAS_DDL_EXPANSION_OLD_AO = "Подземелья Старого Мира A-O";
ATLAS_DDL_EXPANSION_OLD_PZ = "Подземелья Старого Мира P-Z";
ATLAS_DDL_EXPANSION_BC = "Подземелья Пылающего Крестового Похода";
ATLAS_DDL_TYPE = "Типу";
ATLAS_DDL_TYPE_INSTANCE_AK = "Подземелья A-K";
ATLAS_DDL_TYPE_INSTANCE_MZ = "Подземелья M-Z";
ATLAS_DDL_TYPE_ENTRANCE = "Входы";

ATLAS_INSTANCE_BUTTON = "Подземелье";
ATLAS_ENTRANCE_BUTTON = "Вход";
ATLAS_SEARCH_UNAVAIL = "Поиск недоступен";

AtlasZoneSubstitutions = {
	["The Temple of Atal'Hakkar"]	= "The Sunken Temple";
	["Ahn'Qiraj"]					= "The Temple of Ahn'Qiraj";
	["Karazhan"]					= "Karazhan [A] (Start)";
	["Black Temple"]				= "Black Temple [A] (Start)";
}; 

AtlasLocale = {

--************************************************
-- Zone Names, Acronyms, and Common Strings
--************************************************

	--Common strings
	["Adult"] = "Adult";
	["AKA"] = "AKA";
	["Alliance"] = "Alliance";
	["Arcane Container"] = "Arcane Container";
	["Argent Dawn"] = "Argent Dawn";
	["Arms Warrior"] = "Arms Warrior";
	["Attunement Required"] = "Attunement Required";
	["Back"] = "Back";
	["Basement"] = "Basement";
	["Bat"] = "Bat";
	["Blacksmithing Plans"] = "Blacksmithing Plans";
	["Boss"] = "Boss";
	["Brazier of Invocation"] = "Brazier of Invocation";
	["Brewfest"] = "Brewfest";
	["Chase Begins"] = "Chase Begins";
	["Chase Ends"] = "Chase Ends";
	["Child"] = "Child";
	["Connection"] = "Connection";
	["DS2"] = "DS2";
	["East"] = "East";
	["Elevator"] = "Elevator";
	["End"] = "End";
	["Entrance"] = "Вход";
	["Event"] = "Event";
	["Exalted"] = "Exalted";
	["Exit"] = "Exit";
	["Fourth Stop"] = "Fourth Stop";
	["Front"] = "Front";
	["Ghost"] = "Ghost";
	["Hallow's End"] = "Hallow's End";
	["Heroic"] = "Heroic";
	["Holy Paladin"] = "Holy Paladin";
	["Holy Priest"] = "Holy Priest";
	["Horde"] = "Horde";
	["Hunter"] = "Hunter";
	["Imp"] = "Imp";
	["Key"] = "Key";
	["Lower"] = "Lower";
	["Lunar"] = "Lunar";
	["Mage"] = "Mage";
	["Meeting Stone"] = "Meeting Stone";
	["Moonwell"] = "Moonwell";
	["North"] = "North";
	["Optional"] = "Optional";
	["Orange"] = "Orange";
	["Outside"] = "Outside";
	["Paladin"] = "Paladin";
	["Panther"] = "Panther";
	["Portal"] = "Portal";
	["Priest"] = "Priest";
	["Protection Warrior"] = "Protection Warrior";
	["Purple"] = "Purple";
	["Random"] = "Random";
	["Raptor"] = "Raptor";
	["Rare"] = "Rare";
	["Rep"] = "Rep";
	["Repair"] = "Repair";
	["Retribution Paladin"] = "Retribution Paladin";
	["Rewards"] = "Rewards";
	["Rogue"] = "Rogue";
	["Second Stop"] = "Second Stop";
	["Shadow Priest"] = "Shadow Priest";
	["Shaman"] = "Shaman";
	["Side"] = "Side";
	["Snake"] = "Snake";
	["Spawn Point"] = "Spawn Point";
	["Spider"] = "Spider";
	["Start"] = "Start";
	["Summon"] = "Summon";
	["Third Stop"] = "Third Stop";
	["Tiger"] = "Tiger";
	["Top"] = "Top";
	["Undead"] = "Undead";
	["Underwater"] = "Underwater";
	["Unknown"] = "Unknown";
	["Upper"] = "Upper";
	["Varies"] = "Varies";
	["Wanders"] = "Wanders";
	["Warlock"] = "Warlock";
	["Warrior"] = "Warrior";
	["West"] = "West";
	
	--Instance names and acronyms
	["Armory"] = "Armory";
	["Auchenai Crypts"] = "Auchenai Crypts"; ["AC"] = "AC";
	["Auchindoun"] = "Auchindoun"; ["Auch"] = "Auch";
	["Black Temple"] = "Black Temple"; ["BT"] = "BT";
	["Blackfathom Deeps"] = "Blackfathom Deeps"; ["BFD"] = "BFD";
	["Blackrock Depths"] = "Blackrock Depths"; ["BRD"] = "BRD";
	["Blackrock Spire"] = "Blackrock Spire"; ["LBRS"] = "LBRS"; ["UBRS"] = "UBRS";
	["Blackwing Lair"] = "Blackwing Lair"; ["BWL"] = "BWL";
	["Cathedral"] = "Cathedral"; ["Cath"] = "Cath";
	["Caverns of Time"] = "Caverns of Time"; ["CoT"] = "CoT";
	["Coilfang Reservoir"] = "Coilfang Reservoir"; ["CR"] = "CR";
	["Dire Maul"] = "Dire Maul"; ["DM"] = "DM";
	["Gnomeregan"] = "Gnomeregan"; ["Gnome"] = "Gnome";
	["Graveyard"] = "Graveyard"; ["GY"] = "GY";
	["Gruul's Lair"] = "Gruul's Lair"; ["GL"] = "GL";
	["Hellfire Citadel"] = "Hellfire Citadel"; ["HFC"] = "HFC";
	["Hellfire Ramparts"] = "Hellfire Ramparts"; ["Ramp"] = "Ramp";
	["Hyjal Summit"] = "Hyjal Summit"; ["CoT3"] = "CoT3";
	["Karazhan"] = "Karazhan"; ["Kara"] = "Kara";
	["Library"] = "Library"; ["Lib"] = "Lib";
	["Magisters' Terrace"] = "Magisters' Terrace"; ["MT"] = "MT";
	["Magtheridon's Lair"] = "Magtheridon's Lair"; ["Mag"] = "Mag";
	["Mana-Tombs"] = "Mana-Tombs"; ["MT"] = "MT";
	["Maraudon"] = "Maraudon"; ["Mara"] = "Mara";
	["Molten Core"] = "Molten Core"; ["MC"] = "MC";
	["Naxxramas"] = "Naxxramas"; ["Nax"] = "Nax";
	["Old Hillsbrad Foothills"] = "Old Hillsbrad Foothills"; ["CoT1"] = "CoT1";
	["Onyxia's Lair"] = "Onyxia's Lair"; ["Ony"] = "Ony";
	["Ragefire Chasm"] = "Ragefire Chasm"; ["RFC"] = "RFC";
	["Razorfen Downs"] = "Razorfen Downs"; ["RFD"] = "RFD";
	["Razorfen Kraul"] = "Razorfen Kraul"; ["RFK"] = "RFK";
	["Ruins of Ahn'Qiraj"] = "Ruins of Ahn'Qiraj"; ["AQ20"] = "AQ20";
	["Scarlet Monastery"] = "Scarlet Monastery"; ["SM"] = "SM";
	["Scholomance"] = "Scholomance"; ["Scholo"] = "Scholo";
	["Serpentshrine Cavern"] = "Serpentshrine Cavern"; ["SC"] = "SC";
	["Sethekk Halls"] = "Sethekk Halls"; ["Seth"] = "Seth";
	["Shadow Labyrinth"] = "Shadow Labyrinth"; ["SL"] = "SL";
	["Shadowfang Keep"] = "Shadowfang Keep"; ["SFK"] = "SFK";
	["Stratholme"] = "Stratholme"; ["Strat"] = "Strat";
	["Sunken Temple"] = "Sunken Temple"; ["ST"] = "ST";
	["Sunwell Plateau"] = "Sunwell Plateau"; ["SP"] = "SP";
	["Tempest Keep"] = "Tempest Keep"; ["TK"] = "TK";
	["Temple of Ahn'Qiraj"] = "Temple of Ahn'Qiraj"; ["AQ40"] = "AQ40";
	["The Arcatraz"] = "The Arcatraz"; ["Arca"] = "Arca";
	["The Black Morass"] = "The Black Morass"; ["CoT2"] = "CoT2";
	["The Blood Furnace"] = "The Blood Furnace"; ["BF"] = "BF";
	["The Botanica"] = "The Botanica"; ["Bota"] = "Bota";
	["The Deadmines"] = "The Deadmines"; ["VC"] = "VC";
	["The Eye"] = "The Eye"; ["Eye"] = "Eye";
	["The Mechanar"] = "The Mechanar"; ["Mech"] = "Mech";
	["The Shattered Halls"] = "The Shattered Halls"; ["SH"] = "SH";
	["The Slave Pens"] = "The Slave Pens"; ["SP"] = "SP";
	["The Steamvault"] = "The Steamvault"; ["SV"] = "SV";
	["The Stockade"] = "The Stockade"; ["Stocks"] = "Stocks";
	["The Underbog"] = "The Underbog"; ["UB"] = "UB";
	["Uldaman"] = "Uldaman"; ["Uld"] = "Uld";
	["Wailing Caverns"] = "Wailing Caverns"; ["WC"] = "WC";
	["Zul'Aman"] = "Zul'Aman"; ["ZA"] = "ZA";
	["Zul'Farrak"] = "Zul'Farrak"; ["ZF"] = "ZF";
	["Zul'Gurub"] = "Zul'Gurub"; ["ZG"] = "ZG";
	
	--Continents
	["Eastern Kingdoms"] = "Eastern Kingdoms";
	["Kalimdor"] = "Kalimdor";
	["Outland"] = "Outland";
	
	--Outdoor zones, Locations
	["Ashenvale"] = "Ashenvale";
	["Badlands"] = "Badlands";
	["Blackrock Mountain"] = "Blackrock Mountain"; ["BRM"] = "BRM";
	["Blade's Edge Mountains"] = "Blade's Edge Mountains";
	["Burning Steppes"] = "Burning Steppes";
	["Deadwind Pass"] = "Deadwind Pass";
	["Desolace"] = "Desolace";
	["Dun Morogh"] = "Dun Morogh";
	["Dustwallow Marsh"] = "Dustwallow Marsh";
	["Eastern Plaguelands"] = "Eastern Plaguelands";
	["Feralas"] = "Feralas";
	["Ghostlands"] = "Ghostlands";
	["Hellfire Peninsula"] = "Hellfire Peninsula";
	["Isle of Quel'Danas"] = "Isle of Quel'Danas";
	["Netherstorm"] = "Netherstorm";
	["Orgrimmar"] = "Orgrimmar";
	["Searing Gorge"] = "Searing Gorge";
	["Shadowmoon Valley"] = "Shadowmoon Valley";
	["Silithus"] = "Silithus";
	["Silverpine Forest"] = "Silverpine Forest";
	["Stormwind City"] = "Stormwind City";
	["Stranglethorn Vale"] = "Stranglethorn Vale";
	["Swamp of Sorrows"] = "Swamp of Sorrows";
	["Tanaris"] = "Tanaris";
	["Terokkar Forest"] = "Terokkar Forest";
	["The Barrens"] = "The Barrens";
	["Tirisfal Glades"] = "Tirisfal Glades";
	["Western Plaguelands"] = "Western Plaguelands";
	["Westfall"] = "Westfall";
	["Zangarmarsh"] = "Zangarmarsh";

--************************************************
-- Kalimdor Instance Data
--************************************************

	--Ragefire Chasm
	["Maur Grimtotem"] = "Maur Grimtotem";
	["Oggleflint <Ragefire Chieftain>"] = "Oggleflint <Ragefire Chieftain>";
	["Taragaman the Hungerer"] = "Taragaman the Hungerer";
	["Jergosh the Invoker"] = "Jergosh the Invoker";
	["Zelemar the Wrathful"] = "Zelemar the Wrathful";
	["Bazzalan"] = "Bazzalan";
	
	--Wailing Caverns
	["Disciple of Naralex"] = "Disciple of Naralex";
	["Lord Cobrahn <Fanglord>"] = "Lord Cobrahn <Fanglord>";
	["Lady Anacondra <Fanglord>"] = "Lady Anacondra <Fanglord>";
	["Kresh"] = "Kresh";
	["Lord Pythas <Fanglord>"] = "Lord Pythas <Fanglord>";
	["Skum"] = "Skum";
	["Lord Serpentis <Fanglord>"] = "Lord Serpentis <Fanglord>";
	["Verdan the Everliving"] = "Verdan the Everliving";
	["Mutanus the Devourer"] = "Mutanus the Devourer";
	["Naralex"] = "Naralex";
	["Deviate Faerie Dragon"] = "Deviate Faerie Dragon";
	
	--Blackfathom Deeps
	["Ghamoo-ra"] = "Ghamoo-ra";
	["Lorgalis Manuscript"] = "Lorgalis Manuscript";
	["Lady Sarevess"] = "Lady Sarevess";
	["Argent Guard Thaelrid <The Argent Dawn>"] = "Argent Guard Thaelrid <The Argent Dawn>";
	["Gelihast"] = "Gelihast";
	["Shrine of Gelihast"] = "Shrine of Gelihast";
	["Lorgus Jett"] = "Lorgus Jett";
	["Fathom Stone"] = "Fathom Stone";
	["Baron Aquanis"] = "Baron Aquanis";
	["Twilight Lord Kelris"] = "Twilight Lord Kelris";
	["Old Serra'kis"] = "Old Serra'kis";
	["Aku'mai"] = "Aku'mai";
	["Morridune"] = "Morridune";
	["Altar of the Deeps"] = "Altar of the Deeps";
	
	--Razorfen Kraul
	["Roogug"] = "Roogug";
	["Aggem Thorncurse <Death's Head Prophet>"] = "Aggem Thorncurse <Death's Head Prophet>";
	["Death Speaker Jargba <Death's Head Captain>"] = "Death Speaker Jargba <Death's Head Captain>";
	["Overlord Ramtusk"] = "Overlord Ramtusk";
	["Razorfen Spearhide"] = "Razorfen Spearhide";
	["Agathelos the Raging"] = "Agathelos the Raging";
	["Blind Hunter"] = "Blind Hunter";
	["Charlga Razorflank <The Crone>"] = "Charlga Razorflank <The Crone>";
	["Willix the Importer"] = "Willix the Importer";
	["Heralath Fallowbrook"] = "Heralath Fallowbrook";
	["Earthcaller Halmgar"] = "Earthcaller Halmgar";

	--Razorfen Downs
	["Tuten'kash"] = "Tuten'kash";
	["Henry Stern"] = "Henry Stern";
	["Belnistrasz"] = "Belnistrasz";
	["Sah'rhee"] = "Sah'rhee";
	["Mordresh Fire Eye"] = "Mordresh Fire Eye";
	["Glutton"] = "Glutton";
	["Ragglesnout"] = "Ragglesnout";
	["Amnennar the Coldbringer"] = "Amnennar the Coldbringer";
	["Plaguemaw the Rotting"] = "Plaguemaw the Rotting";
	
	--Zul'Farrak
	["Mallet of Zul'Farrak"] = "Mallet of Zul'Farrak";
	["Antu'sul <Overseer of Sul>"] = "Antu'sul <Overseer of Sul>";
	["Theka the Martyr"] = "Theka the Martyr";
	["Witch Doctor Zum'rah"] = "Witch Doctor Zum'rah";
	["Zul'Farrak Dead Hero"] = "Zul'Farrak Dead Hero";
	["Nekrum Gutchewer"] = "Nekrum Gutchewer";
	["Shadowpriest Sezz'ziz"] = "Shadowpriest Sezz'ziz";
	["Dustwraith"] = "Dustwraith";
	["Sergeant Bly"] = "Sergeant Bly";
	["Weegli Blastfuse"] = "Weegli Blastfuse";
	["Murta Grimgut"] = "Murta Grimgut";
	["Raven"] = "Raven";
	["Oro Eyegouge"] = "Oro Eyegouge";
	["Sandfury Executioner"] = "Sandfury Executioner";
	["Hydromancer Velratha"] = "Hydromancer Velratha";
	["Gahz'rilla"] = "Gahz'rilla";
	["Elder Wildmane"] = "Elder Wildmane";
	["Chief Ukorz Sandscalp"] = "Chief Ukorz Sandscalp";
	["Ruuzlu"] = "Ruuzlu";
	["Zerillis"] = "Zerillis";
	["Sandarr Dunereaver"] = "Sandarr Dunereaver";
	
	--Maraudon	
	["Scepter of Celebras"] = "Scepter of Celebras";
	["Veng <The Fifth Khan>"] = "Veng <The Fifth Khan>";
	["Noxxion"] = "Noxxion";
	["Razorlash"] = "Razorlash";
	["Maraudos <The Fourth Khan>"] = "Maraudos <The Fourth Khan>";
	["Lord Vyletongue"] = "Lord Vyletongue";
	["Meshlok the Harvester"] = "Meshlok the Harvester";
	["Celebras the Cursed"] = "Celebras the Cursed";
	["Landslide"] = "Landslide";
	["Tinkerer Gizlock"] = "Tinkerer Gizlock";
	["Rotgrip"] = "Rotgrip";
	["Princess Theradras"] = "Princess Theradras";
	["Elder Splitrock"] = "Elder Splitrock";
	
	--Dire Maul (East)
	["Pusillin"] = "Pusillin";
	["Zevrim Thornhoof"] = "Zevrim Thornhoof";
	["Hydrospawn"] = "Hydrospawn";
	["Lethtendris"] = "Lethtendris";
	["Pimgib"] = "Pimgib";
	["Old Ironbark"] = "Old Ironbark";
	["Alzzin the Wildshaper"] = "Alzzin the Wildshaper";
	["Isalien"] = "Isalien";
	
	--Dire Maul (North)
	["Crescent Key"] = "Crescent Key";--omitted from Dire Maul (West)
	--"Library" omitted from here and DM West because of SM: "Library" duplicate
	["Guard Mol'dar"] = "Guard Mol'dar";
	["Stomper Kreeg <The Drunk>"] = "Stomper Kreeg <The Drunk>";
	["Guard Fengus"] = "Guard Fengus";
	["Knot Thimblejack"] = "Knot Thimblejack";
	["Guard Slip'kik"] = "Guard Slip'kik";
	["Captain Kromcrush"] = "Captain Kromcrush";
	["King Gordok"] = "King Gordok";
	["Cho'Rush the Observer"] = "Cho'Rush the Observer";

	--Dire Maul (West)
	["J'eevee's Jar"] = "J'eevee's Jar";
	["Pylons"] = "Pylons";
	["Shen'dralar Ancient"] = "Shen'dralar Ancient";
	["Tendris Warpwood"] = "Tendris Warpwood";
	["Ancient Equine Spirit"] = "Ancient Equine Spirit";
	["Illyanna Ravenoak"] = "Illyanna Ravenoak";
	["Ferra"] = "Ferra";
	["Magister Kalendris"] = "Magister Kalendris";
	["Tsu'zee"] = "Tsu'zee";
	["Immol'thar"] = "Immol'thar";
	["Lord Hel'nurath"] = "Lord Hel'nurath";
	["Prince Tortheldrin"] = "Prince Tortheldrin";
	["Falrin Treeshaper"] = "Falrin Treeshaper";
	["Lorekeeper Lydros"] = "Lorekeeper Lydros";
	["Lorekeeper Javon"] = "Lorekeeper Javon";
	["Lorekeeper Kildrath"] = "Lorekeeper Kildrath";
	["Lorekeeper Mykos"] = "Lorekeeper Mykos";
	["Shen'dralar Provisioner"] = "Shen'dralar Provisioner";
	["Skeletal Remains of Kariel Winthalus"] = "Skeletal Remains of Kariel Winthalus";
	
	--Onyxia's Lair
	["Drakefire Amulet"] = "Drakefire Amulet";
	["Onyxian Warders"] = "Onyxian Warders";
	["Whelp Eggs"] = "Whelp Eggs";
	["Onyxia"] = "Onyxia";

	--Temple of Ahn'Qiraj
	["Brood of Nozdormu"] = "Brood of Nozdormu";
	["The Prophet Skeram"] = "The Prophet Skeram";
	["The Bug Family"] = "The Bug Family";
	["Vem"] = "Vem";
	["Lord Kri"] = "Lord Kri";
	["Princess Yauj"] = "Princess Yauj";
	["Battleguard Sartura"] = "Battleguard Sartura";
	["Fankriss the Unyielding"] = "Fankriss the Unyielding";
	["Viscidus"] = "Viscidus";
	["Princess Huhuran"] = "Princess Huhuran";
	["Twin Emperors"] = "Twin Emperors";
	["Emperor Vek'lor"] = "Emperor Vek'lor";
	["Emperor Vek'nilash"] = "Emperor Vek'nilash";
	["Ouro"] = "Ouro";
	["Eye of C'Thun"] = "Eye of C'Thun";
	["C'Thun"] = "C'Thun";
	["Andorgos <Brood of Malygos>"] = "Andorgos <Brood of Malygos>";
	["Vethsera <Brood of Ysera>"] = "Vethsera <Brood of Ysera>";
	["Kandrostrasz <Brood of Alexstrasza>"] = "Kandrostrasz <Brood of Alexstrasza>";
	["Arygos"] = "Arygos";
	["Caelestrasz"] = "Caelestrasz";
	["Merithra of the Dream"] = "Merithra of the Dream";
	
	--Ruins of Ahn'Qiraj
	["Cenarion Circle"] = "Cenarion Circle";
	["Kurinnaxx"] = "Kurinnaxx";
	["Lieutenant General Andorov"] = "Lieutenant General Andorov";
	["Four Kaldorei Elites"] = "Four Kaldorei Elites";
	["General Rajaxx"] = "General Rajaxx";
	["Captain Qeez"] = "Captain Qeez";
	["Captain Tuubid"] = "Captain Tuubid";
	["Captain Drenn"] = "Captain Drenn";
	["Captain Xurrem"] = "Captain Xurrem";
	["Major Yeggeth"] = "Major Yeggeth";
	["Major Pakkon"] = "Major Pakkon";
	["Colonel Zerran"] = "Colonel Zerran";
	["Moam"] = "Moam";
	["Buru the Gorger"] = "Buru the Gorger";
	["Ayamiss the Hunter"] = "Ayamiss the Hunter";
	["Ossirian the Unscarred"] = "Ossirian the Unscarred";
	["Safe Room"] = "Safe Room";

	--CoT: The Black Morass
	["Opening of the Dark Portal"] = "Opening of the Dark Portal";
	["Keepers of Time"] = "Keepers of Time";--omitted from Old Hillsbrad Foothills
	["Key of Time"] = "Key of Time";--omitted from Old Hillsbrad Foothills
	["Sa'at <Keepers of Time>"] = "Sa'at <Keepers of Time>";
	["Wave 6: Chrono Lord Deja"] = "Wave 6: Chrono Lord Deja";
	["Wave 12: Temporus"] = "Wave 12: Temporus";
	["Wave 18: Aeonus"] = "Wave 18: Aeonus";
	["The Dark Portal"] = "The Dark Portal";
	["Medivh"] = "Medivh";

	--CoT: Hyjal Summit
	["Battle for Mount Hyjal"] = "Battle for Mount Hyjal";
	["The Scale of the Sands"] = "The Scale of the Sands";
	["Alliance Base"] = "Alliance Base";
	["Lady Jaina Proudmoore"] = "Lady Jaina Proudmoore";
	["Horde Encampment"] = "Horde Encampment";
	["Thrall <Warchief>"] = "Thrall <Warchief>";
	["Night Elf Village"] = "Night Elf Village";
	["Tyrande Whisperwind <High Priestess of Elune>"] = "Tyrande Whisperwind <High Priestess of Elune>";
	["Rage Winterchill"] = "Rage Winterchill";
	["Anetheron"] = "Anetheron";
	["Kaz'rogal"] = "Kaz'rogal";
	["Azgalor"] = "Azgalor";
	["Archimonde"] = "Archimonde";
	["Indormi <Keeper of Ancient Gem Lore>"] = "Indormi <Keeper of Ancient Gem Lore>";
	["Tydormu <Keeper of Lost Artifacts>"] = "Tydormu <Keeper of Lost Artifacts>";

	--CoT: Old Hillsbrad Foothills
	["Escape from Durnholde Keep"] = "Escape from Durnholde Keep";
	["Erozion"] = "Erozion";
	["Brazen"] = "Brazen";
	["Landing Spot"] = "Landing Spot";
	["Southshore"] = "Southshore";
	["Tarren Mill"] = "Tarren Mill";
	["Lieutenant Drake"] = "Lieutenant Drake";
	["Thrall"] = "Thrall";
	["Captain Skarloc"] = "Captain Skarloc";
	["Epoch Hunter"] = "Epoch Hunter";
	["Taretha"] = "Taretha";
	["Jonathan Revah"] = "Jonathan Revah";
	["Jerry Carter"] = "Jerry Carter";
	["Traveling"] = "Traveling";
	["Thomas Yance <Travelling Salesman>"] = "Thomas Yance <Travelling Salesman>";
	["Aged Dalaran Wizard"] = "Aged Dalaran Wizard";
	["Kel'Thuzad <The Kirin Tor>"] = "Kel'Thuzad <The Kirin Tor>";
	["Helcular"] = "Helcular";
	["Farmer Kent"] = "Farmer Kent";
	["Sally Whitemane"] = "Sally Whitemane";
	["Renault Mograine"] = "Renault Mograine";
	["Little Jimmy Vishas"] = "Little Jimmy Vishas";
	["Herod the Bully"] = "Herod the Bully";
	["Nat Pagle"] = "Nat Pagle";
	["Hal McAllister"] = "Hal McAllister";
	["Zixil <Aspiring Merchant>"] = "Zixil <Aspiring Merchant>";
	["Overwatch Mark 0 <Protector>"] = "Overwatch Mark 0 <Protector>";
	["Southshore Inn"] = "Southshore Inn";
	["Captain Edward Hanes"] = "Captain Edward Hanes";
	["Captain Sanders"] = "Captain Sanders";
	["Commander Mograine"] = "Commander Mograine";
	["Isillien"] = "Isillien";
	["Abbendis"] = "Abbendis";
	["Fairbanks"] = "Fairbanks";
	["Tirion Fordring"] = "Tirion Fordring";
	["Arcanist Doan"] = "Arcanist Doan";
	["Taelan"] = "Taelan";
	["Barkeep Kelly <Bartender>"] = "Barkeep Kelly <Bartender>";
	["Frances Lin <Barmaid>"] = "Frances Lin <Barmaid>";
	["Chef Jessen <Speciality Meat & Slop>"] = "Chef Jessen <Speciality Meat & Slop>";
	["Stalvan Mistmantle"] = "Stalvan Mistmantle";
	["Phin Odelic <The Kirin Tor>"] = "Phin Odelic <The Kirin Tor>";
	["Southshore Town Hall"] = "Southshore Town Hall";
	["Magistrate Henry Maleb"] = "Magistrate Henry Maleb";
	["Raleigh the True"] = "Raleigh the True";
	["Nathanos Marris"] = "Nathanos Marris";
	["Bilger the Straight-laced"] = "Bilger the Straight-laced";
	["Innkeeper Monica"] = "Innkeeper Monica";
	["Julie Honeywell"] = "Julie Honeywell";
	["Jay Lemieux"] = "Jay Lemieux";
	["Young Blanchy"] = "Young Blanchy";
	
--****************************
-- Eastern Kingdoms Instances
--****************************
	
	--Blackrock Depths
	["Shadowforge Key"] = "Shadowforge Key";
	["Prison Cell Key"] = "Prison Cell Key";
	["Jail Break!"] = "Jail Break!";
	["Banner of Provocation"] = "Banner of Provocation";
	["Lord Roccor"] = "Lord Roccor";
	["Kharan Mighthammer"] = "Kharan Mighthammer";
	["Commander Gor'shak <Kargath Expeditionary Force>"] = "Commander Gor'shak <Kargath Expeditionary Force>";
	["Marshal Windsor"] = "Marshal Windsor";
	["High Interrogator Gerstahn <Twilight's Hammer Interrogator>"] = "High Interrogator Gerstahn <Twilight's Hammer Interrogator>";
	["Ring of Law"] = "Ring of Law";
	["Anub'shiah"] = "Anub'shiah";
	["Eviscerator"] = "Eviscerator";
	["Gorosh the Dervish"] = "Gorosh the Dervish";
	["Grizzle"] = "Grizzle";
	["Hedrum the Creeper"] = "Hedrum the Creeper";
	["Ok'thor the Breaker"] = "Ok'thor the Breaker";
	["Theldren"] = "Theldren";
	["Lefty"] = "Lefty";
	["Malgen Longspear"] = "Malgen Longspear";
	["Gnashjaw <Malgen Longspear's Pet>"] = "Gnashjaw <Malgen Longspear's Pet>";
	["Rotfang"] = "Rotfang";
	["Va'jashni"] = "Va'jashni";
	["Houndmaster Grebmar"] = "Houndmaster Grebmar";
	["Elder Morndeep"] = "Elder Morndeep";
	["High Justice Grimstone"] = "High Justice Grimstone";
	["Monument of Franclorn Forgewright"] = "Monument of Franclorn Forgewright";
	["Pyromancer Loregrain"] = "Pyromancer Loregrain";
	["The Vault"] = "The Vault";
	["Warder Stilgiss"] = "Warder Stilgiss";
	["Verek"] = "Verek";
	["Watchman Doomgrip"] = "Watchman Doomgrip";
	["Fineous Darkvire <Chief Architect>"] = "Fineous Darkvire <Chief Architect>";
	["The Black Anvil"] = "The Black Anvil";
	["Lord Incendius"] = "Lord Incendius";
	["Bael'Gar"] = "Bael'Gar";
	["Shadowforge Lock"] = "Shadowforge Lock";
	["General Angerforge"] = "General Angerforge";
	["Golem Lord Argelmach"] = "Golem Lord Argelmach";
	["Field Repair Bot 74A"] = "Field Repair Bot 74A";
	["The Grim Guzzler"] = "The Grim Guzzler";
	["Hurley Blackbreath"] = "Hurley Blackbreath";
	["Lokhtos Darkbargainer <The Thorium Brotherhood>"] = "Lokhtos Darkbargainer <The Thorium Brotherhood>";
	["Mistress Nagmara"] = "Mistress Nagmara";
	["Phalanx"] = "Phalanx";
	["Plugger Spazzring"] = "Plugger Spazzring";
	["Private Rocknot"] = "Private Rocknot";
	["Ribbly Screwspigot"] = "Ribbly Screwspigot";
	["Coren Direbrew"] = "Coren Direbrew";
	["Ambassador Flamelash"] = "Ambassador Flamelash";
	["Panzor the Invincible"] = "Panzor the Invincible";
	["Summoner's Tomb"] = "Summoner's Tomb";
	["The Lyceum"] = "The Lyceum";
	["Magmus"] = "Magmus";
	["Emperor Dagran Thaurissan"] = "Emperor Dagran Thaurissan";
	["Princess Moira Bronzebeard <Princess of Ironforge>"] = "Princess Moira Bronzebeard <Princess of Ironforge>";
	["High Priestess of Thaurissan"] = "High Priestess of Thaurissan";
	["The Black Forge"] = "The Black Forge";
	["Core Fragment"] = "Core Fragment";
	["Overmaster Pyron"] = "Overmaster Pyron";

	--Blackrock Spire (Lower)
	["Vaelan"] = "Vaelan";
	["Warosh <The Cursed>"] = "Warosh <The Cursed>";
	["Elder Stonefort"] = "Elder Stonefort";
	["Roughshod Pike"] = "Roughshod Pike";
	["Spirestone Butcher"] = "Spirestone Butcher";
	["Highlord Omokk"] = "Highlord Omokk";
	["Spirestone Battle Lord"] = "Spirestone Battle Lord";
	["Spirestone Lord Magus"] = "Spirestone Lord Magus";
	["Shadow Hunter Vosh'gajin"] = "Shadow Hunter Vosh'gajin";
	["Fifth Mosh'aru Tablet"] = "Fifth Mosh'aru Tablet";
	["Bijou"] = "Bijou";
	["War Master Voone"] = "War Master Voone";
	["Mor Grayhoof"] = "Mor Grayhoof";
	["Sixth Mosh'aru Tablet"] = "Sixth Mosh'aru Tablet";
	["Bijou's Belongings"] = "Bijou's Belongings";
	["Human Remains"] = "Human Remains";
	["Unfired Plate Gauntlets"] = "Unfired Plate Gauntlets";
	["Bannok Grimaxe <Firebrand Legion Champion>"] = "Bannok Grimaxe <Firebrand Legion Champion>";
	["Mother Smolderweb"] = "Mother Smolderweb";
	["Crystal Fang"] = "Crystal Fang";
	["Urok's Tribute Pile"] = "Urok's Tribute Pile";
	["Urok Doomhowl"] = "Urok Doomhowl";
	["Quartermaster Zigris <Bloodaxe Legion>"] = "Quartermaster Zigris <Bloodaxe Legion>";
	["Halycon"] = "Halycon";
	["Gizrul the Slavener"] = "Gizrul the Slavener";
	["Ghok Bashguud <Bloodaxe Champion>"] = "Ghok Bashguud <Bloodaxe Champion>";
	["Overlord Wyrmthalak"] = "Overlord Wyrmthalak";
	["Burning Felguard"] = "Burning Felguard";

	--Blackrock Spire (Upper)
	["Seal of Ascension"] = "Seal of Ascension";
	["Pyroguard Emberseer"] = "Pyroguard Emberseer";
	["Solakar Flamewreath"] = "Solakar Flamewreath";
	["Father Flame"] = "Father Flame";
	["Darkstone Tablet"] = "Darkstone Tablet";
	["Doomrigger's Coffer"] = "Doomrigger's Coffer";
	["Jed Runewatcher <Blackhand Legion>"] = "Jed Runewatcher <Blackhand Legion>";
	["Goraluk Anvilcrack <Blackhand Legion Armorsmith>"] = "Goraluk Anvilcrack <Blackhand Legion Armorsmith>";
	["Warchief Rend Blackhand"] = "Warchief Rend Blackhand";
	["Gyth <Rend Blackhand's Mount>"] = "Gyth <Rend Blackhand's Mount>";
	["Awbee"] = "Awbee";
	["The Beast"] = "The Beast";
	["Lord Valthalak"] = "Lord Valthalak";
	["Finkle Einhorn"] = "Finkle Einhorn";
	["General Drakkisath"] = "General Drakkisath";
	["Drakkisath's Brand"] = "Drakkisath's Brand";
	
	--Blackwing Lair
	["Razorgore the Untamed"] = "Razorgore the Untamed";
	["Vaelastrasz the Corrupt"] = "Vaelastrasz the Corrupt";
	["Broodlord Lashlayer"] = "Broodlord Lashlayer";
	["Firemaw"] = "Firemaw";
	["Draconic for Dummies (Chapter VII)"] = "Draconic for Dummies (Chapter VII)";
	["Master Elemental Shaper Krixix"] = "Master Elemental Shaper Krixix";
	["Ebonroc"] = "Ebonroc";
	["Flamegor"] = "Flamegor";
	["Chromaggus"] = "Chromaggus";
	["Nefarian"] = "Nefarian";
	
	--Gnomeregan
	["Workshop Key"] = "Workshop Key";
	["Blastmaster Emi Shortfuse"] = "Blastmaster Emi Shortfuse";
	["Grubbis"] = "Grubbis";
	["Chomper"] = "Chomper";
	["Clean Room"] = "Clean Room";
	["Tink Sprocketwhistle <Engineering Supplies>"] = "Tink Sprocketwhistle <Engineering Supplies>";
	["The Sparklematic 5200"] = "The Sparklematic 5200";
	["Mail Box"] = "Mail Box";
	["Kernobee"] = "Kernobee";
	["Alarm-a-bomb 2600"] = "Alarm-a-bomb 2600";
	["Matrix Punchograph 3005-B"] = "Matrix Punchograph 3005-B";
	["Viscous Fallout"] = "Viscous Fallout";
	["Electrocutioner 6000"] = "Electrocutioner 6000";
	["Matrix Punchograph 3005-C"] = "Matrix Punchograph 3005-C";
	["Crowd Pummeler 9-60"] = "Crowd Pummeler 9-60";
	["Matrix Punchograph 3005-D"] = "Matrix Punchograph 3005-D";
	["Dark Iron Ambassador"] = "Dark Iron Ambassador";
	["Mekgineer Thermaplugg"] = "Mekgineer Thermaplugg";
	
	--Molten Core
	["Hydraxian Waterlords"] = "Hydraxian Waterlords";
	["Aqual Quintessence"] = "Aqual Quintessence";
	["Eternal Quintessence"] = "Eternal Quintessence";
	["Lucifron"] = "Lucifron";
	["Magmadar"] = "Magmadar";
	["Gehennas"] = "Gehennas";
	["Garr"] = "Garr";
	["Shazzrah"] = "Shazzrah";
	["Baron Geddon"] = "Baron Geddon";
	["Golemagg the Incinerator"] = "Golemagg the Incinerator";
	["Sulfuron Harbinger"] = "Sulfuron Harbinger";
	["Majordomo Executus"] = "Majordomo Executus";
	["Ragnaros"] = "Ragnaros";

	--SM: Library
	["Houndmaster Loksey"] = "Houndmaster Loksey";
	["Arcanist Doan"] = "Arcanist Doan";

	--SM: Armory
	["The Scarlet Key"] = "The Scarlet Key";--omitted from SM: Cathedral
	["Herod <The Scarlet Champion>"] = "Herod <The Scarlet Champion>";

	--SM: Cathedral
	["High Inquisitor Fairbanks"] = "High Inquisitor Fairbanks";
	["Scarlet Commander Mograine"] = "Scarlet Commander Mograine";
	["High Inquisitor Whitemane"] = "High Inquisitor Whitemane";

	--SM: Graveyard
	["Interrogator Vishas"] = "Interrogator Vishas";
	["Vorrel Sengutz"] = "Vorrel Sengutz";
	["Pumpkin Shrine"] = "Pumpkin Shrine";
	["Headless Horseman"] = "Headless Horseman";
	["Bloodmage Thalnos"] = "Bloodmage Thalnos";
	["Ironspine"] = "Ironspine";
	["Azshir the Sleepless"] = "Azshir the Sleepless";
	["Fallen Champion"] = "Fallen Champion";
	
	--Scholomance
	["Skeleton Key"] = "Skeleton Key";
	["Viewing Room Key"] = "Viewing Room Key";
	["Viewing Room"] = "Viewing Room";
	["Blood of Innocents"] = "Blood of Innocents";
	["Divination Scryer"] = "Divination Scryer";
	["Blood Steward of Kirtonos"] = "Blood Steward of Kirtonos";
	["The Deed to Southshore"] = "The Deed to Southshore";
	["Kirtonos the Herald"] = "Kirtonos the Herald";
	["Jandice Barov"] = "Jandice Barov";
	["The Deed to Tarren Mill"] = "The Deed to Tarren Mill";
	["Rattlegore"] = "Rattlegore";
	["Death Knight Darkreaver"] = "Death Knight Darkreaver";
	["Marduk Blackpool"] = "Marduk Blackpool";
	["Vectus"] = "Vectus";
	["Ras Frostwhisper"] = "Ras Frostwhisper";
	["The Deed to Brill"] = "The Deed to Brill";
	["Kormok"] = "Kormok";
	["Instructor Malicia"] = "Instructor Malicia";
	["Doctor Theolen Krastinov <The Butcher>"] = "Doctor Theolen Krastinov <The Butcher>";
	["Lorekeeper Polkelt"] = "Lorekeeper Polkelt";
	["The Ravenian"] = "The Ravenian";
	["Lord Alexei Barov"] = "Lord Alexei Barov";
	["The Deed to Caer Darrow"] = "The Deed to Caer Darrow";
	["Lady Illucia Barov"] = "Lady Illucia Barov";
	["Darkmaster Gandling"] = "Darkmaster Gandling";
	["Torch Lever"] = "Torch Lever";
	["Secret Chest"] = "Secret Chest";
	["Alchemy Lab"] = "Alchemy Lab";
	
	--Shadowfang Keep
	["Deathsworn Captain"] = "Deathsworn Captain";
	["Rethilgore <The Cell Keeper>"] = "Rethilgore <The Cell Keeper>";
	["Sorcerer Ashcrombe"] = "Sorcerer Ashcrombe";
	["Deathstalker Adamant"] = "Deathstalker Adamant";
	["Landen Stilwell"] = "Landen Stilwell";
	["Deathstalker Vincent"] = "Deathstalker Vincent";
	["Fel Steed"] = "Fel Steed";
	["Jordan's Hammer"] = "Jordan's Hammer";
	["Crate of Ingots"] = "Crate of Ingots";
	["Razorclaw the Butcher"] = "Razorclaw the Butcher";
	["Baron Silverlaine"] = "Baron Silverlaine";
	["Commander Springvale"] = "Commander Springvale";
	["Odo the Blindwatcher"] = "Odo the Blindwatcher";
	["Fenrus the Devourer"] = "Fenrus the Devourer";
	["Arugal's Voidwalker"] = "Arugal's Voidwalker";
	["The Book of Ur"] = "The Book of Ur";
	["Wolf Master Nandos"] = "Wolf Master Nandos";
	["Archmage Arugal"] = "Archmage Arugal";

	--Stratholme
	["The Scarlet Key"] = "The Scarlet Key";
	["Key to the City"] = "Key to the City";
	["Various Postbox Keys"] = "Various Postbox Keys";
	["Living Side"] = "Living Side";
	["Undead Side"] = "Undead Side";
	["Skul"] = "Skul";
	["Stratholme Courier"] = "Stratholme Courier";
	["Fras Siabi"] = "Fras Siabi";
	["Atiesh <Hand of Sargeras>"] = "Atiesh <Hand of Sargeras>";
	["Hearthsinger Forresten"] = "Hearthsinger Forresten";
	["The Unforgiven"] = "The Unforgiven";
	["Elder Farwhisper"] = "Elder Farwhisper";
	["Timmy the Cruel"] = "Timmy the Cruel";
	["Malor the Zealous"] = "Malor the Zealous";
	["Malor's Strongbox"] = "Malor's Strongbox";
	["Crimson Hammersmith"] = "Crimson Hammersmith";
	["Cannon Master Willey"] = "Cannon Master Willey";
	["Archivist Galford"] = "Archivist Galford";
	["Grand Crusader Dathrohan"] = "Grand Crusader Dathrohan";
	["Balnazzar"] = "Balnazzar";
	["Sothos"] = "Sothos";
	["Jarien"] = "Jarien";
	["Magistrate Barthilas"] = "Magistrate Barthilas";
	["Aurius"] = "Aurius";
	["Stonespine"] = "Stonespine";
	["Baroness Anastari"] = "Baroness Anastari";
	["Black Guard Swordsmith"] = "Black Guard Swordsmith";
	["Nerub'enkan"] = "Nerub'enkan";
	["Maleki the Pallid"] = "Maleki the Pallid";
	["Ramstein the Gorger"] = "Ramstein the Gorger";
	["Baron Rivendare"] = "Baron Rivendare";
	["Ysida Harmon"] = "Ysida Harmon";
	["Crusaders' Square Postbox"] = "Crusaders' Square Postbox";
	["Market Row Postbox"] = "Market Row Postbox";
	["Festival Lane Postbox"] = "Festival Lane Postbox";
	["Elders' Square Postbox"] = "Elders' Square Postbox";
	["King's Square Postbox"] = "King's Square Postbox";
	["Fras Siabi's Postbox"] = "Fras Siabi's Postbox";
	["3rd Box Opened"] = "3rd Box Opened";
	["Postmaster Malown"] = "Postmaster Malown";

	--The Deadmines
	["Rhahk'Zor <The Foreman>"] = "Rhahk'Zor <The Foreman>";
	["Miner Johnson"] = "Miner Johnson";
	["Sneed <Lumbermaster>"] = "Sneed <Lumbermaster>";
	["Sneed's Shredder <Lumbermaster>"] = "Sneed's Shredder <Lumbermaster>";
	["Gilnid <The Smelter>"] = "Gilnid <The Smelter>";
	["Defias Gunpowder"] = "Defias Gunpowder";
	["Captain Greenskin"] = "Captain Greenskin";
	["Edwin VanCleef <Defias Kingpin>"] = "Edwin VanCleef <Defias Kingpin>";
	["Mr. Smite <The Ship's First Mate>"] = "Mr. Smite <The Ship's First Mate>";
	["Cookie <The Ship's Cook>"] = "Cookie <The Ship's Cook>";
	
	--The Stockade
	["Targorr the Dread"] = "Targorr the Dread";
	["Kam Deepfury"] = "Kam Deepfury";
	["Hamhock"] = "Hamhock";
	["Bazil Thredd"] = "Bazil Thredd";
	["Dextren Ward"] = "Dextren Ward";
	["Bruegal Ironknuckle"] = "Bruegal Ironknuckle";

	--The Sunken Temple
	["The Temple of Atal'Hakkar"] = "The Temple of Atal'Hakkar";
	["Yeh'kinya's Scroll"] = "Yeh'kinya's Scroll";
	["Atal'ai Defenders"] = "Atal'ai Defenders";
	["Gasher"] = "Gasher";
	["Loro"] = "Loro";
	["Hukku"] = "Hukku";
	["Zolo"] = "Zolo";
	["Mijan"] = "Mijan";
	["Zul'Lor"] = "Zul'Lor";
	["Altar of Hakkar"] = "Altar of Hakkar";
	["Atal'alarion <Guardian of the Idol>"] = "Atal'alarion <Guardian of the Idol>";
	["Dreamscythe"] = "Dreamscythe";
	["Weaver"] = "Weaver";
	["Avatar of Hakkar"] = "Avatar of Hakkar";
	["Jammal'an the Prophet"] = "Jammal'an the Prophet";
	["Ogom the Wretched"] = "Ogom the Wretched";
	["Morphaz"] = "Morphaz";
	["Hazzas"] = "Hazzas";
	["Shade of Eranikus"] = "Shade of Eranikus";
	["Essence Font"] = "Essence Font";
	["Spawn of Hakkar"] = "Spawn of Hakkar";
	["Elder Starsong"] = "Elder Starsong";
	["Statue Activation Order"] = "Statue Activation Order";
	
	--Uldaman
	["Staff of Prehistoria"] = "Staff of Prehistoria";
	["Baelog"] = "Baelog";
	["Eric \"The Swift\""] = "Eric \"The Swift\"";
	["Olaf"] = "Olaf";
	["Baelog's Chest"] = "Baelog's Chest";
	["Conspicuous Urn"] = "Conspicuous Urn";
	["Remains of a Paladin"] = "Remains of a Paladin";
	["Revelosh"] = "Revelosh";
	["Ironaya"] = "Ironaya";
	["Obsidian Sentinel"] = "Obsidian Sentinel";
	["Annora <Enchanting Trainer>"] = "Annora <Enchanting Trainer>";
	["Ancient Stone Keeper"] = "Ancient Stone Keeper";
	["Galgann Firehammer"] = "Galgann Firehammer";
	["Tablet of Will"] = "Tablet of Will";
	["Shadowforge Cache"] = "Shadowforge Cache";
	["Grimlok <Stonevault Chieftain>"] = "Grimlok <Stonevault Chieftain>";
	["Archaedas <Ancient Stone Watcher>"] = "Archaedas <Ancient Stone Watcher>";
	["The Discs of Norgannon"] = "The Discs of Norgannon";
	["Ancient Treasure"] = "Ancient Treasure";
	
	--Zul'Gurub
	["Zandalar Tribe"] = "Zandalar Tribe";
	["Mudskunk Lure"] = "Mudskunk Lure";
	["Gurubashi Mojo Madness"] = "Gurubashi Mojo Madness";
	["High Priestess Jeklik"] = "High Priestess Jeklik";
	["High Priest Venoxis"] = "High Priest Venoxis";
	["Zanza the Restless"] = "Zanza the Restless";
	["High Priestess Mar'li"] = "High Priestess Mar'li";
	["Bloodlord Mandokir"] = "Bloodlord Mandokir";
	["Ohgan"] = "Ohgan";
	["Edge of Madness"] = "Edge of Madness";
	["Gri'lek"] = "Gri'lek";
	["Hazza'rah"] = "Hazza'rah";
	["Renataki"] = "Renataki";
	["Wushoolay"] = "Wushoolay";
	["Gahz'ranka"] = "Gahz'ranka";
	["High Priest Thekal"] = "High Priest Thekal";
	["Zealot Zath"] = "Zealot Zath";
	["Zealot Lor'Khan"] = "Zealot Lor'Khan";
	["High Priestess Arlokk"] = "High Priestess Arlokk";
	["Jin'do the Hexxer"] = "Jin'do the Hexxer";
	["Hakkar"] = "Hakkar";
	["Muddy Churning Waters"] = "Muddy Churning Waters";
	
	--Naxxramas
	["Archmage Tarsis Kir-Moldir"] = "Archmage Tarsis Kir-Moldir";
	["Mr. Bigglesworth"] = "Mr. Bigglesworth";
	["Abomination Wing"] = "Abomination Wing";
	["Patchwerk"] = "Patchwerk";
	["Grobbulus"] = "Grobbulus";
	["Gluth"] = "Gluth";
	["Thaddius"] = "Thaddius";
	["Spider Wing"] = "Spider Wing";
	["Anub'Rekhan"] = "Anub'Rekhan";
	["Grand Widow Faerlina"] = "Grand Widow Faerlina";
	["Maexxna"] = "Maexxna";
	["Deathknight Wing"] = "Deathknight Wing";
	["Instructor Razuvious"] = "Instructor Razuvious";
	["Gothik the Harvester"] = "Gothik the Harvester";
	["The Four Horsemen"] = "The Four Horsemen";
	["Thane Korth'azz"] = "Thane Korth'azz";
	["Lady Blaumeux"] = "Lady Blaumeux";
	["Highlord Mograine <The Ashbringer>"] = "Highlord Mograine <The Ashbringer>";
	["Sir Zeliek"] = "Sir Zeliek";
	["Four Horsemen Chest"] = "Four Horsemen Chest";
	["Plague Wing"] = "Plague Wing";
	["Noth the Plaguebringer"] = "Noth the Plaguebringer";
	["Heigan the Unclean"] = "Heigan the Unclean";
	["Loatheb"] = "Loatheb";
	["Frostwyrm Lair"] = "Frostwyrm Lair";
	["Sapphiron"] = "Sapphiron";
	["Kel'Thuzad"] = "Kel'Thuzad";
	
	--Karazhan Start
	["The Violet Eye"] = "The Violet Eye";--omitted from Karazhan End
	["The Master's Key"] = "The Master's Key";--omitted from Karazhan End
	["Blackened Urn"] = "Blackened Urn";
	["Staircase to the Ballroom"] = "Staircase to the Ballroom";
	["Stairs to Upper Stable"] = "Stairs to Upper Stable";
	["Ramp to the Guest Chambers"] = "Ramp to the Guest Chambers";
	["Stairs to Opera House Orchestra Level"] = "Stairs to Opera House Orchestra Level";
	["Ramp from Mezzanine to Balcony"] = "Ramp from Mezzanine to Balcony";
	["Connection to Master's Terrace"] = "Connection to Master's Terrace";
	["Path to the Broken Stairs"] = "Path to the Broken Stairs";--omitted from Karazhan End
	["Hastings <The Caretaker>"] = "Hastings <The Caretaker>";
	["Servant Quarters"] = "Servant Quarters";
	["Hyakiss the Lurker"] = "Hyakiss the Lurker";
	["Rokad the Ravager"] = "Rokad the Ravager";
	["Shadikith the Glider"] = "Shadikith the Glider";
	["Berthold <The Doorman>"] = "Berthold <The Doorman>";
	["Calliard <The Nightman>"] = "Calliard <The Nightman>";
	["Attumen the Huntsman"] = "Attumen the Huntsman";
	["Midnight"] = "Midnight";
	["Koren <The Blacksmith>"] = "Koren <The Blacksmith>";
	["Moroes <Tower Steward>"] = "Moroes <Tower Steward>";
	["Baroness Dorothea Millstipe"] = "Baroness Dorothea Millstipe";
	["Lady Catriona Von'Indi"] = "Lady Catriona Von'Indi";
	["Lady Keira Berrybuck"] = "Lady Keira Berrybuck";
	["Baron Rafe Dreuger"] = "Baron Rafe Dreuger";
	["Lord Robin Daris"] = "Lord Robin Daris";
	["Lord Crispin Ference"] = "Lord Crispin Ference";
	["Bennett <The Sergeant at Arms>"] = "Bennett <The Sergeant at Arms>";
	["Ebonlocke <The Noble>"] = "Ebonlocke <The Noble>";
	["Keanna's Log"] = "Keanna's Log";
	["Maiden of Virtue"] = "Maiden of Virtue";
	["Sebastian <The Organist>"] = "Sebastian <The Organist>";
	["Barnes <The Stage Manager>"] = "Barnes <The Stage Manager>";
	["The Opera Event"] = "The Opera Event";
	["Red Riding Hood"] = "Red Riding Hood";
	["The Big Bad Wolf"] = "The Big Bad Wolf";
	["Wizard of Oz"] = "Wizard of Oz";
	["Dorothee"] = "Dorothee";
	["Tito"] = "Tito";
	["Strawman"] = "Strawman";
	["Tinhead"] = "Tinhead";
	["Roar"] = "Roar";
	["The Crone"] = "The Crone";
	["Romulo and Julianne"] = "Romulo and Julianne";
	["Romulo"] = "Romulo";
	["Julianne"] = "Julianne";
	["The Master's Terrace"] = "The Master's Terrace";
	["Nightbane"] = "Nightbane";
	
	--Karazhan End
	["Broken Stairs"] = "Broken Stairs";
	["Ramp to Guardian's Library"] = "Ramp to Guardian's Library";
	["Suspicious Bookshelf"] = "Suspicious Bookshelf";
	["Ramp up to the Celestial Watch"] = "Ramp up to the Celestial Watch";
	["Ramp down to the Gamesman's Hall"] = "Ramp down to the Gamesman's Hall";
	["Chess Event"] = "Chess Event";
	["Ramp to Medivh's Chamber"] = "Ramp to Medivh's Chamber";
	["Spiral Stairs to Netherspace"] = "Spiral Stairs to Netherspace";
	["The Curator"] = "The Curator";
	["Wravien <The Mage>"] = "Wravien <The Mage>";
	["Gradav <The Warlock>"] = "Gradav <The Warlock>";
	["Kamsis <The Conjurer>"] = "Kamsis <The Conjurer>";
	["Terestian Illhoof"] = "Terestian Illhoof";
	["Kil'rek"] = "Kil'rek";
	["Shade of Aran"] = "Shade of Aran";
	["Netherspite"] = "Netherspite";
	["Ythyar"] = "Ythyar";
	["Echo of Medivh"] = "Echo of Medivh";
	["Dust Covered Chest"] = "Dust Covered Chest";
	["Prince Malchezaar"] = "Prince Malchezaar";
	
	--Zul'Aman
	["Harrison Jones"] = "Harrison Jones";
	["Nalorakk <Bear Avatar>"] = "Nalorakk <Bear Avatar>";
	["Tanzar"] = "Tanzar";
	["The Map of Zul'Aman"] = "The Map of Zul'Aman";
	["Akil'Zon <Eagle Avatar>"] = "Akil'Zon <Eagle Avatar>";
	["Harkor"] = "Harkor";
	["Jan'Alai <Dragonhawk Avatar>"] = "Jan'Alai <Dragonhawk Avatar>";
	["Kraz"] = "Kraz";
	["Halazzi <Lynx Avatar>"] = "Halazzi <Lynx Avatar>";
	["Ashli"] = "Ashli";
	["Zungam"] = "Zungam";
	["Hex Lord Malacrass"] = "Hex Lord Malacrass";
	["Thurg"] = "Thurg";
	["Gazakroth"] = "Gazakroth";
	["Lord Raadan"] = "Lord Raadan";
	["Darkheart"] = "Darkheart";
	["Alyson Antille"] = "Alyson Antille";
	["Slither"] = "Slither";
	["Fenstalker"] = "Fenstalker";
	["Koragg"] = "Koragg";
	["Zul'jin"] = "Zul'jin";
	["Forest Frogs"] = "Forest Frogs";
	["Kyren <Reagents>"] = "Kyren <Reagents>";
	["Gunter <Food Vendor>"] = "Gunter <Food Vendor>";
	["Adarrah"] = "Adarrah";
	["Brennan"] = "Brennan";
	["Darwen"] = "Darwen";
	["Deez"] = "Deez";
	["Galathryn"] = "Galathryn";
	["Mitzi"] = "Mitzi";
	["Mannuth"] = "Mannuth";
	
	--Magisters Terrace
	["Shattered Sun Offensive"] = "Shattered Sun Offensive";
	["Selin Fireheart"] = "Selin Fireheart";
	["Fel Crystals"] = "Fel Crystals";
	["Tyrith"] = "Tyrith";
	["Vexallus"] = "Vexallus";
	["Scrying Orb"] = "Scrying Orb";
	["Kalecgos"] = "Kalecgos";--omitted from SP
	["Priestess Delrissa"] = "Priestess Delrissa";
	["Kael'thas Sunstrider <Lord of the Blood Elves>"] = "Kael'thas Sunstrider <Lord of the Blood Elves>";--omitted from TK: The Eye

	--Sunwell Plateau
	["Sathrovarr the Corruptor"] = "Sathrovarr the Corruptor";
	["Madrigosa"] = "Madrigosa";
	["Brutallus"] = "Brutallus";
	["Felmyst"] = "Felmyst";
	["Eredar Twins"] = "Eredar Twins";
	["Grand Warlock Alythess"] = "Grand Warlock Alythess";
	["Lady Sacrolash"] = "Lady Sacrolash";
	["M'uru"] = "M'uru";
	["Entropius"] = "Entropius";
	["Kil'jaeden <The Deceiver>"] = "Kil'jaeden <The Deceiver>";
	
--*******************
-- Outland Instances
--*******************
	
	--HFC: The Blood Furnace
	["Thrallmar"] = "Thrallmar";--omitted from other HFC
	["Honor Hold"] = "Honor Hold";--omitted from other HFC
	["Flamewrought Key"] = "Flamewrought Key";--omitted from other HFC
	["The Maker"] = "The Maker";
	["Broggok"] = "Broggok";
	["Keli'dan the Breaker"] = "Keli'dan the Breaker";

	--HFC: The Shattered Halls
	["Shattered Halls Key"] = "Shattered Halls Key";
	["Randy Whizzlesprocket"] = "Randy Whizzlesprocket";
	["Drisella"] = "Drisella";
	["Grand Warlock Nethekurse"] = "Grand Warlock Nethekurse";
	["Blood Guard Porung"] = "Blood Guard Porung";
	["Warbringer O'mrogg"] = "Warbringer O'mrogg";
	["Warchief Kargath Bladefist"] = "Warchief Kargath Bladefist";
	["Shattered Hand Executioner"] = "Shattered Hand Executioner";
	["Private Jacint"] = "Private Jacint";
	["Rifleman Brownbeard"] = "Rifleman Brownbeard";
	["Captain Alina"] = "Captain Alina";
	["Scout Orgarr"] = "Scout Orgarr";
	["Korag Proudmane"] = "Korag Proudmane";
	["Captain Boneshatter"] = "Captain Boneshatter";

	--HFC: Hellfire Ramparts
	["Watchkeeper Gargolmar"] = "Watchkeeper Gargolmar";
	["Omor the Unscarred"] = "Omor the Unscarred";
	["Vazruden"] = "Vazruden";
	["Nazan <Vazruden's Mount>"] = "Nazan <Vazruden's Mount>";
	["Reinforced Fel Iron Chest"] = "Reinforced Fel Iron Chest";

	--HFC: Magtheridon's Lair
	["Magtheridon"] = "Magtheridon";

	--CR: The Slave Pens
	["Cenarion Expedition"] = "Cenarion Expedition";--omitted from other CR
	["Reservoir Key"] = "Reservoir Key";--omitted from other CR
	["Mennu the Betrayer"] = "Mennu the Betrayer";
	["Weeder Greenthumb"] = "Weeder Greenthumb";
	["Skar'this the Heretic"] = "Skar'this the Heretic";
	["Rokmar the Crackler"] = "Rokmar the Crackler";
	["Naturalist Bite"] = "Naturalist Bite";
	["Quagmirran"] = "Quagmirran";
	["Ahune <The Frost Lord>"] = "Ahune <The Frost Lord>";

	--CR: The Underbog
	["Hungarfen"] = "Hungarfen";
	["The Underspore"] = "The Underspore";
	["Ghaz'an"] = "Ghaz'an";
	["Earthbinder Rayge"] = "Earthbinder Rayge";
	["Swamplord Musel'ek"] = "Swamplord Musel'ek";
	["Claw <Swamplord Musel'ek's Pet>"] = "Claw <Swamplord Musel'ek's Pet>";
	["The Black Stalker"] = "The Black Stalker";

	--CR: The Steamvault
	["Hydromancer Thespia"] = "Hydromancer Thespia";
	["Main Chambers Access Panel"] = "Main Chambers Access Panel";
	["Second Fragment Guardian"] = "Second Fragment Guardian";
	["Mekgineer Steamrigger"] = "Mekgineer Steamrigger";
	["Warlord Kalithresh"] = "Warlord Kalithresh";

	--CR: Serpentshrine Cavern
	["Hydross the Unstable <Duke of Currents>"] = "Hydross the Unstable <Duke of Currents>";
	["The Lurker Below"] = "The Lurker Below";
	["Leotheras the Blind"] = "Leotheras the Blind";
	["Fathom-Lord Karathress"] = "Fathom-Lord Karathress";
	["Seer Olum"] = "Seer Olum";
	["Morogrim Tidewalker"] = "Morogrim Tidewalker";
	["Lady Vashj <Coilfang Matron>"] = "Lady Vashj <Coilfang Matron>";

	--Auch: Mana-Tombs
	["The Consortium"] = "The Consortium";
	["Auchenai Key"] = "Auchenai Key";--omitted from other Auch
	["The Eye of Haramad"] = "The Eye of Haramad";
	["Pandemonius"] = "Pandemonius";
	["Shadow Lord Xiraxis"] = "Shadow Lord Xiraxis";
	["Ambassador Pax'ivi"] = "Ambassador Pax'ivi";
	["Tavarok"] = "Tavarok";
	["Cryo-Engineer Sha'heen"] = "Cryo-Engineer Sha'heen";
	["Ethereal Transporter Control Panel"] = "Ethereal Transporter Control Panel";
	["Nexus-Prince Shaffar"] = "Nexus-Prince Shaffar";
	["Yor <Void Hound of Shaffar>"] = "Yor <Void Hound of Shaffar>";

	--Auch: Auchenai Crypts
	["Lower City"] = "Lower City";--omitted from other Auch
	["Shirrak the Dead Watcher"] = "Shirrak the Dead Watcher";
	["Exarch Maladaar"] = "Exarch Maladaar";
	["Avatar of the Martyred"] = "Avatar of the Martyred";
	["D'ore"] = "D'ore";

	--Auch: Sethekk Halls
	["Essence-Infused Moonstone"] = "Essence-Infused Moonstone";
	["Darkweaver Syth"] = "Darkweaver Syth";
	["Lakka"] = "Lakka";
	["The Saga of Terokk"] = "The Saga of Terokk";
	["Anzu"] = "Anzu";
	["Talon King Ikiss"] = "Talon King Ikiss";

	--Auch: Shadow Labyrinth
	["Shadow Labyrinth Key"] = "Shadow Labyrinth Key";
	["Spy To'gun"] = "Spy To'gun";
	["Ambassador Hellmaw"] = "Ambassador Hellmaw";
	["Blackheart the Inciter"] = "Blackheart the Inciter";
	["Grandmaster Vorpil"] = "Grandmaster Vorpil";
	["The Codex of Blood"] = "The Codex of Blood";
	["Murmur"] = "Murmur";
	["First Fragment Guardian"] = "First Fragment Guardian";

	--TK: The Botanica
	["The Sha'tar"] = "The Sha'tar";--omitted from other TK
	["Warpforged Key"] = "Warpforged Key";--omitted from other TK
	["Commander Sarannis"] = "Commander Sarannis";
	["High Botanist Freywinn"] = "High Botanist Freywinn";
	["Thorngrin the Tender"] = "Thorngrin the Tender";
	["Laj"] = "Laj";
	["Warp Splinter"] = "Warp Splinter";

	--TK: The Arcatraz
	["Key to the Arcatraz"] = "Key to the Arcatraz";
	["Zereketh the Unbound"] = "Zereketh the Unbound";
	["Third Fragment Guardian"] = "Third Fragment Guardian";
	["Dalliah the Doomsayer"] = "Dalliah the Doomsayer";
	["Wrath-Scryer Soccothrates"] = "Wrath-Scryer Soccothrates";
	["Udalo"] = "Udalo";
	["Harbinger Skyriss"] = "Harbinger Skyriss";
	["Warden Mellichar"] = "Warden Mellichar";
	["Millhouse Manastorm"] = "Millhouse Manastorm";

	--TK: The Mechanar
	["Gatewatcher Gyro-Kill"] = "Gatewatcher Gyro-Kill";
	["Gatewatcher Iron-Hand"] = "Gatewatcher Iron-Hand";
	["Cache of the Legion"] = "Cache of the Legion";
	["Mechano-Lord Capacitus"] = "Mechano-Lord Capacitus";
	["Overcharged Manacell"] = "Overcharged Manacell";
	["Nethermancer Sepethrea"] = "Nethermancer Sepethrea";
	["Pathaleon the Calculator"] = "Pathaleon the Calculator";

	--TK: The Eye
	["The Tempest Key"] = "The Tempest Key";
	["Al'ar <Phoenix God>"] = "Al'ar <Phoenix God>";
	["Void Reaver"] = "Void Reaver";
	["High Astromancer Solarian"] = "High Astromancer Solarian";
	["Thaladred the Darkener <Advisor to Kael'thas>"] = "Thaladred the Darkener <Advisor to Kael'thas>";
	["Master Engineer Telonicus <Advisor to Kael'thas>"] = "Master Engineer Telonicus <Advisor to Kael'thas>";
	["Grand Astromancer Capernian <Advisor to Kael'thas>"] = "Grand Astromancer Capernian <Advisor to Kael'thas>";
	["Lord Sanguinar <The Blood Hammer>"] = "Lord Sanguinar <The Blood Hammer>";

	--Gruul's Lair
	["High King Maulgar <Lord of the Ogres>"] = "High King Maulgar <Lord of the Ogres>";
	["Kiggler the Crazed"] = "Kiggler the Crazed";
	["Blindeye the Seer"] = "Blindeye the Seer";
	["Olm the Summoner"] = "Olm the Summoner";
	["Krosh Firehand"] = "Krosh Firehand";
	["Gruul the Dragonkiller"] = "Gruul the Dragonkiller";

	--Black Temple (Start)
	["Ashtongue Deathsworn"] = "Ashtongue Deathsworn";--omitted from other BT
	["Medallion of Karabor"] = "Medallion of Karabor";--omitted from other BT
	["Towards Reliquary of Souls"] = "Towards Reliquary of Souls";
	["Towards Teron Gorefiend"] = "Towards Teron Gorefiend";
	["Towards Illidan Stormrage"] = "Towards Illidan Stormrage";
	["Spirit of Olum"] = "Spirit of Olum";
	["High Warlord Naj'entus"] = "High Warlord Naj'entus";
	["Supremus"] = "Supremus";
	["Shade of Akama"] = "Shade of Akama";
	["Spirit of Udalo"] = "Spirit of Udalo";
	["Aluyen <Reagents>"] = "Aluyen <Reagents>";
	["Okuno <Ashtongue Deathsworn Quartermaster>"] = "Okuno <Ashtongue Deathsworn Quartermaster>";
	["Seer Kanai"] = "Seer Kanai";

	--Black Temple (Basement)
	["Gurtogg Bloodboil"] = "Gurtogg Bloodboil";
	["Reliquary of Souls"] = "Reliquary of Souls";
	["Essence of Suffering"] = "Essence of Suffering";
	["Essence of Desire"] = "Essence of Desire";
	["Essence of Anger"] = "Essence of Anger";
	["Teron Gorefiend"] = "Teron Gorefiend";

	--Black Temple (Top)
	["Mother Shahraz"] = "Mother Shahraz";
	["The Illidari Council"] = "The Illidari Council";
	["Lady Malande"] = "Lady Malande";
	["Gathios the Shatterer"] = "Gathios the Shatterer";
	["High Nethermancer Zerevor"] = "High Nethermancer Zerevor";
	["Veras Darkshadow"] = "Veras Darkshadow";
	["Illidan Stormrage <The Betrayer>"] = "Illidan Stormrage <The Betrayer>";

--************************************************
-- Instance Entrance Maps
--************************************************

	--Auchindoun (Entrance)
	["Ha'Lei"] = "Ha'Lei";
	["Greatfather Aldrimus"] = "Greatfather Aldrimus";
	["Clarissa"] = "Clarissa";
	["Ramdor the Mad"] = "Ramdor the Mad";
	["Horvon the Armorer <Armorsmith>"] = "Horvon the Armorer <Armorsmith>";
	["Nexus-Prince Haramad"] = "Nexus-Prince Haramad";
	["Artificer Morphalius"] = "Artificer Morphalius";
	["Mamdy the \"Ologist\""] = "Mamdy the \"Ologist\"";
	["\"Slim\" <Shady Dealer>"] = "\"Slim\" <Shady Dealer>";
	["\"Captain\" Kaftiz"] = "\"Captain\" Kaftiz";
	["Isfar"] = "Isfar";
	["Field Commander Mahfuun"] = "Field Commander Mahfuun";
	["Spy Grik'tha"] = "Spy Grik'tha";
	["Provisioner Tsaalt"] = "Provisioner Tsaalt";
	["Dealer Tariq <Shady Dealer>"] = "Dealer Tariq <Shady Dealer>";

	--Blackfathom Deeps (Entrance)
	--Nothing to translate!

	--Blackrock Mountain (Entrance)
	["Bodley"] = "Bodley";
	["Overmaster Pyron"] = "Overmaster Pyron";
	["Lothos Riftwaker"] = "Lothos Riftwaker";
	["Franclorn Forgewright"] = "Franclorn Forgewright";
	["Orb of Command"] = "Orb of Command";
	["Scarshield Quartermaster <Scarshield Legion>"] = "Scarshield Quartermaster <Scarshield Legion>";

	--Coilfang Reservoir (Entrance)
	["Watcher Jhang"] = "Watcher Jhang";
	["Mortog Steamhead"] = "Mortog Steamhead";

	--Gnomeregan (Entrance)
	["Transpolyporter"] = "Transpolyporter";
	["Sprok <Away Team>"] = "Sprok <Away Team>";
	["Matrix Punchograph 3005-A"] = "Matrix Punchograph 3005-A";
	["Namdo Bizzfizzle <Engineering Supplies>"] = "Namdo Bizzfizzle <Engineering Supplies>";
	["Techbot"] = "Techbot";

	--Maraudon (Entrance)
	["The Nameless Prophet"] = "The Nameless Prophet";
	["Kolk <The First Kahn>"] = "Kolk <The First Kahn>";
	["Gelk <The Second Kahn>"] = "Gelk <The Second Kahn>";
	["Magra <The Third Kahn>"] = "Magra <The Third Kahn>";
	["Cavindra"] = "Cavindra";

	--The Deadmines (Entrance)
	["Marisa du'Paige"] = "Marisa du'Paige";
	["Brainwashed Noble"] = "Brainwashed Noble";
	["Foreman Thistlenettle"] = "Foreman Thistlenettle";

	--Sunken Temple (Entrance)
	["Jade"] = "Jade";
	["Kazkaz the Unholy"] = "Kazkaz the Unholy";
	["Zekkis"] = "Zekkis";
	["Veyzhak the Cannibal"] = "Veyzhak the Cannibal";

	--Uldaman (Entrance)
	["Hammertoe Grez"] = "Hammertoe Grez";
	["Magregan Deepshadow"] = "Magregan Deepshadow";
	["Tablet of Ryun'Eh"] = "Tablet of Ryun'Eh";
	["Krom Stoutarm's Chest"] = "Krom Stoutarm's Chest";
	["Garrett Family Chest"] = "Garrett Family Chest";
	["Digmaster Shovelphlange"] = "Digmaster Shovelphlange";

	--Wailing Caverns (Entrance)
	["Mad Magglish"] = "Mad Magglish";
	["Trigore the Lasher"] = "Trigore the Lasher";
	["Boahn <Druid of the Fang>"] = "Boahn <Druid of the Fang>";
	["Above the Entrance:"] = "Above the Entrance:";
	["Ebru <Disciple of Naralex>"] = "Ebru <Disciple of Naralex>";
	["Nalpak <Disciple of Naralex>"] = "Nalpak <Disciple of Naralex>";
	["Kalldan Felmoon <Specialist Leatherworking Supplies>"] = "Kalldan Felmoon <Specialist Leatherworking Supplies>";
	["Waldor <Leatherworking Trainer>"] = "Waldor <Leatherworking Trainer>";

	--Dire Maul (Entrance)
	["Dire Pool"] = "Dire Pool";
	["Dire Maul Arena"] = "Dire Maul Arena";
	["Mushgog"] = "Mushgog";
	["Skarr the Unbreakable"] = "Skarr the Unbreakable";
	["The Razza"] = "The Razza";
	["Elder Mistwalker"] = "Elder Mistwalker";

	--Caverns of Time (Entrance)
	["Steward of Time <Keepers of Time>"] = "Steward of Time <Keepers of Time>";
	["Alexston Chrome <Tavern of Time>"] = "Alexston Chrome <Tavern of Time>";
	["Yarley <Armorer>"] = "Yarley <Armorer>";
	["Bortega <Reagents & Poison Supplies>"] = "Bortega <Reagents & Poison Supplies>";
	["Galgrom <Provisioner>"] = "Galgrom <Provisioner>";
	["Alurmi <Keepers of Time Quartermaster>"] = "Alurmi <Keepers of Time Quartermaster>";
	["Zaladormu"] = "Zaladormu";
	["Soridormi <The Scale of Sands>"] = "Soridormi <The Scale of Sands>";
	["Arazmodu <The Scale of Sands>"] = "Arazmodu <The Scale of Sands>";
	["Andormu <Keepers of Time>"] = "Andormu <Keepers of Time>";
	["Nozari <Keepers of Time>"] = "Nozari <Keepers of Time>";

	--Karazhan (Entrance)
	["Archmage Leryda"] = "Archmage Leryda";
	["Apprentice Darius"] = "Apprentice Darius";
	["Archmage Alturus"] = "Archmage Alturus";
	["Stairs to Underground Pond"] = "Stairs to Underground Pond";
	["Stairs to Underground Well"] = "Stairs to Underground Well";
	["Charred Bone Fragment"] = "Charred Bone Fragment";

	--Scarlet Monastery (Entrance)
	--Nothing to translate!

};


end
