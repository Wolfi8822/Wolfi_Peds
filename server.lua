ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback('arivi:peds', function(source, cb)
	local stykamsieztobomchujem = source
	local xPlayer = ESX.GetPlayerFromId(stykamsieztobomchujem)
	if xPlayer ~= nil then
		MySQL.Async.fetchAll('SELECT * FROM arivi_peds WHERE identifier = @identifier', {
			['@identifier'] = xPlayer.identifier,
		}, function(result)
			if result[1] ~= nil then
				cb(result[1])
			else
				cb(nil)
			end
		end)
	else
		cb(nil)
	end
end)

RegisterCommand('usunpeda', function(playerId, args, rawCommand)
    local xPlayer = ESX.GetPlayerFromId(playerId)
    local xTarget = ESX.GetPlayerFromId(tonumber(args[1]))
    if xPlayer.getGroup() ~= 'superadmin' then
        if xTarget ~= nil then
            MySQL.Async.fetchAll('SELECT * FROM arivi_peds WHERE identifier = @identifier', {
                ['@identifier'] = xTarget.identifier,
            }, function(result)
                if result[1] ~= nil then
                    MySQL.Async.fetchAll('DELETE FROM arivi_peds WHERE identifier = @identifier',{['@identifier'] = xTarget.identifier})
                    TriggerClientEvent('esx:showNotification', playerId, "Pomyślnie zabrano peda graczu!")
                    TriggerClientEvent('esx:showNotification', playerId, "Zabrano Ci peda, zrób reloga!")
                else 
                    TriggerClientEvent('esx:showNotification', playerId, "Ta osoba nie ma peda!")
                end
            end)
        else
            TriggerClientEvent('esx:showNotification', playerId, "Podane ID jest offline!")
        end
    else 
        TriggerClientEvent('esx:showNotification', playerId, "Nie posiadasz wystarczających permisji!")
    end
end, false)

RegisterCommand('dajpeda', function(playerId, args, rawCommand)
    local xPlayer = ESX.GetPlayerFromId(playerId)
    if xPlayer.getGroup() ~= 'superadmin' then
        local xTarget = ESX.GetPlayerFromId(tonumber(args[1]))
        local stringmodelu = args[2]
        if xTarget ~= nil then
            if stringmodelu ~= nil then
                MySQL.Async.fetchAll('SELECT * FROM arivi_peds WHERE identifier = @identifier', {
                    ['@identifier'] = xTarget.identifier,
                }, function(kurwiklak)
                    if kurwiklak[1] == nil then
                        MySQL.Async.execute('INSERT INTO arivi_peds (identifier, pedmodel) VALUES (@identifier, @pedmodel)', {
                            ['@identifier'] = xTarget.identifier,
                            ['@pedmodel'] = stringmodelu
                        })
                        TriggerClientEvent('esx:showNotification', playerId, "Pomyślnie nadano peda danemu graczu!")
                        TriggerClientEvent('esx:showNotification', xTarget.source, "Dostałeś peda, zrób reloga.")
                    else
                        TriggerClientEvent('esx:showNotification', xTarget.source, "Ta osoba ma już peda.")
                    end
                end)
            else
                TriggerClientEvent('esx:showNotification', xTarget.source, "Wpisz drugi argument!")
            end
        else
            TriggerClientEvent('esx:showNotification', xTarget.source, "Podane ID jest offline!")
        end
    else 
        TriggerClientEvent('esx:showNotification', playerId, "Nie posiadasz wystarczających permisji!")
    end
end, false)

RegisterServerEvent('arivi:zapisz')
AddEventHandler('arivi:zapisz', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	MySQL.Async.fetchAll('SELECT * FROM arivi_peds WHERE identifier = @identifier', {['@identifier'] = xPlayer.identifier}, function(result2)
		if result2[1] ~= nil then
			MySQL.Async.execute('UPDATE arivi_peds SET randomized = @randomized WHERE identifier = @identifier',{['@randomized'] = true, ['@identifier'] = xPlayer.identifier})
		end
	end)
end)

AddEventHandler('esx:playerLoaded', function(source)
    TriggerClientEvent('funkcja', source)
end)