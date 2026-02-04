--[[

Chat
Script by: BioEggsHD (BallsHD)

Handles chat coloring for different teams.
Also adds chat tags for admins or VIP players.

]]

--// VARIABLES & SERVICES //--

local Players = game:GetService("Players")
local TextChatService = game:GetService("TextChatService")

--// FUNCTIONS //--

local function colorToHex(color: Color3)
	return string.format("#%02X%02X%02X",
		math.floor(color.R * 255),
		math.floor(color.G * 255),
		math.floor(color.B * 255)
	)
end

--// MAIN //--

TextChatService.OnIncomingMessage = function(message)
	local properties = Instance.new("TextChatMessageProperties")

	if not message.TextSource then
		return properties
	end

	local player = Players:GetPlayerByUserId(message.TextSource.UserId)
	if not player then
		return properties
	end

	local teamColor = Color3.new(1, 1, 1)
	if player.Team then
		teamColor = player.Team.TeamColor.Color
	end
	local teamHex = colorToHex(teamColor)

	local isVIP = player:GetAttribute("VIP") == true
	local isAdmin = player:GetAttribute("Admin") == true

	local tagText = ""
	local messageColor = "#FFFFFF"

	if isAdmin then
		tagText = "<font color='#7ED6FF'>[ADMIN]</font> "
		messageColor = "#2E86DE"
	elseif isVIP then
		tagText = "<font color='#F5CD30'>[VIP]</font> "
		messageColor = "#FF8C00"
	end

	properties.PrefixText =
		tagText ..
		string.format(
			"<font color='%s'>%s</font>:",
			teamHex,
			player.DisplayName
		)

	properties.Text = string.format(
		"<font color='%s'>%s</font>",
		messageColor,
		message.Text
	)

	return properties
end
