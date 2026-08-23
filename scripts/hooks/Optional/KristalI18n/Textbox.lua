-- Optional kristal-i18n adapter: localize item-use pages before a Textbox
-- constructs its DialogueText. World item handlers pass raw strings directly
-- to World:showText, so they bypass the draw-time wrappers in LightMenu.
local HasI18N = Mod and Mod.libs and Mod.libs["kristalI18n"] ~= nil


local Textbox, super = HookSystem.hookScript(Textbox)

local function hasLocalization(key)
    return HasI18N and Game and Game.hasStr and Game:hasStr(key)
end

local function localize(key, fallback, vars)
    if hasLocalization(key) then
        return Game:loc(key, vars)
    end
    return fallback
end

local _, I18N = Kristal.executeLibScript("magical-glass", "scripts/i18n")

local function resolveItemName(value, preferred_id)
    if I18N then
        return I18N.itemName(value, preferred_id)
    end
    return value, preferred_id
end

local function translatedWho(who)
    if Game and Game.lang == "zh_hans" then
        return ({
            ["You"] = "你",
            ["Your"] = "你",
            ["Everyone"] = "所有人",
            ["The enemies"] = "敌人们",
        })[who] or who
    end
    return who
end

-- Dialogue commands are meaningful to DialogueText but should not prevent a
-- source line from matching a use-text rule. Matching on a stripped copy and
-- then carrying commands onto the translated result keeps waits/voices intact
-- even when a language entry omits one of them.
local function stripControlCodes(text)
    if type(text) ~= "string" then
        return text
    end
    text = text:gsub("%b[]", "")
    return text:gsub("%^%d+", "")
end

