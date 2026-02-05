--[[

MapModule
Script by: BioEggsHD (BallsHD)

Handles map selection and teleportation.

]]


--// VARIABLES & SERVICES //--

local MapFolder = workspace.Maps
local Maps = {
	["DustFell Ruins"] = {
		Map = MapFolder["DustFell Ruins"]
	},
	TestMap2 = {
		Map = MapFolder.TestMap2
	},
	TestMap3 = {
		Map = MapFolder.TestMap3
	},
	TestMap4 = {
		Map = MapFolder.TestMap4
	}
}

--// FUNCTIONS //--

local function ShuffleTable(originalTable: {}): {}
	local shuffled = table.clone(originalTable)

	for i = #shuffled, 2, -1 do
		local j = math.random(1, i)
		shuffled[i], shuffled[j] = shuffled[j], shuffled[i]
	end

	return shuffled
end

--// MODULE //--

local MapModule = {}

MapModule.PickRandomMap = function()
	local MapTable = {}
	for name, data in Maps do
		table.insert(MapTable, data)
	end
	return MapTable[math.random(1, #MapTable)]
end

MapModule.PickRandomMaps = function(amount: number)
	local MapTable, PickedMaps = {}, {}
	for name, data in Maps do
		table.insert(MapTable, data)
	end
	for i = 1, amount do
		local RandomNum = math.random(1, #MapTable)
		table.insert(PickedMaps, MapTable[RandomNum])
		table.remove(MapTable, RandomNum)
	end
	return PickedMaps
end

MapModule.TeleportToMap = function(Players: {Player}, map: Model)
	local SpawnLocations = map.Map:WaitForChild("SpawnLocations"):GetChildren()
	local spawnIndex = 0
	Players = ShuffleTable(Players)
	
	for _, player: Player in Players do
		spawnIndex += 1
		if spawnIndex > #SpawnLocations then
			spawnIndex = 1
		end
		local Character = player.Character or player.CharacterAdded:Wait()
		Character:PivotTo(SpawnLocations[spawnIndex].CFrame)
	end
end

MapModule.TeleportToLobby = function(Players: {Player})
	for _, Player in Players do
		local Character = Player.Character or Player.CharacterAdded:Wait()
		Character:PivotTo(workspace.Lobby.SpawnLocation.CFrame + Vector3.yAxis)
	end
end

MapModule.PlayAmbience = function(Map: Model)
	local Ambience = Map:FindFirstChildOfClass("Sound")
	if Ambience and Ambience.Name == "Ambience" and not Ambience.IsPlaying then
		Ambience:Play()
	end
end

MapModule.StopAmbience = function(Map: Model)
	local Ambience = Map:FindFirstChildOfClass("Sound")
	if Ambience and Ambience.Name == "Ambience" and Ambience.IsPlaying then
		Ambience:Stop()
	end
end

return MapModule
