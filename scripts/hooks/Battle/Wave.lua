-- Optional runtime switch: the main mod can disable the whole library via
-- mod.json config ({"magical-glass": {"enabled": false}}); see README.
if Mod and Mod.libs and Mod.libs["magical-glass"] and Kristal.getLibConfig and
    Kristal.getLibConfig("magical-glass", "enabled") == false then
    return Wave
end

local Wave, super = HookSystem.hookScript(Wave)

function Wave:spawnBulletTo(parent, bullet, ...)
    local new_bullet = super.spawnBulletTo(self, parent, bullet, ...)

    if new_bullet:includes(LightBullet) then
        error("Attempted to use LightBullet in a DarkBattle. Convert \"" .. bullet .. "\" to a Bullet")
    end

    return new_bullet
end

return Wave