local assets = {
    Asset("ANIM", "anim/flowers_evil.zip"),
    Asset("ANIM", "anim/flowers_petals.zip"),
}

local function flowers_evil()
    local inst = Prefabs["sisturn_moon_petal_fx"].fn()
    inst.AnimState:OverrideSymbol("flowers_lunar", "flowers_evil", "flowers_evil")
    return inst
end

local function flowers_petals()
    local inst = Prefabs["sisturn_moon_petal_fx"].fn()
    inst.AnimState:OverrideSymbol("flowers_lunar", "flowers_petals", "flowers_petals")
    return inst
end

return Prefab("sisturn_evil_petal_fx", flowers_evil, assets),
       Prefab("sisturn_normal_petal_fx", flowers_petals, assets)
