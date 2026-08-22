-- Optional kristal-i18n adapter: refresh light-enemy fields after encounter
-- construction. Enemy subclasses set their source strings after calling the
-- base init, so LightBattle:postInit is the first stable refresh boundary.
local HasI18N = Mod and Mod.libs and Mod.libs["kristalI18n"] ~= nil
if Mod and Mod.libs and Mod.libs["magical-glass"] and Kristal.getLibConfig and
    Kristal.getLibConfig("magical-glass", "enabled") == false then
    return LightBattle
end

local LightBattle, super = HookSystem.hookScript(LightBattle)

local function refreshEnemies(battle)
    for _, enemy in ipairs(battle.enemies or {}) do
        for _, lib in Kristal.iterLibraries() do
            local refresh = lib.i18n_refreshEnemy
            if type(refresh) == "function" then
                refresh(enemy)
            end
        end
    end
end

local function getSourceActName(enemy, name)
    if type(enemy) ~= "table" or type(name) ~= "string" then
        return name
    end
    for _, act in ipairs(enemy.acts or {}) do
        if act.i18n_source_name and
            (act.name == name or (act.i18n_display_names and act.i18n_display_names[name])) then
            return act.i18n_source_name
        end
    end
    return name
end

local function getSourceXActionName(enemy, name)
    if type(enemy) == "table" and type(name) == "string" and enemy.i18n_xaction_display_names then
        return enemy.i18n_xaction_display_names[name] or name
    end
    return name
end

if HasI18N then
    function LightBattle:postInit(...)
        local r = super.postInit(self, ...)
        refreshEnemies(self)
        return r
    end

    -- LightBattle stores the menu label in action.name. Convert translated
    -- labels back to their data-layer names before UMR's enemy scripts run.
    function LightBattle:commitAction(battler, action_type, target, data, extra)
        if type(data) == "table" and type(data.name) == "string" then
            local source_name
            if action_type == "ACT" then
                source_name = getSourceActName(target, data.name)
            elseif action_type == "XACT" then
                source_name = getSourceXActionName(target, data.name)
                extra = TableUtils.copy(extra or {})
                extra.i18n_xact_source_name = source_name
            end
            if source_name and source_name ~= data.name then
                data = TableUtils.copy(data)
                data.name = source_name
            end
        end
        return super.commitAction(self, battler, action_type, target, data, extra)
    end

    function LightBattle:processAction(action)
        local enemy = action and action.target
        local source_name = action and action.i18n_xact_source_name
        if type(enemy) == "table" and type(source_name) == "string" then
            local original = rawget(enemy, "getXAction")
            enemy.getXAction = function()
                return source_name
            end
            local r = super.processAction(self, action)
            enemy.getXAction = original
            return r
        end
        return super.processAction(self, action)
    end
end

return LightBattle
