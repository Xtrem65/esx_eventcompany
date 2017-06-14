local Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57, 
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177, 
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70, 
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

local PlayerData                  = {}
local GUI                         = {}
GUI.Time                          = 0
local hasAlreadyEnteredMarker     = false;
local lastZone                    = nil;

AddEventHandler('playerSpawned', function(spawn)
	TriggerServerEvent('bespinevents:requestPlayerData', 'playerSpawned')
end)

RegisterNetEvent('esx_phone:loaded')
AddEventHandler('esx_phone:loaded', function(phoneNumber, contacts)
	if (Config.HasEmergencyPhoneLine)then
		TriggerEvent('esx_phone:addContact', Config.CompanyName, Config.CompanyName, 'special', false)
	end
end)

AddEventHandler('bespinevents:hasEnteredMarker', function(zone)

	if zone == 'CloakRoom' then
		SendNUIMessage({
			showControls = true,
			controls     = 'cloakroom'
		})
	end

	if zone == 'VehicleSpawner' then
		if (isInService())then
			SendNUIMessage({
				showControls = true,
				controls     = 'vehiclespawner'
			})
		else
			TriggerEvent('esx:showNotification', 'Vous devez prendre votre service')
		end
	end

	if zone == 'VehicleDeleter' then
		if (isInService())then
			local playerPed = GetPlayerPed(-1)

			if IsPedInAnyVehicle(playerPed, 0) then
				DeleteVehicle(GetVehiclePedIsIn(playerPed, 0))
			end
		else
			TriggerEvent('esx:showNotification', 'Vous devez prendre votre service')
		end
	end
end)

AddEventHandler('bespinevents:hasExitedMarker', function(zone)
	SendNUIMessage({
		showControls = false,
		showMenu     = false,
	})
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
end)

RegisterNetEvent('bespinevents:responsePlayerData')
AddEventHandler('bespinevents:responsePlayerData', function(data, reason)
	PlayerData = data
end)

RegisterNUICallback('select', function(data, cb)
		if data.menu == 'cloakroom' then

			if data.val == 'citizen_wear' then
                TriggerServerEvent("updateJob", "unemployed", 0)
				TriggerEvent('esx_skin:loadSkin', PlayerData.skin)
			end

			if data.val == 'job_wear' then
                local grade = 0 -- Par défaut : Grade 0
                for k,v in pairs(Config.AllowedUsers) do
                    if (v.identifier == PlayerData.identifier) then
                        grade = v.grade
                    end
                end
                TriggerServerEvent("updateJob", Config.JobName, grade)

				if PlayerData.skin.sex == 0 then

					TriggerEvent('esx_skin:loadJobSkin', PlayerData.skin, json.decode(Config.MaleSkin[tostring(grade)]))
				else
					TriggerEvent('esx_skin:loadJobSkin', PlayerData.skin, json.decode(Config.FemaleSkin[tostring(grade)]))
				end
			end

		end

		if data.menu == 'vehiclespawner' then

	    local playerPed = GetPlayerPed(-1)

			Citizen.CreateThread(function()

				local coords       = Config.Zones.VehicleSpawnPoint.Pos
				local vehicleModel = GetHashKey(data.val)

				RequestModel(vehicleModel)

				while not HasModelLoaded(vehicleModel) do
					Citizen.Wait(0)
				end

				if not IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 5.0) then
					local vehicle = CreateVehicle(vehicleModel, coords.x, coords.y, coords.z, coords.rotation, true, false)
					SetVehicleHasBeenOwnedByPlayer(vehicle,  true)
					SetEntityAsMissionEntity(vehicle,  true,  true)
					local id = NetworkGetNetworkIdFromEntity(vehicle)
					SetNetworkIdCanMigrate(id, true)
					TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
				end

			end)

			SendNUIMessage({
				showControls = false,
				showMenu     = false,
			})

		end
		cb('ok')

end)

RegisterNUICallback('select_control', function(data, cb)
		cb('ok')

end)
function isAllowed()
	if Config.AllowListedUsersOnly == true then
		for k,v in pairs(Config.AllowedUsers) do
			if (v.identifier == PlayerData.identifier) then
				return  true
			end
		end
		return false
	end
	return true
end
function isInService()
	if PlayerData.job ~= nil and PlayerData.job.name == Config.JobName then
		return true
	else
		return false
	end
end

-- Display markers
Citizen.CreateThread(function()
    while (PlayerData.identifier == nil) do
        Wait(100)
    end
    local allowed_player = isAllowed()

	while true do
		
		Wait(0)
		
		local coords = GetEntityCoords(GetPlayerPed(-1))
		
		for k,v in pairs(Config.Zones) do

			if(allowed_player and v.Type ~= -1 and GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < Config.DrawDistance) then
				DrawMarker(v.Type, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g, v.Color.b, 100, false, true, 2, false, false, false, false)
			end
		end

	end
end)

-- Display markers
Citizen.CreateThread(function()
    while (PlayerData.identifier == nil) do
        Wait(100)
    end
	while true do
		Wait(0)
		if isInService() and IsControlPressed(0, Keys['F6']) and (GetGameTimer() - GUI.Time) > 300 then

			SendNUIMessage({
				showControls = false,
				showMenu     = true,
				menu         = 'actions'
			})

			GUI.Time = GetGameTimer()

		end
	end
end)


