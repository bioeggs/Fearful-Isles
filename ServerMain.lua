--[[

ServerMain
Script by: BioEggsHD (BallsHD)

Main framework & event connection manager.

]]

--// VARIABLES & SERVICES //--

local Players = game:GetService("Players")
local ServerScriptService = game:GetService("ServerScriptService")
local Teams = game:GetService("Teams")

local Modules = ServerScriptService.Modules
local AdminModule = require(Modules.AdminModule)
local BadgeModule = require(Modules.BadgeModule)
local BanModule = require(Modules.BanModule)
local DataModule = require(Modules.DataModule)
local GamepassModule = require(Modules.GamepassModule)
local KillerModule = require(Modules.KillerModule)
local MessageModule = require(Modules.MessageModule)
local MapModule = require(Modules.MapModule)
local MorphModule = require(Modules.MorphModule)
local TeamModule = require(Modules.TeamModule)
local TimerModule = require(Modules.TimerModule)

--// FUNCTIONS //--

function PlayerAdded(Player: Player)
	print("Player Added: " .. Player.Name)
	
	AdminModule.CheckAdmin(Player)
	BanModule.CheckBanned(Player)
	DataModule.LoadData(Player)
	GamepassModule.CheckVIP(Player)
	BadgeModule.AwardMetOwner()
	
	wait(2)
	
	MorphModule.MorphPlayer(Player, "SunshineDoll")
end
function PlayerRemoving(Player: Player)
	print("Player Removing: " .. Player.Name)
	
	DataModule.SaveData(Player)
end

function GameLoop()
	local PlayerCount = #Players:GetPlayers()
	if PlayerCount >= 1 then -- change to > later
		TimerModule.StartTimer(15)
		local Map = MapModule.PickRandomMap()
		MessageModule.Broadcast("Map selected: " .. Map.Map.Name, 3)
		task.wait(4)
		
		local Killer = KillerModule.PickRandomKiller()
		MessageModule.Broadcast("Killer selected: " .. Killer.Name, 3)
		task.wait(6)
		
		local Survivors = {}
		for _, Player in Players:GetPlayers() do
			if Player ~= Killer then
				table.insert(Survivors, Player)
			end
		end
		TeamModule.AssignTeam({Killer}, Teams.Killer)
		TeamModule.AssignTeam(Survivors, Teams.Survivors)
		task.wait(6)
		
		TimerModule.StartTimer(15)
		MapModule.TeleportToMap(Survivors, Map)
		MessageModule.Broadcast("Hide from the killer!", 5)
		task.wait(16)
		
		TimerModule.StartTimer(180)
		MapModule.TeleportToMap({Killer}, Map)
		MessageModule.Broadcast("Survive.", 5)
	else
		MessageModule.Broadcast("Waiting for more players.", 6)
		TimerModule.StartTimer(15, function()
			GameLoop()
		end)
	end
end

--// EVENTS //--

Players.PlayerAdded:Connect(PlayerAdded)
Players.PlayerRemoving:Connect(PlayerRemoving)

--// MAIN //--

task.wait(2)
GameLoop()
