-- Optional kristal-i18n adapter: light-world menu labels (MGR restyles the
-- engine's LightMenu; the literal labels are drawn with love.graphics.print).
local HasI18N = Mod and Mod.libs and Mod.libs["kristalI18n"] ~= nil
local LightMenu, super = HookSystem.hookScript(LightMenu)

local function loc(key, fallback)
    if HasI18N and Game and Game.hasStr and Game:hasStr(key) then
        return Game:loc(key)
    end
    return fallback
end

local MENU_TEXT_IDS = {
    ["ITEM"] = "mgr_lightmenu_item",
    ["STAT"] = "mgr_lightmenu_stat",
    ["CELL"] = "mgr_lightmenu_cell",
    ["INFO"] = "mgr_lightmenu_info",
    ["USE"] = "mgr_lightmenu_use",
    ["DISCARD"] = "mgr_lightmenu_discard",
    ["HP  "] = "mgr_lightmenu_hp",
    ["HP"] = "mgr_lightmenu_hp",
    ["SPACE"] = "mgr_lightmenu_space",
}

local function localizeMenuText(text)
    if type(text) ~= "string" then
        return text
    end
    local id = MENU_TEXT_IDS[text]
    if id then
        return loc(id, text)
    end
    return text
end

if HasI18N then
    function LightMenu:draw(...)
        local args = { ... }
        local original_print = love.graphics.print
        love.graphics.print = function(text, ...)
            return original_print(localizeMenuText(text), ...)
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

return LightMenu
