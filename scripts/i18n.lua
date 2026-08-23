-- Internal helpers shared by MagicalGlassRedux's optional i18n hooks.
-- This file is executed explicitly with Kristal.executeLibScript; it is not a
-- registered script and intentionally does not add anything to Mod.libs.
local I18N = {}

function I18N.available()
    return Mod and Mod.libs and Mod.libs["kristalI18n"] ~= nil
end

function I18N.has(key)
    return I18N.available() and Game and Game.hasStr and Game:hasStr(key)
end

function I18N.loc(key, fallback, vars)
    if I18N.has(key) then
        return Game:loc(key, vars)
    end
    return fallback
end

function I18N.itemName(value, preferred_id)
    if type(value) ~= "string" then
        return value, preferred_id
    end

    local library = Mod and Mod.libs and Mod.libs["kristalI18n"]
    if type(library) ~= "table" or type(library.getItemTextLocalizationKey) ~= "function" then
        return value, preferred_id
    end

    local key, item_id = library:getItemTextLocalizationKey(value, "name", preferred_id)
    if type(key) == "string" then
        return I18N.loc(key, value), item_id
    end
    return value, item_id or preferred_id
end

function I18N.refreshEnemy(enemy)
    if type(enemy) ~= "table" or type(enemy.id) ~= "string" then
        return
    end

    if type(enemy.check) == "string" and enemy.i18n_orig_check == nil then
        enemy.i18n_orig_check = enemy.check
    end
    if enemy.i18n_orig_check ~= nil then
        enemy.check = I18N.loc("enemy_" .. enemy.id .. "_check", enemy.i18n_orig_check)
    end

    for _, act in ipairs(enemy.acts or {}) do
        if act and type(act.name) == "string" then
            if act.i18n_source_name == nil and act.name == "Check" then
                act.i18n_source_name = act.name
            end
            if act.i18n_source_name == "Check" then
                act.i18n_display_names = act.i18n_display_names or {}
                act.i18n_display_names[act.name] = true
                act.name = I18N.loc("mgr_act_check", act.i18n_source_name)
                act.i18n_display_names[act.name] = true
            end
        end
    end
end

return I18N
