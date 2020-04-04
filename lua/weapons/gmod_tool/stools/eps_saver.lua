if CLIENT then
	language.Add( "tool.epssaver.name", "Eggroll Police System Saving Tool" )
	language.Add( "tool.epssaver.desc", "Saves Eggroll Police System devices." )
	language.Add( "tool.epssaver.left", "Save a device." )
	language.Add( "tool.epssaver.right", "Unsave a device." )
	language.Add( "tool.epssaver.reload", "Update a saved device's position and angle." )
end

local saveable_devices = {
	[ "eps_police_computer" ] = true,
	[ "eps_fingerprint_scanner" ] = true
}

TOOL.Category = "Eggroll Police System"
TOOL.Name = "#tool.epssaver.name"

TOOL.Information = {
	{
		name = "left",
		stage = 0
	},
	{
		name = "right",
		stage = 0
	},
	{
		name = "reload"
	}
}

function TOOL:LeftClick( trace )
	local ent = trace.Entity
	if not saveable_devices[ class ] or ent:GetNWBool( "saved" ) then return false end
	EggrollPoliceSystem.SaveDevice( ent )

	return true
end

function TOOL:RightClick( trace )
	local ent = trace.Entity
	if not saveable_devices[ ent:GetClass( ) ] or not ent:GetNWBool( "saved" ) then return false end
	EggrollPoliceSystem.UnsaveDevice( ent )

	return true
end

function TOOL:Reload( trace )
	local ent = trace.Entity
	if not saveable_devices[ ent:GetClass( ) ] or not ent:GetNWBool( "saved" ) then return false end
	EggrollPoliceSystem.UpdateSavedDevice( ent )

	return true
end

function TOOL.BuildCPanel( cpanel )
	cpanel:AddControl( "Header", {
		Description = "#tool.epssaver.desc"
	} )
end
