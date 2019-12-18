local PROGRAM = { }
PROGRAM.Name = "Department Memos"
PROGRAM.Icon = "icon16/note.png"
PROGRAM.IconPosition = { 40, 200 }

function PROGRAM:CreateTitle( )
	self.TitleLabel = vgui.Create( "DLabel", self.ProgramFrame )
	self.TitleLabel:SetFont( "CloseCaption_Normal" )
	self.TitleLabel:SetText( "Department Memos" )
	self.TitleLabel:SizeToContents( )
	self.TitleLabel:CenterHorizontal( )
	self.TitleLabel:CenterVertical( 0.1 )
end

function PROGRAM:CreateAddPrompt( )
	local program_frame_w, program_frame_h = self.ProgramFrame:GetWide( ), self.ProgramFrame:GetTall( )
	local title_bar_h = program_frame_h * 0.05
	self.AddMemoPanel = vgui.Create( "DPanel", self.ProgramFrame )
	self.AddMemoPanel:SetPos( 0, title_bar_h )
	self.AddMemoPanel:SetSize( program_frame_w, program_frame_h - title_bar_h )

	self.AddMemoPanel.Paint = function( _, w, h )
		surface.SetDrawColor( 0, 0, 0, 200 )
		surface.DrawRect( 0, 0, w, h )
	end

	self.AddMemoPromptPanel = vgui.Create( "DPanel", self.AddMemoPanel )
	self.AddMemoPromptPanel:SetSize( self.AddMemoPanel:GetWide( ) - 100, self.AddMemoPanel:GetTall( ) - 80 )
	self.AddMemoPromptPanel:CenterHorizontal( )
	self.AddMemoPromptPanel:CenterVertical( )

	self.AddMemoPromptPanel.Paint = function( _, w, h )
		surface.SetDrawColor( 30, 30, 30 )
		surface.DrawRect( 0, 0, w, h )
	end

	self.AddMemoPromptPriorityLow = vgui.Create( "DCheckBox", self.AddMemoPromptPanel )
	self.AddMemoPromptPriorityLow:CenterHorizontal( 0.25 )
	self.AddMemoPromptPriorityLow:CenterVertical( 0.15 )
	self.AddMemoPromptPriorityLow:SetValue( true )

	self.AddMemoPromptPriorityLow.OnChange( function( _, checked )
		if checked then
			if self.AddMemoPromptPriorityMed:GetChecked( ) then
				self.AddMemoPromptPriorityMed:SetChecked( false )
			elseif self.AddMemoPromptPriorityHigh:GetChecked( ) then
				self.AddMemoPromptPriorityHigh:SetChecked( false )
			end
		end
	end )

	self.AddMemoPromptPriorityMed = vgui.Create( "DCheckBox", self.AddMemoPromptPanel )
	self.AddMemoPromptPriorityMed:CenterHorizontal( )
	self.AddMemoPromptPriorityMed:CenterVertical( 0.15 )

	self.AddMemoPromptPriorityMed.OnChange( function( checked )
		if checked then
			if self.AddMemoPromptPriorityLow:GetChecked( ) then
				self.AddMemoPromptPriorityLow:SetChecked( false )
			elseif self.AddMemoPromptPriorityHigh:GetChecked( ) then
				self.AddMemoPromptPriorityHigh:SetChecked( false )
			end
		end
	end )

	self.AddMemoPromptPriorityHigh = vgui.Create( "DCheckBox", self.AddMemoPromptPanel )
	self.AddMemoPromptPriorityHigh:CenterHorizontal( 0.75 )
	self.AddMemoPromptPriorityHigh:CenterVertical( 0.15 )

	self.AddMemoPromptPriorityHigh.OnChange( function( checked )
		if checked then
			if self.AddMemoPromptPriorityLow:GetChecked( ) then
				self.AddMemoPromptPriorityLow:SetChecked( false )
			elseif self.AddMemoPromptPriorityMed:GetChecked( ) then
				self.AddMemoPromptPriorityMed:SetChecked( false )
			end
		end
	end )

	local max_width_per_line = 280
	self.AddMemoPromptLine1 = vgui.Create( "DTextEntry", self.AddMemoPromptPanel )
	self.AddMemoPromptLine1:SetWide( self.AddMemoPromptPanel:GetWide( ) - 20 )
	self.AddMemoPromptLine1:CenterHorizontal( )
	self.AddMemoPromptLine1:CenterVertical( 0.32 )
	local x, y = self.AddMemoPromptLine1:GetPos( )
	self.AddMemoPromptLine1Text = vgui.Create( "DLabel", self.AddMemoPromptPanel )
	self.AddMemoPromptLine1Text:SetText( "Line 1:" )
	self.AddMemoPromptLine1Text:SizeToContents( )
	self.AddMemoPromptLine1Text:SetPos( x, y - 20 )

	self.AddMemoPromptLine2 = vgui.Create( "DTextEntry", self.AddMemoPromptPanel )
	self.AddMemoPromptLine2:SetWide( self.AddMemoPromptPanel:GetWide( ) - 20 )
	self.AddMemoPromptLine2:CenterHorizontal( )
	self.AddMemoPromptLine2:CenterVertical( 0.49 )
	x, y = self.AddMemoPromptLine2:GetPos( )
	self.AddMemoPromptLine2Text = vgui.Create( "DLabel", self.AddMemoPromptPanel )
	self.AddMemoPromptLine2Text:SetText( "Line 2:" )
	self.AddMemoPromptLine2Text:SizeToContents( )
	self.AddMemoPromptLine2Text:SetPos( x, y - 20 )

	self.AddMemoPromptLine3 = vgui.Create( "DTextEntry", self.AddMemoPromptPanel )
	self.AddMemoPromptLine3:SetWide( self.AddMemoPromptPanel:GetWide( ) - 20 )
	self.AddMemoPromptLine3:CenterHorizontal( )
	self.AddMemoPromptLine3:CenterVertical( 0.66 )
	x, y = self.AddMemoPromptLine3:GetPos( )
	self.AddMemoPromptLine3Text = vgui.Create( "DLabel", self.AddMemoPromptPanel )
	self.AddMemoPromptLine3Text:SetText( "Line 3:" )
	self.AddMemoPromptLine3Text:SizeToContents( )
	self.AddMemoPromptLine3Text:SetPos( x, y - 20 )

	self.AddMemoPromptLine4 = vgui.Create( "DTextEntry", self.AddMemoPromptPanel )
	self.AddMemoPromptLine4:SetWide( self.AddMemoPromptPanel:GetWide( ) - 20 )
	self.AddMemoPromptLine4:CenterHorizontal( )
	self.AddMemoPromptLine4:CenterVertical( 0.83 )
	x, y = self.AddMemoPromptLine4:GetPos( )
	self.AddMemoPromptLine4Text = vgui.Create( "DLabel", self.AddMemoPromptPanel )
	self.AddMemoPromptLine4Text:SetText( "Line 4:" )
	self.AddMemoPromptLine4Text:SizeToContents( )
	self.AddMemoPromptLine4Text:SetPos( x, y - 20 )
