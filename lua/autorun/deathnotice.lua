

include("autorun/client/cl_deathnotice_init.lua")

if SERVER then

	local i

	local function Addlua()
		AddCSLuaFile("autorun/client/cl_deathnotice_init.lua")
	end
	
	Addlua()

	DEATHNOTICE = {}
	DEATHNOTICE.Attackers = {}
	DEATHNOTICE.Victims = {}
	DEATHNOTICE.Weapons = {}
	CURRENTDEATH = {}
	CURRENTDEATH.attacker = {}
	CURRENTDEATH.victim = {}
	CURRENTDEATH.weapon = {}



	

local function ClearTable()
	
	if table.Count( CURRENTDEATH.attacker ) > 50 then
		CURRENTDEATH.attacker = {}
		CURRENTDEATH.victim = {}
		CURRENTDEATH.weapon = {}
	end
end



local function OnNPCdeath( ply , attacker )

		ClearTable()
		
		for i=1,20 do
			if !DEATHNOTICE.Attackers[CurTime()+i/1000] then 
				DEATHNOTICE.Attackers[CurTime()+i/1000] = attacker
			break
			end
		end

		for i=1,20 do
			if !DEATHNOTICE.Victims[CurTime()+i/1000] then 
				DEATHNOTICE.Victims[CurTime()+i/1000] = ply
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

local function Ondeath( ply , attacker , dmg )

		ClearTable()

		for i=1,20 do
			if !DEATHNOTICE.Attackers[CurTime()+i/1000] then 
				DEATHNOTICE.Attackers[CurTime()+i/1000] = attacker
			break
			end
		end

		for i=1,20 do
			if !DEATHNOTICE.Victims[CurTime()+i/1000] then 
				DEATHNOTICE.Victims[CurTime()+i/1000] = ply
			break
			end
		end

		for i=1,20 do
			if !DEATHNOTICE.Weapons[CurTime()+i/1000] then 
				DEATHNOTICE.Weapons[CurTime()+i/1000] = dmg
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
				elseif DEATHNOTICE.Attackers[k]:GetOwner():IsPlayer() then
					CURRENTDEATH.attacker[k] = DEATHNOTICE.Attackers[k]:GetOwner():Name()
				else
					CURRENTDEATH.attacker[k] = "World"
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



hook.Add("DoPlayerDeath","DEATHNOTICE_PLAYER",Ondeath)

hook.Add("OnNPCKilled","DEATHNOTICE_NPC",OnNPCdeath)

end
