--[[

TeamModule
Script by: BioEggsHD (BallsHD)

Handles assigning players to the "Lobby", "Survivors" or "Killer" teams.

]]

--// VARIABLES & SERVICES //--

local Players = game:GetService("Players")

--// MODULE //--

local TeamModule = {}

TeamModule.AssignTeam = function(Players: {Player}, Team: Team)
	for _, Player in Players do
		Player.Team = Team
	end
end

TeamModule.GetTeamMemberCount = function(Team: Team)
	local count = 0
	for _, Player in Players:GetPlayers() do
		if Player.Team == Team then
			count += 1
		end
	end
	return count
end

return TeamModule
