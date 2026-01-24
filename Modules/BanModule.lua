--[[

BanModule
Script by: BioEggsHD (BallsHD)

For every player that joins, checks if they are banned.
If yes, kick them instantly and give them the moderation message.
Also prints all past logs upon kicking.

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

local BansDataStore = game:GetService("DataStoreService"):GetDataStore("BansDataStore")

secondsToHours = function(Seconds: number)
	return math.round(Seconds / 360) * 10
end

--// MODULE //--

local BanModule = {}

BanModule.CheckBanned = function(Player: Player)
	local Name = Player.Name
	local Uid = Player.UserId
	local BannedInfo = BansDataStore:GetAsync(Uid) or {IsBanned = false, BannedAt = 0, BannedUntil = 0, BanReason = "", BannedBy = "not banned", Logs = {}}
	if BannedInfo.IsBanned == true then
		if BannedInfo.BannedUntil < os.time() then
			print("Player \"" .. Name .. "\" has served ban time, unbanning")
			local NewInfo = BannedInfo
			NewInfo.IsBanned = false
			NewInfo.BannedAt = 0
			NewInfo.BannedUntil = 0
			NewInfo.BanReason = ""
			NewInfo.BannedBy = "not banned"
			BansDataStore:SetAsync(Uid, NewInfo)
			return
		end
		print("Player \"" .. Name .. "\" is banned, kicking. Printing info")
		print("Ban Info for Player \"" .. Name .. "\": Total Ban Duration: " .. secondsToHours(BannedInfo.BannedUntil - BannedInfo.BannedAt) .. ", Unbanned In: " .. secondsToHours(BannedInfo.BannedUntil - os.time()) .. ", Ban Reason: " .. BannedInfo.BanReason .. ", Banned By: " .. BannedInfo.BannedBy .. ". Printing Past Logs")
		for index, log in pairs(BannedInfo.Logs) do
			print("[" .. index .. "]: Banned: " .. secondsToHours(os.time() - log.BannedAt) .. " hours ago, Total Ban Duration: " .. secondsToHours(BannedInfo.BannedUntil - BannedInfo.BannedAt) .. ", Ban Reason: " .. BannedInfo.BanReason .. ", Banned By: " .. BannedInfo.BannedBy)
		end
		Player:Kick("You are banned for " .. secondsToHours(BannedInfo.BannedUntil - os.time()) .. " hours for \"" .. BannedInfo.BanReason .. "\". Please rejoin after the ban duration has been served. Join the discord to appeal.")
	else
		print("Player \"" .. Name .. "\" is not banned")
	end
end

return BanModule
