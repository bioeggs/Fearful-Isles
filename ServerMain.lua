--[[

ServerMain
Script by: BioEggsHD (BallsHD)

Main framework & event connection manager.

]]

--// VARIABLES & SERVICES //--

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local Teams = game:GetService("Teams")

local AdminModule = require(script.AdminModule)
local BadgeModule = require(script.BadgeModule)
local BanModule = require(script.BanModule)
local DataModule = require(script.DataModule)
local GamepassModule = require(script.GamepassModule)
local KillerModule = require(script.KillerModule)
local LeaderstatsModule = require(script.LeaderstatsModule)
local MessageModule = require(script.MessageModule)
local MapModule = require(script.MapModule)
local MorphModule = require(script.MorphModule)
local TeamModule = require(script.TeamModule)
local TimerModule = require(script.TimerModule)

--// FUNCTIONS //--

local function PlayerAdded(Player: Player)
	print("Player Added: " .. Player.Name)

	AdminModule.CheckAdmin(Player)
	BanModule.CheckBanned(Player)
	local Data = DataModule.LoadData(Player)
	LeaderstatsModule.InitPlayer(Player, Data)
	GamepassModule.CheckVIP(Player)
	BadgeModule.AwardMetOwner()
end

local function PlayerRemoving(Player: Player)
	print("Player Removing: " .. Player.Name)

	DataModule.SaveData(Player)
	
	LeaderstatsModule.RemovePlayer(Player)
end

local function GameLoop()
	local LastKiller: number = nil
	while true do 
		MessageModule.Broadcast("Intermission", 14)
		TimerModule.StartTimer(15)
		task.wait(15)

		local AllPlayers = Players:GetPlayers()
		local PlayerCount = #AllPlayers

		if PlayerCount >= 2 then 
			TimerModule.StartTimer(10)
			
			local Map = MapModule.PickRandomMap()
			MessageModule.Broadcast("Map selected: " .. Map.Map.Name, 4)
			task.wait(4)

			local ExcludedForKiller = {} -- add logic later for turning killer off in settings
			if LastKiller ~= nil then
				table.insert(ExcludedForKiller, LastKiller)
			end

			local Killer = KillerModule.PickRandomKiller(ExcludedForKiller)

			if not Killer or not Killer.Parent then
				MessageModule.Broadcast("Killer left during selection. Restarting.", 3)
				task.wait(3)
				continue
			end

			MessageModule.Broadcast("Killer selected: " .. Killer.Name, 4)
			LastKiller = Killer.UserId
			task.wait(4)

			local Survivors = {}
			for _, Player in ipairs(Players:GetPlayers()) do
				if Player ~= Killer then
					table.insert(Survivors, Player)
				end
			end

			if #Survivors == 0 then
				MessageModule.Broadcast("Not enough survivors. Restarting.", 3)
				task.wait(3)
				continue
			end

			TeamModule.AssignTeam({Killer}, Teams.Killer)
			TeamModule.AssignTeam(Survivors, Teams.Survivors)

			MessageModule.Broadcast("Starting round.", 3)
			task.wait(3)

			MapModule.TeleportToMap(Survivors, Map)
			MessageModule.Broadcast("Hide from the killer!", 15)
			TimerModule.StartTimer(15)
			task.wait(15)

			if Killer and Killer.Parent then
				MapModule.TeleportToMap({Killer}, Map)
				MapModule.PlayAmbience(Map)
				MessageModule.Broadcast("Survive.", 5)
			end

			local RoundTime = 120
			TimerModule.StartTimer(RoundTime)

			local RoundActive = true
			local StartTime = os.clock()

			while RoundActive do
				task.wait(1)

				local survivorCount = TeamModule.GetTeamMemberCount(Teams.Survivors)
				local killerStillIn = (Killer.Parent == Players) 
				local timeElapsed = os.clock() - StartTime

				if survivorCount < 1 then
					MessageModule.Broadcast("Killer Wins!", 5)
					RoundActive = false
				elseif not killerStillIn then
					MessageModule.Broadcast("Killer left! Survivors Win!", 5)
					RoundActive = false
				elseif timeElapsed >= RoundTime then
					MessageModule.Broadcast("Time Up! Survivors Win!", 5)
					RoundActive = false
				end
			end

			MapModule.StopAmbience(Map)
			TeamModule.AssignTeam(Players:GetPlayers(), Teams.Lobby)
			MapModule.TeleportToLobby(Players:GetPlayers())
			task.wait(3)
		else
			MessageModule.Broadcast("Waiting for more players (2 required).", 5)
			TimerModule.StartTimer(10)
			task.wait(10)
		end
	end
end

--// EVENTS //--

Players.PlayerAdded:Connect(PlayerAdded)
Players.PlayerRemoving:Connect(PlayerRemoving)

--// MAIN //--

task.wait(2)
task.spawn(GameLoop)
