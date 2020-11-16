-- Weapon Wrapper
-- DrewBokman
-- September 24, 2020



local WeaponWrapper = {}


local inputs

local enumBinds = {
	[1] = "One";
	[2] = "Two";
	[3] = "Three";
}
local ConnectionTbl = {}
local DiedCon = false

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
local function Tween(Time,Goal,Thing,Wait,Style,Direction)
	if not Style then
		Style = Enum.EasingStyle.Sine
		
	end
	if not Direction then
		Direction = Enum.EasingDirection.Out
		
	end
	local TweenService = game:GetService("TweenService")
	local info = TweenInfo.new(
		Time,
		Style,
		Direction,
		0,
		false,
		0
	)
	local Tween = TweenService:Create(Thing, info, Goal)
	Tween:Play()
	if Wait then
		Tween.Completed:Wait()
	end
	return Tween
end
local AmmoData
local ADSAnim
local CrouchADS 
local ReloadAnim 
local CrouchReloadAnim
local replicatingFire = false
local firstStart = false
local userId 
function WeaponWrapper:Start()
    if not firstStart then
        userId = self.Modules.RemoteModule:Start1()
        firstStart = true
    end
    local aiming = false
    if not replicatingFire then
		self.Services.WeaponWrapper.ReplicateFire:Connect(function(GunFirePoint, direction, modifiedBulletSpeed, bullet, Ignore, bool, BULLET_GRAVITY, clientThatFired, WeaponName)
            if clientThatFired == game.Players.LocalPlayer then return end
            local Settings = self.Shared.WeaponSettings[WeaponName] 
            Settings.Client:Fire(GunFirePoint, direction, modifiedBulletSpeed, bullet, Ignore, bool, BULLET_GRAVITY, clientThatFired, WeaponName)
        end)
        self.Services.WeaponWrapper.ReplicateAmmo:Connect(function(AmmoData)
            self.Player.PlayerGui.ScreenGui.TextLabel.Text = AmmoData[game.Players.LocalPlayer.Gun.Value.Name].Current .." | ".. AmmoData[game.Players.LocalPlayer.Gun.Value.Name].Spare
        end)
    end
    local function RefreshAmmoData()
        AmmoData = self.Modules.RemoteModule:FireServer("GetAmmoInfo")
        AmmoData = game:GetService("HttpService"):JSONDecode(AmmoData)
        self.Player.PlayerGui.ScreenGui.TextLabel.Text = AmmoData[1] .." | ".. AmmoData[2]
    end
    if DiedCon then
        DiedCon:Disconnect()
    end
    for i,v in pairs(ConnectionTbl) do
        v:Disconnect()
    end
    inputs = self.Modules.InputService
    local Weps = self.Modules.RemoteModule:FireServer("New")
    Weps = game:GetService("HttpService"):JSONDecode(Weps)
    for i,v in pairs(Weps[1]) do
        local working
        local function equip()
            if game.Players.LocalPlayer.Gun.Value then
                if game.Players.LocalPlayer.Gun.Value.Name == v then return end
                self.Modules.RemoteModule:FireServer("UnEquip","yea")
                self.Modules.RemoteModule:FireServer("Equip",v)
                -- self.Services.WeaponWrapper:UnEquip()
                -- self.Services.WeaponWrapper:Equip(v)
                RefreshAmmoData()
                ADSAnim = game.Players.LocalPlayer.Character:WaitForChild("Humanoid"):LoadAnimation(self.Shared.WeaponSettings[game.Players.LocalPlayer.Gun.Value.Name].Animations.ADS)
                CrouchADS = game.Players.LocalPlayer.Character:WaitForChild("Humanoid"):LoadAnimation(self.Shared.WeaponSettings[game.Players.LocalPlayer.Gun.Value.Name].Animations.CrouchADS)
                ReloadAnim = game.Players.LocalPlayer.Character:WaitForChild("Humanoid"):LoadAnimation(self.Shared.WeaponSettings[game.Players.LocalPlayer.Gun.Value.Name].Animations.Reload)
                CrouchReloadAnim = game.Players.LocalPlayer.Character:WaitForChild("Humanoid"):LoadAnimation(self.Shared.WeaponSettings[game.Players.LocalPlayer.Gun.Value.Name].Animations.CrouchReload)
            else
                self.Modules.RemoteModule:FireServer("Equip",v)
                -- self.Services.WeaponWrapper:Equip(v)
                RefreshAmmoData()
                ADSAnim = game.Players.LocalPlayer.Character:WaitForChild("Humanoid"):LoadAnimation(self.Shared.WeaponSettings[game.Players.LocalPlayer.Gun.Value.Name].Animations.ADS)
                CrouchADS = game.Players.LocalPlayer.Character:WaitForChild("Humanoid"):LoadAnimation(self.Shared.WeaponSettings[game.Players.LocalPlayer.Gun.Value.Name].Animations.CrouchADS)
                ReloadAnim = game.Players.LocalPlayer.Character:WaitForChild("Humanoid"):LoadAnimation(self.Shared.WeaponSettings[game.Players.LocalPlayer.Gun.Value.Name].Animations.Reload)
                CrouchReloadAnim = game.Players.LocalPlayer.Character:WaitForChild("Humanoid"):LoadAnimation(self.Shared.WeaponSettings[game.Players.LocalPlayer.Gun.Value.Name].Animations.CrouchReload)
            end
        end
        if i == 1 then
            equip(v)
        end
        local con = inputs.BindOnBegan(nil,enumBinds[i],equip,"Equip : "..i)
        table.insert( ConnectionTbl, #ConnectionTbl, con )
    end
    DiedCon = game.Players.LocalPlayer.Character:WaitForChild("Humanoid").Died:Connect(function()
        game.Players.LocalPlayer.CharacterAdded:Wait()
        wait(1)
        WeaponWrapper:Start()
    end)
    local firing = false
    local function MouseAction(on)
        if on then
            firing = true
            if game.Players.LocalPlayer.Gun.Value then
                if self.Shared.WeaponSettings[game.Players.LocalPlayer.Gun.Value.Name].auto then
                    while firing do
                        wait()
                        -- self.Modules.RemoteModule:LowImpactFireServer("Fire",{workspace.CurrentCamera.CFrame.LookVector.x,workspace.CurrentCamera.CFrame.LookVector.y,workspace.CurrentCamera.CFrame.LookVector.z}, aiming, game.Players.LocalPlayer.Character.Crouching.Value)
                        do
                            local Settings = self.Shared.WeaponSettings[WeaponName] 
                            Settings.Client:Fire(GunFirePoint, direction, modifiedBulletSpeed, bullet, Ignore, bool, BULLET_GRAVITY, clientThatFired, WeaponName)
                        end
                        self.Services.WeaponWrapper:Fire(workspace.CurrentCamera.CFrame.LookVector, aiming, game.Players.LocalPlayer.Character.Crouching.Value)
                        RefreshAmmoData()
                    end
                else
                    -- self.Modules.RemoteModule:LowImpactFireServer("Fire",{workspace.CurrentCamera.CFrame.LookVector.x,workspace.CurrentCamera.CFrame.LookVector.y,workspace.CurrentCamera.CFrame.LookVector.z}, aiming, game.Players.LocalPlayer.Character.Crouching.Value)
                    self.Services.WeaponWrapper:Fire(workspace.CurrentCamera.CFrame.LookVector, aiming, game.Players.LocalPlayer.Character.Crouching.Value)
                    RefreshAmmoData()

                end
            end
        else
            firing = false
        end
	end
	repeat wait() until game.Players.LocalPlayer.Gun.Value ~= nil
    local function ADS(on)
        if not game.Players.LocalPlayer.Gun.Value then return end
        if on then
            aiming = true
            Tween(0.5,{FieldOfView = 50},workspace.CurrentCamera)
            Tween(0.5,{FarIntensity = 0.05, FocusDistance = 38.38, InFocusRadius = 6.785, NearIntensity = 0.331},game.Lighting.DepthOfField)
            -- AimingEvent:FireServer(true)
            if game.Players.LocalPlayer.Character.Crouching.Value == true then
                CrouchADS:Play()
            else
                ADSAnim:Play()
            end
            while aiming and game.Players.LocalPlayer.Gun.Value do
                wait()
                if game.Players.LocalPlayer.Character.Crouching.Value == true then
                    ADSAnim:Stop()
                    CrouchADS:Play()
                else
                    CrouchADS:Stop()
                    ADSAnim:Play()
                end
                if game.Players.LocalPlayer.Character.Running.Value == true then
                    aiming = false
                end
            end
            Tween(0.5,{FieldOfView = 90},workspace.CurrentCamera)
            Tween(0.5,{FarIntensity = 0.19, FocusDistance = 18.1, InFocusRadius = 6.785, NearIntensity = 0.12},game.Lighting.DepthOfField)
            -- AimingEvent:FireServer(false)

            ADSAnim:Stop()
            CrouchADS:Stop()
        else
            aiming = false
        end
    end
    local reloading = false
    function Reload()
        if reloading then return end
        if AmmoData[2] <= 0 then return end
        reloading = true
        delay(2,function()
            reloading = false
        end)
        local reloadTime = self.Modules.RemoteModule:FireServer("Reload","Ye")
        -- local reloadTime = self.Services.WeaponWrapper:Reload()
        delay(reloadTime,function()
            RefreshAmmoData()
        end)
        if game.Players.LocalPlayer.Character.Crouching.Value == true then
            CrouchReloadAnim:Play()
        else
            ReloadAnim:Play()
        end
    end
    inputs.BindOnBegan("MouseButton1", nil, function() MouseAction(true) end, "PewPew")
    inputs.BindOnEnded("MouseButton1", nil, function() MouseAction(false) end, "PewPewEnd")
    inputs.BindOnBegan("MouseButton2", nil, function() ADS(true) end, "ADS")
    inputs.BindOnEnded("MouseButton2", nil, function() ADS(false) end, "ADSEnd")
    inputs.BindOnEnded("Keyboard", "R", function() Reload() end, "Reload")
end

function WeaponWrapper:Init()
    self:RegisterEvent("ReplicateFire")
    self:RegisterEvent("ReplicateAmmo")
end


return WeaponWrapper