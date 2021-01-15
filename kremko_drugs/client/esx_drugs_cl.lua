local Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

local cokeQTE       			= 0
ESX 			    			= nil
local coke_poochQTE 			= 0
local weedQTE					= 0
local weed_poochQTE 			= 0
local methQTE					= 0
local meth_poochQTE 			= 0
local opiumQTE					= 0
local opium_poochQTE 			= 0
local myJob 					= nil
local HasAlreadyEnteredMarker   = false
local LastZone                  = nil
local isInZone                  = false
local CurrentAction             = nil
local CurrentActionMsg          = ''
local CurrentActionData         = {}

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

AddEventHandler('angelsrp_drugs:hasEnteredMarker', function(zone)
	if myJob == 'police' or myJob == 'ambulance' then
		return
	end

	ESX.UI.Menu.CloseAll()
	
	if zone == 'exitMarker' then
		CurrentAction     = zone
		CurrentActionMsg  = _U('exit_marker')
		CurrentActionData = {}
	end
	
	if zone == 'CokeField' then
		CurrentAction     = zone
		CurrentActionMsg  = _U('press_collect_coke')
		CurrentActionData = {}
	end

	if zone == 'CokeProcessing' then
		if cokeQTE >= 5 then
			CurrentAction     = zone
			CurrentActionMsg  = _U('press_process_coke')
			CurrentActionData = {}
		end
	end

	if zone == 'CokeDealer' then
		if coke_poochQTE >= 1 then
			CurrentAction     = zone
			CurrentActionMsg  = _U('press_sell_coke')
			CurrentActionData = {}
		end
	end

	if zone == 'MethField' then
		CurrentAction     = zone
		CurrentActionMsg  = _U('press_collect_meth')
		CurrentActionData = {}
	end

	if zone == 'MethProcessing' then
		if methQTE >= 5 then
			CurrentAction     = zone
			CurrentActionMsg  = _U('press_process_meth')
			CurrentActionData = {}
		end
	end

	if zone == 'MethDealer' then
		if meth_poochQTE >= 1 then
			CurrentAction     = zone
			CurrentActionMsg  = _U('press_sell_meth')
			CurrentActionData = {}
		end
	end

	if zone == 'WeedField' then
		CurrentAction     = zone
		CurrentActionMsg  = _U('press_collect_weed')
		CurrentActionData = {}
	end

	if zone == 'WeedProcessing' then
		if weedQTE >= 5 then
			CurrentAction     = zone
			CurrentActionMsg  = _U('press_process_weed')
			CurrentActionData = {}
		end
	end

	if zone == 'WeedDealer' then
		if weed_poochQTE >= 1 then
			CurrentAction     = zone
			CurrentActionMsg  = _U('press_sell_weed')
			CurrentActionData = {}
		end
	end

	if zone == 'OpiumField' then
		CurrentAction     = zone
		CurrentActionMsg  = _U('press_collect_opium')
		CurrentActionData = {}
	end

	if zone == 'OpiumProcessing' then
		if opiumQTE >= 5 then
			CurrentAction     = zone
			CurrentActionMsg  = _U('press_process_opium')
			CurrentActionData = {}
		end
	end

	if zone == 'OpiumDealer' then
		if opium_poochQTE >= 1 then
			CurrentAction     = zone
			CurrentActionMsg  = _U('press_sell_opium')
			CurrentActionData = {}
		end
	end
end)

AddEventHandler('angelsrp_drugs:hasExitedMarker', function(zone)
	CurrentAction = nil
	isInZone  = false
	ClearPedTasksImmediately(GetPlayerPed(-1))
	ESX.UI.Menu.CloseAll()
	TriggerEvent('angelsrp_drugs:freezePlayer', false)
	TriggerServerEvent('angelsrp_drugs:stopHarvestCoke')
	TriggerServerEvent('angelsrp_drugs:stopTransformCoke')
	TriggerServerEvent('angelsrp_drugs:stopSellCoke')
	TriggerServerEvent('angelsrp_drugs:stopHarvestMeth')
	TriggerServerEvent('angelsrp_drugs:stopTransformMeth')
	TriggerServerEvent('angelsrp_drugs:stopSellMeth')
	TriggerServerEvent('angelsrp_drugs:stopHarvestWeed')
	TriggerServerEvent('angelsrp_drugs:stopTransformWeed')
	TriggerServerEvent('angelsrp_drugs:stopSellWeed')
	TriggerServerEvent('angelsrp_drugs:stopHarvestOpium')
	TriggerServerEvent('angelsrp_drugs:stopTransformOpium')
	TriggerServerEvent('angelsrp_drugs:stopSellOpium')
end)

