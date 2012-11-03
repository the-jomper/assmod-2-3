
local PLUGIN = {}

PLUGIN.Name = "Ragdoll"
PLUGIN.Author = "PC Camp"
PLUGIN.Date = "May, 2008"
PLUGIN.Filename = PLUGIN_FILENAME
PLUGIN.ClientSide = true
PLUGIN.ServerSide = true
PLUGIN.APIVersion = 2.3
PLUGIN.Gamemodes = {}

if (SERVER) then

	ASS_NewLogLevel("ASS_ACL_RAGDOLL")
	
	function PLUGIN.Ragdoll( PLAYER, CMD, ARGS )

		if (PLAYER:IsTempAdmin()) then

			local TO_RAG = ASS_FindPlayer(ARGS[1])
			local ENABLE = tonumber(ARGS[2]) > 0

			if (!TO_RAG) then

				ASS_MessagePlayer(PLAYER, "Player not found!\n")
				return

			end
			
			if (PLAYER != TO_RAG) then
				if (TO_RAG:IsBetterOrSame(PLAYER) && !ENABLE) then

					// disallow!
					ASS_MessagePlayer(PLAYER, "Access denied! \"" .. TO_RAG:Nick() .. "\" has same or better access then you.")
					return
	
				end
			end

			if (ASS_RunPluginFunction( "AllowRagdoll", true, PLAYER, TO_RAG, ENABLE )) then

				if (ENABLE) then
				
					if not TO_RAG:GetNWBool( "isragdoll" ) then

						if TO_RAG:InVehicle() then
							TO_RAG:ExitVehicle()
							TO_RAG:GetParent():Remove()
						end
						if TO_RAG:GetMoveType() == MOVETYPE_NOCLIP then
							TO_RAG:SetMoveType( MOVETYPE_WALK )
						end

						TO_RAG:SetNWBool( "isragdoll", true )
						TO_RAG:StripWeapons()
						TO_RAG:DrawViewModel( false )
						TO_RAG:DrawWorldModel( false )
						TO_RAG:SetColor( 255, 255, 255, 0 )

						ass_ragdoll = ents.Create( "prop_ragdoll" )
						ass_ragdoll:SetPos( TO_RAG:GetPos() )
						ass_ragdoll:SetModel( TO_RAG:GetModel() )
						ass_ragdoll:SetAngles( TO_RAG:GetAngles() )
						ass_ragdoll:Spawn()
						ass_ragdoll:Activate()
						
						TO_RAG:Spectate( OBS_MODE_ROAMING )
						TO_RAG:Freeze( true )
						TO_RAG:SetNWEntity( "plyragdoll", ass_ragdoll )
						
						ASS_LogAction( PLAYER, ASS_ACL_RAGDOLL, "ragdolled " .. ASS_FullNick(TO_RAG) )
						
					else
						ASS_MessagePlayer(PLAYER, TO_RAG:Nick() .. " is already ragdolled!")
					end

				else
					if TO_RAG:GetNWBool( "isragdoll" ) then
						if ass_ragdoll:IsValid() then

							ass_ragdoll:Remove()
							TO_RAG:SetPos( ass_ragdoll:GetPos() + Vector( 0, 0, 50 ) )
							TO_RAG:Spawn()
							if file.Exists( "../lua/plugins/ass_grouping.lua" ) then
								ApplyASSGroupTeams( TO_RAG )
							else
								TO_RAG:SetModel( ass_ragdoll:GetModel() )
							end

						else
							if TO_RAG:GetNWBool( "isragdoll" ) then
								TO_RAG:Kill()
							end
						end
						
						TO_RAG:SetNWBool( "isragdoll", false )
						TO_RAG:DrawViewModel( true )
						TO_RAG:DrawWorldModel( true )
						TO_RAG:SetColor( 255, 255, 255, 255 )
						TO_RAG:Freeze( false )
						
						ASS_LogAction( PLAYER, ASS_ACL_RAGDOLL, "un-ragdolled " .. ASS_FullNick(TO_RAG) )
						
					else
						ASS_MessagePlayer(PLAYER, TO_RAG:Nick() .. " is not ragdolled!")
					end
				end
				
			end

		end

	end
	concommand.Add("ASS_Ragdoll", PLUGIN.Ragdoll)

	function PLUGIN.RemoveRagdollOnDisconnect( ply )
		local ent = ply:GetNWEntity( "plyragdoll" )
		if ent:IsValid() then
			ent:Remove()
		end
	end
	hook.Add( "PlayerDisconnected", "RemoveRagdollOnDisconnect", PLUGIN.RemoveRagdollOnDisconnect )

	function PLUGIN.CanTheyUseThatToRagdoll( ply, tr )
		if tr.Entity == ass_ragdoll then return ply:IsAdmin() end
	end
	hook.Add( "CanTool", "CanTheyUseToolToRagdoll", PLUGIN.CanTheyUseThatToRagdoll )
	hook.Add( "PhysgunPickup", "CanTheyUsePhysToRagdoll", PLUGIN.CanTheyUseThatToRagdoll )

	hook.Add( "PlayerInitialSpawn", "PlayerInitialSpawnRag", function( PLAYER ) PLAYER:SetNWBool( "isragdoll", false ) end )

	hook.Add( "CanPlayerEnterVehicle", "CanPlayerEnterVehicleRag", function( PLAYER ) if PLAYER:GetNWBool( "isragdoll" ) then return false end end )
	hook.Add( "CanPlayerSuicide", "CanPlayerSuicideRag", function( PLAYER ) if PLAYER:GetNWBool( "isragdoll" ) then return false end end )
	hook.Add( "PlayerCanPickupWeapon", "PlayerCanPickupWeaponRag", function( PLAYER ) if PLAYER:GetNWBool( "isragdoll" ) then return false end end )
	hook.Add( "PlayerGiveSWEP", "PlayerGiveSWEPRag", function( PLAYER ) if PLAYER:GetNWBool( "isragdoll" ) then return false end end )
	hook.Add( "PlayerNoClip", "PlayerNoClipRag", function( PLAYER ) if PLAYER:GetNWBool( "isragdoll" ) then return false end end )
	hook.Add( "PlayerSpawnEffect", "PlayerSpawnEffectRag", function( PLAYER ) if PLAYER:GetNWBool( "isragdoll" ) then return false end end )
	hook.Add( "PlayerSpawnNPC", "PlayerSpawnNPCRag", function( PLAYER ) if PLAYER:GetNWBool( "isragdoll" ) then return false end end )
	hook.Add( "PlayerSpawnObject", "PlayerSpawnObjectRag", function( PLAYER ) if PLAYER:GetNWBool( "isragdoll" ) then return false end end )
	hook.Add( "PlayerSpawnSENT", "PlayerSpawnSENTRag", function( PLAYER ) if PLAYER:GetNWBool( "isragdoll" ) then return false end end )
	hook.Add( "PlayerSpawnSWEP", "PlayerSpawnSWEPRag", function( PLAYER ) if PLAYER:GetNWBool( "isragdoll" ) then return false end end )
	hook.Add( "PlayerSpawnProp", "PlayerSpawnPropRag", function( PLAYER ) if PLAYER:GetNWBool( "isragdoll" ) then return false end end )
	hook.Add( "PlayerSpawnRagdoll", "PlayerSpawnRagdollRag", function( PLAYER ) if PLAYER:GetNWBool( "isragdoll" ) then return false end end )
	hook.Add( "PlayerSpawnVehicle", "PlayerSpawnVehicleRag", function( PLAYER ) if PLAYER:GetNWBool( "isragdoll" ) then return false end end )
	hook.Add( "PlayerUse", "PlayerUseRag", function( PLAYER ) if PLAYER:GetNWBool( "isragdoll" ) then return false end end )

