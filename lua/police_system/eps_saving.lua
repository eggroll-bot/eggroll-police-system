local saveable_devices = {
	[ "eps_police_computer" ] = true,
	[ "eps_fingerprint_scanner" ] = true
}

local file_data = file.Read( "eps_saved_devices.txt" )
local saved_devices = file_data and util.JSONToTable( file_data ) or { }

-- Updates the flat file with the new saved_devices table.
function EggrollPoliceSystem.UpdateSaveFile( )
	file.Write( "eps_saved_devices.txt", util.TableToJSON( saved_devices ) )
end

-- Generates an ID for the next device to be saved.
function EggrollPoliceSystem.GenerateDeviceID( )
	local prev = 0

	for k in pairs( saved_devices ) do
		if k ~= prev + 1 then
			return prev + 1
		else
			prev = prev + 1
		end
	end

	return #saved_devices + 1
end

-- Saves a device.
function EggrollPoliceSystem.SaveDevice( ent )
	local class = ent:GetClass( )

	if not saveable_devices[ class ] or ent:GetNWBool( "saved" ) then
		return
	end

	local data = { }
	data.class = class
	data.pos = ent:GetPos( )
	data.ang = ent:GetAngles( )
	local id = EggrollPoliceSystem.GenerateDeviceID( )
	saved_devices[ id ] = data
	EggrollPoliceSystem.UpdateSaveFile( )
	ent:SetNWBool( "saved", true )
	ent.PermID = id
end


-- Unsaves a device.
function EggrollPoliceSystem.UnsaveDevice( ent )
	if not saveable_devices[ ent:GetClass( ) ] or not ent:GetNWBool( "saved" ) then
		return
	end

	saved_devices[ ent.PermID ] = nil
	EggrollPoliceSystem.UpdateSaveFile( )
	ent:SetNWBool( "saved", false )
	ent.PermID = nil
end

-- Updates the position and angle of a saved device in the table.
function EggrollPoliceSystem.UpdateSavedDevice( ent )
	if not saveable_devices[ ent:GetClass( ) ] or not ent:GetNWBool( "saved" ) then
		return
	end

	saved_devices[ ent.PermID ].pos = ent:GetPos( )
	saved_devices[ ent.PermID ].ang = ent:GetAngles( )
	EggrollPoliceSystem.UpdateSaveFile( )
end

-- Loads the save table from the flat file when the server starts up.
hook.Add( "InitPostEntity", "EPS_LoadSavedDeviceTable", function( )
	for k, v in pairs( saved_devices ) do
		local ent = ents.Create( v.class )

		if IsValid( ent ) then
			ent:SetPos( v.pos )
			ent:SetAngles( v.ang )
			ent:Spawn( )
			ent:Activate( )
			ent:GetPhysicsObject( ):EnableMotion( false )
			ent:SetNWBool( "saved", true )
			ent.PermID = k
		end
	end
end )

-- Replaces removed devices that are saved.
hook.Add( "EntityRemoved", "EPS_ReplaceSavedDevice", function( ent_old )
	if not saveable_devices[ ent_old:GetClass( ) ] or not ent_old:GetNWBool( "saved" ) then
		return
	end

	local id = ent_old.PermID
	local data = saved_devices[ id ]

	timer.Simple( 1, function( ) -- Apparently, cleaning up the server can cause a spike in entities being created? So, we're gonna delay this a bit.
		local ent = ents.Create( data.class )

		if IsValid( ent ) then
			ent:SetPos( data.pos )
			ent:SetAngles( data.ang )
			ent:Spawn( )
			ent:Activate( )
			ent:GetPhysicsObject( ):EnableMotion( false )
			ent:SetNWBool( "saved", true )
			ent.PermID = id
		end
	end )
end )
