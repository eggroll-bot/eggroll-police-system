AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( "shared.lua" )
util.AddNetworkString( "EPS_LoginToPoliceComputer" )
util.AddNetworkString( "EPS_OpenProgram" )
util.AddNetworkString( "EPS_CloseProgram" )

function ENT:Initialize( )
	self.Programs = table.Copy( EggrollPoliceSystem.Programs )
	self:SetModel( "models/props_lab/monitor01a.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
end

function ENT:SpawnFunction( _, tr )
	local spawnPos = tr.HitPos + tr.HitNormal * 16
	local ent = ents.Create( "eps_police_computer" )
	ent:SetPos( spawnPos )
	ent:Spawn( )
	ent:Activate( )

	return ent
end

function ENT:Login( ply )
	self:SetActiveUser( ply )

	timer.Create( "EPS_Police_Computer_Logout_Distance_" .. self:EntIndex( ), 0.5, 0, function( )
		local max_dist_squared = EggrollPoliceSystem.Config.DistanceBeforePoliceComputerLogout ^ 2

		if self.GetActiveUser and self:GetActiveUser( ):GetPos( ):DistToSqr( self:GetPos( ) ) > max_dist_squared then -- Check if GetActiveUser exists because of data table variable delays.
			net.Start( "EPS_LoginToPoliceComputer" ) -- Log out on client.
			net.WriteEntity( self )
			net.Send( self:GetActiveUser( ) )
			self:Logout( )
		end
	end )

	hook.Add( "PlayerDisconnected", "EPS_Police_Computer_Logout_Disconnect_" .. self:EntIndex( ), function( disconnected )
		if disconnected == self:GetActiveUser( ) then
			net.Start( "EPS_LoginToPoliceComputer" ) -- Log out on client.
			net.WriteEntity( self )
			net.Send( self:GetActiveUser( ) )
			self:Logout( )
		end
	end )

	hook.Add( "OnPlayerChangedTeam", "EPS_Police_Computer_Logout_Job_Switch_" .. self:EntIndex( ), function( job_switcher, _, after ) -- Will log out anyone who isn't a cop and has the config option set to false.
		if job_switcher == self:GetActiveUser( ) and not EggrollPoliceSystem.Config.CanNonCopAccessPoliceComputer and not GAMEMODE.CivilProtection[ after ] then
			net.Start( "EPS_LoginToPoliceComputer" ) -- Log out on client.
			net.WriteEntity( self )
			net.Send( self:GetActiveUser( ) )
			self:Logout( )
		end
	end )
end

function ENT:Logout( )
	timer.Remove( "EPS_Police_Computer_Logout_Distance_" .. self:EntIndex( ) )
	hook.Remove( "PlayerDisconnected", "EPS_Police_Computer_Logout_Disconnect_" .. self:EntIndex( ) )
	hook.Remove( "OnPlayerChangedTeam", "EPS_Police_Computer_Logout_Job_Switch_" .. self:EntIndex( ) )
	self:SetActiveUser( nil )
end

net.Receive( "EPS_LoginToPoliceComputer", function( _, ply )
	local computer = net.ReadEntity( )
	local login = net.ReadBool( )

	if ply:GetEyeTraceNoCursor( ).Entity ~= computer or ( not EggrollPoliceSystem.Config.CanNonCopAccessPoliceComputer and not ply:isCP( ) ) then
		return
	end

	if login and not IsValid( computer:GetActiveUser( ) ) then
		computer:Login( ply )
	elseif not login and computer:GetActiveUser( ) == ply then
		computer:Logout( )
	end
end )

net.Receive( "EPS_OpenProgram", function( _, ply )
	local computer = net.ReadEntity( )

	if computer:GetActiveUser( ) ~= ply then
		return
	end

	local program_name = net.ReadString( )
	local program = computer.Programs[ program_name ]

	if program and program.Init then
		program:Init( ply, computer )
	end
end )

net.Receive( "EPS_CloseProgram", function( _, ply )
	local computer = net.ReadEntity( )

	if computer:GetActiveUser( ) ~= ply then
		return
	end

	local program_name = net.ReadString( )
	local program = computer.Programs[ program_name ]

	if program and program.Close then
		program:Close( )
	end
end )
