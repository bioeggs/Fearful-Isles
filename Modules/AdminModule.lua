--[[

AdminModule
Script by: BioEggsHD (BallsHD)

For every player that joins, checks if they are in this admin whitelist.
If yes, give them admin permissions and a UI.

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

--// MODULE //--

local Whitelist = {
	"Aqwertz333",
	"MazinGotNewUser",
	"lolololololgamer593",
	"Not_RealDarkDreamer"
}

local AdminModule = {}

AdminModule.CheckAdmin = function(Player: Player)
	local Name = Player.Name
	if table.find(Whitelist, Name) then
		print("Player \"" .. Name .. "\" is admin, adding AdminUI")
		script.AdminUI:Clone().Parent = Player.PlayerGui
		Player:SetAttribute("Admin", true)
	else
		print("Player \"" .. Name .. "\" is not admin")
		Player:SetAttribute("Admin", false)
	end
end
script.Bindable.CheckAdmin.Event:Connect(AdminModule.CheckAdmin)

AdminModule.GetAdminNames = function()
	return Whitelist
end
script.Bindable.GetAdminNames.OnInvoke = AdminModule.GetAdminNames

return AdminModule
