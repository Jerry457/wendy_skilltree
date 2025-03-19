local AddPrefabPostInit = AddPrefabPostInit
local AddGamePostInit = AddGamePostInit
GLOBAL.setfenv(1, GLOBAL)

local UpvalueUtil = require("utils/upvalue_util")

local function IsFullOfFlowers(inst)
    return inst.components.container and inst.components.container:IsFull()
end

local function OnFlowerPerished(item)
    item.components.perishable.onperishreplacement = "ghostflower"
end

local function OnItemChange(inst, data)
    if IsFullOfFlowers(inst) and inst._petal_preserve then
        if inst.components.timer:IsPaused("spawn_ghostflower") then
            inst.components.timer:ResumeTimer("spawn_ghostflower")
        else
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

local function getsisturnfeel(inst)
    return "BLOSSOM"
end

AddPrefabPostInit("sisturn", function(inst)
    if not TheWorld.ismastersim then
        return
    end

    inst.getsisturnfeel = getsisturnfeel
    UpvalueUtil.SetUpvalue(inst.components.inspectable.getstatus, getsisturnfeel, "getsisturnfeel")

    if not inst.components.timer then
        inst:AddComponent("timer")
    end

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
