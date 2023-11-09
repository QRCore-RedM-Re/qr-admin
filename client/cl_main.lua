-- Admin Options / Tools --
local AdminOptions = {
    function() ToggleNoClipMode() end,
    function() waypointTP() end,
    function() adminRevive() end,
    function() toggleInvisible() end,
    function() toggleGodMode() end,
    function() toggleNames() end,
    function() wagonsMenu() end,
    function() horsesMenu() end
}

-- Menus --
local MenuOptions = {
    function() adminMenu() end,
    function() playersMenu() end,
    function() serverSettings() end,
    function() devMenu() end
}

-- Admin Menu --
function adminMenu()
    local hasPerms = lib.callback.await('admin:server:hasMenuPerms', false, 'admin')
    if not hasPerms then return end

    lib.registerMenu({
        id = 'admin_tools',
        title = locale('admin_menu_title'),
        position = 'top-right',
        onClose = function(keyPressed) if keyPressed == 'Backspace' then lib.showMenu('admin_menu') end end,
        options = {
            { label = locale('noclip'),         icon = 'fas fa-ghost',          close = false },
            { label = locale('wp_tp'),          icon = 'fas fa-map-pin',        close = false },
            { label = locale('revive'),         icon = 'fas fa-user',           close = false },
            { label = locale('invisible'),      icon = 'fas fa-ghost',          close = false },
            { label = locale('godmode'),        icon = 'fas fa-star-of-life',   close = false },
            { label = locale('toggle_names'),   icon = 'fas fa-signature',      close = false },
            { label = locale('spawn_wagon'),    icon = 'fas fa-horse',          close = false },
            { label = locale('spawn_horse'),    icon = 'fas fa-horse',          close = false },
        }
    }, function(selected, scrollIndex, args)
        AdminOptions[selected](scrollIndex)
    end)
    lib.showMenu('admin_tools')
end

-- Main Menu --
RegisterNetEvent('qr-admin:client:MainMenu', function()
    local hasPerms = lib.callback.await('admin:server:hasMenuPerms', false, 'main')
    if not hasPerms then return end

    lib.registerMenu({
        id = 'admin_menu',
        title = locale('main_menu_title'),
        position = 'top-right',
        options = {
            { label = locale('main_admin'),     icon = 'fas fa-bolt' },
            { label = locale('main_players'),   icon = 'fas fa-user' },
            { label = locale('main_server'),    icon = 'fas fa-globe' },
            { label = locale('main_dev'),       icon = 'fas fa-wrench' },
        }
    }, function(selected, scrollIndex, args)
        MenuOptions[selected](scrollIndex)
    end)
    lib.showMenu('admin_menu')
end)

AddEventHandler('onResourceStop', function(resource)
    if resource ~= GetCurrentResourceName() then return end
    cleanupAdminMounts()
end)