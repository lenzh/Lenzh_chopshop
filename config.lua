Config = {} -- DON'T TOUCH

Config.DrawDistance       = 100.0 -- Change the distance before you can see the marker. Less is better performance.
Config.EnableBlips        = true -- Set to false to disable blips.
Config.MarkerType         = 27    -- Change to -1 to disable marker.
Config.MarkerColor        = { r = 255, g = 0, b = 0 } -- Change the marker color.

Config.Locale             = 'en' -- Change the language. Currently available (en or fr).
Config.CooldownMinutes    = 15 -- Minutes between chopping.

Config.CallCops           = true -- Set to true if you want cops to be alerted when chopping is in progress
Config.CallCopsPercent    = 1 -- (min1) if 1 then cops will be called every time=100%, 2=50%, 3=33%, 4=25%, 5=20%.

Config.NPCEnable          = true -- Set to false to disable NPC Ped at shop location.
Config.NPCHash			  = 68070371 --Hash of the npc ped. Change only if you know what you are doing.
Config.NPCShop	          = { x = -55.42, y = 6392.8, z = 30.5, h = 46.0 } -- Location of the shop For the npc.

Config.GiveBlack          = true -- Wanna use Blackmoney?

-- Change the time it takes to open door then to break them.
-- Time in Seconde. 1000 = 1 seconde
Config.DoorOpenTime          = 5000
Config.DoorOpenTime1         = 5000
Config.DoorOpenTime2         = 5000
Config.DoorOpenTime3         = 5000
Config.DoorOpenTime4         = 5000
Config.DoorOpenTime5         = 5000
Config.DoorBrokenTime        = 5000
Config.DoorBrokenTime1       = 5000
Config.DoorBrokenTime2       = 5000
Config.DoorBrokenTime3       = 5000
Config.DoorBrokenTime4       = 5000
Config.DoorBrokenTime5       = 5000
Config.NotificationTotalTime = 60000 -- Total Time From all Config.DoorOpenTime + Config.DoorBrokenTime.

Config.Zones = {
    Chopshop = {coords = vector3(-522.87, -1713.99, 18.33), name = _U('map_blip'), color = 49, sprite = 225, radius = 100.0, Pos = { x = -522.87, y = -1713.99, z = 18.33}, Size  = { x = 5.0, y = 5.0, z = 0.5 }, },
    Shop = {coords = vector3(-55.42, 6392.8, 30.5), name = _U('map_blip_shop'), color = 50, sprite = 120, radius = 25.0, Pos = { x = -55.42, y = 6392.8, z = 30.5}, Size  = { x = 3.0, y = 3.0, z = 1.0 }, },
}

Config.Items = {
    "battery",
    "lowradio",
    "stockrim",
    "airbag",
    "highradio",
    "highrim"
}

Config.Itemsprice = {
    battery = 50,
    lowradio = 94,
    highradio = 350,
    stockrim = 150,
    highrim = 285,
    airbag = 125
}
