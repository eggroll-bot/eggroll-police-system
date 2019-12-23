require( "3d2dvgui" )
include( "shared.lua" )

-- Computer Screen Panel -- BEGIN

function ENT:CreateComputerScreen( )
	self.ComputerScreen = vgui.Create( "DPanel" )
	self.ComputerScreen:SetPos( 0, 0 )
	self.ComputerScreen:SetSize( 489, 401 )

	self.ComputerScreen.Paint = function( _, w, h )
		surface.SetDrawColor( 3, 1, 41 )
		surface.DrawRect( 0, 0, w, h )
	end
end

function ENT:ShowComputerScreen( )
	self.ComputerScreen:Hide( )
end

function ENT:HideComputerScreen( )
	self.ComputerScreen:Hide( )
end

-- Computer Screen Panel -- END

-- Login Screen -- Parented to Computer Screen Panel -- BEGIN

function ENT:CreateLoginScreen( )
	self.LoginText = vgui.Create( "DLabel", self.ComputerScreen )
	self.LoginText:SetFont( "EPSTitleLoginFont" )
	self.LoginText:SetTextColor( Color( 200, 200, 200 ) )
	self.LoginText:SetText( "Police Department Computer" )
	self.LoginText:SizeToContents( )
	self.LoginText:CenterHorizontal( 0.5 )
	self.LoginText:CenterVertical( 0.4 )

	self.LoginButton = vgui.Create( "EPS_Button", self.ComputerScreen )
	self.LoginButton:SetTextWithSize( "Login" )
	self.LoginButton:CenterHorizontal( 0.5 )
	self.LoginButton:CenterVertical( 0.6 )

	self.LoginButton.DoClick = function( )
		if EggrollPoliceSystem.Config.CanNonCopAccessPoliceComputer or ( not EggrollPoliceSystem.Config.CanNonCopAccessPoliceComputer and LocalPlayer( ):isCP( ) ) then
			if IsValid( self:GetActiveUser( ) ) then
				if not IsValid( self.ComputerInUseText ) then
					self.ComputerInUseText = vgui.Create( "DLabel", self.ComputerScreen )
					self.ComputerInUseText:SetFont( "EPSTitleLoginFont" )
					self.ComputerInUseText:SetTextColor( Color( 255, 20, 20 ) )
					self.ComputerInUseText:SetText( "Computer In Use!" )
					self.ComputerInUseText:SizeToContents( )
					self.ComputerInUseText:CenterHorizontal( 0.5 )
					self.ComputerInUseText:CenterVertical( 0.2 )
				elseif not self.ComputerInUseText:IsVisible( ) then
					self.ComputerInUseText:Show( )
				end

				timer.Create( "EPS_" .. self:EntIndex( ) .. "_HideComputerInUse", 5, 1, function( ) -- Using timer.simple would result in this running multiple times if spammed.
					if IsValid( self.ComputerInUseText ) then
						self.ComputerInUseText:Hide( )
					end
				end )
			else
				if IsValid( self.ComputerInUseText ) then
					self.ComputerInUseText:Hide( )
				end

				if IsValid( self.AccessDeniedScreen ) then
					self.AccessDeniedScreen:Hide( )
				end

				self:Login( )
			end
		else
			if not IsValid( self.AccessDeniedScreen ) then
				self.AccessDeniedScreen = vgui.Create( "DLabel", self.ComputerScreen )
				self.AccessDeniedScreen:SetFont( "EPSTitleLoginFont" )
				self.AccessDeniedScreen:SetTextColor( Color( 255, 20, 20 ) )
				self.AccessDeniedScreen:SetText( "Access Denied!" )
				self.AccessDeniedScreen:SizeToContents( )
				self.AccessDeniedScreen:CenterHorizontal( 0.5 )
				self.AccessDeniedScreen:CenterVertical( 0.2 )
			elseif not self.AccessDeniedScreen:IsVisible( ) then
				self.AccessDeniedScreen:Show( )
			end

			timer.Create( "EPS_" .. self:EntIndex( ) .. "_HideAccessDenied", 5, 1, function( ) -- Using timer.simple would result in this running multiple times if spammed.
				if IsValid( self.AccessDeniedScreen ) then
					self.AccessDeniedScreen:Hide( )
				end
			end )
		end
	end
end

function ENT:ShowLoginScreen( )
	self.LoginText:Show( )
	self.LoginButton:Show( )
end

function ENT:HideLoginScreen( )
	self.LoginText:Hide( )
	self.LoginButton:Hide( )
