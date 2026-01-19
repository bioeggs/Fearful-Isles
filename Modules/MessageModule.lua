--[[

MessageModule
Script by: BioEggsHD (BallsHD)

Handles messages as popups on the users screen.
Can be used for notifications or updates.

]]

--// PRINT OVERWRITE FOR LOGS //--

local __print = print
print = function(...)
	if game:GetService("ServerScriptService").Modules:GetAttribute("ModulesDebug") == true then
		__print("- " .. script.Name .. ": " .. ... .. ".")
	else
		return
	end
end

--// VARIABLES & SERVICES //--

local Players = game:GetService("Players")
local MessagingService = game:GetService("MessagingService")
local TweenService = game:GetService("TweenService")

local TweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)

--// MODULE //--

local MessageModule = {}

MessageModule.Broadcast = function(message: string, duration: number)
	for _, Player: Player in Players:GetPlayers() do
		MessageModule.ShowMessage(Player, message, duration)
	end
end
script.Bindable.Broadcast.Event:Connect(MessageModule.Broadcast)

MessageModule.ShowMessage = function(Player: Player, message: string, duration: number)
	local NewMessage = script.Message:Clone()
	NewMessage.Text = message
	NewMessage.Parent = Player:WaitForChild("PlayerGui"):WaitForChild("MessageUI"):WaitForChild("MessagesContainer")
	
	TweenService:Create(NewMessage, TweenInfo, {TextTransparency = 0}):Play()
	task.delay(duration, function()
		TweenService:Create(NewMessage, TweenInfo, {TextTransparency = 1}):Play()
		task.delay(0.3, function()
			NewMessage:Destroy()
		end)
	end)
end
script.Bindable.ShowMessage.Event:Connect(MessageModule.ShowMessage)

return MessageModule
