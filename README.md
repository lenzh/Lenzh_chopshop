# Lenzh_chopshop
Chop shop for ESX


Feel free to edit the resource but make sure to pass it through and give me credits ;)
Edited by XxFri3ndlyxX
```
1. Added Cooldown on chopping vehicles.
2. Added NPC at shop location with config to disable it and change coordination.
3. Vehicle now gets door removed after opening them. Raised time per door to 5000ms  so 5 sec. 
4. Added the bility to hide blips in config.
5. Reworked the way you did the chopping. So removed from key control and added his own function So ChopVehicle.
6. Renamed old ChopVehicle to DeleteVehicle
```
Credit:
I took Cooldown code from esx_carthief and made the necessary modification to make it work.  
https://github.com/KlibrDM/esx_carthief  
I took npc code from esx_cargodelivery  
https://github.com/apoiat/esx_cargodelivery  
So Big special thanks to those guys.  

## Requirements
- es_extended (https://github.com/ESX-Org/es_extended)
- pNotify (https://github.com/Nick78111/pNotify)

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

# Legal
### License

Copyright (C) 2015-2019 Jérémie N'gadi

This program Is free software: you can redistribute it And/Or modify it under the terms Of the GNU General Public License As published by the Free Software Foundation, either version 3 Of the License, Or (at your option) any later version.

This program Is distributed In the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty Of MERCHANTABILITY Or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License For more details.

You should have received a copy Of the GNU General Public License along with this program. If Not, see http://www.gnu.org/licenses/.
