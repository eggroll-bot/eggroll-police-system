local PROGRAM = { }
PROGRAM.Name = "AFIS"
PROGRAM.Icon = "icon16/bug.png"
PROGRAM.IconPosition = { 40, 80 }

function PROGRAM:AwaitFingerprint( )
	self.AwaitingFingerprintText = vgui.Create( "DLabel", self.ProgramFrame )
	self.AwaitingFingerprintText:SetFont( "EPSLabelFont" )
	self.AwaitingFingerprintText:SetTextColor( Color( 200, 200, 200 ) )
	self.AwaitingFingerprintText:SetText( "Waiting for a fingerprint scan..." )
	self.AwaitingFingerprintText:SizeToContents( )
	self.AwaitingFingerprintText:CenterHorizontal( 0.5 )
	self.AwaitingFingerprintText:CenterVertical( 0.5 )
end

function PROGRAM:Init( )
	self.ProgramFrame.WindowBackgroundColor = Color( 20, 20, 20 )
	self:AwaitFingerprint( )
end

net.Receive( "EPS_FoundFingerprintMatch", function( )
	local target = net.ReadEntity( )
	local computer = net.ReadEntity( )
	local records_lookup = computer.Programs[ "Record Lookup" ]

	if IsValid( computer.ComputerScreen.OpenProgram ) then
		computer.ComputerScreen.OpenProgram:CloseProgram( )
	end

	computer:OpenProgram( records_lookup )
	records_lookup:HideMainMenu( )
	net.Start( "EPS_RetrievePersonalRecords" )
	net.WriteEntity( computer )
	net.WriteEntity( target )
	net.SendToServer( )
end )

EggrollPoliceSystem:RegisterProgram( PROGRAM.Name, PROGRAM )
