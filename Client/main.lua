local QBCore = exports['qb-core']:GetCoreObject()
local BagOnHead = false
local isZiptied = false
local OGOutfit = {}

-- Functions
local function loadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Wait(5)
    end
end

local function playZiptieAnimation(ped, animType)
    loadAnimDict("mp_arrest_paired")
    if animType == "ziptier" then
        TaskPlayAnim(ped, "mp_arrest_paired", "cop_p2_back_right", 3.0, 3.0, -1, 48, 0, 0, 0, 0)
        Wait(3500)
        TaskPlayAnim(ped, "mp_arrest_paired", "exit", 3.0, 3.0, -1, 48, 0, 0, 0, 0)
    elseif animType == "ziptied" then
        TaskPlayAnim(ped, "mp_arrest_paired", "crook_p2_back_right", 3.0, 3.0, -1, 32, 0, 0, 0, 0)
        Wait(2500)
    end
end

-- Head Bag Events
RegisterNetEvent('Crazy:Client:UseHeadBag', function()
    local player, distance = QBCore.Functions.GetClosestPlayer()
    if player ~= -1 and distance < 3.0 then
        TriggerServerEvent('Crazy:Server:PutBagOn', GetPlayerServerId(player))
    else
        QBCore.Functions.Notify('No one nearby', 'error')
    end
end)

RegisterNetEvent('Crazy:Client:GetBagOnHead', function()
    local ped = PlayerPedId()
    DoScreenFadeOut(0)
    BagOnHead = true
    OGOutfit.draw = GetPedDrawableVariation(ped, 1)
    OGOutfit.tex = GetPedTextureVariation(ped, 1)
    SetPedComponentVariation(ped, 1, Config.BagSelection, Config.BagTexture, 0)
    QBCore.Functions.Notify('A bag has been put on your head', 'error')
    SetTimeout(Config.BagFallOffWait * 60000, function()
        if BagOnHead then
            TriggerEvent('Crazy:Client:TakeBagOff')
        end
    end)
end)

RegisterNetEvent('Crazy:Client:GetBagOff', function()
    BagOnHead = false
    DoScreenFadeIn(1000)
    SetPedComponentVariation(PlayerPedId(), 1, OGOutfit.draw, OGOutfit.tex, 0)
    QBCore.Functions.Notify('The bag has been removed from your head', 'success')
end)

RegisterNetEvent('Crazy:Client:TakeBagOff', function()
    BagOnHead = false
    DoScreenFadeIn(1000)
    SetPedComponentVariation(PlayerPedId(), 1, OGOutfit.draw, OGOutfit.tex, 0)
    QBCore.Functions.Notify('You managed to get the bag off', 'success')
end)

-- Ziptie Events
RegisterNetEvent('Crazy:Client:UseZiptie', function()
    local player, distance = QBCore.Functions.GetClosestPlayer()
    if player ~= -1 and distance < 3.0 then
        local targetPed = GetPlayerPed(player)
        if IsEntityPlayingAnim(targetPed, "missminuteman_1ig_2", "handsup_base", 3) or IsEntityPlayingAnim(targetPed, "mp_arresting", "idle", 3) then
            TriggerServerEvent("Crazy:Server:ZiptiePlayer", GetPlayerServerId(player))
            playZiptieAnimation(PlayerPedId(), "ziptier")
        else
            QBCore.Functions.Notify('Target must have their hands up', 'error')
        end
    else
        QBCore.Functions.Notify('No one nearby', 'error')
    end
end)

RegisterNetEvent('Crazy:Client:GetZiptied', function(playerId)
    local ped = PlayerPedId()
    isZiptied = true
    TriggerServerEvent("police:server:SetHandcuffStatus", true)
    ClearPedTasksImmediately(ped)
    if GetSelectedPedWeapon(ped) ~= `WEAPON_UNARMED` then
        SetCurrentPedWeapon(ped, `WEAPON_UNARMED`, true)
    end
    playZiptieAnimation(ped, "ziptied")
    QBCore.Functions.Notify('You have been ziptied. Press [G] repeatedly to attempt escape.', 'primary')
end)

RegisterNetEvent('Crazy:Client:GetUnZiptied', function()
    local ped = PlayerPedId()
    isZiptied = false
    TriggerServerEvent("police:server:SetHandcuffStatus", false)
    ClearPedTasksImmediately(ped)
    QBCore.Functions.Notify('You have been released from zipties', 'success')
end)

-- QB-Target Integration
exports['qb-target']:AddGlobalPlayer({
    options = {
        {
            type = "client",
            event = "Crazy:Client:UseHeadBag",
            icon = Config.TargetOptions.RemoveBag.icon,
            label = Config.TargetOptions.RemoveBag.label,
            item = 'headbag',
            canInteract = function(entity)
                return not IsEntityPlayingAnim(entity, "mp_arresting", "idle", 3)
            end,
        },
        {
            type = "client",
            event = "Crazy:Client:UseZiptie",
            icon = Config.TargetOptions.CutZiptie.icon,
            label = Config.TargetOptions.CutZiptie.label,
            item = 'ziptie',
            canInteract = function(entity)
                return IsEntityPlayingAnim(entity, "missminuteman_1ig_2", "handsup_base", 3) or IsEntityPlayingAnim(entity, "mp_arresting", "idle", 3)
            end,
        },
    },
    distance = 2.5,
})

-- Main Thread
CreateThread(function()
    local escapeAttempts = 0
    while true do
        if isZiptied then
            DisableControlAction(0, 24, true) -- Attack
            DisableControlAction(0, 257, true) -- Attack 2
            DisableControlAction(0, 25, true) -- Aim
            DisableControlAction(0, 263, true) -- Melee Attack 1

            -- ... [other disabled controls remain the same]

            if IsControlJustPressed(0, 47) then -- G key
                escapeAttempts = escapeAttempts + 1
                if escapeAttempts >= Config.ZiptieWiggleAmount then
                    TriggerEvent('Crazy:Client:GetUnZiptied')
                    escapeAttempts = 0
                end
            end

            if not IsEntityPlayingAnim(PlayerPedId(), "mp_arresting", "idle", 3) and not QBCore.Functions.GetPlayerData().metadata["isdead"] then
                loadAnimDict("mp_arresting")
                TaskPlayAnim(PlayerPedId(), "mp_arresting", "idle", 8.0, -8, -1, 49, 0, 0, 0, 0)
            end
            Wait(0)
        else
            escapeAttempts = 0
            Wait(1000)
        end
    end
end)