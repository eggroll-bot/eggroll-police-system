include( "shared.lua" )

DEFINE_BASECLASS( "stick_base" )
local arrest_frame

local function CreateArrestGUI( )
	arrest_frame = vgui.Create( "DFrame" )
	arrest_frame:SetSize( 500, 105 )
	arrest_frame:Center( )
	arrest_frame:SetTitle( "Arrest Customizer" )
	arrest_frame:SetVisible( true )
	arrest_frame:SetDraggable( true )
	arrest_frame:ShowCloseButton( true )
	arrest_frame:MakePopup( )

	arrest_frame.Paint = function( _, w, h )
		draw.RoundedBox( 8, 0, 0, w, h, Color( 200, 200, 200 ) )
	end

	arrest_frame.OnClose = function( )
		net.Start( "EPS_OpenArrestGUI" )
		net.WriteBool( false )
		net.SendToServer( )
	end

	local arrest_slider = vgui.Create( "DNumSlider", arrest_frame )
	arrest_slider:Dock( TOP )
	arrest_slider:DockMargin( 20, 5, 20, 0 )
	arrest_slider:SetDark( true )
	arrest_slider:SetText( "Arrest Time" )
	arrest_slider:SetMin( EggrollPoliceSystem.Config.ArrestBatonMinArrestTime )
	arrest_slider:SetMax( EggrollPoliceSystem.Config.ArrestBatonMaxArrestTime )
	arrest_slider:SetDecimals( 0 )
	arrest_slider:SetValue( EggrollPoliceSystem.Config.ArrestBatonMinArrestTime )

	local arrest_button = vgui.Create( "DButton", arrest_frame )
	arrest_button:Dock( TOP )
	arrest_button:DockMargin( 20, 5, 20, 0 )
	arrest_button:SetTextColor( Color( 0, 0, 0 ) )
	arrest_button:SetText( "Arrest" )

	arrest_button.Paint = function( _, w, h )
		draw.RoundedBox( 8, 0, 0, w, h, Color( 100, 100, 100 ) )
	end

	arrest_button.DoClick = function( )
		net.Start( "EPS_OpenArrestGUI" )
		net.WriteBool( true )
		net.WriteUInt( arrest_slider:GetValue( ), 16 )
		net.SendToServer( )
		arrest_frame:Remove( )
	end
end

function SWEP:PrimaryAttack( )
	if not IsFirstTimePredicted( ) then return end
	if self.Cooldown and self.Cooldown > CurTime( ) then return end
	self.Cooldown = CurTime( ) + EggrollPoliceSystem.Config.ArrestBatonCooldown
	BaseClass.PrimaryAttack( self )
end

net.Receive( "EPS_OpenArrestGUI", function( )
	local to_open = net.ReadBool( )

	if to_open then
		CreateArrestGUI( )
	else
		arrest_frame:Remove( )
	end
end )
