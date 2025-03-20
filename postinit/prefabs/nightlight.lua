local AddPrefabPostInit = AddPrefabPostInit
GLOBAL.setfenv(1, GLOBAL)

local function DoMutate(inst, doer)
    local ghostlybond = doer.components.ghostlybond

    if ghostlybond == nil or ghostlybond.ghost == nil or not ghostlybond.summoned then
        return false, "NOGHOST"
    end

    if ghostlybond.ghost:HasTag("shadow_abigail") then
        ghostlybond.ghost:SetShadowToNormal()
        return true
    else
        return false, "NO_SHADOW"
    end
end

AddPrefabPostInit("nightlight", function(inst)
    if not TheWorld.ismastersim then
        return
    end

    inst:AddComponent("ghostgestalter")
    inst.components.ghostgestalter.domutatefn = DoMutate
end)
