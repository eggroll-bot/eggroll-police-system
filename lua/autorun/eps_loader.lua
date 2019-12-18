EggrollPoliceSystem = { }
EggrollPoliceSystem.Config = { }
EggrollPoliceSystem.Programs = { }

function EggrollPoliceSystem:RegisterProgram( name, program )
	EggrollPoliceSystem.Programs[ name ] = program
end

function EggrollPoliceSystem:DeRegisterProgram( name )
	EggrollPoliceSystem.Programs[ name ] = nil
end

if SERVER then
	AddCSLuaFile( "police_system/eps_includes.lua" )
end

include( "police_system/eps_includes.lua" )
