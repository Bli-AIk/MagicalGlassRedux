-- Optional kristal-i18n adapter: MGR item short/serious names.
--
-- kristal-i18n's Item hook covers name/description/check/shopDesc/etc, but
-- NOT getShortName/getSeriousName — MGR's UT-style light inventory shows the
-- short names ("ButtsPie"), which stayed English. Same hasStr-guarded loc
-- pattern; keys: item_<id>_shortName / item_<id>_seriousName.
local HasI18N = Mod and Mod.libs and Mod.libs["kristalI18n"] ~= nil
-- Optional runtime switch: the main mod can disable the whole library via
-- mod.json config ({"magical-glass": {"enabled": false}}); see README.
if Mod and Mod.libs and Mod.libs["magical-glass"] and Kristal.getLibConfig and
    Kristal.getLibConfig("magical-glass", "enabled") == false then
    return Item
end

local Item, super = HookSystem.hookScript(Item)

local function loc(key, fallback)
    if HasI18N and Game and Game.hasStr and Game:hasStr(key) then
        return Game:loc(key)
    end
    return fallback
end

if HasI18N then
    function Item:getShortName()
        return loc("item_" .. self.id .. "_shortName", super.getShortName(self))
    end

    function Item:getSeriousName()
        return loc("item_" .. self.id .. "_seriousName", super.getSeriousName(self))
    end
end

return Item
