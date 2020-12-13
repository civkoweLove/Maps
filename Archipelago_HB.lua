------------------------------------------------------------------------------
--	FILE:	 Archipelago.lua
--	AUTHOR:  Bob Thomas
--	PURPOSE: Global map script - Produces a world full of islands.
--           This is one of Civ5's featured map scripts.
------------------------------------------------------------------------------
--	Copyright (c) 2010 Firaxis Games, Inc. All rights reserved.
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
		Name = "Archipelago feat. Izydor",
		Description = "TXT_KEY_MAP_ARCHIPELAGO_HELP",
		IsAdvancedMap = false,
		IconIndex = 2,
		SortIndex = 3,
		SupportsMultiplayer = true,
		CustomOptions = {
			{
				Name = "TXT_KEY_MAP_OPTION_TEMPERATURE",	-- 1 add temperature defaults to random
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
				Name = "TXT_KEY_MAP_OPTION_RAINFALL",	-- 2 add rainfall defaults to random
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
				Name = "Start Locations",	-- 3 add resources defaults to random
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
				SortPriority = -80,
			},

			{
				Name = "Natural Wonders", -- 4 number of natural wonders to spawn
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
				Name = "Grass Moisture",	-- add setting for grassland mositure (5)
				Values = {
					"Wet",
					"Normal",
					"Dry",
				},

				DefaultValue = 2,
				SortPriority = -98,
			},

			{
				Name = "Islands count",	-- add setting for islands (6)
				Values = {
					"Sparse",
					"Average",
					"Plentiful",
					"Abundant",
				},

				DefaultValue = 2,
				SortPriority = -82,
			},

			{
				Name = "Land Size X",	-- add setting for land type (7)
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
				Name = "Land Size Y",	-- add setting for land type (8)
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
				Name = "TXT_KEY_MAP_OPTION_RESOURCES",	-- add setting for resources (9)
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
				SortPriority = -81,
			},
			
			{
				Name = "Islands size",	-- add setting for resources (10)
				Values = {
					"small",
					"normal",
					"big",
					"large",
				},

				DefaultValue = 2,
				SortPriority = -83,
			},
		},
	}
