-- Optional kristal-i18n adapter:
-- 1) Refresh MGR enemy texts on language switch (LightEnemyBattler registers
--    `i18n_refreshEnemy` on the magical-glass library table).
-- 2) Translate MGR's debug menu additions (encounter/shop/give-item labels
--    registered by Lib:registerDebugOptions — engine duplicate labels are
--    already covered by the i18n static-text map).
local HasI18N = Mod and Mod.libs and Mod.libs["kristalI18n"] ~= nil
local Game, super = HookSystem.hookScript(Game)

local function loc(key, fallback)
    if HasI18N and Game and Game.hasStr and Game:hasStr(key) then
        return Game:loc(key)
    end
    return fallback
end

if HasI18N then
    function Game:setLanguage(...)
        local r = super.setLanguage(self, ...)
        local lib = Mod and Mod.libs and Mod.libs["magical-glass"]
        if lib and lib.i18n_refreshEnemy and Game.battle then
            for _, enemy in ipairs(Game.battle.enemies or {}) do
                lib.i18n_refreshEnemy(enemy)
            end
        end
        return r
    end
end

-- Registration-time translation of the MGR-only debug strings. Menu texts are
-- fixed at registration, so a debug menu relaunch is needed after switching.
if HasI18N and Mod and Mod.libs and Mod.libs["magical-glass"] and HookSystem then
    local Lib = Mod.libs["magical-glass"]

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

        -- Composed give-item entries: label "(ITEM)| light/cards", desc
        -- '"Name"\nDescription'. MGR builds both from RAW item fields
        -- (item.name / item.description), bypassing the i18n accessor hooks —
        -- re-localize them here from the id carried in the label.
        local TYPE_KEYS = {
            ITEM = "mgr_debug_type_item",
            WEAPON = "mgr_debug_type_weapon",
            ARMOR = "mgr_debug_type_armor",
            KEY = "mgr_debug_type_key",
        }

        if debug and orig_register_option then
            function debug.registerOption(self, menu, label, desc, callback)
                label = DEBUG_TEXT_IDS[label] and loc(DEBUG_TEXT_IDS[label], label) or label
                if type(desc) == "string" then
                    desc = DEBUG_TEXT_IDS[desc] and loc(DEBUG_TEXT_IDS[desc], desc) or desc
                end

                if type(label) == "string" then
                    local type_word, item_id = label:match("^%((%u+)%)%| (.+)$")
                    if type_word and item_id and Game then
                        label = "(" .. loc(TYPE_KEYS[type_word], type_word) .. ") | " .. item_id
                        local raw_name, raw_desc = type(desc) == "string" and desc:match('^"([^"]*)"%s*\n%s*(.*)$')
                        if raw_name then
                            local name_key = "item_" .. item_id .. "_name"
                            local desc_key = "item_" .. item_id .. "_description"
                            desc = "\"" .. loc(name_key, raw_name) .. "\"\n" ..
                                loc(desc_key, raw_desc ~= "" and raw_desc or raw_name)
                        end
                    end
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

return Game
