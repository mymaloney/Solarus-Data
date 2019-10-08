-- Defines the elements to put in the HUD
-- and their position on the game screen.

-- You can edit this file to add, remove or move some elements of the HUD.

-- Each HUD element script must provide a method new()
-- that creates the element as a menu.
-- See for example scripts/hud/hearts.

-- Negative x or y coordinates mean to measure from the right or bottom
-- of the screen, respectively.

local hud_config = {

  --Background
  {
    menu_script = "scripts/hud/hud_bg",
    x = 0,
    y = 120,
  },

  -- Hearts meter.
  {
    menu_script = "scripts/hud/hearts",
    x = 120,
    y = 124,
  },

  -- Money counter.
  {
    menu_script = "scripts/hud/money",
    x = 80,
    y = -20,
  },

  -- Pause icon.
  {
    menu_script = "scripts/hud/pause_icon",
    x = 23,
    y = 200,
  },

  -- Item icon for slot 1.
  {
    menu_script = "scripts/hud/item_icon",
    x = 4,
    y = 120,
    slot = 1,  -- Item slot (1 or 2).
  },

  -- Item icon for slot 2.
  {
    menu_script = "scripts/hud/item_icon",
    x = 56,
    y = 120,
    slot = 2,  -- Item slot (1 or 2).
  },

  -- Attack icon.
  {
    menu_script = "scripts/hud/attack_icon",
    x = 30,
    y = 120,
    dialog_x = 15,
    dialog_y = 20,
  },

  -- Action icon.
  {
    menu_script = "scripts/hud/action_icon",
    x = 53,
    y = 200,
    dialog_x = 30,
    dialog_y = 42,
  },
}

return hud_config
