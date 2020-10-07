-- AR
-- DrewBokman
-- September 23, 2020
local Debris = game:GetService("Debris")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local FastCast = require(ReplicatedStorage.Aero.Shared.FastCastRedux)
local AR = {
	auto = false,
	WeaponEssentails = ReplicatedStorage.WeaponEssentails[script.Name],
	WeaponCaster = FastCast.new(),
    -------------Config-------------
    DAMAGE = 115,
    HEADSHOT_MULTIPLIER = 1,
    RELOAD_TIME = 1,
    TOTAL_ROUNDS = 15,
    ROUNDS_PER_MAG = 1,
    BULLET_SPEED = 1600,
    BULLET_MAXDIST = 400,
    BULLET_GRAVITY = Vector3.new(0, -30, 0),
    --Spread--
    MIN_BULLET_SPREAD_ANGLE = 0,
    MAX_BULLET_SPREAD_ANGLE = 0.1,

    ADS_MIN_BULLET_SPREAD_ANGLE = 0,
    ADS_MAX_BULLET_SPREAD_ANGLE = 0.1,

    CROUCH_MIN_BULLET_SPREAD_ANGLE = 0,
    CROUCH_MAX_BULLET_SPREAD_ANGLE = 0.1,
    ----------
    RPM = 50,
    PIERCE_DEMO = true,
    SHOTGUN = false,
	SHOTGUN_SHOTS = 10,
	
	Bullet = game.ReplicatedStorage.RayGunBullet,

	--Animations--
	Animations = {
		-- ADS = "rbxassetid://5707613213",
		-- CrouchADS = "rbxassetid://5707616614",
		-- CrouchReload = "rbxassetid://5707618824",
		-- CrouchShoot = "rbxassetid://5707615634",
		-- Reload = "rbxassetid://5707606742",
		-- Shoot = "rbxassetid://5707608051",
	},
	---------------------------------
}
for i,v in pairs(AR.WeaponEssentails.Animations:GetChildren()) do
	AR.Animations[v.Name] = v--Player.Character:WaitForChild("Humanoid"):LoadAnimation(v)
end
local function PlayAnimation(Player,AnimationObject)
	local anim = Player.Character:WaitForChild("Humanoid"):LoadAnimation(AnimationObject)
	anim:Play()
	return anim
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

function CreateDecal( PartHit, testPosition, DecalSize )
    local WorldToGui = require(game:GetService("ReplicatedStorage").Aero.Shared.WorldToGui)
	local SurfaceFace, Width, Height, RelativeX, RelativeY = WorldToGui.WorldPositionToGuiPosition( PartHit, testPosition );
	if ( SurfaceFace == nil ) then
		return;
	end

	local SCALE = 256;
	
	local SurfaceGui = Instance.new("SurfaceGui");
	SurfaceGui.CanvasSize = Vector2.new( SCALE*Width, SCALE*Height );
	SurfaceGui.Face = SurfaceFace;
	
	local SurfaceFrame = Instance.new("Frame");
	SurfaceFrame.BorderSizePixel = 0;
	SurfaceFrame.Size = UDim2.new(1, 0, 1, 0);
	SurfaceFrame.ClipsDescendants = true;
	SurfaceFrame.BackgroundTransparency = 1;
	SurfaceFrame.Parent = SurfaceGui;
	
	local BulletDecal = Instance.new("ImageLabel");
	BulletDecal.BorderSizePixel = 0;
	BulletDecal.BackgroundTransparency = 1;
	BulletDecal.Size = UDim2.new( 0, SCALE*DecalSize, 0, SCALE*DecalSize );
	BulletDecal.AnchorPoint = Vector2.new(0.5, 0.5);
	BulletDecal.Position = UDim2.new(RelativeX, 0, RelativeY, 0);
	BulletDecal.Image = "rbxassetid://1099167122";
	BulletDecal.Parent = SurfaceFrame;
	
	SurfaceGui.Parent = PartHit;
	Tween(10,{ImageTransparency = 1},BulletDecal)
	Debris:AddItem(SurfaceGui,10)
end
function MakeParticleFX(position, normal, hitPart)
	local attachment = Instance.new("Attachment")
	attachment.CFrame = CFrame.new(position, position + normal)
	attachment.Parent = workspace.Terrain
	local particle = AR.WeaponEssentails.ImpactParticle:Clone()
	particle.Parent = attachment
	Debris:AddItem(attachment, particle.Lifetime.Max)
	particle:Emit(20)
end

