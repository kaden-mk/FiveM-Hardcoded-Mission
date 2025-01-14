-- mission data

x, y, z = -829.14, 170.97, 69.26
missionLocation = vector3(x, y, z)
pacificStandardLocation = vector3(249.09, 193.62, 104.94)
angledAreaLocation = vector3(244.62, 192.47, 105.02)
bankCoords = vector3(230, 214.18, 105.55)
objectives = {
    goToPS = { index = 1, clientCheck = true, distanceThreshold = 10 },
    enterBank = { index = 2, clientCheck = false, distanceThreshold = 10, setBlipCoords = false }
}
currentObjective = objectives.goToPS
scale = 3.0
pacificDoors = {
    [1] = { position = vector3(232.6054, 214.1584, 106.4049), modelHash = 110411286, state = 1 }, -- Pacific Standard Bank Main Right Door
    [2] = { position = vector3(231.5123, 216.5177, 106.4049), modelHash = 110411286, state = 1 }, -- Pacific Standard Bank Main Left Door
    [3] = { position = vector3(260.6432, 203.2052, 106.4049), modelHash = 110411286, state = 1 }, -- Pacific Standard Bank Back Right Door
    [4] = { position = vector3(258.2022, 204.1005, 106.4049), modelHash = 110411286, state = 1 }, -- Pacific Standard Bank Back Left Door
    [5] = { position = vector3(237.7704, 227.87, 106.426), modelHash = 1956494919, state = 1 }, -- Pacific Standard Bank Door To Upstair
    [6] = { position = vector3(236.5488, 228.3147, 110.4328), modelHash = 1956494919, state = 1 }, -- Pacific Standard Bank Upstair Door
    [7] = { position = vector3(259.9831, 215.2468, 106.4049), modelHash = 110411286, state = 1 }, -- Pacific Standard Bank Back To Hall Right Door
    [8] = { position = vector3(259.0879, 212.8062, 106.4049), modelHash = 110411286, state = 1 }, -- Pacific Standard Bank Back To Hall Left Door
    [9] = { position = vector3(256.6172, 206.1522, 110.4328), modelHash = 1956494919, state = 1 }, -- Pacific Standard Bank Upstair Door To Offices
    [10] = { position = vector3(260.8579, 210.4453, 110.4328), modelHash = 964838196, state = 1 }, -- Pacific Standard Bank Big Office Door
    [11] = { position = vector3(262.5366, 215.0576, 110.4328), modelHash = 964838196, state = 1 } -- Pacific Standard Bank Small Office Door
}