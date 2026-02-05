--[[

TimerModule
Script by: BioEggsHD (BallsHD)

Handles starting timers.

]]

--// VARIABLES & SERVICES //--

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local TimeLeft = ReplicatedStorage.Timer

local running = false
local heartbeatConn: RBXScriptConnection?

--// MODULE //--

local TimerModule = {}

TimerModule.StartTimer = function(duration: number, callback: (any) -> (any)?)
	if heartbeatConn then
		heartbeatConn:Disconnect()
		heartbeatConn = nil
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
			if heartbeatConn then
				heartbeatConn:Disconnect()
				heartbeatConn = nil
			end
			running = false
			TimeLeft.Value = 0

			if callback then
				task.spawn(callback)
			end
		end
	end)
end

return TimerModule
