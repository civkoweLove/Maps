------------------------------------------------------------------------------
--	FILE:	 Lekmapv2.2.lua (Modified Pangaea_Plus.lua)
--	AUTHOR:  Original Bob Thomas, Changes HellBlazer, lek10, EnormousApplePie, Cirra, Meota
--	PURPOSE: Global map script - Simulates a Pan-Earth Supercontinent, with
--           numerous tectonic island chains.
------------------------------------------------------------------------------
--	Copyright (c) 2011 Firaxis Games, Inc. All rights reserved.
------------------------------------------------------------------------------

include("HBMapGenerator3.6");
include("HBFractalWorld3.6");
include("HBFeatureGenerator3.6");
include("HBTerrainGenerator3.6");
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
			Name = "Desert Size", -- (11) desertSize
			Values = {
				"sparse",
				"average",
				"plentiful",
			},
			DefaultValue = 2,
			SortPriority = -89,
		},

		{
			Name = "Forest Size", -- (12) forestSize
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
			Name = "Coastal Spawns",	-- Can inland civ spawn on the coast (14)
			Values = {
				"Coastal Civs Only",
				"Random",
				"Random+ (~2 coastals)",
			},

			DefaultValue = 1,
			SortPriority = -86,
		},

		{
			Name = "Coastal Luxes",	-- Can coast spawns have non-coastal luxes (15)
			Values = {
				"Guaranteed",
				"Random",
			},

			DefaultValue = 1,
			SortPriority = -85,
		},

		{
			Name = "Inland Sea Spawns",	-- Can coastal civ spawn on inland seas (16)
			Values = {
				"Allowed",
				"Not Allowed for Coastal Civs",
			},

			DefaultValue = 1,
			SortPriority = -84,
		},
		{
			Name = "Radius Size", -- (17) radiusSize
			Values = {
				"0 - to the edge",
				"1",
				"2",
				"3",
				"4 - default",
			},
			DefaultValue = 5,
			SortPriority = -83,
		},
		{
			Name = "Holy Radius Factor", -- (18) holyRadiusFactor
			Values = {
				"1,5",
				"2 - default",
				"3",
				"4",
			},
			DefaultValue = 2,
			SortPriority = -82,
		},
		{
			Name = "Outside Region", -- (19) Outside terrain Type
			Values = {
				"TXT_KEY_MAP_OPTION_HILLS",
				"TXT_KEY_MAP_OPTION_MOUNTAINS",
				"TXT_KEY_MAP_OPTION_OCEAN",
				"TXT_KEY_MAP_OPTION_STANDARD",
				"TXT_KEY_MAP_OPTION_RANDOM",
			},
			DefaultValue = 3,
			SortPriority = -81,
		},
		{
			Name = "TXT_KEY_MAP_OPTION_CENTER_REGION", -- (20)
			Values = {
				"TXT_KEY_MAP_OPTION_HILLS",
				"TXT_KEY_MAP_OPTION_MOUNTAINS",
				"TXT_KEY_MAP_OPTION_OCEAN",
				"TXT_KEY_MAP_OPTION_DESERT",
				"TXT_KEY_MAP_OPTION_STANDARD",
				"TXT_KEY_MAP_OPTION_RANDOM",
			},
			DefaultValue = 3,
			SortPriority = -80,
		},
		{
			Name = "Must be coast", -- (21) force coastal start
			Values = {
				"Yes",
				"No",
			},
			DefaultValue = 1,
			SortPriority = -79,
		},

		{
			Name = "Jungle Size", -- (22) jungleSize
			Values = {
				"sparse",
				"average",
				"plentiful",
			},
			DefaultValue = 2,
			SortPriority = -78,
		},

		{
			Name = "Marsh Size", -- (23) marshSize
			Values = {
				"sparse",
				"average",
				"plentiful",
			},
			DefaultValue = 2,
			SortPriority = -77,
		},

		{
			Name = "Map Dimensions", -- (24) mapSize
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
		Name = "LoveMap: Donut (v3.6)",
		Description = "TXT_KEY_MAP_DONUT_HELP",
		IsAdvancedMap = false,
		IconIndex = 18,
		SortIndex = 2,
		SupportsMultiplayer = true,
		CustomOptions = opt
	};
end
------------------------------------------------------------------------------
function GetMapInitData(worldSize)

	local mapSize = Map.GetCustomOption(24)
	if mapSize == 4 then
		mapSize = 1 + Map.Rand(3, "Random Map - Lua");
	end

	local curWidth = 14;
	local curHeight = 14;
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
			WrapX = false,
		};
	end


