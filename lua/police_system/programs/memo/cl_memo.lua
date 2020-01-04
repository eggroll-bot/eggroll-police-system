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

function PROGRAM:Create2DTextPrompt( text, callback ) -- Calls the callback function after successful text entry with args: text.
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
		self.TextPromptEntry:SetText( text or "" )

		self.TextPromptSubmit.DoClick = function( ) -- To set the callback function again.
			self.TextPromptBG:Hide( )
			callback( self.TextPromptEntry:GetText( ) )
		end
	end
end

function PROGRAM:AddMemo( author, memo_id, memo, priority ) -- Player author, Number memo_id, String memo, String priority
	local line = self.MemoList:AddLine( author:Name( ), memo, priority )
	line.AuthorUserID = author:UserID( )
	line.MemoID = memo_id
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
	self.AddMemoPromptPanel:SetSize( self.AddMemoPanel:GetWide( ) * 0.5, self.AddMemoPanel:GetTall( ) * 0.5 )
	self.AddMemoPromptPanel:CenterHorizontal( )
	self.AddMemoPromptPanel:CenterVertical( )

	self.AddMemoPromptPanel.Paint = function( _, w, h )
		surface.SetDrawColor( 30, 30, 30 )
		surface.DrawRect( 0, 0, w, h )
	end

	local priority = 1 -- Default to low priority.
	self.AddMemoPromptPriorityLow = vgui.Create( "DCheckBox", self.AddMemoPromptPanel )
	self.AddMemoPromptPriorityLow:CenterHorizontal( 0.25 )
	self.AddMemoPromptPriorityLow:CenterVertical( 0.2 )
	self.AddMemoPromptPriorityLow:SetValue( true )

	self.AddMemoPromptPriorityLow.OnChange = function( _, checked )
		if checked then
			if self.AddMemoPromptPriorityMed:GetChecked( ) then
				self.AddMemoPromptPriorityMed:SetChecked( false )
			elseif self.AddMemoPromptPriorityHigh:GetChecked( ) then
				self.AddMemoPromptPriorityHigh:SetChecked( false )
			end

			priority = 1
		end
	end

	self.AddMemoPromptPriorityMed = vgui.Create( "DCheckBox", self.AddMemoPromptPanel )
	self.AddMemoPromptPriorityMed:CenterHorizontal( )
	self.AddMemoPromptPriorityMed:CenterVertical( 0.2 )

	self.AddMemoPromptPriorityMed.OnChange = function( _, checked )
		if checked then
			if self.AddMemoPromptPriorityLow:GetChecked( ) then
				self.AddMemoPromptPriorityLow:SetChecked( false )
			elseif self.AddMemoPromptPriorityHigh:GetChecked( ) then
				self.AddMemoPromptPriorityHigh:SetChecked( false )
			end

			priority = 2
		end
	end

	self.AddMemoPromptPriorityHigh = vgui.Create( "DCheckBox", self.AddMemoPromptPanel )
	self.AddMemoPromptPriorityHigh:CenterHorizontal( 0.75 )
	self.AddMemoPromptPriorityHigh:CenterVertical( 0.2 )

	self.AddMemoPromptPriorityHigh.OnChange = function( _, checked )
		if checked then
			if self.AddMemoPromptPriorityLow:GetChecked( ) then
				self.AddMemoPromptPriorityLow:SetChecked( false )
			elseif self.AddMemoPromptPriorityMed:GetChecked( ) then
				self.AddMemoPromptPriorityMed:SetChecked( false )
			end

			priority = 3
		end
	end

	self.AddMemoPrompt = vgui.Create( "DButton", self.AddMemoPromptPanel )
	self.AddMemoPrompt:SetText( "Add Memo" )
	self.AddMemoPrompt:SetSize( self.AddMemoPromptPanel:GetWide( ) * 0.32, self.AddMemoPromptPanel:GetTall( ) * 0.12 )
	self.AddMemoPrompt:CenterHorizontal( )
	self.AddMemoPrompt:CenterVertical( 0.5 )

	self.AddMemoPrompt.DoClick = function( )
		self:Create2DTextPrompt( self.AddMemoPrompt.Text, function( text )
			if self and IsValid( self.AddMemoPrompt ) then
				if text ~= "" then
					self.AddMemoPrompt.Text = text
					self.AddMemoSubmit:SetEnabled( true )
				elseif self.AddMemoSubmit:IsEnabled( ) then -- Submit button enabled and text is empty.
					self.AddMemoPrompt.Text = nil
					self.AddMemoSubmit:SetEnabled( false )
				end
			end
		end )
	end

	self.AddMemoSubmit = vgui.Create( "DButton", self.AddMemoPromptPanel )
	self.AddMemoSubmit:SetText( "Submit" )
	self.AddMemoSubmit:SetSize( self.AddMemoPromptPanel:GetWide( ) * 0.32, self.AddMemoPromptPanel:GetTall( ) * 0.12 )
	self.AddMemoSubmit:CenterHorizontal( 0.3 )
	self.AddMemoSubmit:CenterVertical( 0.8 )
	self.AddMemoSubmit:SetEnabled( false )

	self.AddMemoSubmit.DoClick = function( )
		local text = self.AddMemoPrompt.Text
		net.Start( "EPS_AddMemo" )
		net.WriteEntity( self.Computer )
		net.WriteUInt( priority, 2 )
		net.WriteString( text )
		net.SendToServer( )

		timer.Simple( 0.5, function( ) -- Refresh the list after 0.5 seconds (network delay).
			if self and IsValid( self.MemoList ) then
				self:PopulateList( )
			end
		end )

		self.AddMemoPanel:Remove( )
	end

	self.AddMemoCancel = vgui.Create( "DButton", self.AddMemoPromptPanel )
	self.AddMemoCancel:SetText( "Cancel" )
	self.AddMemoCancel:SetSize( self.AddMemoPromptPanel:GetWide( ) * 0.32, self.AddMemoPromptPanel:GetTall( ) * 0.12 )
	self.AddMemoCancel:CenterHorizontal( 0.7 )
	self.AddMemoCancel:CenterVertical( 0.8 )

	self.AddMemoCancel.DoClick = function( )
		self.AddMemoPanel:Remove( )
	end
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
		local to_delete

		for _, v in pairs( self.MemoList.Lines ) do -- DListView.GetSelectedLine won't be available until the next update.
			if v:IsSelected( ) then
				to_delete = v
				break
			end
		end

		if not IsValid( to_delete ) or to_delete.AuthorUserID ~= LocalPlayer( ):UserID( ) then
			return
		end

		net.Start( "EPS_RemoveMemo" )
		net.WriteEntity( self.Computer )
		net.WriteUInt( to_delete.MemoID, 16 )
		net.SendToServer( )
		self.MemoList:RemoveLine( to_delete:GetID( ) )
	end
