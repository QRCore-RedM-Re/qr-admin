fx_version 'cerulean'
game 'rdr3'
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'

description 'Admin Menu for QR-Core'

shared_scripts { '@ox_lib/init.lua', 'shared/*.lua' }
client_scripts { 'client/*.lua' }
server_scripts { '@oxmysql/lib/MySQL.lua', 'server/*.lua' }
files { 'locales/*.json' }

lua54 'yes'