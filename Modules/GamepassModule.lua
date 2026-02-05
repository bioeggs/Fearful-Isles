--[[

GamepassModule
Script by: BioEggsHD (BallsHD)

Handles gamepasses for players.

]]

--// VARIABLES & SERVICES //--

local MarketplaceService = game:GetService("MarketplaceService")

local VIP_ID = 1674321920

--// MODULE //--

local GamepassModule = {}

GamepassModule.CheckVIP = function(Player: Player)
	local Name = Player.Name
	if MarketplaceService:UserOwnsGamePassAsync(Player.UserId, VIP_ID) or Player:GetAttribute("Admin") == true then
		print("Player \"" .. Name .. "\" is VIP")
		Player:SetAttribute("VIP", true)
	else
		print("Player \"" .. Name .. "\" is not VIP")
		Player:SetAttribute("VIP", false)
	end
end

return GamepassModule
