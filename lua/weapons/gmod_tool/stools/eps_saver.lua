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
	if not saveable_devices[ ent:GetClass( ) ] or ent:GetNWBool( "saved" ) then return false end

	if SERVER then
		EggrollPoliceSystem.SaveDevice( ent )
	end

	return true
end

function TOOL:RightClick( trace )
	local ent = trace.Entity
	if not saveable_devices[ ent:GetClass( ) ] or not ent:GetNWBool( "saved" ) then return false end

	if SERVER then
		EggrollPoliceSystem.UnsaveDevice( ent )
	end

	return true
end

function TOOL:Reload( trace )
	local ent = trace.Entity
	if not saveable_devices[ ent:GetClass( ) ] or not ent:GetNWBool( "saved" ) then return false end

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
