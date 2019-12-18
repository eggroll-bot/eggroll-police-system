local PANEL = { }

function PANEL:Init( )
	self:SetFont( "DermaLarge" )
	self:SetTextWithSize( "Label" )
end

function PANEL:UpdateColours( )
	if self.Hovered	then
		return self:SetTextStyleColor( Color( 27, 190, 249 ) )
	end

	return self:SetTextStyleColor( Color( 3, 99, 134 ) )
end

function PANEL:Paint( w, h )
end

function PANEL:SetTextWithSize( txt )
	self:SetText( txt )
	self:SizeToContents( )
end

vgui.Register( "EPS_Button", PANEL, "DButton" )

PANEL = { }

function PANEL:Init( )
	self:SetPos( 0, 0 )
	self:SetImage( "icon16/application_xp.png" )
	self:SetSize( 32, 32 )
	self.Button = vgui.Create( "DButton", self )
	self.Button:SetPos( 0, 0 )
	self.Button:SetSize( 32, 32 )
	self.Button:SetText( "" )

	self.Button.Paint = function( )
	end

	self.Text = vgui.Create( "DLabel", self )
	self.Text:SetFont( "Default" )
	self.Text:SetText( "Program" )
	self.Text:SetTextColor( Color( 200, 200, 200 ) )
	self.Text:SizeToContents( )
	self.Text:SetPos( 0, 31 )
	self.Text:CenterHorizontal( 0.5 )
end

function PANEL:SetText( text )
	self.Text:SetText( text )
	self.Text:SizeToContents( )
	self.Text:SetPos( 0, 31 )
	self.Text:CenterHorizontal( 0.5 )
end

function PANEL:SetIcon( icon )
	self:SetImage( icon )
	self:SetSize( 32, 32 )
end

vgui.Register( "EPS_DesktopIcon", PANEL, "DImage" )

PANEL = { }

function PANEL:Init( )
	self.TitleBar = vgui.Create( "DPanel", self )
	self.TitleBar:SetPos( 0, 0 )

	self.TitleBar.Paint = function( _, w, h )
		surface.SetDrawColor( 3, 37, 64 )
		surface.DrawRect( 0, 0, w, h )
	end

	self.TitleBarIcon = vgui.Create( "DImage", self.TitleBar )
	self.TitleBarIcon:SetSize( 16, 16 )
	self.TitleBarIcon:SetImage( "icon16/application_xp.png" )
	self.TitleBarIcon:CenterHorizontal( 0.25 )
	self.TitleBarIcon:CenterVertical( 0.4 )

	self.TitleBarTitle = vgui.Create( "DLabel", self.TitleBar )
	self.TitleBarTitle:SetFont( "Default" )
	self.TitleBarTitle:SetText( "Program" )
	self.TitleBarTitle:SetTextColor( Color( 200, 200, 200 ) )
	self.TitleBarTitle:SizeToContents( )
	self.TitleBarTitle:CenterHorizontal( 0.85 )
	self.TitleBarTitle:CenterVertical( 0.4 )

	self.TitleBarCloseImg = vgui.Create( "DImage", self.TitleBar )
	self.TitleBarCloseImg:SetSize( 16, 16 )
	self.TitleBarCloseImg:SetImage( "icon16/cancel.png" )
	self.TitleBarCloseImg:CenterHorizontal( 7.45 )
	self.TitleBarCloseImg:CenterVertical( 0.4 )

	self.TitleBarCloseBtn = vgui.Create( "DButton", self.TitleBarCloseImg )
	self.TitleBarCloseBtn:SetPos( 0, 0 )
	self.TitleBarCloseBtn:SetSize( 16, 16 )
	self.TitleBarCloseBtn:SetText( "" )

	self.TitleBarCloseBtn.Paint = function( )
	end

	self.TitleBarCloseBtn.DoClick = function( )
		self:CloseProgram( )
	end
end

function PANEL:SetWindowSize( w, h )
	self:SetSize( w, h )
	self.TitleBar:SetSize( w, h * 0.05 )
end

function PANEL:Paint( w, h )
	local color = self.WindowBackgroundColor or Color( 200, 200, 200 )
	surface.SetDrawColor( color )
	surface.DrawRect( 0, 0, w, h )
end

vgui.Register( "EPS_ProgramFrame", PANEL, "DPanel" )
