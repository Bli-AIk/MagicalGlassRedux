-- Optional runtime switch: the main mod can disable the whole library via
-- mod.json config ({"magical-glass": {"enabled": false}}); see README.
if Mod and Mod.libs and Mod.libs["magical-glass"] and Kristal.getLibConfig and
    Kristal.getLibConfig("magical-glass", "enabled") == false then
    return Spell
end

local Spell, super = HookSystem.hookScript(Spell)

-- Optional kristal-i18n: spell checks are MGR-only fields (the i18n Spell
-- adapter covers name/description/castMessage). Localize per page like
-- Item:getCheck; the ACT spell's check is chapter-scoped in the data, so
-- keys get the same _chapter_<n> treatment as the i18n Spell adapter.
local HasI18N = Mod and Mod.libs and Mod.libs["kristalI18n"] ~= nil
local function loc(key, fallback)
    if HasI18N and Game and Game.hasStr and Game:hasStr(key) then
        return Game:loc(key)
    end
    return fallback
end
local function locChapter(key, fallback)
    local chapter = tonumber(Game.chapter) or 1
    chapter = math.max(1, math.min(5, chapter))
    return loc(key .. "_chapter_" .. tostring(chapter), loc(key, fallback))
end

function Spell:init()
    super.init(self)

    self.check = "Example info"
end

-- Spell check text mirrors the spell description (MGR data keeps both
-- fields; only `check` drives the INFO window). Rendering therefore reads
-- the existing spell_<id>_description keys (en/zh) as one page — spell
-- descriptions are 1-2 lines, so paging isn't needed — and falls back to
-- the merged MGR fields when no key exists. `self.check` itself stays an
-- upstream MGR API data field, untouched.
function Spell:getCheck()
    local text = self.description
    local check = self.check
    if type(check) == "table" then
        text = table.concat(check, "\n")
    elseif type(check) == "string" and not check:find("Example info", 1, true) then
        text = check
    end
    return locChapter("spell_" .. self.id .. "_description", text)
end

function Spell:onCheck()
    if type(self:getCheck()) == "table" then
        local text
        for i, check in ipairs(self:getCheck()) do
            if i > 1 then
                if text == nil then
                    text = {}
                end
                table.insert(text, check)
            end
        end
        Game.world:showText({ { "* \"" .. self:getName() .. "\" - " .. (self:getCheck()[1] or "") }, text })
    else
        Game.world:showText("* \"" .. self:getName() .. "\" - " .. self:getCheck())
    end
end

function Spell:onLightStart(user, target)
    -- Used for the "You recovered X HP!"
    Mod.libs["magical-glass"].heal_amount = nil
    -- Delays the turn of the user if using a harmful spell to prevent stacking damage spells on the same target
    if TableUtils.contains(self.tags, "damage") then
        user.delay_turn_end = true
    end
    local result = self:onLightCast(user, target)
    Game.battle:battleText(self:getLightCastMessage(user, target))
    if result or result == nil then
        Game.battle:finishActionBy(user)
    end
end

function Spell:onLightCast(user, target)
    return self:onCast(user, target)
end

function Spell:getLightCastMessage(user, target)
    return string.format("* %s cast %s!", user.chara:getNameOrYou(), self:getName()) .. (TableUtils.contains(self.tags, "heal") and self:getHealMessage(user, target, Mod.libs["magical-glass"].heal_amount) and "\n" .. self:getHealMessage(user, target, Mod.libs["magical-glass"].heal_amount) or "")
end

function Spell:onLightWorldStart(user, target)
    Mod.libs["magical-glass"].heal_amount = nil
    self:onLightWorldCast(target)
    Game.world:showText(self:getLightWorldCastMessage(user, target))
end

function Spell:onLightWorldCast(target)
    self:onWorldCast(target)
end

function Spell:getLightWorldCastMessage(user, target)
    return string.format("* %s cast %s.", user:getNameOrYou(), self:getName()) .. (TableUtils.contains(self.tags, "heal") and self:getWorldHealMessage(user, target, Mod.libs["magical-glass"].heal_amount) and "\n" .. self:getWorldHealMessage(user, target, Mod.libs["magical-glass"].heal_amount) or "")
end

function Spell:getWorldHealMessage(user, target, amount)
    local maxed = false
    if self.target == "ally" then
        maxed = target:getHealth() >= target:getStat("health") or amount == math.huge
    elseif self.target == "party" and #Game.party == 1 then
        maxed = target[1]:getHealth() >= target[1]:getStat("health") or amount == math.huge
    end

    local message = ""

    if self.target == "ally" then
        if select(2, target:getNameOrYou()) and maxed then
            message = "* Your HP was maxed out."
        elseif maxed then
            message = string.format("* %s's HP was maxed out.", target:getNameOrYou())
        else
            message = string.format("* %s recovered %s HP!", target:getNameOrYou(), amount)
        end

    elseif self.target == "party" then
        if #Game.party > 1 then
            message = string.format("* Everyone recovered %s HP!", amount)
        elseif maxed then
            message = "* Your HP was maxed out."
        else
            message = string.format("* You recovered %s HP!", amount)
        end
    end

    return message
end

function Spell:getHealMessage(user, target, amount)
    local maxed = false
    if self.target == "ally" then
        maxed = target.chara:getHealth() >= target.chara:getStat("health") or amount == math.huge
    elseif self.target == "enemy" then
        maxed = target.health >= target.max_health or amount == math.huge
    elseif self.target == "party" and #Game.battle.party == 1 then
        maxed = target[1].chara:getHealth() >= target[1].chara:getStat("health") or amount == math.huge
    end

    local message = ""

    if self.target == "ally" then
        if select(2, target.chara:getNameOrYou()) and maxed then
            message = "* Your HP was maxed out."
        elseif maxed then
            message = string.format("* %s's HP was maxed out.", target.chara:getNameOrYou())
        else
            message = string.format("* %s recovered %s HP!", target.chara:getNameOrYou(), amount)
        end

    elseif self.target == "party" then
        if #Game.battle.party > 1 then
            message = string.format("* Everyone recovered %s HP!", amount)
        elseif maxed then
            message = "* Your HP was maxed out."
        else
            message = string.format("* You recovered %s HP!", amount)
        end

    elseif self.target == "enemy" then
        if maxed then
            message = string.format("* %s's HP was maxed out.", target.name)
        else
            message = string.format("* %s recovered %s HP!", target.name, amount)
        end

    elseif self.target == "enemies" then
        message = string.format("* The enemies recovered %s HP!", amount)
    end

    return message
end

return Spell