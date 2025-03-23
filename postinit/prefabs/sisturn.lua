local AddPrefabPostInit = AddPrefabPostInit
GLOBAL.setfenv(1, GLOBAL)

local UpvalueUtil = require("utils/upvalue_util")

local function IsFullOfFlowers(inst)
    return inst.components.container and inst.components.container:IsFull()
end

local function getsisturnfeel(inst)
    local evil = inst.components.container:FindItems(function(item)
        if item.prefab == "petals_evil" then
            return true
        end
    end)

    local blossom = inst.components.container:FindItems(function(item)
        if item.prefab == "moon_tree_blossom" then
            return true
        end
    end)

    local petals = inst.components.container:FindItems(function(item)
        if item.prefab == "petals" then
            return true
        end
    end)

    if #evil > 3 then
        return "EVIL", "sisturn_evil_petal_fx"
    elseif #blossom > 3 then
        return "BLOSSOM", "sisturn_moon_petal_fx"
    elseif #petals > 3 then
        return "PETALS", "sisturn_normal_petal_fx"
    else
        return "NORMAL"
    end
end

local function update_sanityaura(inst)
    if IsFullOfFlowers(inst) then
        if not inst.components.sanityaura then
            inst:AddComponent("sanityaura")
        end
    elseif inst.components.sanityaura ~= nil then
        inst:RemoveComponent("sanityaura")
    end
end

local function update_abigail_status(inst)
    local is_full = IsFullOfFlowers(inst)

    if is_full then
        TheWorld:PushEvent("moon_blossom_sisturn",{ status = true })

        local state, petal_fx = inst:getsisturnfeel()
        if not inst.lune_fx and petal_fx then
            inst.lune_fx = SpawnPrefab(petal_fx)
            inst:AddChild(inst.lune_fx)
        elseif inst.lune_fx then
            inst.lune_fx.done = nil
            if inst.lune_fx.AnimState:IsCurrentAnimation("lunar_fx_pst") then
                inst.lune_fx.SoundEmitter:KillSound("loop")
                inst.lune_fx.SoundEmitter:PlaySound("meta5/wendy/sisturn_moonblossom_LP","loop")
                inst.lune_fx.AnimState:PlayAnimation("lunar_fx_pre")
                inst.lune_fx.AnimState:PushAnimation("lunar_fx_loop")
            end
        end
    else
        TheWorld:PushEvent("moon_blossom_sisturn",{ status = nil })
        if inst.lune_fx then
            inst.lune_fx.done = true
        end
    end
 end

local function OnFlowerPerished(item)
    item.components.perishable.onperishreplacement = "ghostflower"
end

local function OnItemChange(inst, data)
    if IsFullOfFlowers(inst) and inst._petal_preserve then
        if inst.components.timer:IsPaused("spawn_ghostflower") then
            inst.components.timer:ResumeTimer("spawn_ghostflower")
        elseif not inst.components.timer:TimerExists("spawn_ghostflower") then
            inst.components.timer:StartTimer("spawn_ghostflower", 180)
        end
    else
        inst.components.timer:PauseTimer("spawn_ghostflower")
    end
end

local function OnItemGet(inst, data)
    local item = data and data.item
    if item and item:HasTag("petal") and item.components.perishable and inst._petal_preserve then
        inst:ListenForEvent("perished", OnFlowerPerished, item)
    end
    OnItemChange(inst)
end

local function OnItemLose(inst, data)
    local item = data and data.prev_item
    if item and item.components.perishable then
        inst:RemoveEventCallback("perished", OnFlowerPerished, item)
    end
    OnItemChange(inst)
end

local function OnTimerDone(inst, data)
    inst.components.lootdropper:SpawnLootPrefab("ghostflower")
    OnItemChange(inst)
end

local function DoMutate(inst, doer)
    local ghostlybond = doer.components.ghostlybond
    if ghostlybond == nil or ghostlybond.ghost == nil or not ghostlybond.summoned then
        return false, "NOGHOST"
    end

    if not TheWorld.state.isnight or not TheWorld.state.iscavenight then
        return false, "NOTNIGHT"
    end

    if inst:getsisturnfeel() == "EVIL" then
        if TheWorld.state.isnightmarewild or TheWorld.state.isnewmoon or
            (not TheWorld.state.isfullmoon and not TheWorld.state.iswaxingmoon) then
                if not ghostlybond.ghost:HasTag("shadow_abigail") then
                    ghostlybond.ghost:SetToShadow()
                    return true
                else
                    return false, "MUTATED"
                end
        else
            return false, "NONEWMOON"
        end
    elseif inst:getsisturnfeel() == "BLOSSOM" then
        if TheWorld.state.isfullmoon or (not TheWorld.state.isnewmoon and TheWorld.state.iswaxingmoon) then
            if not ghostlybond.ghost:HasTag("gestalt") then
                ghostlybond.ghost:ChangeToGestalt(true)
                return true
            else
                return false, "MUTATED"
            end
        else
            return false, "NOFULLMOON"
        end
    else
        return false, "NOFEEL"
    end
end

AddPrefabPostInit("sisturn", function(inst)
    if not TheWorld.ismastersim then
        return
    end

    inst:AddComponent("ghostgestalter")
    inst.components.ghostgestalter.forcerightclickaction = true
    inst.components.ghostgestalter.domutatefn = DoMutate

    if not inst.components.timer then
        inst:AddComponent("timer")
    end

    inst.getsisturnfeel = getsisturnfeel
    UpvalueUtil.SetUpvalue(inst.components.inspectable.getstatus, getsisturnfeel, "getsisturnfeel")

    local remove_decor = inst:GetEventCallbacks("itemlose", inst, "scripts/prefabs/sisturn.lua")

    UpvalueUtil.SetUpvalue(remove_decor, update_sanityaura, "update_sanityaura")
    UpvalueUtil.SetUpvalue(remove_decor, update_abigail_status, "update_abigail_status")

    inst:ListenForEvent("itemget", OnItemGet)
    inst:ListenForEvent("itemlose", OnItemLose)
    inst:ListenForEvent("timerdone", OnTimerDone)

    inst:ListenForEvent("wendy_sisturnskillchanged", function(_, user)
        if user.userid == inst._builder_id and not inst:HasTag("burnt") then
            OnItemChange(inst)
            for i = 1, inst.components.container.numslots do
                local item = inst.components.container.slots[i]
                OnItemGet(inst, { item = item })
            end
        end
    end, TheWorld)
end)
