-- Get Horses --
local function GetHorsesByCategory(CATEGORY)
    local Horses = {}
    for horse, info in pairs(QRCore.Shared.GetHorses()) do
        if info.category == CATEGORY then
            table.insert(Horses, horse)
        end
    end
    return Horses
end

-- Horses Category Menu --
local function horseCategoryMenu(category)
    local Category = {}
    local HorsesMenu = {}
    local Horses = GetHorsesByCategory(category)

    for _, x in pairs(Horses) do
        HorsesMenu[#HorsesMenu + 1] = {
            label = QRCore.Shared.GetHorse(x)['name'],
            args = { type = 'horse', horse = QRCore.Shared.GetHorse(x)['model'] },
        }
    end

    lib.registerMenu({
        id = 'horses_category_menu',
        title = category,
        position = 'top-right',
        onClose = function(keyPressed) if keyPressed == 'Backspace' then lib.showMenu('admin_horses') end end,
        options = HorsesMenu
    }, function(selected, scrollIndex, args)
        local pCoords = GetEntityCoords(cache.ped)
        local coords = vector4(pCoords.x, pCoords.y, pCoords.z, GetEntityHeading(cache.ped))
        adminMounts[#adminMounts+1] = spawnMount(args.type, args.horse, coords)
    end)
    lib.showMenu('horses_category_menu')
end

-- Horses Menu --
function horsesMenu()
    local hasPerms = lib.callback.await('admin:server:hasMenuPerms', false, 'mounts')
    if not hasPerms then return end

    local Category = {}
    local HorsesMenu = {}

    for _, x in pairs(QRCore.Shared.GetHorses()) do
        if Category[x.category] == nil or not Category[x.category] then
            Category[x.category] = true
            HorsesMenu[#HorsesMenu + 1] = { label = x.category, args = x.category }
        end
    end

    lib.registerMenu({
        id = 'admin_horses',
        title = locale('horses_menu_title'),
        position = 'top-right',
        onClose = function(keyPressed) if keyPressed == 'Backspace' then lib.showMenu('admin_menu') end end,
        options = HorsesMenu
    }, function(_, _, args)
        horseCategoryMenu(args)
    end)
    lib.showMenu('admin_horses')
end

-- Wagons Menu --
function wagonsMenu()
    local hasPerms = lib.callback.await('admin:server:hasMenuPerms', false, 'mounts')
    if not hasPerms then return end
    local HorsesMenu = {}

    for k, v in pairs(QRCore.Shared.GetVehicles()) do
        HorsesMenu[#HorsesMenu + 1] = {
            label = v.name,
            args = { type = 'wagon', horse = k },
        }
    end

    lib.registerMenu({
        id = 'wagon_menu',
        title = locale('wagons_menu_title'),
        position = 'top-right',
        onClose = function(keyPressed) if keyPressed == 'Backspace' then lib.showMenu('admin_menu') end end,
        options = HorsesMenu
    }, function(_, _, args)
        local pCoords = GetEntityCoords(cache.ped)
        local coords = vector4(pCoords.x, pCoords.y, pCoords.z, GetEntityHeading(cache.ped))
        adminMounts[#adminMounts+1] = spawnMount(args.type, args.horse, coords)
    end)
    lib.showMenu('wagon_menu')
end