end
------------------------------------------------------------------------------
function GetMapInitData(worldSize)
	
	local LandSizeX = 34 + (Map.GetCustomOption(7) * 2);
	local LandSizeY = 18 + (Map.GetCustomOption(8) * 2);

	local worldsizes = {};

	worldsizes = {
		[GameInfo.Worlds.WORLDSIZE_DUEL.ID] = {LandSizeX, LandSizeY}, -- 960
		[GameInfo.Worlds.WORLDSIZE_TINY.ID] = {LandSizeX, LandSizeY}, -- 2016
		[GameInfo.Worlds.WORLDSIZE_SMALL.ID] = {LandSizeX, LandSizeY}, -- 2772
		[GameInfo.Worlds.WORLDSIZE_STANDARD.ID] = {LandSizeX, LandSizeY}, -- 4160
		[GameInfo.Worlds.WORLDSIZE_LARGE.ID] = {LandSizeX, LandSizeY}, -- 6656
		[GameInfo.Worlds.WORLDSIZE_HUGE.ID] = {LandSizeX, LandSizeY} -- 10240
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
Archipelago = {};
------------------------------------------------------------------------------
function Archipelago.Create(fracXExp, fracYExp)
	local gridWidth, gridHeight = Map.GetGridSize();
	
	local data = {
		InitFractal = FractalWorld.InitFractal,
		ShiftPlotTypes = FractalWorld.ShiftPlotTypes,
		ShiftPlotTypesBy = FractalWorld.ShiftPlotTypesBy,
		DetermineXShift = FractalWorld.DetermineXShift,
		DetermineYShift = FractalWorld.DetermineYShift,
		GenerateCenterRift = FractalWorld.GenerateCenterRift,
		GeneratePlotTypes = Archipelago.GeneratePlotTypes,	-- Custom method
		
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
function Archipelago:GeneratePlotTypes(args)
	if(args == nil) then args = {}; end
	
	-- Create islands. Try to make more useful islands than the default code.
	-- pick a random tile and check if it is ocean, if it is check tiles around it
	-- to see how big an island we can make, then make an island from size 1 up to the biggest we can make

	-- Hex Adjustment tables. These tables direct plot by plot scans in a radius 
	-- around a center hex, starting to Northeast, moving clockwise.
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

	local iW, iH = Map.GetGridSize();
	local iLandSize = 3;
	local mapSize = iW * iH;
	local islLandInRing = 0;
	local goodX = 0;
	local goodY = 0;

	local wrapX = Map:IsWrapX();
	local wrapY = Map:IsWrapY();
	local nextX, nextY, plot_adjustments;
	local odd = firstRingYIsOdd;
	local even = firstRingYIsEven;

	print("######### Creating Islands #########");

	local islCount = 0;
	local islandSetting = Map.GetCustomOption(6);
	
	if islandSetting == 1 then --sparse
		islCount =  20;
	elseif islandSetting == 2 then -- average
		islCount =  28;
	elseif islandSetting == 3 then -- plentiful
		islCount =  40;
	elseif islandSetting == 4 then -- abundant
		islCount =  50;
	end
	
	local dist = 4 - Map.GetCustomOption(6);
	while islCount > 0 do
		local islLandInRing = 0;
		--pick random location
		local x = Map.Rand(iW, "");
		local y = 6 + Map.Rand((iH-12), "");	
		local plotIndex = y * iW + x;
		local radius = 3 + dist + math.floor(Map.Rand(2, ""));
		--print("Count: ", islCount);
		--print ("Radius: ", radius);
		--print("X=", x);
		--print("Y=", y);		
		
		--print("--------");
		--print("Random Plot Is: ", plotIndex);

		--check if random location is ocean
		if self.plotTypes[plotIndex] == PlotTypes.PLOT_OCEAN then
		
			--print("Location is Ocean");

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
							local plot = Map.GetPlot(realX, realY);
							local plotIndex = realY * iW + realX + 1;
	
							--print("--------");
							--print("Plot Is: ", plotIndex);
	
							-- Check this plot for land.

							if self.plotTypes[plotIndex] == PlotTypes.PLOT_LAND then
								islLandInRing = ripple_radius;
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

			if islLandInRing == 0 then
			
				local actradius = radius - dist - 1;
				local thisislandvar = Map.Rand(40, "") + 40;

				plotIndex = y * iW + x+1;
				--print("---------PlotIndex: ", plotIndex);
				--print("---------");
				--print("Island Location Found At X=", x, ", Y=",y);
				--print("Island Size: ", actradius);
				
				self.plotTypes[plotIndex] = PlotTypes.PLOT_LAND;

				for ripple_radius = 1, actradius do
					local ripple_value = actradius - ripple_radius + 1;
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
								local plot = Map.GetPlot(realX, realY);
								local plotIndex = realY * iW + realX + 1;
		
								--print("--------");
								--print("Plot Is: ", plotIndex);
		
								-- closer we get to outer edge increase chance of ocean.
								--if ripple_radius == 1  then --100%
								--	islThresh = Map.Rand(27, "") + thisislandvar;
								--elseif ripple_radius == 2 then -- 57% to 74%
								--	islThresh = Map.Rand(32, "") + (thisislandvar / 1.25);
								--elseif ripple_radius == 3 then --40% to 57%
								--	islThresh = Map.Rand(25, "") + (thisislandvar / 1.5);									
								--else --30% to 50%
								--	islThresh = Map.Rand(20, "") + (thisislandvar / 2);
								--end
								
								islThresh = Map.Rand(25, "") + (thisislandvar / 1.5);
								
								local islRand = Map.Rand(120, "") - 10* Map.GetCustomOption(10);
								local islHill = Map.Rand(100, "");

								--print("Rand: ", islRand, "Thresh: ", islThresh);

								if islRand > islThresh then
									self.plotTypes[plotIndex] = PlotTypes.PLOT_OCEAN
								else
									if islHill <= 30 then
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
			
				islCount = islCount - 1;
			else
				
				--print("---------");
				--print("Land In Ring: ", islLandInRing);
			end
		end
	end

	print("######### Finished Islands #########");
	return self.plotTypes;
end
-------------------------------------------------------------------------------
function GeneratePlotTypes()
	print("Generating Plot Types (Lua Archipelago) ...");


	local fractal_world = Archipelago.Create();
	local plotTypes = fractal_world:GeneratePlotTypes();
	
	SetPlotTypes(plotTypes);
	GenerateCoasts();
end
------------------------------------------------------------------------------
function GenerateTerrain()
	print("Generating Terrain (Lua Archipelago) ...");
	
	local DesertPercent = 22;

	-- Get Temperature setting input by user.
	local temp = Map.GetCustomOption(1)
	if temp == 4 then
		temp = 1 + Map.Rand(3, "Random Temperature - Lua");
	end

	local grassMoist = Map.GetCustomOption(5);

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

function FixIslands()
	--function to change some of the flat land tundra on islands to plains tiles
	local iW, iH = Map.GetGridSize();

	for y = 0, iH - 1 do
		for x = 0, iW - 1 do
			local i = iW * y + x;
			local plot = Map.GetPlotByIndex(i);
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
------------------------------------------------------------------------------
function AddFeatures()
	print("Adding Features (Lua Archipelago) ...");

	-- Get Rainfall setting input by user.
	local rain = Map.GetCustomOption(2)
	if rain == 4 then
		rain = 1 + Map.Rand(3, "Random Rainfall - Lua");
	end
	
	local args = {rainfall = rain}
	local featuregen = FeatureGenerator.Create(args);

	-- False parameter removes mountains from coastlines.
	featuregen:AddFeatures(false);
end
------------------------------------------------------------------------------
function StartPlotSystem()
	-- Get Resources setting input by user.
	local res = Map.GetCustomOption(9)
	local starts = Map.GetCustomOption(3)
	if starts == 7 then
		starts = 1 + Map.Rand(8, "Random Resources Option - Lua");
	end

	-- Handle coastal spawns and start bias
	local OnlyCoastal = true;
	local BalancedCoastal = true;
	local MixedBias = false;
	
	print("Creating start plot database.");
	local start_plot_database = AssignStartingPlots.Create()
	
	print("Dividing the map in to Regions.");
	-- Regional Division Method 4: Inside rectangle
	local iW, iH = Map.GetGridSize();
	local args = {
		method = 2,
		start_locations = starts,
		resources = res,
		NoCoastInland = OnlyCoastal,
		BalancedCoastal = BalancedCoastal,
		MixedBias = MixedBias;
		iWestX = 6;
		iSouthY = 6;
		iWidth = iW - 12;
		iHeight = iH - 12;
		};
	start_plot_database:GenerateRegions(args)

	print("Choosing start locations for civilizations.");
	start_plot_database:ChooseLocations()
	
	print("Normalizing start locations and assigning them to Players.");
	start_plot_database:BalanceAndAssign(args)

	print("Placing Natural Wonders.");
	local wonders = Map.GetCustomOption(4)
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
	
	start_plot_database:PlaceNaturalWonders(wonderargs)


	print("Placing Resources and City States.");
	start_plot_database:PlaceResourcesAndCityStates()
end
------------------------------------------------------------------------------