local function preserveControlCodes(source, translated)
    if type(source) ~= "string" or type(translated) ~= "string" or translated == source then
        return translated
    end

    -- LightBattle prefixes its pages with [shake:...]. Retain any leading
    -- commands at the front, where they still affect the translated page.
    local leading = ""
    local remaining = source
    while true do
        local command = remaining:match("^(%b[])") or remaining:match("^(%^%d+)")
        if not command then
            break
        end
        leading = leading .. command
        remaining = remaining:sub(#command + 1)
    end
    if leading ~= "" and translated:sub(1, #leading) ~= leading then
        translated = leading .. translated
    end

    for command in remaining:gmatch("%b[]") do
        if not translated:find(command, 1, true) then
            translated = translated .. command
        end
    end
    for marker in remaining:gmatch("%^%d+") do
        if not translated:find(marker, 1, true) then
            translated = translated .. marker
        end
    end
    return translated
end

local STATIC_USE_LINE_KEYS = {
    ["* Oh. Tastes yappy..."] = "item_undertale/dog_salad_use_text_tastes_yappy",
    ["* Oh. Fried tennis ball..."] = "item_undertale/dog_salad_use_text_fried_tennis_ball",
    ["* Oh. There are bones..."] = "item_undertale/dog_salad_use_text_bones",
    ["* It's literally garbage???"] = "item_undertale/dog_salad_use_text_garbage",
    ["* OOOORAAAAA!!!"] = "mgr_punch_card_ora",
    ["* But nothing happened."] = "mgr_item_nothing_happened",
    ["* But nothing happened..."] = "mgr_item_nothing_happened_ellipsis",
    ["* Your SPEED boosts!"] = "mgr_item_speed_boosts",
}

local STATIC_USE_TEXT_KEYS = {
    ["* You eat one half\nof the Bisicle."] = "item_undertale/bisicle_use_text",
    ["* You hit the Croquet Roll into\nyour mouth."] = "item_undertale/croquet_roll_use_text",
    ["* You used the Mystery Key.\n* But nothing happened."] = "item_undertale/mystery_key_use_text",
}

local function localizeMappedLine(line, match_text)
    local key = STATIC_USE_LINE_KEYS[match_text]
    if key and hasLocalization(key) then
        return preserveControlCodes(line, localize(key, line))
    end
    return nil
end

local function extractItemName(text)
    if type(text) ~= "string" then
        return nil
    end

    -- Keep embedded newlines so inventory-filled and other wrapped messages
    -- retain the item name for id resolution.
    text = stripControlCodes(text)

    -- The remaining use templates describe their item on the first line;
    -- matching that line keeps multiline battle messages resolvable.
    local first_line = text:match("^[^\n]+") or text

    local item = first_line:match("^%* You used the (.+)%.$")
    if item then
        return item
    end

    local _, used_item = first_line:match("^%* (.-) used the (.+)%.$")
    if used_item then
        return used_item
    end

    item = text:match("^%* The rest of your inventory%s+filled%s+up with (.+)%.$")
    if item then
        return item
    end

    local _, _, verb_item = first_line:match("^%* (.-) ([%a]+) the (.+)%.$")
    return verb_item
end

local function usePageSuffix(text)
    if type(text) ~= "string" then
        return nil
    end
    -- Keep embedded newlines while matching page-specific world text. The
    -- uneasy-atmosphere page is intentionally a two-line string.
    text = stripControlCodes(text)
    if text:match("^%* You used the .+%.$") then
        return ""
    end
    if text:match("^%* The rest of your inventory%s+filled%s+up with .+%.$") then
        return "_2"
    end
    if text:match("^%* %.%.%.%s*$") or text:match("^%* …%s*$") then
        return "_3"
    end
    if text:match("^%* You finished using it%.$") then
        return "_4"
    end
    if text:match("^%* An uneasy atmosphere fills%s+the room%.$") then
        return "_5"
    end
    return nil
end

local function getUsePageKey(item_id, text, page)
    if type(item_id) ~= "string" then
        return nil
    end

    local base = "item_" .. item_id .. "_use_text"
    local suffix = usePageSuffix(text)
    local candidates = {}
    local seen = {}

    local function add(suffix_value)
        local key = base .. suffix_value
        if not seen[key] then
            seen[key] = true
            table.insert(candidates, key)
        end
    end

    if suffix ~= nil then
        add(suffix)
    end
    add(page == 1 and "" or "_" .. tostring(page))

    for _, key in ipairs(candidates) do
        if hasLocalization(key) then
            return key
        end
    end
    return nil
end

local USE_VERB_KEYS = {
    ate = "mgr_use_ate",
    eat = "mgr_use_eat",
    eats = "mgr_use_eat",
    consume = "mgr_use_consume",
    consumes = "mgr_use_consume",
    drank = "mgr_use_drank",
    drink = "mgr_use_drink",
    drinks = "mgr_use_drink",
}

local function localizeLine(line)
    if type(line) ~= "string" then
        return line
    end

    local match_text = stripControlCodes(line)
    local mapped = localizeMappedLine(line, match_text)
    if mapped then
        return mapped
    end

    local who, item = match_text:match("^%* (.-) used the (.+)%.$")
    if who and item then
        local localized_item = resolveItemName(item)
        if who == "You" then
            return preserveControlCodes(line, localize("mgr_item_used_target", line, { item = localized_item }))
        end
        return preserveControlCodes(line, localize("mgr_battle_item_used", line, {
            who = translatedWho(who), item = localized_item,
        }))
    end

    who = match_text:match("^%* (.-) finished using it%.$")
    if who then
        return preserveControlCodes(line, localize("mgr_item_finished_using", line, { who = translatedWho(who) }))
    end

    local amount
    who, amount = match_text:match("^%* (.-) lost ([%d%.]+)%s*HP%.$")
    if who and amount then
        return preserveControlCodes(line, localize("mgr_item_light_lost_hp", line, {
            who = translatedWho(who), amount = amount,
        }))
    end

    who, amount = match_text:match("^%* (.-) recovered ([%d%.]+)%s*HP!$")
    if who and amount then
        if who == "You" then
            return preserveControlCodes(line, localize("heal_recovered", line, { amount = amount }))
        end
        return preserveControlCodes(line, localize("mgr_item_recovered", line, {
            who = translatedWho(who), amount = amount,
        }))
    end

    local maxed_who = match_text:match("^%* (.-)'s HP was maxed out%.$")
    if maxed_who then
        return preserveControlCodes(line, localize("mgr_battle_hp_maxed", line, { who = translatedWho(maxed_who) }))
    end
    if match_text == "* Your HP was maxed out." then
        return preserveControlCodes(line, localize("mgr_battle_your_hp_maxed", line))
    end

    local who, verb, verb_item = match_text:match("^%* (.-) ([%a]+) the (.+)%.$")
    if who and verb and verb_item and USE_VERB_KEYS[verb] then
        local verb_key = USE_VERB_KEYS[verb]
        local localized_verb = localize(verb_key, verb)
        local localized_item = resolveItemName(verb_item)
        return preserveControlCodes(line, localize("mgr_item_light_use", line, {
            who = translatedWho(who),
            verb = localized_verb,
            item = localized_item,
        }))
    end

    local punch_who = match_text:match("^%* (.-) rips up the punch card!$")
    if punch_who then
        return preserveControlCodes(line, localize("mgr_punch_card_rip", line, {
            who = translatedWho(punch_who),
        }))
    end

    local burning_who = match_text:match("^%* (.-)'s hands are burning!$")
    burning_who = burning_who or match_text:match("^%* (Your) hands are burning!$")
    if burning_who then
        return preserveControlCodes(line, localize("mgr_punch_card_burning", line, {
            who = translatedWho(burning_who),
        }))
    end

    local attack_amount = match_text:match("^%* AT increased by (%d+)!$")
    if attack_amount then
        return preserveControlCodes(line, localize("mgr_punch_card_attack", line, {
            amount = attack_amount,
        }))
    end

    return line
end

local function localizeUseString(text, item_id, page, allow_page_keys)
    if type(text) ~= "string" then
        return text, item_id
    end

    local static_key = STATIC_USE_TEXT_KEYS[stripControlCodes(text)]
    if static_key and hasLocalization(static_key) then
        return preserveControlCodes(text, localize(static_key, text)), item_id
    end

    local item_name = extractItemName(text)
    if item_name then
        local _, detected_id = resolveItemName(item_name)
        item_id = detected_id or item_id
    end

    -- Item-specific pages are intended for the world-use sequence. Battle
    -- text contains a real user name, so it must use the variable template
    -- instead of replacing that name with the page-1 "You" translation.
    if allow_page_keys then
        local key = getUsePageKey(item_id, text, page)
        if key then
            local localized_item = item_name and resolveItemName(item_name) or nil
            return preserveControlCodes(text, localize(key, text, { item = localized_item })), item_id
        end
    end

    local match_text = stripControlCodes(text)
    local composite_item = match_text:match("^%* The rest of your inventory%s+filled%s+up with (.+)%.$")
    if composite_item then
        return preserveControlCodes(text, localize("mgr_item_inventory_filled", text, {
            item = resolveItemName(composite_item),
        })), item_id
    end

    if match_text:match("^%* An uneasy atmosphere fills%s+the room%.$") then
        return preserveControlCodes(text, localize("mgr_item_uneasy_atmosphere", text)), item_id
    end
    if match_text:match("^%* %.%.%.%s*$") or match_text:match("^%* …%s*$") then
        return preserveControlCodes(text, localize("mgr_item_ellipsis", text)), item_id
    end

    -- Keep explicit newlines intact while allowing the line rules above to
    -- handle messages composed by item classes (for example Bad Memory).
    return (text:gsub("[^\n]+", localizeLine)), item_id
end

local function localizeTextboxValue(value, textbox)
    if type(value) == "string" then
        return (localizeUseString(value, nil, 1, not textbox.battle_box))
    end
    if type(value) ~= "table" then
        return value
    end

    local out = {}
    local context = { item_id = nil }
    for index, page in ipairs(value) do
        local translated, item_id = localizeUseString(
            page, context.item_id, index, not textbox.battle_box
        )
        out[index] = translated
        context.item_id = item_id or context.item_id
    end
    for key, page in pairs(value) do
        if type(key) ~= "number" then
            out[key] = page
        end
    end
    return out
end

if HasI18N then
    function Textbox:setText(value, callback)
        value = localizeTextboxValue(value, self)
        return super.setText(self, value, callback)
    end
end

return Textbox
