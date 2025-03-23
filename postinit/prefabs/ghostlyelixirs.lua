local AddPrefabPostInit = AddPrefabPostInit
local AddSimPostInit = AddSimPostInit
GLOBAL.setfenv(1, GLOBAL)

local fn = loadfile("prefabs/ghostly_elixirs")
local potions = {fn()}
local UpvalueUtil = require("utils/upvalue_util")

AddSimPostInit(function()
    local potion_tunings = UpvalueUtil.GetUpvalue(Prefabs["ghostlyelixir_speed"]._fn or Prefabs["ghostlyelixir_speed"].fn, "potion_tunings")
    potion_tunings["ghostlyelixir_speed"].ONAPPLY_PLAYER = function(inst, target)
        target.components.locomotor:SetExternalSpeedMultiplier(inst, "ghostlyelixir_speed", 1.1)
    end
    potion_tunings["ghostlyelixir_speed"].ONAPPLY_PLAYER = function(inst, target)
        target.components.locomotor:RemoveExternalSpeedMultiplier(inst, "ghostlyelixir_speed")
    end
    local function SetbonusHaelath(target, value)
        target.bonus_max_health = value

        local health = target.components.health
        if health then
            if health:IsDead() then
                health.maxhealth = target.base_max_health + target.bonus_max_health
            else
                local health_percent = health:GetPercent()
                health:SetMaxHealth(target.base_max_health + target.bonus_max_health)
                health:SetPercent(health_percent, true)
            end

            if target._playerlink ~= nil and target._playerlink.components.pethealthbar ~= nil then
                target._playerlink.components.pethealthbar:SetMaxHealth(health.maxhealth)
            end
        end
    end

    potion_tunings["ghostlyelixir_revive"].fx = "ghostlyelixir_revive_fx"
    potion_tunings["ghostlyelixir_revive"].dripfx = "ghostlyelixir_revive_dripfx"
    potion_tunings["ghostlyelixir_revive"].fx_player = "ghostlyelixir_player_revive_fx"
    potion_tunings["ghostlyelixir_revive"].dripfx_player = "ghostlyelixir_player_revive_dripfx"
    potion_tunings["ghostlyelixir_revive"].ONAPPLY = function(inst, target)
        SetbonusHaelath(target, 300)
    end
    potion_tunings["ghostlyelixir_revive"].ONDETACH = function(inst, target)
        SetbonusHaelath(target, 0)
    end
    potion_tunings["ghostlyelixir_revive"].DURATION = 1.79769313486231e+308


    for type, enemy in pairs({lunar = "shadow", shadow = "lunar"}) do
        local potion_prefab = "ghostlyelixir_" .. type
        local buff_prefab = potion_prefab .. "_buff"
        local potion_tuning = potion_tunings[potion_prefab]

        potion_tuning.ONAPPLY = function(inst, target)
            local damagetyperesist = target.components.damagetyperesist
            if damagetyperesist then
                damagetyperesist:AddResist(type .. "_aligned", inst, 0.95, potion_prefab)
            end
            local damagetypebonus = target.components.damagetypebonus
            if damagetypebonus then
                damagetypebonus:AddBonus(enemy .. "_aligned", inst, 1.05, potion_prefab)
            end
        end
        potion_tuning.ONAPPLY_PLAYER =  potion_tuning.ONAPPLY

        potion_tuning.ONDETACH = function(inst, target)
            local damagetyperesist = target.components.damagetyperesist
            if damagetyperesist then
                damagetyperesist:RemoveResist(type .. "_aligned", inst, potion_prefab)
            end
            local damagetypebonus = target.components.damagetypebonus
            if damagetypebonus then
                damagetypebonus:RemoveBonus(enemy .. "_aligned", inst, 1.05, potion_prefab)
            end
        end
        potion_tuning.ONDETACH_PLAYER = potion_tuning.ONDETACH

        potion_tuning.fx_player = "ghostlyelixir_player_" .. type .. "_fx"
        potion_tuning.dripfx_player = "ghostlyelixir_player_" .. type .."_dripfx"

    end
end)

AddPrefabPostInit("ghostlyelixir_revive", function(inst)
    if not TheWorld.ismastersim then
        return
    end
    inst.components.ghostlyelixir.doapplyelixerfn = function (inst, giver, target)
        local buff = target:AddDebuff(inst.buff_prefab, inst.buff_prefab)
        if buff then
            local new_buff = target:GetDebuff(inst.buff_prefab)
            new_buff:buff_skill_modifier_fn(giver, target)
            return buff
        end
    end

end)

for _, potion_prefab in pairs({"ghostlyelixir_lunar","ghostlyelixir_shadow"}) do
    AddPrefabPostInit(potion_prefab, function(inst)
        inst:RemoveTag("super_elixir")
    end)
end
