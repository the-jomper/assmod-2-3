
local PLUGIN = {}

PLUGIN.Name = "AFK Kicker"
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
	local afkkicktime = 1200 -- THIS IS THE AFK TIME (sec)
/*====================================================
======================================================
====================================================*/
	
	function PLUGIN.ResetAFKTimer( ply )
		function KickMe( ply )
			if ply:IsValid() and not ply:IsAdmin() then
				RunConsoleCommand( "kickid", ply:UserID(), "Idle for "..afkkicktime.." seconds." )
			end
		end
		timer.Create( ply:Nick(), afkkicktime, 0, KickMe, ply )
	end
	hook.Add( "KeyPress", "KeyPressed", PLUGIN.ResetAFKTimer )
	hook.Add( "PlayerInitialSpawn", "PlayerInitialSpawn", PLUGIN.ResetAFKTimer )

end

if (CLIENT) then
end

ASS_RegisterPlugin(PLUGIN)


