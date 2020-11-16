-- Weapon Class
-- DrewBokman
-- September 20, 2020



local WeaponClass = {}
WeaponClass.__index = WeaponClass

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TAU = math.pi * 2
local RNG = Random.new()
local FastCast = require(ReplicatedStorage.Aero.Shared.FastCastRedux)

local ERR_OBJECT_DISPOSED = "This WeaponClass has been Destroyed. It can no longer be used."

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

function WeaponClass:Fire(direction, clientThatFired, Aiming, Crouching)
	-- direction = Vector3.new(tonumber(direction[1]),tonumber(direction[2]),tonumber(direction[3]))
	if self.Reloading then return end
	if Crouching and Aiming then
		self.MinSpread = self.WeaponConfig.CROUCH_MIN_BULLET_SPREAD_ANGLE
		self.MaxSpread = self.WeaponConfig.CROUCH_MAX_BULLET_SPREAD_ANGLE
	elseif Aiming then
		self.MinSpread = self.WeaponConfig.ADS_MIN_BULLET_SPREAD_ANGLE
		self.MaxSpread = self.WeaponConfig.ADS_MAX_BULLET_SPREAD_ANGLE
	else
		self.MinSpread = self.WeaponConfig.MIN_BULLET_SPREAD_ANGLE
		self.MaxSpread = self.WeaponConfig.MAX_BULLET_SPREAD_ANGLE
	end
	if self.WeaponPart.Parent:IsA("Backpack") then return end
	if self.WeaponConfig.SHOTGUN then
		for i=1,self.WeaponConfig.SHOTGUN_SHOTS do
			local directionalCF = CFrame.new(Vector3.new(), direction)
			local direction = (directionalCF * CFrame.fromOrientation(0, 0, RNG:NextNumber(0, TAU)) * CFrame.fromOrientation(math.rad(RNG:NextNumber(self.MinSpread, self.MaxSpread)), 0, 0)).LookVector
			local humanoidRootPart = self.WeaponPart.Parent:WaitForChild("HumanoidRootPart", 1)
			local modifiedBulletSpeed = (direction * self.WeaponConfig.BULLET_SPEED)
			local bullet = self.cache:GetPart()
			if self.WeaponConfig.PIERCE_DEMO then
				local bulletID = game:GetService("HttpService"):GenerateGUID(false)
				
				self.WeaponCaster:Fire(self.WeaponPart.Handle.GunFirePoint.WorldPosition, direction * self.WeaponConfig.BULLET_MAXDIST, modifiedBulletSpeed, bullet, self.WeaponPart.Parent, false, self.WeaponConfig.BULLET_GRAVITY, self.WeaponConfig.Server.CanRayPierce, clientThatFired, self.cache)
				return self.WeaponPart.Handle.GunFirePoint, direction * self.WeaponConfig.BULLET_MAXDIST, modifiedBulletSpeed, bullet, self.WeaponPart.Parent, false, self.WeaponConfig.BULLET_GRAVITY, clientThatFired, self.WeaponName
			else
				self.WeaponCaster:Fire(self.WeaponPart.Handle.GunFirePoint.WorldPosition, direction * self.WeaponConfig.BULLET_MAXDIST, modifiedBulletSpeed, bullet, self.WeaponPart.Parent, false, self.WeaponConfig.BULLET_GRAVITY, nil, self.clientThatFired, self.cache)
				return self.WeaponPart.Handle.GunFirePoint, direction * self.WeaponConfig.BULLET_MAXDIST, modifiedBulletSpeed, bullet, self.WeaponPart.Parent, false, self.WeaponConfig.BULLET_GRAVITY, clientThatFired, self.WeaponName
			end
		end
	else
		local directionalCF = CFrame.new(Vector3.new(), direction)
		local direction = (directionalCF * CFrame.fromOrientation(0, 0, RNG:NextNumber(0, TAU)) * CFrame.fromOrientation(math.rad(RNG:NextNumber(self.MinSpread, self.MaxSpread)), 0, 0)).LookVector
		local humanoidRootPart = self.WeaponPart.Parent:WaitForChild("HumanoidRootPart", 1)
		local modifiedBulletSpeed = (direction * self.WeaponConfig.BULLET_SPEED)
		local bullet = self.cache:GetPart()
		if self.PIERCE_DEMO then
			self.WeaponCaster:Fire(self.WeaponPart.Handle.GunFirePoint.WorldPosition, direction * self.WeaponConfig.BULLET_MAXDIST, modifiedBulletSpeed, bullet, self.WeaponPart.Parent, false, self.WeaponConfig.BULLET_GRAVITY, self.WeaponConfig.Server.CanRayPierce, clientThatFired, self.cache)
			return self.WeaponPart.Handle.GunFirePoint, direction * self.WeaponConfig.BULLET_MAXDIST, modifiedBulletSpeed, bullet, self.WeaponPart.Parent, false, self.WeaponConfig.BULLET_GRAVITY, clientThatFired, self.WeaponName
		else
			self.WeaponCaster:Fire(self.WeaponPart.Handle.GunFirePoint.WorldPosition, direction * self.WeaponConfig.BULLET_MAXDIST, modifiedBulletSpeed, bullet, self.WeaponPart.Parent, false, self.WeaponConfig.BULLET_GRAVITY, nil, clientThatFired, self.cache)
			return self.WeaponPart.Handle.GunFirePoint, direction * self.WeaponConfig.BULLET_MAXDIST, modifiedBulletSpeed, bullet, self.WeaponPart.Parent, false, self.WeaponConfig.BULLET_GRAVITY, clientThatFired, self.WeaponName
		end
	end
	--PlayFireSound()
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

function ErrorDisposed()
	error(ERR_OBJECT_DISPOSED)
end

function WeaponClass:Remove()
	self.Mags = nil
	self.Rounds = nil
	self.MinSpread = nil
	self.MaxSpread = nil
	self.Player = nil
	self.WeaponPart = nil
	self.WeaponName = nil
	self.WeaponConfig = nil
	self.WeaponCaster = nil
	self.Reloading = nil

	self.OnRayHit = ErrorDisposed
	self.OnRayUpdated = ErrorDisposed
	self.Reload = ErrorDisposed
	self.Fire = ErrorDisposed
	self.Remove = ErrorDisposed
	
end

return WeaponClass