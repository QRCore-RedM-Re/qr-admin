-- Server Menu Options --
local ServerMenus = {
    function() weatherMenu() end,
    function() timeMenu() end
}

-- Weather Menu --
function weatherMenu()
    local weatherMenu = {}
    for x = 1, #Config.Weather do
        weatherMenu[#weatherMenu+1] = {
            label = Config.Weather[x].name,
            icon = Config.Weather[x].icon,
            close = false,
            args = Config.Weather[x].args
        }
    end

    lib.registerMenu({
        id = 'weather_menu',
        title = locale('server_weather_title'),
        position = 'top-right',
        onClose = function(keyPressed) if keyPressed == 'Backspace' then lib.showMenu('server_menu') end end,
        options = weatherMenu
    }, function(selected, scrollIndex, args)
        TriggerServerEvent('qr-weathersync:server:setWeather', args)
    end)
    lib.showMenu('weather_menu')
end

-- Input Time --
function timeMenu()
    local input = lib.inputDialog(locale('server_time_title'), {
        { type = 'number', label = locale('hour'),      icon = 'clock' },
        { type = 'number', label = locale('minutes'),   icon = 'clock' },
    })
    if not input then return end
    TriggerServerEvent('qr-weathersync:server:setTime', input[1], input[2])
end

-- Server Settings Menu --
function serverSettings()
    local hasPerms = lib.callback.await('admin:server:hasMenuPerms', false, 'server')
    if not hasPerms then return end

    lib.registerMenu({
        id = 'server_menu',
        title = locale('server_menu_title'),
        position = 'top-right',
        onClose = function(keyPressed) if keyPressed == 'Backspace' then lib.showMenu('admin_menu') end end,
        options = {
            { label = locale('weather_options'),    icon = 'fas fa-cloud-moon' },
            { label = locale('server_time'),        icon = 'fas fa-clock' },
        }
    }, function(selected, scrollIndex, args)
        ServerMenus[selected](scrollIndex)
    end)
    lib.showMenu('server_menu')
end