-- Weapon Wrapper
-- DrewBokman
-- September 24, 2020



local WeaponWrapper = {Client = {}}
WeaponWrapper.Weapons = {} -- table for keeping track of weapons
WeaponWrapper.Players = {}

local defaultWeapons = {
	[1] = "Assault Rifle"
}

local Shared
local weapons = game.ReplicatedStorage:WaitForChild("Weapons")

function WeaponWrapper:Start()
	
end


function WeaponWrapper:Init()
    Shared = self.Shared
    game.Players.PlayerAdded:Connect(function(player)
        local values = {
            { name = "Gun"; value = nil; type = "ObjectValue" };
        }
        for _, v in pairs(values) do
            local value = Instance.new(v.type)
            value.Name = v.name
            value.Value = v.value
            value.Parent = player
        end
    end)
end

function WeaponWrapper.Client:New(player)
    if not player.Character then return end
    WeaponWrapper.Players[player.UserId] = {}
    local weaponTable = WeaponWrapper.Players[player.UserId]
    weaponTable.AmmoData = {}
    weaponTable.Weapons = {}
    for index, weaponName in pairs(defaultWeapons) do 
        local weapon = weapons[weaponName]:Clone()
        local weaponSettings = Shared.WeaponSettings[weaponName]
        weaponTable.Weapons[weaponName] = { Weapon = weapon; Settings = weaponSettings }
        weaponTable.AmmoData[index] = { Current = weaponSettings.ROUNDS_PER_MAG; spare = weaponSettings.TOTAL_ROUNDS  }
        weapon.Parent = player.Character
        weapon.Handle.BackWeld.Part1 = player.Character.Torso
    end
    return defaultWeapons, weaponTable.AmmoData
end

function WeaponWrapper.Client:Equip(player,wepName)
    if WeaponWrapper.Players[player.UserId].CurrentWeapon then return end
	if not WeaponWrapper.Players[player.UserId].Weapons[wepName] then return end
    if not player.Character then return end 
    
	local weaponTable = WeaponWrapper.Players[player.UserId]
	weaponTable.CurrentWeapon = weaponTable.Weapons[wepName] 
	player.Gun.Value = weaponTable.CurrentWeapon.Weapon
    weaponTable.CurrentWeapon.Parent = player.Character
    
	weaponTable.CurrentWeapon.Weapon.Handle.BackWeld.Part1 = nil
	weaponTable.CurrentWeapon.Weapon.Handle.HandWeld.Part1 = player.Character["Right Arm"]
	--weaponTable.loadedAnimations.idle = player.Character.Humanoid:LoadAnimation(weaponTable.currentWeapon.settings.animations.player.idle)
	--weaponTable.loadedAnimations.idle:Play()
	-- for i,v in pairs(weaponTable.CurrentWeapon.Weapon:GetChildren()) do
	-- 	if v:IsA("BasePart") then
	-- 		v.Transparency = 0
	-- 	end
	-- end
	return true 
end
function WeaponWrapper.Client:UnEquip(player)
    if not WeaponWrapper.Players[player.UserId].CurrentWeapon then return end
    if not player.Character then return end 
    
	local weaponTable = WeaponWrapper.Players[player.UserId]
    
	player.Gun.Value = weaponTable.CurrentWeapon.Weapon
    weaponTable.CurrentWeapon.Parent = player.Character
    

	weaponTable.CurrentWeapon.Weapon.Handle.BackWeld.Part1 = player.Character.Torso
	weaponTable.CurrentWeapon.Weapon.Handle.HandWeld.Part1 = nil
	--weaponTable.loadedAnimations.idle = player.Character.Humanoid:LoadAnimation(weaponTable.currentWeapon.settings.animations.player.idle)
	--weaponTable.loadedAnimations.idle:Play()
	-- for i,v in pairs(weaponTable.CurrentWeapon.Weapon:GetChildren()) do
	-- 	if v:IsA("BasePart") then
	-- 		v.Transparency = 0
	-- 	end
    -- end
    weaponTable.CurrentWeapon = nil
	player.Gun.Value = nil
	return true 
end

return WeaponWrapper