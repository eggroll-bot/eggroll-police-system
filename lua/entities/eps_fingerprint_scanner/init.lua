AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( "shared.lua" )

function ENT:Initialize( )
	self:SetModel( "models/maxofs2d/button_04.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetUseType( SIMPLE_USE )
	self:SetPoseParameter( "switch", 1 )
end

function ENT:SpawnFunction( _, tr )
	local spawnPos = tr.HitPos + tr.HitNormal * 32
	local ent = ents.Create( "eps_fingerprint_scanner" )
	ent:SetPos( spawnPos )
	ent:Spawn( )
	ent:Activate( )

	return ent
end

function ENT:Use( ply )
	if not IsValid( ply ) or not ply:IsPlayer( ) then
		return
	end

	ply:ChatPrint( "Scanning your fingerprints..." )

	for _, v in pairs( ents.FindInSphere( self:GetPos( ), 100 ) ) do
		if v:GetClass( ) == "eps_police_computer" and v.FingerprintScan then
			v:FingerprintScan( ply )
		end
	end
end
