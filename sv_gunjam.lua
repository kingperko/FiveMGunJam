RegisterServerEvent('PerkoGunjamBypass:CheckIsPlayerGunjamBypass')
AddEventHandler('PerkoGunjamBypass:CheckIsPlayerGunjamBypass', function()
    local playerId = source
    local hasBypassPermission = IsPlayerAceAllowed(playerId, "perkogunjam.bypass")
    if hasBypassPermission then
        TriggerClientEvent('PerkoGunjamBypass:ReturnIfPlayerGunjamBypass', playerId, true)
    else
        TriggerClientEvent('PerkoGunjamBypass:ReturnIfPlayerGunjamBypass', playerId, false)
    end
end)
