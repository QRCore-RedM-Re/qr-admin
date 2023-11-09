Config = {}

Config.Command = 'am'               -- Open menu command
Config.CopyCoordsKey = '7'          -- Key to copy current coords when view coords is enabled

-- Minimum Perms for Each Admin Menu --
Config.MenuPerms = {
    ['main'] = 'mod',               -- Main menu
    ['players'] = 'mod',            -- Players menu
    ['admin'] = 'admin',            -- Admin tools menu
    ['server'] = 'admin',           -- Server management menu
    ['mounts'] = 'admin',           -- Horses/Wagons menu
    ['dev'] = 'god'                 -- Developer menu
}

-- Permissions for Commands --
Config.CommandPerms = {
    ['menu'] = 'mod',
    ['staffchat'] = 'mod',
    ['noclip'] = 'admin',
    ['announce'] = 'admin',
    ['warn'] = 'admin',
    ['bring'] = 'admin',
    ['bringback'] = 'admin',
    ['goto'] = 'admin',
    ['reportr'] = 'admin',
    ['vector3'] = 'god',
    ['vector4'] = 'god',
    ['heading'] = 'god',
}

-- Permissions for Player Options --
Config.PlayerPermissions = {
    { title = 'Kill',                 permission = 'admin',     icon = 'fas fa-skull-crossbones',            event = 'admin:server:kill',           type = 'server', close = false },
    { title = 'Revive',               permission = 'admin',     icon = 'fas fa-briefcase-medical',           event = 'admin:server:revive',         type = 'server', close = false },
    { title = 'Heal',                 permission = 'admin',     icon = 'fas fa-star-of-life',                event = 'admin:server:heal',           type = 'server', close = false },
    { title = 'Go To',                permission = 'admin',     icon = 'fas fa-person-arrow-up-from-line',   event = 'admin:server:goto',           type = 'server', close = false },
    { title = 'Bring',                permission = 'admin',     icon = 'fas fa-person-arrow-down-to-line',   event = 'admin:server:bring',          type = 'server', close = false },
    { title = 'Give Item',            permission = 'admin',     icon = 'fas fa-hands-holding-circle',        event = 'admin:server:giveItem',       type = 'server', close = true },
    { title = 'Sit on Mount',         permission = 'admin',     icon = 'fas fa-horse',                       event = 'admin:server:sitonmount',     type = 'server', close = true },
    { title = 'Open Inventory',       permission = 'admin',     icon = 'fas fa-box-open',                    event = 'admin:server:inventory',      type = 'server', close = true },
    { title = 'Open Clothing Menu',   permission = 'admin',     icon = 'fas fa-shirt',                       event = 'admin:server:cloth',          type = 'server', close = true },
    { title = 'Freeze',               permission = 'admin',     icon = 'fas fa-icicles',                     event = 'admin:server:freeze',         type = 'server', close = false },
    { title = 'Spectate',             permission = 'admin',     icon = 'fas fa-magnifying-glass',            event = 'admin:server:spectate',       type = 'server', close = true },
    { title = 'Ban',                  permission = 'admin',     icon = 'fas fa-ban',                         event = 'admin:server:ban',            type = 'server', close = true },
    { title = 'Kick',                 permission = 'admin',     icon = 'fas fa-plane-departure',             event = 'admin:server:kick',           type = 'server', close = true },
}

-- Weather Options --
Config.Weather = {
    { name = 'SUNNY',             icon = 'fas fa-sun',                    args = 'SUNNY' },
    { name = 'FOGGY',             icon = 'fas fa-smog',                   args = 'FOG' },
    { name = 'CLOUDY',            icon = 'fas fa-cloud',                  args = 'CLOUDS' },
    { name = 'OVERCAST',          icon = 'fas fa-cloud',                  args = 'OVERCAST' },
    { name = 'OVERCASTDARK',      icon = 'fas fa-cloud',                  args = 'OVERCASTDARK' },
    { name = 'MISTY',             icon = 'fas fa-cloud-showers-heavy',    args = 'MISTY' },
    { name = 'DRIZZLE',           icon = 'fas fa-cloud-showers-heavy',    args = 'DRIZZLE' },
    { name = 'RAIN',              icon = 'fas fa-cloud-showers-heavy',    args = 'RAIN' },
    { name = 'RAIN SHOWER',       icon = 'fas fa-cloud-showers-heavy',    args = 'SHOWER' },
    { name = 'THUNDER',           icon = 'fas fa-cloud-showers-heavy',    args = 'THUNDER' },
    { name = 'THUNDERSTORM',      icon = 'fas fa-cloud-showers-heavy',    args = 'THUNDERSTORM' },
    { name = 'HAILING',           icon = 'fas fa-cloud-rain',             args = 'HAIL' },
    { name = 'HIGH PRESSURE',     icon = 'fas fa-hurricane',              args = 'HIGHPRESSURE' },
    { name = 'HURRICANE',         icon = 'fas fa-hurricane',              args = 'HURRICANE' },
    { name = 'SLEET',             icon = 'fas fa-snowflake',              args = 'SLEET' },
    { name = 'LIGHT SNOW',        icon = 'fas fa-snowflake',              args = 'LIGHTSNOW' },
    { name = 'SNOW',              icon = 'fas fa-snowflake',              args = 'SNOW' },
    { name = 'GROUNDBLIZZARD',    icon = 'fas fa-snowflake',              args = 'GROUNDBLIZZARD' },
    { name = 'BLIZZARD',          icon = 'fas fa-snowflake',              args = 'BLIZZARD' },
    { name = 'WHITEOUT',          icon = 'fas fa-snowflake',              args = 'WHITEOUT' },
    { name = 'SANDSTORM',         icon = 'fas fa-wind',                   args = 'SANDSTORM' },
}

--------------------------------------------------

lib.locale()
QRCore = exports['qr-core']:GetCoreObject()