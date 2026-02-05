--[[

BadgeModule
Script by: BioEggsHD (BallsHD)

Handles giving badges to players.

]]

--// VARIABLES & SERVICES //--

local Players = game:GetService("Players")
local ServerScriptService = game:GetService("ServerScriptService")
local BadgeService = game:GetService("BadgeService")

local AdminModule = require(ServerScriptService.Modules.AdminModule)

local MetOwnerID = 4123542304286657

--// MODULE //--

local BadgeModule = {}

BadgeModule.AwardMetOwner = function()
	local Admins = AdminModule.GetAdminNames()
	local OwnerInGame = false
	for _, Player in Players:GetPlayers() do
		if table.find(Admins, Player.Name) then
			OwnerInGame = true
			break
		end
	end
	if OwnerInGame then
		for _, Player in Players:GetPlayers() do
			if not BadgeService:UserHasBadgeAsync(Player.UserId, MetOwnerID) then
				BadgeService:AwardBadgeAsync(Player.UserId, MetOwnerID)
			end
		end
	end
end

return BadgeModule
