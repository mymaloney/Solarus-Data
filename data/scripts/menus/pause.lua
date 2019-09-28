require("scripts/multi_events")

local width,height = sol.video.get_quest_size()
local pause_screen_surface = sol.surface.create(width,height)

local function initialize_pause_features(game)  
  
  local inventory_builder = nil  
  local inventory_submenu = nil  
  
  if game.pause_menu ~= nil then
    return
  end  
  
  local pause_menu = {}
  
  function pause_menu:on_started()
    inventory_builder = require("scripts/menus/pause_inventory")
    inventory_submenu = inventory_builder:new(game)
    pause_screen_surface = sol.surface.create(width,height)
  end
    
  function pause_menu:on_finished()

  end  
  
  --Called to open the pause menu
  function pause_menu:open()
    pause_menu:move_pause_screen(function() end)
    sol.menu.start(game, pause_menu)
  end
  
  --Called to close the pause menu
  function pause_menu:close()
    pause_menu:move_pause_screen(function() end)
    sol.menu.stop(pause_menu)
  end
  
  
  function pause_menu:move_pause_screen(callback)
    local angle_added = math.pi
    local movement_speed = 1    
    local movement_distance = height
    
    if (false) then
      -- Opposite direction when closing.
      angle_added = 0
    end

    local movement = sol.movement.create("straight")
    movement:set_speed(movement_speed)
    movement:set_max_distance(movement_distance)
    movement:set_angle(3 * math.pi / 2 + angle_added)
    movement:start(pause_screen_surface, callback)
  end  
  
  
  
  function pause_menu:on_draw(dst_surface)
    if (inventory_submenu ~= nil) then
      pause_screen_surface:clear()
      inventory_submenu:draw_grid(pause_screen_surface, 10, 10)
      pause_screen_surface:draw(dst_surface)
    end
  end
  
  --Adds pause_menu:open() and pause_menu:close() to their respective events in game,
  --so that when the game is paused/unpaused, it calls pause_menu:open()/close()
  game:register_event("on_paused", function(game)
    pause_menu:open()
  end)
  game:register_event("on_unpaused", function(game)
    pause_menu:close()
  end)
  
  game.pause_menu = pause_menu
end

-- Set up the pause menu on any game that starts.
local game_meta = sol.main.get_metatable("game")
game_meta:register_event("on_started", initialize_pause_features)

return true
