local AddPrefabPostInit = AddPrefabPostInit
GLOBAL.setfenv(1, GLOBAL)

AddPrefabPostInit("ghostlyelixir_speed", function(inst)
    inst.potion_tunings.ONAPPLY_PLAYER = function(inst, target)
        target.components.locomotor:SetExternalSpeedMultiplier(inst, "ghostlyelixir_speed", 1.1)
    end
    inst.potion_tunings.ONAPPLY_PLAYER = function(inst, target)
        target.components.locomotor:RemoveExternalSpeedMultiplier(inst, "ghostlyelixir_speed")
    end
end)
