GLOBAL.setfenv(1, GLOBAL)

local GHOSTCOMMAND_DEFS = require("prefabs/ghostcommand_defs")

local UpvalueUtil = require("utils/upvalue_util")
local SKILLTREE_COMMAND_DEFS = UpvalueUtil.GetUpvalue(GHOSTCOMMAND_DEFS.GetGhostCommandsFor, "SKILLTREE_COMMAND_DEFS")

local haunt_at = SKILLTREE_COMMAND_DEFS["wendy_ghostcommand_3"][2]

local _onselect = haunt_at.onselect
local GhostHauntSpell = UpvalueUtil.GetUpvalue(_onselect, "GhostHauntSpell")
local _DoGhostSpell = UpvalueUtil.GetUpvalue(GhostHauntSpell, "DoGhostSpell")
local function DoGhostSpell(doer, event, ...)
    local _spellbookcooldowns = doer.components.spellbookcooldowns
    if event == "do_ghost_hauntat" then
        doer.components.spellbookcooldowns = nil
    end
    local result = {_DoGhostSpell(doer, event, ...)}
    doer.components.spellbookcooldowns = _spellbookcooldowns
    return unpack(result)
end
UpvalueUtil.SetUpvalue(GhostHauntSpell, DoGhostSpell, "DoGhostSpell")
haunt_at.checkcooldown = nil


-- local SpellBookCooldowns = require("components/spellbookcooldowns")
-- local _IsInCooldown = SpellBookCooldowns.IsInCooldown
-- function SpellBookCooldowns:IsInCooldown(spellname, ...)
--     if spellname == "ghostcommand" then
--         return true
--     end
--     return _IsInCooldown(self, spellname, ...)
-- end
