-- Optional kristal-i18n adapter: refresh MGR enemy texts on language switch.
-- The LightEnemyBattler adapter registers `i18n_refreshEnemy` on the
-- magical-glass library table; this hook re-applies it to live battles.
local HasI18N = Mod and Mod.libs and Mod.libs["kristalI18n"] ~= nil
local Game, super = HookSystem.hookScript(Game)

if HasI18N then
    function Game:setLanguage(...)
        local r = super.setLanguage(self, ...)
        local lib = Mod and Mod.libs and Mod.libs["magical-glass"]
        if lib and lib.i18n_refreshEnemy and Game.battle then
            for _, enemy in ipairs(Game.battle.enemies or {}) do
                lib.i18n_refreshEnemy(enemy)
            end
        end
        return r
    end
end

return Game
