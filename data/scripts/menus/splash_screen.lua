--Basic Splash Screen by CopperKatana, adapted from solarus_logo.lua by Maxs.
--Just plays an animaton from the sprite "splash."

local splash_screen = {}

splash_screen.surface = sol.surface.create(160, 144)
local surface = splash_screen.surface

local splash_sprite = sol.sprite.create("menus/splash")
splash_sprite:set_animation("title")

local timer = nil

--A function which redraws the surface of splash_screen, allowing different frames of animation
--to be visible.
local function rebuild_surface() 
  surface:clear()
  splash_sprite:draw(surface)
end 

--Event called when splash_screen menu is started.
function splash_screen:on_started()
  --Here you could add a timer to play a sound.
end

--Event called every time splash_screen is drawn to the screen.
function splash_screen:on_draw(screen)
  surface:draw(screen, 0, 0)
  rebuild_surface()
end

--Event called when the current animation of splash_sprite ends.
function splash_sprite:on_animation_finished()
  sol.menu.stop(splash_screen)
end

return splash_screen