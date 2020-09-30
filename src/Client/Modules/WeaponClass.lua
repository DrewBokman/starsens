-- Weapon Class
-- DrewBokman
-- September 20, 2020



local WeaponClass = {}
WeaponClass.__index = WeaponClass

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TAU = math.pi * 2
local RNG = Random.new()
local PartCache = require(ReplicatedStorage.Aero.Shared.PartChache)
local FastCast = require(ReplicatedStorage.Aero.Shared.FastCastRedux)

function WeaponClass.new(Player,Config,WeaponName,WeaponPart)

	local self = setmetatable({
		Player = Player,
		WeaponPart = WeaponPart,
		WeaponName = WeaponName,
		WeaponConfig = require(Config),
		WeaponCaster = FastCast.new(),
		Reloading = false,
	}, WeaponClass)
	self.Mags = self.WeaponConfig.TOTAL_ROUNDS
	self.Rounds = self.WeaponConfig.ROUNDS_PER_MAG
	self.MinSpread = self.WeaponConfig.MIN_BULLET_SPREAD_ANGLE
	self.MaxSpread = self.WeaponConfig.MAX_BULLET_SPREAD_ANGLE
	local preLoad = self.WeaponConfig.ROUNDS_PER_MAG
	if self.WeaponConfig.SHOTGUN then
		preLoad *= self.WeaponConfig.SHOTGUN_SHOTS
	end
	self.cache = PartCache.new(self.WeaponConfig.Bullet, math.clamp(preLoad,0,200),  self.WeaponPart.Parent)
	return self

end

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

function WeaponClass:Fire(FirePointObject,direction,modifiedBulletSpeed,bullet,ignore,bool,BULLET_GRAVITY,clientThatFired, FuncThatGoBrr)
	bullet:WaitForChild("CylinderHandleAdornment").Enabled = true
	bullet:WaitForChild("BillboardGui").Enabled = true
	bullet:WaitForChild("BillboardGui").Size = UDim2.fromScale(0,0)
	Tween(5,{Size = UDim2.fromScale(30,30)},bullet:WaitForChild("BillboardGui"))
	bullet.CFrame = CFrame.new(FirePointObject.WorldPosition, FirePointObject.WorldPosition + direction)
	local funcGo = CanRayPierce
	if FuncThatGoBrr then
		funcGo = self.WeaponConfig.Client.EnemyCanRayPierce
	else
		funcGo = self.WeaponConfig.Client.CanRayPierce
	end
	Caster:Fire(FirePointObject.WorldPosition,direction,modifiedBulletSpeed,bullet,ignore,bool,BULLET_GRAVITY,funcGo,clientThatFired)
end

function WeaponClass:Reload()
	if self.Mags <=0 then return end
--	if player.Character.Running.Value == true then return end
	local AddedRounds = self.WeaponConfig.ROUNDS_PER_MAG
	self.Mags += self.Rounds
	self.Rounds = 0
	Reloading = true
	local canceled = false
	self.WeaponPart.Handle.Reload:Play()
	delay(0,function()
		while Reloading do
			if self.Player.Character.Running.Value == true then
				self.WeaponPart.Handle.Reload:Stop()
				canceled = true
			end
			wait()
		end
	end)
	delay(self.WeaponConfig.RELOAD_TIME, function()
		if canceled then return end
		if self.Mags <= self.WeaponConfig.ROUNDS_PER_MAG then
			AddedRounds = self.Mags
			self.Mags = 0
		else
			self.Mags -= self.WeaponConfig.ROUNDS_PER_MAG
		end
		self.Rounds = AddedRounds
		self.Reloading = false
	end)
	--ReloadEvent:FireAllClients()
end

function WeaponClass:OnRayHit(hitPart, hitPoint, normal, material, segmentVelocity, cosmeticBulletObject, clientThatFired)
	self.WeaponConfig.Client:OnRayHit(hitPart, hitPoint, normal, material, segmentVelocity, cosmeticBulletObject, clientThatFired, self.WeaponPart)
end

function WeaponClass:OnRayUpdated(castOrigin, segmentOrigin, segmentDirection, length, segmentVelocity, cosmeticBulletObject, distanceTravelled, MaxDistance, clientThatFired)
	self.WeaponConfig.Client:OnRayUpdated(castOrigin, segmentOrigin, segmentDirection, length, segmentVelocity, cosmeticBulletObject, distanceTravelled, MaxDistance, clientThatFired)
end

return WeaponClass