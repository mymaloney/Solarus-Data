local hud_bg_builder = {}

function hud_bg_builder:new(game, config)

  local hud_bg = {}

  hud_bg.surface = sol.surface.create(160,24)
  hud_bg.img = sol.surface.create("hud/hud_bg.png")
  hud_bg.x, hud_bg.y = config.x, config.y

  local ix,movement_distance = sol.video.get_quest_size()
  movement_distance = movement_distance - 24
  local movement_speed = 800

  function hud_bg:update_surface()
    hud_bg.surface:clear()
    hud_bg.img:draw(hud_bg.surface)
  end

  function hud_bg:on_draw(dst_surface)
    hud_bg:update_surface()
    hud_bg.surface:draw(dst_surface, hud_bg.x, hud_bg.y)
  end
 
  function hud_bg:pause_movement()
    local movement = sol.movement.create("straight")
    movement:set_speed(movement_speed)
    movement:set_max_distance(movement_distance)
    movement:set_angle(math.pi / 2 + 0)
    movement:start(hud_bg.surface)
  end
    
  function hud_bg:unpause_movement()
    local movement = sol.movement.create("straight")
    movement:set_speed(movement_speed)
    movement:set_max_distance(movement_distance)
    movement:set_angle(3*math.pi / 2 + 0)
    movement:start(hud_bg.surface)
  end  

  game["hud_bg_icon"] = hud_bg
  function game:get_hud_bg_icon()
    return game["hud_bg_icon"]
  end
  

  return hud_bg

end

return hud_bg_builder