-- ----------------------------------------------------------------------------------------------------
-- INFINITY ACCUMULATOR

local event = require('lualib/event')
local util = require('lualib/util')

-- GUI ELEMENTS
local entity_camera = require('lualib/gui-elems/entity-camera')
local titlebar = require('lualib/gui-elems/titlebar')

local gui = {}

-- --------------------------------------------------
-- LOCAL UTILITIES

local state_to_circuit_type = {left='red', right='green'}

-- --------------------------------------------------
-- GUI

-- -------------------------
-- GUI HANDLERS

local function close_button_clicked(e)
  -- invoke GUI closed event
  event.raise(defines.events.on_gui_closed, {element=e.element.parent.parent, gui_type=16, player_index=e.player_index, tick=game.tick})
end

local function update_circuit_values(e)
  local players = global.players
  for i,_ in pairs(global.combinators) do
      local gui_data = players[i].gui.ic
      local entity = gui_data.entity
      local control = entity.get_or_create_control_behavior()
      local network = entity.get_circuit_network(defines.wire_type[state_to_circuit_type[gui_data.elems.color_switch.switch_state]])
      
  end
end

local handlers = {
  ic_close_button_clicked = close_button_clicked
}

event.on_load(function()
  event.load_conditional_handlers(handlers)
  .load_conditional_handlers{ic_update_circuit_values = update_circuit_values}
end)

-- -------------------------
-- GUI MANAGEMENT

function gui.create(parent, entity, player)
  local window = parent.add{type='frame', name='ee_ic_window', direction='vertical'}
  local titlebar = titlebar.create(window, 'ee_ic_titlebar', {
    draggable = true,
    label = {'entity-name.infinity-combinator'},
    buttons = {util.constants.close_button_def}
  })
  event.gui.on_click(titlebar.children[3], close_button_clicked, 'ic_close_button_clicked', player.index)
  local content_pane = window.add{type='frame', name='ee_ic_content_pane', style='inside_deep_frame', direction='vertical'}
  local toolbar = content_pane.add{type='frame', name='ee_ic_toolbar_frame', style='ee_toolbar_frame_for_switch'}
  local color_switch = toolbar.add{type='switch', name='ee_ic_color_switch', left_label_caption='Red', right_label_caption='Green'}
  util.gui.add_pusher(toolbar, 'ee_ic_toolbar_pusher')
  toolbar.add{type='sprite-button', name='ee_ic_search_button', style='tool_button', sprite='utility/search_icon'}
  toolbar.add{type='sprite-button', name='ee_ic_updaterate_button', style='tool_button', sprite='ee-time'}
  local signals_scroll = content_pane.add{type='scroll-pane', name='ic_signals_scrollpane', style='signal_scroll_pane', vertical_scroll_policy='auto'}
  local signals_table = signals_scroll.add{type='table', name='slot_table', style='signal_slot_table', column_count=6}
  local bottom_flow = window.add{type='flow', name='ee_ic_lower_flow', style='ee_vertically_centered_flow'}
  bottom_flow.style.top_margin = 4
  bottom_flow.visible = false
  util.gui.add_pusher(window, 'ee_ic_lower_pusher')
  local value_textfield = bottom_flow.add{type='textfield', name='ee_ic_input_textfield', style='short_number_textfield', numeric=true,
                                          clear_and_focus_on_right_click=true, lose_focus_on_confirm=true}
  window.force_auto_center()
  return {window=window, color_switch=color_switch, signals_table=signals_table, value_textfield=value_textfield}
end

function gui.destroy(window, player_index)
  -- deregister all GUI events if needed
  local con_registry = global.conditional_event_registry
  for cn,h in pairs(handlers) do
    event.gui.deregister(con_registry[cn].id, h, cn, player_index)
  end
  window.destroy()
end

-- --------------------------------------------------
-- STATIC HANDLERS

-- when a player opens a GUI
event.register(defines.events.on_gui_opened, function(e)
  if e.entity and e.entity.name == 'infinity-combinator' then
    local player, player_table = util.get_player(e)
    local elems = gui.create(player.gui.screen, e.entity, player)
    player.opened = elems.window
    player_table.gui.ic = {elems=elems, entity=e.entity}
    -- register on_tick for updating values
    event.register(defines.events.on_tick, update_circuit_values, 'ic_update_circuit_values', player.index)
    -- add to open combinators table
    global.combinators[player.index] = true
  end
end)

-- when a GUI is closed
event.register(defines.events.on_gui_closed, function(e)
  if e.gui_type == 16 and e.element.name == 'ee_ic_window' then
    gui.destroy(e.element, e.player_index)
    util.player_table(e).gui.ic = nil
    -- deregister on_tick
    event.deregister(defines.events.on_tick, update_circuit_values, 'ic_update_circuit_values', e.player_index)
    -- remove from open combinators table
    global.combinators[e.player_index] = nil
  end
end)