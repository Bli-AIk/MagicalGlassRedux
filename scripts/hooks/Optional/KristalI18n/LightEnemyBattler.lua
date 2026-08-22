-- Optional kristal-i18n adapter: light enemy name / check / act names.
--
-- LightEnemyBattler (an Object subclass in MGR, NOT EnemyBattler) stores
-- `self.name` / `self.check` as plain fields and composes texts from them at
-- render/act time ("* " .. enemy.name, getSpareText, onAct Check). The adapter
-- swaps those fields to the localized values once LightBattle has finished
-- constructing the encounter, and on language switch. This is deliberately
-- after subclass init: enemy data classes assign their source strings after
-- calling LightEnemyBattler:init. Without kristalI18n this script only
-- registers the shared refresh helper on the library table and does nothing
-- else.
local HasI18N = Mod and Mod.libs and Mod.libs["kristalI18n"] ~= nil
-- Optional runtime switch: the main mod can disable the whole library via
-- mod.json config ({"magical-glass": {"enabled": false}}); see README.
if Mod and Mod.libs and Mod.libs["magical-glass"] and Kristal.getLibConfig and
    Kristal.getLibConfig("magical-glass", "enabled") == false then
    return LightEnemyBattler
end

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

local function refreshEnemy(enemy)
    if type(enemy) ~= "table" or type(enemy.id) ~= "string" then
        return
    end
    local check_key = "enemy_" .. enemy.id .. "_check"
    -- Names are left to the content library's refresher (UMR resolves them
    -- through the volatile [name:...] dictionary); this one only handles
    -- check text + the default Check act name.
    -- Keep the English source around once so we can restore on language switch.
    if type(enemy.check) == "string" and enemy.i18n_orig_check == nil then
        enemy.i18n_orig_check = enemy.check
    end
    if enemy.i18n_orig_check ~= nil then
        enemy.check = callLoc(check_key, enemy.i18n_orig_check)
    end
    -- Default act ("Check", registered in init) names shown in the act palette.
    -- Keep the source name separate because the menu uses its visible name as
    -- the action identifier.
    for _, act in ipairs(enemy.acts or {}) do
        if act and type(act.name) == "string" then
            if act.i18n_source_name == nil and act.name == "Check" then
                act.i18n_source_name = act.name
            end
            if act.i18n_source_name == "Check" then
                act.i18n_display_names = act.i18n_display_names or {}
                act.i18n_display_names[act.name] = true
                act.name = callLoc("mgr_act_check", act.i18n_source_name)
                act.i18n_display_names[act.name] = true
            end
        end
    end
end

if HasI18N and Mod and Mod.libs and Mod.libs["magical-glass"] then
    Mod.libs["magical-glass"].i18n_refreshEnemy = refreshEnemy
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
