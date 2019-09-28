local inventory_manger = {}

local inventory_items_names = {
  "bomb",
  "tunic",
}


function inventory_manager:display_items(game, x, y, dst_surface)
  local gridsize = 16 
  for i=1,5 do
    for j=1,2 do
      if (grid:get_item(i,j) ~= nil) then
        item_surface = sol.surface.create("items/" .. grid:get_item(i,j) .. ".png")
        item_surface:draw(dst_surface, x+((i-1)*gridsize), y+((j-1)*gridsize))
      end
    end
  end
end

local function create_item_grid(game, rows, columns, size)
  local grid_table = {}
  for i=1,rows do
  grid_table[i] = {}
    for j=1,columns do
      grid_table[i][j] = nil
    end
  end

  function grid_table:add_to_table(item, r, c)
    if ((r <= rows) and (c <= columns)) then
      grid_table[r][c] = item
    end
  end
  
  function grid_table:get_item(r, c)
    return grid_table[r][c]
  end  
  
  return grid_table
end

function inventory_manager:new(game)
  local grid = create_item_grid(game, 5, 2, 16)
    
  grid:add_to_table("bomb", 0, 0)
  grid:add_to_table("tunic", 0, 1)  
  
  
end

return inventory_manager