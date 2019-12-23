AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( "shared.lua" )

function SWEP:Equip( ply )
	ply:SelectWeapon( self:GetClass( ) )
	self:StartHandcuffing( )
end

function SWEP:StartHandcuffing( )
	local ply = self:GetOwner( )
	ply:SetNWBool( "EPS_Handcuffed", true )
	ply:ManipulateBoneAngles( ply:LookupBone( "ValveBiped.Bip01_L_UpperArm" ), Angle( 20, 18.8, 0 ) )
	ply:ManipulateBoneAngles( ply:LookupBone( "ValveBiped.Bip01_L_Forearm" ), Angle( 32, 50, 10 ) )
	ply:ManipulateBoneAngles( ply:LookupBone( "ValveBiped.Bip01_L_Hand" ), Angle( 0, 0, 165 ) )
	ply:ManipulateBoneAngles( ply:LookupBone( "ValveBiped.Bip01_L_Finger0" ), Angle( -10, 10, 0 ) )
	ply:ManipulateBoneAngles( ply:LookupBone( "ValveBiped.Bip01_L_Finger01" ), Angle( 0, 30, 0 ) )
	ply:ManipulateBoneAngles( ply:LookupBone( "ValveBiped.Bip01_L_Finger1" ), Angle( 5, 90, 5 ) )
	ply:ManipulateBoneAngles( ply:LookupBone( "ValveBiped.Bip01_L_Finger11" ), Angle( 0, 40, 0 ) )
	ply:ManipulateBoneAngles( ply:LookupBone( "ValveBiped.Bip01_L_Finger2" ), Angle( -10, 90, 0 ) )
	ply:ManipulateBoneAngles( ply:LookupBone( "ValveBiped.Bip01_L_Finger21" ), Angle( 0, 40, 0 ) )
	ply:ManipulateBoneAngles( ply:LookupBone( "ValveBiped.Bip01_R_UpperArm" ), Angle( -20, 6.6, 30 ) )
	ply:ManipulateBoneAngles( ply:LookupBone( "ValveBiped.Bip01_R_Forearm" ), Angle( -30, 90, 0 ) )
	ply:ManipulateBoneAngles( ply:LookupBone( "ValveBiped.Bip01_R_Hand" ), Angle( 10, 0, -80 ) )
	ply:ManipulateBoneAngles( ply:LookupBone( "ValveBiped.Bip01_R_Finger1" ), Angle( -20, 30, 0 ) )
	ply:ManipulateBoneAngles( ply:LookupBone( "ValveBiped.Bip01_R_Finger11" ), Angle( 0, 30, 0 ) )
	ply:ManipulateBoneAngles( ply:LookupBone( "ValveBiped.Bip01_R_Finger2" ), Angle( 0, 30, 0 ) )
	ply:ManipulateBoneAngles( ply:LookupBone( "ValveBiped.Bip01_R_Finger21" ), Angle( 0, 90, 0 ) )
	ply:ManipulateBoneAngles( ply:LookupBone( "ValveBiped.Bip01_R_Finger22" ), Angle( 0, 60, 0 ) )
	ply.EPS_OldWalkSpeed = ply:GetWalkSpeed( )
	ply.EPS_OldRunSpeed = ply:GetRunSpeed( )
	ply:SetWalkSpeed( 120 )
	ply:SetRunSpeed( 120 )
end

function SWEP:FreeHandcuffs( ) -- Do not call this directly.
	local ply = self:GetOwner( )
	ply:SetNWBool( "EPS_Handcuffed", false ) -- nil won't change it on the client for some reason, so we need to use false.
	ply:ManipulateBoneAngles( ply:LookupBone( "ValveBiped.Bip01_L_UpperArm" ), Angle( 0, 0, 0 ) )
	ply:ManipulateBoneAngles( ply:LookupBone( "ValveBiped.Bip01_L_Forearm" ), Angle( 0, 0, 0 ) )
	ply:ManipulateBoneAngles( ply:LookupBone( "ValveBiped.Bip01_L_Hand" ), Angle( 0, 0, 0 ) )
	ply:ManipulateBoneAngles( ply:LookupBone( "ValveBiped.Bip01_L_Finger0" ), Angle( 0, 0, 0 ) )
	ply:ManipulateBoneAngles( ply:LookupBone( "ValveBiped.Bip01_L_Finger01" ), Angle( 0, 0, 0 ) )
	ply:ManipulateBoneAngles( ply:LookupBone( "ValveBiped.Bip01_L_Finger1" ), Angle( 0, 0, 0 ) )
	ply:ManipulateBoneAngles( ply:LookupBone( "ValveBiped.Bip01_L_Finger11" ), Angle( 0, 0, 0 ) )
	ply:ManipulateBoneAngles( ply:LookupBone( "ValveBiped.Bip01_L_Finger2" ), Angle( 0, 0, 0 ) )
	ply:ManipulateBoneAngles( ply:LookupBone( "ValveBiped.Bip01_L_Finger21" ), Angle( 0, 0, 0 ) )
	ply:ManipulateBoneAngles( ply:LookupBone( "ValveBiped.Bip01_R_UpperArm" ), Angle( 0, 0, 0 ) )
	ply:ManipulateBoneAngles( ply:LookupBone( "ValveBiped.Bip01_R_Forearm" ), Angle( 0, 0, 0 ) )
	ply:ManipulateBoneAngles( ply:LookupBone( "ValveBiped.Bip01_R_Hand" ), Angle( 0, 0, 0 ) )
	ply:ManipulateBoneAngles( ply:LookupBone( "ValveBiped.Bip01_R_Finger1" ), Angle( 0, 0, 0 ) )
	ply:ManipulateBoneAngles( ply:LookupBone( "ValveBiped.Bip01_R_Finger11" ), Angle( 0, 0, 0 ) )
	ply:ManipulateBoneAngles( ply:LookupBone( "ValveBiped.Bip01_R_Finger2" ), Angle( 0, 0, 0 ) )
	ply:ManipulateBoneAngles( ply:LookupBone( "ValveBiped.Bip01_R_Finger21" ), Angle( 0, 0, 0 ) )
	ply:ManipulateBoneAngles( ply:LookupBone( "ValveBiped.Bip01_R_Finger22" ), Angle( 0, 0, 0 ) )
	ply:SetWalkSpeed( ply.EPS_OldWalkSpeed )
	ply:SetRunSpeed( ply.EPS_OldRunSpeed )
	ply.EPS_OldWalkSpeed = nil
	ply.EPS_OldRunSpeed = nil
end

function SWEP:OnRemove( ) -- Call WEAPON:Remove( ) to get rid of the handcuffs.
	self:FreeHandcuffs( )
end

hook.Add( "PlayerUse", "EPS_UseWhileHandcuffed", function( ply )
	if not EggrollPoliceSystem.Config.CanUseWhileHandcuffed and ply.EPS_Handcuffed then
		return false
	end
end )
