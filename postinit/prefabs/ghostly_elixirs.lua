local AddPrefabPostInit = AddPrefabPostInit
GLOBAL.setfenv(1, GLOBAL)
--
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

    inst.components.ghostlyelixir.doapplyelixerfn = DoApplyReviveElixir

    inst.potion_tunings.ONAPPLY = function(inst, target)
        SetbonusHaelath(target, 300)
    end
    inst.potion_tunings.ONDETACH = function(inst, target)
        SetbonusHaelath(target, 0)
    end

    inst.potion_tunings.DURATION = 99999999999
end)

for type, enemy in pairs({lunar = "shadow", shadow = "lunar"}) do
	local potion_prefab = "ghostlyelixir_" .. type
	local buff_prefab = potion_prefab .. "_buff"

    AddPrefabPostInit(potion_prefab, function(inst)
        inst:RemoveTag("super_elixir")
    end)

    AddPrefabPostInit(buff_prefab, function(inst)
        if not TheWorld.ismastersim then
            return
        end

        inst.potion_tunings.ONAPPLY = function(inst, target)
            local damagetyperesist = target.components.damagetyperesist
            if damagetyperesist then
                damagetyperesist:AddResist(type .. "_aligned", inst, 0.95, potion_prefab)
            end
            local damagetypebonus = target.components.damagetypebonus
            if damagetypebonus then
                damagetypebonus:AddBonus(enemy .. "_aligned", inst, 1.05, potion_prefab)
            end
        end
        inst.potion_tunings.ONAPPLY_PLAYER = inst.potion_tunings.ONAPPLY

        inst.potion_tunings.ONDETACH = function(inst, target)
            local damagetyperesist = target.components.damagetyperesist
            if damagetyperesist then
                damagetyperesist:RemoveResist(type .. "_aligned", inst, potion_prefab)
            end
            local damagetypebonus = target.components.damagetypebonus
            if damagetypebonus then
                damagetypebonus:RemoveBonus(enemy .. "_aligned", inst, 1.05, potion_prefab)
            end
        end
        inst.potion_tunings.ONDETACH_PLAYER = inst.potion_tunings.ONDETACH
    end)
end
