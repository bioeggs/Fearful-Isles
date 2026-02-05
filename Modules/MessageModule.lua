--[[

MessageModule
Script by: BioEggsHD (BallsHD)

Handles messages as popups on the users screen.

]]

--// VARIABLES & SERVICES //--

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local TweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)

--// FUNCTIONS //--

local function createMessage(Player: Player, message: string)
	local PlayerGui = Player:FindFirstChild("PlayerGui")
	if not PlayerGui then return nil end

	local UI = PlayerGui:FindFirstChild("MessageUI")
	if not UI then return nil end

	local NewMessage = script.Message:Clone()
	NewMessage.Text = message
	NewMessage.Parent = UI:FindFirstChild("MessagesContainer")

	return NewMessage
end

local function hideMessage(message: TextLabel)
	if not message then return end
	local tween = TweenService:Create(message, TweenInfo, {TextTransparency = 1})
	tween:Play()
	tween.Completed:Connect(function()
		message:Destroy()
	end)
end

--// MODULE //--

local MessageModule = {}

MessageModule.Broadcast = function(message: string, duration: number)
	for _, Player: Player in Players:GetPlayers() do
		MessageModule.ShowMessage(Player, message, duration)
	end
end

MessageModule.ShowMessage = function(Player: Player, message: string, duration: number)
	local NewMessage = createMessage(Player, message)
	if NewMessage then
		TweenService:Create(NewMessage, TweenInfo, {TextTransparency = 0}):Play()

		task.delay(duration, function()
			hideMessage(NewMessage)
		end)
	end
end

return MessageModule
