--[[

MorphModule
Script by: BioEggsHD (BallsHD)

Handles morphing for players.

]]

--// VARIABLES & SERVICES //--

local Morphs = script.Morphs

--// MODULE //--

local MorphModule = {}

MorphModule.MorphPlayer = function(Player: Player, MorphName: string)
	local MorphTemplate = Morphs[MorphName]
	if not MorphTemplate then
		print("ERROR: No morph \"" .. MorphName .. "\"")
	end
	
	local Character = Player.Character or Player.CharacterAdded:Wait()
	local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
	local OldCFrame = HumanoidRootPart.CFrame
	
	local Morph = MorphTemplate:Clone()
	Morph.Name = Player.Name
	Morph.Parent = workspace
	
	local MorphHRP = Morph:FindFirstChild("HumanoidRootPart")
	if not MorphHRP then
		print("ERROR: Morph has no HumanoidRootPart")
		Morph:Destroy()
		return
	end
	MorphHRP.CFrame = OldCFrame
	
	Player.Character = Morph
	Character:Destroy()
end

return MorphModule
