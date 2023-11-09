-- Get All Players --
lib.callback.register('admin:server:getplayers', function(source)
    local players = {}
    for _, x in pairs(QRCore.Functions.GetPlayers()) do
        local player = QRCore.Functions.GetPlayer(x)
        players[#players + 1] = {
            id = x,
            name = ('%s %s | (%s)'):format(player.PlayerData.charinfo.firstname, player.PlayerData.charinfo.lastname, GetPlayerName(x)),
            citizenid = player.PlayerData.citizenid,
            ped = GetPlayerPed(player.PlayerData.source),
            src = player.PlayerData.source
        }
    end
    table.sort(players, function(a, b) return a.id < b.id end)

    return players
end)

-- Get Menu Permissions --
lib.callback.register('admin:server:hasMenuPerms', function(source, action)
    local src = source
    local callback = false
    if QRCore.Functions.HasPermission(src, Config.MenuPerms[action]) then 
        callback = true 
    else
        QRCore.Functions.Notify(src, locale('no_access'), 'error')
    end
    return callback
end)

-- Get Permissions for Player Management --
lib.callback.register('admin:server:getPlayerMenuOptions', function(source, target)
    local src = source
    local PlayerOptions = {}

    for x = 1, #Config.PlayerPermissions do
        local option = Config.PlayerPermissions[x]
        if QRCore.Functions.HasPermission(src, tostring(option.permission)) then
            PlayerOptions[#PlayerOptions + 1] = {
                label = option.title,
                icon = option.icon,
                close = option.close,
                args = {
                    type = option.type,
                    player = target,
                    perm = option.permission,
                    event = option.event
                }
            }
        end
    end
    return PlayerOptions
end)

-- Check if Player has Permissions -- --
lib.callback.register('admin:server:hasPerms', function(source, permission)
    local src = source
    local callback = false
    if QRCore.Functions.HasPermission(src, permission) then callback = true end
    return callback
end)