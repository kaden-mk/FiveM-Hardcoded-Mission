-- functions

-- Shows a notification text at the top left of the screen
function ShowHelpNotification(text)
    BeginTextCommandDisplayHelp("STRING")
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandDisplayHelp(0, false, true, -1)
end

-- Draws 3D text at specified coordinates
function DrawText3D(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local camCoords = GetGameplayCamCoords()
    local dist = #(vector3(x, y, z) - camCoords)

    local scale = (1 / dist) * (1 / GetGameplayCamFov()) * 100

    if onScreen then
        SetTextScale(0.0, scale)
        SetTextFont(0)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 215)
        SetTextOutline()

        SetTextEntry("STRING")
        AddTextComponentString(text)
        DrawText(_x, _y)
    end
end

blips = {}

-- Creates a blip with customizable properties
function CreateBlip(settings)
    local blip = AddBlipForCoord(settings.coords)
    SetBlipSprite(blip, settings.icon)
    SetBlipDisplay(blip, settings.display)
    SetBlipAsShortRange(blip, settings.shortRange)
    SetBlipScale(blip, settings.scale)
    SetBlipColour(blip, settings.color)

    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(settings.name)
    EndTextCommandSetBlipName(blip)

    if settings.blipRoute then
        SetBlipRoute(blip, true)
    end

    blips[settings.name] = blip

    return blip
end

-- Updates any existing blip using the name
function UpdateBlipCoords(blipName, newCoords)
    local blip = blips[blipName]

    if not blip then return end

    SetBlipCoords(blip, newCoords)
end

-- Plays a cutscene
function PlayCutscene(name, replaceEntity)
    if not name or name == "" then
        print("Invalid cutscene name provided!")
        return true
    end

    RequestCutscene(name, 8)

    while not HasCutsceneLoaded() do
        Wait(0)
    end

    local playerPed = PlayerPedId()
    if replaceEntity and replaceEntity ~= "" then
        SetCutscenePedComponentVariationFromPed(replaceEntity, playerPed, 0)
        RegisterEntityForCutscene(playerPed, replaceEntity, 0, 0, 64)
    end

    StartCutscene(0)
    
    while GetCutsceneTime() < GetCutsceneTotalDuration() do
        if IsDisabledControlJustReleased(0, 24) or IsDisabledControlJustReleased(0, 200) or IsDisabledControlJustReleased(0, 22) then
            break
        end

        Wait(0)
    end

    StopCutsceneImmediately()
    RemoveCutscene()

    return true
end

-- Sets the current objective
function SetObjective(objective, time)
    ClearPrints()
    BeginTextCommandPrint("STRING") 
    AddTextComponentString(objective)
    EndTextCommandPrint(time or 999999999, true)
end

ClearPrints() -- just incase any prints were there after restart

-- Sets 1 door's state
function SetDoorState(doorData)
    local position = doorData.position
    local modelHash = doorData.modelHash

    doorEntity = GetClosestObjectOfType(position, 5.0, modelHash, false, false, false)

    if not IsDoorRegisteredWithSystem(doorEntity) then  
        AddDoorToSystem(doorEntity, modelHash, position.x, position.y, position.z, false, false, true)
    end

    DoorSystemSetDoorState(doorEntity, doorData.state, false, true)
end

-- Sets the state of a list of doors and if it doesn't exist in the system it'll add it
function SetDoorsState(doors)
    -- Table should look like this Doors = { [index] = { position = vector3(x, y, z), state = number, modelHash = number } }

    for _, doorData in pairs(doors) do
        SetDoorState(doorData)
    end
end

isInMission = false

-- Start the mission on the client (missionName isnt needed im just doing it for no reason)
function StartMission(missionName)
    -- this is pretty much where the entire mission will get ran
    isInMission = true

    -- LOCK PACIFIC STANDARD DOORS
    PlayCutscene("family_3_int", "Michael") -- this yields which is good, after it finishes continue making the mission things

    -- Create the first blip
    local pacificBlip = CreateBlip({
        coords = pacificStandardLocation,
        name = "Destination",
        icon = 146,
        display = 4,
        scale = 0.8,
        color = 5,
        shortRange = false,
        blipRoute = true
    })

    -- Set the objective
    SetObjective("Go to the ~y~Pacific Standard Bank.")

    -- Main mission thread
    CreateThread(function()
        -- Main mission loop
        local playerPed = PlayerPedId()

        while true do
            -- things
            local playerPosition = GetEntityCoords(playerPed)

            -- pls lua add switch cases, this is fucking horrible
            if currentObjective == objectives.goToPS then
                SetDoorsState(pacificDoors)

                -- check if the player has reached that point
                local distance = #(playerPosition - pacificStandardLocation)

                if distance <= currentObjective.distanceThreshold then
                    SetObjective("Enter the ~y~bank.")
                    currentObjective = objectives.enterBank
                end
            elseif currentObjective == objectives.enterBank then
                if currentObjective.setBlipCoords == false then
                    SetBlipCoords(pacificBlip, bankCoords)
                end

                -- check if the player has reached that point
                local distance = #(playerPosition - bankCoords)

                if distance <= currentObjective.distanceThreshold then
                    -- TODO: Check if the rest of the players have also went to the spot
                end
            end

            Wait(0)
        end
    end)
end
RegisterNetEvent("mission:startMission")
AddEventHandler("mission:startMission", StartMission)