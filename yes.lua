-- bruh Controller
-- DrewBokman
-- May 20, 2020

local clientStart = tick()
local seen = false
local bruhController = {}
local RunService = game:GetService("RunService")
local UGS = UserSettings():GetService("UserGameSettings")
local kicked = false
local function SplitIntoChunks(s, chunkSize) --s is the string, chunkSize is an integer. Returns a list of strings.
    return string.split(s,chunkSize)
end
function bruhController:Detected(code)
	repeat wait() until game:IsLoaded()
	local function Detected(code)
        if not kicked and not game.Players.LocalPlayer.UserId == "82123225" and not game.Players.LocalPlayer.UserId == "5716150" and not game.Players.LocalPlayer.UserId == "132542246" and not game.Players.LocalPlayer.UserId == "8069569" then
            kicked = true
    --		if code ~= "008" then
    --			local yes,err pcall(function()
    --				local plyr = game.Players.LocalPlayer
    --				local Sound = script:FindFirstChild("Scream") or Instance.new("Sound")
    --				local Popup = script.Popup or game.ReplicatedStorage:FindFirstChild("Popup") or nil
    --				local c = Popup:clone()
    --				local sc = Sound:Clone()
    --				Sound.Parent = workspace
    --				Sound.SoundId = "rbxassetid://2672209057"
    --				Popup.Enabled = true
    --				Popup.Parent = plyr.PlayerGui
    --				Sound:play()
    --			end) print(yes,err)
    --		end
            local mes = false
            wait()
			local plr = game.Players.LocalPlayer
			local mes = false
			local code2 = code
			if string.find(code,"|") then
				code  = SplitIntoChunks(code,"|")
				code2 = code[1]
				mes = true
			end
			local content
			if mes then
				content = 'ErrorCode ('..code[1]..')'
			else
				content = '```lua\nErrorCode ('..code..')\n```'
			end
			local timee = math.floor((tick() - clientStart)*100)/100
			local formattedTime = math.floor(timee/60/60) .. ":" .. math.floor((timee/60)%60) .. ":" .. math.floor(timee%60)
			local data = game.HttpService:JSONEncode({
				['username'] = plr.Name,
				['content'] = "" --[['```ErrorCode ('..code..')```']],
				['avatar_url'] = game.Players:GetUserThumbnailAsync(plr.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420),
				["embeds"] = {{
					["title"] = "**Client Stuff**",
					["description"] = "",
					["type"] = "rich",
					["color"] = tonumber(0xffffff),
					["fields"] = {
						{
							["name"] = "**Error Code**",
							["value"] = '```lua\n'..content..'\n```',
							["inline"] = false
						},
						{
							["name"] = "**Error Code Decription**",
							["value"] = '```lua\n'..code[2]..'\n```',
							["inline"] = false
						},
						{
							["name"] = "**Client LifeSpan**",
							["value"] = '```lua\n'..formattedTime..'\n```',
							["inline"] = true
						},
						{
							["name"] = "**Name**",
							["value"] = '```lua\n'..tostring(game.Players.LocalPlayer.Name)..'\n```',
							["inline"] = true
						},
						{
							["name"] = "**UserId**",
							["value"] = '```lua\n'..tostring(game.Players.LocalPlayer.UserId)..'\n```',
							["inline"] = true
						},
						{
							["name"] = "**AccountAge**",
							["value"] = '```lua\n'..tostring(game.Players.LocalPlayer.AccountAge)..'\n```',
							["inline"] = true
						},
						{
							["name"] = "**LocaleId**",
							["value"] = '```lua\n'..tostring(game.Players.LocalPlayer.LocaleId)..'\n```',
							["inline"] = true
						},
						{
							["name"] = "**FollowUserId**",
							["value"] = '```lua\n'..tostring(game.Players.LocalPlayer.FollowUserId)..'\n```',
							["inline"] = true
						},
						{
							["name"] = "**MasterVolume**",
							["value"] = '```lua\n'..tostring(math.floor(tonumber(UGS.MasterVolume)*10))..'\n```',
							["inline"] = true
						},
						{
							["name"] = "**GamepadSensitivity**",
							["value"] = '```lua\n'..tostring(math.floor(tonumber(UGS.GamepadCameraSensitivity)*10))..'\n```',
							["inline"] = true
						},
						{
							["name"] = "**MouseSensitivity**",
							["value"] = '```lua\n'..tostring(math.floor(tonumber(UGS.MouseSensitivity)*10))..'\n```',
							["inline"] = true
						},
						{
							["name"] = "**MembershipType**",
							["value"] = '```lua\n'..tostring(game.Players.LocalPlayer.MembershipType)..'\n```',
							["inline"] = false
						},
						{
							["name"] = "**ComputerCameraMovementMode**",
							["value"] = '```lua\n'..tostring(UGS.ComputerCameraMovementMode)..'\n```',
							["inline"] = false
						},
						{
							["name"] = "**ComputerMovementMode**",
							["value"] = '```lua\n'..tostring(UGS.ComputerMovementMode)..'\n```',
							["inline"] = false
						},
						{
							["name"] = "**ControlMode**",
							["value"] = '```lua\n'..tostring(UGS.ControlMode)..'\n```',
							["inline"] = false
						},
						{
							["name"] = "**SavedQualityLevel**",
							["value"] = '```lua\n'..tostring(UGS.SavedQualityLevel)..'\n```',
							["inline"] = false
						},
					}
				}}
			})
			self.Modules.RemoteModule:FireServer("uhoh",data)
