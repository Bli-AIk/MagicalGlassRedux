-- Optional kristal-i18n adapter: light enemy name / check / act names.
--
-- LightEnemyBattler (an Object subclass in MGR, NOT EnemyBattler) stores
-- `self.name` / `self.check` as plain fields and composes texts from them at
-- render/act time ("* " .. enemy.name, getSpareText, onAct Check). The adapter
-- swaps those fields to the localized values at battle start and on language
-- switch, restoring the English originals when the target language has no
-- translation (Game:hasStr). Without kristalI18n this script only registers
-- the shared refresh helper on the library table and does nothing else.
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
    local name_key = "enemy_" .. enemy.id .. "_name"
    local check_key = "enemy_" .. enemy.id .. "_check"
    -- Keep the English source around once so we can restore on language switch.
    if enemy.i18n_orig_name == nil then
        enemy.i18n_orig_name = enemy.name
    end
    if enemy.i18n_orig_check == nil then
        enemy.i18n_orig_check = enemy.check
    end
    enemy.name = callLoc(name_key, enemy.i18n_orig_name)
    if enemy.i18n_orig_check ~= nil then
        enemy.check = callLoc(check_key, enemy.i18n_orig_check)
    end
    -- Default act ("Check", registered in init) names shown in the act palette.
    for _, act in ipairs(enemy.acts or {}) do
        if act and act.name == "Check" then
            act.name = callLoc("mgr_act_check", act.name)
        end
    end
end

if HasI18N and Mod and Mod.libs and Mod.libs["magical-glass"] then
    Mod.libs["magical-glass"].i18n_refreshEnemy = refreshEnemy
end

if HasI18N then
    function LightEnemyBattler:init(...)
        local r = super.init(self, ...)
        -- Run every library's registered refresher (this one + UMR's, which
        -- localizes turn texts, low/spare texts and the extra act names).
        for _, lib in Kristal.iterLibraries() do
            local refresh = lib.i18n_refreshEnemy
            if type(refresh) == "function" then
                refresh(self)
            end
        end
        return r
    end

    -- getXAction builds the bottom X-Action label ("Standard" / "X-Action").
    function LightEnemyBattler:getXAction(battler)
        local value = super.getXAction(self, battler)
        if type(value) == "string" then
            value = callLoc(XACT_KEYS[value], value)
        end
        return value
    end
end

return LightEnemyBattler
