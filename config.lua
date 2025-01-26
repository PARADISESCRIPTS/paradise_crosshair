Config = {}

-- Default crosshair settings
Config.DefaultEnabled = true
Config.DefaultColor = "#FFFFFF"
Config.DefaultSize = 1.0

-- Size limitations
Config.MinSize = 1
Config.MaxSize = 5
Config.SizeIncrement = 0.6
Config.BaseSize = 2.9

-- Commands
Config.Commands = {
    crosshair = "crosshair" -- Command to toggle crosshair or change color
}

-- Storage keys for KVP
Config.Storage = {
    enabled = "crosshair",
    color = "crosshairColor",
    size = "crosshairSize"
}

-- Crosshair states
Config.States = {
    DISABLED = 0,
    ENABLED = 1,
    ALTERNATIVE = 2  -- If you need a third state
}

-- Weapon configuration
Config.ShowWithUnarmedWeapon = false  -- Set to true if you want to show crosshair when unarmed

-- Update interval (in ms) for crosshair management
Config.UpdateInterval = 0

return Config