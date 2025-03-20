local AddPrefabPostInit = AddPrefabPostInit
GLOBAL.setfenv(1, GLOBAL)

local UpvalueUtil = require("utils/upvalue_util")

local petals = {
    "petals",
    "petals_evil",
    "moon_tree_blossom",
}

local function OnRegrow(prefab)
    return function (inst, doer)
        local ent = SpawnPrefab(prefab)
        local owner = inst.components.inventoryitem and inst.components.inventoryitem:GetGrandOwner() or nil
        if owner and owner.components.inventory then
            owner.components.inventory:GiveItem(ent)
        else
            local x, y, z = inst.Transform:GetWorldPosition()
            ent.Transform:SetPosition(x, y, z)
        end

        if doer.components.talker then
            doer.components.talker:Say("1234")
        end

        if inst.components.stackable then
            inst.components.stackable:Get():Remove()
        else
            inst:Remove()
        end

        return true
    end
end

AddPrefabPostInit("petals", function(inst)
    if not TheWorld.ismastersim then
        return
    end

    inst:AddComponent("mourningregrow")
    inst.components.mourningregrow:SetOnRegrowFn(OnRegrow("butterfly"))
end)

AddPrefabPostInit("petals_evil", function(inst)
    if not TheWorld.ismastersim then
        return
    end

    inst:AddComponent("mourningregrow")
    inst.components.mourningregrow:SetOnRegrowFn(OnRegrow("dark_butterfly"))
end)

AddPrefabPostInit("moon_tree_blossom", function(inst)
    if not TheWorld.ismastersim then
        return
    end

    inst:AddComponent("mourningregrow")
    inst.components.mourningregrow:SetOnRegrowFn(OnRegrow("moonbutterfly"))
end)

AddPrefabPostInit("fruitflyfruit", function(inst)
    if not TheWorld.ismastersim then
        return
    end

    inst:AddComponent("mourningregrow")
    inst.components.mourningregrow:SetOnRegrowFn(function(inst, doer)
        if not inst:HasTag("fruitflyfruit") then
            return false, "fruitflyfruit"
        elseif TheSim:FindFirstEntityWithTag("friendlyfruitfly") then
            return false, "alady cxczcxzczxc"
        end
        return OnRegrow("fruitflyfruit")
    end)
end)

AddPrefabPostInit("glommerflower", function(inst)
    if not TheWorld.ismastersim then
        return
    end

    inst:AddComponent("mourningregrow")
    inst.components.mourningregrow:SetOnRegrowFn(function(inst, doer)
        if not inst:HasTag("glommerflower") then
            return false, "Glommerflowers death"
        end
        return false, "Glommerflowers"
    end)
end)



AddPrefabPostInit("abigail_flower", function(inst)
    if not TheWorld.ismastersim then
        return
    end

    inst:AddComponent("mourningregrow")
    inst.components.mourningregrow:SetOnRegrowFn(function(inst, doer)
        return false, "abigail_flower"
    end)
end)

AddPrefabPostInit("chester_eyebone", function(inst)
    if not TheWorld.ismastersim then
        return
    end

    local RespawnChester = UpvalueUtil.GetUpvalue(inst.components.inventoryitem.onputininventoryfn, "FixChester.StartRespawn.RespawnChester")

    inst:AddComponent("mourningregrow")
    inst.components.mourningregrow:SetOnRegrowFn(function(inst, doer)
        if not inst.isOpenEye then
            RespawnChester(inst)
            if doer.components.talker then
                doer.components.talker:Say("chester_eyebone")
            end
            return true
        end
        return false, "chester_eyebone"
    end)
end)

AddPrefabPostInit("hutch_fishbowl", function(inst)
    if not TheWorld.ismastersim then
        return
    end

    local RespawnHutch = UpvalueUtil.GetUpvalue(inst.components.inventoryitem.onputininventoryfn, "FixHutch.StartRespawn.RespawnHutch")

    inst:AddComponent("mourningregrow")
    inst.components.mourningregrow:SetOnRegrowFn(function(inst, doer)
        if not inst.isFishAlive then
            RespawnHutch(inst)
            if doer.components.talker then
                doer.components.talker:Say("hutch_fishbowl")
            end
            return true
        end
        return false, "hutch_fishbowl"
    end)
end)

AddPrefabPostInit("hutch_fishbowl", function(inst)
    if not TheWorld.ismastersim then
        return
    end

    local RespawnHutch = UpvalueUtil.GetUpvalue(inst.components.inventoryitem.onputininventoryfn, "FixHutch.StartRespawn.RespawnHutch")

    inst:AddComponent("mourningregrow")
    inst.components.mourningregrow:SetOnRegrowFn(function(inst, doer)
        if not inst.isFishAlive then
            RespawnHutch(inst)
            if doer.components.talker then
                doer.components.talker:Say("hutch_fishbowl")
            end
            return true
        end
        return false, "hutch_fishbowl"
    end)
end)
