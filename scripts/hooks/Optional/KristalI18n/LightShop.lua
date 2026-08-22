-- Optional kristal-i18n adapter: LightShop UI strings.
-- When the kristalI18n library is absent, this hook script is inert (it only
-- wraps LightShop:draw to translate known source strings; without i18n the
-- translation map always falls back to the original text).
local HasI18N = Mod and Mod.libs and Mod.libs["kristalI18n"] ~= nil
-- Optional runtime switch: the main mod can disable the whole library via
-- mod.json config ({"magical-glass": {"enabled": false}}); see README.
if Mod and Mod.libs and Mod.libs["magical-glass"] and Kristal.getLibConfig and
    Kristal.getLibConfig("magical-glass", "enabled") == false then
    return LightShop
end

local LightShop, super = HookSystem.hookScript(LightShop)

local function loc(key, fallback, var)
    if HasI18N and Game and Game.hasStr and Game:hasStr(key) then
        return Game:loc(key, var)
    end
    return fallback
end

-- Exact source strings used by LightShop (see scripts/globals/LightShop.lua:
-- self.* texts, menu_options and sell_options, plus the draw-time literals).
local SHOP_TEXT_IDS = {
    ["Buy"] = "mgr_shop_buy",
    ["Sell"] = "mgr_shop_sell",
    ["Talk"] = "mgr_shop_talk",
    ["Exit"] = "mgr_shop_exit",
    ["Return"] = "mgr_shop_return",
    ["Sell Items"] = "mgr_shop_sell_items",
    ["Sell Box A Items"] = "mgr_shop_sell_box_a",
    ["Sell Box B Items"] = "mgr_shop_sell_box_b",
    ["SOLD OUT"] = "mgr_shop_sold_out",
    ["--- SOLD OUT ---"] = "mgr_shop_sold_out_banner",
    ["Not\nenough\nmoney."] = "mgr_shop_too_expensive",
    ["You're\ncarrying\ntoo much."] = "mgr_shop_no_space",
    ["Out of\nstock."] = "mgr_shop_sold_out_item",
    ["Sell\nmenu\ntext"] = "mgr_shop_menu_text",
    ["Sell %s for %s ?"] = "mgr_shop_sell_confirm",
    ["Yes"] = "mgr_shop_yes",
    ["No"] = "mgr_shop_no",
    ["Yes and Exit"] = "mgr_shop_yes_and_exit",
    ["Sold\neverything\ntext"] = "mgr_shop_sold_everything",
    ["Empty\ninventory\ntext"] = "mgr_shop_empty_inventory",
    ["* Empty inventory text"] = "mgr_shop_empty_inventory_encounter",
    ["Talk\ntext"] = "mgr_shop_talk_text",
}

-- Formatted confirmation strings ("Sell %s for %s ?" is string.format'd before
-- printing, so match it by pattern and re-localize with `Game:loc` vars.
local function localizeShopText(text)
    if type(text) ~= "string" then
        return text
    end
    local id = SHOP_TEXT_IDS[text]
    if id then
        return loc(id, text)
    end
    local item, money = text:match("^Sell (.+) for (.+) %?$")
    if item and money then
        return loc("mgr_shop_sell_confirm", text, { item = item, money = money })
    end
    return text
end

if HasI18N then
    function LightShop:draw(...)
        local args = { ... }
        local original_print = love.graphics.print
        love.graphics.print = function(text, ...)
            return original_print(localizeShopText(text), ...)
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

return LightShop
