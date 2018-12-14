
DEATHNOTICE = {}
DEATHNOTICE.Attackers = {}
DEATHNOTICE.Victims = {}
DEATHNOTICE.Weapons = {}
CURRENTDEATH = {}
if SERVER then


	function Ondeath( victim, inflictor, attacker )

	
		for i=1,20 do
			if !DEATHNOTICE.Attackers[CurTime()+i/100] then 
				DEATHNOTICE.Attackers[CurTime()+i/100] = attacker
			break
			end
		end

		for i=1,20 do
			if !DEATHNOTICE.Victims[CurTime()+i/100] then 
				DEATHNOTICE.Victims[CurTime()+i/100] = victim
			break
			end
		end

		for i=1,20 do
			if !DEATHNOTICE.Weapons[CurTime()+i/100] then 
				DEATHNOTICE.Weapons[CurTime()+i/100] = inflictor
			break
			end
		end
		
	CURRENTDEATH.attacker = {}
	CURRENTDEATH.victim = {}
	CURRENTDEATH.weapon = {}

	i = 0
	for k,v in pairs(DEATHNOTICE.Attackers) do
		if CurTime() - 10 < k then
			i = i + 1
			if DEATHNOTICE.Attackers[k]:IsPlayer() then
				CURRENTDEATH.attacker[k] = tostring( DEATHNOTICE.Attackers[k]:Name() )
			elseif DEATHNOTICE.Attackers[k]:IsNPC() then
				CURRENTDEATH.attacker[k] = tostring( DEATHNOTICE.Attackers[k]:GetClass() )
			elseif IsValid(DEATHNOTICE.Attackers[k]) then 
				CURRENTDEATH.attacker[k] = tostring( DEATHNOTICE.Attackers[k]:GetOwner():Name() )
			else
				CURRENTDEATH.attacker[k] = "World"
			end

			if DEATHNOTICE.Victims[k]:IsPlayer() then
				CURRENTDEATH.victim[k] = tostring( DEATHNOTICE.Victims[k]:Name() )
			elseif DEATHNOTICE.Victims[k]:IsNPC() then
				CURRENTDEATH.victim[k] = tostring( DEATHNOTICE.Victims[k]:GetClass() )
			elseif DEATHNOTICE.Victims[k]:GetOwner():IsPlayer() then 
				CURRENTDEATH.victim[k] = tostring( DEATHNOTICE.Victims[k]:GetOwner():Name() )
			else
				CURRENTDEATH.victim[k] = "World"
			end

			if DEATHNOTICE.Weapons[k] then
				CURRENTDEATH.weapon[k] = tostring( DEATHNOTICE.Weapons[k] )
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
	i = 0
	Mouvement = 0
	print("CLIENT")
surface.CreateFont("DEATHNOTICEFONT", {
    font = "Segoe UI Light",
    size = 28,
    weight = 300
})
	function DrawShaarDeathNotice()
		
		u = 0
		for k,v in pairs(DEATHNOTICECLIENT.attacker) do
			if CurTime() - 6 < k then 
				u = u + 1
				OldCount = u
			end
		end

		if OldCount < i and OldCount != 0 then  Mouvement = Mouvement - (OldCount - i)*45 end
		i = 0

		if Mouvement != 0 then
			Mouvement = math.Approach( Mouvement , 0, 1 )
		end

		for k,v in pairs(DEATHNOTICECLIENT.attacker) do
			if CurTime() - 6 < k then i = i + 1
				if v == LocalPlayer():Name() or DEATHNOTICECLIENT.victim[k] == LocalPlayer():Name() then

					local triangle = {
						{ x = ScrW()/1.27 - 100 + 250 - 15, y = ScrH()/100 + i*45 - 20 + Mouvement + 10},
						{ x = ScrW()/1.27 - 100 + 250 + 15, y = ScrH()/100 + i*45 - 20 + Mouvement},
						{ x = ScrW()/1.27 - 100 + 250 - 15, y = ScrH()/100 + i*45 - 20 + Mouvement - 10}
						}

					
					draw.RoundedBox( 0, ScrW()/1.27 - 100 , ScrH()/100 + i*45 - 40 + Mouvement, 500, 40, Color(200 ,0 ,0 , 200) )
					draw.SimpleText( v, "DEATHNOTICEFONT", ScrW()/1.27 - 90, ScrH()/100 + i*45 - 20 + Mouvement, Color( 255, 255, 255 ), 0, 1 )
					draw.SimpleText( DEATHNOTICECLIENT.victim[k], "DEATHNOTICEFONT", ScrW()/1.27 + 390, ScrH()/100 + i*45 - 20 + Mouvement, Color( 255, 255, 255 ), 2, 1 )

					surface.SetDrawColor( 0, 0, 0, 255 )
					surface.DrawPoly( triangle )
				else

					local triangle = {
						{ x = ScrW()/1.27 - 100 + 250 - 15, y = ScrH()/100 + i*45 - 20 + Mouvement + 10},
						{ x = ScrW()/1.27 - 100 + 250 + 15, y = ScrH()/100 + i*45 - 20 + Mouvement},
						{ x = ScrW()/1.27 - 100 + 250 - 15, y = ScrH()/100 + i*45 - 20 + Mouvement - 10}
						}


					draw.RoundedBox( 0, ScrW()/1.27 - 100 , ScrH()/100 + i*45 - 40 + Mouvement, 500, 40, Color(0 ,0 ,0 , 100) )
					draw.SimpleText( v, "DEATHNOTICEFONT", ScrW()/1.27 - 90, ScrH()/100 + i*45 - 20 + Mouvement, Color( 255, 255, 255 ), 0, 1 )
					draw.SimpleText( DEATHNOTICECLIENT.victim[k], "DEATHNOTICEFONT", ScrW()/1.27 + 390, ScrH()/100 + i*45 - 20 + Mouvement, Color( 255, 255, 255 ), 2, 1 )

					surface.SetDrawColor( 255, 255, 255, 200 )
					surface.DrawPoly( triangle )
				end
		else end
		end

		if i == 0 then Mouvement = 0 end
	end

	net.Receive( "DEATHNOTICE", function( len, ply )
		 DEATHNOTICECLIENT = net.ReadTable()
		 PrintTable(DEATHNOTICECLIENT)
		 hook.Add("HUDPaint","DEATHNOTICE" , DrawShaarDeathNotice)
	end )


end