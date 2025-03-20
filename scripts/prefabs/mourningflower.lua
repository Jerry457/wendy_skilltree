local assets =
{
    Asset("ANIM", "anim/mourningflower.zip"),
    Asset("IMAGE", "images/mourningflower.tex"),
    Asset("ATLAS", "images/mourningflower.xml"),
}

RegisterInventoryItemAtlas(resolvefilepath("images/mourningflower.xml"), "mourningflower.tex")
RegisterInventoryItemAtlas(resolvefilepath("images/mourningflower.xml"), hash("mourningflower.tex"))

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    -- inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("mourningflower")
    inst.AnimState:SetBuild("mourningflower")
    inst.AnimState:PlayAnimation("idle_loop", true)
    inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
    MakeInventoryPhysics(inst)

    -- inst.scrapbook_deps = {"ghostflower","nightmarefuel"}

    -- inst.MiniMapEntity:SetIcon("mourningflower.tex")

    MakeInventoryFloatable(inst, "small", 0.15, 0.9)

    inst:AddTag("mourningflower")
    -- inst:AddTag("give_dolongaction")
    -- inst:AddTag("ghostlyelixirable") -- for ghostlyelixirable component

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")

    inst:AddComponent("lootdropper")

    inst:AddComponent("mourningflower")

    MakeSmallBurnable(inst, TUNING.SMALL_BURNTIME)
    inst.components.burnable.fxdata = {}
    inst.components.burnable:AddBurnFX("campfirefire", Vector3(0, 0, 0))

    MakeSmallPropagator(inst)
    MakeHauntableLaunch(inst)

    return inst
end

return Prefab("mourningflower", fn, assets)
