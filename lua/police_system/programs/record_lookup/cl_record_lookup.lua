local PROGRAM = { }
PROGRAM.Name = "Record Lookup"
PROGRAM.Icon = "icon16/book.png"
PROGRAM.IconPosition = { 40, 140 }

function PROGRAM:CreateMainMenu( )
	self.MainMenuTitle = vgui.Create( "DLabel", self.ProgramFrame )
	self.MainMenuTitle:SetFont( "DermaLarge" )
	self.MainMenuTitle:SetTextColor( Color( 200, 200, 200 ) )
	self.MainMenuTitle:SetText( "Record Lookup" )
	self.MainMenuTitle:SizeToContents( )
	self.MainMenuTitle:CenterHorizontal( 0.5 )
	self.MainMenuTitle:CenterVertical( 0.15 )

	self.MainMenuViewRecordsButton = vgui.Create( "EPS_Button", self.ProgramFrame )
	self.MainMenuViewRecordsButton:SetTextWithSize( "View/Edit Records" )
	self.MainMenuViewRecordsButton:CenterHorizontal( 0.5 )
	self.MainMenuViewRecordsButton:CenterVertical( 0.5 )

	self.MainMenuViewRecordsButton.DoClick = function( )
		self:HideMainMenu( )
		self:CreateViewRecords( )
	end
end

function PROGRAM:ShowMainMenu( )
	self.MainMenuTitle:Show( )
	self.MainMenuViewRecordsButton:Show( )
end

function PROGRAM:HideMainMenu( )
	self.MainMenuTitle:Hide( )
	self.MainMenuViewRecordsButton:Hide( )
end

function PROGRAM:CreateViewRecords( )
	self.ViewRecordsScrollPanel = vgui.Create( "DScrollPanel", self.ProgramFrame )
	self.ViewRecordsScrollPanel:Dock( FILL )
	self.ViewRecordsScrollPanel:DockMargin( 5, 50, 5, 25 )
	local vbar = self.ViewRecordsScrollPanel:GetVBar( )
	vbar.btnGrip:Hide( )

	vbar.Paint = function( ) end

	vbar.OnMousePressed = function( ) end

	for _, v in pairs( player.GetAll( ) ) do
		local player_btn = self.ViewRecordsScrollPanel:Add( "EPS_Button" )
		player_btn:SetTextWithSize( v:Name( ) )
		player_btn:Dock( TOP )
		player_btn:DockMargin( 0, 5, 0, 0 )
		player_btn:CenterHorizontal( 0.5 )

		player_btn.DoClick = function( )
			self.ViewRecordsScrollPanel:Remove( ) -- Have to remove it b/c stupid buttons are clickable even behind the panel and other issues.
			net.Start( "EPS_RetrievePersonalRecords" )
			net.WriteEntity( self.Computer )
			net.WriteEntity( v )
			net.SendToServer( )
		end
	end
end

function PROGRAM:Init( computer )
	self.Computer = computer
	self.ProgramFrame.WindowBackgroundColor = Color( 20, 20, 20 )
	self:CreateMainMenu( )

	net.Receive( "EPS_RetrievePersonalRecords", function( ) -- Needs to be in here because it needs to reference the program.
		if self and self.CreateRecords then
			self:CreateRecords( ) -- Need to call CreateRecords from the metatable. Can't just use self.CreateRecords.
		end
	end )
end

