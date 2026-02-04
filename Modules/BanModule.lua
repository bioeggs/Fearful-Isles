--[[

BanModule
Script by: BioEggsHD (BallsHD)

For every player that joins, checks if they are banned.
If yes, kick them instantly and give them the moderation message.
Also prints all past logs upon kicking (server-side).

]]

--// VARIABLES & SERVICES //--

local DataStoreService = game:GetService("DataStoreService")
local BansDataStore = DataStoreService:GetDataStore("BansDataStore")

local secondsToHoursFormatted = function(seconds: number)
	return string.format("%.1f", math.max(seconds, 0) / 3600)
end

--// MODULE //--

local BanModule = {}

BanModule.CheckBanned = function(Player: Player)
	local Name = Player.Name
	local Uid = tostring(Player.UserId)

	local ok, BannedInfo = pcall(function()
		return BansDataStore:GetAsync(Uid)
	end)

	if not ok then
		warn("Failed to read ban data for player \"" .. Name .. "\"")
		return
	end

	BannedInfo = BannedInfo or {
		IsBanned = false,
		BannedAt = 0,
		BannedUntil = 0,
		BanReason = "",
		BannedBy = "not banned",
		Logs = {}
	}

	if BannedInfo.IsBanned == true then
		if BannedInfo.BannedUntil < os.time() then
			BannedInfo.IsBanned = false
			BannedInfo.BannedAt = 0
			BannedInfo.BannedUntil = 0
			BannedInfo.BanReason = ""
			BannedInfo.BannedBy = "not banned"

			pcall(function()
				BansDataStore:SetAsync(Uid, BannedInfo)
			end)

			print("Player \"" .. Name .. "\" has served ban time, unbanning")
			return
		end

		print("Player \"" .. Name .. "\" is banned, kicking. Printing info")
		print(
			"Ban Info for Player \"" .. Name .. "\": " ..
			"Total Ban Duration: " .. secondsToHoursFormatted(BannedInfo.BannedUntil - BannedInfo.BannedAt) ..
			", Unbanned In: " .. secondsToHoursFormatted(BannedInfo.BannedUntil - os.time()) ..
			", Ban Reason: " .. BannedInfo.BanReason ..
			", Banned By: " .. BannedInfo.BannedBy ..
			". Printing Past Logs"
		)

		if typeof(BannedInfo.Logs) == "table" then
			for index, log in pairs(BannedInfo.Logs) do
				if typeof(log) == "table" then
					print(
						"[" .. index .. "]: " ..
						"Banned: " .. secondsToHoursFormatted(os.time() - (log.BannedAt or 0)) .. " hours ago, " ..
						"Total Ban Duration: " .. secondsToHoursFormatted((log.BannedUntil or 0) - (log.BannedAt or 0)) ..
						", Ban Reason: " .. tostring(log.BanReason) ..
						", Banned By: " .. tostring(log.BannedBy)
					)
				end
			end
		end

		Player:Kick(
			"You are banned for " ..
			secondsToHoursFormatted(BannedInfo.BannedUntil - os.time()) ..
			" hours for \"" ..
			BannedInfo.BanReason ..
			"\". Please rejoin after the ban duration has been served."
		)
	else
		print("Player \"" .. Name .. "\" is not banned")
	end
end

return BanModule
