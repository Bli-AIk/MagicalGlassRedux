-- Optional runtime switch: the main mod can disable the whole library via
-- mod.json config ({"magical-glass": {"enabled": false}}); see README.
if Mod and Mod.libs and Mod.libs["magical-glass"] and Kristal.getLibConfig and
    Kristal.getLibConfig("magical-glass", "enabled") == false then
    return GameOver
end

local GameOver, super = HookSystem.hookScript(GameOver)

function GameOver:init(x, y)
    super.init(self, x, y)

    if Game:isLight() then
        self.screenshot = love.graphics.newImage(SCREEN_CANVAS:newImageData())
    end

    -- Prevents skipping the game over screen by rapidly pressing the confirm button (if disabled)
    if not Kristal.getLibConfig("magical-glass", "gameover_skipping")[1] and not Game:isLight() or not Kristal.getLibConfig("magical-glass", "gameover_skipping")[2] and Game:isLight() then
        self.skipping = -math.huge
    end

     -- Battle type screenshot timer (a frame in light battles)
    if Game.battle then
        if Game.battle.light then
            self.timer = 28
        else
            self.timer = 0
        end
    end
end

return GameOver