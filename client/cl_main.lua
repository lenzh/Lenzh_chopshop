ESX = nil
local PlayerData, Timer, HasAlreadyEnteredMarker, ChoppingInProgress, LastZone, isDead, pedIsTryingToChopVehicle, menuOpen  = {}, 0, false, false, nil, false, false, false
local CurrentAction, CurrentActionMsg, CurrentActionData, menuOpen, isPlayerWhitelisted  = nil, '', {}, false, false
local timing = math.ceil(Config.Timer * 60000)

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end

    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(10)
    end

    PlayerData = ESX.GetPlayerData()

    isPlayerWhitelisted = refreshPlayerWhitelisted()

end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    ESX.PlayerData.job = job

    isPlayerWhitelisted = refreshPlayerWhitelisted()
end)

AddEventHandler('esx:onPlayerDeath', function(data)
    isDead = true
    ESX.UI.Menu.CloseAll()
end)

function IsDriver()
    return GetPedInVehicleSeat(GetVehiclePedIsIn(PlayerPedId(), false), - 1) == PlayerPedId()
end

function MaxSeats(vehicle)
    local vehpas = GetVehicleNumberOfPassengers(vehicle)
    return vehpas
end


AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        if menuOpen then
            ESX.UI.Menu.CloseAll()
        end
    end
end)

function refreshPlayerWhitelisted()

    if not ESX.PlayerData then
        return false
    end

    if not ESX.PlayerData.job then
        return false
    end

    for k,v in ipairs(Config.WhitelistedCops) do
        if v == ESX.PlayerData.job.name then
            return true
        end
    end

    return false
end


-- Display Marker
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5)
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        local letSleep = true

        for k,v in pairs(Config.Zones) do
            local distance = GetDistanceBetweenCoords(playerCoords, v.Pos.x, v.Pos.y, v.Pos.z, true)
            if Config.MarkerType ~= -1 and distance < Config.DrawDistance then
                DrawMarker(Config.MarkerType, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, nil, nil, false)
                letSleep = false
            end

        end
        if letSleep then
            Citizen.Wait(500)
        end
    end
end)

function CreateBlipCircle(coords, text, radius, color, sprite)

    local blip = AddBlipForCoord(coords)
    SetBlipSprite(blip, sprite)
    SetBlipColour(blip, color)
    SetBlipScale(blip, 0.8)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(text)
    EndTextCommandSetBlipName(blip)
end

Citizen.CreateThread(function()
    if Config.EnableBlips == true then
        for k,zone in pairs(Config.Zones) do
            CreateBlipCircle(zone.coords, zone.name, zone.radius, zone.color, zone.sprite)
        end
    end
end)

-- Enter / Exit marker events
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)

        local isInMarker  = false
        local currentZone = nil
        local letSleep = true
        for k,v in pairs(Config.Zones) do
            local distance = GetDistanceBetweenCoords(playerCoords, v.Pos.x, v.Pos.y, v.Pos.z, true)
            if distance < v.Size.x then
                isInMarker  = true
                currentZone = k
            end

        end
        if (isInMarker and not HasAlreadyEnteredMarker) or (isInMarker and LastZone ~= currentZone) then
            HasAlreadyEnteredMarker = true
            LastZone                = currentZone
            TriggerEvent('Lenzh_chopshop:hasEnteredMarker', currentZone)
        end

        if not isInMarker and HasAlreadyEnteredMarker then
            HasAlreadyEnteredMarker = false
            TriggerEvent('Lenzh_chopshop:hasExitedMarker', LastZone)
        end
    end
end)

AddEventHandler('Lenzh_chopshop:hasEnteredMarker', function(zone)
    if zone == 'Chopshop' and IsDriver() then
        CurrentAction     = 'Chopshop'
        CurrentActionMsg  = _U('press_to_chop')
        CurrentActionData = {}
    elseif zone == 'StanleyShop' then
        CurrentAction     = 'StanleyShop'
        CurrentActionMsg  = _U('open_shop')
        CurrentActionData = {}
    end
end)

AddEventHandler('Lenzh_chopshop:hasExitedMarker', function(zone)
    if menuOpen then
        ESX.UI.Menu.CloseAll()
    end

    CurrentAction = nil
end)


