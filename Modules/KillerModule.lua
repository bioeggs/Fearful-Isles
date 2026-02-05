--[[

KillerModule
Script by: BioEggsHD (BallsHD)

Handles killer selection.

]]

--// VARIABLES & SERVICES //--

local Players = game:GetService("Players")

--// MODULE //--

local KillerModule = {}

KillerModule.PickRandomKiller = function()
	return Players:GetPlayers()[math.random(1, #Players:GetPlayers())]
end

return KillerModule
