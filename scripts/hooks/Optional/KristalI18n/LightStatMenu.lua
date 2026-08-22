-- Optional kristal-i18n adapter: light-world stat menu labels
-- (MGR's LightStatMenu restyle draws "AT"/"DF"/"LV"/"HP"/... literals).
local HasI18N = Mod and Mod.libs and Mod.libs["kristalI18n"] ~= nil
local LightStatMenu, super = HookSystem.hookScript(LightStatMenu)

local function loc(key, fallback)
    if HasI18N and Game and Game.hasStr and Game:hasStr(key) then
        return Game:loc(key)
    end
    return fallback
end

local STAT_TEXT_IDS = {
    ["AT"] = "mgr_lightstat_at",
    ["DF"] = "mgr_lightstat_df",
    ["LV"] = "mgr_lightstat_lv",
    ["HP  "] = "mgr_lightstat_hp",
    ["HP"] = "mgr_lightstat_hp",
    ["MAX"] = "mgr_lightstat_max",
    ["EXP: "] = "mgr_lightstat_exp",
    ["KILLS: "] = "mgr_lightstat_kills",
    ["NEXT: "] = "mgr_lightstat_next",
    ["WEAPON: "] = "mgr_lightstat_weapon",
    ["ARMOR: "] = "mgr_lightstat_armor",
    ["MERCY"] = "mgr_lightstat_mercy",
}

local function localizeStatText(text)
    if type(text) ~= "string" then
        return text
    end
    local id = STAT_TEXT_IDS[text]
    if id then
        return loc(id, text)
    end
    -- "HP 90 / 90" style combos
    local hp = text:match("^HP (%d+) / (%d+)$")
    if hp then
        return loc("mgr_lightstat_hp_total", text, { hp = hp })
    end
    return text
end

if HasI18N then
    function LightStatMenu:draw(...)
        local args = { ... }
        local original_print = love.graphics.print
        love.graphics.print = function(text, ...)
            return original_print(localizeStatText(text), ...)
        end
        local ok, result = xpcall(function()
            return super.draw(self, unpack(args))
        end, debug.traceback)
        love.graphics.print = original_print
        if not ok then
            error(result)
        end
        return result
    end
end

return LightStatMenu
