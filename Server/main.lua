local QBCore = exports['qb-core']:GetCoreObject()

-- Useable Items
QBCore.Functions.CreateUseableItem('headbag', function(source)
    TriggerClientEvent('Crazy:Client:UseHeadBag', source)
end)

QBCore.Functions.CreateUseableItem('ziptie', function(source)
    TriggerClientEvent('Crazy:Client:UseZiptie', source)
end)

-- Ziptie Events
RegisterNetEvent('Crazy:Server:ZiptiePlayer', function(playerId)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local ZiptiedPlayer = QBCore.Functions.GetPlayer(playerId)

    if not Player or not ZiptiedPlayer then return end

    local playerPed = GetPlayerPed(src)
    local targetPed = GetPlayerPed(playerId)
    if #(GetEntityCoords(playerPed) - GetEntityCoords(targetPed)) > 3.0 then 
        return TriggerClientEvent('QBCore:Notify', src, 'You are too far away', 'error')
    end

    if Player.Functions.RemoveItem('ziptie', 1) then
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['ziptie'], 'remove')
        TriggerClientEvent("Crazy:Client:GetZiptied", ZiptiedPlayer.PlayerData.source, Player.PlayerData.source)
    end
end)

RegisterNetEvent('Crazy:Server:UnZiptie', function(targetId)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local UnZiptiedPlayer = QBCore.Functions.GetPlayer(targetId)

    if not Player or not UnZiptiedPlayer then return end

    local playerPed = GetPlayerPed(src)
    local targetPed = GetPlayerPed(targetId)
    if #(GetEntityCoords(playerPed) - GetEntityCoords(targetPed)) > 3.0 then 
        return TriggerClientEvent('QBCore:Notify', src, 'You are too far away', 'error')
    end

    for _, item in ipairs(Config.UnZipItems) do
        if QBCore.Functions.HasItem(src, item) then
            TriggerClientEvent('Crazy:Client:GetUnZiptied', UnZiptiedPlayer.PlayerData.source, Player.PlayerData.source)
            return
        end
    end
    TriggerClientEvent('QBCore:Notify', src, 'You don\'t have the right tool to cut the ziptie', 'error')
end)

-- Bag Events
RegisterNetEvent('Crazy:Server:PutBagOn', function(targetId)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local Target = QBCore.Functions.GetPlayer(targetId)

    if not Player or not Target then return end

    local playerPed = GetPlayerPed(src)
    local targetPed = GetPlayerPed(targetId)
    if #(GetEntityCoords(playerPed) - GetEntityCoords(targetPed)) > 3.0 then 
        return TriggerClientEvent('QBCore:Notify', src, 'You are too far away', 'error')
    end

    if Player.Functions.RemoveItem('headbag', 1) then
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['headbag'], 'remove')
        TriggerClientEvent('Crazy:Client:GetBagOnHead', Target.PlayerData.source, Player.PlayerData.source)
    end
end)

RegisterNetEvent('Crazy:Server:BagOff', function(targetId)
    local src = source
    local Target = QBCore.Functions.GetPlayer(targetId)

    if not Target then return end

    TriggerClientEvent('Crazy:Client:GetBagOff', Target.PlayerData.source, src)
end)