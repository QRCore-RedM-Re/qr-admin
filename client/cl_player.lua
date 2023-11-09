-- Players Menu --
function playersMenu()
    local hasPerms = lib.callback.await('admin:server:hasMenuPerms', false, 'players')
    if not hasPerms then return end
    local Players = lib.callback.await('admin:server:getplayers', false)
    local PlayersMenu = {}

    for x = 1, #Players do
        local info = Players[x]
        PlayersMenu[#PlayersMenu + 1] = {
            label = ('%s | %s'):format(info.src, info.name),
            args = { name = info.name, player = info.src },
        }
    end

    lib.registerMenu({
        id = 'players_menu',
        title = locale('players_menu_title'),
        position = 'top-right',
        onClose = function(keyPressed) if keyPressed == 'Backspace' then lib.showMenu('admin_menu') end end,
        options = PlayersMenu
    }, function(_, _, data)
        local optionsMenu = lib.callback.await('admin:server:getPlayerMenuOptions', false, data.player)
        if not optionsMenu and not optionsMenu[1] then return end
        local PlayerOptions = {}

        for x = 1, #optionsMenu do
            local info = optionsMenu[x]
            PlayerOptions[#PlayerOptions + 1] = {
                label = info.label,
                icon = info.icon,
                args = info.args,
                close = info.close
            }
        end

        lib.registerMenu({
            id = 'players_options',
            title = data.player..' | '..data.name,
            position = 'top-right',
            onClose = function(keyPressed) if keyPressed == 'Backspace' then lib.showMenu('players_menu') end end,
            options = PlayerOptions
        }, function(_, _, args)
            if args.type == 'client' then
                TriggerEvent(args.event, data.player, args.perm)
            else
                TriggerServerEvent(args.event, data.player, args.perm)
            end
        end)
        lib.showMenu('players_options')
    end)
    lib.showMenu('players_menu')
end