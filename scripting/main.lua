local function notify(message)
    lib.notify({
        title = 'Crosshair Settings',
        description = message,
        type = 'info', -- You can modify this to be 'success', 'error', etc.
        duration = 4000 -- duration in ms (e.g., 4 seconds)
    })
end

-- Function to check if the player is armed
local function isPlayerArmed()
    local weapon = GetSelectedPedWeapon(PlayerPedId())
    return weapon ~= GetHashKey('WEAPON_UNARMED')
end

-- Function to toggle the visibility of the crosshair
local function toggleCrosshair()
    if isPlayerArmed() then
        if GetResourceKvpInt(Config.Storage.enabled) == Config.States.ALTERNATIVE then
            SetResourceKvpInt(Config.Storage.enabled, Config.States.ENABLED)
            crosshairKVP = Config.States.ENABLED
            crosshairEnabled = true
            SendNUIMessage({ display = "reticleShow" })
            -- Notify user that the crosshair has been enabled
            notify('Crosshair enabled.')
        else
            SetResourceKvpInt(Config.Storage.enabled, Config.States.ALTERNATIVE)
            crosshairKVP = Config.States.DISABLED
            crosshairEnabled = false
            SendNUIMessage({ display = "reticleHide" })
            -- Notify user that the crosshair has been disabled
            notify('Crosshair disabled.')
        end
    else
        -- If player is unarmed, hide the crosshair
        SendNUIMessage({ display = "reticleHide" })
        crosshairEnabled = false
        notify('Crosshair hidden because you are unarmed.')
    end
end

-- Function to open the crosshair settings menu
local function openCrosshairMenu()
    lib.registerContext({
        id = 'crosshair_settings',
        title = 'Crosshair Settings',
        options = {
            {
                title = 'Adjust Size',
                description = 'Change the size of your crosshair',
                onSelect = function()
                    local input = lib.inputDialog('Crosshair Size', {
                        {
                            type = 'slider',
                            label = 'Size',
                            default = GetResourceKvpFloat(Config.Storage.size) or Config.DefaultSize,
                            min = Config.MinSize,
                            max = Config.MaxSize,
                            step = 1
                        }
                    })

                    if input then
                        local sizeCalc = Config.BaseSize + (Config.SizeIncrement * input[1])
                        SendNUIMessage({ display = "reticleSize", size = sizeCalc })
                        SetResourceKvpFloat(Config.Storage.size, sizeCalc)
                        -- Notify user that the size was changed
                        notify('Crosshair size changed!')
                    end
                end
            },
            {
                title = 'Change Color',
                description = 'Select a new color for your crosshair',
                onSelect = function()
                    local currentColor = GetResourceKvpString(Config.Storage.color) or Config.DefaultColor
                    local input = lib.inputDialog('Crosshair Color', {
                        {
                            type = 'color',
                            label = 'Select Color',
                            default = currentColor
                        }
                    })

                    if input then
                        local color = input[1]
                        SetResourceKvp(Config.Storage.color, color)
                        SendNUIMessage({ display = "reticleColor", color = color })
                        -- Notify user that the color was changed
                        notify('Crosshair color changed to: ' .. color)
                    end
                end
            },
            {
                title = 'Toggle Crosshair',
                description = 'Enable or disable the crosshair',
                onSelect = function()
                    toggleCrosshair()
                end
            }
        }
    })

    lib.showContext('crosshair_settings')
end
RegisterCommand(Config.Commands.crosshair, function(_, _, rawCommand)
    local hexArg = string.sub(rawCommand, 11)
    if #hexArg > 0 then
        -- Keep existing direct color change functionality
        SetResourceKvp(Config.Storage.color, hexArg)
        SendNUIMessage({ display = "reticleColor", color = hexArg })
        -- Notify user that the color has been changed
        notify('Crosshair color changed to: ' .. hexArg)
    else
        -- Open the new settings menu
        openCrosshairMenu()
    end
end, false)

-- Listen for weapon changes and update crosshair visibility accordingly
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000) -- Check every second
        if isPlayerArmed() then
            if not crosshairEnabled then
                -- If the player is armed and the crosshair is not enabled, show it
                SendNUIMessage({ display = "reticleShow" })
                crosshairEnabled = true
            end
        else
            if crosshairEnabled then
                -- If the player is unarmed and the crosshair is enabled, hide it
                SendNUIMessage({ display = "reticleHide" })
                crosshairEnabled = false
            end
        end
    end
end)
