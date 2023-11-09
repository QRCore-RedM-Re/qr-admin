adminMounts = {}

-- 3D Draw Text --
function DrawText3D(x, y, z, text)
    local onScreen, _x , _y = GetScreenCoordFromWorldCoord(x, y, z)

    SetTextScale(0.35, 0.35)
    SetTextFontForCurrentCommand(1)
    SetTextColor(255, 255, 255, 215)
    local str = CreateVarString(10, "LITERAL_STRING", text, Citizen.ResultAsLong())
    SetTextCentre(1)
    DisplayText(str, _x, _y)
    local factor = (string.len(text)) / 150
end

-- Spawn Wagon / Horse --
function spawnMount(type, model, coords)
    local hasPerms = lib.callback.await('admin:server:hasMenuPerms', false, 'mounts')
    if not hasPerms then return end

    local hashp = joaat("PLAYER")
    local newMount = nil
    if not IsModelInCdimage(model) then return end

    lib.requestModel(model)
    if type == 'wagon' then
        newMount = CreateVehicle(model, vector3(coords.x, coords.y, coords.z), coords.w, true, false)
        TaskWarpPedIntoVehicle(cache.ped, newMount, -1)
        Citizen.InvokeNative(0x283978A15512B2FE, newMount, true)
        NetworkSetEntityInvisibleToNetwork(newMount, true)
    else
        newMount = CreatePed(model, vector3(coords.x, coords.y, coords.z), coords.w, true, false)
        Citizen.InvokeNative(0xADB3F206518799E8, newMount, hashp)           -- Relationship
        Citizen.InvokeNative(0xCC97B29285B1DC3B, newMount, 1)               -- Horse Mood
        Citizen.InvokeNative(0x028F76B6E78246EB, cache.ped, newMount, 0)    -- On Saddle
        Citizen.InvokeNative(0x283978A15512B2FE, newMount, true)            -- Set random outfit variation / skin
        NetworkSetEntityInvisibleToNetwork(newMount, true)
    end
    return newMount
end

-- Delete All Spawned Mounts --
function cleanupAdminMounts()
    if not adminMounts and not adminMounts[1] then return end
    for x = 1, #adminMounts do
        if DoesEntityExist(adminMounts[x]) then
            local isVeh = IsEntityAVehicle(adminMounts[x])
            if isVeh then
                DeleteVehicle(adminMounts[x])
            else
                DeletePed(adminMounts[x])
            end
        end
        adminMounts[x] = nil
    end
end

-- Copy to Clipboard --
function copyToClipboard(TYPE)
    local copyCoords = ''
    local coords = GetEntityCoords(cache.ped)
    local heading = GetEntityHeading(cache.ped)
    local currentMenu = lib.getOpenMenu()
    if currentMenu then lib.hideMenu() end
    local x = QRCore.Shared.Round(coords.x, 2)
    local y = QRCore.Shared.Round(coords.y, 2)
    local z = QRCore.Shared.Round(coords.z, 2)
    local z = QRCore.Shared.Round(coords.z, 2)
    local h = QRCore.Shared.Round(heading, 2)

    if TYPE == 'coords3' then
        copyCoords = ('vec3(%s, %s, %s)'):format(x, y, z)
        QRCore.Functions.Notify(locale('vec3_copied'), 'success', 5000)
    elseif TYPE == 'coords4' then
        copyCoords = ('vec4(%s, %s, %s, %s)'):format(x, y, z, h)
        QRCore.Functions.Notify(locale('vec4_copied'), 'success', 5000)
    elseif TYPE == 'heading' then
        copyCoords = h
        QRCore.Functions.Notify(locale('heading_copied'), 'success', 5000)
    end

    lib.setClipboard(copyCoords)
    if currentMenu then lib.showMenu(currentMenu) end
end