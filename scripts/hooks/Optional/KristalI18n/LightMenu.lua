-- Optional kristal-i18n adapter: light-world UI text (LightMenu /
-- LightStatMenu / LightItemMenu, and the composed "Use <item> on" bar).
--
-- Class-level draw hooks do NOT work here: MGR's own hooks on these classes
-- register after the adapters (path sort: Optional/... < World/...) and their
-- draw() never calls super.draw, shadowing adapter draw models entirely.
-- Instead the adapter wraps love.graphics.print and Draw.printAlign once at
-- load time; the i18n library's own wrappers are installed later (postInit),
-- so every string still passes through this translator first (its map only
-- hits known MGR strings, all others pass through untouched).
local HasI18N = Mod and Mod.libs and Mod.libs["kristalI18n"] ~= nil
local LightMenu, super = HookSystem.hookScript(LightMenu)

-- Context for the "Use <item> on" target bar: MGR's LightItemMenu:update
-- does call super.update, so a class-level hook here is reachable (unlike
-- the draw methods). Capture the item being targeted so the draw-time
-- translator can pick the equip vs. use wording.
local target_item_type = nil
if HasI18N then
    local LightItemMenu, itemmenu_super = HookSystem.hookScript(LightItemMenu)
    function LightItemMenu:update(...)
        local r = itemmenu_super.update(self, ...)
        if self.state == "PARTYSELECT" and Game and Game.inventory then
            local item = Game.inventory:getItem(self.storage, self.item_selecting)
            target_item_type = item and item.type or nil
        end
        return r
    end
end

local function loc(key, fallback, var)
    if HasI18N and Game and Game.hasStr and Game:hasStr(key) then
        return Game:loc(key, var)
    end
    return fallback
end

local LIGHT_UI_TEXT_IDS = {
    -- LightMenu
    ["ITEM"] = "mgr_lightmenu_item",
    ["STAT"] = "mgr_lightmenu_stat",
    ["CELL"] = "mgr_lightmenu_cell",
    ["INFO"] = "mgr_lightmenu_info",
    ["USE"] = "mgr_lightmenu_use",
    ["DISCARD"] = "mgr_lightmenu_discard",
    ["HP  "] = "mgr_lightmenu_hp",
    ["HP"] = "mgr_lightmenu_hp",
    ["LV"] = "mgr_lightmenu_lv",
    ["SPACE"] = "mgr_lightmenu_space",
    -- LightStatMenu
    ["AT"] = "mgr_lightstat_at",
    ["DF"] = "mgr_lightstat_df",
    ["MAX"] = "mgr_lightstat_max",
    ["EXP: "] = "mgr_lightstat_exp",
    ["KILLS: "] = "mgr_lightstat_kills",
    ["NEXT: "] = "mgr_lightstat_next",
    ["WEAPON: "] = "mgr_lightstat_weapon",
    ["ARMOR: "] = "mgr_lightstat_armor",
    ["MERCY"] = "mgr_lightstat_mercy",
    -- Debug menus (MGR Lib:registerDebugOptions additions) — see Game.lua
    -- for the registration-time wrapper; here they are also live at draw time.
    ["Start Dark Encounter"] = "mgr_debug_start_dark_encounter",
    ["Start a dark encounter."] = "mgr_debug_start_dark_encounter_desc",
    ["Start Light Encounter"] = "mgr_debug_start_light_encounter",
    ["Start a light encounter."] = "mgr_debug_start_light_encounter_desc",
    ["Select Dark Encounter"] = "mgr_debug_select_dark_encounter",
    ["Select Light Encounter"] = "mgr_debug_select_light_encounter",
    ["Enter Dark Shop"] = "mgr_debug_enter_dark_shop",
    ["Enter a dark shop."] = "mgr_debug_enter_dark_shop_desc",
    ["Enter Light Shop"] = "mgr_debug_enter_light_shop",
    ["Enter a light shop."] = "mgr_debug_enter_light_shop_desc",
    ["Give Kristal Item"] = "mgr_debug_give_kristal_item",
    ["Give a Kristal built-in item."] = "mgr_debug_give_kristal_item_desc",
    ["Give Dark Item"] = "mgr_debug_give_dark_item",
    ["Give a dark item."] = "mgr_debug_give_dark_item_desc",
    ["Give Light Item"] = "mgr_debug_give_light_item",
    ["Give a light item."] = "mgr_debug_give_light_item_desc",
    ["Give Undertale Item"] = "mgr_debug_give_undertale_item",
    ["Give an Undertale item."] = "mgr_debug_give_undertale_item_desc",
}

local function localizeLightUIText(text)
    if type(text) ~= "string" then
        return text
    end
    local id = LIGHT_UI_TEXT_IDS[text]
    if id then
        return loc(id, text)
    end
    -- Composed strings
    local hp = text:match("^HP (%d+) / (%d+)$")
    if hp then
        return loc("mgr_lightstat_hp_total", text, { hp = hp })
    end
    local item = text:match("^Use (.+) on$")
    if item then
        return loc("mgr_item_use_target", text, { item = item })
    end
    if text == "Use" then
        return loc("mgr_item_use", text)
    end
    return text
end

if HasI18N then
    -- kristal-i18n wraps these functions AFTER this adapter's load (its
    -- postInit), at which point the current global points at the i18n wrapper
    -- whose base is ours. To let the i18n CJK-spacing machinery see the
    -- TRANSLATED text, delegates go back through the *current* global (depth
    -- 1); a second re-entry reaches the raw base and ends the cycle. Before
    -- the i18n install (global == us) we fall straight to the base.
    local depth = 0

    local base_print = love.graphics.print
    local base_printf = love.graphics.printf
    local base_align = Draw and Draw.printAlign
    local base_shadow = Draw and Draw.printShadow

    local my_print
    my_print = function(text, ...)
        depth = depth + 1
        local r
        if depth > 1 or love.graphics.print == my_print then
            r = base_print(text, ...)
        else
            r = love.graphics.print(localizeLightUIText(text), ...)
        end
        depth = depth - 1
        return r
    end
    love.graphics.print = my_print

    -- Debug menu option labels render through love.graphics.printf (via
    -- DebugSystem:printShadow/printAlign); without this wrapper they never
    -- reach the translator.
    local my_printf
    my_printf = function(text, ...)
        depth = depth + 1
        local r
        if depth > 1 or love.graphics.printf == my_printf then
            r = base_printf(text, ...)
        else
            r = love.graphics.printf(localizeLightUIText(text), ...)
        end
        depth = depth - 1
        return r
    end
    love.graphics.printf = my_printf

    if base_align then
        local my_align
        my_align = function(text, ...)
            depth = depth + 1
            local r
            if depth > 1 or Draw.printAlign == my_align then
                r = base_align(text, ...)
            else
                r = Draw.printAlign(localizeLightUIText(text), ...)
            end
            depth = depth - 1
            return r
        end
        Draw.printAlign = my_align
    end

    if base_shadow then
        local my_shadow
        my_shadow = function(text, ...)
            depth = depth + 1
            local r
            if depth > 1 or Draw.printShadow == my_shadow then
                r = base_shadow(text, ...)
            else
                r = Draw.printShadow(localizeLightUIText(text), ...)
            end
            depth = depth - 1
            return r
        end
        -- Debug-system menus (MGR's give-item/encounter/shop selections) draw
        -- labels via printShadow; this makes the mgr_debug_* strings live at
        -- draw time, independent of register-time state or language switches.
        Draw.printShadow = my_shadow
    end
end

return LightMenu
