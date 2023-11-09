-- Kill Player --
RegisterNetEvent('admin:server:kill', function(player, permission)
    local src = source
    if not QRCore.Functions.HasPermission(src, permission) then return end
    TriggerClientEvent('hospital:client:KillPlayer', player)
end)

-- Revive Player --
RegisterNetEvent('admin:server:revive', function(player, permission)
    local src = source
    if not QRCore.Functions.HasPermission(src, permission) then return end
    TriggerClientEvent('admin:client:revivePlayer', player)
    TriggerClientEvent('hospital:client:Revive', player)
end)

-- Heal Player --
RegisterNetEvent('admin:server:heal', function(player, permission)
    local src = source
    if not QRCore.Functions.HasPermission(src, permission) then return end
    TriggerClientEvent('admin:client:healPlayer', player)
end)

-- Give Player Clothing Menu --
RegisterNetEvent('admin:server:cloth', function(player, permission)
    local src = source
    if not QRCore.Functions.HasPermission(src, permission) then return end
    TriggerClientEvent('qr-clothing:client:openMenu', player, 'all')
end)

-- Kick Player --
RegisterNetEvent('admin:server:kick', function(player, permission)
    local src = source
    if not QRCore.Functions.HasPermission(src, permission) then return end
    local kickInput = lib.callback.await('admin:client:kickInput', src)
    if not kickInput then return end
    local reason = kickInput[1]

    TriggerEvent('qr-log:server:CreateLog', 'bans', 'Player Kicked', 'red', string.format('%s was kicked by %s for %s', GetPlayerName(player), GetPlayerName(src), reason), true)
    DropPlayer(player, "You have been kicked from the server" .. ':\n' .. reason .. '\n\n' .. "🔸 Check our Discord for more information: " .. QRCore.Config.Server.Discord)
end)

-- Go to Player --
RegisterNetEvent('admin:server:goto', function(player, permission)
    local src = source
    if player == src then return QRCore.Functions.Notify(src, locale('self_action'), 'error') end
    if not QRCore.Functions.HasPermission(src, permission) then return end
    local admin = GetPlayerPed(src)
    local target = GetPlayerPed(player)
    local targetCoords = GetEntityCoords(target)
    SetEntityCoords(admin, targetCoords)
end)

-- Spectate Player --
RegisterNetEvent('admin:server:spectate', function(player, permission)
    local src = source
    if player == src then return QRCore.Functions.Notify(src, locale('self_action'), 'error') end
    if not QRCore.Functions.HasPermission(src, permission) then return end
    local admin = GetPlayerPed(src)
    local target = GetEntityCoords(GetPlayerPed(player))
    TriggerClientEvent('admin:client:spectate', src, player)
end)

-- Bring Player --
RegisterNetEvent('admin:server:bring', function(player, permission)
    local src = source
    if player == src then return QRCore.Functions.Notify(src, locale('self_action'), 'error') end
    if not QRCore.Functions.HasPermission(src, permission) then return end
    local admin = GetPlayerPed(src)
    local coords = GetEntityCoords(admin) -- Admin Coords
    local target = GetPlayerPed(player) -- Player Ped
    SetEntityCoords(target, coords)
end)

-- Freeze Player --
local frozen = {}
RegisterNetEvent('admin:server:freeze', function(player, permission)
    local src = source
    if not QRCore.Functions.HasPermission(src, permission) then return end
    TriggerClientEvent('admin:client:freeze', player)
end)

-- Open Player Inventory --
RegisterNetEvent('admin:server:inventory', function(player, permission)
    local src = source
    if not QRCore.Functions.HasPermission(src, permission) then return end
    TriggerEvent("inventory:server:adminOpenPlayerInventoy", src, player)
end)

-- Ban Player --
RegisterNetEvent('admin:server:ban', function(player, permission)
    local src = source
    if not QRCore.Functions.HasPermission(src, permission) then return end
    local banInput = lib.callback.await('admin:client:banInput', src)
    if not banInput then return end
    local reason = banInput[1]
    local time = banInput[2]

    if time == 'perm' then time = 2147483647 end
    local time = tonumber(time)
    local banTime = tonumber(os.time() + time)
    if banTime > 2147483647 then banTime = 2147483647 end
    local timeTable = os.date('*t', banTime)

    MySQL.Async.insert('INSERT INTO bans (name, license, discord, ip, reason, expire, bannedby) VALUES (?, ?, ?, ?, ?, ?, ?)', {
        GetPlayerName(player),
        QRCore.Functions.GetIdentifier(player, 'license'),
        QRCore.Functions.GetIdentifier(player, 'discord'),
        QRCore.Functions.GetIdentifier(player, 'ip'),
        reason,
        banTime,
        GetPlayerName(src)
    })

    TriggerClientEvent('chat:addMessage', -1, {
        template = "<div class=chat-message server'><strong>ANNOUNCEMENT | {0} has been banned:</strong> {1}</div>",
        args = {GetPlayerName(player), reason}
    })

    TriggerEvent('qr-log:server:CreateLog', 'bans', 'Player Banned', 'red', string.format('%s was banned by %s for %s', GetPlayerName(player), GetPlayerName(src), reason), true)
    if banTime >= 2147483647 then
        DropPlayer(player, "You have been banned:" .. '\n' .. reason .. "\n\nYour ban is permanent.\n🔸 Check our Discord for more information: " .. QRCore.Config.Server.Discord)
    else
        DropPlayer(player, "You have been banned:" .. '\n' .. reason .. "\n\nBan expires: " .. timeTable['day'] .. '/' .. timeTable['month'] .. '/' .. timeTable['year'] .. ' ' .. timeTable['hour'] .. ':' .. timeTable['min'] .. '\n🔸 Check our Discord for more information: ' .. QRCore.Config.Server.Discord)
    end
end)

-- Give Item to Player --
RegisterNetEvent('admin:server:giveItem', function(target, permission)
    local src = source
    local TPlayer = QRCore.Functions.GetPlayer(tonumber(target))
    if not TPlayer then return end
    if not QRCore.Functions.HasPermission(src, permission) then return end
    local itemInput = lib.callback.await('admin:client:giveItemInput', src)
    if not itemInput then return end
    local itemData = QRCore.Shared.GetItem(tostring(itemInput[1]))
    local amount = itemInput[2]

    local info = {}
    if itemData["type"] == "weapon" then
        amount = 1
        info.serie = tostring(QRCore.Shared.RandomInt(2) .. QRCore.Shared.RandomStr(3) .. QRCore.Shared.RandomInt(1) .. QRCore.Shared.RandomStr(2) .. QRCore.Shared.RandomInt(3) .. QRCore.Shared.RandomStr(4))
        info.quality = 100
    elseif itemData["name"] == "markedbills" then
        info.worth = math.random(5000, 10000)
    end

    if TPlayer.Functions.AddItem(itemInput[1], amount) then
        TriggerClientEvent("inventory:client:ItemBox", src, QRCore.Shared.GetItem(itemInput[1]), "add")
    end
end)