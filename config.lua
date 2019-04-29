Config = {}

Config.DrawDistance               = 100.0
Config.MarkerType                 = 27
Config.MarkerColor                = { r = 50, g = 50, b = 204 }

Config.Locale                     = 'en'


Config.GiveBlack = true -- Wanna use Blackmoney?

Config.Zones = {
	Chopshop = {coords = vector3(-531.34, -1713.45, 19.20), name = _U('map_blip'), color = 49, sprite = 225, radius = 100.0, Pos = { x = -531.34, y = -1713.45, z = 18.3}, Size  = { x = 5.0, y = 5.0, z = 0.5 }, },
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
