DEFINE_BASECLASS( "stick_base" )

SWEP.PrintName = "Better Arrest Baton"
SWEP.Author = "TheAsian EggrollMaker"
SWEP.Contact = "theasianeggrollmaker@gmail.com"
SWEP.Purpose = "To arrest suspects."
SWEP.Instructions = "Left Click: Arrest suspect.\nRight Click: Switch batons."

SWEP.Category = "Eggroll's Police System"
SWEP.Slot = 1
SWEP.SlotPos = 3

SWEP.Spawnable = true

SWEP.IsDarkRPArrestStick = true -- For compatibility with the regular arrest baton.
SWEP.StickColor = Color( 255, 0, 0 )
SWEP.Switched = true -- Used to switch between arrest and unarrest baton.

function SWEP:Deploy( )
	if not IsFirstTimePredicted( ) then return end
	self.Switched = true

	return BaseClass.Deploy( self )
end

function SWEP:startDarkRPCommand( usrcmd ) -- Create compatibility with unarrest baton. -- Can't use WEAPON.SecondaryAttack because usrcmd.SelectWeapon runs in prediction while Player.SelectWeapon runs outside of prediction.
	if not IsFirstTimePredicted( ) then return end

	if usrcmd:KeyDown( IN_ATTACK2 ) then
		if not self.Switched and self:GetOwner( ):HasWeapon( "unarrest_stick" ) then
			usrcmd:SelectWeapon( self:GetOwner( ):GetWeapon( "unarrest_stick" ) )
		end
	else
		self.Switched = false
	end
end

hook.Add( "WeaponEquip", "EPS_OverwriteUnarrestBatonSwitching", function( wep, ply )
	if wep:GetClass( ) ~= "unarrest_stick" then return end

	wep.startDarkRPCommand = function( _, usrcmd )
		if not IsFirstTimePredicted( ) then return end

		if usrcmd:KeyDown( IN_ATTACK2 ) then
			if not wep.Switched and ply:HasWeapon( "eps_better_arrest_baton" ) then
				usrcmd:SelectWeapon( ply:GetWeapon( "eps_better_arrest_baton" ) )
			end
		else
			wep.Switched = false
		end
	end
end )
