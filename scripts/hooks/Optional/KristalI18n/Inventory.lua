-- Optional kristal-i18n adapter: capture the targeted item type for the
-- "Use <item> on" target bar (equip vs. use wording).
--
-- The LightItemMenu:update chain cannot be used: MGR's update calls
-- super.update only in the ITEMSELECT branch, so an inner adapter hook never
-- runs while the target bar (PARTYSELECT) is displayed. Instead capture at
-- Inventory:getItem — the bar's draw calls getItem right before composing
-- "Use <item> on", so the last fetched item IS the displayed one. No MGR or
-- i18n hook occupies Inventory:getItem, so no chaining/shadowing concerns.
local HasI18N = Mod and Mod.libs and Mod.libs["kristalI18n"] ~= nil
local Inventory, super = HookSystem.hookScript(Inventory)

if HasI18N then
    function Inventory:getItem(...)
        local item = super.getItem(self, ...)
        if type(item) == "table" and Mod and Mod.libs and Mod.libs["magical-glass"] then
            Mod.libs["magical-glass"].i18n_target_item_type = item.type
        end
        return item
    end
end

return Inventory
