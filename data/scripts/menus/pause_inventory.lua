local inventory_manager = {}
inventory_manager.grid = {}
inventory_manager.sprites_grid = {}

local num_rows = 5
local num_columns = 2
local size = 16  --Size of items in the grid, in pixels (length of one side of square)

function inventory_manager:new(game)
  --Initializing the matrix of item names
  for i=1,num_rows do
    self.grid[i] = {}
    for j=1,num_columns do
      self.grid[i][j] = nil
    end
  end
  
  --Adding item names to the matrix of item names
  --TODO: make it so that it only adds items which are in the player's inventory.
  self.grid[1][1] = "bombs"
  self.grid[1][2] = "bow"
  
  self:initialize_sprites_grid()
  
  --returning the inventory_manager
  return self
end

function inventory_manager:draw_grid(dst_surface, x, y)
  for i=1,num_rows do
    for j=1,num_columns do
      if (self.sprites_grid[i][j] ~= nil) then
        (self.sprites_grid[i][j]):draw(dst_surface, x+((i-1)*size), y+((j-1)*size))
      end
    end
  end
end

function inventory_manager:initialize_sprites_grid()
  for i=1,num_rows do
    self.sprites_grid[i] = {}
    for j=1,num_columns do
      self.sprites_grid[i][j] = nil
      if (self.grid[i][j] ~= nil) then
        self.sprites_grid[i][j] = sol.surface.create("items/inventory/".. self.grid[i][j] .. ".png")
      end
    end
  end
end

--This was written simply for debugging.
function inventory_manager:print_grid()
  for i=1,5 do
    for j=1,2 do
      print(self.grid[i][j])
    end
  end
end

return inventory_manager