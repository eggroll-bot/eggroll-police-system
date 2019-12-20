local Config = EggrollPoliceSystem.Config

-- Max distance to draw the screen.

Config.MaxDrawDist = 512

-- Which jobs should be displayed in the police computer records for a person. If the job is not listed here, it will be listed as "Unknown" in the police computer records program. Enter "CP" for all civil protection jobs or "all" for all jobs. All other jobs should be entered with "TEAM_[WhateverJob]". Example: "TEAM_GUN". Don't forget the commas between entries.

Config.JobsToDisplayInRecords = {
	[ "CP" ] = true,
}

-- Can a person who does not hold a civil protection job be allowed to access a police computer? -- Setting this to true will allow a person who does not hold a civil protection job to have full access to a police computer, including the ability to scan fingerprints, create memos, and look up records.

Config.CanNonCopAccessPoliceComputer = false

-- Distance before a person is logged out of the police computer automatically.

Config.DistanceBeforePoliceComputerLogout = 200

--[[

To add to config:

- Need to implement MaxDrawDist, only a config option right now.

- Enable citation system.

- Enable warning system.

- Distance of fingerprint scanner link.

- Who has access to removing all memos including ones not created by them? (default to "TEAM_MAYOR") (Do something similar to Config.JobsToDisplayInRecords for this.)

- Give handcuffs to cops?

- Must handcuff before arrest?

- Replace regular arrest batons with improved arrest batons automatically?

- Minimum arrest time for improved arrest baton.

- Maximum arrest time for improved arrest baton.

- Can a non-cop access ALPR in a car? Can a access a police computer in a car?

- Manual adding police cars by vehicle/entity names. Make sure they understand any police cars recognized by VCMod are already added if they have VCMod.

- Make fingerprint scanners buyable by cops. Tell the configurator that if set to false, the only way to get them is to place them and make them permanent on the map.

- Radius of a fingerprint scanner's signal.

- Should ALPR display the driver of the vehicle in front? Should ALPR display all of the non-driver passengers of the vehicle in front?

- Which key to press to exit out of police computer DTextEntries?

- Colors for backgrounds, text, etc.

- Localization Stuff

Last, organize config into sections.

]]