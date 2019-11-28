local math2d = require('__core__/lualib/math2d')
local util = require('__core__/lualib/util')

-- returns the player and his global table
function util.get_player(obj)
    if type(obj) == 'number' then return game.players[obj], global.players[obj] -- gave the player_index itself
    elseif obj.index then return game.players[obj.index], global.players[obj.index] -- gave a player object
    else return game.players[obj.player_index], global.players[obj.player_index] end -- gave the event table
end

-- just returns the player table
function util.player_table(obj)
    if type(obj) == 'number' then return global.players[obj] -- gave the player_index itself
    elseif obj.index then return global.players[obj.index] -- gave a player object
    else return global.players[obj.player_index] end -- gave the event table
end

-- prints the contents of the event table
function util.debug_print(e)
    print(serpent.block(e))
end

util.constants = {
    -- commonly-used set of events for when an entity is built
    entity_built_events = {
        defines.events.on_built_entity,
        defines.events.on_robot_built_entity,
        defines.events.script_raised_built,
        defines.events.script_raised_revive
    },
    -- commonly-used set of events for when an entity is destroyed
    entity_destroyed_events = {
        defines.events.on_player_mined_entity,
        defines.events.on_robot_mined_entity,
        defines.events.on_entity_died,
        defines.events.script_raised_destroy
    },
    -- close button for frames, as defined in the titlebar submodule
    close_button_def = {
        name = 'close',
        sprite = 'utility/close_white',
        hovered_sprite = 'utility/close_black',
        clicked_sprite = 'utility/close_black'
    }
}

util.area = math2d.bounding_box
util.position = math2d.position

util.textfield = {}

function util.textfield.clamp_number_input(element, clamps, last_value)
    local text = element.text
    if text == ''
    or (clamps[1] and tonumber(text) < clamps[1])
    or (clamps[2] and tonumber(text) > clamps[2]) then
        element.style = 'ee_invalid_slider_textfield'
    else
        element.style = 'ee_slider_textfield'
        last_value = text
    end
    return last_value
end

function util.textfield.set_last_valid_value(element, last_value)
    if element.text ~= last_value then
        element.text = last_value
        element.style = 'ee_slider_textfield'
    end
    return element.text
end

-- -- ----------------------------------------------------------------------------------------------------
-- -- GUI

-- -- close open_gui on escape
-- on_event(defines.events.on_gui_closed, function(e)
--     local player = util.get_player(e)
--     local player_table = util.player_table(player)
--     local open_gui = player_table.open_gui
--     if open_gui and open_gui.element == e.element then
--         open_gui.element.destroy()
--         if player_table[open_gui.data_to_destroy] then
--             player_table[open_gui.data_to_destroy] = nil
--         end
--         player_table.open_gui = nil
--     end
-- end)

-- -- handle open_gui close buttons
-- on_event(defines.events.on_gui_click, function(e)
--     local player = util.get_player(e)
--     local open_gui = util.player_table(player).open_gui
--     if open_gui and open_gui.close_button and open_gui.close_button == e.element then
--         open_gui.element.destroy()
--         open_gui = nil
--     end
-- end)

-- function util.set_open_gui(player, element, close_button, data_to_destroy)
--     util.player_table(player).open_gui = {
--         element = element,
--         location = element.location,
--         close_button = close_button or nil,
--         data_to_destroy = data_to_destroy or nil
--     }
--     player.opened = element
-- end

-- -- ----------------------------------------------------------------------------------------------------
-- -- GLOBAL

-- local function player_setup(e)
--     global.players[e.player_index] = {}
-- end

-- on_event('on_init', function(e)
--     global.players = {}
--     global.cheats = {}
--     for i,p in pairs(game.players) do
--         player_setup{player_index=i}
--     end
-- end)

-- on_event(defines.events.on_player_created, function(e)
--     player_setup(e)
-- end)

-- function util.player_table(player)
--     if type(player) == 'number' then
--         return global.players[player]
--     end
--     return global.players[player.index]
-- end

-- function util.cheat_table(category, name, obj)
--     if not name then return global.cheats[category] end
--     if category == 'game' then return global.cheats[category][name][1] end
--     if type(obj) == 'string' and obj == 'global' then
--         return global.cheats[category][name].global
--     end
--     local index = type(obj) == 'table' and obj.index or obj
--     return index and global.cheats[category][name][index] or global.cheats[category][name]
-- end

-- function util.cheat_enabled(category, name, index, exclude_idx)
--     local cheat_table = table.deepcopy(util.cheat_table(category, name))
--     if exclude_idx then cheat_table[exclude_idx] = nil end
--     if index then
--         return cheat_table[index].cur_value
--     else
--         -- check if any players have the cheat enabled
--         for i=1,#cheat_table do
--             if cheat_table[i] and cheat_table[i].cur_value then return true end
--         end
--     end
-- end

-- -- ----------------------------------------------------------------------------------------------------
-- -- INVENTORIES

-- -- Transfers the contents of the source inventory to the destination inventory.
-- function util.transfer_inventory_contents(source_inventory, destination_inventory)
-- 	for i = 1, math.min(#source_inventory, #destination_inventory), 1 do
-- 		local source_slot = source_inventory[i]
-- 		if source_slot.valid_for_read then
-- 			if destination_inventory[i].set_stack(source_slot) then
-- 				source_inventory[i].clear()
-- 			end
-- 		end
-- 	end
-- end

-- ----------------------------------------------------------------------------------------------------

return util