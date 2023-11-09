local sharedItems = QRCore.Shared.GetItems()
local Invisible = false
local Godmode = false
local lastSpectateCoord = nil
local isSpectating = false
local isFrozen = false
local showNames = false
local playerNames = {}

-- Toggle Names --
function toggleNames()
    showNames = not showNames
    if not showNames then
        local players = GetActivePlayers()
        for _, x in ipairs(players) do
            if playerNames[x] or IsMpGamerTagActive(playerNames[x].gamerTag) then
                Citizen.InvokeNative(0x93171DDDAB274EB8, playerNames[x].gamerTag, 0) -- SetMpGamerTagVisibility
                playerNames[x] = nil
            end
        end
        return
    end

    while showNames do
        local players = GetActivePlayers()
        for _, x in ipairs(players) do
            local targetPed = GetPlayerPed(x)
            local playerStr = ('[%s] %s'):format(GetPlayerServerId(x), GetPlayerName(x))

            if not playerNames[x] or not IsMpGamerTagActive(playerNames[x].gamerTag) then
                playerNames[x] = {
                    gamerTag = Citizen.InvokeNative(0xE961BF23EAB76B12, targetPed, playerStr),
                    ped = targetPed
                }
            end
        end
        Wait(10)
    end
end

-- Invisible Player --
function toggleInvisible()
    local ped = cache.ped
    Invisible = not Invisible
    if Invisible then
        SetEntityVisible(ped, true)
    else
        SetEntityVisible(ped, false)
    end
end

-- Godmode Toggle --
function toggleGodMode()
    local ped = cache.ped
    Godmode = not Godmode
    if Godmode then
        QRCore.Functions.Notify(locale('godmode_on'), 'success')
        while Godmode do
          Wait(0)
          SetEntityInvincible(ped, true)
        end
    else
        SetEntityInvincible(ped, false)
        QRCore.Functions.Notify(locale('godmode_off'), 'error')
    end
end

-- Revive Self (Admin) --
function adminRevive()
    local ped = cache.ped
    local pos = GetEntityCoords(ped)
    NetworkResurrectLocalPlayer(pos.x, pos.y, pos.z, GetEntityHeading(ped), true, false)
    SetEntityInvincible(ped, false)
    SetEntityMaxHealth(ped, 200)
    SetEntityHealth(ped, 200)
    ClearPedBloodDamage(ped)
    TriggerServerEvent('hud:server:RelieveStress', 100)
    QRCore.Functions.Notify(locale('feeling_healthy'), 'success')
end

-- Teleport to Waypoint --
function waypointTP()
    TriggerEvent('QRCore:Command:GoToMarker')
end

-- Give Item to Player --
lib.callback.register('admin:client:giveItemInput', function()
    local Options = {}
    for _, x in pairs(sharedItems) do
        Options[#Options+1] = { value = x['name'], label = x['label'] }
    end
    local ItemInput = lib.inputDialog(locale('give_item_title'), {
        { type = 'select', label = locale('give_item_name'), options = Options },
        { type = 'number', label = locale('give_item_count'), description = '', icon = 'hashtag' },
    })
    if not ItemInput then return nil end
    return ItemInput
end)

-- Kick Player --
lib.callback.register('admin:client:kickInput', function()
    local input = lib.inputDialog(locale('kick_title'), {
        {type = 'input', label = locale('reason'), description = ''},
    })
    if not input then return nil end
    return input
end)

-- Ban Player --
lib.callback.register('admin:client:banInput', function()
    local input = lib.inputDialog(locale('ban_title'), {
        { type = 'input', label = locale('reason'), description = '' },
        { type = 'select', label = locale('ban_length'), options = {
            { value = 24, label = locale('1_day') },
            { value = 48, label = locale('2_day') },
            { value = 72, label = locale('3_day') },
            { value = 168, label = locale('1_week') },
            { value = 730, label = locale('1_month') },
            { value = 'perm', label = locale('perm_ban') },
        }},
    })
    if not input then return end
    return input
end)

-- Spectate Players --
RegisterNetEvent('admin:client:spectate', function(targetPed)
    if GetInvokingResource() then return end

    isSpectating = not isSpectating
    local ped = cache.ped
    local targetplayer = GetPlayerFromServerId(targetPed)
    local target = GetPlayerPed(targetplayer)

    if not isSpectating then
        NetworkSetInSpectatorMode(false, target)
        NetworkSetEntityInvisibleToNetwork(ped, false)
        SetEntityCollision(ped, true, true)
        SetEntityCoords(ped, lastSpectateCoord)
        SetEntityVisible(ped, true)
        SetEntityInvincible(ped, false)
        lastSpectateCoord = nil
    else
        SetEntityVisible(ped, false)
        SetEntityCollision(ped, false, false)
        SetEntityInvincible(ped, true)
        NetworkSetEntityInvisibleToNetwork(ped, true)
        lastSpectateCoord = GetEntityCoords(ped)
        NetworkSetInSpectatorMode(true, target)
    end
end)

-- Freeze Player --
RegisterNetEvent('admin:client:freeze', function()
    if GetInvokingResource() then return end
    isFrozen = not isFrozen
    FreezeEntityPosition(cache.ped, isFrozen)
end)