-- Weed Effect
RegisterNetEvent('angelsrp_drugs:onPot')
AddEventHandler('angelsrp_drugs:onPot', function()
	RequestAnimSet("MOVE_M@DRUNK@SLIGHTLYDRUNK")
	while not HasAnimSetLoaded("MOVE_M@DRUNK@SLIGHTLYDRUNK") do
		Citizen.Wait(0)
	end
	TaskStartScenarioInPlace(GetPlayerPed(-1), "WORLD_HUMAN_SMOKING_POT", 0, true)
	Citizen.Wait(5000)
	DoScreenFadeOut(1000)
	Citizen.Wait(1000)
	ClearPedTasksImmediately(GetPlayerPed(-1))
	SetTimecycleModifier("spectator5")
	SetPedMotionBlur(GetPlayerPed(-1), true)
	SetPedMovementClipset(GetPlayerPed(-1), "MOVE_M@DRUNK@SLIGHTLYDRUNK", true)
	SetPedIsDrunk(GetPlayerPed(-1), true)
	local ped = GetPlayerPed( -1 )
		if ( DoesEntityExist( ped ) and not IsEntityDead( ped ) ) then
			SetEntityHealth( ped, 1000 )
		end
	DoScreenFadeIn(1000)
	Citizen.Wait(600000)
	DoScreenFadeOut(1000)
	Citizen.Wait(1000)
	DoScreenFadeIn(1000)
	ClearTimecycleModifier()
	ResetScenarioTypesEnabled()
	ResetPedMovementClipset(GetPlayerPed(-1), 0)
	SetPedIsDrunk(GetPlayerPed(-1), false)
	SetPedMotionBlur(GetPlayerPed(-1), false)
end)

-- Meth Effect
RegisterNetEvent('angelsrp_drugs:onMeth')
AddEventHandler('angelsrp_drugs:onMeth', function()
	RequestAnimSet("MOVE_M@DRUNK@SLIGHTLYDRUNK")
	while not HasAnimSetLoaded("MOVE_M@DRUNK@SLIGHTLYDRUNK") do
		Citizen.Wait(0)
	end
	TaskStartScenarioInPlace(GetPlayerPed(-1), "WORLD_HUMAN_DRUG_DEALER", 0, true)
	Citizen.Wait(5000)
	DoScreenFadeOut(1000)
	Citizen.Wait(1000)
	ClearPedTasksImmediately(GetPlayerPed(-1))
	SetTimecycleModifier("drug_drive_blend01")
	SetPedMotionBlur(GetPlayerPed(-1), true)
	SetPedMovementClipset(GetPlayerPed(-1), "MOVE_M@DRUNK@SLIGHTLYDRUNK", true)
	SetPedIsDrunk(GetPlayerPed(-1), true)
	local ped = GetPlayerPed( -1 )
		if ( DoesEntityExist( ped ) and not IsEntityDead( ped ) ) then
			SetPedArmour( ped, 85)
		end
	DoScreenFadeIn(1000)
	Citizen.Wait(600000)
	DoScreenFadeOut(1000)
	Citizen.Wait(1000)
	DoScreenFadeIn(1000)
	ClearTimecycleModifier()
	ResetScenarioTypesEnabled()
	ResetPedMovementClipset(GetPlayerPed(-1), 0)
	SetPedIsDrunk(GetPlayerPed(-1), false)
	SetPedMotionBlur(GetPlayerPed(-1), false)
end)

