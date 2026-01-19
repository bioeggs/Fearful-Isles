--[[

TeamModule
Script by: BioEggsHD (BallsHD)

Handles assigning players to the "Lobby", "Survivors" or "Killer" teams.

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

--// MODULE //--

local TeamModule = {}

TeamModule.AssignTeam = function(Players: {Player}, Team: Team)
	for _, Player in Players do
		Player.Team = Team
	end
end
script.Bindable.AssignTeam.Event:Connect(TeamModule.AssignTeam)

return TeamModule
