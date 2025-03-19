local AddPrefabPostInit = AddPrefabPostInit
GLOBAL.setfenv(1, GLOBAL)

local function DoMutate(inst, doer)
    local ghostlybond = doer.components.ghostlybond

    if ghostlybond == nil or ghostlybond.ghost == nil or not ghostlybond.summoned then
        return false, "NOGHOST"
    end

    if ghostlybond.ghost:HasTag("gestalt") then
        ghostlybond.ghost:ChangeToGestalt(false)
        return true
    else
        return false, "NO_GESTALT"
    end
end

AddPrefabPostInit("moondial", function(inst)
    if not TheWorld.ismastersim then
        return
    end

    inst.components.ghostgestalter.domutatefn = DoMutate
end)
