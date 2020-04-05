-- Max distance to draw the screen.

EggrollPoliceSystem.Config.MaxDrawDist = 512

-- Which ranks should be allowed to save/un-save/update permanently saved devices? This option will only work with CAMI compatible permission systems. If no compatible permission systems are found, the addon will check if the user is a superadmin.

EggrollPoliceSystem.Config.SavedDevicesPermissions = {
	"superadmin",
	"owner"
}

-- Can a person who does not hold a civil protection job be allowed to access a police computer? -- Setting this to true will allow a person who does not hold a civil protection job to have full access to a police computer, including the ability to scan fingerprints, create memos, and look up records.

EggrollPoliceSystem.Config.CanNonCopAccessPoliceComputer = false

-- Distance before a person is logged out of the police computer automatically.

EggrollPoliceSystem.Config.DistanceBeforePoliceComputerLogout = 200

-- Which jobs should be displayed in the police computer records for a person. If the job is not listed here, it will be listed as "Unknown" in the police computer records program. Enter "CP" for all civil protection jobs or "all" for all jobs. All other jobs should be entered with "TEAM_[WhateverJob]". Example: "TEAM_GUN". Don't forget the commas between entries.

EggrollPoliceSystem.Config.JobsToDisplayInRecords = {
	[ "CP" ] = true,
}

-- Minimum arrest time for the improved arrest baton in seconds.

EggrollPoliceSystem.Config.ArrestBatonMinArrestTime = 60

-- Maximum arrest time for the improved arrest baton in seconds.

EggrollPoliceSystem.Config.ArrestBatonMaxArrestTime = 500

-- Arrest GUI timeout time for the improved arrest baton in seconds. (This is here so a player cannot just freeze another player indefinitely by leaving the menu open.)

EggrollPoliceSystem.Config.ArrestBatonGUITimeout = 60

-- Arrest baton cooldown in seconds. Set to 0 to disable. Cooldown starts from when the baton starts swinging. (This is here to help mitigate baton rushing.)

EggrollPoliceSystem.Config.ArrestBatonCooldown = 0

-- How far can a cop be from a player to handcuff/un-handcuff them?

EggrollPoliceSystem.Config.MaxHandcuffDistance = 90

-- How long should it take to handcuff a player?

EggrollPoliceSystem.Config.TimeToHandcuff = 2

-- Should the player be able to "use" anything with the USE key while handcuffed?

EggrollPoliceSystem.Config.CanUseWhileHandcuffed = false

--[[

To add to config:

- Need to implement MaxDrawDist, only a config option right now.

- Enable citation system.

- Enable warning system.

- Distance of fingerprint scanner link.

- Who has access to removing all memos including ones not created by them? (default to "TEAM_MAYOR") (Do something similar to EggrollPoliceSystem.Config.JobsToDisplayInRecords for this.)

- Give handcuffs to cops?

- Must handcuff before arrest?

- Replace regular arrest batons with improved arrest batons automatically?

- Can a non-cop access ALPR in a car? Can a access a police computer in a car?

- Manual adding police cars by vehicle/entity names. Make sure they understand any police cars recognized by VCMod are already added if they have VCMod.

- Make fingerprint scanners buyable by cops. Tell the configurator that if set to false, the only way to get them is to place them and make them permanent on the map.

- Radius of a fingerprint scanner's signal.

- Should ALPR display the driver of the vehicle in front? Should ALPR display all of the non-driver passengers of the vehicle in front?

- Which key to press to exit out of police computer DTextEntries?

- Colors for backgrounds, text, etc.

- Localization Stuff

]]
