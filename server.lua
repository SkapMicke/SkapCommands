local QBCore = exports['qb-core']:GetCoreObject()

local webhookURL = "YOUR_DISCORD_WEBHOOK_HERE"

RegisterCommand('ban', function(source, args)
    local playerId = tonumber(args[1])
    local reason = args[2] or "No reason provided"
    local days = tonumber(args[3]) or 0
    local hours = tonumber(args[4]) or 0
    local minutes = tonumber(args[5]) or 0

    if playerId then
        local targetPlayer = QBCore.Functions.GetPlayer(playerId)
        if targetPlayer then
            local banTime = (days * 24 * 60 * 60) + (hours * 60 * 60) + (minutes * 60)
            local expirationDate = os.date('%Y-%m-%d %H:%M:%S', os.time() + banTime)
            local playerIdentifier = targetPlayer.PlayerData.license
            local bannedBy = GetPlayerName(source)

            exports.oxmysql:insert("INSERT INTO banned_players (player_id, reason, ban_time, ban_expiration, banned_by) VALUES (?, ?, ?, ?, ?)", {
                playerIdentifier, reason, banTime, expirationDate, bannedBy
            })

            DropPlayer(targetPlayer.PlayerData.source, "You got banned for: " .. reason)

            local message = string.format("**Player:** %s (ID: %s)\n**banned for:** %s\n**Av:** %s\n**Legth:** %d Days, %d hours, %d minutes", 
                targetPlayer.PlayerData.name, playerId, reason, bannedBy, days, hours, minutes)
            SendWebhookMessage(webhookURL, message)

            TriggerClientEvent('QBCore:Notify', source, 'Player got banned!', 'success')
        else
            TriggerClientEvent('QBCore:Notify', source, 'Invald Player', 'error')
        end
    else
        TriggerClientEvent('QBCore:Notify', source, 'You must enter a player', 'error')
    end
end, true)

RegisterCommand('kick', function(source, args)
    local playerId = tonumber(args[1])
    local reason = table.concat(args, " ", 2) or "No reason provided"

    if playerId then
        local targetPlayer = QBCore.Functions.GetPlayer(playerId)
        if targetPlayer then
            DropPlayer(targetPlayer.PlayerData.source, "You have been kicked from the server for: " .. reason)

            local message = string.format("**Player:** %s (ID: %s)\n**kicked for:** %s\n**Av:** %s", 
                targetPlayer.PlayerData.name, playerId, reason, GetPlayerName(source))
            SendWebhookMessage(webhookURL, message)

            TriggerClientEvent('QBCore:Notify', source, 'Player got kicked with reason: ' .. reason, 'success')
        else
            TriggerClientEvent('QBCore:Notify', source, 'Invalid player', 'error')
        end
    else
        TriggerClientEvent('QBCore:Notify', source, 'You must enter a player', 'error')
    end
end, true)

function SendWebhookMessage(webhookURL, message)
    PerformHttpRequest(webhookURL, function(err, text, headers) end, 'POST', json.encode({content = message}), { ['Content-Type'] = 'application/json' })
end
