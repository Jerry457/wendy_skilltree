local AddPrefabPostInit = AddPrefabPostInit
GLOBAL.setfenv(1, GLOBAL)
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
