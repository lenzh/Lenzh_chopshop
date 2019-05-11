ESX                             = nil
local PlayerData                = {}
local HasAlreadyEnteredMarker   = false
local LastZone                  = nil
local CurrentAction             = nil
local CurrentActionMsg          = ''
local CurrentActionData         = {}
local isDead                    = false
local CurrentTask               = {}
local menuOpen 				    = false
local wasOpen 				    = false
local pedIsTryingToChopVehicle  = false



Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	PlayerData = ESX.GetPlayerData()
end)

AddEventHandler('esx:onPlayerDeath', function(data)
    isDead = true
end)

AddEventHandler('playerSpawned', function(spawn)
    isDead = false
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local playerPed = PlayerPedId()
		local coords = GetEntityCoords(playerPed)

		if GetDistanceBetweenCoords(coords, Config.Zones.Shop.coords, true) < 3.0 then
			if not menuOpen then
				ESX.ShowHelpNotification(_U('shop_prompt'))

				if IsControlJustReleased(0, 38) then
					wasOpen = true
					OpenShop()
				end
			else
				Citizen.Wait(500)
			end
		else
			if wasOpen then
				wasOpen = false
				ESX.UI.Menu.CloseAll()
			end

			Citizen.Wait(500)
		end
	end
end)

function OpenShop()
	ESX.UI.Menu.CloseAll()
	local elements = {}
	menuOpen = true

	for k, v in pairs(ESX.GetPlayerData().inventory) do
		local price = Config.Itemsprice[v.name]

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

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'car_shop', {
		title    = _U('shop_title'),
		align    = 'right',
		elements = elements
	}, function(data, menu)
		TriggerServerEvent('lenzh_chopshop:sell', data.current.name, data.current.value)
	end, function(data, menu)
		menu.close()
		menuOpen = false
	end)
end

function IsDriver ()
	return GetPedInVehicleSeat(GetVehiclePedIsIn(GetPlayerPed(-1), false), -1) == GetPlayerPed(-1)
end

function MaxSeat()
	local veh = GetVehiclePedIsIn(GetPlayerPed(-1))
	if GetVehicleMaxNumberOfPassengers(veh) >= 1 then
		NoPassengerAllowed()
	end
	if GetVehicleMaxNumberOfPassengers(veh) <= 1 then
		NoPassengerAllowed1()
	end
end

function NoPassengerAllowed()
	local veh1 = GetVehiclePedIsIn(GetPlayerPed(-1))
	local veh2 = GetPedInVehicleSeat(GetPlayerPed(-1))
	if veh2 then
if IsVehicleSeatFree(veh1,0) and IsVehicleSeatFree(veh1,1) and IsVehicleSeatFree(veh1,2) and not IsVehicleSeatFree(veh1,-1) then
	ChopVehicle()
