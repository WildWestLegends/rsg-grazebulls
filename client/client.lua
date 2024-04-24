local RSGCore = exports['rsg-core']:GetCoreObject()
local pasturingBulls = {}
local starting = false
local isPasturing = false
local pasturingStartTime = 0
local isFinish = false
local lastNotificationTime = 0

-- Spawn the bulls
Citizen.CreateThread(function()
    for bullmenu, v in pairs(Config.Bull) do
        exports['rsg-core']:createPrompt(v.location, v.coords, RSGCore.Shared.Keybinds['J'], '' .. v.name, {
            type = 'client',
            event = 'rsg-grazebulls:client:bulljob',
            args = {},
        })
        if v.showblip == true then
            local BullBlip = Citizen.InvokeNative(0x554D9D53F696D002, 1664425300, v.coords)
            SetBlipSprite(BullBlip, Config.BlipBull.blipSprite, 1)
            SetBlipScale(BullBlip, Config.BlipBull.blipScale)
            Citizen.InvokeNative(0x9CB1A1623062F402, BullBlip, Config.BlipBull.blipName)
        end
    end
end)

-- Delivery the bulls
Citizen.CreateThread(function()
    for bullmenu, v in pairs(Config.BullDelivery) do
        exports['rsg-core']:createPrompt(v.location, v.coords, RSGCore.Shared.Keybinds['J'], '' .. v.name, {
            type = 'client',
            event = 'rsg-grazebulls:client:bulljob2',
            args = {},
        })
        if v.showblip == true then
            local BullBlip = Citizen.InvokeNative(0x554D9D53F696D002, 1664425300, v.coords)
            SetBlipSprite(BullBlip, Config.BlipBull.blipSprite, 1)
            SetBlipScale(BullBlip, Config.BlipBull.blipScale)
            Citizen.InvokeNative(0x9CB1A1623062F402, BullBlip, Config.BlipBull.blipName)
        end
    end
end)

RegisterNetEvent('rsg-grazebulls:client:bulljob', function()
 exports['rsg-menu']:openMenu({
        {
            header = Lang:t('menu.job_shepherd'),
            icon = 'fas fa-solid fa-hat-cowboy',
            isMenuHeader = true,
        },
        {
            header = Lang:t('menu.job_bull'),
            txt = '',
            icon = 'fas fa-solid fa-cow',
            params = {
                event = 'rsg-grazebulls:client:bullspawn',
                args = {}
            }
        },
        {
            header = Lang:t('menu.close_menu'),
            icon = 'fas fa-xmark',
            params = {
                event = 'rsg-menu:closeMenu',
            }
        },
    })
end)

RegisterNetEvent('rsg-grazebulls:client:bulljob2', function()
    exports['rsg-menu']:openMenu({
           {
               header = Lang:t('menu.job_shepherd'),
               icon = 'fas fa-solid fa-hat-cowboy',
               isMenuHeader = true,
           },
            {
               header = Lang:t('menu.job_back'),
               txt = '',
               icon = 'fas fa-solid fa-cow',
               params = {
                   event = 'rsg-grazebulls:client:bullreturn',
                   args = {}
               }
           },
           {
               header = Lang:t('menu.close_menu'),
               icon = 'fas fa-xmark',
               params = {
                   event = 'rsg-menu:closeMenu',
               }
           },
       })
   end)

RegisterNetEvent('rsg-grazebulls:client:bullspawn')
AddEventHandler('rsg-grazebulls:client:bullspawn', function()
    if starting then 
        RSGCore.Functions.Notify(Lang:t('error.job_error'), 'error', 3000)
        return
    else    
        starting = true
        local bullCount = Config.BullCount
		local follow = Config.Follow
        local player = PlayerPedId()
        local playerCoords = GetEntityCoords(player)
        local randomChance = math.random(1, 100)
		
        for i = 1, bullCount do
            local hash = 'a_c_bull_01'
            RequestModel(hash)
            while not HasModelLoaded(hash) do
                Wait(10)
            end
            local randomX = 1886.1606 -- Примерный диапазон по X
            local randomY = -1407.375 -- Примерный диапазон по Y

            bull = CreatePed(hash, randomX, randomY, playerCoords.z, true, true, false)
            Citizen.InvokeNative(0x23f74c2fda6e7c61, -1749618580, bull)
            Citizen.InvokeNative(0x77FF8D35EEC6BBC4, bull, 0, false)
			SetEntityAsMissionEntity(animal, true)
		if follow then
			local bullOffset = vector3(0.0, 2.0, 0.0) 
			TaskFollowToOffsetOfEntity(bull, player, bullOffset.x, bullOffset.y, bullOffset.z, 1.0, -1, 0.0, 1)
            SetRelationshipBetweenGroups(1, GetPedRelationshipGroupHash(bull), joaat('PLAYER'))

		end
            table.insert(pasturingBulls, bull) 
			Wait(500)
        end 
		
        for _, bullId in ipairs(pasturingBulls) do
            exports['rsg-target']:AddTargetEntity(bullId, {
                options = {
                    {
                        type = 'client',
                        label = Lang:t('menu.lead_menu'),
                        targeticon = 'fas fa-solid fa-cow',
                        action = function()
                            TriggerEvent('rsg-grazebulls:client:lead', bullId)
                        end,
                    },
                    {
                        type = 'client',
                        label = Lang:t('menu.to_graze'),
						targeticon = 'fas fa-solid fa-cow',
                        action = function()
                            TriggerEvent('rsg-grazebulls:client:pas', bullId)
                        end,
                    },
					{
                        type = 'client',
                        label = Lang:t('menu.bull_stop'),
						targeticon = 'fas fa-solid fa-cow',
                        action = function()
                            TriggerEvent('rsg-grazebulls:client:startanim', bullId)
                        end,
                    }
                },
                distance = 10,
            })
		end
		
        if randomChance <= Config.RandomChance then
            TriggerEvent('rsg-grazebulls:client:hunters')
        end
    end
end)

