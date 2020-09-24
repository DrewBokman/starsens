-- Weapon Class
-- DrewBokman
-- September 20, 2020



local WeaponClass = {}
WeaponClass.__index = WeaponClass


function WeaponClass.new(Config,WeaponName)

	local self = setmetatable({
		WeaponName = WeaponName,
		WeaponConfig = require(Config)
	}, WeaponClass)

	return self

end



return WeaponClass