end
------------------------------------------------------------------------------
-------------------------------------------------------------------------------
function MultilayeredFractal:GeneratePlotsByRegion()
	-- Sirian's MultilayeredFractal controlling function.
	-- You -MUST- customize this function for each script using MultilayeredFractal.
	--
	-- This implementation is specific to Donut.
	local iW, iH = Map.GetGridSize();
	local fracFlags = {FRAC_WRAP_X = false, FRAC_POLAR = true};

	-- Get user input.
	hole_type = Map.GetCustomOption(20) -- Global
	
	-- Get user input.
	radiusSize = Map.GetCustomOption(17) -- Global
	radiusSize = radiusSize - 1;
	-- Get user input.
	holyRadiusFactor = Map.GetCustomOption(18) -- Global
	if holyRadiusFactor == 1 then
		holyRadiusFactor = 1.5;
	end
	
		-- Get user input.
	outsideTerrainType = Map.GetCustomOption(19) -- Global
	
	if outsideTerrainType == 5 then
		outsideTerrainType = 1 + Map.Rand(4, "Random terrain type for outside region - Donut Lua");
	end
	
	if hole_type == 6 then
		hole_type = 1 + Map.Rand(5, "Random terrain type for center region - Donut Lua");
	end

	local worldsizes = {
		[GameInfo.Worlds.WORLDSIZE_DUEL.ID] = 3,
		[GameInfo.Worlds.WORLDSIZE_TINY.ID] = 4,
		[GameInfo.Worlds.WORLDSIZE_SMALL.ID] = 4,
		[GameInfo.Worlds.WORLDSIZE_STANDARD.ID] = 5,
		[GameInfo.Worlds.WORLDSIZE_LARGE.ID] = 5,
		[GameInfo.Worlds.WORLDSIZE_HUGE.ID] = 6,
		};
	local grain = worldsizes[Map.GetWorldSize()];

	local terrainFrac = Fractal.Create(iW, iH, grain, fracFlags, -1, -1);
	local iHillsThreshold = terrainFrac:GetHeight(91);
	local iPeaksThreshold = terrainFrac:GetHeight(96);
	local iHillsClumps = terrainFrac:GetHeight(4);

	local hillsFrac = Fractal.Create(iW, iH, grain, fracFlags, -1, -1);
	local iHillsBottom1 = hillsFrac:GetHeight(20);
	local iHillsTop1 = hillsFrac:GetHeight(30);
	local iHillsBottom2 = hillsFrac:GetHeight(70);
	local iHillsTop2 = hillsFrac:GetHeight(80);

	local iCenterX = math.floor(iW / 2);
	local iCenterY = math.floor(iH / 2);
	local iRadius = iCenterX - radiusSize;
	local iHoleRadius = math.floor(iRadius / holyRadiusFactor);

	for y = 0, iH - 1 do
		for x = 0, iW - 1 do
			local i = y * iW + x + 1;
			local fDistance = 0;
			if x ~= iCenterX or y ~= iCenterY then
				fDistance = math.sqrt(((x - iCenterX) ^ 2) + ((y - iCenterY) ^ 2));
			end
			if fDistance > iRadius then
				if outsideTerrainType == 1 then
					self.wholeworldPlotTypes[i] = PlotTypes.PLOT_HILLS;
				elseif outsideTerrainType == 2 then
					self.wholeworldPlotTypes[i] = PlotTypes.PLOT_MOUNTAIN;
				elseif outsideTerrainType == 3 then
					self.wholeworldPlotTypes[i] = PlotTypes.PLOT_OCEAN;
				else -- standard type
					local val = terrainFrac:GetHeight(x, y);
					local hillsVal = hillsFrac:GetHeight(x, y);
					if val >= iPeaksThreshold then
						self.wholeworldPlotTypes[i] = PlotTypes.PLOT_MOUNTAIN;
					elseif val >= iHillsThreshold or val <= iHillsClumps then
						self.wholeworldPlotTypes[i] = PlotTypes.PLOT_HILLS;
					elseif hillsVal >= iHillsBottom1 and hillsVal <= iHillsTop1 then
						self.wholeworldPlotTypes[i] = PlotTypes.PLOT_HILLS;
					elseif hillsVal >= iHillsBottom2 and hillsVal <= iHillsTop2 then
						self.wholeworldPlotTypes[i] = PlotTypes.PLOT_HILLS;
					else
						self.wholeworldPlotTypes[i] = PlotTypes.PLOT_LAND;
					end
				end
			elseif fDistance < iHoleRadius and hole_type < 4 then -- Plot is in hole of donut.
				if hole_type == 1 then
					self.wholeworldPlotTypes[i] = PlotTypes.PLOT_HILLS;
				elseif hole_type == 2 then
					self.wholeworldPlotTypes[i] = PlotTypes.PLOT_MOUNTAIN;
				else
					self.wholeworldPlotTypes[i] = PlotTypes.PLOT_OCEAN;
				end
			else -- standard type
				local val = terrainFrac:GetHeight(x, y);
				local hillsVal = hillsFrac:GetHeight(x, y);
				if val >= iPeaksThreshold then
					self.wholeworldPlotTypes[i] = PlotTypes.PLOT_MOUNTAIN;
				elseif val >= iHillsThreshold or val <= iHillsClumps then
					self.wholeworldPlotTypes[i] = PlotTypes.PLOT_HILLS;
				elseif hillsVal >= iHillsBottom1 and hillsVal <= iHillsTop1 then
					self.wholeworldPlotTypes[i] = PlotTypes.PLOT_HILLS;
				elseif hillsVal >= iHillsBottom2 and hillsVal <= iHillsTop2 then
					self.wholeworldPlotTypes[i] = PlotTypes.PLOT_HILLS;
				else
					self.wholeworldPlotTypes[i] = PlotTypes.PLOT_LAND;
				end
			end
		end
	end

	-- Plot Type generation completed. Return global plot array.
	return self.wholeworldPlotTypes
