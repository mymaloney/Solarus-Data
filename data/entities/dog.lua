-- Lua script of custom entity dog.
-- This script is executed every time a custom entity with this model is created.

-- Feel free to modify the code below.
-- You can add more events and remove the ones you don't need.

-- See the Solarus Lua API documentation for the full specification
-- of types, events and methods:
-- http://www.solarus-games.org/doc/latest

local entity = ...
local game = entity:get_game()
local map = entity:get_map()
local sprite
local m   --movement variable
local sit_timer

-- Event called when the custom entity is initialized.
function entity:on_created()

  -- Initialize the properties of your custom entity here,
  -- like the sprite, the size, and whether it can traverse other
  -- entities and be traversed by them.
  sprite = self:create_sprite("animals/"..self:get_model())
  self:set_direction(3)
  self:go_random()

end


function entity:go_random()
  local random = math.random(1000, 20000)
print(random)
  sprite:set_animation("jumping")
  --m = sol.movement.create("straight")
  m = sol.movement.create("random_path")
  --m:set_smooth(false)
  --m:set_angle(math.random(0, 2*math.pi))
  m:set_speed(64)
  --m:set_max_distance(128)
  --function m:on_obstacle_reached() m:set_angle(math.random(0, 2*math.pi)) end
  --function m:on_finished() m:set_angle(math.random(0, 2*math.pi)) end
  m:start(self)
  sit_timer = sol.timer.start(entity, random, function() entity:sit() end) --timer with a random time (between 1 and 20 seconds) to make dog sit.
end

function entity:sit()
  local random = math.random(500, 7500)
print(random)
  if m ~= nil then m:stop() end
  sprite:set_animation("sitting")
  sol.timer.start(entity, random, function() entity:go_random() end)
end

function entity:on_restarted()
if m ~= nil then m:stop() end
  self:sit()
end

function entity:on_movement_changed(m)
  local dir = self:get_direction()
  local n_dir = m:get_direction4()
  if n_dir ~= dir then
    sprite:set_direction(n_dir)
  end
end