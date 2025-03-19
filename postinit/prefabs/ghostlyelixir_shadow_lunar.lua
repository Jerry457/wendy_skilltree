local AddPrefabPostInit = AddPrefabPostInit
GLOBAL.setfenv(1, GLOBAL)

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
