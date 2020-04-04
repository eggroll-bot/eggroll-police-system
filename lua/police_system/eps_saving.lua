local saveable_devices = {
	[ "eps_police_computer" ] = true,
	[ "eps_fingerprint_scanner" ] = true
}

local saved_devices = { }

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

	if not saveable_devices[ class ] or ent.Saved then
		return
	end

	local data = { }
	data.class = class
	data.pos = ent:GetPos( )
	data.ang = ent:GetAngles( )
	local id = EggrollPoliceSystem.GenerateDeviceID( )
	data.id = id
	saved_devices[ id ] = data
	EggrollPoliceSystem.UpdateSaveFile( )
	ent.PermID = id
	ent.Saved = true
end


-- Unsaves a device.
function EggrollPoliceSystem.UnsaveDevice( ent )
	if not saveable_devices[ ent:GetClass( ) ] or not ent.Saved then
		return
	end

	saved_devices[ ent.PermID ] = nil
	EggrollPoliceSystem.UpdateSaveFile( )
	ent.PermID = nil
	ent.Saved = nil
end

-- Updates the position and angle of a saved device in the table.
function EggrollPoliceSystem.UpdateSavedDevice( ent )
	if not saveable_devices[ ent:GetClass( ) ] or not ent.Saved then
		return
	end

	saved_devices[ ent.PermID ].pos = ent:GetPos( )
	saved_devices[ ent.PermID ].ang = ent:GetAngles( )
	EggrollPoliceSystem.UpdateSaveFile( )
end

-- on startup, place down all saved devices and make it so device.Saved = true and if it's a police computer, device.PermID = ID.
-- make it so on EntityRemoved with saveable devices, they are placed back down and respawned.
