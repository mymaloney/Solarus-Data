require("scripts/multi_events")

local map_meta = sol.main.get_metatable("map")

local function set_camera()
  local map = self
  local camera = map:get_camera()
  camera:set_size(160, 128)
end

map_meta:register_event("on_started", set_camera)