function PROGRAM:CreateRecords( )
	local data = net.ReadTable( )
	self.PersonalRecordsPanel = vgui.Create( "DPanel", self.ProgramFrame )
	self.PersonalRecordsPanel:Dock( FILL )
	self.PersonalRecordsPanel:DockMargin( 0, 18, 0, 0 )

	self.PersonalRecordsPanel.Paint = function( _, w, h )
		surface.SetDrawColor( 20, 20, 20 )
		surface.DrawRect( 0, 0, w, h )
	end

	timer.Simple( 0.1, function( ) -- Have to wait for Dock to invalidate layout.
		if IsValid( self.PersonalRecordsPanel ) then
			self.PersonalRecordsBackImg = vgui.Create( "DImage", self.ProgramFrame.TitleBar )
			self.PersonalRecordsBackImg:SetSize( 16, 16 )
			self.PersonalRecordsBackImg:SetImage( "icon16/arrow_left.png" )
			self.PersonalRecordsBackImg:CenterHorizontal( 0.25 )
			self.PersonalRecordsBackImg:CenterVertical( 0.5 )

			self.PersonalRecordsBackBtn = vgui.Create( "DButton", self.ProgramFrame.TitleBar )
			self.PersonalRecordsBackBtn:SetSize( 16, 16 )
			self.PersonalRecordsBackBtn:SetText( "" )
			self.PersonalRecordsBackBtn:CenterHorizontal( 0.25 )
			self.PersonalRecordsBackBtn:CenterVertical( 0.5 )

			self.PersonalRecordsBackBtn.Paint = function( ) end

			self.PersonalRecordsBackBtn.DoClick = function( )
				self.PersonalRecordsBackImg:Remove( )
				self.PersonalRecordsBackBtn:Remove( )
				self.PersonalRecordsPanel:Remove( )
				self:CreateViewRecords( )
			end

			if data.model then
				self.PersonalRecordsPlayerIcon = vgui.Create( "SpawnIcon", self.PersonalRecordsPanel )
				self.PersonalRecordsPlayerIcon:SetSize( 128, 128 )
				self.PersonalRecordsPlayerIcon:SetPos( self.PersonalRecordsPanel:GetWide( ) - self.PersonalRecordsPlayerIcon:GetWide( ), 0 )
				self.PersonalRecordsPlayerIcon:SetModel( data.model )

				self.PersonalRecordsPlayerIcon.PerformLayout = function( ) end
			else
				self.PersonalRecordsPlayerIcon = vgui.Create( "DLabel", self.PersonalRecordsPanel )
				self.PersonalRecordsPlayerIcon:SetFont( "CloseCaption_Normal" )
				self.PersonalRecordsPlayerIcon:SetText( "Face Not Found" )
				self.PersonalRecordsPlayerIcon:SizeToContents( )
				self.PersonalRecordsPlayerIcon:SetPos( self.PersonalRecordsPanel:GetWide( ) - self.PersonalRecordsPlayerIcon:GetWide( ) - 5, 5 )
			end

			self.PersonalRecordsName = vgui.Create( "DLabel", self.PersonalRecordsPanel )
			self.PersonalRecordsName:SetFont( "CloseCaption_Normal" )
			self.PersonalRecordsName:SetText( "Name: " .. data.name )
			self.PersonalRecordsName:SetSize( self.PersonalRecordsPanel:GetWide( ) - 130, 1 )
			self.PersonalRecordsName:SizeToContentsY( )
			self.PersonalRecordsName:SetPos( 10, 5 )

			self.PersonalRecordsInfo = vgui.Create( "DLabel", self.PersonalRecordsPanel )
			self.PersonalRecordsInfo:SetFont( "CloseCaption_Normal" )
			self.PersonalRecordsInfo:SetText( "Job: " .. data.job .. "\n\nSalary: " .. data.salary )
			self.PersonalRecordsInfo:SetSize( self.PersonalRecordsPanel:GetWide( ) - 130, 1 )
			self.PersonalRecordsInfo:SizeToContentsY( )
			self.PersonalRecordsInfo:SetPos( 10, self.PersonalRecordsName:GetTall( ) + 30 )

			self.PersonalRecordsArrests = vgui.Create( "DListView", self.PersonalRecordsPanel )
			self.PersonalRecordsArrests:SetPos( 10, self.PersonalRecordsName:GetTall( ) + self.PersonalRecordsInfo:GetTall( ) + 40 )
			self.PersonalRecordsArrests:SetSize( self.PersonalRecordsPanel:GetWide( ) - 20, self.PersonalRecordsPanel:GetTall( ) * 0.56 )
			self.PersonalRecordsArrests:SetMultiSelect( false )
			self.PersonalRecordsArrests:AddColumn( "Date/Time Of Arrest" )
			self.PersonalRecordsArrests:AddColumn( "Duration" )
			self.PersonalRecordsArrests.VBar.btnGrip:Hide( )

			self.PersonalRecordsArrests.VBar.Paint = function( ) end

			self.PersonalRecordsArrests.VBar.OnMousePressed = function( ) end

			for _, v in pairs( data.arrestrecord ) do
				self.PersonalRecordsArrests:AddLine( v[ 1 ], v[ 2 ] .. " sec(s)" )
			end
		end
	end )
end

EggrollPoliceSystem:RegisterProgram( PROGRAM.Name, PROGRAM )