end

function PROGRAM:CreateExpandButton( )
	self.ExpandButton = vgui.Create( "DButton", self.ProgramFrame )
	self.ExpandButton:SetText( "Expand" )
	self.ExpandButton:SizeToContents( )
	self.ExpandButton:CenterHorizontal( )
	self.ExpandButton:CenterVertical( 0.18 )

	self.ExpandButton.DoClick = function( )
		--
	end
end

function PROGRAM:PopulateList( ) -- Populate self.MemoList with the proper memos. Make sure that when populating, you set DListView_Line.AuthorUserID and DListView_Line.MemoID.
	net.Start( "EPS_RetrieveMemos" ) -- Receiver for this is at the bottom.
	net.WriteEntity( self.Computer )
	net.SendToServer( )

	net.Receive( "EPS_RetrieveMemos", function( ) -- Needs to be in here because it needs to reference the program.
		if not self or not IsValid( self.MemoList ) then return end
		self.MemoList:Clear( ) -- Remove all lines before populating.
		local json_tbl = net.ReadString( )
		local memo_tbl = util.JSONToTable( json_tbl )

		for author_user_id, author_memo_tbl in pairs( memo_tbl ) do
			for memo_id, memo_data in pairs( author_memo_tbl ) do
				local author = Player( author_user_id )
				self:AddMemo( author, memo_id, memo_data.Text, memo_data.Priority )
			end
		end

		self.MemoList:SortByColumn( 1 ) -- Sort by author.
	end )
end

function PROGRAM:CreateMemoList( )
	self.MemoList = vgui.Create( "DListView", self.ProgramFrame )
	self.MemoList:SetSize( self.ProgramFrame:GetWide( ) - 20, self.ProgramFrame:GetTall( ) - 100 )
	self.MemoList:CenterHorizontal( )
	self.MemoList:CenterVertical( 0.6 )
	self.MemoList:SetMultiSelect( false )
	self.MemoList:AddColumn( "Author" ):SetWidth( 100 )
	self.MemoList:AddColumn( "Message" ):SetWidth( 220 )
	self.MemoList:AddColumn( "Memo Priority" ):SetWidth( 50 )
	self.MemoList.VBar.btnGrip:Hide( )
	self.MemoList.VBar.Paint = function( ) end
	self.MemoList.VBar.OnMousePressed = function( ) end
	self:PopulateList( )
end

function PROGRAM:Init( computer )
	self.ProgramFrame.WindowBackgroundColor = Color( 20, 20, 20 )
	self.Computer = computer
	self:CreateTitle( )
	self:CreateAddButton( )
	self:CreateDeleteButton( )
	self:CreateExpandButton( )
	self:CreateMemoList( )
end

EggrollPoliceSystem:RegisterProgram( PROGRAM.Name, PROGRAM )
