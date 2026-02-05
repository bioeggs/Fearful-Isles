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
	local MorphTemplate = Morphs:FindFirstChild(MorphName)
	if not MorphTemplate then
		warn("ERROR: No morph \"" .. MorphName .. "\"")
		return
	end
	
	local Character = Player.Character or Player.CharacterAdded:Wait()
	local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
	local OldCFrame = HumanoidRootPart.CFrame
	
	-- Store original character for morph-back
	Character.Parent = nil
	
	local Morph = MorphTemplate:Clone()
	Morph.Name = Player.Name
	Morph.Parent = workspace
	
	local MorphHRP = Morph:FindFirstChild("HumanoidRootPart")
	if not MorphHRP then
		warn("ERROR: Morph has no HumanoidRootPart")
		Morph:Destroy()
		Character.Parent = workspace
		return
	end
	
	MorphHRP.CFrame = OldCFrame
	
	Player.Character = Morph
end

MorphModule.MorphBack = function(Player: Player, OldCharacter: Model, OldMorph: Model)
	if not OldCharacter then 
		warn("ERROR: No OldCharacter")
		return
	end
	if not OldMorph then 
		warn("ERROR: No OldMorph")
		return
	end
	
	if not OldMorph.Parent then
		warn("ERROR: OldMorph no longer exists")
		return
	end
	
	local MorphHRP = OldMorph:FindFirstChild("HumanoidRootPart")
	if not MorphHRP then
		warn("ERROR: Morph has no HumanoidRootPart")
		return
	end
	
	local OldCFrame = MorphHRP.CFrame
	
	OldCharacter.Parent = workspace
	
	local CharacterHRP = OldCharacter:FindFirstChild("HumanoidRootPart")
	if not CharacterHRP then
		warn("ERROR: Character has no HumanoidRootPart")
		OldCharacter:Destroy()
		return
	end
	
	CharacterHRP.CFrame = OldCFrame
	
	Player.Character = OldCharacter
	OldMorph:Destroy()
end

return MorphModule
