
local PLUGIN = {}

PLUGIN.Name = "Armor"
PLUGIN.Author = "Legitcobra"
PLUGIN.Date = "January 30 2008"
PLUGIN.Filename = PLUGIN_FILENAME
PLUGIN.ClientSide = true
PLUGIN.ServerSide = true
PLUGIN.APIVersion = 2.3
PLUGIN.Gamemodes = {}

if (SERVER) then

	ASS_NewLogLevel("ASS_ACL_ARMOR")

	function PLUGIN.GiveTakeArmor( PLAYER, CMD, ARGS )

		if (PLAYER:IsTempAdmin()) then

			local TO_RECIEVE = ASS_FindPlayer(ARGS[1])
			local ARMOR = tonumber(ARGS[2]) or 0

			if (!TO_RECIEVE) then

				ASS_MessagePlayer(PLAYER, "Player not found!\n")
				return

			end
			
			if (ARMOR == 0) then return end // nothing to do!

			if (PLAYER != TO_RECIEVE) then
				if (TO_RECIEVE:IsBetterOrSame(PLAYER) && ARMOR < 0) then

					// disallow!
					ASS_MessagePlayer(PLAYER, "Access denied! \"" .. TO_RECIEVE:Nick() .. "\" has same or better access then you.")
					return
				end
			end

			if (ASS_RunPluginFunction( "AllowPlayerArmor", true, PLAYER, TO_RECIEVE, ARMOR )) then

				if (ARMOR < 0) then

					TO_RECIEVE:Hurt( -ARMOR )
					ASS_LogAction( PLAYER, ASS_ACL_ARMOR, "took " .. -ARMOR .. " armor from " .. ASS_FullNick(TO_RECIEVE) )

				else

					TO_RECIEVE:SetArmor( TO_RECIEVE:Armor() + ARMOR )
					ASS_LogAction( PLAYER, ASS_ACL_ARMOR, "gave " .. ASS_FullNick(TO_RECIEVE) .. " " .. ARMOR .. " armor"  )

				end

			end


		else

			ASS_MessagePlayer( PLAYER, "Access Denied!\n")

		end

	end
	concommand.Add("ASS_GiveTakeArmor", PLUGIN.GiveTakeArmor)

end

if (CLIENT) then

	function PLUGIN.GiveTakeArmor(PLAYER, AMOUNT)

		if (!PLAYER:IsValid()) then return end
		
		RunConsoleCommand( "ASS_GiveTakeArmor", PLAYER:UniqueID(), AMOUNT )
		return true

	end
	
	function PLUGIN.PosAmountPower(MENU, PLAYER)

		for i=10,100,10 do
			MENU:AddOption( tostring(i),	function() PLUGIN.GiveTakeArmor(PLAYER,  i) end )
		end

	end
	
	function PLUGIN.NegAmountPower(MENU, PLAYER)

		for i=10,100,10 do
			MENU:AddOption( tostring(i),	function() PLUGIN.GiveTakeArmor(PLAYER,  -i) end )
		end

	end

	function PLUGIN.AddMenu(DMENU)			
	
		DMENU:AddSubMenu( "Give Armor", nil, function(NEWMENU) ASS_PlayerMenu( NEWMENU, {"IncludeLocalPlayer","HasSubMenu"}, PLUGIN.PosAmountPower  ) end ):SetImage( "gui/silkicons/heart" )
		DMENU:AddSubMenu( "Take Armor", nil, function(NEWMENU) ASS_PlayerMenu( NEWMENU, {"IncludeLocalPlayer","HasSubMenu"}, PLUGIN.NegAmountPower  ) end ):SetImage( "gui/silkicons/pill" )

	end

end

ASS_RegisterPlugin(PLUGIN)


