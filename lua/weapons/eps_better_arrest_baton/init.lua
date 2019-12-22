AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( "shared.lua" )

DEFINE_BASECLASS( "stick_base" )

util.AddNetworkString( "EPS_OpenArrestGUI" )

local function StopArresting( target )
	target.Arrester = nil

	if not target.frozen and target:IsFrozen( ) then -- Player.frozen is set by ULX when freezing through ULX and we don't want to unfreeze a ULX frozen person.
		target:Freeze( false )
	end
end

local function Arrest( arrester, target, time )
	target:arrest( time, arrester )
	DarkRP.notify( target, 0, 20, DarkRP.getPhrase( "youre_arrested_by", arrester:Nick( ) ) )

	if arrester.SteamName then
		DarkRP.log( arrester:Nick( ) .. " (" .. arrester:SteamID( ) .. ") arrested " .. target:Nick( ) .. " for " .. time .. " seconds", Color( 0, 255, 255 ) )
	end
end

function SWEP:PromptArrest( ply, target )
	ply:Freeze( true ) -- Freeze the arrester too. If the client decides to remove the clientside WEAPON.PrimaryAttack functionality using clientside Lua execution, the player gets frozen, so they can't go running around freezing people without closing the GUI first.
	target:Freeze( true ) -- Bots can still turn their heads with this.
	ply.Arrestee = target
	target.Arrester = self:GetOwner( )
	net.Start( "EPS_OpenArrestGUI" )
	net.WriteBool( true )
	net.Send( ply )
	target:ChatPrint( "You are being arrested by " .. ply:Name( ) .. "..." )

	timer.Create( "EPS_ArrestBatonGUITimeout_" .. ply:UserID( ), EggrollPoliceSystem.Config.ArrestBatonGUITimeout, 1, function( )
		if IsValid( ply ) then
			if not ply.frozen and ply:IsFrozen( ) then -- Make sure they're not frozen by ULX.
				ply:Freeze( false )
			end

			ply.Arrestee = nil
			net.Start( "EPS_OpenArrestGUI" )
			net.WriteBool( false )
			net.Send( ply )
			ply:ChatPrint( "You took too long to arrest the player. Closing the arrest customizer..." )
		end

		if IsValid( target ) then
			StopArresting( target )
		end
	end )
end

function SWEP:PrimaryAttack( )
	if not IsFirstTimePredicted( ) then return end
	if self.Cooldown and self.Cooldown > CurTime( ) then return end
	self.Cooldown = CurTime( ) + EggrollPoliceSystem.Config.ArrestBatonCooldown
	BaseClass.PrimaryAttack( self )
	self:GetOwner( ):LagCompensation( true )
	local trace = util.QuickTrace( self:GetOwner( ):EyePos( ), self:GetOwner( ):GetAimVector( ) * 90, { self:GetOwner( ) } )
	self:GetOwner( ):LagCompensation( false )
	local target = trace.Entity

	if IsValid( target ) and target.onArrestStickUsed then -- For DarkRP compatibility.
		target:onArrestStickUsed( self:GetOwner( ) )

		return
	end

	target = self:GetOwner( ):getEyeSightHitEntity( nil, nil, function( ply ) return ply ~= self:GetOwner( ) and ply:IsPlayer( ) and ply:Alive( ) and ply:IsSolid( ) end )
	local stickRange = self.stickRange ^ 2
	if not IsValid( target ) or self:GetOwner( ):EyePos( ):DistToSqr( target:GetPos( ) ) > stickRange or not target:IsPlayer( ) then return end

	if IsValid( target.Arrester ) then
		self:GetOwner( ):ChatPrint( "This person is already being arrested by someone else." )
	end

	local canArrest, message = hook.Call( "canArrest", DarkRP.hooks, self:GetOwner( ), target )

	if not canArrest then
		if message then
			DarkRP.notify( self:GetOwner( ), 1, 5, message )
		end

		return
	end

	self:PromptArrest( self:GetOwner( ), target )
end

net.Receive( "EPS_OpenArrestGUI", function( _, ply ) -- Receives a Bool, UInt16 - whether the target should be arrested, seconds that should be arrested (only exists if target should be arrested).
	local target = ply.Arrestee
	if not IsValid( target ) then return end

	if not ply.frozen and ply:IsFrozen( ) then -- Make sure they're not frozen by ULX.
		ply:Freeze( false )
	end

	timer.Remove( "EPS_ArrestBatonGUITimeout_" .. ply:UserID( ) )
	local should_arrest = net.ReadBool( )
	StopArresting( target )

	if should_arrest then
		local time = net.ReadUInt( 16 )
		Arrest( ply, target, time )
	end

	ply.Arrestee = nil
end )

hook.Add( "PlayerDisconnected", "EPS_ArrestBatonHandleDisconnect", function( ply )
	if IsValid( ply.Arrester ) then -- If ply has an arrester, ply is an arrestee.
		if not ply.Arrester.frozen and ply.Arrester:IsFrozen( ) then -- Make sure they're not frozen by ULX.
			ply.Arrester:Freeze( false )
		end

		timer.Remove( "EPS_ArrestBatonGUITimeout_" .. ply.Arrester:UserID( ) )
		net.Start( "EPS_OpenArrestGUI" )
		net.WriteBool( false )
		net.Send( ply.Arrester )
		ply.Arrester.Arrestee = nil
	elseif IsValid( ply.Arrestee ) then -- If ply has an arrestee, ply is an arrester.
		StopArresting( ply.Arrestee )
		ply.Arrestee.Arrester = nil
	end
end )