-- Coke Effect
RegisterNetEvent('angelsrp_drugs:onCoke')
AddEventHandler('angelsrp_drugs:onCoke', function()
	RequestAnimSet("MOVE_M@DRUNK@SLIGHTLYDRUNK")
	while not HasAnimSetLoaded("MOVE_M@DRUNK@SLIGHTLYDRUNK") do
		Citizen.Wait(0)
	end
	TaskStartScenarioInPlace(GetPlayerPed(-1), "WORLD_HUMAN_DRUG_DEALER", 0, true)
	Citizen.Wait(5000)
	DoScreenFadeOut(1000)
	Citizen.Wait(1000)
	ClearPedTasksImmediately(GetPlayerPed(-1))
	SetTimecycleModifier("drug_flying_base")
	SetPedMotionBlur(GetPlayerPed(-1), true)
	SetPedIsDrunk(GetPlayerPed(-1), true)
	local playerPed = GetPlayerPed(-1)
	local playerID = PlayerId()
		if playerPed then
			SetRunSprintMultiplierForPlayer(ped, 1.2)
			SetPedArmour( ped, 30)
		end
	DoScreenFadeIn(1000)
	Citizen.Wait(150000)
	local playerPed = GetPlayerPed(-1)
	local playerID = PlayerId()
		if playerPed then
			SetRunSprintMultiplierForPlayer(ped, 1.0)
		end
	Citizen.Wait(600000)
	DoScreenFadeOut(1000)
	Citizen.Wait(1000)
	DoScreenFadeIn(1000)
	ClearTimecycleModifier()
	ResetScenarioTypesEnabled()
	ResetPedMovementClipset(GetPlayerPed(-1), 0)
	SetPedIsDrunk(GetPlayerPed(-1), false)
	SetPedMotionBlur(GetPlayerPed(-1), false)
end)

-- Opium Effect
RegisterNetEvent('angelsrp_drugs:onOpium')
AddEventHandler('angelsrp_drugs:onOpium', function()
	RequestAnimSet("MOVE_M@DRUNK@SLIGHTLYDRUNK")
	while not HasAnimSetLoaded("MOVE_M@DRUNK@SLIGHTLYDRUNK") do
		Citizen.Wait(0)
	end
	TaskStartScenarioInPlace(GetPlayerPed(-1), "WORLD_HUMAN_DRUG_DEALER", 0, true)
	Citizen.Wait(5000)
	DoScreenFadeOut(1000)
	Citizen.Wait(1000)
	ClearPedTasksImmediately(GetPlayerPed(-1))
	SetTimecycleModifier("NG_filmic23")
	SetPedMotionBlur(GetPlayerPed(-1), true)
	SetPedIsDrunk(GetPlayerPed(-1), true)
	DoScreenFadeIn(1000)
	Citizen.Wait(600000)
	DoScreenFadeOut(1000)
	Citizen.Wait(1000)
	DoScreenFadeIn(1000)
	ClearTimecycleModifier()
	ResetScenarioTypesEnabled()
	ResetPedMovementClipset(GetPlayerPed(-1), 0)
	SetPedIsDrunk(GetPlayerPed(-1), false)
	SetPedMotionBlur(GetPlayerPed(-1), false)
end)

-- Render markers
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local coords = GetEntityCoords(GetPlayerPed(-1))
		for k,v in pairs(Config.Zones) do
			if(GetDistanceBetweenCoords(coords, v.x, v.y, v.z, true) < Config.DrawDistance) then
				DrawMarker(Config.MarkerType, v.x, v.y, v.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.ZoneSize.x, Config.ZoneSize.y, Config.ZoneSize.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, false, false, false)
			end
		end

	end
end)

-- RETURN NUMBER OF ITEMS FROM SERVER
RegisterNetEvent('angelsrp_drugs:ReturnInventory')
AddEventHandler('angelsrp_drugs:ReturnInventory', function(cokeNbr, cokepNbr, methNbr, methpNbr, weedNbr, weedpNbr, opiumNbr, opiumpNbr, jobName, currentZone)
	cokeQTE	   = cokeNbr
	coke_poochQTE = cokepNbr
	methQTE 	  = methNbr
	meth_poochQTE = methpNbr
	weedQTE 	  = weedNbr
	weed_poochQTE = weedpNbr
	opiumQTE	   = opiumNbr
	opium_poochQTE = opiumpNbr
	myJob		 = jobName
	TriggerEvent('angelsrp_drugs:hasEnteredMarker', currentZone)
end)