else
	exports.pNotify:SendNotification({text = "Cannot Chop if passenger abord", type = "error", timeout = 5000, layout = "centerRight", queue = "right", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
       end
    end
end

function NoPassengerAllowed1()
	local veh3 = GetVehiclePedIsIn(GetPlayerPed(-1))
	local veh4 = GetPedInVehicleSeat(GetPlayerPed(-1))
	if veh3 then
if IsVehicleSeatFree(veh3,0) then
	ChopVehicle()
--else
	--exports.pNotify:SendNotification({text = "Cannot Chop if passenger abord", type = "error", timeout = 5000, layout = "centerRight", queue = "right", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
       end
    end
end

--if GetVehicleMaxNumberOfPassengers(veh) > 1 then
function ChopVehicle()
	ESX.TriggerServerCallback('Lenzh_chopshop:isCooldown', function(cooldown)
		if cooldown <= 0 then
			if Config.CallCops then
				local randomReport = math.random(1, Config.CallCopsPercent)
				print(Config.CallCopsPercent)
				if randomReport == Config.CallCopsPercent then
					TriggerServerEvent('chopNotify')
				end
			end
			local ped = GetPlayerPed(-1)
			local vehicle = GetVehiclePedIsIn( ped, false )
        exports.pNotify:SendNotification({text = "Chopping vehicle, please wait...", type = "error", timeout = Config.NotificationTotalTime, layout = "centerRight", queue = "right", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})

				SetVehicleEngineOn(vehicle, false, false, true)
				SetVehicleUndriveable(vehicle, false)
				SetVehicleDoorOpen(GetVehiclePedIsIn(GetPlayerPed(-1), false), 0, false, false)
				Citizen.Wait(Config.DoorBrokenTime)
				SetVehicleDoorBroken(GetVehiclePedIsIn(GetPlayerPed(-1), false), 0, true)
				Citizen.Wait(Config.DoorOpenTime)
				SetVehicleDoorOpen(GetVehiclePedIsIn(GetPlayerPed(-1), false), 1, false, false)
				Citizen.Wait(Config.DoorBrokenTime1)
				SetVehicleDoorBroken(GetVehiclePedIsIn(GetPlayerPed(-1), false), 1, true)
				Citizen.Wait(Config.DoorOpenTime1)
				SetVehicleDoorOpen(GetVehiclePedIsIn(GetPlayerPed(-1), false), 2, false, false)
				Citizen.Wait(Config.DoorBrokenTime2)
				SetVehicleDoorBroken(GetVehiclePedIsIn(GetPlayerPed(-1), false), 2, true)
				Citizen.Wait(Config.DoorOpenTime2)
				SetVehicleDoorOpen(GetVehiclePedIsIn(GetPlayerPed(-1), false), 3, false, false)
				Citizen.Wait(Config.DoorBrokenTime3)
				SetVehicleDoorBroken(GetVehiclePedIsIn(GetPlayerPed(-1), false), 3, true)
				Citizen.Wait(Config.DoorOpenTime3)
				SetVehicleDoorOpen(GetVehiclePedIsIn(GetPlayerPed(-1), false), 4, false, false)
				Citizen.Wait(Config.DoorBrokenTime4)
				SetVehicleDoorBroken(GetVehiclePedIsIn(GetPlayerPed(-1), false),4, true)
				Citizen.Wait(Config.DoorOpenTime4)
				SetVehicleDoorOpen(GetVehiclePedIsIn(GetPlayerPed(-1), false), 5, false, false)
				Citizen.Wait(Config.DoorBrokenTime5)
				SetVehicleDoorBroken(GetVehiclePedIsIn(GetPlayerPed(-1), false),5, true)
				Citizen.Wait(Config.DoorOpenTime5)
				DeleteVehicle()
				exports.pNotify:SendNotification({text = "Vehicle Chopped Successfully...", type = "success", timeout = 1000, layout = "centerRight", queue = "right", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
			else
				ESX.ShowNotification(_U('cooldown', math.ceil(cooldown/1000)))
	    end
	end)
end

function DeleteVehicle()
	if IsDriver() then
        local playerPed = GetPlayerPed(-1)
        local coords    = GetEntityCoords(playerPed)

        if IsPedInAnyVehicle(playerPed,  false) then
            local vehicle = GetVehiclePedIsIn(playerPed, false)
            ESX.Game.DeleteVehicle(vehicle)
				end

			TriggerServerEvent("lenzh_chopshop:rewards", rewards)
	  end
end


AddEventHandler('lenzh_chopshop:hasEnteredMarker', function(zone)
	if zone == 'Chopshop' and IsDriver() then
		CurrentAction     = 'Chopshop'
		CurrentActionMsg  = _U('press_to_chop')
		CurrentActionData = {}
	end

end)

AddEventHandler('lenzh_chopshop:hasExitedMarker', function(zone)
	if menuOpen then
		ESX.UI.Menu.CloseAll()
	end

	CurrentAction = nil
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
--npc
Citizen.CreateThread(function()
    if Config.NPCEnable == true then
	RequestModel(Config.NPCHash)
	while not HasModelLoaded(Config.NPCHash) do
	Wait(1)

	end

	--PROVIDER
		meth_dealer_seller = CreatePed(1, Config.NPCHash, Config.NPCShop.x, Config.NPCShop.y, Config.NPCShop.z, Config.NPCShop.h, false, true)
		SetBlockingOfNonTemporaryEvents(meth_dealer_seller, true)
		SetPedDiesWhenInjured(meth_dealer_seller, false)
		SetPedCanPlayAmbientAnims(meth_dealer_seller, true)
		SetPedCanRagdollFromPlayerImpact(meth_dealer_seller, false)
		SetEntityInvincible(meth_dealer_seller, true)
		FreezeEntityPosition(meth_dealer_seller, true)
		TaskStartScenarioInPlace(meth_dealer_seller, "WORLD_HUMAN_SMOKING", 0, true);
	else
	end
end)

-- Display markers
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        local coords, letSleep = GetEntityCoords(PlayerPedId()), true

        for k,v in pairs(Config.Zones) do
            if Config.MarkerType ~= -1 and GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < Config.DrawDistance then
                DrawMarker(Config.MarkerType, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, nil, nil, false)
                letSleep = false
            end
        end

        if letSleep then
            Citizen.Wait(500)
        end
    end
end)

-- Enter / Exit marker events
Citizen.CreateThread(function()
	while true do

		Citizen.Wait(0)

		local coords      = GetEntityCoords(PlayerPedId())
		local isInMarker  = false
		local currentZone = nil
		local letSleep = true

		for k,v in pairs(Config.Zones) do
			if(GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < v.Size.x) then
				isInMarker  = true
				currentZone = k
			end
		end

		if (isInMarker and not HasAlreadyEnteredMarker) or (isInMarker and LastZone ~= currentZone) then
			HasAlreadyEnteredMarker = true
			LastZone                = currentZone
			TriggerEvent('lenzh_chopshop:hasEnteredMarker', currentZone)
		end

		if not isInMarker and HasAlreadyEnteredMarker then
			HasAlreadyEnteredMarker = false
			TriggerEvent('lenzh_chopshop:hasExitedMarker', LastZone)
		end

	end
end)

-- Key controls
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        if CurrentAction ~= nil then
            ESX.ShowHelpNotification(CurrentActionMsg)

            if IsControlJustReleased(0, 38) then
                if IsDriver() then
                    if CurrentAction == 'Chopshop' then
						--NoPassengerAllowed()
						MaxSeat()
                    end
                end
                CurrentAction = nil
            end
        else
            Citizen.Wait(500)
        end
    end
end)

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		if menuOpen then
			ESX.UI.Menu.CloseAll()
		end
	end
end)

--Only if Config.CallCops = true
GetPlayerName()
RegisterNetEvent('outlawNotify')
AddEventHandler('outlawNotify', function(alert)
	if PlayerData.job ~= nil and PlayerData.job.name == 'police' then
		TriggerEvent('lenzh_chopshop:notify2')
		PlaySoundFrontend(-1, "Event_Start_Text", "GTAO_FM_Events_Soundset", 0)
    end
end)

--[[ function Notify(text)
    SetNotificationTextEntry('STRING')
    AddTextComponentString(text)
    DrawNotification(false, false)
end ]]

--[[ function Notify2(msg)
    local xTarget = ESX.GetPlayerFromId(target)
    local mugshot, mugshotStr = ESX.Game.GetPedMugshot(GetPlayerPed(xTarget))

    ESX.ShowAdvancedNotification(_U('911'), _U('chop'), _U('call'), mugshotStr, 2)

    UnregisterPedheadshot(mugshot)
end ]]

RegisterNetEvent("lenzh_chopshop:notify2")
AddEventHandler("lenzh_chopshop:notify2", function(msg, target)
		ESX.ShowAdvancedNotification(_U('911'), _U('chop'), _U('call'), 'CHAR_CALL911', 7)
end)

local timer = 1 --in minutes - Set the time during the player is outlaw
local showOutlaw = true --Set if show outlaw act on map
local blipTime = 35 --in second
local showcopsmisbehave = true --show notification when cops steal too

local timing = timer * 60000 --Don't touche it

Citizen.CreateThread(function()
    while true do
        Wait(100)
        if NetworkIsSessionStarted() then
            DecorRegister("IsOutlaw",  3)
            DecorSetInt(GetPlayerPed(-1), "IsOutlaw", 1)
            return
        end
    end
end)

Citizen.CreateThread( function()
    while true do
        Wait(100)
        local plyPos = GetEntityCoords(GetPlayerPed(-1),  true)
        local s1, s2 = Citizen.InvokeNative( 0x2EB41072B4C1E4C0, plyPos.x, plyPos.y, plyPos.z, Citizen.PointerValueInt(), Citizen.PointerValueInt() )
        local street1 = GetStreetNameFromHashKey(s1)
        local street2 = GetStreetNameFromHashKey(s2)
        if pedIsTryingToChopVehicle then
            DecorSetInt(GetPlayerPed(-1), "IsOutlaw", 2)
			if PlayerData.job ~= nil and PlayerData.job.name == 'police' and showcopsmisbehave == false then
			elseif PlayerData.job ~= nil and PlayerData.job.name == 'police' and showcopsmisbehave then
				ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
					local sex = nil
					if skin.sex == 0 then
						sex = "male" --male/change it to your language
					else
						sex = "female" --female/change it to your language
					end
					TriggerServerEvent('ChoppingInProgressPos', plyPos.x, plyPos.y, plyPos.z)
					if s2 == 0 then
						TriggerServerEvent('ChopInProgressS1', street1, sex)
					elseif s2 ~= 0 then
						TriggerServerEvent('ChopInProgress', street1, street2, sex)
					end
				end)
				Wait(3000)
				pedIsTryingToChopVehicle = false
			else
				ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
					local sex = nil
					if skin.sex == 0 then
						sex = "male"
					else
						sex = "female"
					end
					TriggerServerEvent('ChoppingInProgressPos', plyPos.x, plyPos.y, plyPos.z)
					if s2 == 0 then
						TriggerServerEvent('ChopInProgressS1', street1, sex)
					elseif s2 ~= 0 then
						TriggerServerEvent('ChopInProgress', street1, street2, sex)
					end
				end)
				Wait(3000)
				pedIsTryingToChopVehicle = false
			end
        end
    end
end)

RegisterNetEvent('Choplocation')
AddEventHandler('Choplocation', function(tx, ty, tz)
	if PlayerData.job.name == 'police' then
		local transT = 250
		local Blip = AddBlipForCoord(tx, ty, tz)
		SetBlipSprite(Blip,  10)
		SetBlipColour(Blip,  1)
		SetBlipAlpha(Blip,  transT)
		SetBlipAsShortRange(Blip,  false)
		while transT ~= 0 do
			Wait(blipTime * 4)
			transT = transT - 1
			SetBlipAlpha(Blip,  transT)
			if transT == 0 then
				SetBlipSprite(Blip,  2)
				return
			end
		end
	end
end)


RegisterNetEvent('chopEnable')
AddEventHandler('chopEnable', function()
	pedIsTryingToChopVehicle = true
end)
