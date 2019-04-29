Config = {}

Config.DrawDistance               = 100.0
Config.MarkerType                 = 1
Config.MarkerColor                = { r = 50, g = 50, b = 204 }

Config.Locale                     = 'en'


Config.GiveBlack = true -- Wanna use Blackmoney?

Config.Zones = {
	Chopshop = {coords = vector3(-531.34, -1713.45, 19.20), name = _U('map_blip'), color = 49, sprite = 225, radius = 100.0, Pos = { x = -531.34, y = -1713.45, z = 18.3}, Size  = { x = 5.0, y = 5.0, z = 0.5 }, },
	Shop = {coords = vector3(-66.25, 6388.9, 31.49), name = _U('map_blip_shop'), color = 50, sprite = 120, radius = 25.0, Pos = { x = -66.25, y = 6688.9, z = 32.1}, Size  = { x = 2.0, y = 2.0, z = 1.0 }, },

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
