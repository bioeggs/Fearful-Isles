--[[

MapModule
Script by: BioEggsHD (BallsHD)

Handles map selection and teleportation.

]]

--// PRINT OVERWRITE FOR LOGS //--

local __print = print
print = function(...)
	if game:GetService("ServerScriptService").Modules:GetAttribute("ModulesDebug") == true then
		__print("- " .. script.Name .. ": " .. ... .. ".")
	else
		return
	end
end

--// VARIABLES & SERVICES //--

local MapFolder = workspace.Maps
local Maps = {
	TestMap1 = {
		Map = MapFolder.TestMap1
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
script.Bindable.PickRandomMap.OnInvoke = MapModule.PickRandomMap

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
script.Bindable.PickRandomMaps.OnInvoke = MapModule.PickRandomMaps

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
script.Bindable.TeleportToMap.Event:Connect(MapModule.TeleportToMap)

return MapModule
