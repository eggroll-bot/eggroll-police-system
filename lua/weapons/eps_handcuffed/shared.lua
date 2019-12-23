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

function SWEP:Holster( ) -- Shared due to prediction.
	if self:GetOwner( ):GetNWBool( "EPS_Handcuffed" ) then -- No holstering if handcuffed.
		return false
	end
end

hook.Add( "StartCommand", "EPS_CrouchingJumpingWhileHandcuffed", function( ply, usr_cmd ) -- Shared due to prediction.
	if ply:GetNWBool( "EPS_Handcuffed" ) then -- No jumping or crouching while handcuffed.
		if usr_cmd:KeyDown( IN_JUMP ) then
			usr_cmd:RemoveKey( IN_JUMP )
		end

		if usr_cmd:KeyDown( IN_DUCK ) then
			usr_cmd:RemoveKey( IN_DUCK )
		end
	end
end )
