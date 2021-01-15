Config              = {}
Config.MarkerType   = 1
Config.DrawDistance = 30.0
Config.ZoneSize     = {x = 3.5, y = 3.5, z = 0.1}
Config.MarkerColor  = {r = 255, g = 0, b = 0}

Config.RequiredCopsCoke  = 2
Config.RequiredCopsMeth  = 2
Config.RequiredCopsWeed  = 2
Config.RequiredCopsOpium = 2

Config.TimeToFarm    = 15 * 1000
Config.TimeToProcess = 20 * 1000
Config.TimeToSell    = 25  * 1000

Config.Locale = 'en'
      
Config.Zones = {
	CokeField =		{x=-1144.22, y=4909.4, z=250.97,	name = _U('coke_field'),		sprite = 501,	color = 40},
	CokeProcessing =	{x=2432.25, y=4970.41, z=60.34, 	name = _U('coke_processing'),	        sprite = 478,	color = 40},
	CokeDealer =		{x=1334.69, y=4391.49, z=80.34,	        name = _U('opium_field'),		sprite = 51,	color = 60},
}