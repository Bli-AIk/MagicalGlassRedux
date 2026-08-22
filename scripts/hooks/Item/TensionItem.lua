-- Optional runtime switch: the main mod can disable the whole library via
-- mod.json config ({"magical-glass": {"enabled": false}}); see README.
if Mod and Mod.libs and Mod.libs["magical-glass"] and Kristal.getLibConfig and
    Kristal.getLibConfig("magical-glass", "enabled") == false then
    return TensionItem
end

local TensionItem, super = HookSystem.hookScript(TensionItem)

-- Support for light battles
function TensionItem:onBattleSelect(user, target)
    if Game.battle.light then
        self.tension_given = Game:giveTension(self:getTensionAmount())

        local sound = Assets.newSound("cardrive")
        sound:setPitch(1.4)
        sound:setVolume(0.8)
        sound:play()
    else
        super.onBattleSelect(self, user, target)
    end
end

return TensionItem