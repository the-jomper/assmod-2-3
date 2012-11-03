
local PLUGIN = {}

PLUGIN.Name = "ASSmod MOTD"
PLUGIN.Author = "PC Camp"
PLUGIN.Date = "May, 2008"
PLUGIN.Filename = PLUGIN_FILENAME
PLUGIN.ClientSide = true
PLUGIN.ServerSide = true
PLUGIN.APIVersion = 2.3
PLUGIN.Gamemodes = {}

if CLIENT then
/*====================================================
================== CONFIGURATION =====================
====================================================*/

	ASSMOTD_TimeToWait = 3 -- The time needed until the player can exit the MOTD in seconds
end

/*====================================================
======================================================
====================================================*/

if (SERVER) then

	function PLUGIN.OpenMOTDWhenPlayerSpawns( ply )
		ply:ConCommand( "ASS_MotdOpen" )
	end
	hook.Add( "PlayerInitialSpawn", "OpenMOTDWhenPlayerSpawns", PLUGIN.OpenMOTDWhenPlayerSpawns )

end

if (CLIENT) then

	ASSMOTD_HTMLMOTD = [[
	<html>
	<body bgcolor=#FFFFFF>
		<div style="text-align: center;">
			<div style="width: 80%; margin: 0px auto; border: 10px solid #3366FF; background-color: #B0B0B0; padding: 10px; font-size: 12px; font-family: Tahoma; margin-top: 30px; color: #000066; text-align: left;">
				<div style="font-size: 30px; font-family: impact; width: 100%; margin-bottom: 5px;">My Server Name</div><br>
					<h2>News:</h2>
						New plugins installed to the server for ASSmod!<br>
						This server is dedicated to helping with any client that joins.<br>
					<br>
					<h2>Rules:</h2>
						1. Don't mess with other players.<br>
						2. Don't spam ever. You will be kicked.<br>
						3. Have fun!<br>
					<br>
					<h2>Admins:</h2>
					[ASS] | Moby Dick<br>
					[ASS] | Sucka Dick<br>
					[ASS] | Something else about Dick<br>
				<div style="width: 100%; text-align: center; margin: 10px; font-weight: bold;">- Server Owner</div>
			</div>
		</div>
	</body>
	</html>
	]]

	function PLUGIN.OpenMOTD( ply, cmd, args )
			
		local MOTDFrame = vgui.Create( "DFrame" )
		MOTDFrame:SetTitle( "ASS MOTD" )
		MOTDFrame:SetSize( ScrW() - 100, ScrH() - 100 )
		MOTDFrame:Center()
		MOTDFrame:ShowCloseButton( false )
		MOTDFrame:SetBackgroundBlur( true )
		MOTDFrame:SetDraggable( false )
		MOTDFrame:SetVisible( true )
		MOTDFrame:MakePopup()

		local MOTDHTMLFrame = vgui.Create( "HTML", MOTDFrame )
		MOTDHTMLFrame:SetPos( 25, 50 )
		MOTDHTMLFrame:SetSize( MOTDFrame:GetWide() - 50, MOTDFrame:GetTall() - 150 )
		MOTDHTMLFrame:SetHTML( ASSMOTD_HTMLMOTD )
		
		local CloseButton = vgui.Create( "DButton", MOTDFrame )
		CloseButton:SetSize( 100, 50 )
		CloseButton:SetPos( ( MOTDFrame:GetWide() / 2 ) - ( CloseButton:GetWide() / 2 ), MOTDFrame:GetTall() - 75 )
		CloseButton:SetText( "Close" )
		CloseButton:SetVisible( false )
		CloseButton.DoClick = function() 
			MOTDFrame:Remove()
		end
		
		timer.Simple( ASSMOTD_TimeToWait, function()
			CloseButton:SetVisible( true )
		end )

	end
	concommand.Add( "ASS_MotdOpen", PLUGIN.OpenMOTD )
	
	function PLUGIN.DeleteOldMOTDWhenLeave( ply )
		file.Delete( "ASSmod/motd.txt" )
	end
	hook.Add( "ShutDown", "DeleteOldMOTDWhenLeave", PLUGIN.DeleteOldMOTDWhenLeave )
	usermessage.Hook( "DeleteMOTD", PLUGIN.DeleteOldMOTDWhenLeave )
	
	function PLUGIN.ShowMOTD(MENUITEM)
		RunConsoleCommand( "ASS_MotdOpen" )
	end
	function PLUGIN.AddNonAdminMenu(MENU)
		MENU:AddOption( "View MOTD", PLUGIN.ShowMOTD )
	end

end

ASS_RegisterPlugin(PLUGIN)


