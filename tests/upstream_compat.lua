-- Match the enemy-state extension points added by Kristal eaf9e0e.
Object = {}
function Class(base)
    if type(base) == "string" then
        base = { getLightCastMessage = function() return "cast" end }
    end
    return setmetatable({}, { __index = base }), base
end
local Enemy = dofile("scripts/globals/LightBattle/LightEnemyBattler.lua")
local priority = false
Game = {
    getConfig = function(_, key) return key == "oldPacify" or priority end,
    battle = { timer = { after = function() end } },
}
Kristal = { getLibConfig = function() return false end }
TableUtils = { pick = function(values) return values[1] end }

local enemy = setmetatable({
    tired = false, health = 100, max_health = 100, low_health_percentage = 0.5,
    mercy = 0, text = { "idle" },
}, { __index = Enemy })
assert(not enemy:isTired())
assert(not enemy:hasLowHealth())
enemy.health = 50
assert(enemy:hasLowHealth())

local events = {}
enemy.onTired = function() events[#events + 1] = "tired" end
enemy.onAwake = function() events[#events + 1] = "awake" end
enemy:setTired(true)
enemy:setTired(true)
enemy:setTired(false)
assert(table.concat(events, ",") == "tired,tired,awake")

-- Getters may return portraits/actors as well as text, and override raw fields.
enemy.spareable_text, enemy.low_health_text, enemy.tired_text = nil, nil, nil
enemy.getSpareableText = function() return "spare", "portrait", "actor" end
enemy.getLowHealthText = function() return "low", "low_portrait" end
enemy.getTiredText = function() return "tired" end
enemy.hasLowHealth = function() return false end
enemy.isTired = function() return false end
assert(enemy:getEncounterText() == "idle")
enemy.isTired = function() return true end
assert(enemy:getEncounterText() == "tired")
enemy.hasLowHealth = function() return true end
local text, portrait = enemy:getEncounterText()
assert(text == "low" and portrait == "low_portrait")
priority, enemy.mercy = true, 100
local text, portrait, actor = enemy:getEncounterText()
assert(text == "spare" and portrait == "portrait" and actor == "actor")

-- Light spells must use the same getter as the menu/encounter system.
local pacify = dofile("scripts/data/spells/pacify.lua")
local spared = false
local target = {
    tired = false, mercy = 0, isTired = function() return true end,
    spare = function(_, success) spared = success end,
}
assert(pacify:getLightCastMessage({}, target) == "cast")
pacify:onLightCast({}, target)
assert(spared)
local sleep_mist = dofile("scripts/data/spells/sleep_mist.lua")
local awake = { tired = true, isTired = function() return false end }
sleep_mist:onLightCast({}, { target, awake })
assert(target.done_state == "PACIFIED" and awake.done_state == nil)

-- Preserve MGR's custom shake strength and the option to disable it.
local shakes = 0
enemy.getActiveSprite = function()
    return { shake = function(_, x) assert(x == 6); shakes = shakes + 1 end }
end
enemy.can_shake = true
enemy:applyDamageShake()
enemy.can_shake = false
enemy:applyDamageShake()
assert(shakes == 1)

print("light battle upstream compatibility: PASS")
