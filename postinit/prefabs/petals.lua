local AddPrefabPostInit = AddPrefabPostInit
GLOBAL.setfenv(1, GLOBAL)

local petals = {
    "petals",
    "petals_evil",
    "moon_tree_blossom",
}

for _, petal in ipairs(petals) do
    AddPrefabPostInit(petal, function(inst)
        inst:AddTag("petal")
    end)
end
