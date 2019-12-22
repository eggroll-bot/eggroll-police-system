SWEP.PrintName = "Handcuffs"
SWEP.Author = "TheAsian EggrollMaker"
SWEP.Contact = "theasianeggrollmaker@gmail.com"

SWEP.Base = "weapon_base"

SWEP.UseHands = true

SWEP.Slot = 0
SWEP.SlotPos = 0

SWEP.Spawnable = false

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Ammo = "none"

SWEP.DrawAmmo = false

function SWEP:Initialize( )
	self:SetHoldType( "passive" ) -- This holdtype doesn't have arm walking animations.
end

function SWEP:Deploy( )
	local ply = self:GetOwner( )
	ply.EPS_Handcuffed = true
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

function SWEP:Holster( )
	if self:GetOwner( ).EPS_Handcuffed then -- No holstering if handcuffed.
		return false
	end
end

function SWEP:FreeHandcuffs( ) -- Needs to be called shared. After being called in both the client and the server realm, you should remove the weapon with WEAPON:Remove( ).
	local ply = self:GetOwner( )
	ply.EPS_Handcuffed = nil
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

hook.Add( "StartCommand", "EPS_CrouchingJumpingWhileHandcuffed", function( ply, usr_cmd )
	if ply.EPS_Handcuffed then -- No jumping or crouching while handcuffed.
		if usr_cmd:KeyDown( IN_JUMP ) then
			usr_cmd:RemoveKey( IN_JUMP )
		end

		if usr_cmd:KeyDown( IN_DUCK ) then
			usr_cmd:RemoveKey( IN_DUCK )
		end
	end
end )
