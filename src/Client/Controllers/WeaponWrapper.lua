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
end


return WeaponWrapper