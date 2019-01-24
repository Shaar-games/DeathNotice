
if CLIENT then

local i
local Mouvement

if !Mouvement then 
	i = 0
	Mouvement = 0
end

surface.CreateFont("DEATHNOTICEFONT", {
    font = "Segoe UI Light",
    size = 28,
    weight = 300
})

	
	
	function DrawShaarDeathNotice()

		local VGA = (ScrW() - 1920)/4

		local VGATEXT = 0

		VGATEXT = ScrW()/(ScrW()/50)

		if (ScrW()/ScrW()) > 1.4 then 
			VGATEXT = 0
		end

		--print(VGATEXT)

		if LocalPlayer():IsValid() then
			function GAMEMODE:DrawDeathNotice() end
		end

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
			Mouvement = math.Approach( Mouvement , 0, 1 + Mouvement/12 )
		end

		for k,v in pairs(DEATHNOTICECLIENT.attacker) do
			if CurTime() - 6 < k then i = i + 1
				local triangle = {
					{ x = ScrW()/1 + 120 - 15 - ScrW()/5 + VGA, y = ScrH()/100 + i*45 - 20 + Mouvement + 10},
					{ x = ScrW()/1 + 120 + 15 - ScrW()/5 + VGA, y = ScrH()/100 + i*45 - 20 + Mouvement},
					{ x = ScrW()/1 + 120 - 15 - ScrW()/5 + VGA, y = ScrH()/100 + i*45 - 20 + Mouvement - 10}
					}

				if CurTime() - 6 < k then
					if v == LocalPlayer():Name() or DEATHNOTICECLIENT.victim[k] == LocalPlayer():Name() then
						draw.RoundedBox( 0, ScrW()/1 - 170 - ScrW()/5 + VGA , ScrH()/100 + i*45 - 40 + Mouvement, 500, 40, Color(200 ,0 ,0 , 200) )
						draw.SimpleText( DEATHNOTICECLIENT.attacker[k], "DEATHNOTICEFONT", ScrW()/1 - ScrW()/3.5 + VGA - VGATEXT, ScrH()/100 + i*45 - 20 + Mouvement, Color( 255, 255, 255 ), 0, 1 )
						draw.SimpleText( DEATHNOTICECLIENT.victim[k], "DEATHNOTICEFONT", ScrW()/1 + 240*2 - ScrW()/3.5 + VGA - VGATEXT, ScrH()/100 + i*45 - 20 + Mouvement, Color( 255, 255, 255 ), 2, 1 )

						surface.SetDrawColor( 0, 0, 0, 255 )
						surface.DrawPoly( triangle )
					else
						draw.RoundedBox( 0, ScrW()/1 - 170 - ScrW()/5 + VGA , ScrH()/100 + i*45 - 40 + Mouvement, 500, 40, Color(0 ,0 ,0 , 100) )
						draw.SimpleText( DEATHNOTICECLIENT.attacker[k], "DEATHNOTICEFONT", ScrW()/1 - ScrW()/3.5 + VGA - VGATEXT, ScrH()/100 + i*45 - 20 + Mouvement, Color( 255, 255, 255 ), 0, 1 )
						draw.SimpleText( DEATHNOTICECLIENT.victim[k], "DEATHNOTICEFONT", ScrW()/1 + 240*2 - ScrW()/3.5 + VGA - VGATEXT, ScrH()/100 + i*45 - 20 + Mouvement, Color( 255, 255, 255 ), 2, 1 )

						surface.SetDrawColor( 255, 255, 255, 255 )
						surface.DrawPoly( triangle )
					end
				end
			end
		end
		--if i == 0 then Mouvement = 0 end
	end

	net.Receive( "DEATHNOTICE", function( len, ply )
		DEATHNOTICECLIENT = net.ReadTable()
		--PrintTable(DEATHNOTICECLIENT)
		hook.Add("HUDPaint","DEATHNOTICE" , DrawShaarDeathNotice)
	end )


end