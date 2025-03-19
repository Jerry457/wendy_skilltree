
local UpvalueUtil = {}

local hidefns = {}
function UpvalueUtil.HideFn(hidefn, realfn)
    hidefns[hidefn] = realfn
end

local _debug_getupvalue = debug.getupvalue
function debug.getupvalue(fn, ...)
    return _debug_getupvalue(hidefns[fn] or fn, ...)
end
UpvalueUtil.HideFn(debug.getupvalue, _debug_getupvalue)

local _debug_setupvalue = debug.setupvalue
function debug.setupvalue(fn, ...)
    return _debug_setupvalue(hidefns[fn] or fn, ...)
end
UpvalueUtil.HideFn(debug.setupvalue, _debug_setupvalue)

--Tool designed by Rezecib.
---@param fn function
---@param name string
---@return any, number | nil
local function get_upvalue(fn, name)
    local i = 1
    while true do
        local value_name, value = debug.getupvalue(fn, i)
        if value_name == name then
            return value, i
        elseif value_name == nil then
            return
        end
        i = i + 1
    end
end

---@param fn function
---@param path string
---@return any, number, function
function UpvalueUtil.GetUpvalue(fn, path)
    local value, prv, i = fn, nil, nil ---@type any, function | nil, number | nil
    for part in path:gmatch("[^%.]+") do
        -- print(part)
        prv = fn
        value, i = get_upvalue(value, part)
    end
    return value, i, prv
end

---@param fn function
---@param path string
---@param value any
function UpvalueUtil.SetUpvalue(fn, value, path)
    local _, i, source_fn = UpvalueUtil.GetUpvalue(fn, path)
    debug.setupvalue(source_fn, i, value)
end

function UpvalueUtil.RegisterInventoryItemAtlas(atlas_path)
    local atlas = resolvefilepath(atlas_path)

    local file = io.open(atlas, "r")
    local data = file:read("*all")
    file:close()

    local str = string.gsub(data, "%s+", "")
    local _, _, elements = string.find(str, "<Elements>(.-)</Elements>")

    for s in string.gmatch(elements, "<Element(.-)/>") do
        local _, _, image = string.find(s, "name=\"(.-)\"")
        if image ~= nil then
            RegisterInventoryItemAtlas(atlas, image)
            RegisterInventoryItemAtlas(atlas, hash(image))  -- for client
        end
    end
end

return UpvalueUtil