-- Activate menu when player is inside marker
Citizen.CreateThread(function()
	while true do

		Citizen.Wait(0)

		local coords      = GetEntityCoords(GetPlayerPed(-1))
		local isInMarker  = false
		local currentZone = nil

		for k,v in pairs(Config.Zones) do
			if(GetDistanceBetweenCoords(coords, v.x, v.y, v.z, true) < Config.ZoneSize.x / 2) then
				isInMarker  = true
				currentZone = k
			end
		end

		if isInMarker and not hasAlreadyEnteredMarker then
			hasAlreadyEnteredMarker = true
			lastZone				= currentZone
			TriggerServerEvent('angelsrp_drugs:GetUserInventory', currentZone)
		end

		if not isInMarker and hasAlreadyEnteredMarker then
			hasAlreadyEnteredMarker = false
			TriggerEvent('angelsrp_drugs:hasExitedMarker', lastZone)
		end

		if isInMarker and isInZone then
			TriggerEvent('angelsrp_drugs:hasEnteredMarker', 'exitMarker')
		end
	end
end)

-- Key Controls
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10)
		if CurrentAction ~= nil then
			SetTextComponentFormat('STRING')
			AddTextComponentString(CurrentActionMsg)
			DisplayHelpTextFromStringLabel(0, 0, 1, -1)
			if IsControlJustReleased(0, Keys['E']) then
				isInZone = true -- unless we set this boolean to false, we will always freeze the user
				if CurrentAction == 'exitMarker' then
					isInZone = false -- do not freeze user
					TriggerEvent('angelsrp_drugs:freezePlayer', false)
					TriggerEvent('angelsrp_drugs:hasExitedMarker', lastZone)
					Citizen.Wait(15000)
				elseif CurrentAction == 'CokeField' then
					TriggerServerEvent('angelsrp_drugs:startHarvestCoke')
				elseif CurrentAction == 'CokeProcessing' then
					TriggerServerEvent('angelsrp_drugs:startTransformCoke')
					TaskStartScenarioInPlace(GetPlayerPed(-1), "CODE_HUMAN_POLICE_INVESTIGATE", 0, true)
				elseif CurrentAction == 'CokeDealer' then
					TriggerServerEvent('angelsrp_drugs:startSellCoke')
				elseif CurrentAction == 'MethField' then
					TriggerServerEvent('angelsrp_drugs:startHarvestMeth')
					TaskStartScenarioInPlace(GetPlayerPed(-1), "WORLD_HUMAN_GARDENER_PLANT", 0, true)
				elseif CurrentAction == 'MethProcessing' then
					TriggerServerEvent('angelsrp_drugs:startTransformMeth')
					TaskStartScenarioInPlace(GetPlayerPed(-1), "CODE_HUMAN_POLICE_INVESTIGATE", 0, true)
				elseif CurrentAction == 'MethDealer' then
					TriggerServerEvent('angelsrp_drugs:startSellMeth')
				elseif CurrentAction == 'WeedField' then
					TriggerServerEvent('angelsrp_drugs:startHarvestWeed')
					TaskStartScenarioInPlace(GetPlayerPed(-1), "WORLD_HUMAN_GARDENER_PLANT", 0, true)
				elseif CurrentAction == 'WeedProcessing' then
					TriggerServerEvent('angelsrp_drugs:startTransformWeed')
					TaskStartScenarioInPlace(GetPlayerPed(-1), "CODE_HUMAN_POLICE_INVESTIGATE", 0, true)
				elseif CurrentAction == 'WeedDealer' then
					TriggerServerEvent('angelsrp_drugs:startSellWeed')
				elseif CurrentAction == 'OpiumField' then
					TriggerServerEvent('angelsrp_drugs:startHarvestOpium')
					TaskStartScenarioInPlace(GetPlayerPed(-1), "WORLD_HUMAN_GARDENER_PLANT", 0, true)
				elseif CurrentAction == 'OpiumProcessing' then
					TriggerServerEvent('angelsrp_drugs:startTransformOpium')
					TaskStartScenarioInPlace(GetPlayerPed(-1), "CODE_HUMAN_POLICE_INVESTIGATE", 0, true)
				elseif CurrentAction == 'OpiumDealer' then
					TriggerServerEvent('angelsrp_drugs:startSellOpium')
				else
					isInZone = false -- not a angelsrp_drugs zone
				end
				if isInZone then
					TriggerEvent('angelsrp_drugs:freezePlayer', true)
				end
				
				CurrentAction = nil
			end
		end
	end
end)

RegisterNetEvent('angelsrp_drugs:freezePlayer')
AddEventHandler('angelsrp_drugs:freezePlayer', function(freeze)
	FreezeEntityPosition(GetPlayerPed(-1), freeze)
end)
