--[[

BadgeModule
Script by: BioEggsHD (BallsHD)

Handles giving badges to players.

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
script.Bindable.AwardMetOwner.Event:Connect(BadgeModule.AwardMetOwner)

return BadgeModule
