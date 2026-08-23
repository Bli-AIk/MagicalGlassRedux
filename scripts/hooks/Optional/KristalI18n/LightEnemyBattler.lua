-- Optional kristal-i18n adapter: light enemy name / check / act names.
--
-- LightEnemyBattler (an Object subclass in MGR, NOT EnemyBattler) stores
-- `self.name` / `self.check` as plain fields and composes texts from them at
-- render/act time ("* " .. enemy.name, getSpareText, onAct Check). The adapter
-- swaps those fields to the localized values once LightBattle has finished
-- constructing the encounter, and on language switch. This is deliberately
-- after subclass init: enemy data classes assign their source strings after
-- calling LightEnemyBattler:init.
local HasI18N = Mod and Mod.libs and Mod.libs["kristalI18n"] ~= nil

local LightEnemyBattler, super = HookSystem.hookScript(LightEnemyBattler)

local XACT_KEYS = {
    ["Standard"] = "mgr_xact_standard",
    ["X-Action"] = "mgr_xact_x_action",
}

local function callLoc(key, fallback)
    if HasI18N and Game and Game.hasStr and Game:hasStr(key) then
        return Game:loc(key)
    end
    return fallback
end

if HasI18N then
    function LightEnemyBattler:getAct(name)
        local act = super.getAct(self, name)
        if act then
            return act
        end
        for _, candidate in ipairs(self.acts or {}) do
            if candidate.i18n_source_name == name or
                (candidate.i18n_display_names and candidate.i18n_display_names[name]) then
                return candidate
            end
        end
    end

    -- getXAction builds the bottom X-Action label ("Standard" / "X-Action").
    function LightEnemyBattler:getXAction(battler)
        local value = super.getXAction(self, battler)
        if type(value) == "string" then
            local source_name = value
            value = callLoc(XACT_KEYS[source_name], source_name)
            self.i18n_xaction_display_names = self.i18n_xaction_display_names or {}
            self.i18n_xaction_display_names[source_name] = source_name
            self.i18n_xaction_display_names[value] = source_name
        end
        return value
    end
end

return LightEnemyBattler
