local AddPrefabPostInit = AddPrefabPostInit
GLOBAL.setfenv(1, GLOBAL)

local function ApplyDebuff(inst, data)
	local target = data ~= nil and data.target
	if target and target:HasTag("shadowcreature") then
        local ghostlybond = inst.components.ghostlybond
        if ghostlybond and ghostlybond.ghost and ghostlybond.summoned and ghostlybond.ghost:HasDebuff("abigail_murder_buff") then
            target:AddDebuff("abigail_vex_debuff", "abigail_vex_shadow_debuff", nil, nil, nil, inst)
        end
	end
end

AddPrefabPostInit("wendy", function(inst)
    if not TheWorld.ismastersim then
        return
    end

    local checkforshadowsacrifice = inst:GetEventCallbacks("murdered", inst, "scripts/prefabs/wendy.lua")
    inst:RemoveEventCallback("murdered", checkforshadowsacrifice)

    inst:ListenForEvent("onattackother", ApplyDebuff)
end)