-- Key controls
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if CurrentAction ~= nil then
            ESX.ShowHelpNotification(CurrentActionMsg, true, true)
            if IsControlJustReleased(0, 38) then
                if IsDriver() then
                    if CurrentAction == 'Chopshop' then
                        ChopVehicle()
                    end
                elseif CurrentAction == 'StanleyShop' then
                    OpenShopMenu()
                end
                CurrentAction = nil
            end
        else
            Citizen.Wait(500)
        end
    end
end)

Citizen.CreateThread(function()
    if Config.NPCEnable == true then
        RequestModel(Config.NPCHash)
        while not HasModelLoaded(Config.NPCHash) do
            Wait(1)
        end

        stanley = CreatePed(1, Config.NPCHash, Config.NPCShop.x, Config.NPCShop.y, Config.NPCShop.z, Config.NPCShop.h, false, true)
        SetBlockingOfNonTemporaryEvents(stanley, true)
        SetPedDiesWhenInjured(stanley, false)
        SetPedCanPlayAmbientAnims(stanley, true)
        SetPedCanRagdollFromPlayerImpact(stanley, false)
        SetEntityInvincible(stanley, true)
        FreezeEntityPosition(stanley, true)
        TaskStartScenarioInPlace(stanley, "WORLD_HUMAN_CLIPBOARD", 0, true);
    else

        print('[Lenzh_chopshop: NPC is turned Off]')
    end
end)

function ChopVehicle()
    local seats = MaxSeats(vehicle)
    if seats ~= 0 then
        ESX.ShowNotification(_U("Cannot_Chop_Passengers"), false, true)
    elseif GetGameTimer() - Timer > Config.CooldownMinutes * 60000 then
        Timer = GetGameTimer()
        ESX.TriggerServerCallback('Lenzh_chopshop:anycops', function(anycops)
            if anycops >= Config.CopsRequired then
                if Config.CallCops then
                    local randomReport = math.random(1, Config.CallCopsPercent)

                    if randomReport == Config.CallCopsPercent then
                        --TriggerEvent('Lenzh_chopshop:StartNotifyPD')
                        serverid = GetPlayerServerId(PlayerId())
                        TriggerServerEvent('Lenzh_chopshop:GetPlayerID', serverid)
                        pedIsTryingToChopVehicle = true
                    end
                end
                local ped = PlayerPedId()
                local vehicle = GetVehiclePedIsIn( ped, false )
                ChoppingInProgress = true
                VehiclePartsRemoval()
                if not HasAlreadyEnteredMarker then
                    HasAlreadyEnteredMarker = true
                    ChoppingInProgress = false
                    ESX.ShowNotification(_U'ZoneLeft', false, true)

                    SetVehicleAlarmTimeLeft(vehicle, 60000)
                end
            else
                ESX.ShowNotification(_U('not_enough_cops'))
            end
        end)
    else
        local timerNewChop = Config.CooldownMinutes * 60000 - (GetGameTimer() - Timer)
        local TotalTime = math.floor(timerNewChop / 60000)
        if TotalTime >= 0 then
            ESX.ShowNotification("Comeback in " ..TotalTime.. " minute(s)")
        elseif TotalTime <= 0 then
            ESX.ShowNotification(_U('cooldown'.. TotalTime))
        end
    end
end

