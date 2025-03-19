local AddPrefabPostInit = AddPrefabPostInit
GLOBAL.setfenv(1, GLOBAL)

local function DoMutate(inst, doer)
    local ghostlybond = doer.components.ghostlybond

    if ghostlybond == nil or ghostlybond.ghost == nil or not ghostlybond.summoned then
        return false, "NOGHOST"
    end

    if ghostlybond.ghost:HasDebuff("abigail_murder_buff") then
        ghostlybond.ghost:RemoveDebuff("abigail_murder_buff")
        return true
    else
        return false, "NO_SHADOW"
    end
end

AddPrefabPostInit("nightlight", function(inst)
    if not TheWorld.ismastersim then
        return
    end

    inst.components.ghostgestalter.domutatefn = DoMutate
end)
