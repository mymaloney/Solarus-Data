--[[
This script disables the ability to move in two directions at once;
effectively giving the game a more retro feel. Originally scripted by 
CopperKatana. Modified by Kamigousu Aug 17th, 2019.

merged into the game metascript 3/22/2020. --]]


require("scripts/multi_events")

local game_meta = sol.main.get_metatable("game") 

function game_meta:on_command_pressed(command)
  if command == "right" then
    if self:is_command_pressed("up") then
      self:simulate_command_released("up") 
    end    
    if self:is_command_pressed("down") then
      self:simulate_command_released("down")    
    end   
  end
  
  if command == "left" then
    if self:is_command_pressed("up") then
      self:simulate_command_released("up")    
    end    
    if self:is_command_pressed("down") then
      self:simulate_command_released("down")    
    end   
  end

  if command == "up" then
    if self:is_command_pressed("left") then
      self:simulate_command_released("left")    
    end    
    if self:is_command_pressed("right") then
      self:simulate_command_released("right")    
    end   
  end
  if command == "down" then
      if self:is_command_pressed("left") then
      self:simulate_command_released("left")    
    end    
    if self:is_command_pressed("right") then
      self:simulate_command_released("right")    
    end   
  end
  
  --Optionally, this disables the spin attack (or anything which would come after a normal attack)
  if command == "attack" then
    self:simulate_command_released("attack")
  end
end


--Here we add an on_command_released() function that will restore the original movement of the player.
--Example: If you were moving right and pressed up, you will move up. Upon releasing up, you will return
--to your original movment direction, which is right.
function game_meta:on_command_released(command)
  if command == "right" then
    if sol.input.is_key_pressed("up") then
      self:simulate_command_pressed("up") 

    end    
    if sol.input.is_key_pressed("down") then
      self:simulate_command_pressed("down")    
    end   
  end
  
  if command == "left" then
    if sol.input.is_key_pressed("up") then
      self:simulate_command_pressed("up")    
    end    
    if sol.input.is_key_pressed("down") then
      self:simulate_command_pressed("down")    
    end   
  end

  if command == "up" then
    if sol.input.is_key_pressed("left") then
      self:simulate_command_pressed("left")    
    end    
    if sol.input.is_key_pressed("right") then
      self:simulate_command_pressed("right")    
    end   
  end
  if command == "down" then
      if sol.input.is_key_pressed("left") then
      self:simulate_command_pressed("left")    
    end    
    if sol.input.is_key_pressed("right") then
      self:simulate_command_pressed("right")    
    end   
  end
end
