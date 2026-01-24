--[[

DataModule
Script by: BioEggsHD (BallsHD)

Handles data loading and saving through DataStores.
Also has functions for leaderstats loading or reading.

]]

--// VARIABLES & SERVICES //--

local DataStore = game:GetService("DataStoreService"):GetDataStore("DataStore_V1")

local DefaultData = {
	Wins = 0,
	Kills = 0
}

local SESSION_TIMEOUT = 300
local SessionId = game.JobId

--// MODULE //--

local DataModule = {}

DataModule.LoadData = function(Player: Player)
	local Name = Player.Name
	local Uid = Player.UserId

	local Data = nil
	local Retry = 3

	while Retry > 0 do
		local ok, result = pcall(function()
			return DataStore:UpdateAsync(Uid, function(oldData)
				oldData = oldData or {}
				if oldData.__SessionId and oldData.__SessionId ~= SessionId then
					if os.time() - (oldData.__LastUpdate or 0) < SESSION_TIMEOUT then
						return nil
					end
				end
				oldData.__SessionId = SessionId
				oldData.__LastUpdate = os.time()

				for stat, value in pairs(DefaultData) do
					if oldData[stat] == nil then
						oldData[stat] = value
					end
				end
				Data = table.clone(oldData)
				return oldData
			end)
		end)

		if ok and Data then
			break
		else
			Retry -= 1
			task.wait(1)
		end
	end

	if not Data then
		Data = table.clone(DefaultData)
	end

	local leaderstats = Instance.new("Folder")
	leaderstats.Name = "leaderstats"
	leaderstats.Parent = Player

	for statName, value in pairs(Data) do
		if statName:sub(1, 2) ~= "__" then
			local ValueObject = Instance.new("NumberValue")
			ValueObject.Name = statName
			ValueObject.Value = value
			ValueObject.Parent = leaderstats
		end
	end

	local dataString = ""
	for stat, value in pairs(Data) do
		if stat:sub(1, 2) ~= "__" then
			dataString ..= stat .. ": " .. tostring(value) .. ", "
		end
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
	local Retry = 3

	while Retry > 0 do
		local ok = pcall(function()
			DataStore:UpdateAsync(Uid, function(oldData)
				oldData = oldData or {}
				if oldData.__SessionId ~= SessionId then
					return nil
				end

				for _, value in leaderstats:GetChildren() do
					if value:IsA("NumberValue") then
						oldData[value.Name] = value.Value
					end
				end

				oldData.__LastUpdate = os.time()
				return oldData
			end)
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
	local Retry = 3

	while Retry > 0 do
		local ok = pcall(function()
			DataStore:UpdateAsync(Uid, function(oldData)
				oldData = oldData or {}
				if oldData.__SessionId ~= SessionId then
					return nil
				end

				for stat, value in pairs(DefaultData) do
					oldData[stat] = value
				end
				oldData.__LastUpdate = os.time()
				return oldData
			end)
		end)
		if ok then
			break
		end
		Retry -= 1
		task.wait(1)
	end

	for _, value in ipairs(leaderstats:GetChildren()) do
		if value:IsA("NumberValue") and DefaultData[value.Name] ~= nil then
			value.Value = DefaultData[value.Name]
		end
	end
end

game:BindToClose(function()
    for _, player in Players:GetPlayers() do
        DataModule.SaveData(player)
    end
    task.wait(2)
end)

return DataModule
