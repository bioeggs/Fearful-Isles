--[[

KillerModule
Script by: BioEggsHD (BallsHD)

Handles killer selection.

]]

--// PRINT OVERWRITE FOR LOGS //--

local __print = print
print = function(...)
	if game:GetService("ServerScriptService"):GetAttribute("DoDebug") == true then
		__print(script.Name .. ": " .. ... .. ".")
	else
		return
	end
end

--// VARIABLES & SERVICES //--

local Players = game:GetService("Players")

--// MODULE //--

local KillerModule = {}

KillerModule.PickRandomKiller = function()
	return Players:GetPlayers()[math.random(1, #Players:GetPlayers())]
end
script.Bindable.PickRandomKiller.OnInvoke = KillerModule.PickRandomKiller

return KillerModule
