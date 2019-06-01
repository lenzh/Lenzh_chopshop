Config = {} -- DON'T TOUCH

Config.DrawDistance       = 100.0 -- Change the distance before you can see the marker. Less is better performance.
Config.EnableBlips        = true -- Set to false to disable blips.
Config.MarkerType         = 27    -- Change to -1 to disable marker.
Config.MarkerColor        = { r = 255, g = 0, b = 0 } -- Change the marker color.

Config.Locale             = 'en' -- Change the language. Currently available (en or fr).
Config.CooldownMinutes    = 0 -- Minutes between chopping.

Config.CallCops           = true -- Set to true if you want cops to be alerted when chopping is in progress
Config.CallCopsPercent    = 1 -- (min1) if 1 then cops will be called every time=100%, 2=50%, 3=33%, 4=25%, 5=20%.

Config.NPCEnable          = true -- Set to false to disable NPC Ped at shop location.
Config.NPCHash			      = 68070371 --Hash of the npc ped. Change only if you know what you are doing.
Config.NPCShop	          = { x = -55.42, y = 6392.8, z = 30.5, h = 46.0 } -- Location of the shop For the npc.

Config.GiveBlack          = true -- Wanna use Blackmoney?

-- Change the time it takes to open door then to break them.
-- Time in Seconde. 1000 = 1 seconde
Config.DoorOpenFrontLeftTime      = 5000
Config.DoorBrokenFrontLeftTime    = 5000
Config.DoorOpenFrontRightTime     = 5000
Config.DoorBrokenFrontRightTime   = 5000
Config.DoorOpenRearLeftTime       = 5000
Config.DoorBrokenRearLeftTime     = 5000
Config.DoorOpenRearRightTime      = 5000
Config.DoorBrokenRearRightTime    = 5000
Config.DoorOpenHoodTime           = 5000
Config.DoorBrokenHoodTime         = 5000
Config.DoorOpenTrunkTime          = 5000
Config.DoorBrokenTrunkTime        = 5000
Config.DeletingVehicleTime        = 5000

Config.Zones = {
    Chopshop = {coords = vector3(-522.87, -1713.99, 18.33), name = _U('map_blip'), color = 49, sprite = 225, radius = 100.0, Pos = { x = -522.87, y = -1713.99, z = 18.33}, Size  = { x = 5.0, y = 5.0, z = 0.5 }, },
    Shop = {coords = vector3(-55.42, 6392.8, 30.5), name = _U('map_blip_shop'), color = 50, sprite = 120, radius = 25.0, Pos = { x = -55.42, y = 6392.8, z = 30.5}, Size  = { x = 3.0, y = 3.0, z = 1.0 }, },
    getOrders = {coords = vector3(472.37, -1310.46, 28.22), name = _U('map_blip_order'), color = 50, sprite = 442, radius = 25.0, Pos = { x = 472.37, y = -1310.46, z = 28.22}, Size  = { x = 3.0, y = 3.0, z = 1.0 }, },
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

Config.vehicles = {
    'Adder',
    'Akuma',
    'Baller',
    'Banshee',
    'Benson',
    'Bison',
    'Blazer',
    'Blista', 
    'Buccaneer', 
    'Buffalo',
    'Bullet', 
    'Burrito',
    'Comet2', --needs checking
    'Coquette', 
    'Daemon',
    'Dilettante',
    'Dominator', 
    'Emperor', 
    'Felon', 
    'Feltzer2', --Needs checking
    'Fugitive', 
    'Fusilade', 
    'Futo', 
    'Gauntlet', 
    'Gresley', 
    'Habanero', 
    'Hexer', 
    'Landstalker',
    'Mesa', 
    'Monroe', 
    'Mule', 
    'Nemesis', 
    'Pcj', 
    'Premier', 
    'Primo', 
    'Rapidgt', 
    'Sabregt', 
    'Schafter2', --Needs checking
    'Stratum', 
    'Sultan',
    'Taxi',
    'Tornado'
}