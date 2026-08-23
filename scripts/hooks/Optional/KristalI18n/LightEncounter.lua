-- Optional kristal-i18n adapter: default light-battle flee messages.
local HasI18N = Mod and Mod.libs and Mod.libs["kristalI18n"] ~= nil

local LightEncounter, super = HookSystem.hookScript(LightEncounter)

local function callLoc(key, fallback)
    if HasI18N and Game and Game.hasStr and Game:hasStr(key) then
        return Game:loc(key)
    end
    return fallback
end

local DEFAULT_FLEE_MESSAGES = {
    ["* I'm outta here."] = "mgr_battle_flee_outta_here",
    ["* I've got better to do."] = "mgr_battle_flee_better_to_do",
    ["* Don't slow me down."] = "mgr_battle_flee_dont_slow_me_down",
    ["* Escaped..."] = "mgr_battle_flee_escaped",
}

if HasI18N then
    function LightEncounter:getFleeMessage(...)
        local message = super.getFleeMessage(self, ...)
        local key = DEFAULT_FLEE_MESSAGES[message]
        if key then
            return callLoc(key, message)
        end
        return message
    end
end

return LightEncounter
