util.AddNetworkString( "EPS_FoundFingerprintMatch" )

local PROGRAM = { }
PROGRAM.Name = "AFIS"

function PROGRAM:Init( user, computer )
	self.Computer = computer

	self.Computer.FingerprintScan = function( _, target )
		net.Start( "EPS_FoundFingerprintMatch" )
		net.WriteEntity( target )
		net.WriteEntity( self.Computer )
		net.Send( user )
	end
end

function PROGRAM:Close( )
	self.Computer.FingerprintScan = nil
end

EggrollPoliceSystem:RegisterProgram( PROGRAM.Name, PROGRAM )
