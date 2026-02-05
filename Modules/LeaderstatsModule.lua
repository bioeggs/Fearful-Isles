--[[

LeaderstatsModule
Script By: BioEggsHD

Mirrors server stats into leaderstats with strict control.

]]

--// VARIABLES & SERVICES //--

local Players = game:GetService("Players")

local STAT_SCHEMA = {
	Wins = "number",
	Kills = "number",
}

--// MODULE //--

local LeaderstatsModule = {}

LeaderstatsModule.PlayerStats = {}

--// FUNCTIONS //--

local function createLeaderstats(player: Player, stats: {})
	if player:FindFirstChild("leaderstats") then
		return
	end

	local folder = Instance.new("Folder")
	folder.Name = "leaderstats"
	folder.Parent = player

	for statName, statType in pairs(STAT_SCHEMA) do
		local value = stats[statName]
		if value == nil then
			continue
		end

		local obj
		if statType == "number" then
			obj = Instance.new("NumberValue")
		elseif statType == "string" then
			obj = Instance.new("StringValue")
		end

		obj.Name = statName
		obj.Value = value
		obj.Parent = folder
	end
end

local function updateLeaderstat(player: Player, statName: string, value: number | string)
	local leaderstats = player:FindFirstChild("leaderstats")
	if not leaderstats then
		return
	end

	local stat = leaderstats:FindFirstChild(statName)
	if stat then
		stat.Value = value
	end
end

local function validateStat(statName: string, value: any): boolean
	local expectedType = STAT_SCHEMA[statName]
	if not expectedType then
		return false
	end

	return typeof(value) == expectedType
end

function LeaderstatsModule.InitPlayer(player: Player, initialStats: {})
	local uid = player.UserId

	local stats = {}

	for statName, statType in pairs(STAT_SCHEMA) do
		local value = initialStats[statName]
		if value ~= nil and typeof(value) == statType then
			stats[statName] = value
		end
	end

	LeaderstatsModule.PlayerStats[uid] = stats
	createLeaderstats(player, stats)
end

function LeaderstatsModule.SetStat(player: Player, statName: string, value: number | string)
	local uid = player.UserId
	local stats = LeaderstatsModule.PlayerStats[uid]
	if not stats then
		return
	end

	if not validateStat(statName, value) then
		warn(
			string.format(
				"[LeaderstatsModule] Invalid stat write: %s = %s",
				statName,
				tostring(value)
			)
		)
		return
	end

	stats[statName] = value
	updateLeaderstat(player, statName, value)
end

function LeaderstatsModule.AddStat(player: Player, statName: string, amount: number)
	local uid = player.UserId
	local stats = LeaderstatsModule.PlayerStats[uid]
	if not stats then
		return
	end

	if STAT_SCHEMA[statName] ~= "number" then
		return
	end

	local newValue = (stats[statName] or 0) + amount
	stats[statName] = newValue
	updateLeaderstat(player, statName, newValue)
end

function LeaderstatsModule.GetStat(player: Player, statName: string)
	local stats = LeaderstatsModule.PlayerStats[player.UserId]
	if not stats then
		return nil
	end

	return stats[statName]
end

function LeaderstatsModule.RemovePlayer(player: Player)
	LeaderstatsModule.PlayerStats[player.UserId] = nil
end

return LeaderstatsModule
