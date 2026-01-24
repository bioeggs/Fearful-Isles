--[[

DataModule
Script by: BioEggsHD (BallsHD)

Handles data loading and saving through DataStores.
Also has functions for leaderstats loading or reading.

]]

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

	local Data = nil
	local Retry = 3

	while Retry > 0 do
		local ok, result = pcall(function()
			return DataStore:GetAsync(Uid)
		end)
		if ok then
			Data = result
			break
		else
			Retry -= 1
			task.wait(1)
		end
	end

	if not Data then
		Data = table.clone(DefaultData)
	end

	for stat, value in pairs(DefaultData) do
		if Data[stat] == nil then
			Data[stat] = value
		end
	end

	local leaderstats = Instance.new("Folder")
	leaderstats.Name = "leaderstats"
	leaderstats.Parent = Player

	for statName, value in pairs(Data) do
		local ValueObject = Instance.new("NumberValue")
		ValueObject.Name = statName
		ValueObject.Value = value
		ValueObject.Parent = leaderstats
	end

	local dataString = ""
	for stat, value in pairs(Data) do
		dataString ..= stat .. ": " .. tostring(value) .. ", "
	end

	if #dataString > 2 then
		dataString = dataString:sub(1, -3)
	end

	print("Data for player \"" .. Name .. "\": " .. dataString)
end

DataModule.SaveData = function(Player: Player)
	local leaderstats = Player:FindFirstChild("leaderstats")
	if not leaderstats then return end

	local Uid = Player.UserId
	local Data = {}
	for _, value in leaderstats:GetChildren() do
		if value:IsA("NumberValue") then
			Data[value.Name] = value.Value
		end
	end

	local Retry = 3
	while Retry > 0 do
		local ok, err = pcall(function()
			DataStore:SetAsync(Uid, Data)
		end)
		if ok then
			break
		end
		Retry -= 1
		task.wait(1)
	end
end

DataModule.WipeData = function(Player: Player)
	local leaderstats = Player:FindFirstChild("leaderstats")
	if not leaderstats then return end

	local Uid = Player.UserId
	local Data = table.clone(DefaultData)
	for _, value in ipairs(leaderstats:GetChildren()) do
		if value:IsA("NumberValue") and Data[value.Name] ~= nil then
			value.Value = Data[value.Name]
		end
	end

	local Retry = 3
	while Retry > 0 do
		local ok = pcall(function()
			DataStore:SetAsync(Uid, Data)
		end)
		if ok then
			break
		end
		Retry -= 1
		task.wait(1)
	end
end

return DataModule
