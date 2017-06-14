require "resources/[essential]/es_extended/lib/MySQL"
MySQL:open("127.0.0.1", "gta5_gamemode_essential", "root", "1202")

RegisterServerEvent('bespinevents:requestPlayerData')
AddEventHandler('bespinevents:requestPlayerData', function(reason)
	TriggerEvent('esx:getPlayerFromId', source, function(xPlayer)
		TriggerEvent('esx_skin:requestPlayerSkinInfosCb', source, function(skin, jobSkin)

			local data = {
				identifier = xPlayer.identifier,
				job       = xPlayer.job,
				inventory = xPlayer.inventory,
				skin      = skin
			}

			TriggerClientEvent('bespinevents:responsePlayerData', source, data, reason)
		end)
	end)
end)

RegisterServerEvent('bespinevents:requestPlayerPositions')
AddEventHandler('bespinevents:requestPlayerPositions', function(reason)
	
	local _source = source

	TriggerEvent('esx:getPlayers', function(xPlayers)

		local positions = {}

		for k, v in pairs(xPlayers) do
			positions[tostring(k)] = v.player.coords
		end

		TriggerClientEvent('bespinevents:responsePlayerPositions', _source, positions, reason)

	end)

end)
--[[
TriggerEvent('esx_phone:registerCallback', 'special', function(source, phoneNumber, playerName, type, message)

	--Remplacer par le contenu de Config.CompanyName
	if phoneNumber == '<default>' then

		TriggerEvent('esx:getPlayerFromId', source, function(xPlayer)
			TriggerEvent('esx:getPlayers', function(xPlayers)
				for k, v in pairs(xPlayers) do
					--Remplacer par le job name
					if v.job.name == '<jobname>' then
						RconPrint('Message => ' .. playerName .. ' ' .. message)
						TriggerClientEvent('esx_phone:onMessage', v.player.source, xPlayer.phoneNumber, playerName, type, message, xPlayer.player.coords, {reply = 'Répondre', gps = 'GPS'})
					end
				end
			end)
		end)

	end
end)]]