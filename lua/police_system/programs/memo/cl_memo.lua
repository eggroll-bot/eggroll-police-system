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

function PROGRAM:Create2DTextPrompt( callback ) -- Calls the callback function after successful text entry with args: text.
	if not self.TextPromptEntry then
		local scr_w, scr_h = ScrW( ), ScrH( )
		self.TextPromptBG = vgui.Create( "EditablePanel" ) -- Have to use an EditablePanel because DTextEntries require something derived from EditablePanels.
		self.TextPromptBG:SetSize( scr_w * 0.3, scr_h * 0.2 )
		self.TextPromptBG:Center( )
		self.TextPromptBG:MakePopup( )

		self.TextPromptBG.Paint = function( _, w, h )
			surface.SetDrawColor( 75, 75, 75 )
			surface.DrawRect( 0, 0, w, h )
		end

		self.TextPromptEntry = vgui.Create( "DTextEntry", self.TextPromptBG )
		self.TextPromptEntry:SetSize( self.TextPromptBG:GetWide( ) / 1.05, self.TextPromptBG:GetTall( ) / 1.30 )
		self.TextPromptEntry:CenterHorizontal( )
		self.TextPromptEntry:CenterVertical( 0.44 )
		self.TextPromptEntry:SetMultiline( true )

		self.TextPromptSubmit = vgui.Create( "DButton", self.TextPromptBG )
		self.TextPromptSubmit:SetText( "Submit" )
		self.TextPromptSubmit:SetSize( self.TextPromptBG:GetWide( ) * 0.2, self.TextPromptBG:GetTall( ) * 0.1 )
		self.TextPromptSubmit:CenterHorizontal( 0.5 )
		self.TextPromptSubmit:CenterVertical( 0.91 )

		self.TextPromptSubmit.DoClick = function( )
			self.TextPromptBG:Hide( )
			callback( self.TextPromptEntry:GetText( ) )
		end
	else
		self.TextPromptBG:Show( )
		self.TextPromptEntry:SetText( "" )

		self.TextPromptSubmit.DoClick = function( ) -- To set the callback function again.
			self.TextPromptBG:Hide( )
			callback( self.TextPromptEntry:GetText( ) )
		end
	end
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

	self.AddMemoPrompt = vgui.Create( "DTextEntry", self.AddMemoPromptPanel )
	self.AddMemoPrompt:SetSize( self.AddMemoPromptPanel:GetWide( ) - 20, self.AddMemoPromptPanel:GetTall( ) - 110 )
	self.AddMemoPrompt:CenterHorizontal( )
	self.AddMemoPrompt:CenterVertical( 0.575 )
	self.AddMemoPrompt:SetMultiline( true )
	self.AddMemoPrompt.OldOnMousePressed = self.AddMemoPrompt.OnMousePressed -- I'm reallyyy starting to hate 3D2D VGUI now. It has no support for text entry focusing.

	self.AddMemoPrompt.OnMousePressed = function( )
		if not IsFirstTimePredicted( ) then return end

		self:Create2DTextPrompt( function( text )
			--
		end )

		return self.AddMemoPrompt:OldOnMousePressed( )
	end

	local x, y = self.AddMemoPrompt:GetPos( )
	self.AddMemoPromptText = vgui.Create( "DLabel", self.AddMemoPromptPanel )
	self.AddMemoPromptText:SetText( "Memo:" )
	self.AddMemoPromptText:SizeToContents( )
	self.AddMemoPromptText:SetPos( x, y - 20 )
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
