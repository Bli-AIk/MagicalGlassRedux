local DebugSystem, super = HookSystem.hookScript(DebugSystem)

local GIVE_ITEM_MENUS = {
    kristal_dark_give_item = true,
    kristal_light_give_item = true,
    dark_give_item = true,
    light_give_item = true,
    ut_give_item = true,
}

local function isGiveItemLabel(menu, text, align, limit, sx, sy)
    return GIVE_ITEM_MENUS[menu]
        and type(text) == "string"
        and align == nil
        and limit == nil
        and sx == nil
        and sy == nil
        and text:match("^%([^)]*%) %| .+$") ~= nil
end

local function getItemLabelText(self, text)
    local cjk = rawget(_G, "kristalI18nCjk")
    local spacing = cjk and cjk.settings and cjk.settings.cjkFixedTextSpacing or 0
    local is_cjk = cjk and cjk.isCjkCodepoint
    local cache = self.mgr_debug_item_label_cache

    if not cache or cache.font ~= self.font or cache.spacing ~= spacing or cache.is_cjk ~= is_cjk then
        cache = {
            font = self.font,
            spacing = spacing,
            is_cjk = is_cjk,
            labels = {},
        }
        self.mgr_debug_item_label_cache = cache
    end

    local label = cache.labels[text]
    if label then
        return label
    end

    -- The CJK printf hook draws each glyph separately to apply spacing. Build
    -- the static debug label once instead, so scrolling does not redo that work.
    love.graphics.push("all")
    love.graphics.setColor(1, 1, 1, 1)
    label = love.graphics.newText(self.font, "")

    local x = 0
    for _, codepoint in utf8.codes(text) do
        local char = utf8.char(codepoint)
        label:add(char, x, 0)
        x = x + self.font:getWidth(char)
        if is_cjk and is_cjk(codepoint) then
            x = x + spacing
        end
    end

    love.graphics.pop()
    cache.labels[text] = label
    return label
end

function DebugSystem:init()
    super.init(self)

    self.light_selected_waves = {}
end

function DebugSystem:refresh()
    super.refresh(self)

    self.light_selected_waves = {}
    self.mgr_debug_item_label_cache = nil
end

function DebugSystem:update()
    super.update(self)

    if self:isMenuOpen() then

        for state, menus in pairs(self.exclusive_battle_menus) do
            if state == "DARKBATTLE" then
                state = false
            elseif state == "LIGHTBATTLE" then
                state = true
            end
            if TableUtils.contains(menus, self.current_menu) and type(state) == "boolean" and Game.battle and Game.battle.light ~= state then
                self:refresh()
            end
        end

        for state, menus in pairs(self.exclusive_world_menus) do
            if state == "DARKWORLD" then
                state = false
            elseif state == "LIGHTWORLD" then
                state = true
            end
            if TableUtils.contains(menus, self.current_menu) and type(state) == "boolean" and Game:isLight() ~= state then
                self:refresh()
            end
        end

    end
end

function DebugSystem:returnMenu()
    super.returnMenu(self)

    -- Moves the menu to the top when returning
    if not (#self.menu_history == 0) then
        self.menu_target_y = 0
    end
end

function DebugSystem:enterMenu(menu, soul, skip_history)
    -- Fixes an issue where non-search menus would have the selected slot at the bottom instead of the top
    if self.menus[menu].type ~= "search" and soul == 0 then
        soul = 1
    end

    super.enterMenu(self, menu, soul, skip_history)

    -- Moves the menu to the top when entering
    self.menu_target_y = 0
end

function DebugSystem:printShadow(text, x, y, color, align, limit, sx, sy)
    if isGiveItemLabel(self.current_menu, text, align, limit, sx, sy) then
        color = color or { 1, 1, 1, 1 }
        love.graphics.setFont(self.font)

        local label = getItemLabelText(self, text)
        Draw.setColor({ 0, 0, 0, color[4] })
        Draw.draw(label, x + 2, y + 2)
        Draw.setColor(color)
        Draw.draw(label, x, y)
        return
    end

    return super.printShadow(self, text, x, y, color, align, limit, sx, sy)
end

return DebugSystem