RegisterNetEvent('rsg-grazebulls:client:lead')
AddEventHandler('rsg-grazebulls:client:lead', function(bull)
if IsPedDeadOrDying(bull, true) then
	RSGCore.Functions.Notify(Lang:t('error.dead_bulls'), 'error', 3000)
return end
		local player = PlayerPedId()
		local playerCoords = GetEntityCoords(player)
		local bullOffset = vector3(0.0, 2.0, 0.0) 
		ClearPedTasks(bull)
		TaskFollowToOffsetOfEntity(bull, player, bullOffset.x, bullOffset.y, bullOffset.z, 1.0, -1, 0.0, 1)
end)

RegisterNetEvent('rsg-grazebulls:client:startanim')
AddEventHandler('rsg-grazebulls:client:startanim', function(animal)
if IsPedDeadOrDying(animal, true) then
	RSGCore.Functions.Notify(Lang:t('error.dead_bulls'), 'error', 3000)
return end

    if DoesEntityExist(animal) then
		local availableScenarios = {
			"WORLD_ANIMAL_BULL_GRAZING",
			"WORLD_ANIMAL_BULL_RESTING",
			"WORLD_ANIMAL_BULL_SLEEPING"
		}
		local randomScenario = availableScenarios[math.random(1, #availableScenarios)]
		local anim = randomScenario
		ClearPedTasks(animal)
		TaskStartScenarioInPlace(animal, GetHashKey(anim), -1, true, false, false, false)
	end
end)

RegisterNetEvent('rsg-grazebulls:client:pas')
AddEventHandler('rsg-grazebulls:client:pas', function(animal)
	if IsPedDeadOrDying(animal, true) then
		RSGCore.Functions.Notify(Lang:t('error.dead_bulls'), 'error', 3000)
		return 
	end
	if isFinish then
		RSGCore.Functions.Notify(Lang:t('success.bull_finish'), 'success', 3000)
        return
    end
	if isPasturing then
		RSGCore.Functions.Notify(Lang:t('error.bull_already'), 'error', 3000)
        return
    end
	
	local isInZone = false
	
    for _, bull in ipairs(pasturingBulls) do
        if DoesEntityExist(bull) then
            for _, zoneCoords in ipairs(Config.BullZone) do
                local distance = #(zoneCoords - GetEntityCoords(bull))
                if distance <= Config.ZoneDist then
                    isInZone = true
                    break
                end
            end
            if isInZone then
                break
            end
        end
    end

    if isInZone then
        RSGCore.Functions.Notify(Lang:t('error.lead_ranch'), 'error', 3000)
    else
		
    for i = 1, #pasturingBulls do
      local bull = pasturingBulls[i]
        if DoesEntityExist(bull) then
			local availableScenarios = {
				"WORLD_ANIMAL_BULL_GRAZING",
				"WORLD_ANIMAL_BULL_RESTING",
				"WORLD_ANIMAL_BULL_SLEEPING"
			}
			local randomScenario = availableScenarios[math.random(1, #availableScenarios)]
			local anim = randomScenario
			TaskStartScenarioInPlace(bull, GetHashKey(anim), -1, true, false, false, false)
		end
	end
        RSGCore.Functions.Notify(Lang:t('success.bull_grazing'), 'success', 3000)
	isPasturing = true
    pasturingStartTime = GetGameTimer()
	startPasturing()
    end
end)

function modelrequest( model )
    Citizen.CreateThread(function()
        RequestModel( model )
    end)
end

RegisterNetEvent('rsg-grazebulls:client:hunters')
AddEventHandler('rsg-grazebulls:client:hunters', function()
   local waitExpectation = math.random(Config.WaitHuntersMin, Config.WaitHuntersMax)
	Citizen.Wait(waitExpectation)
    local npcList = {} 

    local playerCoords = GetEntityCoords(PlayerPedId())
    local spawnDistance = Config.DistanceHunters  

    for z, x in pairs(Config.Hunters) do
        while not HasModelLoaded(GetHashKey(Config.Hunters[z]["Model"])) do
            Wait(500)
            modelrequest(GetHashKey(Config.Hunters[z]["Model"]))
        end
        local spawnX = playerCoords.x + (math.random() - 0.5) * spawnDistance
        local spawnY = playerCoords.y + (math.random() - 0.5) * spawnDistance
        local npc = CreatePed(GetHashKey(Config.Hunters[z]["Model"]), spawnX, spawnY, playerCoords.z, playerCoords.h, true, false, 0, 0)

        while not DoesEntityExist(npc) do
            Wait(300)
        end

        Citizen.InvokeNative(0x283978A15512B2FE, npc, true) 
        GiveWeaponToPed_2(npc, 0x64356159, 500, true, 1, false, 0.0)
        TaskCombatPed(npc, PlayerPedId())

        table.insert(npcList, npc)
    end

    Citizen.CreateThread(function()
        while true do
            Wait(5000)
            local player = Citizen.InvokeNative(0x217E9DC48139933D)
			
            if IsPlayerDead(player) then
		
                for _, npc in ipairs(npcList) do
                    if DoesEntityExist(npc) then
                        DeletePed(npc)
                    end
                end
				for _, bullInfo in ipairs(pasturingBulls) do
					if DoesEntityExist(bullInfo) then
					DeletePed(bullInfo)
					end
				end
				npcList = {} 
				pasturingBulls = {}
				starting = false
				isPasturing = false
                RSGCore.Functions.Notify(Lang:t('error.error_dead'), 'error', 3000)
                break
            end
        end
    end)
end)

RegisterNetEvent('rsg-grazebulls:client:bullreturn')
AddEventHandler('rsg-grazebulls:client:bullreturn', function()
    if isPasturing then
        local currentTime = GetGameTimer()
        local elapsedTime = currentTime - pasturingStartTime
        
        if elapsedTime >= Config.WaitTimeBull then
            local isInZone = false
            local isBullKilled = false
            
            for _, bull in ipairs(pasturingBulls) do
                if DoesEntityExist(bull) then
                    if IsPedDeadOrDying(bull, true) then
                        isBullKilled = true
                        break
                    end
                    
                    for _, zoneCoords in ipairs(Config.BullZoneReturn) do
                        local distance = #(zoneCoords - GetEntityCoords(bull))
                        if distance > 20 then
                            isInZone = true
                            break
                        end
                    end
                    if isInZone then
                        break
                    end
                end
            end
            
            if isInZone then
                RSGCore.Functions.Notify(Lang:t('error.error_bullback'), 'error', 3000)
            else
                for i, bullInfo in ipairs(pasturingBulls) do
                    SetEntityInvincible(bullInfo, false)
                    ClearPedTasks(bullInfo)
                    DeletePed(bullInfo)
                end
                pasturingBulls = {}
                starting = false
                if not isBullKilled then
				RSGCore.Functions.Notify(Lang:t('success.success_bull'), 'success', 3000)
                    TriggerServerEvent('rsg-grazebulls:server:givemoney')
				else
                RSGCore.Functions.Notify(Lang:t('error.dead_bull'), 'error', 3000)
                end
                isPasturing = false
				isFinish = false
            end
        else
            RSGCore.Functions.Notify(Lang:t('error.error_time'), 'error', 3000)
        end
    else
        RSGCore.Functions.Notify(Lang:t('error.error_bull'), 'error', 3000)
    end
end)

function startPasturing()
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(10000)
            
            if isPasturing then
                local currentTime = GetGameTimer()
                local elapsedTime = currentTime - pasturingStartTime
                local remainingTime = Config.WaitTimeBull - elapsedTime
                
                if elapsedTime >= Config.WaitTimeBull then
                    RSGCore.Functions.Notify(Lang:t('success.time_grazing'), 'success', 6000)
					isFinish = true
                    break
                end
                
                local remainingMinutes = math.floor(remainingTime / 60000) 
                
                if remainingMinutes > 0 and currentTime - lastNotificationTime >= 60000 then
                    RSGCore.Functions.Notify(Lang:t('primary.minutes_left') .. remainingMinutes, 'primary', 6000)
                    lastNotificationTime = currentTime
                end
            end
        end
    end)
end
