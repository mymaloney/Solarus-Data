local inventory_manager = {}

local gui_designer = require("scripts/menus/lib/gui_designer")
require("scripts/multi_events")

local inventory_items_names = {

}

local main_equipment_names = {
  "sword", "tunic",
}

local secondary_equipment_names = {
  "money_bag"
}

local quest_items_name = {
  
}

-- The inventory's numbers of columns and rows of are used for the selection system
local inventory_num_columns = 2
local inventory_num_rows = math.ceil(#inventory_items_names / inventory_num_columns)

local movement_speed = 800
local i_x,movement_distance = sol.video.get_quest_size()

local white_background = sol.surface.create(160,144)
white_background:set_xy(0,movement_distance)
white_background:fill_color{255,255,255,255}

local function display_items_grid(game, widget, item_names, item_script_folder, sprite_folder, num_columns, x_margin, x_padding, y_margin, y_padding)
  -- Draw the items, if they are possessed, depending on their variant
  for i, item_name in ipairs(item_names) do    
    local variant = game:get_item(item_script_folder .. "/" .. item_name):get_variant() -- 0 = not possesed

    if variant > 0 then
      local column = (i - 1) % num_columns + 1
      local row = math.floor((i - 1) / num_columns + 1) - 1
      -- Draw the sprite statically. This is okay as long as
      -- item sprites are not animated.
      -- If they become animated one day, they will have to be
      -- drawn at each frame instead (in on_draw()).
      local item_sprite = sol.sprite.create(sprite_folder .. "/" .. item_name)
      item_sprite:set_direction(variant - 1)
      item_sprite:set_xy(x_margin + (column * (16 + x_padding)) - 16, y_margin + (row * (16 + y_padding)))
      item_sprite:draw(widget:get_surface())
    end
  end
end

-- Draw part of inventory containing the equipable items
local function create_inventory_widget(game)
  local widget = gui_designer:create(84, 118)
  widget:set_xy(4, 16 + movement_distance)
  widget:make_green_frame()

  display_items_grid(game, widget, inventory_items_names, "inventory", "menus/items/inventory", inventory_num_columns, 8, 16, 29, 16)

  return widget
end

local function create_quest_widget(game)

  local widget = gui_designer:create(72, 52)
  widget:set_xy(82, 82 + movement_distance)
  widget:make_yellow_frame()
  local num_columns = 4
  
  display_items_grid(game, widget, quest_items_name, "quest", "menus/items/quest", num_columns, 8, 16, 24, 8)

  return widget

end

local function create_equipment_widget(game)

  local widget = gui_designer:create(72, 64)
  widget:set_xy(82, 16 + movement_distance)
  widget:make_yellow_frame()
  local items_surface = widget:get_surface()
  local num_columns = 5
  
  display_items_grid(game, widget, main_equipment_names, "equipment", "menus/items/equipment", num_columns, 8, 8, 24, 8)
  
  return widget
  
end

local function create_do_widget(game)

  local widget = gui_designer:create(176, 64)
  widget:set_xy(16, 168 + movement_distance)
  widget:make_red_frame()
  local num_columns = 5
  
  display_items_grid(game, widget, secondary_equipment_names, "equipment", "menus/items/equipment", num_columns, 8, 16, 24, 8)
  
  return widget

end

function inventory_manager:new(game)

  local inventory = {}

  local state = "opening"  -- "opening", "ready" or "closing".

  local inventory_widget = create_inventory_widget(game)
  local quest_widget = create_quest_widget(game)
  local do_widget = create_do_widget(game)
  local equipment_widget = create_equipment_widget(game)

  local item_cursor_fixed_sprite = sol.sprite.create("menus/item_cursor")
  item_cursor_fixed_sprite:set_animation("solid_fixed")
  local item_cursor_moving_sprite = sol.sprite.create("menus/item_cursor")
  item_cursor_moving_sprite:set_animation("dashed_blinking")

  -- Determine the place of the item currently assigned if any.
  local item_assigned_row, item_assigned_column, item_assigned_index
  local item_assigned = game:get_item_assigned(1)
  if item_assigned ~= nil then
    local item_name_assigned = item_assigned:get_name()
    for i, item_name in ipairs(inventory_items_names) do

      if item_name == item_name_assigned then
        item_assigned_column = (i - 1) % inventory_num_columns
        item_assigned_row = math.floor((i - 1) / inventory_num_columns)
        item_assigned_index = i - 1
      end
    end
  end

  -- Rapidly moves the inventory widgets towards or away from the screen.
  local function move_widgets(callback)

    local angle_added = math.pi
    if select(2, inventory_widget:get_xy()) < (movement_distance+16) then
      -- Opposite direction when closing.
      angle_added = 0
    end

    local movement = sol.movement.create("straight")
    movement:set_speed(movement_speed)
    movement:set_max_distance(movement_distance)
    movement:set_angle(3 * math.pi / 2 + angle_added)
    inventory_widget:start_movement(movement, callback)

    local movement = sol.movement.create("straight")
    movement:set_speed(movement_speed)
    movement:set_max_distance(movement_distance)
    movement:set_angle(3 * math.pi / 2 + angle_added)
    quest_widget:start_movement(movement)

    local movement = sol.movement.create("straight")
    movement:set_speed(movement_speed)
    movement:set_max_distance(movement_distance)
    movement:set_angle(3 * math.pi / 2 + angle_added)
    do_widget:start_movement(movement)

    local movement = sol.movement.create("straight")
    movement:set_speed(movement_speed)
    movement:set_max_distance(movement_distance)
    movement:set_angle(3 * math.pi / 2 + angle_added)
    equipment_widget:start_movement(movement)
  
    local movement = sol.movement.create("straight")
    movement:set_speed(movement_speed)
    movement:set_max_distance(movement_distance-24)
    movement:set_angle(3 * math.pi / 2 + angle_added)
    movement:start(white_background)

  end

  local cursor_index = game:get_value("pause_inventory_last_item_index") or 0
  local cursor_row = math.floor(cursor_index / inventory_num_columns)
  local cursor_column = cursor_index % inventory_num_columns

  -- Draws cursors on the selected and on the assigned items.
  local function draw_item_cursors(dst_surface)

    -- Selected item.
    local widget_x, widget_y = inventory_widget:get_xy()
    item_cursor_moving_sprite:draw(
        dst_surface,
        widget_x + 24 + 32 * cursor_column,
        widget_y + 24 + 32 * cursor_row
    )

    -- Item assigned (only if different from the selected one).
    if item_assigned_row ~= nil then
      if item_assigned_index ~= cursor_index then
        item_cursor_fixed_sprite:draw(
            dst_surface,
            widget_x + 24 + 32 * item_assigned_column,
            widget_y + 24 + 32 * item_assigned_row
        )
      end
    end
  end

  -- Changes the position of the item cursor.
  local function set_cursor_position(row, column)
    cursor_row = row
    cursor_column = column
    cursor_index = cursor_row * inventory_num_columns + cursor_column
    if cursor_index == item_assigned_index then
      item_cursor_moving_sprite:set_animation("solid_blinking")
      item_cursor_moving_sprite:set_frame(1)
    else
      item_cursor_moving_sprite:set_animation("dashed_blinking")
    end
  end

  function inventory:on_draw(dst_surface)
    white_background:draw(dst_surface)
    inventory_widget:draw(dst_surface)
    quest_widget:draw(dst_surface)
    do_widget:draw(dst_surface)
    equipment_widget:draw(dst_surface)

    -- Show the item cursors.
    draw_item_cursors(dst_surface)
  end

  function inventory:on_command_pressed(command)

    if state ~= "ready" then
      return true
    end

    local handled = false

    if command == "pause" then
      -- Close the pause menu.
      state = "closing"
      sol.audio.play_sound("pause_closed")
    
      local item_icon_1 = game:get_item_icon(1)
      local item_icon_2 = game:get_item_icon(2)
      local hearts_icon = game:get_hearts_icon()
      local money_icon = game:get_rupees_icon()
      local hud_bg_icon = game:get_hud_bg_icon()
      
      item_icon_1:unpause_movement()
      item_icon_2:unpause_movement()
      hearts_icon:unpause_movement()
      money_icon:unpause_movement()
      hud_bg_icon:unpause_movement()
  
      move_widgets(function() game:set_paused(false) end)
      handled = true

    elseif command == "item_1" or command == "action" then
      -- Assign an item.
      local item = game:get_item("inventory/" .. inventory_items_names[cursor_index + 1])
      if cursor_index ~= item_assigned_index
          and item:has_variant()
          and item:is_assignable() then
        sol.audio.play_sound("ok")
        game:set_item_assigned(1, item)
        item_assigned_row, item_assigned_column = cursor_row, cursor_column
        item_assigned_index = cursor_row * inventory_num_rows + cursor_column
        item_cursor_moving_sprite:set_animation("solid_blinking")
        item_cursor_moving_sprite:set_frame(0)
      end
      handled = true

    elseif command == "right" then
      if cursor_column < inventory_num_columns - 1 then
        sol.audio.play_sound("cursor")
        set_cursor_position(cursor_row, cursor_column + 1)
        handled = true
      end

    elseif command == "up" then
      sol.audio.play_sound("cursor")
      if cursor_row > 0 then
        set_cursor_position(cursor_row - 1, cursor_column)
      else
        set_cursor_position(inventory_num_rows - 1, cursor_column)
      end
      handled = true

    elseif command == "left" then
      if cursor_column > 0 then
        sol.audio.play_sound("cursor")
        set_cursor_position(cursor_row, cursor_column - 1)
        handled = true
      end

    elseif command == "down" then
      sol.audio.play_sound("cursor")
      if cursor_row < inventory_num_rows - 1 then
        set_cursor_position(cursor_row + 1, cursor_column)
      else
        set_cursor_position(0, cursor_column)
      end
      handled = true
    end

    return handled
  end

  function inventory:on_finished()
    -- Store the cursor position.
    game:set_value("pause_inventory_last_item_index", cursor_index)
  end

  set_cursor_position(cursor_row, cursor_column)

  local item_icon_1 = game:get_item_icon(1)
  local item_icon_2 = game:get_item_icon(2)
  local hearts_icon = game:get_hearts_icon()
  local money_icon = game:get_rupees_icon()
  local hud_bg_icon = game:get_hud_bg_icon()
      
  item_icon_1:pause_movement()
  item_icon_2:pause_movement()
  hearts_icon:pause_movement()
  money_icon:pause_movement()
  hud_bg_icon:pause_movement()
  
  move_widgets(function() state = "ready" end)

  return inventory
end

return inventory_manager

