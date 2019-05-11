ESX = nil
local cooldown = 0

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback('Lenzh_chopshop:isCooldown',function(source, cb)
    cb(cooldown)
end)

RegisterServerEvent("lenzh_chopshop:rewards")
AddEventHandler("lenzh_chopshop:rewards", function()
    Rewards()
    --Add cooldown
    cooldown = Config.CooldownMinutes * 60000 --DO NOT EDIT
end)

function Rewards(rewards)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return; end
    for k,v in pairs(Config.Items) do
        local randomCount = math.random(0, 3)
        xPlayer.addInventoryItem(v, randomCount)
    end
end

RegisterServerEvent('chopNotify')
AddEventHandler('chopNotify', function()
    TriggerClientEvent("chopEnable", source)
end)


RegisterServerEvent('ChopInProgress')
AddEventHandler('ChopInProgress', function(street1, street2, sex)
    TriggerClientEvent("outlawNotify", -1, "")
end)


RegisterServerEvent('ChopInProgressS1')
AddEventHandler('ChopInProgressS1', function(street1, sex)
    TriggerClientEvent("outlawNotify", -1, "")

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

--Cooldown manager
AddEventHandler('onResourceStart', function(resource)
    while true do
        Wait(5000)
        if cooldown > 0 then
            cooldown = cooldown - 5000
        end
    end
end)
