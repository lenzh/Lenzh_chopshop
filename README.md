# Lenzh_chopshop
Chop shop for ESX


## How to use with esx_inventoryhud

add the files from the folder iHUD to the html/img/items of esx_inventoryhud

go the the __resource of esx_inventoryhud and search the files {} section and add this to the bottom
```
  -- Lenzh_chopshop
  "html/img/items/battery.png",
  "html/img/items/lowradio.png",
  "html/img/items/stockrim.png",
  "html/img/items/airbag.png",
  "html/img/items/highradio.png",
  "html/img/items/highrim.png",
```

Feel free to edit the resource but make sure to pass it through and give me credits ;)  

Credit:
I took npc code from esx_cargodelivery  
https://github.com/apoiat/esx_cargodelivery  
and https://github.com/XxFri3ndlyxX for all his help ;)  

So Big special thanks to those guys.  

## Requirements
- es_extended (https://github.com/ESX-Org/es_extended)
- pNotify (https://github.com/Nick78111/pNotify)
- progressBars (https://github.com/chipsahoy6/progressBars/releases)

## Download & Installation

### Using [fvm](https://github.com/qlaffont/fvm-installer)
```
fvm install --save --folder=esx lenzh/Lenzh_chopshop
```

### Using Git
```
cd resources
git clone https://github.com/lenzh/Lenzh_chopshop [esx]/Lenzh_chopshop
```

### Manually
- Download https://github.com/lenzh/Lenzh_chopshop/archive/master.zip
- Put it in the `[esx]` directory

## Installation
- Import `Lenzh_chopshop.sql` in your database
- Add this in your `server.cfg`:

```
start Lenzh_chopshop
```


# Support
Support can be found on my discord

https://discord.gg/sjsT9zV

Wanna support me visit my patreon
# Legal
### License

Copyright (C) 2015-2019 Jérémie N'gadi

This program Is free software: you can redistribute it And/Or modify it under the terms Of the GNU General Public License As published by the Free Software Foundation, either version 3 Of the License, Or (at your option) any later version.

This program Is distributed In the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty Of MERCHANTABILITY Or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License For more details.

You should have received a copy Of the GNU General Public License along with this program. If Not, see http://www.gnu.org/licenses/.
