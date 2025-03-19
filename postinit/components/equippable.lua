GLOBAL.setfenv(1, GLOBAL)

local Equippable = require("components/equippable")

local _GetWalkSpeedMult = Equippable.GetWalkSpeedMult
function Equippable:GetWalkSpeedMult(...)
    local owner = self.inst.components.inventoryitem and self.inst.components.inventoryitem.owner
    if self.isequipped and owner and owner:HasTag("vigorbuff") then
        return 1
    end

    return  _GetWalkSpeedMult(self, ...)
end
