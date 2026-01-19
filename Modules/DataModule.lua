--[[

DataModule
Script by: BioEggsHD (BallsHD)

Handles data loading and saving through DataStores.
Also has functions for leaderstats loading or reading.

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

local DataStore = game:GetService("DataStoreService"):GetDataStore("DataStore")

local DefaultData = {
	Wins = 0,
	Kills = 0
}

--// MODULE //--

local DataModule = {}

DataModule.LoadData = function(Player: Player)
	local Name = Player.Name
	local Uid = Player.UserId
	local Data = DataStore:GetAsync(Uid) or DefaultData
	for stat, value in DefaultData do
		if not Data[stat] then
			Data[stat] = value
		end
	end
	local leaderstats = Instance.new("Folder", Player)
	leaderstats.Name = "leaderstats"
	for statName, value in Data do
		local ValueObject = Instance.new("NumberValue", leaderstats)
		ValueObject.Name = statName
		ValueObject.Value = value
	end
	local dataString = ""
	for stat, value in Data do
		dataString ..= stat .. ": " .. value .. ", "
	end
	dataString = dataString:sub(1, -3)
	print("Data for player \"" .. Name .. "\": " .. dataString)
end
script.Bindable.LoadData.Event:Connect(DataModule.LoadData)

DataModule.SaveData = function(Player: Player)
	local Uid = Player.UserId
	local Data = {}
	for _, value in Player.leaderstats:GetChildren() do
		Data[value.Name] = value.Value
	end
	if Data == nil then
		Data = DefaultData
	end
	DataStore:SetAsync(Uid, Data)
end
script.Bindable.SaveData.Event:Connect(DataModule.SaveData)

DataModule.WipeData = function(Player: Player)
	local Uid = Player.UserId
end
script.Bindable.WipeData.Event:Connect(DataModule.WipeData)

return DataModule
