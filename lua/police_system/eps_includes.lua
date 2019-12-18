if SERVER then
	AddCSLuaFile( "police_system/eps_config.lua" )
	AddCSLuaFile( "police_system/eps_fonts.lua" )
	AddCSLuaFile( "includes/modules/3d2dvgui.lua" )
	include( "police_system/eps_config.lua" )
	local _, program_folders = file.Find( "police_system/programs/*", "LUA" )
	local program_folder = "police_system/programs/"

	for _, folder in pairs( program_folders ) do
		local program_files_sh = file.Find( program_folder .. folder .. "/sh_*.lua", "LUA" )
		local program_files_sv = file.Find( program_folder .. folder .. "/sv_*.lua", "LUA" )
		local program_files_cl = file.Find( program_folder .. folder .. "/cl_*.lua", "LUA" )

		for _, v in pairs( program_files_sh ) do
			AddCSLuaFile( program_folder .. folder .. "/" .. v )
			include( program_folder .. folder .. "/" .. v )
		end

		for _, v in pairs( program_files_sv ) do
			include( program_folder .. folder .. "/" .. v )
		end

		for _, v in pairs( program_files_cl ) do
			AddCSLuaFile( program_folder .. folder .. "/" .. v )
		end
	end
elseif CLIENT then
	include( "police_system/eps_config.lua" )
	include( "police_system/eps_fonts.lua" )
	include( "includes/modules/3d2dvgui.lua" )
	EggrollPoliceSystem.DesktopIcons = { }
	local _, program_folders = file.Find( "police_system/programs/*", "LUA" )
	local program_folder = "police_system/programs/"

	for _, folder in pairs( program_folders ) do
		local program_files_sh = file.Find( program_folder .. folder .. "/sh_*.lua", "LUA" )
		local program_files_cl = file.Find( program_folder .. folder .. "/cl_*.lua", "LUA" )

		for _, v in pairs( program_files_sh ) do
			include( program_folder .. folder .. "/" .. v )
		end

		for _, v in pairs( program_files_cl ) do
			include( program_folder .. folder .. "/" .. v )
		end
	end
end
