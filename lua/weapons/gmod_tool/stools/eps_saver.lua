if CLIENT then
	language.Add( "tool.eps_saver.name", "Saving Tool" )
	language.Add( "tool.eps_saver.desc", "Saves Eggroll Police System devices." )
	language.Add( "tool.eps_saver.left", "Save a device." )
	language.Add( "tool.eps_saver.right", "Unsave a device." )
	language.Add( "tool.eps_saver.reload", "Update a saved device's position and angle." )
end

local saveable_devices = {
	[ "eps_police_computer" ] = true,
	[ "eps_fingerprint_scanner" ] = true
}

TOOL.Category = "Eggroll Police System"
TOOL.Name = "#tool.eps_saver.name"

TOOL.Information = {
	{
		name = "left"
	},
	{
		name = "right"
	},
	{
		name = "reload"
	}
}

function TOOL:LeftClick( trace )
	local ent = trace.Entity
	if not IsFirstTimePredicted( ) or ent == Entity( 0 ) then return end

	if not saveable_devices[ ent:GetClass( ) ] then
		if CLIENT then
			notification.AddLegacy( "The entity you are looking at is not saveable.", NOTIFY_ERROR, 3 )
		end

		return false
	end

	if ent:GetNWBool( "saved" ) then
		if CLIENT then
			notification.AddLegacy( "The device you are looking at is already saved.", NOTIFY_ERROR, 3 )
		end

		return false
	end

	if SERVER then
		EggrollPoliceSystem.SaveDevice( ent )
	end

	return true
end

function TOOL:RightClick( trace )
	local ent = trace.Entity
	if not IsFirstTimePredicted( ) or ent == Entity( 0 ) then return end

	if not saveable_devices[ ent:GetClass( ) ] then
		if CLIENT then
			notification.AddLegacy( "The entity you are looking at is not saveable.", NOTIFY_ERROR, 3 )
		end

		return false
	end

	if not ent:GetNWBool( "saved" ) then
		if CLIENT then
			notification.AddLegacy( "The device you are looking at is not saved yet.", NOTIFY_ERROR, 3 )
		end

		return false
	end

	if SERVER then
		EggrollPoliceSystem.UnsaveDevice( ent )
	end

	return true
end

function TOOL:Reload( trace )
	local ent = trace.Entity
	if not IsFirstTimePredicted( ) or ent == Entity( 0 ) then return end

	if not saveable_devices[ ent:GetClass( ) ] then
		if CLIENT then
			notification.AddLegacy( "The entity you are looking at is not saveable.", NOTIFY_ERROR, 3 )
		end

		return false
	end

	if not ent:GetNWBool( "saved" ) then
		if CLIENT then
			notification.AddLegacy( "The device you are looking at is not saved yet.", NOTIFY_ERROR, 3 )
		end

		return false
	end

	if SERVER then
		EggrollPoliceSystem.UpdateSavedDevice( ent )
	end

	return true
end

function TOOL.BuildCPanel( cpanel )
	cpanel:AddControl( "Header", {
		Description = "#tool.eps_saver.desc"
	} )
end
