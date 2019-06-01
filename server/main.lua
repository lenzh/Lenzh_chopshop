ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterCommand('chop', function(source)
    TriggerClientEvent('getList', source)
end)

ESX.RegisterServerCallback('_getList', function(source, cb, _vehicle)
    local message = 'you still need these vehicles: ^6'
    if next(_vehicle) ~= nil then
        for k,v in pairs(_vehicle) do
            message = message .. " ^6" .. v .."^7,"
        end
        TriggerClientEvent('chatMessage', source, message)
    else
        TriggerClientEvent('chatMessage', source, 'You don\'t have any ^7target^6 vehicles.')
    end
    cb()
end)

RegisterServerEvent("lenzh_chopshop:rewards")
AddEventHandler("lenzh_chopshop:rewards", function(rewards)
    --Rewards()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    if not xPlayer then return; end
    for k,v in pairs(Config.Items) do
        local randomCount = math.random(0, 3)
        xPlayer.addInventoryItem(v, randomCount)
    end
end)

ESX.RegisterServerCallback('lenzh_chopshop:getOrders', function(source, cb, _table)
    local _source = source
    if next(_table) == nil then
        local _vehicle = {}
        for i = 1, 5, 1 do
            table.insert(_vehicle, Config.vehicles[math.random(#Config.vehicles)])
        end
        local message = 'Yo dawg, find these vehicles for me: ^6'.._vehicle[1].."^7,^6 ".._vehicle[2].."^7,^6 ".._vehicle[3].."^7,^6 ".._vehicle[4].."^7,^6 ".._vehicle[5]
        TriggerClientEvent('chatMessage', source, message)
        cb(_vehicle)
    else
        TriggerClientEvent('esx:showNotification', source, 'You already have a list.')
    end
end)
--[[ function Rewards(rewards)
local xPlayer = ESX.GetPlayerFromId(source)
if not xPlayer then return; end
for k,v in pairs(Config.Items) do
    local randomCount = math.random(0, 3)
    xPlayer.addInventoryItem(v, randomCount)
end
end ]]

RegisterServerEvent('chopNotify')
AddEventHandler('chopNotify', function()
    TriggerClientEvent("chopEnable", source)
end)


RegisterServerEvent('ChopInProgress')
AddEventHandler('ChopInProgress', function(street1, street2, sex)
    TriggerClientEvent("outlawChopNotify", -1, "")
end)


RegisterServerEvent('ChopInProgressS1')
AddEventHandler('ChopInProgressS1', function(street1, sex)
    TriggerClientEvent("outlawChopNotify", -1, "")

end)

RegisterServerEvent('ChoppingInProgressPos')
AddEventHandler('ChoppingInProgressPos', function(gx, gy, gz)
    TriggerClientEvent('Choplocation', -1, gx, gy, gz)
end)


RegisterServerEvent('lenzh_chopshop:sell')
AddEventHandler('lenzh_chopshop:sell', function(itemName, amount)
    local xPlayer = ESX.GetPlayerFromId(source)
    local price = Config.Itemsprice[itemName]
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
