local map_meta = sol.main.get_metatable("map")

function map_meta:on_started()
  local map = self
  local camera = map:get_camera()
  camera:set_size(160, 128)
end