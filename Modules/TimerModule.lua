--[[

TimerModule
Script by: BioEggsHD (BallsHD)

Handles starting timers.

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

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local TimeLeft = ReplicatedStorage.Timer

local running = false
local heartbeatConn: RBXScriptConnection?

--// MODULE //--

local TimerModule = {}

TimerModule.StartTimer = function(duration: number, callback: (any) -> (any)?)
	if running then
		return
	end

	running = true
	TimeLeft.Value = duration

	local lastUpdate = os.clock()

	heartbeatConn = RunService.Heartbeat:Connect(function()
		local now = os.clock()
		local dt = now - lastUpdate
		lastUpdate = now

		TimeLeft.Value = math.max(0, TimeLeft.Value - dt)

		if TimeLeft.Value <= 0 then
			heartbeatConn:Disconnect()
			heartbeatConn = nil
			running = false

			TimeLeft.Value = 0

			if callback then
				task.spawn(callback)
			end
		end
	end)
end
script.Bindable.StartTimer.Event:Connect(TimerModule.StartTimer)

return TimerModule
