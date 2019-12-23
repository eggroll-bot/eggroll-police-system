AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( "shared.lua" )

function SWEP:Fail( ) -- Fail in handcuffing.
	self.Target = nil
	self:SetNWInt( "FinishHandcuffingTime", 0 )
end

function SWEP:Success( ) -- Succeed in handcuffing.
	self.Target:Give( "eps_handcuffed" )
	self.Target = nil
	self:SetNWInt( "FinishHandcuffingTime", 0 )
end

function SWEP:PrimaryAttack( )
	if not IsFirstTimePredicted( ) then return end
	local ply = self:GetOwner( )
	local trace = ply:GetEyeTrace( )
	local target = trace.Entity
	local handcuff_range_squared = EggrollPoliceSystem.Config.MaxHandcuffDistance ^ 2
	if not IsValid( target ) or not target:IsPlayer( ) or not target:Alive( ) or not target:IsSolid( ) or ply:EyePos( ):DistToSqr( target:GetPos( ) ) > handcuff_range_squared then return end

	if target:GetNWBool( "EPS_Handcuffed" ) then
		ply:ChatPrint( "This person is already handcuffed." )

		return
	end

	self.Target = target
	self:SetNWInt( "FinishHandcuffingTime", CurTime( ) + EggrollPoliceSystem.Config.TimeToHandcuff )
end

function SWEP:SecondaryAttack( )
	if not IsFirstTimePredicted( ) then return end
	local ply = self:GetOwner( )

	if self.Target then
		self:Fail( )
	end

	local trace = ply:GetEyeTrace( )
	local target = trace.Entity
	local unhandcuff_range_squared = EggrollPoliceSystem.Config.MaxHandcuffDistance ^ 2
	if not IsValid( target ) or not target:IsPlayer( ) or not target:Alive( ) or ply:EyePos( ):DistToSqr( target:GetPos( ) ) > unhandcuff_range_squared then return end

	if not target:GetNWBool( "EPS_Handcuffed" ) then
		ply:ChatPrint( "This person is not handcuffed." )

		return
	end

	target:GetWeapon( "eps_handcuffed" ):Remove( )
end

function SWEP:Think( )
	if not self.Target then -- Not handcuffing anyone.
		return
	end

	if self.Target and not IsValid( self.Target ) then -- Target no longer exists, most likely because they disconnected or crashed.
		self:Fail( )

		return
	end

	local ply = self:GetOwner( )
	local trace = ply:GetEyeTrace( )
	local target = trace.Entity

	if target ~= self.Target then -- The player is no longer looking at the target.
		self:Fail( )

		return
	end

	local handcuff_range_squared = EggrollPoliceSystem.Config.MaxHandcuffDistance ^ 2

	if not target:GetNWBool( "EPS_Handcuffed" ) and ply:EyePos( ):DistToSqr( target:GetPos( ) ) <= handcuff_range_squared then
		if CurTime( ) >= self:GetNWInt( "FinishHandcuffingTime" ) then
			self:Success( )
		end
	else -- Fail if the player is already handcuffed or the distance between the player and the target is too large.
		self:Fail( )
	end
end

function SWEP:Holster( )
	if self.Target then
		self:Fail( )
	end

	return true
end

function SWEP:OnRemove( )
	if self.Target then
		self:Fail( )
	end
end
