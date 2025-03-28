local widget_files = {
}

local component_files = {
}

local stategraphs_files = {
    "common",
    "wilson",
    "wilson_client",
}

local prefab_files = {
}

local brain_files = {

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
    modimport("postinit/file_name")
end
