-- events
RegisterNetEvent("playerJoining", OnPlayerJoined)

-- enterVote
RegisterNetEvent("mission:enterVote")
AddEventHandler("mission:enterVote", function(mission)
    local playerData = players[source]

    if not playerData then
        players[source] = { isInMission = false, missionSelected = nil }
        playerData = players[source]
    end
    if playerData.isInMission == true or playerData.missionSelected ~= nil then print("FUCK you") return end

    playerData.missionSelected = mission
    missionCount = missionCount + 1

    UpdateMissionCount()

    -- Check if the missionCount is the same as the players inside the marker for the next 2 seconds then start the mission
    Wait(2000)

    local playersInRange = {}
    local playerCount = 0

    for playerSrc, playerData in pairs(players) do
        local playerPed = GetPlayerPed(playerSrc)
        local playerPosition = GetEntityCoords(playerPed)
        local distance = #(playerPosition - missionLocation)

        if distance < scale then
            playersInRange[playerSrc] = playerData
            playerCount = playerCount + 1 
        end
    end

    -- see if playersInRange = missionCount
    if playerCount == missionCount then
        StartMission(playersInRange)
    end
end)

-- leave
RegisterNetEvent("mission:leaveVote")
AddEventHandler("mission:leaveVote", function()
    local playerData = players[source]

    if not playerData then
        players[source] = { isInMission = false, missionSelected = nil }
        playerData = players[source]
    end
    if playerData.missionSelected == nil then print("mission is not selected") return end

    playerData.missionSelected = nil
    missionCount = missionCount - 1

    UpdateMissionCount()
end)