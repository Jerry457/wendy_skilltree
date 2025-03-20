local AddComponentAction = AddComponentAction
local AddAction = AddAction
local AddStategraphActionHandler = AddStategraphActionHandler
local MODENV = env
GLOBAL.setfenv(1, GLOBAL)

local UpvalueUtil = require("utils/upvalue_util")

if not rawget(_G, "HotReloading") then
    local ACTIONS = {
        SPAEN_SMALL_GHOST = Action({priority = 1, rmb = true}),
        MOURNING_REGROW = Action({priority = 1}),
    }

    for name, action in pairs(ACTIONS) do
        action.id = name
        action.str = STRINGS.ACTIONS[name] or name
        AddAction(action)
    end

    local actionhandlers = {
        ActionHandler(ACTIONS.SPAEN_SMALL_GHOST, "dolongaction"),
        ActionHandler(ACTIONS.MOURNING_REGROW, "give"),
    }
    for _, actionhandler in ipairs(actionhandlers) do
        AddStategraphActionHandler("wilson", actionhandler)
        AddStategraphActionHandler("wilson_client", actionhandler)
    end
end

ACTIONS.SPAEN_SMALL_GHOST.fn = function(act)
    if act.doer and not act.doer.questghost and act.target and (not act.target.ghost or not act.target.ghost:IsValid()) then
        local gx, gy, gz = act.target.Transform:GetWorldPosition()
        act.target.ghost = SpawnPrefab("smallghost")
        act.target.ghost.Transform:SetPosition(gx + 0.3, gy, gz + 0.3)
        act.target.ghost:LinkToHome(act.target)
        act.target.ghost:DoTaskInTime(0,function()
            act.target.ghost.components.questowner:BeginQuest(act.doer)
        end)
        return true
    end
    return false
end

ACTIONS.MOURNING_REGROW.fn = function(act)
    if act.target and act.target.components.mourningregrow then
        return act.target.components.mourningregrow:Regrow(act.doer)
    end
end


AddComponentAction("SCENE", "gravediggable", function(inst, doer, actions, right)
    local skilltreeupdater = (doer and doer.components.skilltreeupdater) or nil

    if right and skilltreeupdater and skilltreeupdater:IsActivated("wendy_smallghost_1") then
        table.insert(actions, ACTIONS.SPAEN_SMALL_GHOST)
    end
end)

AddComponentAction("USEITEM", "mourningflower", function(inst, doer, target, actions, right)
    local skilltreeupdater = (doer and doer.components.skilltreeupdater) or nil
    if target and target:HasTag("mourningregrow") and skilltreeupdater and skilltreeupdater:IsActivated("wendy_ghostflower_butterfly") then
        table.insert(actions, ACTIONS.MOURNING_REGROW)
    end
end)


local COMPONENT_ACTIONS = UpvalueUtil.GetUpvalue(EntityScript.CollectActions, "COMPONENT_ACTIONS")
local SCENE = COMPONENT_ACTIONS.SCENE
local USEITEM = COMPONENT_ACTIONS.USEITEM
local POINT = COMPONENT_ACTIONS.POINT
local EQUIPPED = COMPONENT_ACTIONS.EQUIPPED
local INVENTORY = COMPONENT_ACTIONS.INVENTORY

SCENE.ghostgestalter = function(inst, doer, actions, right)
    local skilltreeupdater = (inst and doer.components.skilltreeupdater) or nil
    if skilltreeupdater and (skilltreeupdater:IsActivated("wendy_lunar_3") or skilltreeupdater:IsActivated("wendy_shadow_3")) and (right) then
        table.insert(actions, ACTIONS.MUTATE)
    end
end