end

-- Login Screen -- Parented to Computer Screen Panel -- END

-- Desktop Screen -- Parented to Computer Screen Panel -- BEGIN

function ENT:CreateDesktop( )
	self:CreateDesktopText( )
	self:CreateTaskbar( )
	self.WindowSize = { }
	self.WindowSize.W = self.ComputerScreen:GetWide( )
	self.WindowSize.H = self.ComputerScreen:GetTall( ) - self.Taskbar:GetTall( )
	self:CreateDesktopIcons( )
end

function ENT:ShowDesktop( )
	self:ShowDesktopText( )
	self:ShowTaskbar( )
	self:ShowDesktopIcons( )
end

function ENT:HideDesktop( )
	self:HideDesktopText( )
	self:HideTaskbar( )
	self:HideDesktopIcons( )
end

-- Desktop Screen -- Parented to Computer Screen Panel -- END

-- Desktop Text -- Parented to Desktop Screen -- BEGIN

function ENT:CreateDesktopText( )
	self.DesktopText = vgui.Create( "DLabel", self.ComputerScreen )
	self.DesktopText:SetFont( "EPSTitleFont" )
	self.DesktopText:SetTextColor( Color( 200, 200, 200 ) )
	self.DesktopText:SetText( "Police Department" )
	self.DesktopText:SizeToContents( )
	self.DesktopText:CenterHorizontal( 0.5 )
	self.DesktopText:CenterVertical( 0.1 )
end

function ENT:ShowDesktopText( )
	self.DesktopText:Show( )
end

function ENT:HideDesktopText( )
	self.DesktopText:Hide( )
end

-- Desktop Text -- Parented to Desktop Screen -- END

-- Taskbar -- Parented to Computer Screen -- BEGIN

function ENT:CreateTaskbar( )
	self.Taskbar = vgui.Create( "DPanel", self.ComputerScreen )
	self.Taskbar:Dock( BOTTOM )
	self.Taskbar:SetSize( self.ComputerScreen:GetWide( ), self.ComputerScreen:GetTall( ) * 0.075 )

	self.Taskbar.Paint = function( _, w, h )
		surface.SetDrawColor( 6, 68, 117 )
		surface.DrawRect( 0, 0, w, h )
	end

	self.TaskbarStartMenu = vgui.Create( "DPanel", self.ComputerScreen )
	self.TaskbarStartMenu:SetSize( self.ComputerScreen:GetWide( ) / 4.5, self.ComputerScreen:GetTall( ) * 0.075 )
	self.TaskbarStartMenu:SetPos( 0, self.ComputerScreen:GetTall( ) - self.ComputerScreen:GetTall( ) * 0.075 - self.TaskbarStartMenu:GetTall( ) )
	self.TaskbarStartMenu:Hide( )

	self.TaskbarStartMenu.Paint =  function( _, w, h )
		surface.SetDrawColor( 3, 38, 65 )
		surface.DrawRect( 0, 0, w, h )
	end

	self.TaskbarStartMenuLogout = vgui.Create( "DButton", self.TaskbarStartMenu )
	self.TaskbarStartMenuLogout:Dock( FILL )
	self.TaskbarStartMenuLogout:DockMargin( 5, 5, 5, 5 )
	self.TaskbarStartMenuLogout:SetTextColor( Color( 200, 200, 200 ) )
	self.TaskbarStartMenuLogout:SetText( "Log Out" )

	self.TaskbarStartMenuLogout.Paint = function( _, w, h )
		surface.SetDrawColor( 8, 112, 191 )
		surface.DrawRect( 0, 0, w, h )
	end

	self.TaskbarStartMenuLogout.DoClick = function( )
		self:Logout( )
	end

	self.TaskbarStartButton = vgui.Create( "DButton", self.Taskbar )
	self.TaskbarStartButton:Dock( LEFT )
	self.TaskbarStartButton:SetSize( self.ComputerScreen:GetWide( ) * 0.15, self.ComputerScreen:GetTall( ) )
	self.TaskbarStartButton:SetTextColor( Color( 200, 200, 200 ) )
	self.TaskbarStartButton:SetText( "Start" )

	self.TaskbarStartButton.Paint = function( _, w, h )
		surface.SetDrawColor( 8, 91, 157 )
		surface.DrawRect( 0, 0, w, h )
	end

	self.TaskbarStartButton.DoClick = function( )
		if not self.TaskbarStartMenu:IsVisible( ) then
			self.TaskbarStartMenu:Show( )
			self.TaskbarStartMenu:MoveToFront( )
		else
			self.TaskbarStartMenu:Hide( )
		end
	end