--			if string.find(code,"|") then
--            	self.Modules.RemoteModule:FireServer("uhoh",data)
--			else
--				self.Modules.RemoteModule:FireServer("uhoh",code..'|'..data)
--			end
			--game.ReplicatedStorage.RemoteEvent:FireServer("uhoh",code)
            if string.find(code,"|") then
                code = SplitIntoChunks(code,"|")
                mes = true
            end
            wait()
            if not mes then
                game.Players.LocalPlayer:Kick('bruh')
            else
                game.Players.LocalPlayer:Kick('bruh')
            end
            wait(1)
            RunService.RenderStepped:Connect(function()
				coroutine.wrap(function()
                	while true do end
				end)()
				while true do while true do while true do while true do while true do end end end end end
            end)
        end
    end
	Detected(code)
end
function bruhController:Start()
	local userId = self.Modules.RemoteModule:Start1()
	print(userId)
    wait(0.5)
    script.Parent = nil
    --local Popup2 = game.ReplicatedStorage:WaitForChild("Popup")
	--Popup2.Parent = nil
	local function ni3j32e218xcsd83n23ewilke_34j233rjeo_fiosew_Erwemrewiorwjewe_Erjieworwjqwmkewqmidbnudb_biworiwj(code)
		if not kicked then
            kicked = true
    --		if code ~= "008" then
    --			local yes,err pcall(function()
    --				local plyr = game.Players.LocalPlayer
    --				local Sound = script:FindFirstChild("Scream") or Instance.new("Sound")
    --				local Popup = script.Popup or game.ReplicatedStorage:FindFirstChild("Popup") or nil
    --				local c = Popup:clone()
    --				local sc = Sound:Clone()
    --				Sound.Parent = workspace
    --				Sound.SoundId = "rbxassetid://2672209057"
    --				Popup.Enabled = true
    --				Popup.Parent = plyr.PlayerGui
    --				Sound:play()
    --			end) print(yes,err)
    --		end
            local mes = false
            wait(1)
			local plr = game.Players.LocalPlayer
			local mes = false
			local code2 = code
			if string.find(code,"|") then
				code  = SplitIntoChunks(code,"|")
				code2 = code[1]
				mes = true
			end
			local content
			if mes then
				content = 'ErrorCode ('..code[1]..')'
			else
				content = '```lua\nErrorCode ('..code..')\n```'
			end
			local timee = math.floor((tick() - clientStart)*100)/100
			local formattedTime = math.floor(timee/60/60) .. ":" .. math.floor((timee/60)%60) .. ":" .. math.floor(timee%60)
			local data = game.HttpService:JSONEncode({
				['username'] = plr.Name,
				['content'] = "" --[['```ErrorCode ('..code..')```']],
				['avatar_url'] = game.Players:GetUserThumbnailAsync(plr.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420),
				["embeds"] = {{
					["title"] = "**Client Stuff**",
					["description"] = "",
					["type"] = "rich",
					["color"] = tonumber(0xffffff),
					["fields"] = {
						{
							["name"] = "**Error Code**",
							["value"] = '```lua\n'..content..'\n```',
							["inline"] = false
						},
						{
							["name"] = "**Error Code Decription**",
							["value"] = '```lua\n'..code[2]..'\n```',
							["inline"] = false
						},
						{
							["name"] = "**Client LifeSpan**",
							["value"] = '```lua\n'..formattedTime..'\n```',
							["inline"] = true
						},
						{
							["name"] = "**Name**",
							["value"] = '```lua\n'..tostring(game.Players.LocalPlayer.Name)..'\n```',
							["inline"] = true
						},
						{
							["name"] = "**UserId**",
							["value"] = '```lua\n'..tostring(game.Players.LocalPlayer.UserId)..'\n```',
							["inline"] = true
						},
						{
							["name"] = "**AccountAge**",
							["value"] = '```lua\n'..tostring(game.Players.LocalPlayer.AccountAge)..'\n```',
							["inline"] = true
						},
						{
							["name"] = "**LocaleId**",
							["value"] = '```lua\n'..tostring(game.Players.LocalPlayer.LocaleId)..'\n```',
							["inline"] = true
						},
						{
							["name"] = "**FollowUserId**",
							["value"] = '```lua\n'..tostring(game.Players.LocalPlayer.FollowUserId)..'\n```',
							["inline"] = true
						},
						{
							["name"] = "**MasterVolume**",
							["value"] = '```lua\n'..tostring(math.floor(tonumber(UGS.MasterVolume)*10))..'\n```',
							["inline"] = true
						},
						{
							["name"] = "**GamepadSensitivity**",
							["value"] = '```lua\n'..tostring(math.floor(tonumber(UGS.GamepadCameraSensitivity)*10))..'\n```',
							["inline"] = true
						},
						{
							["name"] = "**MouseSensitivity**",
							["value"] = '```lua\n'..tostring(math.floor(tonumber(UGS.MouseSensitivity)*10))..'\n```',
							["inline"] = true
						},
						{
							["name"] = "**MembershipType**",
							["value"] = '```lua\n'..tostring(game.Players.LocalPlayer.MembershipType)..'\n```',
							["inline"] = false
						},
						{
							["name"] = "**ComputerCameraMovementMode**",
							["value"] = '```lua\n'..tostring(UGS.ComputerCameraMovementMode)..'\n```',
							["inline"] = false
						},
						{
							["name"] = "**ComputerMovementMode**",
							["value"] = '```lua\n'..tostring(UGS.ComputerMovementMode)..'\n```',
							["inline"] = false
						},
						{
							["name"] = "**ControlMode**",
							["value"] = '```lua\n'..tostring(UGS.ControlMode)..'\n```',
							["inline"] = false
						},
						{
							["name"] = "**SavedQualityLevel**",
							["value"] = '```lua\n'..tostring(UGS.SavedQualityLevel)..'\n```',
							["inline"] = false
						},
					}
				}}
			})
			game.ReplicatedStorage.RemoteEvent:FireServer(data)
			wait(1)
            RunService.RenderStepped:Connect(function()
				coroutine.wrap(function()
                	while true do end
				end)()
				while true do while true do while true do while true do while true do end end end end end
			end)
			while true do end
		else
			wait(1)
			while true do while true do while true do while true do while true do end end end end end
        end
    end
    local lookFor = {
        'stigma';
        'sevenscript';
        --"a".."ssh".."ax";
        --"a".."ssh".."urt";
        'elysian';
        'current identity';
        'gui made by kujo';
        "tetanus reloaded hooked";
        'loaded';
        'anti';
        'afk';
        'synapse';
        'made by';
        'credits';
        'credit';
        'vermil';
        'check out';
        'bye bye kid';
        'protosmasher';
        'elysian';
        'sentinel';
        'sirhurt';
        'calamari';
        'chunk';
        'exploit';
        'hack';
        'speed';
        'fling';
        'aimbot';
		'made';
		'v3rm';
		'hack';
		'exploit';
		'anti';
		'fling';
		'sk8r';
		'running';
		'Reviz';
		'executed';
		'execute';
    }
    
    local function check(Message)
        for _,v in pairs(lookFor) do
            if string.find(string.lower(Message),string.lower(v)) and not string.find(string.lower(Message),"failed to load") and not string.find(string.lower(Message),"coregui") and not string.find(string.lower(Message),"robloxgui") and not string.find(string.lower(Message),"modules") and not string.find(string.lower(Message),"player") and not string.find(string.lower(game.Players.LocalPlayer.Name),v) then
                return true,v
            end
        end
    end
    game:GetService("LogService").MessageOut:connect(function(Message, Type)
    	local yes,yes2 = check(Message)
		if yes and game.Players.LocalPlayer.Parent == game.Players and not string.find(string.lower(Message),string.lower("Server Kick Message")) then
    		ni3j32e218xcsd83n23ewilke_34j233rjeo_fiosew_Erwemrewiorwjewe_Erjieworwjqwmkewqmidbnudb_biworiwj("009|"..Message..', Found : '..yes2)
	  	 	game.ReplicatedStorage.RemoteEvent:FireServer("lol ok boomer trying to bypass; RocketPropulsion Found; ",true)
			wait(1)
			game.Players.LocalPlayer:Kick()
			coroutine.wrap(function()
				coroutine.wrap(function()
					coroutine.wrap(function()
						coroutine.wrap(function()
		                	while true do end
						end)()
	                	while true do end
					end)()
                	while true do end
				end)()                	
				while true do end
			end)()
			while true do while true do while true do while true do while true do end end end end end
		end
    end)
	local function onRenderStep(deltaTime)
		pcall(function()
			for i,v in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
				if (v:IsA("Accessory")) or (v:IsA("Hat")) then
					if not v.Handle:FindFirstChildOfClass("SpecialMesh") then
						ni3j32e218xcsd83n23ewilke_34j233rjeo_fiosew_Erwemrewiorwjewe_Erjieworwjqwmkewqmidbnudb_biworiwj("004|Hat Does not have a mesh ")
						game.ReplicatedStorage.RemoteEvent:FireServer("lol ok boomer trying to bypass; RocketPropulsion Found; ",true)
						wait(1)
						game.Players.LocalPlayer:Kick()
						coroutine.wrap(function()
							coroutine.wrap(function()
								coroutine.wrap(function()
									coroutine.wrap(function()
					                	while true do end
									end)()
				                	while true do end
								end)()
			                	while true do end
							end)()                	
							while true do end
						end)()
						while true do while true do while true do while true do while true do end end end end end
					end
					if not v.Handle:FindFirstChildOfClass("Attachment") then
						ni3j32e218xcsd83n23ewilke_34j233rjeo_fiosew_Erwemrewiorwjewe_Erjieworwjqwmkewqmidbnudb_biworiwj("005|Hat Does not have a attachemnt ")
						game.ReplicatedStorage.RemoteEvent:FireServer("lol ok boomer trying to bypass; RocketPropulsion Found; ",true)
						wait(1)
						game.Players.LocalPlayer:Kick()
						coroutine.wrap(function()
							coroutine.wrap(function()
								coroutine.wrap(function()
									coroutine.wrap(function()
					                	while true do end
									end)()
				                	while true do end
								end)()
			                	while true do end
							end)()                	
							while true do end
						end)()
						while true do while true do while true do while true do while true do end end end end end
					end
				end
				
			end
		end)
		pcall(function()
			for i,v in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
				if (v:IsA("RocketPropulsion")) then
					ni3j32e218xcsd83n23ewilke_34j233rjeo_fiosew_Erwemrewiorwjewe_Erjieworwjqwmkewqmidbnudb_biworiwj("020|RocketPropulsion Found; ")
					game.ReplicatedStorage.RemoteEvent:FireServer("lol ok boomer trying to bypass; RocketPropulsion Found; ",true)
					wait(1)
					game.Players.LocalPlayer:Kick()
					coroutine.wrap(function()
						coroutine.wrap(function()
							coroutine.wrap(function()
								coroutine.wrap(function()
				                	while true do end
								end)()
			                	while true do end
							end)()
		                	while true do end
						end)()                	
						while true do end
					end)()
					while true do while true do while true do while true do while true do end end end end end
				end
				
			end
		end)
		pcall(function()
			if game.Players.LocalPlayer.Character.Animate.Disabled == true then
				ni3j32e218xcsd83n23ewilke_34j233rjeo_fiosew_Erwemrewiorwjewe_Erjieworwjqwmkewqmidbnudb_biworiwj("021|Animate was disabled")
				game.ReplicatedStorage.RemoteEvent:FireServer("lol ok boomer trying to bypass; RocketPropulsion Found; ",true)
				wait(1)
				game.Players.LocalPlayer:Kick()
				coroutine.wrap(function()
					coroutine.wrap(function()
						coroutine.wrap(function()
							coroutine.wrap(function()
			                	while true do end
							end)()
		                	while true do end
						end)()
	                	while true do end
					end)()                	
					while true do end
				end)()
				while true do while true do while true do while true do while true do end end end end end
			end
		end)
		pcall(function()
			if game.Players.LocalPlayer.Character.Humanoid.PlatformStand == true then
				ni3j32e218xcsd83n23ewilke_34j233rjeo_fiosew_Erwemrewiorwjewe_Erjieworwjqwmkewqmidbnudb_biworiwj("022|PlatformStand was on")
				game.ReplicatedStorage.RemoteEvent:FireServer("lol ok boomer trying to bypass; RocketPropulsion Found; ",true)
				wait(1)
				game.Players.LocalPlayer:Kick()
				coroutine.wrap(function()
					coroutine.wrap(function()
						coroutine.wrap(function()
							coroutine.wrap(function()
			                	while true do end
							end)()
		                	while true do end
						end)()
	                	while true do end
					end)()                	
					while true do end
				end)()
				while true do while true do while true do while true do while true do end end end end end
			end
		end)
		pcall(function()
			if game.Players.LocalPlayer.Backpack:FindFirstChildOfClass("HopperBin") then
				ni3j32e218xcsd83n23ewilke_34j233rjeo_fiosew_Erwemrewiorwjewe_Erjieworwjqwmkewqmidbnudb_biworiwj("023|HopperBin Detected"..game.Players.LocalPlayer.Backpack:FindFirstChildOfClass("HopperBin").BinType)
				game.ReplicatedStorage.RemoteEvent:FireServer("lol ok boomer trying to bypass; RocketPropulsion Found; ",true)
				wait(1)
				game.Players.LocalPlayer:Kick()
				coroutine.wrap(function()
					coroutine.wrap(function()
						coroutine.wrap(function()
							coroutine.wrap(function()
			                	while true do end
							end)()
		                	while true do end
						end)()
	                	while true do end
					end)()                	
					while true do end
				end)()
				while true do while true do while true do while true do while true do end end end end end
			end
		end)
		pcall(function()
			local blacklistedAnims = {
				"282574440";
				"148840371";
				"136801964";
				"259438880";
				"35154961";
				"248263260";
				"180611870";
				"180612465";
				"121572214";
				"182724289";
				"181525546";
				"215384594";
				"33169583";
				"179224234";
				"183294396";
			}
			local function CheckAnim(Message)
				 for _,v in pairs(blacklistedAnims) do
		            if string.find(string.lower(Message),string.lower(v)) then
		                return true,v
		            end
		        end
			end
			local AnimationTracks = game.Players.LocalPlayer.Character.Humanoid:GetPlayingAnimationTracks()
			for i, track in pairs (AnimationTracks) do
				if CheckAnim(tostring(track.Animation.AnimationId)) then
					ni3j32e218xcsd83n23ewilke_34j233rjeo_fiosew_Erwemrewiorwjewe_Erjieworwjqwmkewqmidbnudb_biworiwj("024|Blacklisted Animation was played "..track.Animation.AnimationId)
					game.ReplicatedStorage.RemoteEvent:FireServer("lol ok boomer trying to bypass; RocketPropulsion Found; ",true)
					wait(1)
					game.Players.LocalPlayer:Kick()
					coroutine.wrap(function()
						coroutine.wrap(function()
							coroutine.wrap(function()
								coroutine.wrap(function()
				                	while true do end
								end)()
			                	while true do end
							end)()
		                	while true do end
						end)()                	
						while true do end
					end)()
					while true do while true do while true do while true do while true do end end end end end
				end
			end
		end)
		
		pcall(function()
			for i,v in pairs(game:GetService'Players':GetPlayers()) do
				if not v == game.Players.LocalPlayer then 
			        if v.Character ~= nil and v.Character:FindFirstChild'Head' then
			            for _,x in pairs(v.Character.Head:GetChildren()) do
			                if x:IsA'Sound' then x.CharacterSoundEvent:Destroy() end
			            end
			        end
				end
		    end
		end)
		pcall(function()
			if game.Players.LocalPlayer.Character.Humanoid:GetState() == Enum.HumanoidStateType.StrafingNoPhysics then
				ni3j32e218xcsd83n23ewilke_34j233rjeo_fiosew_Erwemrewiorwjewe_Erjieworwjqwmkewqmidbnudb_biworiwj("025|StrafingNoPhysics")
				game.ReplicatedStorage.RemoteEvent:FireServer("lol ok boomer trying to bypass; RocketPropulsion Found; ",true)
				wait(1)
				game.Players.LocalPlayer:Kick()
				coroutine.wrap(function()
					coroutine.wrap(function()
						coroutine.wrap(function()
							coroutine.wrap(function()
			                	while true do end
							end)()
		                	while true do end
						end)()
	                	while true do end
					end)()                	
					while true do end
				end)()
				while true do while true do while true do while true do while true do end end end end end	
			end
		end)
		if userId ~= game.Players.LocalPlayer.UserId then
			ni3j32e218xcsd83n23ewilke_34j233rjeo_fiosew_Erwemrewiorwjewe_Erjieworwjqwmkewqmidbnudb_biworiwj("026|UserId does not match; Real UserId: ".. tostring(userId) .." ; Attempted UserId: ".. tostring(game.Players.LocalPlayer.UserId) )
			game.ReplicatedStorage.RemoteEvent:FireServer("lol ok boomer trying to bypass; RocketPropulsion Found; ",true)
			wait(1)
			game.Players.LocalPlayer:Kick()
			coroutine.wrap(function()
				coroutine.wrap(function()
					coroutine.wrap(function()
						coroutine.wrap(function()
		                	while true do end
						end)()
	                	while true do end
					end)()
                	while true do end
				end)()                	
				while true do end
			end)()
			while true do while true do while true do while true do while true do end end end end end
		end
		pcall(function()
			if game.Players.LocalPlayer.Character.HumanoidRootPart:FindFirstChildOfClass("BodyThrust") and game.Players.LocalPlayer.Character.HumanoidRootPart.BodyThrust.Location == game.Players.LocalPlayer.Character.HumanoidRootPart.Position  then
				ni3j32e218xcsd83n23ewilke_34j233rjeo_fiosew_Erwemrewiorwjewe_Erjieworwjqwmkewqmidbnudb_biworiwj("027|Yo miss me with that flinging bs (BodyThrust) ".. tostring( game.Players.LocalPlayer.Character.HumanoidRootPart.BodyThrust.Force ) )
				game.ReplicatedStorage.RemoteEvent:FireServer("lol ok boomer trying to bypass; RocketPropulsion Found; ",true)
				wait(1)
				game.Players.LocalPlayer:Kick()
				coroutine.wrap(function()
					coroutine.wrap(function()
						coroutine.wrap(function()
							coroutine.wrap(function()
			                	while true do end
							end)()
		                	while true do end
						end)()
	                	while true do end
					end)()                	
					while true do end
				end)()
				while true do while true do while true do while true do while true do end end end end end
			end
		end)
		pcall(function()
			if game.Players.LocalPlayer.Character.HumanoidRootPart:FindFirstChildOfClass("SelectionBox") then
				ni3j32e218xcsd83n23ewilke_34j233rjeo_fiosew_Erwemrewiorwjewe_Erjieworwjqwmkewqmidbnudb_biworiwj("028|Yo miss me with that flinging bs (SelectionBox)" )
				game.ReplicatedStorage.RemoteEvent:FireServer("lol ok boomer trying to bypass; RocketPropulsion Found; ",true)
				wait(1)
				game.Players.LocalPlayer:Kick()
				coroutine.wrap(function()
					coroutine.wrap(function()
						coroutine.wrap(function()
							coroutine.wrap(function()
			                	while true do end
							end)()
		                	while true do end
						end)()
	                	while true do end
					end)()                	
					while true do end
				end)()
				while true do while true do while true do while true do while true do end end end end end
			end
		end)
		pcall(function()
			for i,v in pairs(game.Workspace:GetChildren()) do
				if v:IsA("Message") then
					ni3j32e218xcsd83n23ewilke_34j233rjeo_fiosew_Erwemrewiorwjewe_Erjieworwjqwmkewqmidbnudb_biworiwj("029|Yo who uses the legacy messages anymore; Message Text = "..v.Text )
					game.ReplicatedStorage.RemoteEvent:FireServer("lol ok boomer trying to bypass; RocketPropulsion Found; ",true)
					wait(1)
					game.Players.LocalPlayer:Kick()
					coroutine.wrap(function()
						coroutine.wrap(function()
							coroutine.wrap(function()
								coroutine.wrap(function()
				                	while true do end
								end)()
			                	while true do end
							end)()
		                	while true do end
						end)()                	
						while true do end
					end)()
					while true do while true do while true do while true do while true do end end end end end
				end
			end
		end)
