
DEATHNOTICE = {}
DEATHNOTICE.Attackers = {}
DEATHNOTICE.Victims = {}
DEATHNOTICE.Weapons = {}
CURRENTDEATH = {}
CURRENTDEATH.attacker = {}
CURRENTDEATH.victim = {}
CURRENTDEATH.weapon = {}

if SERVER then


	local function ClearTable()
		if table.Count( CURRENTDEATH.attacker ) > 50 then
			CURRENTDEATH.attacker = {}
			CURRENTDEATH.victim = {}
			CURRENTDEATH.weapon = {}
		end
	end

	function Ondeath( ply , attacker , dmg )

		ClearTable()

		for i=1,20 do
			if !DEATHNOTICE.Attackers[CurTime()+i/100] then 
				DEATHNOTICE.Attackers[CurTime()+i/100] = attacker
			break
			end
		end

		for i=1,20 do
			if !DEATHNOTICE.Victims[CurTime()+i/100] then 
				DEATHNOTICE.Victims[CurTime()+i/100] = ply
			break
			end
		end

		for i=1,20 do
			if !DEATHNOTICE.Weapons[CurTime()+i/100] then 
				DEATHNOTICE.Weapons[CurTime()+i/100] = dmg
			break
			end
		end
	
	
	i = 0
	for k,v in pairs(DEATHNOTICE.Attackers) do
		if CurTime() - 10 < k then
			i = i + 1


			if !CURRENTDEATH.attacker[k] then
				CURRENTDEATH.attacker[k] = tostring( DEATHNOTICE.Attackers[k] )

				if DEATHNOTICE.Attackers[k]:IsPlayer() then
					CURRENTDEATH.attacker[k] = tostring( DEATHNOTICE.Attackers[k]:Name() )
				elseif DEATHNOTICE.Attackers[k]:IsNPC() then
					CURRENTDEATH.attacker[k] = tostring( DEATHNOTICE.Attackers[k]:GetClass() )
				elseif IsValid( CURRENTDEATH.attacker[k]:GetOwner() ) then
					CURRENTDEATH.attacker[k] = DEATHNOTICE.Attackers[k]:GetOwner()
				end

			end

			if !CURRENTDEATH.victim[k] then
				CURRENTDEATH.victim[k] = tostring( DEATHNOTICE.Victims[k] )

				if DEATHNOTICE.Victims[k]:IsPlayer() then
					CURRENTDEATH.victim[k] = tostring( DEATHNOTICE.Victims[k]:Name() )
				end

			end

			if !CURRENTDEATH.attacker[k] then
				if dmg:GetDamageType() == 1 then
					CURRENTDEATH.attacker[k] = "Prop"
				end

				if dmg:GetDamageType() == 32 then
					CURRENTDEATH.attacker[k] = "Fall Damage"
				end

				if dmg:GetDamageType() == 4 then
					CURRENTDEATH.attacker[k] = tostring( DEATHNOTICE.Attackers[k]:GetClass() )
				end

				if dmg:GetDamageType() == 6144 then
					CURRENTDEATH.attacker[k] = "Suicide"
				end
			end

			if CURRENTDEATH.attacker[k] == CURRENTDEATH.victim[k] then
				CURRENTDEATH.attacker[k] = ""
			end
		end
	end

	util.AddNetworkString( "DEATHNOTICE" )
	net.Start( "DEATHNOTICE" , true)
	net.WriteTable( CURRENTDEATH )
	net.Broadcast()
	
end

function OnNPCdeath( ply , attacker )

		ClearTable()
		
		for i=1,20 do
			if !DEATHNOTICE.Attackers[CurTime()+i/100] then 
				DEATHNOTICE.Attackers[CurTime()+i/100] = attacker
			break
			end
		end

		for i=1,20 do
			if !DEATHNOTICE.Victims[CurTime()+i/100] then 
				DEATHNOTICE.Victims[CurTime()+i/100] = ply
			break
			end
		end

		for i=1,20 do
			if !DEATHNOTICE.Weapons[CurTime()+i/100] then 
				DEATHNOTICE.Weapons[CurTime()+i/100] = dmg
			break
			end
		end
	
	i = 0
	for k,v in pairs(DEATHNOTICE.Attackers) do
		if CurTime() - 10 < k then
			i = i + 1

			if !CURRENTDEATH.attacker[k] then
				CURRENTDEATH.attacker[k] = tostring( DEATHNOTICE.Attackers[k] )

				if DEATHNOTICE.Attackers[k]:IsPlayer() then
					CURRENTDEATH.attacker[k] = tostring( DEATHNOTICE.Attackers[k]:Name() )
				end

				if DEATHNOTICE.Attackers[k]:IsNPC() then
					CURRENTDEATH.attacker[k] = tostring( DEATHNOTICE.Attackers[k]:GetClass() )
					if CURRENTDEATH.attacker[k] == "[NULL NPC]" then
						CURRENTDEATH.attacker[k] = "NPC"
					end
				end
			end

			if !CURRENTDEATH.victim[k] then
				CURRENTDEATH.victim[k] = "NPC"
				if DEATHNOTICE.Victims[k]:IsValid() then
					CURRENTDEATH.victim[k] = tostring( DEATHNOTICE.Victims[k]:GetClass() )
				end
					
				if CURRENTDEATH.victim[k] == "[NULL NPC]" then
					CURRENTDEATH.victim[k] = "NPC"
				end

			end
		end
	end


	util.AddNetworkString( "DEATHNOTICE" )
	net.Start( "DEATHNOTICE" , true)
	net.WriteTable( CURRENTDEATH )
	net.Broadcast()
	
end

hook.Add("DoPlayerDeath","DEATHNOTICE_PLAYER",Ondeath)

hook.Add("OnNPCKilled","DEATHNOTICE_NPC",OnNPCdeath)

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

	function GAMEMODE:AddDeathNotice() return end	

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
		 hook.Add("HUDPaint","DEATHNOTICE" , DrawShaarDeathNotice)
	end )


end