end

function PROGRAM:CreateAddButton( )
	self.AddButtonImg = vgui.Create( "DImage", self.ProgramFrame )
	self.AddButtonImg:SetSize( 16, 16 )
	self.AddButtonImg:SetImage( "icon16/add.png" )
	self.AddButtonImg:CenterHorizontal( 0.4 )
	self.AddButtonImg:CenterVertical( 0.18 )

	self.AddButtonBtn = vgui.Create( "DButton", self.AddButtonImg )
	self.AddButtonBtn:SetPos( 0, 0 )
	self.AddButtonBtn:SetSize( 16, 16 )
	self.AddButtonBtn:SetText( "" )

	self.AddButtonBtn.Paint = function( )
	end

	self.AddButtonBtn.DoClick = function( )
		self:CreateAddPrompt( )
	end
end

function PROGRAM:CreateDeleteButton( )
	self.DeleteButtonImg = vgui.Create( "DImage", self.ProgramFrame )
	self.DeleteButtonImg:SetSize( 16, 16 )
	self.DeleteButtonImg:SetImage( "icon16/delete.png" )
	self.DeleteButtonImg:CenterHorizontal( 0.6 )
	self.DeleteButtonImg:CenterVertical( 0.18 )

	self.DeleteButtonBtn = vgui.Create( "DButton", self.DeleteButtonImg )
	self.DeleteButtonBtn:SetPos( 0, 0 )
	self.DeleteButtonBtn:SetSize( 16, 16 )
	self.DeleteButtonBtn:SetText( "" )

	self.DeleteButtonBtn.Paint = function( )
	end

	self.DeleteButtonBtn.DoClick = function( )
		--
	end
end

function PROGRAM:CreateMemoList( )
	self.MemoList = vgui.Create( "DListView", self.ProgramFrame )
	self.MemoList:SetSize( self.ProgramFrame:GetWide( ) - 20, self.ProgramFrame:GetTall( ) - 100 )
	self.MemoList:CenterHorizontal( )
	self.MemoList:CenterVertical( 0.6 )
	self.MemoList:SetMultiSelect( false )
	self.MemoList:AddColumn( "Author" ):SetWidth( 30 )
	self.MemoList:AddColumn( "Message" ):SetWidth( 230 )
	self.MemoList:AddColumn( "Memo Priority" ):SetWidth( 15 )
	self.MemoList.VBar.btnGrip:Hide( )

	self.MemoList.VBar.Paint = function( ) end

	self.MemoList.VBar.OnMousePressed = function( ) end

	self.MemoList:AddLine( "Test", "WWWWWWWWWWWWWWWWWWWWWWWWWWWW", "test" )
end

function PROGRAM:Init( )
	self.ProgramFrame.WindowBackgroundColor = Color( 20, 20, 20 )
	self:CreateTitle( )
	self:CreateAddButton( )
	self:CreateDeleteButton( )
	self:CreateMemoList( )
end

EggrollPoliceSystem:RegisterProgram( PROGRAM.Name, PROGRAM )
