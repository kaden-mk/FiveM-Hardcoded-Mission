players = {}
buckets = 1
missionCount = 0

function OnPlayerJoined()
    if players[source] then return end

    players[source] = { isInMission = false, missionSelected = nil }
end

function UpdateMissionCount()
    for playerSrc, playerData in pairs(players) do
        TriggerClientEvent("mission:setVoteCount", playerSrc, missionCount)
    end
end

function StartMission(players)
    -- tp the players to a bucket
    for playerSrc, playerData in pairs(players) do
        SetPlayerRoutingBucket(playerSrc, buckets)

        TriggerClientEvent("chat:addMessage", playerSrc, {
            args = { "System", "You have been assigned to bucket: " .. buckets }
        })

        -- make the player start the mission
        TriggerClientEvent("mission:startMission", playerSrc, "MissionTest")
    end

    buckets = buckets + 1
end

function SetObjective()
    -- TODO: maybe finish this? idrk how this is gonna work
end