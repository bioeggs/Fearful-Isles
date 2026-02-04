--[[

AdminModule
Script by: BioEggsHD (BallsHD)

For every player that joins, checks if they are in this admin whitelist.
If yes, give them admin permissions and a UI.

]]

--// MODULE //--

local Whitelist = {
	[1210462714] = true, -- Balls
	[3409824679] = true, -- Balls alt
	[2645344530] = true, -- Mazin
	[1827342603] = true, -- Dusty
	[2862614403] = true, -- Placeholder
}

local AdminModule = {}

AdminModule.CheckAdmin = function(Player: Player)
	local Name = Player.Name
	local Uid = Player.UserId
	if Whitelist[Uid] == true then
		print("Player \"" .. Name .. "\" is admin, adding AdminUI")
		script.AdminUI:Clone().Parent = Player.PlayerGui
		Player:SetAttribute("Admin", true)
	else
		print("Player \"" .. Name .. "\" is not admin")
		Player:SetAttribute("Admin", false)
	end
end

AdminModule.GetAdminNames = function()
	return Whitelist
end

return AdminModule
