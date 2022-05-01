------------------------------------------------------------------------------
--	FILE:	 Lekmapv2.2.lua (Modified Pangaea_Plus.lua)
--	AUTHOR:  Original Bob Thomas, Changes HellBlazer, lek10, EnormousApplePie, Cirra, Meota
--	PURPOSE: Global map script - Simulates a Pan-Earth Supercontinent, with
--           numerous tectonic island chains.
------------------------------------------------------------------------------
--	Copyright (c) 2011 Firaxis Games, Inc. All rights reserved.
------------------------------------------------------------------------------

include("HBMapGenerator");
include("HBFractalWorld");
include("HBFeatureGenerator");
include("HBTerrainGenerator");
include("IslandMaker");
include("MultilayeredFractal");

------------------------------------------------------------------------------
function GetMapScriptInfo()
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
				SortPriority = -90,
			},

			{
				Name = "Grass Moisture",	-- add setting for grassland mositure (8)
				Values = {
					"Wet",
					"Normal",
					"Dry",
				},

				DefaultValue = 2,
				SortPriority = -89,
			},

			{
				Name = "Rivers",	-- add setting for rivers (9)
				Values = {
					"Sparse",
					"Average",
					"Plentiful",
				},

				DefaultValue = 2,
				SortPriority = -88,
			},

			{
				Name = "Tundra",	-- add setting for tundra (10)
				Values = {
					"Sparse",
					"Average",
					"Plentiful",
				},

				DefaultValue = 2,
				SortPriority = -87,
			},


			{
				Name = "Must be coast", -- (11) force coastal start
				Values = {
					"Yes",
					"No",
				},
				DefaultValue = 2,
				SortPriority = -82,
			},
			{
				Name = "Desert Size", -- (12) desertSize
				Values = {
					"sparse",
					"average",
					"plentiful",
				},
				DefaultValue = 2,
				SortPriority = -81,
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
				SortPriority = -86,
			},

			{
				Name = "Coastal Spawns",	-- Can inland civ spawn on the coast (14)
				Values = {
					"Coastal Civs Only",
					"Random",
					"Random+ (~2 coastals)",
				},

				DefaultValue = 1,
				SortPriority = -85,
			},

			{
				Name = "Coastal Luxes",	-- Can coast spawns have non-coastal luxes (15)
				Values = {
					"Guaranteed",
					"Random",
				},

				DefaultValue = 1,
				SortPriority = -84,
			},

			{
				Name = "Inland Sea Spawns",	-- Can coastal civ spawn on inland seas (16)
				Values = {
					"Allowed",
					"Not Allowed for Coastal Civs",
				},

				DefaultValue = 1,
				SortPriority = -83,
			},

			{
				Name = "Forest Size", -- (17) forestSize
				Values = {
					"sparse",
					"average",
					"plentiful",
				},
				DefaultValue = 2,
				SortPriority = -80,
			},
			{
				Name = "Jungle Size", -- (18) jungleSize
				Values = {
					"sparse",
					"average",
					"plentiful",
				},
				DefaultValue = 2,
				SortPriority = -79,
			},
			{
				Name = "Marsh Size", -- (19) marshSize
				Values = {
					"sparse",
					"average",
					"plentiful",
				},
				DefaultValue = 2,
				SortPriority = -78,
			},
			{
				Name = "Map Dimensions", -- (20) mapSize
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

	--opt[Locale.ConvertTextKey("TXT_KEY_MAP_OPTION_TECH_SPEED_ID")] = {
	opt["Tech Speed"] = {
		Name = Locale.ConvertTextKey("TXT_KEY_MAP_OPTION_TECH_SPEED_ID"),
		Values = {
			"Marathon",
			"Epic",
			"Optimal",
			"Standard",
			"Fair",
			"Quick",
			"Online",
		},
		DefaultValue = 4,
		SortPriority = -101,
	}

	return {
		Name = "Mapa z Tech Speedem; Lekmap: Oval (v3.6)",
		Description = "A map script made for Lekmod based of HB's Mapscript v8.1. Oval",
		IsAdvancedMap = false,
		IconIndex = 15,
		SortIndex = 2,
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
	local curWidth = 20;
	local curHeight = 20;
	local factor = 10;

	if mapSize == 1 then
		curWidth = math.floor(curWidth * 0.8);
		curHeight = math.floor(curHeight * 0.8);
		factor = math.floor(factor * 0.8);
	end

	if mapSize == 3 then
		curWidth = math.floor(curWidth * 1.15);
		curHeight = math.floor(curHeight * 1.15);
		factor = math.floor(factor * 1.15);
	end

	local worldsizes = {
		[GameInfo.Worlds.WORLDSIZE_DUEL.ID] = {curWidth + factor, curHeight + factor},
		[GameInfo.Worlds.WORLDSIZE_TINY.ID] = {curWidth + 2 * factor, curHeight + 2 *  factor},
		[GameInfo.Worlds.WORLDSIZE_SMALL.ID] = {curWidth + 3 * factor, curHeight + 3 * factor},
		[GameInfo.Worlds.WORLDSIZE_STANDARD.ID] = {curWidth + 4 * factor, curHeight + 4 * factor},
		[GameInfo.Worlds.WORLDSIZE_LARGE.ID] = {curWidth + 5 * factor, curHeight + 5 * factor},
		[GameInfo.Worlds.WORLDSIZE_HUGE.ID] = {curWidth + 6 * factor, curHeight + 6 * factor}
	}

	local grid_size = worldsizes[worldSize];
	--
	local world = GameInfo.Worlds[worldSize];
	if (world ~= nil) then
		return {
			Width = grid_size[1],
			Height = grid_size[2],
			WrapX = true, -- here u can travel by east and west
		};
	end

end
------------------------------------------------------------------------------
------------------------------------------------------------------------------
function MultilayeredFractal:GeneratePlotsByRegion()
	-- Sirian's MultilayeredFractal controlling function.
	-- You -MUST- customize this function for each script using MultilayeredFractal.
	--
	-- This implementation is specific to Oval.
	local iW, iH = Map.GetGridSize();
	local fracFlags = {FRAC_POLAR = true};

	local sea_level = Map.GetCustomOption(4)
	if sea_level == 4 then
		sea_level = 1 + Map.Rand(3, "Random Sea Level - Lua");
	end
	local world_age = Map.GetCustomOption(1)
	if world_age == 4 then
		world_age = 1 + Map.Rand(3, "Random World Age - Lua");
	end
	local axis_list = {0.87, 0.81, 0.75};
	local axis_multiplier = axis_list[sea_level];
	local cohesion_list = {0.41, 0.38, 0.35};
	local cohesion_multiplier = cohesion_list[sea_level];

	-- Fill all rows with water plots.
	self.wholeworldPlotTypes = table.fill(PlotTypes.PLOT_OCEAN, iW * iH);

	-- Add the main oval as land plots.
	local centerX = iW / 2;
	local centerY = iH / 2;
	local majorAxis = centerX * axis_multiplier;
	local minorAxis = centerY * axis_multiplier;
	local majorAxisSquared = majorAxis * majorAxis;
	local minorAxisSquared = minorAxis * minorAxis;
	for x = 0, iW - 1 do
		for y = 0, iH - 1 do
			local deltaX = x - centerX;
			local deltaY = y - centerY;
			local deltaXSquared = deltaX * deltaX;
			local deltaYSquared = deltaY * deltaY;
			local d = deltaXSquared/majorAxisSquared + deltaYSquared/minorAxisSquared;
			if d <= 1 then
				local i = y * iW + x + 1;
				self.wholeworldPlotTypes[i] = PlotTypes.PLOT_LAND;
			end
		end
	end

	-- Now add bays, fjords, inland seas, etc, but not inside the cohesion area.
	local baysFrac = Fractal.Create(iW, iH, 3, fracFlags, -1, -1);
	local iBaysThreshold = baysFrac:GetHeight(82);
	local centerX = iW / 2;
	local centerY = iH / 2;
	local majorAxis = centerX * cohesion_multiplier;
	local minorAxis = centerY * cohesion_multiplier;
	local majorAxisSquared = majorAxis * majorAxis;
	local minorAxisSquared = minorAxis * minorAxis;
	for y = 0, iH - 1 do
		for x = 0, iW - 1 do
			local deltaX = x - centerX;
			local deltaY = y - centerY;
			local deltaXSquared = deltaX * deltaX;
			local deltaYSquared = deltaY * deltaY;
			local d = deltaXSquared/majorAxisSquared + deltaYSquared/minorAxisSquared;
			if d > 1 then
				local i = y * iW + x + 1;
				local baysVal = baysFrac:GetHeight(x, y);
				if baysVal >= iBaysThreshold then
					self.wholeworldPlotTypes[i] = PlotTypes.PLOT_OCEAN;
				end
			end
		end
	end

	-- Land and water are set. Now apply hills and mountains.
	local args = {
		adjust_plates = 1.5,
		world_age = world_age,
	};
	self:ApplyTectonics(args)

	-- Plot Type generation completed. Return global plot array.
	return self.wholeworldPlotTypes
end
------------------------------------------------------------------------------
function GeneratePlotTypes()
	print("Setting Plot Types (Lua Oval) ...");

	local layered_world = MultilayeredFractal.Create();
	local plot_list = layered_world:GeneratePlotsByRegion();

	SetPlotTypes(plot_list);

	local args = {bExpandCoasts = false};
	GenerateCoasts(args);
end
------------------------------------------------------------------------------

------------------------------------------------------------------------------
function GenerateTerrain()
	print("Adding Terrain (Lua Oval) ...");

	-- Get Temperature setting input by user.
	local temp = Map.GetCustomOption(2)
	if temp == 4 then
		temp = 1 + Map.Rand(3, "Random Temperature - Lua");
	end


	local args = {
		temperature = temp,
		iDesertPercent = 2 + 10 * Map.GetCustomOption(12),-- desertSize 12/22/32
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
		iForestPercent = 13 + 5 * Map.GetCustomOption(17),  -- forestSize 18/23/28
		iJunglePercent = 15 + 15 * Map.GetCustomOption(18),  -- jungleSize 30/45/60
		fMarshPercent =  3 + 7 * Map.GetCustomOption(19), -- marshSize 10/17/24
	};
	local featuregen = FeatureGenerator.Create(args);

	-- False parameter removes mountains from coastlines.
	featuregen:AddFeatures(false);
end

------------------------------------------------------------------------------
function StartPlotSystem()

	local RegionalMethod = 1;

	-- Get Resources setting input by user.
	local AllowInlandSea = Map.GetCustomOption(16)
	local res = Map.GetCustomOption(13)
	local starts = Map.GetCustomOption(5)
	if starts == 8 then
		starts = 1 + Map.Rand(8, "Random Resources Option - Lua");
	end

	-- Handle coastal spawns and start bias
	MixedBias = false;
	if Map.GetCustomOption(14) == 1 then
		OnlyCoastal = true;
		BalancedCoastal = false;
	end
	if Map.GetCustomOption(14) == 2 then
		BalancedCoastal = false;
		OnlyCoastal = false;
	end

	if Map.GetCustomOption(14) == 3 then
		OnlyCoastal = true;
		BalancedCoastal = true;
	end

	if Map.GetCustomOption(15) == 1 then
	CoastLux = true
	end

	if Map.GetCustomOption(15) == 2 then
	CoastLux = false
	end

	local _mustBeCoast = false;

	if Map.GetCustomOption(11) == 1 then
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
		AllowInlandSea = AllowInlandSea,
		CoastLux = CoastLux,
		NoCoastInland = OnlyCoastal,
		BalancedCoastal = BalancedCoastal,
		MixedBias = MixedBias;
		mustBeCoast = _mustBeCoast;
		};
	start_plot_database:GenerateRegions(args)

	print("Choosing start locations for civilizations.");
	start_plot_database:ChooseLocations(args)

	print("Normalizing start locations and assigning them to Players. DUPA");
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
end
------------------------------------------------------------------------------