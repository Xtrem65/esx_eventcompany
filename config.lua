Config                           = {}
Config.DrawDistance              = 100.0

Config.CompanyName = "Bespin Events"
Config.HasEmergencyPhoneLine = false
Config.JobName = "events"

Config.AllowListedUsersOnly = true

Config.AllowedUsers = {
	{identifier="steam:110000101a6fc7e", grade=1},
	{identifier="steam:110000101eda301", grade=3}, --Maximilan Daulnay
	{identifier="steam:110000101fb3988", grade=4},
	{identifier="steam:1100001047c07d7", grade=3}, -- Jean Lapiece
	{identifier="steam:11000010e7887ad", grade=5},
}
Config.MaleSkin = {
	['0'] = '{"tshirt_1":59, "tshirt_2":0}',
	['1'] = '{"tshirt_1":59, "tshirt_2":0}',
	['2'] = '{"tshirt_1":118,"tshirt_2":0, "pants_1":59,"pants_2":0, "helmet_1":53}',
	['3'] = '{"tshirt_1":118,"tshirt_2":0, "pants_1":59,"pants_2":0, "helmet_1":19}',
	['4'] = '{"tshirt_1":59,"tshirt_2":1}',
	['5'] = '{"tshirt_1":59,"tshirt_2":1}'
}
Config.FemaleSkin = {
	['0'] = '{"tshirt_1":59, "tshirt_2":0}',
	['1'] = '{"tshirt_1":59, "tshirt_2":0}',
	['2'] = '{"tshirt_1":118,"tshirt_2":0, "pants_1":59,"pants_2":0, "helmet_1":53}',
	['3'] = '{"tshirt_1":118,"tshirt_2":0, "pants_1":59,"pants_2":0, "helmet_1":19}',
	['4'] = '{"tshirt_1":59,"tshirt_2":1}',
	['5'] = '{"tshirt_1":59,"tshirt_2":1}'
}

Config.Zones = {

	Entreprise = {
		Pos   = {x = -1042.98, y = -228.897, z = 38.0139},
		Size  = {x = 1.5, y = 1.5, z = 1.0},
		Type  = -1,
		BlipSprite = 304
	},

	CloakRoom = {
		Pos   = {x = -1044.23, y = -237.832, z = 36.965},
		Size  = {x = 1.5, y = 1.5, z = 1.0},
		Color = {r = 204, g = 204, b = 0},
		Type  = 1
	},

	VehicleSpawner = {
		Pos   = {x = -1095.48, y = -260.466, z = 36.6937},
		Size  = {x = 1.5, y = 1.5, z = 1.0},
		Color = {r = 204, g = 204, b = 0},
		Type  = 1
	},

	VehicleSpawnPoint = {
		Pos   = {x = -1099.51, y = -264.26, z = 36.6607, rotation=180.0},
		Size  = {x = 1.5, y = 1.5, z = 1.0},
		Type  = -1
	},

	VehicleDeleter = {
		Pos   = {x = -1096.79, y = -255.189, z = 36.6842},
		Size  = {x = 1.5, y = 1.5, z = 1.0},
		Color = {r = 204, g = 204, b = 0},
		Type  = 1
	}

}
