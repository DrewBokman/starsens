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

function WeaponWrapper:Start()

end

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

function WeaponWrapper:Init()
    if DiedCon then
        DiedCon:Disconnect()
    end
    for i,v in pairs(ConnectionTbl) do
        v:Disconnect()
    end
    inputs = self.Modules.InputService
    local Weps, AmmoData = self.Services.WeaponWrapper:New()

    for i,v in pairs(Weps) do
        local working
        local function equip()
            if game.Players.LocalPlayer.Gun.Value then
                self.Services.WeaponWrapper:UnEquip()
            else
                self.Services.WeaponWrapper:Equip(v)
            end
        end
        local con = inputs.BindOnBegan(nil,enumBinds[i],equip,"Equip : "..i)
        table.insert( ConnectionTbl, #ConnectionTbl, con )
    end
    DiedCon = game.Players.LocalPlayer.Character:WaitForChild("Humanoid").Died:Connect(function()
        game.Players.LocalPlayer.CharacterAdded:Wait()
        wait(1)
        WeaponWrapper:Init()
    end)
    local firing = false
    local function MouseAction(on)
        if on then
            firing = true
            if game.Players.LocalPlayer.Gun.Value then
                if require(self.Shared.WeaponSettings[game.Players.LocalPlayer.Gun.Value]).auto then
                    while firing do
                        wait()
                        self.Services.WeaponWrapper:Fire(workspace.CurrentCamera.CFrame.LookVector)
                    end
                end
            end
        else
            firing = false
        end
    end
    inputs.BindOnBegan("MouseButton1", nil, function() MouseAction(true) end, "PewPew")
    inputs.BindOnEnded("MouseButton1", nil, function() MouseAction(false) end, "PewPewEnd")
end


return WeaponWrapper