local SG_COMMON = SG_COMMON
local AddStategraphState = AddStategraphState
local AddStategraphPostInit = AddStategraphPostInit

GLOBAL.setfenv(1, GLOBAL)

local states = {
    State{
        name = "applyelixir_mourningflower",
        tags = { "doing", "busy" },

        onenter = function(inst)
            inst.components.locomotor:Stop()

            inst.AnimState:PlayAnimation("wendy_elixir_pre")
            inst.AnimState:PushAnimation("wendy_elixir",false)
            inst.SoundEmitter:PlaySound("meta5/wendy/pour_elixir_f17")

            inst.sg.statemem.action = inst:GetBufferedAction()

            if inst.sg.statemem.action ~= nil then
                local invobject = inst.sg.statemem.action.invobject
                local elixir_type = invobject.elixir_buff_type

                inst.AnimState:OverrideSymbol("ghostly_elixirs_swap", "ghostly_elixirs", "ghostly_elixirs_".. elixir_type .."_swap")
                inst.AnimState:OverrideSymbol("flower", "mourningflower", "flower")
            end

            inst.sg:SetTimeout(50 * FRAMES)
        end,

        timeline =
        {
            FrameEvent(4, function(inst)
                inst.sg:RemoveStateTag("busy")
            end),
            FrameEvent(19, function(inst)
                if not inst:PerformBufferedAction() then
                    inst.sg:GoToState("idle", true)
                end
            end),
        },

        ontimeout = function(inst)
            inst.sg:GoToState("idle", true)
        end,

        onexit = function(inst)
            if inst.bufferedaction == inst.sg.statemem.action and
            (inst.components.playercontroller == nil or inst.components.playercontroller.lastheldaction ~= inst.bufferedaction) then
                inst:ClearBufferedAction()
            end
        end,
    },
}

for _, state in ipairs(states) do
    AddStategraphState("wilson", state)
end

AddStategraphPostInit("wilson", function(sg)

end)
