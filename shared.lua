
DEATHNOTICE = {}
DEATHNOTICE.Attackers = {}
DEATHNOTICE.Victims = {}
CURRENTDEATH = {}
if SERVER then


	function Ondeath( victim, inflictor, attacker )

	DEATHNOTICE.Attackers[CurTime()] = attacker
	DEATHNOTICE.Victims[CurTime()] = victim
	CURRENTDEATH.attacker = {}
	CURRENTDEATH.victim = {}

	i = 0
	for k,v in pairs(DEATHNOTICE.Attackers) do
		if CurTime() - 10 < k then
			i = i + 1

			if DEATHNOTICE.Attackers[k]:IsPlayer() then
				CURRENTDEATH.attacker[k] = tostring( DEATHNOTICE.Attackers[k]:Name() )
			elseif DEATHNOTICE.Attackers[k]:IsNPC() then
				CURRENTDEATH.attacker[k] = tostring( DEATHNOTICE.Attackers[k] )
			elseif IsValid(DEATHNOTICE.Attackers[k]:GetOwner()) and DEATHNOTICE.Attackers[k]:GetOwner():IsPlayer() and IsValid(DEATHNOTICE.Attackers[k]) then 
				CURRENTDEATH.attacker[k] = tostring( DEATHNOTICE.Attackers[k]:GetOwner():Name() )
			else
				CURRENTDEATH.attacker[k] = "World"
			end

			if DEATHNOTICE.Victims[k]:IsPlayer() then
				CURRENTDEATH.victim[k] = tostring( DEATHNOTICE.Victims[k]:Name() )
			elseif DEATHNOTICE.Victims[k]:IsNPC() then
				CURRENTDEATH.victim[k] = tostring( DEATHNOTICE.Victims[k] )
			elseif DEATHNOTICE.Victims[k]:GetOwner():IsPlayer() then 
				CURRENTDEATH.victim[k] = tostring( DEATHNOTICE.Victims[k]:GetOwner():Name() )
			else
				CURRENTDEATH.victim[k] = "World"
			end
		end
	end

	util.AddNetworkString( "DEATHNOTICE" )
	net.Start( "DEATHNOTICE" , true)
	net.WriteTable( CURRENTDEATH )
	net.Broadcast()
	
end

hook.Add("PlayerDeath","DEATHNOTICE",Ondeath)

hook.Add("OnNPCKilled","DEATHNOTICE_2",Ondeath)

end



if CLIENT then
	print("CLIENT")
surface.CreateFont("DEATHNOTICEFONT", {
    font = "Segoe UI Light",
    size = 28,
    weight = 300
})
	function DrawShaarDeathNotice()
		i = 0

		for k,v in pairs(DEATHNOTICECLIENT.attacker) do
			if CurTime() - 10 < k then i = i + 1
				if v == LocalPlayer():Name() or DEATHNOTICECLIENT.victim[k] == LocalPlayer():Name() then
					draw.RoundedBox( 0, ScrW()/1.27 - 100 , ScrH()/100 + i*45 - 40, 500, 40, Color(200 ,0 ,0 , 200) )
					draw.SimpleText( v, "DEATHNOTICEFONT", ScrW()/1.27 - 90, ScrH()/100 + i*45 - 20, Color( 255, 255, 255 ), 0, 1 )
					draw.SimpleText( DEATHNOTICECLIENT.victim[k], "DEATHNOTICEFONT", ScrW()/1.27 + 390, ScrH()/100 + i*45 - 20, Color( 255, 255, 255 ), 2, 1 )
				else
					draw.RoundedBox( 0, ScrW()/1.27 - 100 , ScrH()/100 + i*45 - 40, 500, 40, Color(0 ,0 ,0 , 100) )
					draw.SimpleText( v, "DEATHNOTICEFONT", ScrW()/1.27 - 90, ScrH()/100 + i*45 - 20, Color( 255, 255, 255 ), 0, 1 )
					draw.SimpleText( DEATHNOTICECLIENT.victim[k], "DEATHNOTICEFONT", ScrW()/1.27 + 390, ScrH()/100 + i*45 - 20, Color( 255, 255, 255 ), 2, 1 )
				end
		end
		end
	end

	net.Receive( "DEATHNOTICE", function( len, ply )
		 DEATHNOTICECLIENT = net.ReadTable()
		 PrintTable(DEATHNOTICECLIENT)
		 hook.Add("HUDPaint","DEATHNOTICE" , DrawShaarDeathNotice)
	end )


end