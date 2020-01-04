util.AddNetworkString( "EPS_AddMemo" )
util.AddNetworkString( "EPS_RemoveMemo" )
util.AddNetworkString( "EPS_RetrieveMemos" )

EggrollPoliceSystem.CurrentMemos = { } -- Memos table is formatted like so:

--[[

{
	[ 1 ] = { -- Is the player's user ID for the session. Can be retrieved with ply:UserID( ). Names can be changed during a session, so the user ID is the best way to go.
		[ 1 ] = { -- Is the ID of the memo.
			[ "Priority" ] = "High", -- Can be "High", "Medium", or "Low"
			[ "Text" ] = "This is a text memo."
		},

		[ 2 ] = { -- Is the ID of the memo.
			[ "Priority" ] = "Medium", -- Can be "High", "Medium", or "Low"
			[ "Text" ] = "This is another text memo."
		}
	}
}

]]

local current_memos = EggrollPoliceSystem.CurrentMemos

local function AddMemo( author, priority, text )
	local memo = {
		[ "Priority" ] = priority,
		[ "Text" ] = text
	}

	current_memos[ author ] = current_memos[ author ] or { } -- Create the author's table if it does not exist.
	table.insert( current_memos[ author ], memo )
end

local function RemoveMemo( author, id )
	current_memos[ author:UserID( ) ][ id ] = nil

	if table.IsEmpty( current_memos[ author:UserID( ) ] ) then
		current_memos[ author:UserID( ) ] = nil
	end
end

local function RemoveMemosByAuthor( author )
	current_memos[ author:UserID( ) ] = nil
end

net.Receive( "EPS_AddMemo", function( _, ply )
	local computer = net.ReadEntity( )

	if not IsValid( computer ) or computer:GetActiveUser( ) ~= ply then
		return
	end

	local author = ply:UserID( )
	local priority = net.ReadUInt( 2 ) -- 1 = "Low", 2 = "Medium", 3 = "High"

	if priority == 1 then
		priority = "Low"
	elseif priority == 2 then
		priority = "Medium"
	elseif priority == 3 then
		priority = "High"
	else -- If we get 0, then we have to assume that it's a player "faking" a memo.
		return
	end

	local text = net.ReadString( )

	if text == "" then
		return
	end

	AddMemo( author, priority, text )
end )

net.Receive( "EPS_RemoveMemo", function( _, ply )
	local computer = net.ReadEntity( )

	if not IsValid( computer ) or computer:GetActiveUser( ) ~= ply then
		return
	end

	local userid = ply:UserID( ) -- Should only be able to delete their own.
	local id = net.ReadUInt( 16 )

	if current_memos[ userid ] and current_memos[ userid ][ id ] then
		RemoveMemo( ply, id )
	end
end )

net.Receive( "EPS_RetrieveMemos", function( _, ply )
	local computer = net.ReadEntity( )

	if not IsValid( computer ) or computer:GetActiveUser( ) ~= ply then
		return
	end

	local compressed_memo_tbl = util.TableToJSON( current_memos )
	net.Start( "EPS_RetrieveMemos" )
	net.WriteString( compressed_memo_tbl )
	net.Send( ply )
end )

hook.Add( "PlayerDisconnected", "EPS_Memos_Disconnect_Remove", RemoveMemosByAuthor )

hook.Add( "OnPlayerChangedTeam", "EPS_Memos_Team_Change_Remove", function( ply, _, after )
	if not GAMEMODE.CivilProtection[ after ] then
		RemoveMemosByAuthor( ply )
	end
end )