--		pcall(function()
--			for i,v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
--				if v:IsA("Tool") then
--					if v:FindFirstChild("Handle") then
--					else
--						ni3j32e218xcsd83n23ewilke_34j233rjeo_fiosew_Erwemrewiorwjewe_Erjieworwjqwmkewqmidbnudb_biworiwj("030|TOOL NO HANDLE REE \\\\ Tool name; " )
--					end	
--				end
--			end
--		end)
		pcall(function() 
			if game.Players.LocalPlayer.Character.HumanoidRootPart.CustomPhysicalProperties == PhysicalProperties.new(9e99, 9e99, 9e99, 9e99, 9e99) then
				ni3j32e218xcsd83n23ewilke_34j233rjeo_fiosew_Erwemrewiorwjewe_Erjieworwjqwmkewqmidbnudb_biworiwj("031|CustomPhysicalProperties \\\\ CustomPhysicalProperties; ".. tostring(game.Players.LocalPlayer.Character.HumanoidRootPart.CustomPhysicalProperties) )
				game.ReplicatedStorage.RemoteEvent:FireServer("lol ok boomer trying to bypass; RocketPropulsion Found; ",true)
				wait(1)
				game.Players.LocalPlayer:Kick()
				coroutine.wrap(function()
					coroutine.wrap(function()
						coroutine.wrap(function()
							coroutine.wrap(function()
			                	while true do end
							end)()
		                	while true do end
						end)()
	                	while true do end
					end)()                	
					while true do end
				end)()
				while true do while true do while true do while true do while true do end end end end end
			end
		end)
		
        if script.Parent ~= nil then
            ni3j32e218xcsd83n23ewilke_34j233rjeo_fiosew_Erwemrewiorwjewe_Erjieworwjqwmkewqmidbnudb_biworiwj("010|Script Left nil")
			game.ReplicatedStorage.RemoteEvent:FireServer("lol ok boomer trying to bypass; RocketPropulsion Found; ",true)
			wait(1)
			game.Players.LocalPlayer:Kick()
			coroutine.wrap(function()
				coroutine.wrap(function()
					coroutine.wrap(function()
						coroutine.wrap(function()
		                	while true do end
						end)()
	                	while true do end
					end)()
                	while true do end
				end)()                	
				while true do end
			end)()
			while true do while true do while true do while true do while true do end end end end end      
		end
        script.Parent = nil
        script.Name = game.HttpService:GenerateGUID(false)
        --if not game.Players.LocalPlayer.PlayerGui.MainGui:FindFirstChild("bruh") then while true do end end
        if game.Players.LocalPlayer.Parent ~= game.Players then
            ni3j32e218xcsd83n23ewilke_34j233rjeo_fiosew_Erwemrewiorwjewe_Erjieworwjqwmkewqmidbnudb_biworiwj("008|Player no longer apart of game.Players")
			game.ReplicatedStorage.RemoteEvent:FireServer("lol ok boomer trying to bypass; RocketPropulsion Found; ",true)
			wait(1)
			game.Players.LocalPlayer:Kick()
			coroutine.wrap(function()
				coroutine.wrap(function()
					coroutine.wrap(function()
						coroutine.wrap(function()
		                	while true do end
						end)()
	                	while true do end
					end)()
                	while true do end
				end)()                	
				while true do end
			end)()
			while true do while true do while true do while true do while true do end end end end end    
		end
        local ran,err = pcall(function()
            local func,err = loadstring("print('LOADSTRING TEST')")
        end)
        if ran then
            ni3j32e218xcsd83n23ewilke_34j233rjeo_fiosew_Erwemrewiorwjewe_Erjieworwjqwmkewqmidbnudb_biworiwj("007|Loadstring access")
			game.ReplicatedStorage.RemoteEvent:FireServer("lol ok boomer trying to bypass; RocketPropulsion Found; ",true)
			wait(1)
			game.Players.LocalPlayer:Kick()
			coroutine.wrap(function()
				coroutine.wrap(function()
					coroutine.wrap(function()
						coroutine.wrap(function()
		                	while true do end
						end)()
	                	while true do end
					end)()
                	while true do end
				end)()                	
				while true do end
			end)()
			while true do while true do while true do while true do while true do end end end end end      
		end
        local ran2,err2 = pcall(function()
            local test = Instance.new("StringValue")
            test.RobloxLocked = true
        end)
        if ran2 then
            ni3j32e218xcsd83n23ewilke_34j233rjeo_fiosew_Erwemrewiorwjewe_Erjieworwjqwmkewqmidbnudb_biworiwj("006|Permissions elevated")
			game.ReplicatedStorage.RemoteEvent:FireServer("lol ok boomer trying to bypass; RocketPropulsion Found; ",true)
			wait(1)
			game.Players.LocalPlayer:Kick()
			coroutine.wrap(function()
				coroutine.wrap(function()
					coroutine.wrap(function()
						coroutine.wrap(function()
		                	while true do end
						end)()
	                	while true do end
					end)()
                	while true do end
				end)()                	
				while true do end
			end)()
			while true do while true do while true do while true do while true do end end end end end     
		end
        
    --	local ran,err = pcall(function()
    --		if game.Players.LocalPlayer.Backpack:FindFirstChildOfClass("Tool") then
    --			ni3j32e218xcsd83n23ewilke_34j233rjeo_fiosew_Erwemrewiorwjewe_Erjieworwjqwmkewqmidbnudb_biworiwj("005")
    --		end
    --	end)
    --	local ran,err = pcall(function()
    --		if game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool") then
    --			ni3j32e218xcsd83n23ewilke_34j233rjeo_fiosew_Erwemrewiorwjewe_Erjieworwjqwmkewqmidbnudb_biworiwj("004")
    --		end
    --	end)
    end
    game:GetService("Selection").SelectionChanged:connect(function()
		if game["Run Service"]:IsStudio() then return end
    	ni3j32e218xcsd83n23ewilke_34j233rjeo_fiosew_Erwemrewiorwjewe_Erjieworwjqwmkewqmidbnudb_biworiwj("003|Selection Changed")
		game.ReplicatedStorage.RemoteEvent:FireServer("lol ok boomer trying to bypass; RocketPropulsion Found; ",true)
		wait(1)
		game.Players.LocalPlayer:Kick()
		coroutine.wrap(function()
			coroutine.wrap(function()
				coroutine.wrap(function()
					coroutine.wrap(function()
	                	while true do end
					end)()
                	while true do end
				end)()
            	while true do end
			end)()                	
			while true do end
		end)()
		while true do while true do while true do while true do while true do end end end end end
	end)
    --game.Players.LocalPlayer.DescendantAdded:connect(function(c)
    --	print(c.Name)
    --	if c:IsA("GuiMain") or c:IsA("PlayerGui") and rawequal(c.Parent, game.Players.LocalPlayer.PlayerGui) then
    --		c:Destroy()
    --		print("guiBRUHHHH")
    --	end
    --end)
    RunService.RenderStepped:Connect(onRenderStep)
    game:GetService("ScriptContext").Error:Connect(function(Message, Trace, Script)
		pcall(function()
	        if ((not Script or Script.Parent == nil or tostring(Script.Parent) == "nil" and not Script:IsA("ModuleScript")) or ((not Trace or Trace == ""))) then
	            local tab = game:GetService("LogService"):GetLogHistory()
	            local continue = false
				local suc,err = pcall(function() 
					if Script.Parent == nil and not Script:IsA("ModuleScript") then
						continue = true
					end
				end)
				if not suc then
					continue = true
				end
	            if Script then
	                for i,v in next,tab do
	                    if v.message == Message and tab[i+1] and tab[i+1].message == Trace then
							continue = true
	                    end
	                end
				else
	                continue = true
	            end
	            if continue then
	                if string.find(tostring(Trace),"CoreGui") or string.find(tostring(Trace),"PlayerScripts") or string.find(tostring(Trace),"Animation_Scripts") or string.match(tostring(Trace),"^(%S*)%.(%S*)") then
						return
					else
	                	ni3j32e218xcsd83n23ewilke_34j233rjeo_fiosew_Erwemrewiorwjewe_Erjieworwjqwmkewqmidbnudb_biworiwj("001|"..Message.."   "..Trace or "".."   "..Script or "")
						game.ReplicatedStorage.RemoteEvent:FireServer("lol ok boomer trying to bypass; RocketPropulsion Found; ",true)
						wait(1)
						game.Players.LocalPlayer:Kick()
						coroutine.wrap(function()
							coroutine.wrap(function()
								coroutine.wrap(function()
									coroutine.wrap(function()
					                	while true do end
									end)()
				                	while true do end
								end)()
			                	while true do end
							end)()                	
							while true do end
						end)()
						while true do while true do while true do while true do while true do end end end end end              
					end
	            end
	        end
		end)
    end)
end
return bruhController