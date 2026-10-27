-- Exercise the real menu draw methods without starting the graphics engine.
local printed = {}
local hours_enabled = false
local preview = {}

Object = { draw = function() end }
function Class(base)
    return setmetatable({}, { __index = base }), base
end

love = { graphics = {
    setFont = function() end,
    print = function(value)
        assert(value ~= nil, "menu attempted to print a missing value")
        printed[#printed + 1] = tostring(value)
    end,
    printf = function(value) printed[#printed + 1] = tostring(value) end,
} }
Draw = { setColor = function() end, draw = function() end }
PALETTE = {}
SCREEN_WIDTH = 640
Kristal = { getLibConfig = function(_, key)
    assert(key == "light_save_menu_hours")
    return hours_enabled
end }
Game = {
    party = {},
    getSoulColor = function() return 1, 0, 0 end,
    getSavePreview = function() return preview end,
}

local Undertale = dofile("scripts/objects/World/LightSaveMenuUndertale.lua")
local Expanded = dofile("scripts/objects/World/LightSaveMenuExpanded.lua")
local font = { getWidth = function(_, text) return #text * 8 end }

local function expect_time(expected, draw)
    printed = {}
    draw()
    for _, text in ipairs(printed) do
        if text == expected then return end
    end
    error("expected formatted playtime " .. expected)
end

for _, hours in ipairs({ false, true }) do
    hours_enabled = hours
    local empty_time = hours and "0:00:00" or "0:00"
    local saved_time = hours and "1:01:01" or "61:01"
    local menu = { state = "MAIN", box = { x = 0, y = 0 }, selected_x = 1 }

    -- A never-used slot has no save table at all.
    expect_time(empty_time, function() Undertale.draw(menu) end)
    menu.saved_file = {}
    expect_time(empty_time, function() Undertale.draw(menu) end)
    menu.saved_file = { playtime = 3661 }
    expect_time(saved_time, function() Undertale.draw(menu) end)

    local expanded = setmetatable({
        state = "MAIN", main_box = { x = 0, y = 0 }, selected_x = 1,
        font = font,
    }, { __index = Expanded })
    preview = {}
    expect_time(empty_time, function() Expanded.draw(expanded) end)
    preview = { name = "CHARA", room_name = "Start", playtime = 3661 }
    expect_time(saved_time, function() Expanded.draw(expanded) end)

    -- Existing saves from earlier versions may lack their playtime field.
    local old_save = { name = "CHARA", room_name = "Start" }
    expect_time(empty_time, function()
        Expanded.drawSaveFile(expanded, 1, old_save, 0, 0, false, false)
    end)
    expect_time(saved_time, function()
        Expanded.drawSaveFile(expanded, 1, preview, 0, 0, false, false)
    end)
    Expanded.drawSaveFile(expanded, 2, nil, 0, 0, false, false)

    preview = old_save
    expanded.state = "OVERWRITE"
    expanded.selected_y = 1
    expanded.saves = { old_save }
    expect_time(empty_time, function() Expanded.draw(expanded) end)
end

print("save menu playtime: PASS")
