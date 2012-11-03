
local PLUGIN = {}

PLUGIN.Name = "Disable Kill Command"
PLUGIN.Author = "PC Camp"
PLUGIN.Date = "May, 2008"
PLUGIN.Filename = PLUGIN_FILENAME
PLUGIN.ClientSide = true
PLUGIN.ServerSide = true
PLUGIN.APIVersion = 2.3
PLUGIN.Gamemodes = {}

if (SERVER) then
/*====================================================
================== CONFIGURATION =====================
====================================================*/
	local SuicideMessage = "If your stuck, good luck getting out."
/*====================================================
======================================================
====================================================*/

    hook.Add( "CanPlayerSuicide", "NoKill", function( ply ) 
		ply:PrintMessage( 3, SuicideMessage ) 
		return false 
	end )

end

if (CLIENT) then
end

ASS_RegisterPlugin(PLUGIN)