end

function ENT:ShowTaskbar( )
	self.Taskbar:Show( )
end

function ENT:HideTaskbar( )
	self.Taskbar:Hide( )
	self.TaskbarStartMenu:Hide( )
end

-- Taskbar -- Parented to Computer Screen -- END

-- Desktop Icons -- Parented to Desktop Screen -- BEGIN

function ENT:CreateDesktopIcons( )
	for k, v in pairs( self.Programs ) do
		self.Icons[ k ] = vgui.Create( "EPS_DesktopIcon", self.ComputerScreen )
		self.Icons[ k ]:SetPos( v.IconPosition[ 1 ], v.IconPosition[ 2 ] )
		self.Icons[ k ]:SetText( v.Name )
		self.Icons[ k ]:SetIcon( v.Icon )

		self.Icons[ k ].Button.DoClick = function( )
			self:OpenProgram( v )
		end
	end
end

function ENT:ShowDesktopIcons( )
	for _, v in pairs( self.Icons ) do
		v:Show( )
	end
end

function ENT:HideDesktopIcons( )
	for _, v in pairs( self.Icons ) do
		v:Hide( )
	end
end

-- Desktop Icons -- Parented to Desktop Screen -- END

function ENT:Initialize( )
	self.Icons = { }
	self.Programs = table.Copy( EggrollPoliceSystem.Programs )
	self:CreateComputerScreen( )
	self:CreateLoginScreen( )
	self:CreateDesktop( )
	self:HideDesktop( )
	self:DrawComputer( ) -- Need to do this, otherwise it will draw in 2D.
end

function ENT:Draw( )
	self:DrawModel( )
	self:DrawComputer( )
end

function ENT:DrawComputer( )
	local pos = self:GetPos( ) + self:GetForward( ) * 11.72 + self:GetUp( ) * 11.8 + self:GetRight( ) * 9.8
	local ang = self:GetAngles( )
	ang:RotateAroundAxis( ang:Up( ), 90 )
	ang:RotateAroundAxis( ang:Forward( ), 85.5 )

	vgui.Start3D2D( pos, ang, 0.04 )
		self.ComputerScreen:Paint3D2D( )
	vgui.End3D2D( )
end

function ENT:Login( )
	net.Start( "EPS_LoginToPoliceComputer" )
	net.WriteEntity( self )
	net.WriteBool( true ) -- Log in.
	net.SendToServer( )
	self:HideLoginScreen( )
	self:ShowDesktop( )
end

function ENT:Logout( )
	net.Start( "EPS_LoginToPoliceComputer" )
	net.WriteEntity( self )
	net.WriteBool( false ) -- Log out.
	net.SendToServer( )
	self:HideDesktop( )

	if self.ComputerScreen.OpenProgram then
		self.ComputerScreen.OpenProgram:CloseProgram( )
	end

	self.LoginText:Show( )
	self.LoginButton:Show( )
end

function ENT:OpenProgram( program_tbl )
	program_tbl.ProgramFrame = vgui.Create( "EPS_ProgramFrame", self.ComputerScreen )
	program_tbl.ProgramFrame:SetPos( 0, 0 )
	program_tbl.ProgramFrame:SetWindowSize( self.WindowSize.W, self.WindowSize.H )
	program_tbl.ProgramFrame.TitleBarIcon:SetImage( program_tbl.Icon )
	program_tbl.ProgramFrame.TitleBarTitle:SetText( program_tbl.Name )
	program_tbl.ProgramFrame.TitleBarTitle:SizeToContents( )

	program_tbl.ProgramFrame.CloseProgram = function( )
		if program_tbl.Close then
			program_tbl:Close( )
		end

		program_tbl.ProgramFrame:Remove( )
		self.ComputerScreen.OpenProgram = nil
		net.Start( "EPS_CloseProgram" )
		net.WriteEntity( self )
		net.WriteString( program_tbl.Name )
		net.SendToServer( )
	end

	self.ComputerScreen.OpenProgram = program_tbl.ProgramFrame
	program_tbl:Init( self )

	net.Start( "EPS_OpenProgram" )
	net.WriteEntity( self )
	net.WriteString( program_tbl.Name )
	net.SendToServer( )
end

net.Receive( "EPS_LoginToPoliceComputer", function( ) -- Log out on client
	local computer = net.ReadEntity( )

	if IsValid( computer ) then
		computer:Logout( )
	end
end )
