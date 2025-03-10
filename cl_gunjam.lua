 local jammedList = {}
local random = math.random

local blacklist = {
    `WEAPON_STUNGUN`,
    `WEAPON_FLAREGUN`,
    `WEAPON_BZGAS`,
    `WEAPON_MOLOTOV`,
    `WEAPON_SNOWBALL`,
    `WEAPON_BALL`,
    `WEAPON_SMOKEGRENADE`,
    `WEAPON_FLARE`,
    `WEAPON_PETROLCAN`,
    `WEAPON_HAZARDCAN`,
    `WEAPON_FIREEXTINGUISHER`,
    `WEAPON_STICKYBOMB`,
    `WEAPON_GRENADE`,
    `WEAPON_TEARGAS`,
    `WEAPON_PROXMINE`,
    `WEAPON_MOLOTOV`,
    `WEAPON_PIPEBOMB`,
    `WEAPON_GRENADELAUNCHER`,
    `WEAPON_RPG`,
    `WEAPON_MINIGUN`,
    `WEAPON_FIREWORK`,
    `WEAPON_RAILGUN`,
    `WEAPON_HOMINGLAUNCHER`,
    `WEAPON_COMPACTLAUNCHER`,
    `WEAPON_RAYMINIGUN`,
    `WEAPON_RAYPISTOL`,
    `WEAPON_LLPUMPSHOTGUN`,
    `WEAPON_HOSE`,
    `WEAPON_FERTILIZERCAN`
}

local function findJammedWeapon()
    local weapon = GetSelectedPedWeapon(PlayerPedId())

    for i = 1, #jammedList do
        if jammedList[i] == weapon then
            return true, i
        end
    end

    return false
end

local function isBlacklisted(model)
    for i = 1, #blacklist do
        if blacklist[i] == model then
            return true
        end
    end

    return false
end

local function notify(text)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(text)
    DrawNotification(false, false)
end

CreateThread(function()
    while true do
        Wait(0)
        local weapon = GetSelectedPedWeapon(PlayerPedId())
        if not IsPedArmed(PlayerPedId(), 1) and IsPedShooting(PlayerPedId()) and not isBlacklisted(weapon) then
            local randomNum = random(1, 1000)
            if randomNum >= 995 and not UnjamEnabled() and not BypassGunjam() then
                jammedList[#jammedList + 1] = weapon
                TriggerServerEvent("Server:SoundToRadius", NetworkGetNetworkIdFromEntity(PlayerPedId()), 3, "jamed", 0.3)
                notify("~b~Gunjam~w~: Your gun has ~g~jammed~w~, type /unjam to unjam it.")
               
            
            end
        end
        if findJammedWeapon() and not IsPedArmed(ped, 1) then
            DisablePlayerFiring(ped, true)
        end
    end
end)

RegisterCommand("unjam", function()
    if findJammedWeapon() then
        notify("~b~Gunjam~w~: Unjamming gun ~c~(3 seconds)~w~.")
        ExecuteCommand("e knucklecrunch")
        SetTimeout(3000, function()
            ExecuteCommand("e c")
            TriggerServerEvent("Server:SoundToRadius", NetworkGetNetworkIdFromEntity(PlayerPedId()), 3, "unjam", 0.2)
            notify("~b~Gunjam~w~: Your gun has been ~g~unjammed~w~.")
            found, index = findJammedWeapon()
            if found then
                jammedList[index] = nil
            end
        end)
        Wait(5000)
    else
        notify("~b~Gunjam: ~w~Your gun is not jammed.")
    end
end, false)
TriggerEvent("chat:addSuggestion", "/unjam", "Unjam your weapon. Usage: /unjam")
RegisterKeyMapping('unjam', 'Unjam your weapon', 'keyboard', '')



Citizen.CreateThread(function()
    while true do
        Wait(500)
        TriggerServerEvent('PerkoGunjamBypass:CheckIsPlayerGunjamLEO')
    end
end)

PlayerIsLEOUnjam = false
RegisterNetEvent('PerkoGunjamBypass:ReturnIfPlayerGunjamLEO')
AddEventHandler('PerkoGunjamBypass:ReturnIfPlayerGunjamLEO', function(Allowed)
    if Allowed then
      PlayerIsLEOUnjam = true
    else
      PlayerIsLEOUnjam = false
    end
end)

function UnjamEnabled()
    return PlayerIsLEOUnjam
end

PlayerHasBypassGunjam = false
TriggerServerEvent('PerkoGunjamBypass:CheckIsPlayerGunjamBypass')
RegisterNetEvent('PerkoGunjamBypass:ReturnIfPlayerGunjamBypass')
AddEventHandler('PerkoGunjamBypass:ReturnIfPlayerGunjamBypass', function(Allowed)
    if Allowed then
      PlayerHasBypassGunjam = true
    else
      PlayerHasBypassGunjam = false
    end
end)

function BypassGunjam()
    return PlayerHasBypassGunjam
end

