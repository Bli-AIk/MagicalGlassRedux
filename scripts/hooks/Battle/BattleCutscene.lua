-- Optional runtime switch: the main mod can disable the whole library via
-- mod.json config ({"magical-glass": {"enabled": false}}); see README.
if Mod and Mod.libs and Mod.libs["magical-glass"] and Kristal.getLibConfig and
    Kristal.getLibConfig("magical-glass", "enabled") == false then
    return BattleCutscene
end

local BattleCutscene, super = HookSystem.hookScript(BattleCutscene)

function BattleCutscene:text(text, portrait, actor, options)
    return super.text(self, Game.battle.light and ("[shake:" .. Mod.libs["magical-glass"].light_battle_shake_text .. "]" .. text) or text, portrait, actor, options)
end

function BattleCutscene:choicer(choices, options)
    options = options or {}

    -- Whether to use an Undertale variation choicer
    Game.battle.battle_ui.choice_box.undertale = options["undertale"]

    return super.choicer(self, choices, options)
end

return BattleCutscene