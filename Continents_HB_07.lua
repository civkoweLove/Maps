------------------------------------------------------------------------------
--	FILE:	 Modified Pangaea_Plus.lua
--	AUTHOR:  Original Bob Thomas, Changes HellBlazer
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
	return {
		Name = "Continents feat. Szczeepan v0.7",
		Description = "A map script made for Lekmod based of HB's Mapscript v8.1 containing different map types selectable from the map set up screen.",
		IsAdvancedMap = false,
		IconIndex = 0,
		SortIndex = 2,
		SupportsMultiplayer = true,
		CustomOptions = {
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
				SortPriority = -96,
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
					"Very Low",
					"TXT_KEY_MAP_OPTION_LOW",
					"TXT_KEY_MAP_OPTION_MEDIUM",
					"TXT_KEY_MAP_OPTION_HIGH",
					"Very High",
					"TXT_KEY_MAP_OPTION_RANDOM",
				},
				DefaultValue = 3,
				SortPriority = -93,
			},
			{
				Name = "Start Locations",	-- 5 add resources defaults to random
				Values = {
					"Legendary Start - Strat Balance",
					"Legendary - Strat Balance + Uranium",
					"TXT_KEY_MAP_OPTION_STRATEGIC_BALANCE",
					"Strategic Balance With Coal",
					"Strategic Balance With Aluminum",
					"Strategic Balance With Coal & Aluminum",
					"TXT_KEY_MAP_OPTION_RANDOM",
				},
				DefaultValue = 2,
				SortPriority = -90,
			},

			{
				Name = "Natural Wonders", -- 6 number of natural wonders to spawn
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
				SortPriority = -88,
			},

			{
				Name = "Grass Moisture",	-- add setting for grassland mositure (7)
				Values = {
					"Wet",
					"Normal",
					"Dry",
				},

				DefaultValue = 2,
				SortPriority = -98,
			},

			{
				Name = "Rivers",	-- add setting for rivers (8)
				Values = {
					"Sparse",
					"Average",
					"Plentiful",
				},

				DefaultValue = 2,
				SortPriority = -95,
			},

			{
				Name = "Lakes",	-- add setting for Lakes (9)
				Values = {
					"Sparse",
					"Average",
					"Plentiful",
				},

				DefaultValue = 1,
				SortPriority = -94,
			},

			{
				Name = "Tundra",	-- add setting for tundra (10)
				Values = {
					"Sparse",
					"Average",
					"Plentiful",
				},

				DefaultValue = 1,
				SortPriority = -92,
			},

			{
				Name = "Islands",	-- add setting for islands (11)
				Values = {
					"Sparse",
					"Average",
					"Plentiful",
					"Abundant",
				},

				DefaultValue = 2,
				SortPriority = -89,
			},

			{
				Name = "Start type",	-- add setting for land type (12)
				Values = {
					"One Continent Challenge",
					"regular",
				},

				DefaultValue = 2,
				SortPriority = -102,
			},

			{
				Name = "Land Size X",	-- add setting for land type (13)
				Values = {
					"36",
					"38",
					"40",
					"42",
					"44",
					"46",
					"48",
					"50",
					"52",
					"54",
					"56",
					"58",
					"60",
					"62",
					"64",
					"66",
					"68",
					"70",
					"72",
					"74",
					"76",
					"78",
					"80",
					"82",
					"84",
					"86",
					"88",
					"90",
					"92",
					"94",
					"96",
					"98",
					"100",
					"102",
					"104",
					"106",
					"108",
					"110",
					"112",
					"114",
					"116",
					"118",
					"120",
					"122",
					"124",
				},

				DefaultValue = 11,
				SortPriority = -101,
			},

			{
				Name = "Land Size Y",	-- add setting for land type (14)
				Values = {
					"20",
					"22",
					"24",
					"26",
					"28",
					"30",
					"32",
					"34",
					"36",
					"38",
					"40",
					"42",
					"44",
					"46",
					"48",
					"50",
					"52",
					"54",
					"56",
					"58",
					"60",
					"62",
					"64",
					"66",
					"68",
					"70",
					"72",
					"74",
					"76",

				},

				DefaultValue = 15,
				SortPriority = -100,
			},

			{
				Name = "TXT_KEY_MAP_OPTION_RESOURCES",	-- add setting for resources (15)
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
				SortPriority = -91,
			},

			{
				Name = "Coastal Spawns",	-- Can inland civ spawn on the coast (16)
				Values = {
					"Coastal Civs Only",
					"Random",
					"Mixed bias",
				},

				DefaultValue = 3,
				SortPriority = -87,
			},

			{
				Name = "Coastal Luxes",	-- Can inland civ spawn on the coast (17)
				Values = {
					"Guaranteed",
					"Random (80% Chance Coastal)",
				},

				DefaultValue = 1,
				SortPriority = -86,
			},

			{
				Name = "Pangaea Bays",	-- Determines how harsh the bays are for mainland (18)
				Values = {
					"Minimal",
					"Standard",
					"Harsh",
				},

				DefaultValue = 2,
				SortPriority = -85,
			},
		},
	};