function VehiclePartsRemoval()
    local ped = PlayerPedId()
    local vehicle = GetVehiclePedIsIn( ped, false )
    local rearLeftDoor = GetEntityBoneIndexByName(GetVehiclePedIsIn(GetPlayerPed(-1), false), 'door_dside_r')
    local bonnet = GetEntityBoneIndexByName(GetVehiclePedIsIn(GetPlayerPed(-1), false), 'bonnet')
    local boot = GetEntityBoneIndexByName(GetVehiclePedIsIn(GetPlayerPed(-1), false), 'boot')
    SetVehicleEngineOn(vehicle, false, false, true)
    SetVehicleUndriveable(vehicle, false)
    if ChoppingInProgress == true then
        ESX.ShowNotification("Opening Front Left Door")
        Citizen.Wait(Config.RemovePart)
        SetVehicleDoorOpen(GetVehiclePedIsIn(ped, false), 0, false, false)
    end
    Citizen.Wait(1000)
    if ChoppingInProgress == true then
        ESX.ShowNotification("Removing Front Left Door")
        Citizen.Wait(Config.RemovePart)
        SetVehicleDoorBroken(GetVehiclePedIsIn(ped, false), 0, true)
    end
    Citizen.Wait(1000)
    if ChoppingInProgress == true then
        ESX.ShowNotification("Opening Front Right Door")
        Citizen.Wait(Config.RemovePart)
        SetVehicleDoorOpen(GetVehiclePedIsIn(ped, false), 1, false, false)
    end
    Citizen.Wait(1000)
    if ChoppingInProgress == true then
        ESX.ShowNotification("Removing Front Right Door")
        Citizen.Wait(Config.RemovePart)
        SetVehicleDoorBroken(GetVehiclePedIsIn(ped, false), 1, true)
    end
    Citizen.Wait(1000)
    if rearLeftDoor ~= -1 then
        if ChoppingInProgress == true then
            ESX.ShowNotification("Opening Rear Left Door")
            Citizen.Wait(Config.RemovePart)
            SetVehicleDoorOpen(GetVehiclePedIsIn(ped, false), 2, false, false)
        end
        Citizen.Wait(1000)
        if ChoppingInProgress == true then
            ESX.ShowNotification("Removing Rear Left Door")
            Citizen.Wait(Config.RemovePart)
            SetVehicleDoorBroken(GetVehiclePedIsIn(ped, false), 2, true)
        end
        Citizen.Wait(1000)
        if ChoppingInProgress == true then
            ESX.ShowNotification("Opening Rear Right Door")
            Citizen.Wait(Config.RemovePart)
            SetVehicleDoorOpen(GetVehiclePedIsIn(ped, false), 3, false, false)
        end
        Citizen.Wait(1000)
        if ChoppingInProgress == true then
            ESX.ShowNotification("Removing Rear Right Door")
            Citizen.Wait(Config.RemovePart)
            SetVehicleDoorBroken(GetVehiclePedIsIn(ped, false), 3, true)
        end
    end
    Citizen.Wait(1000)
    if bonnet ~= -1 then
        if ChoppingInProgress == true then
            ESX.ShowNotification("Opening Hood")
            Citizen.Wait(Config.RemovePart)
            SetVehicleDoorOpen(GetVehiclePedIsIn(ped, false), 4, false, false)
        end
        Citizen.Wait(1000)
        if ChoppingInProgress == true then
            ESX.ShowNotification("Removing Hood")
            Citizen.Wait(Config.RemovePart)
            SetVehicleDoorBroken(GetVehiclePedIsIn(ped, false),4, true)
        end
    end
    Citizen.Wait(1000)
    if boot ~= -1 then
        if ChoppingInProgress == true then
            ESX.ShowNotification("Opening Trunk")
            Citizen.Wait(Config.RemovePart)
            SetVehicleDoorOpen(GetVehiclePedIsIn(ped, false), 5, false, false)
        end
        Citizen.Wait(1000)
        if ChoppingInProgress == true then
            ESX.ShowNotification("Removing Trunk")
            Citizen.Wait(Config.RemovePart)
            SetVehicleDoorBroken(GetVehiclePedIsIn(ped, false),5, true)
        end
    end
    Citizen.Wait(1000)
    ESX.ShowNotification("Let John take care of the car if allowed!")
    Citizen.Wait(Config.RemovePart)
    if ChoppingInProgress == true then
        local vehicle =  GetVehiclePedIsIn( ped, false )
        if vehicle then
            local vehPlate = GetVehicleNumberPlateText(vehicle)
            ESX.TriggerServerCallback('Lenzh_chopshop:OwnedCar', function(owner)
                if owner then
                    ESX.ShowNotification("Your Personal Vehicle is Chopped Successfully...", false, true, g)
                    DeleteVehicle(vehicle)
                else
                    ESX.ShowNotification("Vehicle Chopped Successfully...", false, true, g)
                    DeleteVehicle(vehicle)
                end
            end, vehPlate)
        end
        TriggerServerEvent("Lenzh_chopshop:ChopRewards")
    end