end
------------------------------------------------------------------------------
function GeneratePlotTypes()
	print("Setting Plot Types (Lua Donut) ...");

	local layered_world = MultilayeredFractal.Create();
	local plotsDonut = layered_world:GeneratePlotsByRegion();
	
	SetPlotTypes(plotsDonut);

	GenerateCoasts();
end
------------------------------------------------------------------------------

----------------------------------------------------------------------------------
function TerrainGenerator:GenerateTerrainAtPlot(iX, iY)
	local plot = Map.GetPlot(iX, iY);
	if (plot:IsWater()) then
		local val = plot:GetTerrainType();
		if val == TerrainTypes.NO_TERRAIN then -- Error handling.
			val = self.terrainGrass;
			plot:SetPlotType(PlotTypes.PLOT_LAND, false, false);
		end
		return val;	 
	end

	local iW, iH = Map.GetGridSize();
	local iCenterX = math.floor(iW / 2);
	local iCenterY = math.floor(iH / 2);
	local iRadius = iCenterX - radiusSize;
	local iHoleRadius = math.floor(iRadius / holyRadiusFactor);
	local terrainVal = self.terrainGrass;

	local fDistance = 0;
	if iX ~= iCenterX or iY ~= iCenterY then
		fDistance = math.sqrt(((iX - iCenterX) ^ 2) + ((iY - iCenterY) ^ 2));
	end
	if fDistance < iHoleRadius and hole_type == 4 then -- Desert plot in center.
		terrainVal = self.terrainDesert;
	else
		local desertVal = self.deserts:GetHeight(iX, iY);
		local plainsVal = self.plains:GetHeight(iX, iY);
		if ((desertVal >= self.iDesertBottom) and (desertVal <= self.iDesertTop)) then
			terrainVal = self.terrainDesert;
		elseif ((plainsVal >= self.iPlainsBottom) and (plainsVal <= self.iPlainsTop)) then
			terrainVal = self.terrainPlains;
		end
	end
	
	return terrainVal;
end
----------------------------------------------------------------------------------
function GenerateTerrain()
	print("Generating Terrain (Lua Donut) ...");
	-- desertSize

	local args = {
		temperature = temp,
		iDesertPercent = 2 + 10 * Map.GetCustomOption(11),-- desertSize 12/22/32
		rainfall = Map.GetCustomOption(3),
		iGrassMoist = Map.GetCustomOption(8),
		tundra = Map.GetCustomOption(10),

	};

	local terraingen = TerrainGenerator.Create(args);

	terrainTypes = terraingen:GenerateTerrain();
	
	SetTerrainTypes(terrainTypes);
	
	-- FixIslands();
end
------------------------------------------------------------------------------

------------------------------------------------------------------------------
function FeatureGenerator:AddIceAtPlot(plot, iX, iY, lat)
	-- No ice.
end
------------------------------------------------------------------------------
function FeatureGenerator:AddJunglesAtPlot(plot, iX, iY, lat)
	-- No jungle.
end
------------------------------------------------------------------------------
function AddFeatures()
	print("Adding Features (Lua Donut) ...");

	local rain = Map.GetCustomOption(3)
	if rain == 4 then
		rain = 1 + Map.Rand(3, "Random Rainfall - Lua");
	end

	local args = {
		rainfall = rain,
		iGrassMoist = Map.GetCustomOption(8),
		iForestPercent = 13 + 5 * Map.GetCustomOption(12),  -- forestSize 18/23/28
		iJunglePercent = 15 + 15 * Map.GetCustomOption(22),  -- jungleSize 30/45/60
		fMarshPercent =  3 + 7 * Map.GetCustomOption(23), -- marshSize 10/17/24
	};

	local featuregen = FeatureGenerator.Create(args);



	-- False parameter removes mountains from coastlines.
	featuregen:AddFeatures(false);
end
------------------------------------------------------------------------------


------------------------------------------------------------------------------
function StartPlotSystem()

	local RegionalMethod = 1;

	-- Get Resources setting input by user.
	local AllowInlandSea = Map.GetCustomOption(16)
	local res = Map.GetCustomOption(13)
	local starts = Map.GetCustomOption(5)
	--if starts == 7 then
		--starts = 1 + Map.Rand(8, "Random Resources Option - Lua");
	--end

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
	if Map.GetCustomOption(21) == 1 then -- 21 on this
		_mustBeCoast = true;
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