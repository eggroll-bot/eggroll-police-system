AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( "shared.lua" )

function SWEP:OwnerChanged( )
	if IsValid( self:GetOwner( ) ) then -- Make sure it was picked up and not dropped.
		self:GetOwner( ):SelectWeapon( self:GetClass( ) )
	end
end

hook.Add( "PlayerUse", "EPS_UseWhileHandcuffed", function( ply )
	if not EggrollPoliceSystem.Config.CanUseWhileHandcuffed and ply.EPS_Handcuffed then
		return false
	end
end )
