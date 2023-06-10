------------------------------------------------------------------------------
--	FILE:	 Lekmapv2.2.lua (Modified Pangaea_Plus.lua)
--	AUTHOR:  Original Bob Thomas, Changes HellBlazer, lek10, EnormousApplePie, Cirra, Meota
--	PURPOSE: Global map script - Simulates a Pan-Earth Supercontinent, with
--           numerous tectonic island chains.
------------------------------------------------------------------------------
--	Copyright (c) 2011 Firaxis Games, Inc. All rights reserved.
------------------------------------------------------------------------------

include("HBMapGenerator3.8");
include("FractalWorld");
include("HBFeatureGenerator3.8");
include("HBTerrainGenerator3.8");
include("IslandMaker");
include("MultilayeredFractal");

------------------------------------------------------------------------------
function GetMapScriptInfo()
	local world_age, temperature, rainfall, sea_level, resources = GetCoreMapOptions()
	local opt = {
		{
			Name = "TXT_KEY_MAP_OPTION_WORLD_AGE", -- 1
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
			Name = "TXT_KEY_MAP_OPTION_TEMPERATURE",	-- 2 add temperature defaults to random
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
			Name = "TXT_KEY_MAP_OPTION_RAINFALL",	-- 3 add rainfall defaults to random
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
			Name = "TXT_KEY_MAP_OPTION_SEA_LEVEL",	-- 4 add sea level defaults to random.
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
			Name = "Start Quality",	-- (5) add resources defaults to random
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
			Name = "Start Distance",	-- 6 add resources defaults to random
			Values = {
				"Close",
				"Normal",
				"Far - Warning: May sometimes crash during map generation",
			},
			DefaultValue = 2,
			SortPriority = -94,
		},

		{
			Name = "Natural Wonders", -- 7 number of natural wonders to spawn
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
			Name = "Grass Moisture",	-- add setting for grassland mositure (8)
			Values = {
				"Wet",
				"Normal",
				"Dry",
			},

			DefaultValue = 2,
			SortPriority = -92,
		},

		{
			Name = "Rivers",	-- add setting for rivers (9)
			Values = {
				"sparse",
				"average",
				"plentiful",
			},

			DefaultValue = 2,
			SortPriority = -91,
		},

		{
			Name = "Tundra Size",	-- add setting for tundra (10)
			Values = {
				"sparse",
				"average",
				"plentiful",
			},

			DefaultValue = 2,
			SortPriority = -90,
		},
		{
			Name = "Forest Size", -- (11) forestSize
			Values = {
				"sparse",
				"average",
				"plentiful",
			},
			DefaultValue = 2,
			SortPriority = -89,
		},
		{
			Name = "Jungle Size", -- (12) jungleSize
			Values = {
				"sparse",
				"average",
				"plentiful",
			},
			DefaultValue = 2,
			SortPriority = -88,
		},

		{
			Name = "TXT_KEY_MAP_OPTION_RESOURCES",	-- add setting for resources (13)
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
			Name = "Must be coast", -- (14) force coastal start
			Values = {
				"Yes",
				"No",
			},
			DefaultValue = 2,
			SortPriority = -86,
		},

		{
			Name = "Desert Size", -- (15) desertSize
			Values = {
				"sparse",
				"average",
				"plentiful",
			},
			DefaultValue = 2,
			SortPriority = -85,
		},

		{
			Name = "Marsh Size", -- (16) marshSize
			Values = {
				"sparse",
				"average",
				"plentiful",
			},
			DefaultValue = 2,
			SortPriority = -84,
		},
		{
			Name = "Map Dimensions", -- (17) mapSize
			Values = {
				"Cage",
				"Standard",
				"Big",
				"Random",
			},
			DefaultValue = 2,
			SortPriority = -100,
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
		Name = "Lekmap: Small Continents (v3.8)",
		Description = "A map script made for Lekmod based of HB's Mapscript v8.1. Small Continents",
		IsAdvancedMap = false,
		IconIndex = 1,
		SortIndex = 2,
		SupportsMultiplayer = true,
	CustomOptions = opt
	};
end
------------------------------------------------------------------------------
function GetMapInitData(worldSize)

	local mapSize = Map.GetCustomOption(17)
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
		};
	end

