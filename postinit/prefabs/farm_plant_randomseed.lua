local AddPrefabPostInit = AddPrefabPostInit
GLOBAL.setfenv(1, GLOBAL)

AddPrefabPostInit("farm_plant_randomseed", function(inst)
    local GROWTH_STAGES_RANDOMSEED = inst.components.growable.stages[2]
    local _fn = GROWTH_STAGES_RANDOMSEED.fn
    GROWTH_STAGES_RANDOMSEED.fn = function(inst, ...)
        local weed_chance = TUNING.FARM_PLANT_RANDOMSEED_WEED_CHANCE

        if inst.no_weed then
            TUNING.FARM_PLANT_RANDOMSEED_WEED_CHANCE = 0
        end

        local ret = {_fn and _fn(inst, ...)}

        TUNING.FARM_PLANT_RANDOMSEED_WEED_CHANCE = weed_chance

        return unpack(ret)
    end
end)
