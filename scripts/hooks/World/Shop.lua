-- Optional runtime switch: the main mod can disable the whole library via
-- mod.json config ({"magical-glass": {"enabled": false}}); see README.
if Mod and Mod.libs and Mod.libs["magical-glass"] and Kristal.getLibConfig and
    Kristal.getLibConfig("magical-glass", "enabled") == false then
    return Shop
end

local Shop, super = HookSystem.hookScript(Shop)

-- Automatically sets the world type to the shop type
function Shop:setShopWorldLight(value)
    if value then
        if Mod.libs["magical-glass"].last_shop_world_type == nil then
            Mod.libs["magical-glass"].last_shop_world_type = Game:isLight()
        end
        Game:setLight(false)
    else
        if Mod.libs["magical-glass"].last_shop_world_type ~= nil then
            Game:setLight(Mod.libs["magical-glass"].last_shop_world_type)
        end
        Mod.libs["magical-glass"].last_shop_world_type = nil
    end
end

function Shop:init()
    self:setShopWorldLight(true)

    super.init(self)
end

function Shop:leaveImmediate()
    self:setShopWorldLight(false)

    super.leaveImmediate(self)
end

return Shop