end

function OpenShopMenu()
    local elements = {}
    menuOpen = true

    for k, v in pairs(ESX.GetPlayerData().inventory) do
        local price = Config.ItemsPrices[v.name]

        if price and v.count > 0 then
            table.insert(elements, {
                label = ('%s - <span style="color:green;">%s</span>'):format(v.label, _U('item', ESX.Math.GroupDigits(price))),
                name = v.name,
                price = price,

                -- menu properties
                type = 'slider',
                value = 1,
                min = 1,
                max = v.count
            })
        end
    end
    ESX.UI.Menu.CloseAll()
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'car_shop', {
        title    = _U('shop_title'),
        align    = 'right',
        elements = elements
    }, function(data, menu)

        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'shop_confirm', {
            title    = _U('shop_confirm', data.current.value, data.current.label_real, ESX.Math.GroupDigits(data.current.price * data.current.value)),
            align    = 'right',
            elements = {
                {label = _U('no'),  value = 'no'},
                {label = _U('yes'), value = 'yes'}
            }
        }, function(data2, menu2)
            if data2.current.value == 'yes' then
                TriggerServerEvent('Lenzh_chopshop:sell', data.current.name, data.current.value)
            end

            menu2.close()
        end, function(data2, menu2)
            menu2.close()
        end)
    end, function(data, menu)
        menu.close()
        menuOpen = false
        CurrentAction     = 'StanleyShop'
        CurrentActionMsg  = _U('open_shop')
        CurrentActionData = {}
    end)
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5)

        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)

        Citizen.Wait(3000)
        if pedIsTryingToChopVehicle then
            if (isPlayerWhitelisted and Config.ShowCopsMisbehave) or not isPlayerWhitelisted then
                DecorSetInt(playerPed, 'Chopping', 2)

                TriggerServerEvent('Lenzh_chopshop:NotifPos', {
                    x = ESX.Math.Round(playerCoords.x, 1),
                    y = ESX.Math.Round(playerCoords.y, 1),
                    z = ESX.Math.Round(playerCoords.z, 1)
                })
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(100)

        if NetworkIsSessionStarted() then
            DecorRegister('Chopping', 3)
            DecorSetInt(PlayerPedId(), 'Chopping', 1)

            return
        end
    end
end)




RegisterNetEvent('Lenzh_chopshop:StartNotifyPD')
AddEventHandler('Lenzh_chopshop:StartNotifyPD', function(serverid)
    local serverid = GetPlayerPed(GetPlayerFromServerId(serverid))
    local mugshot, mugshotStr = ESX.Game.GetPedMugshot(serverid)
    ESX.ShowAdvancedNotification(_U('911'), _U('chop'), _U('call'), mugshotStr, 1)
    PlaySoundFrontend(-1, "Event_Start_Text", "GTAO_FM_Events_Soundset", 0)
    UnregisterPedheadshot(mugshot)
end)

RegisterNetEvent('Lenzh_chopshop:NotifPosProgress')
AddEventHandler('Lenzh_chopshop:NotifPosProgress', function(targetCoords)
    if isPlayerWhitelisted then
        local alpha = 250
        local ChopBlip = AddBlipForRadius(targetCoords.x, targetCoords.y, targetCoords.z, 50.0)

        SetBlipHighDetail(ChopBlip, true)
        SetBlipColour(ChopBlip, 17)
        SetBlipAlpha(ChopBlip, alpha)
        SetBlipAsShortRange(ChopBlip, true)

        while alpha ~= 0 do
            Citizen.Wait(5 * 4)
            alpha = alpha - 1
            SetBlipAlpha(ChopBlip, alpha)

            if alpha == 0 then
                RemoveBlip(ChopBlip)
                pedIsTryingToChopVehicle = false
                return
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(2000)

        if DecorGetInt(PlayerPedId(), 'Chopping') == 2 then
            Citizen.Wait(timing)
            DecorSetInt(PlayerPedId(), 'Chopping', 1)
        end
    end
end)
