-- Optional kristal-i18n adapter: capture the targeted item type for the
-- "Use <item> on" target bar (equip vs. use wording).
--
-- MGR's LightItemMenu:update calls super.update, so a class hook registered
-- before MGR's is still reachable (unlike draw, which never chains). The
-- captured type is shared with the draw-time translator in LightMenu.lua via
-- the magical-glass library table.
local HasI18N = Mod and Mod.libs and Mod.libs["kristalI18n"] ~= nil
local LightItemMenu, super = HookSystem.hookScript(LightItemMenu)

if HasI18N then
    function LightItemMenu:update(...)
        local r = super.update(self, ...)
        if self.state == "PARTYSELECT" and Game and Game.inventory then
            local item = Game.inventory:getItem(self.storage, self.item_selecting)
            if Mod and Mod.libs and Mod.libs["magical-glass"] then
                Mod.libs["magical-glass"].i18n_target_item_type = item and item.type or nil
            end
        end
        return r
    end
end

return LightItemMenu
