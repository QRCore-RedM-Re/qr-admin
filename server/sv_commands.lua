-- Commands --
lib.addCommand(Config.Command, {
  help = 'Open the admin menu (Admin Only)',
  params = {},
  restricted = Config.CommandPerms['menu']
}, function(source, args, raw)
  local src = source
  TriggerClientEvent('qr-admin:client:MainMenu', src)
end)

lib.addCommand('staffchat', {
  help = 'Send Message to Staff',
  params = {
    {
      name = 'message',
      type = 'string',
      help = 'Message',
      optional = false
    },
  },
  restricted = Config.CommandPerms['staffchat']
}, function(source, args, raw)
  staffChatHandler(source, args.message)
end)

lib.addCommand('announce', {
  help = 'Make Announcement',
  params = {
    {
      name = 'message',
      type = 'string',
      help = 'Message',
      optional = false
    },
  },
  restricted = Config.CommandPerms['announce']
}, function(source, args, raw)
  if args.message == '' then return end
  local msg = args.message
  TriggerClientEvent('chat:addMessage', -1, {
    color = { 255, 0, 0},
    multiline = true,
    args = {"[ANNOUNCEMENT] ", msg}
  })
end)

lib.addCommand('warn', {
  help = 'Warn a Player',
  params = {
    {
      name = 'target',
      type = 'playerId',
      help = 'Player ID',
      optional = false
    },
    {
      name = 'reason',
      type = 'string',
      help = 'Warning Reason',
      optional = false
    },
  },
  restricted = Config.CommandPerms['warn']
}, function(source, args, raw)
  local src = source
  local targetPlayer = QRCore.Functions.GetPlayer(tonumber(args.target))
  local senderPlayer = QRCore.Functions.GetPlayer(source)
  local msg = args.reason
  local warnId = 'WARN-'..math.random(1111, 9999)
  if targetPlayer ~= nil then
  TriggerClientEvent('chat:addMessage', targetPlayer.PlayerData.source, { args = { "SYSTEM", ('[WARNING]: %s | [REASON]: %s'):format(GetPlayerName(source), msg) }, color = 255, 0, 0 })
  TriggerClientEvent('chat:addMessage', source, { args = { "SYSTEM", ('[WARNED]: %s | [REASON]: %s'):format(GetPlayerName(targetPlayer.PlayerData.source), msg) }, color = 255, 0, 0 })
    -- MySQL.insert('INSERT INTO player_warns (senderIdentifier, targetIdentifier, reason, warnId) VALUES (?, ?, ?, ?)', {
    --   senderPlayer.PlayerData.license,
    --   targetPlayer.PlayerData.license,
    --   msg,
    --   warnId
    -- })
  else
    QRCore.Functions.Notify(src, 'Player is not online!', 'error')
  end
end)

lib.addCommand('noclip', {
  help = 'No Clip (Admin Only)',
  params = {},
  restricted = Config.CommandPerms['noclip']
}, function(source, args, raw)
  local src = source
  TriggerClientEvent('admin:client:ToggleNoClip', src)
end)

local savedCoords = {}
lib.addCommand('bring', {
  help = 'Bring a player to you (Admin only)',
  params = {
    {
      name = 'target',
      type = 'playerId',
      help = 'Player ID',
      optional = false
    },
  },
  restricted = Config.CommandPerms['bring']
}, function(source, args, raw)
  if args.target then
    local src = source
    local admin = GetPlayerPed(src)
    local coords = GetEntityCoords(admin) -- Admin coords
    local target = GetPlayerPed(tonumber(args.target)) -- Player ped
    SetEntityCoords(target, coords)
    savedCoords[tonumber(args.target)] = GetEntityCoords(target) -- Save player coords
  end
end)

lib.addCommand('bringback', {
  help = 'Bring back a player (Admin only)',
  params = {
    {
      name = 'target',
      type = 'playerId',
      help = 'Player ID',
      optional = false
    },
  },
  restricted = Config.CommandPerms['bringback']
}, function(source, args, raw)
  if args.target then
    local src = source
    local coords = savedCoords[tonumber(args.target)] --Player saved coords
    local target = GetPlayerPed(tonumber(args.target)) --Player ped
    SetEntityCoords(target, coords)
  end
end)

lib.addCommand('goto', {
  help = 'Teleport yourself to the player (Admin only)',
  params = {
    {
      name = 'target',
      type = 'playerId',
      help = 'Player ID',
      optional = false
    },
  },
  restricted = Config.CommandPerms['goto']
}, function(source, args, raw)
  if args.target then
    local src = source
    local admin = GetPlayerPed(src)
    local target = GetPlayerPed(tonumber(args.target))
    local targetCoords = GetEntityCoords(target)
    SetEntityCoords(admin, targetCoords)
  end
end)

-- Staff / Report Commands --
lib.addCommand('reportr', {
  help = 'Respond to Report',
  params = {
    {
      name = 'target',
      type = 'playerId',
      help = 'Player',
      optional = false
    },
    {
      name = 'message',
      type = 'string',
      help = 'Message',
      optional = false
    },
  },
  restricted = Config.CommandPerms['reportr']
}, function(source, args, raw)
  reportResponseHandler(source, args.target, args.message)
end)

lib.addCommand('report', {
  help = 'Send Admin Report',
  params = {
    {
      name = 'message',
      type = 'string',
      help = 'Message',
      optional = false
    },
  },
  restricted = false
}, function(source, args, raw)
  reportHandler(source, args.message)
end)

-- Developer Commands --
lib.addCommand('vector3', {
  help = 'Copy vector3 to clipboard (Admin only)',
  params = {},
  restricted = Config.CommandPerms['vector3']
}, function(source, args, raw)
  local src = source
  TriggerClientEvent('qr-admin:client:copyToClipboard', src, 'coords3')
end)

lib.addCommand('vector4', {
  help = 'Copy vector4 to clipboard (Admin only)',
  params = {},
  restricted = Config.CommandPerms['vector4']
}, function(source, args, raw)
  local src = source
  TriggerClientEvent('qr-admin:client:copyToClipboard', src, 'coords4')
end)

lib.addCommand('heading', {
  help = 'Copy heading to clipboard (Admin only)',
  params = {},
  restricted = Config.CommandPerms['heading']
}, function(source, args, raw)
  local src = source
  TriggerClientEvent('qr-admin:client:CopytoClipboard', src, 'heading')
end)