function PlaySound(Sound)
	local NewSound = Sound:Clone()
	NewSound.Parent = workspace
	NewSound:Play()
	Debris:AddItem(NewSound, NewSound.TimeLength)
end

--ClientFuncs--
AR.Client = {}
local ClientTbl = AR.Client

function ClientTbl.CanRayPierce(hitPart, hitPoint, normal, material, segmentVelocity)
	--if material == Enum.Material.Plastic or material == Enum.Material.Ice or material == Enum.Material.Glass or material == Enum.Material.SmoothPlastic then
	--	if hitPart.Transparency >= 0.5 and not hitPart.Name == "HumanoidRootPart" then
	--		if not hitPart:FindFirstChild("Value") then
	--			delay(0.1,function() onFragmentPart(hitPart) --[[Debris:AddItem(hitPart, 5)]] end)
	--		end
	--		hitPart.Anchored = false
	--		hitPart.Velocity = segmentVelocity/2
	--		return true
	--	end
	--end
	if hitPart.Parent:IsA("Tool") then
		return true
	end
	if hitPart.Transparency == 1 then
		return true
	end
	if hitPart.Name == "Handle" and hitPart.Parent:IsA("Accoutrement") then
		return true
	end
	return false
end

function ClientTbl.EnemyCanRayPierce(hitPart, hitPoint, normal, material, segmentVelocity)
	--if material == Enum.Material.Plastic or material == Enum.Material.Ice or material == Enum.Material.Glass or material == Enum.Material.SmoothPlastic then
	--	if hitPart.Transparency >= 0.5 and not hitPart.Name == "HumanoidRootPart" then
	--		if not hitPart:FindFirstChild("Value") then
	--			delay(0.1,function() onFragmentPart(hitPart) --[[Debris:AddItem(hitPart, 5)]] end)
	--		end
	--		hitPart.Anchored = false
	--		hitPart.Velocity = segmentVelocity/2
	--		return true
	--	end
	--end
	if hitPart.Parent:IsA("Tool") then
		return true
	end
	if hitPart.Name == "Handle" and hitPart.Parent:IsA("Accoutrement") then
		return true
	end
	if hitPart ~= nil and hitPart.Parent ~= nil then
		local humanoid = hitPart.Parent:FindFirstChildOfClass("Humanoid")
		if humanoid then
			return false
		else
			if hitPart.Transparency == 1 then
				return true
			else
				CreateDecal(hitPart,hitPoint,2)
				return true
			end
		end
	end
	return false
end

function ClientTbl:Fire(FirePointObject,direction,modifiedBulletSpeed,bullet,ignore,bool,BULLET_GRAVITY,clientThatFired)
	bullet:WaitForChild("CylinderHandleAdornment").Enabled = true
	bullet:WaitForChild("BillboardGui").Enabled = true
	bullet:WaitForChild("BillboardGui").Size = UDim2.fromScale(0,0)
	bullet:waitForChild("Trail").Enabled = true
	bullet:waitForChild("Shock").Enabled = true
	Tween(5,{Size = UDim2.fromScale(30,30)},bullet:WaitForChild("BillboardGui"))
	bullet.CFrame = CFrame.new(FirePointObject.WorldPosition, FirePointObject.WorldPosition + direction)
	
	if clientThatFired.Parent == game.Players then
		if clientThatFired.Character.Crouching.Value then
			local Anim = PlayAnimation(clientThatFired,AR.Animations.CrouchShoot)
		else
			local Anim = PlayAnimation(clientThatFired,AR.Animations.Shoot)

		end
	end
	local FireSound = AR.WeaponEssentails.Fire:Clone()
	FireSound.Parent = FirePointObject
	PlaySound(FireSound)
	AR.WeaponCaster:Fire(FirePointObject.WorldPosition,direction,modifiedBulletSpeed,bullet,ignore,bool,BULLET_GRAVITY,ClientTbl.CanRayPierce,clientThatFired)
end

