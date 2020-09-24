-- Saving Service
-- DrewBokman
-- September 8, 2020



local SavingService = {Client = {}}

-- local ProfileTemplate = {
--     Cash = 0,
--     Items = {},
--     LogInTimes = 0,
-- }

-- local ProfileService = require(script.Parent.Parent.Modules.ProfileService)

-- local Players = game:GetService("Players")

-- local GameProfileStore

-- local Profiles = {}

-- local function GiveCash(profile, amount)
--     if profile.Data.Cash == nil then
--         profile.Data.Cash = 0
--     end
--     profile.Data.Cash = profile.Data.Cash + amount
-- end

-- local function DoSomethingWithALoadedProfile(player, profile)
-- 	print(profile.MetaData.ActiveSession["game_job_id"],profile.MetaData.SessionLoadCount,profile.MetaData.ProfileCreateTime)
--     profile.Data.LogInTimes = profile.Data.LogInTimes + 1
--     print(player.Name .. " has logged in " .. tostring(profile.Data.LogInTimes)
--         .. " time" .. ((profile.Data.LogInTimes > 1) and "s" or ""))
--     GiveCash(profile, 100)
--     print(player.Name .. " owns " .. tostring(profile.Data.Cash) .. " now!")
-- end

-- local function PlayerAdded(player)
--     local profile = GameProfileStore:LoadProfileAsync(
--         "Player_" .. player.UserId,
--         "ForceLoad"
--     )
--     if profile ~= nil then
--         profile:ListenToRelease(function()
--             Profiles[player] = nil
--             -- The profile could've been loaded on another Roblox server:
--             player:Kick()
--         end)
--         if player:IsDescendantOf(Players) == true then
--             Profiles[player] = profile
--             -- A profile has been successfully loaded:
--             DoSomethingWithALoadedProfile(player, profile)
--         else
--             -- Player left before the profile loaded:
--             profile:Release()
--         end
--     else
--         -- The profile couldn't be loaded possibly due to other
--         --   Roblox servers trying to load this profile at the same time:
--         player:Kick()
--     end
-- end

-- function SavingService:Start()

-- end


-- function SavingService:Init()
-- 	--repeat wait() until self.Modules.ProfileService
--     GameProfileStore = ProfileService.GetProfileStore(
--         "PlayerData",
--         ProfileTemplate
--     )
--     for _, player in ipairs(Players:GetPlayers()) do
--         coroutine.wrap(PlayerAdded)(player)
--     end
--     Players.PlayerAdded:Connect(PlayerAdded)
--     Players.PlayerRemoving:Connect(function(player)
--         local profile = Profiles[player]
--         if profile ~= nil then
--             profile:Release()
--         end
--     end)
-- end


return SavingService