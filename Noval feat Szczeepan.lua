------------------------------------------------------------------------------
--	PURPOSE: Multitype mirrored pangaea for multiplayer games.
--	AUTHOR: Szczeepan base on other maps and scripts.
--	CivkoveLove
--	Noval feat Szczeepan
------------------------------------------------------------------------------
--	Copyright (c) 2011 Firaxis Games, Inc. All rights reserved.
------------------------------------------------------------------------------
---
include("HBMapGenerator3.6");
include("HBFractalWorld3.6");
include("HBFeatureGenerator3.6");
include("HBTerrainGenerator3.6");
include("IslandMaker");
include("MultilayeredFractal");

---------------------------------------------------------------------------------
function GetMapScriptInfo()
    local world_age, temperature, rainfall, sea_level, resources = GetCoreMapOptions()
    local opt = {
        {
            Name = "TXT_KEY_MAP_OPTION_WORLD_AGE", --(1)
            Values = {
                "TXT_KEY_MAP_OPTION_THREE_BILLION_YEARS",
                "TXT_KEY_MAP_OPTION_FOUR_BILLION_YEARS",
                "TXT_KEY_MAP_OPTION_FIVE_BILLION_YEARS",
                "No Mountains",
                "TXT_KEY_MAP_OPTION_RANDOM",
            },
            DefaultValue = 2,
            SortPriority = -99,
        },

        {
            Name = "TXT_KEY_MAP_OPTION_TEMPERATURE",	--(2) add temperature defaults to random
            Values = {
                "TXT_KEY_MAP_OPTION_COOL",
                "TXT_KEY_MAP_OPTION_TEMPERATE",
                "TXT_KEY_MAP_OPTION_HOT",
                "TXT_KEY_MAP_OPTION_RANDOM",
            },
            DefaultValue = 2,
            SortPriority = -98,
        },

        {
            Name = "TXT_KEY_MAP_OPTION_RAINFALL",	--(3) add rainfall defaults to random
            Values = {
                "TXT_KEY_MAP_OPTION_ARID",
                "TXT_KEY_MAP_OPTION_NORMAL",
                "TXT_KEY_MAP_OPTION_WET",
                "TXT_KEY_MAP_OPTION_RANDOM",
            },
            DefaultValue = 2,
            SortPriority = -97,
        },

        {
            Name = "TXT_KEY_MAP_OPTION_SEA_LEVEL",	--(4) add sea level defaults to random.
            Values = {
                "TXT_KEY_MAP_OPTION_LOW",
                "TXT_KEY_MAP_OPTION_MEDIUM",
                "TXT_KEY_MAP_OPTION_HIGH",
                "TXT_KEY_MAP_OPTION_RANDOM",
            },
            DefaultValue = 2,
            SortPriority = -96,
        },

        {
            Name = "Start Quality",	--(5) add resources defaults to random
            Values = {
                "Legendary Start - Strat Balance",
                "Legendary - Strat Balance + Uranium",
                "TXT_KEY_MAP_OPTION_STRATEGIC_BALANCE",
                "Strategic Balance With Coal",
                "Strategic Balance With Aluminum",
                "Strategic Balance With Coal & Aluminum",
                "Strategic Balance With Coal & Aluminum & Uran",
                "TXT_KEY_MAP_OPTION_RANDOM",
            },
            DefaultValue = 7,
            SortPriority = -95,
        },

        {
            Name = "Start Distance",	--(6) add resources defaults to random
            Values = {
                "Close",
                "Normal",
                "Far - Warning: May sometimes crash during map generation",
            },
            DefaultValue = 2,
            SortPriority = -94,
        },

        {
            Name = "Natural Wonders", --(7) number of natural wonders to spawn
            Values = {
                "0",
                "1",
                "2",
                "3",
                "4",
                "5",
                "6",
                "7",
                "8",
                "9",
                "10",
                "11",
                "12",
                "Random",
                "Default",
            },
            DefaultValue = 15,
            SortPriority = -93,
        },

        {
            Name = "Grass Moisture",	--(8) add setting for grassland mositure
            Values = {
                "Wet",
                "Normal",
                "Dry",
            },

            DefaultValue = 2,
            SortPriority = -92,
        },

        {
            Name = "Rivers",	--(9) add setting for rivers
            Values = {
                "sparse",
                "average",
                "plentiful",
            },

            DefaultValue = 2,
            SortPriority = -91,
        },

        {
            Name = "Tundra Size",	--(10) add setting for tundra
            Values = {
                "sparse",
                "average",
                "plentiful",
            },

            DefaultValue = 2,
            SortPriority = -90,
        },
        {
            Name = "Desert Size", --(11) desertSize
            Values = {
                "sparse",
                "average",
                "plentiful",
            },
            DefaultValue = 2,
            SortPriority = -89,
        },

        {
            Name = "Forest Size", --(12) forestSize
            Values = {
                "sparse",
                "average",
                "plentiful",
            },
            DefaultValue = 2,
            SortPriority = -88,
        },

        {
            Name = "TXT_KEY_MAP_OPTION_RESOURCES",	--(13) add setting for resources
            Values = {
                "1 -- Nearly Nothing",
                "2",
                "3",
                "4",
                "5 -- Default",
                "6",
                "7",
                "8",
                "9",
                "10 -- Almost no normal tiles left",
            },

            DefaultValue = 5,
            SortPriority = -87,
        },

        {
            Name = "Coastal Spawns",	--(14) Can inland civ spawn on the coast
            Values = {
                "Coastal Civs Only",
                "Random",
                "Random+ (~2 coastals)",
            },

            DefaultValue = 1,
            SortPriority = -86,
        },

        {
            Name = "Coastal Luxes",	--(15) Can coast spawns have non-coastal luxes
            Values = {
                "Guaranteed",
                "Random",
            },

            DefaultValue = 1,
            SortPriority = -85,
        },

        {
            Name = "Inland Sea Spawns",	--(16) Can coastal civ spawn on inland seas
            Values = {
                "Allowed",
                "Not Allowed for Coastal Civs",
            },

            DefaultValue = 1,
            SortPriority = -83,
        },

        {
            Name = "Forest Size", --(17) forestSize
            Values = {
                "sparse",
                "average",
                "plentiful",
            },
            DefaultValue = 2,
            SortPriority = -80,
        },
        {
            Name = "Jungle Size", --(18) jungleSize
            Values = {
                "sparse",
                "average",
                "plentiful",
            },
            DefaultValue = 2,
            SortPriority = -79,
        },
        {
            Name = "Marsh Size", --(19) marshSize
            Values = {
                "sparse",
                "average",
                "plentiful",
            },
            DefaultValue = 2,
            SortPriority = -78,
        },
        {
            Name = "Map Dimensions", --(20) mapSize
            Values = {
                "Cage",
                "Standard",
                "Big",
                "Random",
            },
            DefaultValue = 2,
            SortPriority = -77,
        },
        {--5
            Name = "CS Army", --(21) CS_Army
            Values = {
                {"Brak","Panstwa Miasta startuja bez jednostek."},
                {"+LUCZNIK","Miasta Panstwa startuja z: LUCZNIKIEM."},
                {"+LUCZNIK, HOPLITA","Miasta Panstwa startuja z: LUCZNIKIEM i HOPLITA."},
                {"+LUCZNIK, HOPLITA, SLON","Miasta Panstwa startuja z: LUCZNIKIEM, HOPLITA i SLONIEM BOJOWYM."},
                {"+LUCZNIK, 2xHOPLITA, SLON","Miasta Panstwa startuja z: LUCZNIKIEM i 2 razy HOPLITA i SLONIEM BOJOWYM."},
                {"+LUCZNIK, 2xHOPLITA, 2xSLON","Miasta Panstwa startuja z: LUCZNIKIEM, 2 razy HOPLITA i 2 razy SLONIE BOJOWE."},
            },
            DefaultValue = 3,
            SortPriority = -76,
        },
        {--6
            Name = "human army", --(22) humanArmy
            Values = {
                "Brak",
                {"+ZWIADOWCA","Gracz staruje z wojownikiem plus: ZWIADOWCA."},
                {"+ZWIAD. i WOJOWNIK","Gracz staruje z wojownikiem plus: ZWIADOWCA i WOJOWNIK."},
                {"+ZWIAD.,WOJO. i ROBOTNIK","Gracz staruje z wojownikiem plus: ZWIADOWCA, WOJOWNIK i ROBOTNIK."},
                {"+ZWIAD.,WOJO.,ROBO. i OSADNIK","Gracz staruje z wojownikiem plus: ZWIADOWCA, WOJOWNIK, ROBOTNIK i OSADNIK."},
            },
            DefaultValue = 2,
            SortPriority = -75,
        },
        {--7
            Name = "Barbarian Camp",--(23) barbCamp
            Values = {
                {"Bez mirroringu obozow barb.","Obozy barbarzyncow nie beda odbijane (mirroring)."},
                {"Mirroring i brak nowych barbs.","Obozy barbarzyncow nie tworza nowych jednostek."},
                {"Mirroring i nowe barbs.","Normalne zachowanie sie barbarzyncow."},
            },
            DefaultValue = 2,
            SortPriority = -74,
        },
        {--8
            Name = "WAR", --(24) WAR
            Values = {
                {"TAK","Gra startuje z rozpoczeta ciagla wojna pomiedzy graczami. [NEWLINE]Dla gier bez Panstw Miast zostanie aktywowana opcja ZAWSZE_WOJNA, dla gier z Panstwami Miastami zostanie aktywowana opcja BEZ_ZMIANY_WOJNA->POKOJ."},
                {"NIE","Gra startuje bez rozpoczetej wojny."},
            },
            DefaultValue = 1,
            SortPriority = -73,
        },
        {--9
            Name = "Iron and Horse", --(25) horseIron
            Values = {
                "2 jednostek na zrodlo",
                "3 jednostek na zrodlo",
                "4 jednostek na zrodlo",
                "5 jednostek na zrodlo",
                "6 jednostek na zrodlo",
                "Bez ograniczen",
                "Losowo",
            },
            DefaultValue = 1,
            SortPriority = -72,
        },
        {--10
            Name = "El Dorado", --(26) EL_DORADO
            Values = {
                {"TAK","El Dorado moze byc odkryte"},
                {"BRAK","Brak El Dorado na mapie"},
            },
            DefaultValue = 2,
            SortPriority = -71,
        },
        {
            Name = "Kilimandzaro", --(27) KILIMANDZARO
            Values = {
                {"TAK","El Dorado moze byc odkryte"},
                {"BRAK","Brak El Dorado na mapie"},
            },
            DefaultValue = 2,
            SortPriority = -70,
        },
        { --11
            Name = "Starting Position", --(28) startPosition
            Values = {
                {"Rozrzucone","Mirroring wszystkich elementow gry plus losowe symetryczne pozycje startowe. [NEWLINE]Ta opcja jest akrywna dla gier 1v1 oraz zespolowych z dwoma druzynami, np. 2v2 lub 3v2."},
                {"Pionowa linia frontu","Mirroring wszystkich elementow gry plus zespoly startuja ustawione w symetryczne pionowe linie. [NEWLINE]Ta opcja jest aktywna tylko dla gier zespolowych z dwoma druzynami, np. 2v2 lub 3v2."},
            },
            DefaultValue = 1,
            SortPriority = -69,
        },
        { --12
            Name = "Zasobnosc Kraju", --(29) startPosition
            Values = {
                {"Zebracy","Maksymalnie 2 typy zasobow luksusu i Mala ilosc surowcow stretegicznych."},--1
                {"Bieda","Maksymalnie 3 typy zasobow luksusu i Mala ilosc surowcow stretegicznych."},--2
                {"Szare zycie","Maksynalnie 4 typy zasobow luksusu i Mala ilosc surowcow stretegicznych."},--3
                {"Dostatek","Maksymalnie 5 typow zasobow luksusu i Srednia ilosc surowcow stretegicznych."},--4
                {"Bogactwo","Maksymalnie 7 typow zasobow luksusu i Strategiczny Balans surowcow."},--5
                {"Rozpusta","Maksymalnie 9 typow zasobow luksusu i Strategiczny Balans surowcow."},--6
                {"Raj","Maksymalnie 12 typow zasobow luksusu i Strategiczny Balans surowcow."},--7
                {"Bez ograniczen ","Brak ograniczen dla ilosci luksusu i Strategiczny Balans surowcow.."},--8
                "Losowo",
            },
            DefaultValue = 7,
            SortPriority = -68,
        },
        { --13
            Name = "Promocje", --(30) startPosition
            Values = {
                {"Brak","Jednostki Panstw Miast i Barbarzyncow startuja bez promocji."},
                {"Dla Panstw Miast","Na poczatku gry jednostki Panstw Miast startuja z dodatkowymi promocjami."},
                {"Dla Barbarzyncow","Na poczatku gry jednostki Barbarzyncow startuja z dodatkowymi promocjami."},
                {"Dla Barb. i Panstw Miast","Na poczatku gry jednostki Barbarzyncow i Panstw Miast startuja z dodatkowymi promocjami."},
            },
            DefaultValue = 1,
            SortPriority = -67,
        },
        { --14
            Name = "Barbarzyncy",--(31) startPosition
            Values = {
                {"Tylko w obozie","Tylko w obozach barbarzyncow."},
                {"+1 BRUTE","Wszystkie obozy barbarzyncow startuja z obronca obozu i jednym BRUTE. [NEWLINE]Funkcja aktywna tylko z opcja: 'Mirroring obozow barbarzyncow'."},
                {"+2 BRUTE","Wszystkie obozy barbarzyncow startuja z obronca obozu i dwoma BRUTE. [NEWLINE]Funkcja aktywna tylko z opcja: 'Mirroring obozow barbarzyncow'."},
            },
            DefaultValue = 1,
            SortPriority = -66,
        },
        { --15
            Name = "Front Line", --(32) startPosition
            Values = {
                {"Blisko","Odlegosc pomiedzy zespolami = 8 lub wiecej. [NEWLINE]Funkcja aktywna tylko z opcja: 'Pionowa linia frontu'."},
                {"Srednio","Odlegosc pomiedzy zespolami = 12 lub wiecej. [NEWLINE]Funkcja aktywna tylko z opcja: 'Pionowa linia frontu'."},
                {"Daleko","Odlegosc pomiedzy zespolami = 16 lub wiecej. [NEWLINE]Funkcja aktywna tylko z opcja: 'Pionowa linia frontu'."},
            },
            DefaultValue = 2,
            SortPriority = -65,
        },
        { --16
            Name = "road", --(33) road
            Values = {
                {"TAK","Droga pomiedzy pozycjami startowymi graczy. Poprowadzona najkrotszym szlakiem."},
                {"Brak","Brak drogi pomiedzy pozycjami startowymi graczy."},
            },
            DefaultValue = 1,
            SortPriority = -64,
        },
    }
    opt["Tech Speed"] = {
        Name = Locale.ConvertTextKey("TXT_KEY_MAP_OPTION_TECH_SPEED_ID"),
        Values = {
            "Online",
            "Quick",
            "Fair",
            "Standard",
            "Optimal",
            "Epic",
            "Marathon",
        },
        DefaultValue = 4,
        SortPriority = -101,
    }
    return {
        Name = "MultiMod: Noval feat Szczeepan (v3.6)",
        Description = "Symetrical Pangea script made for MultiMod based of Noval v9_1[NEWLINE] More info on facebook group Civ 5 - MultiBalancedMod (MultiMod)",
        IsAdvancedMap = true,
        IconIndex = 15,
        SortIndex = 2,
        SupportsSinglePlayer = true,
        SupportsMultiplayer = true,
        CustomOptions = opt
    };