end

if (CLIENT) then

	function PLUGIN.CalcView( pl, origin, angles, fov )

		if pl:GetNWBool( "isragdoll" ) then

			local ragdoll = pl:GetNWEntity( "plyragdoll" )
			if not ragdoll or ragdoll == NULL or not ragdoll:IsValid() then return end
			local eyes = ragdoll:GetAttachment( ragdoll:LookupAttachment( "eyes" ) )
			local view = {
				origin = eyes.Pos,
				angles = eyes.Ang,
				fov = 90,
			}

			return view
		else return end
     
    end
    hook.Add( "CalcView", "ASS_RagdollView", PLUGIN.CalcView )

	function PLUGIN.Ragdoll(PLAYER, ALLOW)
		
		if (type(PLAYER) == "table") then
			for _, ITEM in pairs(PLAYER) do
				if (IsValid(ITEM)) then
					RunConsoleCommand( "ASS_Ragdoll", ITEM:UniqueID(), ALLOW )
				end
			end
		else
			if (!IsValid(PLAYER)) then return end
			RunConsoleCommand( "ASS_Ragdoll", PLAYER:UniqueID(), ALLOW )
		end

	end
	
	function PLUGIN.RagdollEnableDisable(MENU, PLAYER)

		MENU:AddOption( "Enable",	function() PLUGIN.Ragdoll(PLAYER, 1) end )
		MENU:AddOption( "Disable",	function() PLUGIN.Ragdoll(PLAYER, 0) end )

	end

	function PLUGIN.AddMenu(DMENU)			

		DMENU:AddSubMenu( "Ragdoll", nil, 
			function(NEWMENU) 
				ASS_PlayerMenu( NEWMENU, {"IncludeAll", "HasSubMenu","IncludeLocalPlayer"}, PLUGIN.RagdollEnableDisable  ) 
			end )

	end

end

ASS_RegisterPlugin(PLUGIN)