function ClientTbl.OnRayHit(hitPart, hitPoint, normal, material, segmentVelocity, cosmeticBulletObject, clientThatFired, Gun)
	cosmeticBulletObject:WaitForChild("CylinderHandleAdornment").Enabled = false	
	cosmeticBulletObject:WaitForChild("CylinderHandleAdornment").Lifetime = 0.2
	cosmeticBulletObject:waitForChild("Trail").Enabled = false
	cosmeticBulletObject:waitForChild("Shock").Enabled = false
	cosmeticBulletObject:WaitForChild("BillboardGui").Enabled = false
	delay(0.75,function()
		cosmeticBulletObject:WaitForChild("CylinderHandleAdornment").Lifetime = 1
		cosmeticBulletObject:WaitForChild("CylinderHandleAdornment").MaxLength = 10
		cosmeticBulletObject:WaitForChild("BillboardGui").ImageLabel.ImageTransparency = 0
		cosmeticBulletObject.Attachment.Position = Vector3.new(-0.1,0,0)
		cosmeticBulletObject.Attachment2.Position = Vector3.new(0.1,0,0)
	end)
	if hitPart ~= nil and hitPart.Parent ~= nil then
		local humanoid = hitPart.Parent:FindFirstChildOfClass("Humanoid")
		if not humanoid then
			CreateDecal(hitPart,hitPoint,1)
		elseif clientThatFired == game.Players.LocalPlayer then
			if hitPart.Name == "Head" then
				PlaySound(AR.WeaponEssentails.HeadShotHitmarker)
			else
				PlaySound(AR.WeaponEssentails.Hitmarker)
			end
			local new = game.Players.LocalPlayer.PlayerGui.HitRegister.TextLabel:Clone()
			new.Name = "New"
			new.Parent = game.Players.LocalPlayer.PlayerGui.HitRegister
			local vector, onScreen = workspace.CurrentCamera:WorldToScreenPoint(hitPoint)
			if onScreen then
				new.Position = UDim2.fromOffset(vector.X, vector.Y)
				new.Visible = true
				local start = tick()
				repeat 
					wait()
					local vector, onScreen = workspace.CurrentCamera:WorldToScreenPoint(hitPoint)
					if onScreen then
						new.Visible = true
						new.Position = UDim2.fromOffset(vector.X, vector.Y)
					else
						new.Visible = false
					end
				until
					tick()-start >= 0.3
				new:Destroy()
			end
		end
		MakeParticleFX(hitPoint, normal, hitPart)
	end
end

function ClientTbl.OnRayUpdated(castOrigin, segmentOrigin, segmentDirection, length, segmentVelocity, cosmeticBulletObject, distanceTravelled, MaxDistance, clientThatFired)
	local ForamttedDist = MaxDistance-(MaxDistance*0.25)
	if distanceTravelled >= ForamttedDist then
		cosmeticBulletObject:WaitForChild("BillboardGui").ImageLabel.ImageTransparency = math.clamp((distanceTravelled-ForamttedDist)/(MaxDistance*0.25),0,(MaxDistance*0.25))
	end
	local bulletLength = cosmeticBulletObject.Size.Z / 2
	local baseCFrame = CFrame.new(segmentOrigin, segmentOrigin + segmentDirection)
	cosmeticBulletObject.CFrame = baseCFrame * CFrame.new(0, 0, -(length - bulletLength))
end

--ServerFuncs--
AR.Server = {}
local ServerTbl = AR.Server

function ServerTbl.CanRayPierce(hitPart, hitPoint, normal, material, segmentVelocity)
	--if material == Enum.Material.Plastic or material == Enum.Material.Ice or material == Enum.Material.Glass or material == Enum.Material.SmoothPlastic then
	--	if hitPart.Transparency >= 0.5 and not hitPart.Name == "HumanoidRootPart" then
	--		if not hitPart:FindFirstChild("Value") then
	--			delay(0.1,function() onFragmentPart(hitPart) --[[Debris:AddItem(hitPart, 5)]] end)
	--		end
	--		hitPart.Anchored = false
	--		hitPart.Velocity = segmentVelocity/2
	--		return true
	--	end
	--end
	if hitPart.Parent:IsA("Tool") then
		return true
	end
	if hitPart.Transparency == 1 then
		return true
	end
	if hitPart.Name == "Handle" and hitPart.Parent:IsA("Accoutrement") then
		return true
	end
	return false
end

function ServerTbl.OnRayHit(hitPart, hitPoint, normal, material, segmentVelocity, cosmeticBulletObject, ClientThatFired, cache)
	if hitPart ~= nil and hitPart.Parent ~= nil then
		local humanoid = hitPart.Parent:FindFirstChildOfClass("Humanoid")
		if humanoid then
			if hitPart.Name == "Head" then
				humanoid:TakeDamage(AR.DAMAGE * AR.HEADSHOT_MULTIPLIER)
			else
				humanoid:TakeDamage(AR.DAMAGE)
			end
		end
	end
	-- delay(1,function()
	-- 	cache:ReturnPart(cosmeticBulletObject)
	-- end)
end

AR.WeaponCaster.RayHit:Connect(ClientTbl.OnRayHit)
AR.WeaponCaster.LengthChanged:Connect(ClientTbl.OnRayUpdated)

return AR