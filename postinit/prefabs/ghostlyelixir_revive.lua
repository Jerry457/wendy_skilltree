local AddPrefabPostInit = AddPrefabPostInit
GLOBAL.setfenv(1, GLOBAL)

local function DoApplyReviveElixir(inst, giver, target)
    local buff = target:AddDebuff(inst.buff_prefab, inst.buff_prefab)
    if buff then
        local new_buff = target:GetDebuff(inst.buff_prefab)
        new_buff:buff_skill_modifier_fn(giver, target)
        return buff
    end
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

AddPrefabPostInit("ghostlyelixir_revive", function(inst)
    if not TheWorld.ismastersim then
        return
    end

    inst.potion_tunings.fx = "ghostlyelixir_revive_fx"
    inst.potion_tunings.dripfx = "ghostlyelixir_revive_dripfx"
    inst.potion_tunings.fx_player = "ghostlyelixir_player_revive_fx"
    inst.potion_tunings.dripfx_player = "ghostlyelixir_player_revive_dripfx"

    inst.components.ghostlyelixir.doapplyelixerfn = DoApplyReviveElixir

    inst.potion_tunings.ONAPPLY = function(inst, target)
        SetbonusHaelath(target, 300)
    end
    inst.potion_tunings.ONDETACH = function(inst, target)
        SetbonusHaelath(target, 0)
    end

    inst.potion_tunings.DURATION = 1.79769313486231e+308
end)
