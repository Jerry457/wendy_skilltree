local AddPrefabPostInit = AddPrefabPostInit
GLOBAL.setfenv(1, GLOBAL)

local UpvalueUtil = require("utils/upvalue_util")

AddPrefabPostInit("abigail_murder_buff", function(inst)
    if not TheWorld.ismastersim then
        return
    end

    inst.persists = true

    inst.murder_buff_OnExtended = function() end
    inst.components.debuff:SetExtendedFn(inst.murder_buff_OnExtended)

    local _onattachedfn = inst.components.debuff.onattachedfn
    UpvalueUtil.SetUpvalue(_onattachedfn, inst.murder_buff_OnExtended, "murder_buff_OnExtended")

    inst.components.debuff.onattachedfn = function(inst, target, ...)
        target:AddTag("shadow_abigail")
        _onattachedfn(inst, target, ...)
        local OnDeath = inst:GetEventCallbacks("death", target, "scripts/prefabs/abigail.lua")
        inst:RemoveEventCallback("death", OnDeath, target)
    end

    local _ondetachedfn = inst.components.debuff.ondetachedfn
    inst.components.debuff.ondetachedfn = function(inst, target, ...)
        target:RemoveTag("shadow_abigail")
        inst.decaytimer = inst:DoTaskInTime(0, function() end)
        _ondetachedfn(inst, target, ...)
    end
end)
