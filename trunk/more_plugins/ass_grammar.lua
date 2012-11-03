
local PLUGIN = {}

PLUGIN.Name = "Grammar"	
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
	local FilterWords = {
		i = "I",
		u = "you",
		cuz = "because",
		r = "are",
		im = "I'm",
		ur = "your",
		omg = "oh my gosh",
		omfg = "oh my freakin gosh",
		ass = "butt",
		wtf = "what the fudge",
		tbh = "to be honest",
		usa = "United States of America",
		wont = "won't",
		dont = "don't",
		cant = "can't",
		theyre = "they're",
		lol = "haha",
		rofl = "haha",
		gay = "homosexual",
		hax = "hacks",
		teh = "the",
		lagging = "lag",
		lagspike = "lag",
		lagspiked = "lag",
		lagg = "lag",
		lags = "lag",
		bbl = "be back later",
		brb = "be right back",
		bsod = "blue screen of death",
		hai = "hey",
		haitut = "hey to you too",
		bbiab = "be back in a bit",
		afaicr = "as far as I can recall",
		asap = "as soon as possible",
		atm = "at the moment",
		leet = "leet",
		cya = "see ya",
		faq = "frequently asked questions",
		ffs = "for freaks sake",
		ftw = "for the win",
		flt = "for the lose",
		gtg = "got to go",
		g2g = "got to go",
		haxor = "hacker",
		motd = "message of the day",
		ty = "thank you",
		np = "no problem",
		wtg = "way to go",
		wth = "what the heck",
		zomg = "oh my gosh",
		nub = "noob",
	}
/*====================================================
======================================================
====================================================*/

	function PLUGIN.WhenPlayerSaysSomethingNoobish( PLAYER, Text )
	
		local RetText = " "..string.lower( Text ).." "
		
		for K, V in pairs( FilterWords ) do
			RetText = string.Replace( RetText, " "..K.." ", " "..V.." " )
		end
		
		RetText = string.Trim( RetText )
		
		local UpperText = string.upper( string.sub( RetText, 0, 1 ) )
		
		RetText = UpperText..""..string.sub( RetText, 2, string.len( RetText ) )
		
		if not string.find( string.sub( RetText, string.len( RetText ) ), "%p" ) then
			RetText = RetText.."."
		end
		
		if file.Exists( "addons/Assmod_2.3//lua/plugins/ass_mute.lua", "GAME" ) and PLAYER:GetNWBool( "playermuted" ) then return end
		if file.Exists( "addons/Assmod_2.3//lua/plugins/ass_gimp.lua", "GAME" ) and PLAYER:GetNWBool( "playergimped" ) then return end
		
		return RetText
	
	end
	hook.Add( "PlayerSay", "WhenPlayerSaysSomethingNoobish", PLUGIN.WhenPlayerSaysSomethingNoobish)

end

if (CLIENT) then
end

ASS_RegisterPlugin(PLUGIN)