end
------------------------------------------------------------------------------
function GetMapInitData(worldSize)

	local LandSizeX = 34 + (Map.GetCustomOption(13) * 2);
	local LandSizeY = 18 + (Map.GetCustomOption(14) * 2);

	local worldsizes = {};


	worldsizes = {

		[GameInfo.Worlds.WORLDSIZE_DUEL.ID] = {LandSizeX, LandSizeY}, -- 720
		[GameInfo.Worlds.WORLDSIZE_TINY.ID] = {LandSizeX, LandSizeY}, -- 1664
		[GameInfo.Worlds.WORLDSIZE_SMALL.ID] = {LandSizeX, LandSizeY}, -- 2480
		[GameInfo.Worlds.WORLDSIZE_STANDARD.ID] = {LandSizeX, LandSizeY}, -- 3900
		[GameInfo.Worlds.WORLDSIZE_LARGE.ID] = {LandSizeX, LandSizeY}, -- 6076
		[GameInfo.Worlds.WORLDSIZE_HUGE.ID] = {LandSizeX, LandSizeY} -- 9424
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
-- START OF CONTINENTS CREATION CODE
------------------------------------------------------------------------------
ContinentsFractalWorld = {};
------------------------------------------------------------------------------
function ContinentsFractalWorld.Create(fracXExp, fracYExp)
	local gridWidth, gridHeight = Map.GetGridSize();

	local data = {
		InitFractal = FractalWorld.InitFractal,
		ShiftPlotTypes = FractalWorld.ShiftPlotTypes,
		ShiftPlotTypesBy = FractalWorld.ShiftPlotTypesBy,
		DetermineXShift = FractalWorld.DetermineXShift,
		DetermineYShift = FractalWorld.DetermineYShift,
		GenerateCenterRift = FractalWorld.GenerateCenterRift,
		GeneratePlotTypes = ContinentsFractalWorld.GeneratePlotTypes,	-- Custom method

		iFlags = Map.GetFractalFlags(),

		fracXExp = fracXExp,
		fracYExp = fracYExp,

		iNumPlotsX = gridWidth,
		iNumPlotsY = gridHeight,
		plotTypes = table.fill(PlotTypes.PLOT_OCEAN, gridWidth * gridHeight)
	};

	return data;
end

------------------------------------------------------------------------------
function ContinentsFractalWorld:GeneratePlotTypes(args)
	if(args == nil) then args = {}; end

	local allcomplete = false;

	while allcomplete == false do
		local sea_level_low = 67;
		local sea_level_normal = 72;
		local sea_level_high = 76;
		local world_age_old = 2;
		local world_age_normal = 5;
		local world_age_new = 15;
		--
		local extra_mountains = 25;
		local grain_amount = 0;
		local adjust_plates = 1.3;
		local shift_plot_types = true;
		local tectonic_islands = false;
		local hills_ridge_flags = self.iFlags;
		local peaks_ridge_flags = self.iFlags;
		local has_center_rift = true;
		local adjadj = 1.4;

		local sea_level = Map.GetCustomOption(4)
		if sea_level == 4 then
			sea_level = 1 + Map.Rand(3, "Random Sea Level - Lua");
		end
		local world_age = Map.GetCustomOption(1)
		if world_age == 5 then
			world_age = 1 + Map.Rand(3, "Random World Age - Lua");
		end

		-- Set Sea Level according to user selection.
		local water_percent = sea_level_normal;
		if sea_level == 1 then -- Low Sea Level
			water_percent = sea_level_low
		elseif sea_level == 3 then -- High Sea Level
			water_percent = sea_level_high
		else -- Normal Sea Level
		end

		-- Set values for hills and mountains according to World Age chosen by user.
		local adjustment = world_age_normal;
		if world_age == 4 then -- No Moutains
			adjustment = world_age_old;
			adjust_plates = adjust_plates * 0.5;
		elseif world_age == 3 then -- 5 Billion Years
			adjustment = world_age_old;
			adjust_plates = adjust_plates * 0.5;
		elseif world_age == 1 then -- 3 Billion Years
			adjustment = world_age_new;
			adjust_plates = adjust_plates * 1;
		else -- 4 Billion Years
		end
		-- Apply adjustment to hills and peaks settings.
		local hillsBottom1 = 28 - (adjustment * adjadj);
		local hillsTop1 = 28 + (adjustment * adjadj);
		local hillsBottom2 = 72 - (adjustment * adjadj);
		local hillsTop2 = 72 + (adjustment * adjadj);
		local hillsClumps = 1 + (adjustment * adjadj);
		local hillsNearMountains = 120 - (adjustment * 2) - extra_mountains;
		local mountains = 100 - adjustment - extra_mountains;

		if world_age == 4 then
			mountains = 300 - adjustment - extra_mountains;
		end

		-- Hills and Mountains handled differently according to map size
		local WorldSizeTypes = {};
		for row in GameInfo.Worlds() do
			WorldSizeTypes[row.Type] = row.ID;
		end
		local sizekey = Map.GetWorldSize();
		-- Fractal Grains
		local sizevalues = {
			[WorldSizeTypes.WORLDSIZE_DUEL]     = 3,
			[WorldSizeTypes.WORLDSIZE_TINY]     = 3,
			[WorldSizeTypes.WORLDSIZE_SMALL]    = 3,
			[WorldSizeTypes.WORLDSIZE_STANDARD] = 3,
			[WorldSizeTypes.WORLDSIZE_LARGE]    = 3,
			[WorldSizeTypes.WORLDSIZE_HUGE]		= 3
		};
		local grain = sizevalues[sizekey] or 3;
		-- Tectonics Plate Counts
		local platevalues = {
			[WorldSizeTypes.WORLDSIZE_DUEL]		= 100,
			[WorldSizeTypes.WORLDSIZE_TINY]     = 100,
			[WorldSizeTypes.WORLDSIZE_SMALL]    = 100,
			[WorldSizeTypes.WORLDSIZE_STANDARD] = 100,
			[WorldSizeTypes.WORLDSIZE_LARGE]    = 100,
			[WorldSizeTypes.WORLDSIZE_HUGE]     = 100
		};
		local numPlates = platevalues[sizekey] or 5;
		-- Add in any plate count modifications passed in from the map script.
		numPlates = numPlates * adjust_plates;

		-- Generate continental fractal layer and examine the largest landmass. Reject
		-- the result until the largest landmass occupies 45% to 55% of the total land.
		local done = false;
		local iAttempts = 0;
		local iWaterThreshold, biggest_area, iNumTotalLandTiles, iNumBiggestAreaTiles, iBiggestID;
		while done == false do
			local plusminus = 0.3;
			local grain_dice = Map.Rand(7, "Continental Grain roll - LUA Continents");
			if grain_dice < 4 then
				grain_dice = 1;
			else
				grain_dice = 2;
			end
			local rift_dice = Map.Rand(3, "Rift Grain roll - LUA Continents");
			if rift_dice < 1 then
				rift_dice = -1;
			end

			rift_dice = -1;
			grain_dice = 1;

			self.continentsFrac = nil;
			self:InitFractal{continent_grain = grain_dice, rift_grain = rift_dice};
			iWaterThreshold = self.continentsFrac:GetHeight(water_percent);

			iNumTotalLandTiles = 0;
			for x = 0, self.iNumPlotsX - 1 do
				for y = 0, self.iNumPlotsY - 1 do
					local i = y * self.iNumPlotsX + x;
					local val = self.continentsFrac:GetHeight(x, y);
					if(val <= iWaterThreshold) then
						self.plotTypes[i] = PlotTypes.PLOT_OCEAN;
					else
						self.plotTypes[i] = PlotTypes.PLOT_LAND;
						iNumTotalLandTiles = iNumTotalLandTiles + 1;
					end
				end
			end

			self:ShiftPlotTypes();

			self:GenerateCenterRift()

			SetPlotTypes(self.plotTypes);
			Map.RecalculateAreas();

			biggest_area = Map.FindBiggestArea(false);
			iNumBiggestAreaTiles = biggest_area:GetNumTiles();
			-- Now test the biggest landmass to see if it is large enough.
			if (iNumBiggestAreaTiles <= (iNumTotalLandTiles * 0.53)) and (iNumBiggestAreaTiles >= (iNumTotalLandTiles * 0.47)) then
				done = true;
				iBiggestID = biggest_area:GetID();
			end
			iAttempts = iAttempts + 1;

			-- Printout for debug use only
			print("-"); print("--- Continents landmass generation, Attempt#", iAttempts, "---");
			print("- This attempt successful: ", done);
			print("- Total Land Plots in world:", iNumTotalLandTiles);
			print("- Land Plots belonging to biggest landmass:", iNumBiggestAreaTiles);
			print("- Percentage of land belonging to biggest: ", 100 * iNumBiggestAreaTiles / iNumTotalLandTiles);
			print("- Continent Grain for this attempt: ", grain_dice);
			print("- Rift Grain for this attempt: ", rift_dice);
			print("- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -");
			print(".");

		end

		-- Generate fractals to govern hills and mountains
		self.hillsFrac = Fractal.Create(self.iNumPlotsX, self.iNumPlotsY, grain, self.iFlags, self.fracXExp, self.fracYExp);
		self.mountainsFrac = Fractal.Create(self.iNumPlotsX, self.iNumPlotsY, grain, self.iFlags, self.fracXExp, self.fracYExp);
		self.hillsFrac:BuildRidges(numPlates, hills_ridge_flags, 2, 1);
		self.mountainsFrac:BuildRidges((numPlates * 2) / 3, peaks_ridge_flags, 4, 1);
		-- Get height values
		local iHillsBottom1 = self.hillsFrac:GetHeight(hillsBottom1);
		local iHillsTop1 = self.hillsFrac:GetHeight(hillsTop1);
		local iHillsBottom2 = self.hillsFrac:GetHeight(hillsBottom2);
		local iHillsTop2 = self.hillsFrac:GetHeight(hillsTop2);
		local iHillsClumps = self.mountainsFrac:GetHeight(hillsClumps);
		local iHillsNearMountains = self.mountainsFrac:GetHeight(hillsNearMountains);
		local iMountainThreshold = self.mountainsFrac:GetHeight(mountains);
		local iPassThreshold = self.hillsFrac:GetHeight(hillsNearMountains);

		-- Set Hills and Mountains
		for x = 0, self.iNumPlotsX - 1 do
			for y = 0, self.iNumPlotsY - 1 do
				-- local plot = Map.GetPlot(x, y);
				local i = y * self.iNumPlotsX + x;
				local mountainVal = self.mountainsFrac:GetHeight(x, y);
				local hillVal = self.hillsFrac:GetHeight(x, y);

				if self.plotTypes[i]  ~= PlotTypes.PLOT_OCEAN then
					if (mountainVal >= iMountainThreshold) then
						if (hillVal >= iPassThreshold) then -- Mountain Pass though the ridgeline
							self.plotTypes[i] = PlotTypes.PLOT_HILLS;
						else -- Mountain
							-- set some randomness to moutains next to each other
							local iIsMount = Map.Rand(100, "Mountain Spwan Chance");
							--print("-"); print("Mountain Spawn Chance: ", iIsMount);
							local iIsMountAdj = 83 - adjustment;
							if iIsMount >= iIsMountAdj then
								self.plotTypes[i] = PlotTypes.PLOT_MOUNTAIN;
							else
								-- set some randomness to hills or flat land next to the mountain
								local iIsHill = Map.Rand(100, "Hill Spwan Chance");
								--print("-"); print("Mountain Spawn Chance: ", iIsMount);
								local iIsHillAdj = 50 - adjustment;
								if iIsHillAdj >= iIsHill then
									self.plotTypes[i] = PlotTypes.PLOT_HILLS;
								else
									self.plotTypes[i] = PlotTypes.PLOT_LAND;
								end
							end
						end
					elseif (mountainVal >= iHillsNearMountains) then
						self.plotTypes[i] = PlotTypes.PLOT_HILLS;
					else
						if ((hillVal >= iHillsBottom1 and hillVal <= iHillsTop1) or (hillVal >= iHillsBottom2 and hillVal <= iHillsTop2)) then
							self.plotTypes[i] = PlotTypes.PLOT_HILLS;
						else
							self.plotTypes[i] = PlotTypes.PLOT_LAND;
						end
					end
				end
			end
		end

		-- island here
		--#####################

		-- Create islands. Try to make more useful islands than the default code.
		-- pick a random tile and check if it is ocean, if it is check tiles around it
		-- to see how big an island we can make, then make an island from size 1 up to the biggest we can make

		-- Hex Adjustment tables. These tables direct plot by plot scans in a radius
		-- around a center hex, starting to Northeast, moving clockwise.
		local islandQty = {
			[WorldSizeTypes.WORLDSIZE_DUEL]		= 5,
			[WorldSizeTypes.WORLDSIZE_TINY]     = 16,
			[WorldSizeTypes.WORLDSIZE_SMALL]    = 24,
			[WorldSizeTypes.WORLDSIZE_STANDARD] = 32,
			[WorldSizeTypes.WORLDSIZE_LARGE]    = 52,
			[WorldSizeTypes.WORLDSIZE_HUGE]		= 77
		}

		local firstRingYIsEven = {{0, 1}, {1, 0}, {0, -1}, {-1, -1}, {-1, 0}, {-1, 1}};

		local secondRingYIsEven = {
			{1, 2}, {1, 1}, {2, 0}, {1, -1}, {1, -2}, {0, -2},
			{-1, -2}, {-2, -1}, {-2, 0}, {-2, 1}, {-1, 2}, {0, 2}
		};

		local thirdRingYIsEven = {
			{1, 3}, {2, 2}, {2, 1}, {3, 0}, {2, -1}, {2, -2},
			{1, -3}, {0, -3}, {-1, -3}, {-2, -3}, {-2, -2}, {-3, -1},
			{-3, 0}, {-3, 1}, {-2, 2}, {-2, 3}, {-1, 3}, {0, 3}
		};

		local firstRingYIsOdd = {{1, 1}, {1, 0}, {1, -1}, {0, -1}, {-1, 0}, {0, 1}};

		local secondRingYIsOdd = {
			{1, 2}, {2, 1}, {2, 0}, {2, -1}, {1, -2}, {0, -2},
			{-1, -2}, {-1, -1}, {-2, 0}, {-1, 1}, {-1, 2}, {0, 2}
		};

		local thirdRingYIsOdd = {
			{2, 3}, {2, 2}, {3, 1}, {3, 0}, {3, -1}, {2, -2},
			{2, -3}, {1, -3}, {0, -3}, {-1, -3}, {-2, -2}, {-2, -1},
			{-3, 0}, {-2, 1}, {-2, 2}, {-1, 3}, {0, 3}, {1, 3}
		};

		-- Direction types table, another method of handling hex adjustments, in combination with Map.PlotDirection()
		local direction_types = {
			DirectionTypes.DIRECTION_NORTHEAST,
			DirectionTypes.DIRECTION_EAST,
			DirectionTypes.DIRECTION_SOUTHEAST,
			DirectionTypes.DIRECTION_SOUTHWEST,
			DirectionTypes.DIRECTION_WEST,
			DirectionTypes.DIRECTION_NORTHWEST
		};


		plotTypesTwo = self.plotTypes;

		local iW, iH = Map.GetGridSize();
		local islMax = islandQty[sizekey] or 24;
		local mapSize = iW * iH;
		local islCount = 0;
		local islLandInRing = 0;
		local goodX = 0;
		local goodY = 0;

		local wrapX = Map:IsWrapX();
		local wrapY = false; --Map:IsWrapY();
		local nextX, nextY, plot_adjustments;
		local odd = firstRingYIsOdd;
		local even = firstRingYIsEven;
		local failedattemps = 0;
		local bIslandsFailure = false;

		local minIslandSize = 1;
		local maxIslandSize = 5;
		local escapeRedo = 500;
		local redoMap = false;

		print("######### Creating Islands #########");

		islandSetting = Map.GetCustomOption(11);

		islCount =  20;

		if islandSetting == 1 then --sparse
			islCount =  12;
		elseif islandSetting == 3 then -- plentiful
			islCount =  30;
		elseif islandSetting == 4 then -- abundant
			islCount =  40;
		end

		while islCount > 0 and escapeRedo > 0 do

			local islLandInRing = 0;
			local startingPlot = 0;
			local landX = 0;
			local landY = 0;
			local landPlot = 0;

			--pick random location
			local x = Map.Rand(iW, "");
			local y = 3 + Map.Rand((iH-6), "");
			local plotIndex = y * iW + x + 1;

			local dist = 3;
			local radius = 3 + dist + math.floor(Map.Rand(2, ""));
			print("----------------------------------------------------------------------------------------");
			print("Count: ", islCount);
			print ("Radius: ", radius);
			print("X=", x);
			print("Y=", y);

			print("--------");
			--print("Random Plot Is: ", plotIndex);

			--check if random location is ocean
			if self.plotTypes[plotIndex] == PlotTypes.PLOT_OCEAN then

				startingPlot = plotIndex;

				print("Location is Ocean");
				-- local radius = 5;

				for ripple_radius = 1, radius do
					local ripple_value = radius - ripple_radius + 1;
					local currentX = x - ripple_radius;
					local currentY = y;
					for direction_index = 1, 6 do
						for plot_to_handle = 1, ripple_radius do
							if currentY / 2 > math.floor(currentY / 2) then
								plot_adjustments = odd[direction_index];
							else
								plot_adjustments = even[direction_index];
							end
							nextX = currentX + plot_adjustments[1];
							nextY = currentY + plot_adjustments[2];
							if wrapX == false and (nextX < 0 or nextX >= iW) then
								-- X is out of bounds.
							elseif wrapY == false and (nextY < 0 or nextY >= iH) then
								-- Y is out of bounds.
							else
								local realX = nextX;
								local realY = nextY;
								if wrapX then
									realX = realX % iW;
								end
								if wrapY then
									realY = realY % iH;
								end
								-- We've arrived at the correct x and y for the current plot.
								--local plot = Map.GetPlot(realX, realY);
								local plotIndex = realY * iW + realX + 1;

								--print("--------");
								--print("Plot Is: ", plotIndex);

								-- Check this plot for land.

								if self.plotTypes[plotIndex] == PlotTypes.PLOT_LAND then
									islLandInRing = ripple_radius;

									landPlot = plotIndex;

									landX = realX;
									landY = realY;

									--print("PlotID: " .. tostring(plotIndex));
									--print("RealX: " .. tostring(realX));
									--print("RealY: " .. tostring(realY));
									break;
								end

								currentX, currentY = nextX, nextY;
							end
						end

						if islLandInRing ~= 0 then
							break;
						end
					end

					if islLandInRing ~= 0 then
						break;
					end

				end


				if islLandInRing ~= 0 then

					print("We hit land, check if it is the Mainland");

					local biggest_area = Map.FindBiggestArea(false);
					local biggest_ID = biggest_area:GetID();
					local plotCheck = Map.GetPlot(landX, landY);
					local plotArea = plotCheck:Area();
					local iAreaID = plotArea:GetID();
					local pullBack = 3;

					-- pull back the radius by 2 to 3 tiles and as long as island will be a radius of 2 then plunk it in da water init bruv!
					if plotTypesTwo[landPlot] == PlotTypes.PLOT_LAND then

						-- create us an island
						islLandInRing = islLandInRing - pullBack;

						--self.plotTypes[startingPlot] = PlotTypes.PLOT_LAND

						if islLandInRing > minIslandSize and islLandInRing < maxIslandSize then

							local islThresh = 0;
							local landvarDefault = 20;

							local locationRnd = Map.Rand(100, "");

							if (locationRnd > 49) then
								self.plotTypes[startingPlot] = PlotTypes.PLOT_LAND;
							else
								self.plotTypes[startingPlot] = PlotTypes.PLOT_HILLS;
							end

							for ripple_radius = 1, islLandInRing do
								local ripple_value = islLandInRing - ripple_radius + 1;
								local currentX = x - ripple_radius;
								local currentY = y;
								for direction_index = 1, 6 do
									for plot_to_handle = 1, ripple_radius do
										if currentY / 2 > math.floor(currentY / 2) then
											plot_adjustments = odd[direction_index];
										else
											plot_adjustments = even[direction_index];
										end
										nextX = currentX + plot_adjustments[1];
										nextY = currentY + plot_adjustments[2];
										if wrapX == false and (nextX < 0 or nextX >= iW) then
											-- X is out of bounds.
										elseif wrapY == false and (nextY < 0 or nextY >= iH) then
											-- Y is out of bounds.
										else
											local realX = nextX;
											local realY = nextY;
											if wrapX then
												realX = realX % iW;
											end
											if wrapY then
												realY = realY % iH;
											end
											-- We've arrived at the correct x and y for the current plot.
											--local plot = Map.GetPlot(realX, realY);
											local plotIndex = realY * iW + realX + 1;

											local thisislandvar = Map.Rand(60, "") + landvarDefault;

											-- closer we get to outer edge increase chance of ocean.
											if ripple_radius == 1  then --100%
												islThresh = Map.Rand(50, "") + thisislandvar;
											elseif ripple_radius == 2 then -- 57% to 74%
												islThresh = Map.Rand(45, "") + (thisislandvar / 1.25);
											elseif ripple_radius == 3 then --40% to 57%
												islThresh = Map.Rand(37, "") + (thisislandvar / 1.25);
											else --30% to 50%
												islThresh = Map.Rand(30, "") + (thisislandvar / 1.5);
											end

											local islRand = Map.Rand(100, "");
											local islHill = Map.Rand(100, "");

											--print("Rand: ", islRand, "Thresh: ", islThresh);

											if islRand > islThresh then
												self.plotTypes[plotIndex] = PlotTypes.PLOT_OCEAN
												landvarDefault = landvarDefault + 5;
											else
												if islHill <= 40 then
													self.plotTypes[plotIndex] = PlotTypes.PLOT_LAND
												else
													self.plotTypes[plotIndex] = PlotTypes.PLOT_HILLS
												end
											end

											currentX, currentY = nextX, nextY;
										end
									end
								end
							end
							islCount = islCount -1;
							print("Finished Island. islCount: ", islCount);
						end
					end
				end
			end
			print("next place");
			escapeRedo = escapeRedo - 1;

		end

		-- make sure islands were created
		if escapeRedo == 0 then
			--oh boy something went wrong, regen a new map
			redoMap = true
		end

		print("######### Finished Islands #########");

		--check to make sure map has not failed
		local iNumLandTilesInUse = 0;
		local iW, iH = Map.GetGridSize();
		local iPercent = (iW * iH) * 0.25;

		for y = 0, iH - 1 do
			for x = 0, iW - 1 do
				local i = iW * y + x;
				if self.plotTypes[i] ~= PlotTypes.PLOT_OCEAN then
					iNumLandTilesInUse = iNumLandTilesInUse + 1;
				end
			end
		end

		redoMap = false;

		print("######### Map Failure Check #########");
		print("25% Of Map Area: ", iPercent);
		print("Map Land Tiles: ", iNumLandTilesInUse);

		if iNumLandTilesInUse >= iPercent and redoMap == false then
			allcomplete = true;
			print("######### Map Pass #########");
		else
			print("######### Map Failure #########");
		end
	end

	return self.plotTypes;
end
------------------------------------------------------------------------------

------------------------------------------------------------------------------
function GeneratePlotTypes()

	local MapShape = 2;

	-- Customized plot generation to ensure avoiding "near Pangaea" conditions.
	print("Generating Plot Types (Lua Continents) ...");
	local fractal_world = ContinentsFractalWorld.Create();
	local plotTypes = fractal_world:GeneratePlotTypes();

	SetPlotTypes(plotTypes);
	GenerateCoasts();

end

------------------------------------------------------------------------------
function GenerateTerrain()
	local DesertPercent = 22;


	-- Get Temperature setting input by user.
	local temp = Map.GetCustomOption(2)
	if temp == 4 then
		temp = 1 + Map.Rand(3, "Random Temperature - Lua");
	end

	local grassMoist = Map.GetCustomOption(7);

	local args = {
		temperature = temp,
		iDesertPercent = DesertPercent,
		iGrassMoist = grassMoist,
	};

	local terraingen = TerrainGenerator.Create(args);

	terrainTypes = terraingen:GenerateTerrain();

	SetTerrainTypes(terrainTypes);

	FixIslands();

end

------------------------------------------------------------------------------
function FixIslands()
	--function to change some of the flat land tundra on islands to plains tiles
	local iW, iH = Map.GetGridSize();
	local biggest_area = Map.FindBiggestArea(False);
	local iAreaID = biggest_area:GetID();

	for y = 0, iH - 1 do
		for x = 0, iW - 1 do
			local i = iW * y + x;
			local plot = Map.GetPlotByIndex(i);
			plotAreaID = plot:GetArea();
			if plotAreaID ~= iAreaID then
				local terrainType = plot:GetTerrainType();
				local plotType = plot:GetPlotType();

				if terrainType == TerrainTypes.TERRAIN_TUNDRA then
					if plotType ~= PlotTypes.PLOT_HILLS then
						--give a chance to turn this flat tundra to plains
						local tundratoplains = Map.Rand(100, "Plains Spwan Chance");
						if tundratoplains >= 30 then
							plot:SetTerrainType(TerrainTypes.TERRAIN_PLAINS, false, true);
						end
					end
				end
			end
		end
	end
end

------------------------------------------------------------------------------
function AddFeatures()

	-- Get Rainfall setting input by user.
	local rain = Map.GetCustomOption(3)
	if rain == 4 then
		rain = 1 + Map.Rand(3, "Random Rainfall - Lua");
	end

	local args = {rainfall = rain}
	local featuregen = FeatureGenerator.Create(args);

	-- False parameter removes mountains from coastlines.
	featuregen:AddFeatures(false);
end
------------------------------------------------------------------------------

------------------------------------------------------------------------------
function StartPlotSystem()

	local spawnType = Map.GetCustomOption(12);
	local RegionalMethod = 1;

	if spawnType == 2 then
		RegionalMethod = 2;
	end

	-- Get Resources setting input by user.
	local res = Map.GetCustomOption(15)
	local starts = Map.GetCustomOption(5)
	if starts == 7 then
		starts = 1 + Map.Rand(8, "Random Resources Option - Lua");
	end

	-- Handle coastal spawns and start bias
	local OnlyCoastal = true;
	local BalancedCoastal = false;
	local MixedBias = false;

	if Map.GetCustomOption(16) == 2 then
		BalancedCoastal = true;
	end

	if Map.GetCustomOption(16) == 3 then
		BalancedCoastal = true;
		MixedBias = true;
	end

	print("Creating start plot database.");
	local start_plot_database = AssignStartingPlots.Create()

	print("Dividing the map in to Regions.");
	-- Regional Division Method 1: Biggest Landmass
	local args = {
		method = RegionalMethod,
		start_locations = starts,
		resources = res,
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
	local wonders = Map.GetCustomOption(6)
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

	local LandSize = Map.GetCustomOption(13);

	if LandSize ~= 6 then --brawl no wonders please
		start_plot_database:PlaceNaturalWonders(wonderargs)
	end

	print("Placing Resources and City States.");
	start_plot_database:PlaceResourcesAndCityStates()
end
------------------------------------------------------------------------------