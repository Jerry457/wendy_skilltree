local widget_files = {

}

local component_files = {

}

local stategraphs_files = {

}

local prefab_files = {
    "abigail",
    "elixir_container",
    "ghostly_elixirs",
    "petals",
    "sisturn",
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
