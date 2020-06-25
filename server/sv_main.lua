ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback('Lenzh_chopshop:anycops',function(src, cb)
    local anycops = 0
    local playerList = GetPlayers()
    for i=1, #playerList, 1 do
        local _source = playerList[i]
        local xPlayer = ESX.GetPlayerFromId(_source)
        local playerjob = xPlayer.job.name

        if playerjob == 'police' then
            anycops = anycops + 1
        end
    end
    cb(anycops)
end)

RegisterServerEvent('Lenzh_chopshop:NotifPos')
AddEventHandler('Lenzh_chopshop:NotifPos', function(targetCoords)
    TriggerClientEvent('Lenzh_chopshop:NotifPosProgress', -1, targetCoords)
end)



RegisterServerEvent("Lenzh_chopshop:ChopRewards")
AddEventHandler("Lenzh_chopshop:ChopRewards", function(rewards)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    for i= 1, 3, 1 do
        local chance = math.random(1, #Config.Items)
        local amount = math.random(1,3)
        local myItem = Config.Items[chance]

        if xPlayer.canCarryItem(myItem, amount) then
            xPlayer.addInventoryItem(myItem, amount)
            TriggerClientEvent('esx:showNotification', source, '~g~Rewards has been given!')
        else
            TriggerClientEvent('esx:showNotification', source, '~r~You cant carry anymore!')
        end
    end
end)

ESX.RegisterServerCallback('Lenzh_chopshop:OwnedCar', function(source, cb, plate, owner)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    MySQL.Async.fetchAll("SELECT * FROM owned_vehicles WHERE plate=@plate AND owner=@identifier",{['@identifier'] = xPlayer.getIdentifier(), ['@plate'] = plate}, function(result)
        if result[1] and Config.AnyoneCanChop == true then
            print("Vehicle is owned")
            cb(result[1].owner == xPlayer.getIdentifier())
            Citizen.Wait(5)
            MySQL.Async.execute('DELETE FROM owned_vehicles WHERE plate = @plate', {
                ['@plate'] = plate
            })
            print('deleted = ' ..plate)
        else
            cb(false)
            print("Not owned")
        end
    end)
end)

RegisterServerEvent('Lenzh_chopshop:sell')
AddEventHandler('Lenzh_chopshop:sell', function(itemName, amount)
    local xPlayer = ESX.GetPlayerFromId(source)
    local price = Config.ItemsPrices[itemName]
    local xItem = xPlayer.getInventoryItem(itemName)

    if xItem.count < amount then
        TriggerClientEvent('esx:showNotification', source, _U('not_enough'))
        return
    end

    price = ESX.Math.Round(price * amount)
    if Config.GiveBlack then
        xPlayer.addAccountMoney('black_money', price)
    else
        xPlayer.addMoney(price)
    end

    xPlayer.removeInventoryItem(xItem.name, amount)

    TriggerClientEvent('esx:showNotification', source, _U('sold', amount, xItem.label, ESX.Math.GroupDigits(price)))
end)

RegisterServerEvent('Lenzh_chopshop:GetPlayerID')
AddEventHandler('Lenzh_chopshop:GetPlayerID', function(serverid)
    _source  = source
    xPlayer  = ESX.GetPlayerFromId(_source)
    local xPlayers = ESX.GetPlayers()
    for i=1, #xPlayers, 1 do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        if xPlayer.job.name == 'police' then
            TriggerClientEvent('Lenzh_chopshop:StartNotifyPD', xPlayers[i], serverid)
        end
    end
end)
