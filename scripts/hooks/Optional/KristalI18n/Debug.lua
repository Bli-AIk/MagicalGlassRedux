-- Optional kristal-i18n adapter: MGR's debug menu additions.
--
-- MGR's Lib:registerDebugOptions registers encounter/shop/give-item debug
-- menus with hardcoded English labels; the engine-wide debug strings are
-- already covered by the i18n library's static-text map, but these MGR-only
-- entries are not. We wrap the registerOption/registerMenu calls made during
-- Lib:registerDebugOptions and translate label/description arguments through
-- `Game:loc` with hasStr guards. Menu texts are fixed at registration time,
-- so the debug menu needs a relaunch after an in-game language switch.
local HasI18N = Mod and Mod.libs and Mod.libs["kristalI18n"] ~= nil

if HasI18N and Mod and Mod.libs and Mod.libs["magical-glass"] and HookSystem then
    local Lib = Mod.libs["magical-glass"]

    local function loc(key, fallback)
        if Game and Game.hasStr and Game:hasStr(key) then
            return Game:loc(key)
        end
        return fallback
    end

    -- label / description -> key (only MGR-own strings; engine duplicates
    -- like "Encounter Select" are handled by the i18n static map already).
    local DEBUG_TEXT_IDS = {
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

    HookSystem.hook(Lib, "registerDebugOptions", function(orig, debug, ...)
        local orig_register_option = debug and debug.registerOption
        local orig_register_menu = debug and debug.registerMenu

        if debug and orig_register_option then
            function debug.registerOption(self, menu, label, desc, callback)
                label = DEBUG_TEXT_IDS[label] and loc(DEBUG_TEXT_IDS[label], label) or label
                if type(desc) == "string" then
                    desc = DEBUG_TEXT_IDS[desc] and loc(DEBUG_TEXT_IDS[desc], desc) or desc
                end
                return orig_register_option(self, menu, label, desc, callback)
            end
        end

        if debug and orig_register_menu then
            function debug.registerMenu(self, menu, label, search)
                if type(label) == "string" then
                    label = DEBUG_TEXT_IDS[label] and loc(DEBUG_TEXT_IDS[label], label) or label
                end
                return orig_register_menu(self, menu, label, search)
            end
        end

        return orig(debug, ...)
    end)
end