end
------------------------------------------------------------------------------
------------------------------------------------------------------------------
function GeneratePlotTypes()
	print("Generating Plot Types (Lua Small Continents) ...");

	-- Fetch Sea Level and World Age user selections.
	local sea = Map.GetCustomOption(4)
	if sea == 4 then
		sea = 1 + Map.Rand(3, "Random Sea Level - Lua");
	end
	local age = Map.GetCustomOption(1)
	if age == 4 then
		age = 1 + Map.Rand(3, "Random World Age - Lua");
	end

	local fractal_world = FractalWorld.Create();
	fractal_world:InitFractal{
		continent_grain = 3};

	local args = {
		sea_level = sea,
		world_age = age,
		sea_level_low = 69,
		sea_level_normal = 75,
		sea_level_high = 80,
		extra_mountains = 10,
		adjust_plates = 1.5,
		tectonic_islands = true
		}
	local plotTypes = fractal_world:GeneratePlotTypes(args);
	
	SetPlotTypes(plotTypes);

	local args = {expansion_diceroll_table = {10, 4, 4}};
	GenerateCoasts(args);
end
------------------------------------------------------------------------------
function GenerateTerrain()

	-- Get Temperature setting input by user.
	local temp = Map.GetCustomOption(2)
	if temp == 4 then
		temp = 1 + Map.Rand(3, "Random Temperature - Lua");
	end

	local args = {
		temperature = temp,
		iDesertPercent = 2 + 10 * Map.GetCustomOption(15),-- desertSize 12/22/32
		rainfall = Map.GetCustomOption(3),
		iGrassMoist = Map.GetCustomOption(8),
		tundra = Map.GetCustomOption(10),
			};

	local terraingen = TerrainGenerator.Create(args);

	terrainTypes = terraingen:GenerateTerrain();
	
	SetTerrainTypes(terrainTypes);


end

------------------------------------------------------------------------------
function AddFeatures()

	-- Get Rainfall setting input by user.
	local rain = Map.GetCustomOption(3)
	if rain == 4 then
		rain = 1 + Map.Rand(3, "Random Rainfall - Lua");
	end

	local args = {
		rainfall = rain,
		iGrassMoist = Map.GetCustomOption(8),
		iForestPercent = 13 + 5 * Map.GetCustomOption(11),  -- forestSize 18/23/28
		iJunglePercent = 15 + 15 * Map.GetCustomOption(12),  -- jungleSize 30/45/60
		fMarshPercent =  3 + 7 * Map.GetCustomOption(16), -- marshSize 10/17/24
	};
	local featuregen = FeatureGenerator.Create(args);

	-- False parameter removes mountains from coastlines.
	featuregen:AddFeatures(false);
end
------------------------------------------------------------------------------

------------------------------------------------------------------------------
function StartPlotSystem()

	local RegionalMethod = 2;

	-- Get Resources setting input by user.
	local res = Map.GetCustomOption(13)
	local starts = Map.GetCustomOption(5)
	--if starts == 7 then
		--starts = 1 + Map.Rand(8, "Random Resources Option - Lua");
	--end

	-- Handle coastal spawns and start bias
	MixedBias = false;
	BalancedCoastal = false;
	OnlyCoastal = false;
	CoastLux = false;

	local _mustBeCoast = false;

	if Map.GetCustomOption(14) == 1 then -- force coastal start
		_mustBeCoast = true;
		print("mustBeCoast = true");
	end

	print("Creating start plot database.");
	local start_plot_database = AssignStartingPlots.Create()

	print("Dividing the map in to Regions.");
	-- Regional Division Method 1: Biggest Landmass
	local args = {
		method = RegionalMethod,
		start_locations = starts,
		resources = res,
		CoastLux = CoastLux,
		NoCoastInland = OnlyCoastal,
		BalancedCoastal = BalancedCoastal,
		MixedBias = MixedBias;
		mustBeCoast = _mustBeCoast;
		};
	start_plot_database:GenerateRegions(args)

	print("Choosing start locations for civilizations.");
	start_plot_database:ChooseLocations()
	
	print("Normalizing start locations and assigning them to Players.");
	start_plot_database:BalanceAndAssign(args)

	print("Placing Natural Wonders.");
	local wonders = Map.GetCustomOption(7)
	if wonders == 14 then
		wonders = Map.Rand(13, "Number of Wonders To Spawn - Lua");
	else
		wonders = wonders - 1;
	end

	print("########## Wonders ##########");
	print("Natural Wonders To Place: ", wonders);

	local wonderargs = {
		wonderamt = wonders,
	};
	start_plot_database:PlaceNaturalWonders(wonderargs);
	print("Placing Resources and City States.");
	start_plot_database:PlaceResourcesAndCityStates()

	-- tell the AI that we should treat this as a naval expansion map
	Map.ChangeAIMapHint(4);

end
------------------------------------------------------------------------------