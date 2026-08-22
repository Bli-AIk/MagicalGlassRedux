-- Optional runtime switch: the main mod can disable the whole library via
-- mod.json config ({"magical-glass": {"enabled": false}}); see README.
if Mod and Mod.libs and Mod.libs["magical-glass"] and Kristal.getLibConfig and
    Kristal.getLibConfig("magical-glass", "enabled") == false then
    return TextChoicebox
end

local TextChoicebox, super = HookSystem.hookScript(TextChoicebox)

function TextChoicebox:update()
    local old_choice = self.current_choice

    super.update(self)

    if self.added_text_boxes and not self:isTyping() and self.current_choice ~= old_choice and Kristal.getLibConfig("magical-glass", "text_choicebox_sound") then
        Assets.stopAndPlaySound("ui_move")
    end
end

return TextChoicebox