
local PLUGIN = {}

PLUGIN.Name = "Cleanup Disconnect"
PLUGIN.Author = "PC Camp"
PLUGIN.Date = "May, 2008"
PLUGIN.Filename = PLUGIN_FILENAME
PLUGIN.ClientSide = true
PLUGIN.ServerSide = true
PLUGIN.APIVersion = 2.3
PLUGIN.Gamemodes = { "sandbox" }

if (SERVER) then
	
	hook.Add("PlayerDisconnected", "CleanUpWhenDisconnect",
        function( ply )
            cleanup.CC_Cleanup( ply, "gmod_cleanup", {} )
        end
    )

end

if (CLIENT) then
end

ASS_RegisterPlugin(PLUGIN)


