
local PLUGIN = {}

PLUGIN.Name = "No Player Collision"
PLUGIN.Author = "PC Camp"
PLUGIN.Date = "May, 2008"
PLUGIN.Filename = PLUGIN_FILENAME
PLUGIN.ClientSide = true
PLUGIN.ServerSide = true
PLUGIN.APIVersion = 2.3
PLUGIN.Gamemodes = {}

if (SERVER) then

	hook.Add( "PlayerSpawn", "PlayerCollision", function(ply) ply:SetCollisionGroup(11) end )

end

if (CLIENT) then
end

ASS_RegisterPlugin(PLUGIN)


