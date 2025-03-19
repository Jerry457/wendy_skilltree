local AddPrefabPostInit = AddPrefabPostInit
GLOBAL.setfenv(1, GLOBAL)

AddPrefabPostInit("elixir_container", function(inst)
    inst:AddTag("fridge")
end)
