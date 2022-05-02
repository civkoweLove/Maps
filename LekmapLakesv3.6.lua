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
			Name = "TXT_KEY_MAP_OPTION_RAINFALL",	-- (3) add rainfall defaults to random
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
			Name = "TXT_KEY_MAP_OPTION_RESOURCES",	-- add setting for resources (11)
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
			SortPriority = -89,
		},
		{
			Name = "TXT_KEY_MAP_OPTION_BODIES_OF_WATER", -- (12)
			Values = {
				{"TXT_KEY_MAP_OPTION_SMALL_LAKES", "TXT_KEY_MAP_OPTION_SMALL_LAKES_HELP"},
				{"TXT_KEY_MAP_OPTION_LARGE_LAKES", "TXT_KEY_MAP_OPTION_LARGE_LAKES_HELP"},
				{"TXT_KEY_MAP_OPTION_SEAS", "TXT_KEY_MAP_OPTION_SEAS_HELP"},
				"TXT_KEY_MAP_OPTION_RANDOM",
			},
			DefaultValue = 4,
			SortPriority = 1,
		},
		{
			Name = "Forest Size", -- (13) forestSize
			Values = {
				"sparse",
				"average",
				"plentiful",
			},
			DefaultValue = 2,
			SortPriority = -88,
		},
		{
			Name = "Jungle Size", -- (14) jungleSize
			Values = {
				"sparse",
				"average",
				"plentiful",
			},
			DefaultValue = 2,
			SortPriority = -87,
		},
		{
			Name = "Marsh Size", -- (15) marshSize
			Values = {
				"sparse",
				"average",
				"plentiful",
			},
			DefaultValue = 2,
			SortPriority = -86,
		},
		{
			Name = "Desert Size", -- (16) desertSize
			Values = {
				"sparse",
				"average",
				"plentiful",
			},
			DefaultValue = 2,
			SortPriority = -85,
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
		Name = "Lekmap: Lakes (v3.6)",
		Description = "A map script made for Lekmod based of HB's Mapscript v8.1. Lakes",
		IsAdvancedMap = false,
		IconIndex = 13,
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
		curWidth = math.floor(curWidth * 0.65);
		curHeight = math.floor(curHeight * 0.65);
		factorW = math.floor(factorW * 0.65);
		factorH = math.floor(factorH * 0.65);
	end

	if mapSize == 2 then
		curWidth = math.floor(curWidth * 0.85);
		curHeight = math.floor(curHeight * 0.85);
		factorW = math.floor(factorW * 0.85);
		factorH = math.floor(factorH * 0.85);
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

-------------------------------------------------------------------------------
function MultilayeredFractal:GeneratePlotsByRegion()
	-- Sirian's MultilayeredFractal controlling function.
	-- You -MUST- customize this function for each script using MultilayeredFractal.
	--
	-- This implementation is specific to Lakes.
	local iW, iH = Map.GetGridSize();
	local fracFlags = {FRAC_WRAP_X = true, FRAC_POLAR = true};

	-- Fill all but the top two rows with land plots.
	self.wholeworldPlotTypes = table.fill(PlotTypes.PLOT_LAND, iW * (iH - 2));
	-- Ensure top two and bottom two rows are ocean (to give rivers a place to end and to create polar ice).
	for x = 0, iW - 1 do
		self.wholeworldPlotTypes[x + 1] = PlotTypes.PLOT_OCEAN;
		self.wholeworldPlotTypes[iW + x + 1] = PlotTypes.PLOT_OCEAN;
		self.wholeworldPlotTypes[iW * iH - x] = PlotTypes.PLOT_OCEAN;
		self.wholeworldPlotTypes[iW * (iH - 1) - x] = PlotTypes.PLOT_OCEAN;
	end

	-- Get user inputs.
	local world_age = Map.GetCustomOption(1)
	if world_age == 4 then
		world_age = 1 + Map.Rand(3, "Random World Age - Lua");
	end
	local userInputLakes = Map.GetCustomOption(12)
	if userInputLakes == 4 then -- Random
		userInputLakes = 1 + Map.Rand(3, "Highlands Random Lake Size - Lua");
	end

	-- Lake density
	local lake_list = {93, 90, 85};
	local lake_grains = {5, 4, 3};
	local lakes = lake_list[userInputLakes];
	local lake_grain = lake_grains[userInputLakes];

	local lakesFrac = Fractal.Create(iW, iH, lake_grain, fracFlags, -1, -1);
	local iLakesThreshold = lakesFrac:GetHeight(lakes);

	for y = 1, iH - 2 do
		for x = 0, iW - 1 do
			local i = y * iW + x + 1; -- add one because Lua arrays start at 1
			local lakeVal = lakesFrac:GetHeight(x, y);
			if lakeVal >= iLakesThreshold then
				self.wholeworldPlotTypes[i] = PlotTypes.PLOT_OCEAN;
			end
		end
	end

	-- Land and water are set. Now apply hills and mountains.
	local args = {
		adjust_plates = 1.2,
		world_age = world_age,
	};
	self:ApplyTectonics(args)

	-- Plot Type generation completed. Return global plot array.
	return self.wholeworldPlotTypes
end
------------------------------------------------------------------------------

------------------------------------------------------------------------------
function GeneratePlotTypes()
	print("Setting Plot Types (Lua Lakes) ...");

	local layered_world = MultilayeredFractal.Create();
	local plotsLakes = layered_world:GeneratePlotsByRegion();
	
	SetPlotTypes(plotsLakes);

	GenerateCoasts();
end
------------------------------------------------------------------------------
function GenerateTerrain()
	print("Generating Terrain (Lua Lakes) ...");
	
	-- Get Temperature setting input by user.
	local temp = Map.GetCustomOption(2)
	if temp == 4 then
		temp = 1 + Map.Rand(3, "Random Temperature - Lua");
	end

	local args = {
		temperature = temp,
		iDesertPercent = 2 + 10 * Map.GetCustomOption(16),-- desertSize 12/22/32
		rainfall = Map.GetCustomOption(3),
		iGrassMoist = Map.GetCustomOption(8),
		tundra = Map.GetCustomOption(10),

	};
	local terraingen = TerrainGenerator.Create(args);

	terrainTypes = terraingen:GenerateTerrain();
	
	SetTerrainTypes(terrainTypes);
end
------------------------------------------------------------------------------
function FeatureGenerator:AddIceAtPlot(plot, iX, iY, lat)
	-- Overriding default feature ice to ensure that the ice fully covers two rows, at top and bottom
	if(plot:CanHaveFeature(self.featureIce)) then
		if iY < 2 or iY >= self.iGridH - 2 then
			plot:SetFeatureType(self.featureIce, -1)
			
		else
			local rand = Map.Rand(100, "Add Ice Lua")/100.0;
			
			if(rand < 8 * (lat - 0.875)) then
				plot:SetFeatureType(self.featureIce, -1);
			elseif(rand < 4 * (lat - 0.75)) then
				plot:SetFeatureType(self.featureIce, -1);
			end
		end
	end
end
------------------------------------------------------------------------------
function AddFeatures()
	print("Adding Features (Lua Lakes) ...");

	-- Get Rainfall setting input by user.
	local rain = Map.GetCustomOption(3)
	if rain == 4 then
		rain = 1 + Map.Rand(3, "Random Rainfall - Lua");
	end

	local args = {
		rainfall = rain,
		iGrassMoist = Map.GetCustomOption(8),
		iForestPercent = 13 + 5 * Map.GetCustomOption(13),  -- forestSize 18/23/28
		iJunglePercent = 15 + 15 * Map.GetCustomOption(14),  -- jungleSize 30/45/60
		fMarshPercent =  3 + 7 * Map.GetCustomOption(15), -- marshSize 10/17/24
	};
	local featuregen = FeatureGenerator.Create(args);

	-- False parameter removes mountains from coastlines.
	featuregen:AddFeatures(false);
end
------------------------------------------------------------------------------

------------------------------------------------------------------------------
function AssignStartingPlots:CanPlaceCityStateAt(x, y, area_ID, force_it, ignore_collisions)
	-- Overriding default city state placement to prevent city states from being placed too close to the poles.
	local iW, iH = Map.GetGridSize();
	local plot = Map.GetPlot(x, y)
	local area = plot:GetArea()
	
	-- Adding this check for Lakes
	if y < 4 or y >= iH - 4 then
		return false
	end
	--
	
	if area ~= area_ID and area_ID ~= -1 then
		return false
	end
	local plotType = plot:GetPlotType()
	if plotType == PlotTypes.PLOT_OCEAN or plotType == PlotTypes.PLOT_MOUNTAIN then
		return false
	end
	local terrainType = plot:GetTerrainType()
	if terrainType == TerrainTypes.TERRAIN_SNOW then
		return false
	end
	local plotIndex = y * iW + x + 1;
	if self.cityStateData[plotIndex] > 0 and force_it == false then
		return false
	end
	local plotIndex = y * iW + x + 1;
	if self.playerCollisionData[plotIndex] == true and ignore_collisions == false then
		return false
	end
	return true
end
------------------------------------------------------------------------------
function StartPlotSystem()

	local RegionalMethod = 1;

	-- Get Resources setting input by user.
	local res = Map.GetCustomOption(11)
	local starts = Map.GetCustomOption(5)
	--if starts == 7 then
		--starts = 1 + Map.Rand(8, "Random Resources Option - Lua");
	--end

	-- Handle coastal spawns and start bias
	MixedBias = false;
	BalancedCoastal = false;
	OnlyCoastal = false;
	CoastLux = false;

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
end
------------------------------------------------------------------------------