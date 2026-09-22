local FleeButton, super = Class(ActionButton)

-- A dark battle action button which lets to toggle between the spare and flee button by pressing up or down while hovering on either of them
function FleeButton:init(flee_only)
    super.init(self, nil)

    self.flee_only = flee_only -- Whether to disallow changing to the spare button
    self.flee_mode = self.flee_only

    -- Which of the two sprites is currently drawn
    self.displayed_type = self.flee_mode and "flee" or "spare"

    self.delay_timer = 0
end

function FleeButton:update()
    super.update(self)

    self.delay_timer = MathUtils.approach(self.delay_timer, 0, DTMULT)
    local battle_leader
    for i, battler in ipairs(Game.battle.party) do
        if not battler.is_down and not battler.sleeping and not (Game.battle:getActionBy(battler) and Game.battle:getActionBy(battler).action == "AUTOATTACK") then
            battle_leader = battler.chara.id
            break
        end
    end

    if not self.flee_only then
        if Game.battle:getPartyIndex(battle_leader) == Game.battle.current_selecting and Game.battle.encounter:canFlee() and not self.disabled then
            if self.hovered and (Input.pressed("up") or Input.pressed("down")) then
                if self.flee_mode then
                    self.flee_mode = false
                else
                    self.flee_mode = true
                end
                Game.battle.ui_move:stop()
                Game.battle.ui_move:play()
            end
        elseif self.flee_mode then
            self.flee_mode = false
            self.delay_timer = 2
        end
    end

    if self.delay_timer <= 0 then
        self.displayed_type = self.flee_mode and "flee" or "spare"
    end
end

-- The "flee" or "spare" sprite currently drawn
function FleeButton:getDisplayedType()
    return self.displayed_type
end

function FleeButton:getTexture()
    return Assets.getTexture("ui/battle/btn/" .. self:getDisplayedType())
end

function FleeButton:getHoveredTexture()
    return Assets.getTexture("ui/battle/btn/" .. self:getDisplayedType() .. "_h")
end

function FleeButton:getSpecialTexture()
    return Assets.getTexture("ui/battle/btn/" .. self:getDisplayedType() .. "_a")
end

function FleeButton:getDisabledTexture()
    return Assets.getTexture("ui/battle/btn/" .. self:getDisplayedType() .. "_d")
end

function FleeButton:select()
    if self.flee_mode then
        if Game.battle.encounter:canFlee() then
            local chance = Game.battle.encounter.flee_chance

            for _, party in ipairs(Game.battle.party) do
                for _, equip in ipairs(party.chara:getEquipment()) do
                    chance = chance + (equip:getFleeBonus() / #Game.battle.party or 0)
                end
            end

            chance = math.floor(chance)

            if chance >= MathUtils.round(MathUtils.random(1, 100)) then
                Game.battle:onFlee()
            else
                Game.battle.current_selecting = 0
                Game.battle:setState("ENEMYDIALOGUE", "FLEEFAIL")
                Game.battle.encounter:onFleeFail()
            end
        else
            Game.battle:setEncounterText({ text = "* You attempted to escape,\n[wait:5]but it failed." })
        end
    else
        Game.battle:setState("ENEMYSELECT", "SPARE")
    end
end

function FleeButton:hasSpecial()
    if not self.flee_mode then
        for _, enemy in ipairs(Game.battle:getActiveEnemies()) do
            if enemy.mercy >= 100 then
                return true
            end
        end
    end
    return false
end

return FleeButton