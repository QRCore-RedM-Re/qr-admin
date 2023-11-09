-- Staff Chat --
function staffChatHandler(source, msg)
    local name = GetPlayerName(source)
    local players = QRCore.Functions.GetPlayers()

    for i = 1, #players, 1 do
        local player = players[i]
        if QRCore.Functions.HasPermission(player, Config.CommandPerms['staffchat']) or IsPlayerAceAllowed(plr, 'command') then
            if QRCore.Functions.IsOptin(player) then
                TriggerClientEvent('chat:addMessage', player, {
                    color = {0, 255, 255},
                    multiline = true,
                    args = {('[STAFF] | %s'):format(name), msg}
                })
            end
        end
    end
end

-- Report Response --
function reportResponseHandler(source, target, message)
    if not QRCore.Functions.HasPermission(source, Config.CommandPerms['reportr']) and not IsPlayerAceAllowed(source, 'command') then return end
    if message == '' then return end

    local src = source
    local playerId = tonumber(target)
    local msg = message
    local OtherPlayer = QRCore.Functions.GetPlayer(playerId)
    if not OtherPlayer then return QRCore.Functions.Notify(src, locale('not_online'), 'error') end

    -- Send response to player
    TriggerClientEvent('chat:addMessage', playerId, {
      color = {0, 255, 0},
      multiline = true,
      args = {'[ADMIN RESPONSE] | ', msg}
    })

    -- Show response to admin
    TriggerClientEvent('chat:addMessage', src, {
      color = {0, 255, 0},
      multiline = true,
      args = {('[REPORT RESPONSE] (%s) | '):format(playerId), msg}
    })

    QRCore.Functions.Notify(src, locale('report_reply_sent'), 'success')
    TriggerEvent('qr-log:server:CreateLog', 'report', 'Report Reply', 'red', '**'..GetPlayerName(src)..'** replied on: **'..OtherPlayer.PlayerData.name.. ' **(ID: '..OtherPlayer.PlayerData.source..') **Message:** ' ..msg, false)
end

-- Send Report --
function reportHandler(targetSrc, msg)
    local name = GetPlayerName(targetSrc)
    local Player = QRCore.Functions.GetPlayer(targetSrc)
    local players = QRCore.Functions.GetPlayers()

    for i = 1, #players, 1 do
        local playerSrc = players[i]
        if QRCore.Functions.HasPermission(playerSrc, Config.CommandPerms['reportr']) or IsPlayerAceAllowed(playerSrc, 'command') then
            if QRCore.Functions.IsOptin(playerSrc) then
                TriggerClientEvent('chat:addMessage', playerSrc, {
                    color = {255, 0, 0},
                    multiline = true,
                    args = { ('[REPORT] | %s (%s)'):format(name, targetSrc), msg}
                })
            end
        end
    end

    TriggerEvent('qr-log:server:CreateLog', 'report', 'Report', 'green', '**'..name..'** (CitizenID: '..Player.PlayerData.citizenid..' | ID: '..targetSrc..') **Report:** ' ..msg, false)
end