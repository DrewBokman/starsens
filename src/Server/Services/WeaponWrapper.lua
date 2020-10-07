-- Weapon Wrapper
-- DrewBokman
-- September 24, 2020



local WeaponWrapper = {Client = {}}
WeaponWrapper.Weapons = {} -- table for keeping track of weapons
WeaponWrapper.Players = {}

local defaultWeapons = {
	[1] = "Assault Rifle" ,
	--[2] = "Goldilocks" ,
	[2] = "LightningInABottle" 
}


local Shared
local weapons = game.ReplicatedStorage:WaitForChild("Weapons")

local weaponClass
local AeroServer

local FireAllClientsFunc

function wait(TimeToWait)
	local startTS = tick()
	local val = "Stepped"
	if game:GetService("RunService"):IsServer() then
		val = "Heartbeat"
	end
	if TimeToWait ~= nil then
		local TotalTime = 0
		TotalTime = TotalTime + game:GetService("RunService")[val]:wait()
		while TotalTime < TimeToWait do
			TotalTime = TotalTime + game:GetService("RunService")[val]:wait()
		end
	else
		game:GetService("RunService")[val]:wait()
	end
	return tick() - startTS
end

function WeaponWrapper:Start()
    weaponClass = self.Modules.WeaponClass
    Shared = self.Shared
	AeroServer = self
	FireAllClientsFunc = function(...)
		self:FireAllClients(...)
	end
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


function WeaponWrapper:Init()
    self:RegisterClientEvent("ReplicateFire")
    self:RegisterClientEvent("ReplicateAmmo")
end

function WeaponWrapper:New(player)

    print(weaponClass)
    if not player.Character then return end
    WeaponWrapper.Players[player.UserId] = {}
    local weaponTable = WeaponWrapper.Players[player.UserId]
    weaponTable.AmmoData = {}
    weaponTable.Weapons = {}
    for index, weaponName in pairs(defaultWeapons) do 
        local weapon = weapons[weaponName]:Clone()
        local weaponSettings = Shared.WeaponSettings[weaponName]
        local WeaponClass = weaponClass.new(player,weaponSettings,weaponName,weapon)
        weaponTable.Weapons[weaponName] = { Weapon = weapon; Settings = weaponSettings; WeaponClass = WeaponClass; CanFire = true}
        weaponTable.AmmoData[weaponName] = { Current = weaponSettings.ROUNDS_PER_MAG; Spare = weaponSettings.TOTAL_ROUNDS  }
        weapon.Parent = player.Character
        weapon.Handle.BackWeld.Part1 = player.Character.Torso
    end
    return {defaultWeapons, weaponTable.AmmoData}
end

function WeaponWrapper:Equip(player,wepName)
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
function WeaponWrapper:UnEquip(player)
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

function WeaponWrapper.Client:Fire(player,Direction,Aiming,Crouching)
    local weaponTable = WeaponWrapper.Players[player.UserId]
    if not WeaponWrapper.Players[player.UserId].CurrentWeapon then return end
    if not player.Character then return end
    if not WeaponWrapper.Players[player.UserId].CurrentWeapon.CanFire then return end
    local Weapon = WeaponWrapper.Players[player.UserId].CurrentWeapon
    local CurrentAmmo = WeaponWrapper.Players[player.UserId].CurrentWeapon.WeaponClass.Rounds
    if CurrentAmmo <=0 then return weaponTable.AmmoData end
    print(CurrentAmmo)
    Weapon.CanFire = false
    delay(60/WeaponWrapper.Players[player.UserId].CurrentWeapon.Settings.RPM,function()
        Weapon.CanFire = true
	end)
    local GunFirePoint, direction, modifiedBulletSpeed, bullet, Ignore, bool, BULLET_GRAVITY, clientThatFired, WeaponName = weaponTable.CurrentWeapon.WeaponClass:Fire(Direction,player,Aiming,Crouching)
    -- print(GunFirePoint, direction, modifiedBulletSpeed, bullet, Ignore, bool, BULLET_GRAVITY, clientThatFired, WeaponName)
    --AeroServer:FireAllClients("ReplicateFire",FirePointObject,Direction,Bullet,Bool,Ignore,BulletSpeed,ClientThatFired,WeaponName)
    FireAllClientsFunc("ReplicateFire",GunFirePoint, direction, modifiedBulletSpeed, bullet, Ignore, bool, BULLET_GRAVITY, clientThatFired, WeaponName, Aiming, Crouching)
    return weaponTable.AmmoData
end
function WeaponWrapper:Reload(player)
    local weaponTable = WeaponWrapper.Players[player.UserId]
    if not WeaponWrapper.Players[player.UserId].CurrentWeapon then return end
    if not player.Character then return end
    --weaponTable.
    return weaponTable.CurrentWeapon.WeaponClass:Reload()

end
function WeaponWrapper:GetAmmoInfo(player)
    local weaponTable = WeaponWrapper.Players[player.UserId]
    if not WeaponWrapper.Players[player.UserId].CurrentWeapon then return end
    if not player.Character then return end
    local CurrentAmmo = WeaponWrapper.Players[player.UserId].CurrentWeapon.WeaponClass.Rounds
    local SpareAmmo = WeaponWrapper.Players[player.UserId].CurrentWeapon.WeaponClass.Mags
    return {CurrentAmmo,SpareAmmo}
end

return WeaponWrapper