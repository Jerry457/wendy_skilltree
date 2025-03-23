local widget_files = {

}

local component_files = {
    "equippable",
    "hauntable",
}

local stategraphs_files = {
    "wilson",
    "wilson_client"
}

local prefab_files = {
    "abigail_murder_buff",
    "abigail",
    "elixir_container",
    "farm_plant_randomseed",
    "ghostcommand_defs",
    "ghostlyelixirs",
    "moondial",
    "mourning_regrow",
    "nightlight",
    "petals",
    "sisturn",
    "wendy",
}

local brain_files = {
    "abigailbrain"
}

modimport("postinit/entityscript")
modimport("postinit/loottables")

for i, file_name in ipairs(widget_files) do
    modimport("postinit/widgets/" .. file_name)
end

for i, file_name in ipairs(component_files) do
    modimport("postinit/components/" .. file_name)
end

for i, file_name in ipairs(stategraphs_files) do
    modimport("postinit/stategraphs/SG" .. file_name)
end

for i, file_name in ipairs(prefab_files) do
    modimport("postinit/prefabs/" .. file_name)
end

for i, file_name in ipairs(brain_files) do
    modimport("postinit/brains/" .. file_name)
end
