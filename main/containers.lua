GLOBAL.setfenv(1, GLOBAL)

local containers = require("containers")
local params = containers.params

local function CanContainerItem(container, item, slot)
    return item.replica.container == nil
end

params.goblinkiller_equipment_back = {
    widget =
    {
        slotpos =
        {
            Vector3(-60, -5, 0),
            Vector3(60, -5, 0),
        },
        slotbg =
        {
            { image = "equip_slot_body.tex", atlas = "images/hud.xml" },
            { image = "equip_slot_head.tex", atlas = "images/hud.xml" },
        },
        animbank = "ui_goblinkiller_equipment_back_2x1",
        animbuild = "ui_goblinkiller_equipment_back_2x1",
        pos = Vector3(-82, 100, 0),
        bottom_align_tip = -100,
    },
    acceptsstacks = false,
    lowpriorityselection = true,
    type = "side_inv_behind",
}

params.goblinkiller_greed_equipment_back = params.goblinkiller_equipment_back
for prefab in pairs(GOBLINKILLER_TRANSFORME_CHARACTERS) do
    params[prefab .. "_equipment_back"] = params.goblinkiller_equipment_back
end

params.goblinkiller_backpack_1 = {
    widget = {
        slotpos = {},
        animbank  = "ui_backpack_2x4",
        animbuild = "ui_backpack_2x4",
        pos = Vector3(-5, -80, 0),
    },
    issidewidget = true,
    openlimit = 1,
    type = "pack",
    itemtestfn = CanContainerItem,
}

for y = 0, 3 do
    table.insert(params.goblinkiller_backpack_1.widget.slotpos, Vector3(-162, -75 * y + 114, 0))
    table.insert(params.goblinkiller_backpack_1.widget.slotpos, Vector3(-162 + 75, -75 * y + 114, 0))
end

params.goblinkiller_backpack_2 = {
    widget = {
        slotpos = {},
        animbank  = "ui_piggyback_2x6",
        animbuild = "ui_piggyback_2x6",
        pos = Vector3(-5, -90, 0),
    },
    issidewidget = true,
    openlimit = 1,
    type = "pack",
    itemtestfn = CanContainerItem,
}

for y = 0, 5 do
    table.insert(params.goblinkiller_backpack_2.widget.slotpos, Vector3(-162, -75 * y + 170, 0))
    table.insert(params.goblinkiller_backpack_2.widget.slotpos, Vector3(-162 + 75, -75 * y + 170, 0))
end

params.goblinkiller_backpack_3 = {
    widget = {
        slotpos = {},
        animbank  = "ui_krampusbag_2x8",
        animbuild = "ui_krampusbag_2x8",
        pos = Vector3(-5, -130, 0),
    },
    issidewidget = true,
    openlimit = 1,
    type = "pack",
    itemtestfn = CanContainerItem,
}

for y = 0, 6 do
    table.insert(params.goblinkiller_backpack_3.widget.slotpos, Vector3(-162, -75 * y + 240, 0))
    table.insert(params.goblinkiller_backpack_3.widget.slotpos, Vector3(-162 + 75, -75 * y + 240, 0))
end

local greed_coinbag = {
    widget =
    {
        slotpos = {},
        slotbg = {},
        pos = Vector3(-340, -120, 0),
        side_align_tip = 160,
    },
    type = "pack",
    itemtestfn = function(container, item, slot)  -- 只可以用来装 贽金、古金币、护符、宝石
        return item:HasTag("gem") or item:HasTag("greed_coin") or string.find(item.prefab, "amulet")
    end,
}

params.greed_coinbag_1 = deepcopy(greed_coinbag)
params.greed_coinbag_1.widget.animbank = "ui_greed_coinbag_2x3"
params.greed_coinbag_1.widget.animbuild = "ui_greed_coinbag_2x3"

for y = 2, 0, -1 do
    for x = 0, 1 do
        table.insert(params.greed_coinbag_1.widget.slotpos, Vector3(80 * (x - 2) + 130, 80 * (y - 2) + 75, 0))
    end
end

params.greed_coinbag_2 = deepcopy(greed_coinbag)
params.greed_coinbag_2.widget.animbank = "ui_greed_coinbag_3x4"
params.greed_coinbag_2.widget.animbuild = "ui_greed_coinbag_3x4"

for y = 2.5, -0.5, -1 do
    for x = 0, 2 do
        table.insert(params.greed_coinbag_2.widget.slotpos, Vector3(75 * x - 75 * 2 + 75, 75 * y - 75 * 2 + 75, 0))
    end
end
