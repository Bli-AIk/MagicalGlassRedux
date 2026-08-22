-- Optional kristal-i18n adapter: LightItemMenu composed UI strings.
-- Kristal-i18n's light inventory hook already covers the plain USE/INFO/DROP
-- labels; only the composed "Use <item> on" target bar remains English.
local HasI18N = Mod and Mod.libs and Mod.libs["kristalI18n"] ~= nil
local LightItemMenu, super = HookSystem.hookScript(LightItemMenu)

local function loc(key, fallback, var)
    if HasI18N and Game and Game.hasStr and Game:hasStr(key) then
        return Game:loc(key, var)
    end
    return fallback
end

local function localizeItemMenuText(text)
    if type(text) ~= "string" then
        return text
    end
    local item, target = text:match("^Use (.+) on$")
    if item then
        return loc("mgr_item_use_target", text, { item = item })
    end
    if text == "Use" then
        return loc("mgr_item_use", text)
    end
    return text
end

if HasI18N then
    function LightItemMenu:draw(...)
        local args = { ... }
        local original_print = love.graphics.print
        local original_align = Draw and Draw.printAlign
        love.graphics.print = function(text, ...)
            return original_print(localizeItemMenuText(text), ...)
        end
        if original_align then
            -- The "Use <item> on" target bar is drawn via Draw.printAlign.
            function Draw.printAlign(text, ...)
                return original_align(localizeItemMenuText(text), ...)
            end
        end
        local ok, result = xpcall(function()
            return super.draw(self, unpack(args))
        end, debug.traceback)
        love.graphics.print = original_print
        if original_align then
            Draw.printAlign = original_align
        end
        if not ok then
            error(result)
        end
        return result
    end
end

return LightItemMenu
