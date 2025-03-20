local AddPrefabPostInit = AddPrefabPostInit
GLOBAL.setfenv(1, GLOBAL)

local UpvalueUtil = require("utils/upvalue_util")

local function SetToGestalt(inst)
    inst:AddTag("gestalt")
    inst:AddTag("crazy")
    inst.components.aura:Enable(false)
    inst.AnimState:SetBuild("ghost_abigail_gestalt_build")

    inst.AnimState:OverrideSymbol("fx_puff2",       "lunarthrall_plant_front",      "fx_puff2")
    inst.AnimState:OverrideSymbol("v1_ball_loop",   "brightmare_gestalt_evolved",   "v1_ball_loop")
    inst.AnimState:OverrideSymbol("v1_embers",      "brightmare_gestalt_evolved",   "v1_embers")
    inst.AnimState:OverrideSymbol("v1_melt2",       "brightmare_gestalt_evolved",   "v1_melt2")

    inst.components.combat:SetAttackPeriod(3)
    inst.components.combat.attackrange = 6

    -- 原版月亮药剂的效果
    inst.components.planardamage:AddBonus(inst, TUNING.SKILLS.WENDY.LUNARELIXIR_DAMAGEBONUS, "ghostlyelixir_lunarbonus")
end

local function SetToNormal(inst)
    inst:RemoveTag("gestalt")
    inst:RemoveTag("crazy")
    inst.components.aura:Enable(true)
    inst.AnimState:SetBuild("ghost_abigail_build")

    inst.AnimState:ClearOverrideSymbol("fx_puff2")
    inst.AnimState:ClearOverrideSymbol("v1_ball_loop")
    inst.AnimState:ClearOverrideSymbol("v1_embers")
    inst.AnimState:ClearOverrideSymbol("v1_melt2")

    inst.components.combat:SetAttackPeriod(4)
    inst.components.combat.attackrange = 3

    -- 原版月亮药剂的效果
    inst.components.planardamage:RemoveBonus(inst, "ghostlyelixir_lunarbonus")
end

local function ApplyDebuff(inst, data)
    local target = data ~= nil and data.target
    if target ~= nil then
        local buff = "abigail_vex_debuff"

        if inst:HasTag("shadow_abigail") then  -- 原来暗影药剂效果
            buff = "abigail_vex_shadow_debuff"
        end

        local olddebuff = target:GetDebuff("abigail_vex_debuff")
        if olddebuff and olddebuff.prefab ~= buff then
            target:RemoveDebuff("abigail_vex_debuff")
        end

        target:AddDebuff("abigail_vex_debuff", buff, nil, nil, nil, inst)

        local debuff = target:GetDebuff("abigail_vex_debuff")

        local skin_build = inst:GetSkinBuild()
        if skin_build ~= nil and debuff ~= nil then
            debuff.AnimState:OverrideItemSkinSymbol("flower", skin_build, "flower", inst.GUID, "abigail_attack_fx" )
        end
    end
end

local function SetToShadow(inst)
    local x, y, z = inst.Transform:GetWorldPosition()
    SpawnPrefab("abigail_attack_shadow_fx").Transform:SetPosition(x,y,z)
    local fx = SpawnPrefab("abigail_shadow_buff_fx")
    inst:AddChild(fx)
    inst.SoundEmitter:PlaySound("meta5/abigail/abigail_nightmare_buff_stinger")
    inst:AddDebuff("abigail_murder_buff", "abigail_murder_buff")
end

local function SetShadowToNormal(inst)
    inst:RemoveDebuff("abigail_murder_buff")
end

AddPrefabPostInit("abigail", function(inst)
    if not TheWorld.ismastersim then
        return
    end

    inst.SetToNormal = SetToNormal
    inst.SetToGestalt = SetToGestalt

    inst.SetToShadow = SetToShadow
    inst.SetShadowToNormal = SetShadowToNormal

    inst.DoShadowBurstBuff = function() end

    UpvalueUtil.SetUpvalue(inst.OnLoad, SetToGestalt, "SetToGestalt")
    UpvalueUtil.SetUpvalue(inst.LinkToPlayer, ApplyDebuff, "ApplyDebuff")

    inst.UpdateBonusHealth = function() end
    local OnHealthChanged = inst:GetEventCallbacks("pre_health_setval", inst, "scripts/prefabs/abigail.lua")
    inst:RemoveEventCallback("pre_health_setval", OnHealthChanged)
end)
