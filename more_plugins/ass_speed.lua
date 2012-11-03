
local PLUGIN = {}

PLUGIN.Name = "Speed"
PLUGIN.Author = "PC Camp"
PLUGIN.Date = "May, 2008"
PLUGIN.Filename = PLUGIN_FILENAME
PLUGIN.ClientSide = true
PLUGIN.ServerSide = true
PLUGIN.APIVersion = 2.3
PLUGIN.Gamemodes = {}

if (SERVER) then

	ASS_NewLogLevel("ASS_ACL_SPEED")
	
	function PLUGIN.Speed( PLAYER, CMD, ARGS )

		if (PLAYER:IsTempAdmin()) then

			local TO_RECIEVE = ASS_FindPlayer(ARGS[1])
			local ENABLE = tonumber(ARGS[2]) > 0

			if (!TO_RECIEVE) then

				ASS_MessagePlayer(PLAYER, "Player not found!\n")
				return

			end
			
			if (PLAYER != TO_RECIEVE) then
				if (TO_RECIEVE:IsBetterOrSame(PLAYER) && !ENABLE) then

					// disallow!
					ASS_MessagePlayer(PLAYER, "Access denied! \"" .. TO_RECIEVE:Nick() .. "\" has same or better access then you.")
					return
	
				end
			end

			if (ASS_RunPluginFunction( "AllowSpeed", true, PLAYER, TO_RECIEVE, ENABLE )) then

				if (ENABLE) then
					GAMEMODE:SetPlayerSpeed( TO_RECIEVE, 1000, 2000)
					ASS_LogAction( PLAYER, ASS_ACL_SPEED, "gave speed to " .. ASS_FullNick(TO_RECIEVE) )
				else
					GAMEMODE:SetPlayerSpeed( TO_RECIEVE, 200, 500)
					ASS_LogAction( PLAYER, ASS_ACL_SPEED, "took speed from " .. ASS_FullNick(TO_RECIEVE) )
				end
								
			end

		end

	end
	concommand.Add("ASS_Speed", PLUGIN.Speed)
	
end

if (CLIENT) then

	function PLUGIN.Speed(PLAYER, ALLOW)

		if (type(PLAYER) == "table") then
			for _, ITEM in pairs(PLAYER) do
				if (IsValid(ITEM)) then
					RunConsoleCommand( "ASS_Speed", ITEM:UniqueID(), ALLOW )
				end
			end
		else
			if (!IsValid(PLAYER)) then return end
			RunConsoleCommand( "ASS_Speed", PLAYER:UniqueID(), ALLOW )
		end
			
	end
	
	function PLUGIN.SpeedEnableDisable(MENU, PLAYER)

		MENU:AddOption( "Enable",	function() PLUGIN.Speed(PLAYER, 1) end )
		MENU:AddOption( "Disable",	function() PLUGIN.Speed(PLAYER, 0) end )

	end

	function PLUGIN.AddMenu(DMENU)			

		DMENU:AddSubMenu( "Speed", nil, 
			function(NEWMENU) 
				ASS_PlayerMenu( NEWMENU, {"IncludeAll", "HasSubMenu","IncludeLocalPlayer"}, PLUGIN.SpeedEnableDisable  ) 
			end
		)
		
	end

end

hook.Add( "PlayerSay", "IsPlayerMuted", PLUGIN.IsPlayerMuted)

ASS_RegisterPlugin(PLUGIN)


