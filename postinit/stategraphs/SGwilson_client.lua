local SG_COMMON = SG_COMMON
local AddStategraphState = AddStategraphState
local AddStategraphPostInit = AddStategraphPostInit
GLOBAL.setfenv(1, GLOBAL)

local states = {
    State{
        name = "applyelixir_mourningflower",
        tags = { "busy" },
        server_states = { "applyelixir" },

        onenter = function(inst)
            inst.components.locomotor:Stop()
            inst.AnimState:PlayAnimation("wendy_elixir_pre")
            inst.AnimState:PushAnimation("wendy_elixir_lag", false)

            inst:PerformPreviewBufferedAction()
            inst.sg:SetTimeout(TIMEOUT)

            local buffaction = inst:GetBufferedAction()
            if buffaction ~= nil and buffaction.invobject ~= nil then
                local elixir_type = buffaction.invobject.elixir_buff_type
                inst.AnimState:OverrideSymbol("ghostly_elixirs_swap", "ghostly_elixirs", "ghostly_elixirs_".. elixir_type .."_swap")
            end
        end,

        onupdate = function(inst)
            if inst.sg:ServerStateMatches() then
                if inst.entity:FlattenMovementPrediction() then
                    inst.sg:GoToState("idle", "noanim")
                end
            elseif inst.bufferedaction == nil then
                inst.sg:GoToState("idle")
            end
        end,

        ontimeout = function(inst)
            inst:ClearBufferedAction()
            inst.sg:GoToState("idle")
        end,
    },

}

for _, state in ipairs(states) do
    AddStategraphState("SGwilson_client", state)
end

AddStategraphPostInit("SGwilson_client", function(sg)

end)