end
------------------------------------------------------------------------------
function GetMapInitData(worldSize)

    local mapSize = Map.GetCustomOption(20)
    if mapSize == 4 then
        mapSize = 1 + Map.Rand(3, "Random Map - Lua");
    end
    local curWidth = 25;
    local curHeight = 20;
    local factorW = 15;
    local factorH = 10;

    if mapSize == 1 then
        curWidth = math.floor(curWidth * 0.8);
        curHeight = math.floor(curHeight * 0.8);
        factorW = math.floor(factorW * 0.8);
        factorH = math.floor(factorH * 0.8);
    end

    if mapSize == 3 then
        curWidth = math.floor(curWidth * 1.15);
        curHeight = math.floor(curHeight * 1.15);
        factorW = math.floor(factorW * 1.15);
        factorH = math.floor(factorH * 1.15);
    end

    local worldsizes = {};

    worldsizes = {

        [GameInfo.Worlds.WORLDSIZE_DUEL.ID] = {curWidth + factorW, curHeight + factorH},
        [GameInfo.Worlds.WORLDSIZE_TINY.ID] = {curWidth + 2 * factorW, curHeight + 2 *  factorH},
        [GameInfo.Worlds.WORLDSIZE_SMALL.ID] = {curWidth + 3 * factorW, curHeight + 3 * factorH},
        [GameInfo.Worlds.WORLDSIZE_STANDARD.ID] = {curWidth + 4 * factorW, curHeight + 4 * factorH},
        [GameInfo.Worlds.WORLDSIZE_LARGE.ID] = {curWidth + 5 * factorW, curHeight + 5 * factorH},
        [GameInfo.Worlds.WORLDSIZE_HUGE.ID] = {curWidth + 6 * factorW, curHeight + 6 * factorH}
    }

    local grid_size = worldsizes[worldSize];
    --
    local world = GameInfo.Worlds[worldSize];
    if (world ~= nil) then
        return {
            Width = grid_size[1],
            Height = grid_size[2],
            WrapX = true,
            WrapY = false,
        };
    end

end