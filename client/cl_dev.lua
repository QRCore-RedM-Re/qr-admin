local copyCoordsKey = QRCore.Shared.GetKey(Config.CopyCoordsKey)
local showingCoords = false
local viewingHashes = false

-- Show Coordinates --
local function ToggleShowCoordinates()
    showingCoords = not showingCoords
    if not showingCoords then
        while lib.isTextUIOpen() do
            Wait(10)
            lib.hideTextUI()
        end
        return
    end

    while showingCoords do
        local coords = GetEntityCoords(cache.ped)
        local heading = GetEntityHeading(cache.ped)
        local c = {}
        c.x = QRCore.Shared.Round(coords.x, 2)
        c.y = QRCore.Shared.Round(coords.y, 2)
        c.z = QRCore.Shared.Round(coords.z, 2)
        c.w = QRCore.Shared.Round(heading, 2)
        Wait(0)

        lib.showTextUI(('%s  \nvec4(%s, %s, %s, %s'):format(locale('show_coords'), c.x, c.y, c.z, c.w), {
            position = "top-center",
            icon = 'fas fa-map-pin',
        })

        if IsControlJustReleased(0, copyCoordsKey) then
            copyToClipboard('coords4')
        end
    end
end

-- Toggle Nearby Hashes --
local function ViewHashes(type)
    viewingHashes = not viewingHashes
    if viewingHashes then
        QRCore.Functions.Notify(locale('hashes_on'), 'success', 5000)
    else
        QRCore.Functions.Notify(locale('hashes_off'), 'error', 5000)
        return
    end

    local pool
    if type == 'peds' then
        pool = GetGamePool('CPed')
    elseif type == 'objects' then
        pool = GetGamePool('CObject')
    elseif type == 'vehicles' then
        pool = GetGamePool('CVehicle')
    end

    while viewingHashes do
        local pcoords = GetEntityCoords(cache.ped)
        for _, v in pairs(pool) do
            local pedModel = GetEntityModel(v)
            local pedCoords = GetEntityCoords(v)
            local dist = #(pedCoords - pcoords)
            if dist <= 5.0 then
                if type == 'peds' then
                    if not IsPedAPlayer(v) then
                        DrawText3D(pedCoords.x, pedCoords.y, pedCoords.z + 1, tostring(GetEntityModel(v)))
                    end
                else
                    DrawText3D(pedCoords.x, pedCoords.y, pedCoords.z + 1, tostring(GetEntityModel(v)))
                end
            end
        end
        Wait(10)
    end
end

-- Dev Menu Options --
local DevOptions = {
    function() ToggleShowCoordinates() end,
    function() copyToClipboard('coords3') end,
    function() copyToClipboard('coords4') end,
    function() copyToClipboard('heading') end,
    function() ViewHashes('objects') end,
    function() ViewHashes('peds') end,
    function() ViewHashes('vehicles') end,
}

-- Open Dev Menu --
function devMenu()
    local hasPerms = lib.callback.await('admin:server:hasMenuPerms', false, 'dev')
    if not hasPerms then return end

    lib.registerMenu({
        id = 'dev_menu',
        title = locale('dev_tools_title'),
        position = 'top-right',
        onClose = function(keyPressed) if keyPressed == 'Backspace' then lib.showMenu('admin_menu') end end,
        options = {
            { label = locale('display_coords'), icon = 'fas fa-street-view',   close = false },
            { label = locale('copy_vec3'),      icon = 'fas fa-3',             close = false },
            { label = locale('copy_vec4'),      icon = 'fas fa-4',             close = false },
            { label = locale('copy_heading'),   icon = 'fas fa-compass',       close = false },
            { label = locale('obj_hashes'),     icon = 'fas fa-box-archive',   close = false },
            { label = locale('ped_hashes'),     icon = 'fas fa-person',        close = false },
            { label = locale('veh_hashes'),     icon = 'fas fa-horse',         close = false },
        }
    }, function(selected, scrollIndex, args)
        DevOptions[selected](scrollIndex)
    end)
    lib.showMenu('dev_menu')
end

RegisterNetEvent('qr-admin:client:CopytoClipboard', function(type) CopyToClipboard(type) end)