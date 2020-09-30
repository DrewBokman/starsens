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

function WeaponClass:Fire(direction, clientThatFired)
	if self.WeaponPart.Parent:IsA("Backpack") then return end
	if self.WeaponConfig.SHOTGUN then
		for i=1,self.WeaponConfig.SHOTGUN_SHOTS do
			local directionalCF = CFrame.new(Vector3.new(), direction)
			local direction = (directionalCF * CFrame.fromOrientation(0, 0, RNG:NextNumber(0, TAU)) * CFrame.fromOrientation(math.rad(RNG:NextNumber(self.MinSpread, self.MaxSpread)), 0, 0)).LookVector
			local humanoidRootPart = self.WeaponPart.Parent:WaitForChild("HumanoidRootPart", 1)
			local modifiedBulletSpeed = (direction * self.BULLET_SPEED)
			local bullet = self.cache:GetPart()
			if self.PIERCE_DEMO then
				game.ReplicatedStorage.BulletReplication:FireAllClients(self.WeaponPart.Handle.FirePointObject, direction * self.WeaponConfig.BULLET_MAXDIST, modifiedBulletSpeed, bullet, self.WeaponPart.Parent, false, self.WeaponConfig.BULLET_GRAVITY, clientThatFired)
				self.WeaponCaster:Fire(self.WeaponPart.Handle.FirePointObject.WorldPosition, direction * self.WeaponConfig.BULLET_MAXDIST, modifiedBulletSpeed, bullet, self.WeaponPart.Parent, false, self.WeaponConfig.BULLET_GRAVITY, self.WeaponConfig.Server.CanRayPierce, clientThatFired)
			else
				game.ReplicatedStorage.BulletReplication:FireAllClients(self.WeaponPart.Handle.FirePointObject, direction * self.WeaponConfig.BULLET_MAXDIST, modifiedBulletSpeed, bullet, self.WeaponPart.Parent, false, self.WeaponConfig.BULLET_GRAVITY, clientThatFired)
				self.WeaponCaster:Fire(self.WeaponPart.Handle.FirePointObject.WorldPosition, direction * self.WeaponConfig.BULLET_MAXDIST, modifiedBulletSpeed, bullet, self.WeaponPart.Parent, false, self.WeaponConfig.BULLET_GRAVITY, self.clientThatFired)
			end
		end
	else
		local directionalCF = CFrame.new(Vector3.new(), direction)
		local direction = (directionalCF * CFrame.fromOrientation(0, 0, RNG:NextNumber(0, TAU)) * CFrame.fromOrientation(math.rad(RNG:NextNumber(self.MinSpread, self.MaxSpread)), 0, 0)).LookVector
		local humanoidRootPart = self.WeaponPart.Parent:WaitForChild("HumanoidRootPart", 1)
		local modifiedBulletSpeed = (direction * self.BULLET_SPEED)
		local bullet = self.cache:GetPart()
		if self.PIERCE_DEMO then
			game.ReplicatedStorage.BulletReplication:FireAllClients(self.WeaponPart.Handle.FirePointObject, direction * self.WeaponConfig.BULLET_MAXDIST, modifiedBulletSpeed, bullet, self.WeaponPart.Parent, false, self.WeaponConfig.BULLET_GRAVITY, clientThatFired)
			self.WeaponCaster:Fire(self.WeaponPart.Handle.FirePointObject.WorldPosition, direction * self.WeaponConfig.BULLET_MAXDIST, modifiedBulletSpeed, bullet, self.WeaponPart.Parent, false, self.WeaponConfig.BULLET_GRAVITY, self.WeaponConfig.Server.CanRayPierce, clientThatFired)
		else
			game.ReplicatedStorage.BulletReplication:FireAllClients(self.WeaponPart.Handle.FirePointObject, direction * self.WeaponConfig.BULLET_MAXDIST, modifiedBulletSpeed, bullet, self.WeaponPart.Parent, false, self.WeaponConfig.BULLET_GRAVITY, clientThatFired)
			self.WeaponCaster:Fire(self.WeaponPart.Handle.FirePointObject.WorldPosition, direction * self.WeaponConfig.BULLET_MAXDIST, modifiedBulletSpeed, bullet, self.WeaponPart.Parent, false, self.WeaponConfig.BULLET_GRAVITY, clientThatFired)
		end
	end
	self.Rounds -= 1
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

function WeaponClass:OnRayHit(hitPart, hitPoint, normal, material, segmentVelocity, cosmeticBulletObject)
	self.WeaponConfig.Server:OnRayHit(hitPart, hitPoint, normal, material, segmentVelocity, cosmeticBulletObject,self.cache)
end

return WeaponClass