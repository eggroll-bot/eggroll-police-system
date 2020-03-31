util.AddNetworkString( "EPS_RetrievePersonalRecords" )

local function GetJobNameForRecords( target )
	local job_number = target:Team( )
	local job_name = RPExtraTeams[ job_number ].name
	local jobs_to_display = EggrollPoliceSystem.Config.JobsToDisplayInRecords

	if jobs_to_display[ "all" ] then
		return job_name
	end

	if jobs_to_display[ "CP" ] and target:isCP( ) then
		return job_name
	end

	for k in pairs( jobs_to_display ) do
		if _G[ k ] == job_number then -- _G[ "job_number" ] will convert it into a valid enumeration. It needs to be like this because DarkRP hasn't loaded by the time the configuration file has.
			return job_name
		end
	end

	return "Unknown"
end

net.Receive( "EPS_RetrievePersonalRecords", function( _, ply )
	local computer = net.ReadEntity( )

	if not IsValid( computer ) or computer:GetClass( ) ~= "eps_police_computer" or computer:GetActiveUser( ) ~= ply then
		return
	end

	local target = net.ReadEntity( )

	if not IsValid( target ) or not target:IsPlayer( ) then
		return
	end

	local arrest_record_file = file.Read( "eggroll_police_system/arrests/" .. target:SteamID64( ) .. ".txt", "DATA" )
	local arrests = { }

	if arrest_record_file then
		arrests = string.Explode( "|", arrest_record_file, false )
	end

	for k, v in pairs( arrests ) do
		arrests[ k ] = string.Explode( "&", v, false )
	end

	local data = { }
	data.name = target:Name( )
	data.model = target:GetModel( )
	data.job = GetJobNameForRecords( target )

	if data.job == "Unknown" then
		data.salary = "Unknown"
	else
		data.salary = DarkRP.formatMoney( DarkRP.retrieveSalary( target ) )
	end

	data.arrestrecord = arrests
	net.Start( "EPS_RetrievePersonalRecords" )
	net.WriteTable( data )
	net.Send( ply )
end )

hook.Add( "playerArrested", "Register_EPS_Arrest", function( criminal, arrest_time )
	if not IsValid( criminal ) then
		return
	end

	local _, folder = file.Find( "eggroll_police_system", "DATA" )

	if table.IsEmpty( folder ) then
		file.CreateDir( "eggroll_police_system" )
	end

	_, folder = file.Find( "eggroll_police_system/arrests", "DATA" )

	if table.IsEmpty( folder ) then
		file.CreateDir( "eggroll_police_system/arrests" )
	end

	local filetowrite = "eggroll_police_system/arrests/" .. criminal:SteamID64( ) .. ".txt"

	if table.IsEmpty( file.Find( filetowrite, "DATA" ) ) then
		file.Write( filetowrite, os.date( "%m/%d/%Y %H:%M", os.time( ) ) .. "&" .. arrest_time )
	else
		file.Append( filetowrite, "|" .. os.date( "%m/%d/%Y %H:%M", os.time( ) ) .. "&" .. arrest_time )
	end
end )
