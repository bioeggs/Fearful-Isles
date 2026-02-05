--[[

KillerModule
Script by: BioEggsHD (BallsHD)

Handles killer selection.

]]

--// VARIABLES & SERVICES //--

local Players = game:GetService("Players")

--// MODULE //--

local KillerModule = {}

KillerModule.PickRandomKiller = function(excludedPlayers: {number})
	local AllPlayers = Players:GetPlayers()
	local SelectedPlayer: Player = nil
	while task.wait() do
		local PlayerCount = #AllPlayers
		if PlayerCount < 1 then return false end
		
		SelectedPlayer = AllPlayers[math.random(1, PlayerCount)]
		if not table.find(excludedPlayers, SelectedPlayer.UserId) then
			return true, SelectedPlayer
		end
	end
end

return KillerModule
