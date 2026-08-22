-- Optional runtime switch: the main mod can disable the whole library via
-- mod.json config ({"magical-glass": {"enabled": false}}); see README.
if Mod and Mod.libs and Mod.libs["magical-glass"] and Kristal.getLibConfig and
    Kristal.getLibConfig("magical-glass", "enabled") == false then
    return Arena
end

local Arena, super = HookSystem.hookScript(Arena)

-- Sets the arena default color in the light world to white
function Arena:init(x, y, shape)
    super.init(self, x, y, shape)

    if Game:isLight() then
        self.color = { 1, 1, 1 }
    end
end

return Arena