--freeze_object permet d'éviter que l'objet de bouge (et tombe dans le vide... utile pour certains modeles)
function spawn_object(model_name, freeze_object)

	local x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))
	local objectHash = GetHashKey(model_name)
	local rotation = GetEntityRotation(GetPlayerPed(-1), true)

	RequestModel(objectHash)
	while not HasModelLoaded(objectHash) do
		Wait(1)
	end

	--Aucune conviction pour le "true, true, true"
	local object = CreateObject(objectHash, x, y+0.5, z-0.9, true, true, true)
	if object then
		--On essaie de rendre les objets spawnés durables.
		SetEntityAsMissionEntity(object, 1, 1)
		local id = NetworkGetNetworkIdFromEntity(object)
		SetNetworkIdCanMigrate(id, true)

		SetEntityRotation(object, rotation, 2, true)
		if(freeze_object)then
			FreezeEntityPosition(object, true)
		end
	end
end
function remove_object(model_name)
	local coords = GetEntityCoords(GetPlayerPed(-1), true)

	local object_name = model_name
	local objectHash = GetHashKey(object_name)

	RequestModel(objectHash)
	while not HasModelLoaded(objectHash) do
		Wait(1)
	end
	local object = GetClosestObjectOfType(coords, 10.0, objectHash, false, false, false)
	SetEntityAsMissionEntity(object, 1, 1)
	DeleteEntity(object)
end

RegisterNUICallback('select', function(data, cb)
	if data.menu == 'actions' then
		if data.val == 'add_plot' then
			spawn_object("prop_roadcone01a", false)

			SendNUIMessage({
				showControls = false,
				showMenu     = false,
			})
		end
		if data.val == 'delete_plot' then
			remove_object("prop_roadcone01a")
			SendNUIMessage({
				showControls = false,
				showMenu     = false,
			})
		end
		if data.val == 'add_barrier' then
			spawn_object("prop_barriercrash_03", true)

			SendNUIMessage({
				showControls = false,
				showMenu     = false,
			})
		end
		if data.val == 'delete_barrier' then
			remove_object("prop_barriercrash_03")
			SendNUIMessage({
				showControls = false,
				showMenu     = false,
			})
		end
		if data.val == 'add_tremplin' then
			spawn_object("prop_jetski_ramp_01", true)

			SendNUIMessage({
				showControls = false,
				showMenu     = false,
			})
		end
		if data.val == 'remove_tremplin' then
			remove_object("prop_jetski_ramp_01")
			SendNUIMessage({
				showControls = false,
				showMenu     = false,
			})
		end
	end
end)

-- Activate menu when player is inside marker
Citizen.CreateThread(function()
    while (PlayerData.identifier == nil) do
        Wait(100)
    end
	local allowed_player = isAllowed()

	while true do
		Wait(0)
		if(allowed_player) then

			local coords      = GetEntityCoords(GetPlayerPed(-1))
			local isInMarker  = false
			local currentZone = nil

			for k,v in pairs(Config.Zones) do
				if(GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < v.Size.x) then
					isInMarker  = true
					currentZone = k
				end
			end

			if isInMarker and not hasAlreadyEnteredMarker then
				hasAlreadyEnteredMarker = true
				lastZone                = currentZone
				TriggerEvent('bespinevents:hasEnteredMarker', currentZone)
			end

			if not isInMarker and hasAlreadyEnteredMarker then
				hasAlreadyEnteredMarker = false
				TriggerEvent('bespinevents:hasExitedMarker', lastZone)
			end

		end

	end
end)

-- Create blips
Citizen.CreateThread(function()
	local blip = AddBlipForCoord(Config.Zones.Entreprise.Pos.x, Config.Zones.Entreprise.Pos.y, Config.Zones.Entreprise.Pos.z)

  	SetBlipSprite (blip, Config.Zones.Entreprise.BlipSprite)
  	SetBlipDisplay(blip, 4)
  	SetBlipScale  (blip, 1.2)
  	SetBlipColour (blip, 5)
  	SetBlipAsShortRange(blip, true)
	BeginTextCommandSetBlipName("STRING")
  	AddTextComponentString(Config.CompanyName)
  	EndTextCommandSetBlipName(blip)

end)

-- Menu Controls
Citizen.CreateThread(function()
	while (PlayerData.identifier == nil) do
        Wait(100)
    end
    local allowed_player = isAllowed()
	while true do

		Wait(0)

		if allowed_player and IsControlPressed(0, Keys['F10']) then
			spawn_object("prop_jetski_ramp_01", true)
			Wait(1000)
		end
		if allowed_player and IsControlPressed(0, Keys['F2']) then
			remove_object("prop_jetski_ramp_01")
			Wait(1000)
		end

		if IsControlPressed(0, Keys['ENTER']) and (GetGameTimer() - GUI.Time) > 300 then

			SendNUIMessage({
				enterPressed = true
			})

			GUI.Time = GetGameTimer()

		end

		if IsControlPressed(0, Keys['BACKSPACE']) and (GetGameTimer() - GUI.Time) > 300 then

			SendNUIMessage({
				backspacePressed = true
			})

			GUI.Time = GetGameTimer()

		end

		if IsControlPressed(0, Keys['LEFT']) and (GetGameTimer() - GUI.Time) > 300 then

			SendNUIMessage({
				move = 'LEFT'
			})

			GUI.Time = GetGameTimer()

		end

		if IsControlPressed(0, Keys['RIGHT']) and (GetGameTimer() - GUI.Time) > 300 then

			SendNUIMessage({
				move = 'RIGHT'
			})

			GUI.Time = GetGameTimer()

		end

		if IsControlPressed(0, Keys['TOP']) and (GetGameTimer() - GUI.Time) > 300 then

			SendNUIMessage({
				move = 'UP'
			})

			GUI.Time = GetGameTimer()

		end

		if IsControlPressed(0, Keys['DOWN']) and (GetGameTimer() - GUI.Time) > 300 then

			SendNUIMessage({
				move = 'DOWN'
			})

			GUI.Time = GetGameTimer()

		end

	end
end)