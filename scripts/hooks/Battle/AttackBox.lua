-- Optional runtime switch: the main mod can disable the whole library via
-- mod.json config ({"magical-glass": {"enabled": false}}); see README.
if Mod and Mod.libs and Mod.libs["magical-glass"] and Kristal.getLibConfig and
    Kristal.getLibConfig("magical-glass", "enabled") == false then
    return AttackBox
end

local AttackBox, super = HookSystem.hookScript(AttackBox)

function AttackBox:init(battler, offset, index, x, y)
    super.init(self, battler, offset, index, x, y)

    -- Color the head sprites in the light world
    if Kristal.getLibConfig("magical-glass", "light_world_dark_battle_color_override") and Game:isLight() then
        self.head_sprite:addFX(ShaderFX("color", { targetColor = MG_PALETTE["light_world_dark_battle_color"] }))
    end
end

return AttackBox