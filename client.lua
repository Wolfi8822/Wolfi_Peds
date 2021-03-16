ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

RegisterCommand('fixped', function()
	ESX.TriggerServerCallback('arivi:peds', function(informacje)
		if informacje ~= nil then
			stfuszpeda(informacje)
		end		
	end)
end)

TriggerEvent('chat:addSuggestion', '/dajpeda', 'Nadaje peda graczu.')
TriggerEvent('chat:addSuggestion', '/fixped', 'Ładuje peda.')
TriggerEvent('chat:addSuggestion', '/usunpeda', 'Usuwa peda graczu.')

function stfuszpeda(informacje)
	local pedau = informacje.pedmodel
	if pedau ~= nil then
		hashpeda = GetHashKey(pedau)
		if IsModelValid(hashpeda) then
			if not HasModelLoaded(hashpeda) then
				RequestModel(hashpeda)
				while not HasModelLoaded(hashpeda) do
					Citizen.Wait(5)
				end
			end

			SetPlayerModel(PlayerId(), hashpeda)
			SetModelAsNoLongerNeeded(hashpeda)

			Citizen.Wait(100)

			if not tonumber(informacje.randomized) then
				SetPedRandomProps(GetPlayerPed(-1))
				SetPedRandomComponentVariation(GetPlayerPed(-1), true)
				TriggerEvent('skinchanger:getSkin', function(skin)
					TriggerServerEvent('esx_skin:save', skin)
				end)
				TriggerServerEvent('arivi:zapisz')
			else
				ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin, height)
					TriggerEvent('skinchanger:loadSkin', skin)
				end)
			end
		end
	end
end

RegisterNetEvent('funkcja')
AddEventHandler('funkcja', function(source)
	TriggerEvent('esx:showNotification', playerId, "Poczekaj 50 sekund na załadowanie peda!")
	Citizen.Wait(50000)
	ESX.TriggerServerCallback('arivi:peds', function(result)
		if result ~= nil then
			stfuszpeda(result)
		end		
	end)
	print("[AriviRP] Load Udany")
end)
