-- Event handlers for mission state and vote count

local isInVote = false 
local players = 0

RegisterNetEvent("mission:setVoteCount")
AddEventHandler("mission:setVoteCount", function(number)
    players = number
end)

-- Main thread for managing the mission marker and vote system
CreateThread(function()
    -- Creating the mission blip
    local missionBlip = CreateBlip({
        coords = missionLocation,
        name = "Why did I move here? I guess it was the weather.",
        icon = 78,
        display = 4,
        scale = 0.8,
        color = 3,
        shortRange = true
    })

    -- Creating the mission marker
    while true do
        SetBlipAlpha(missionBlip, isInMission and 0 or 255)

        if not isInMission then
            DrawMarker(1, x, y, z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, scale, scale, scale, 255, 255, 0, 50, false, true, 2)

            -- Drawing the 3D text above the marker
            DrawText3D(x, y, z + 2, string.format("Players ready: [%d/4]", players))

            local playerPos = GetEntityCoords(PlayerPedId())
            local distance = #(playerPos - missionLocation)

            if not isInVote and distance < scale then
                ShowHelpNotification("Press ~INPUT_CONTEXT~ to enter vote.")
                if IsControlJustReleased(0, 51) then
                    isInVote = true
                    TriggerServerEvent("mission:enterVote", "mission test")
                end
            elseif isInVote and distance > scale then
                isInVote = false
                TriggerServerEvent("mission:leaveVote")
            end
        end

        Wait(0)
    end
end)