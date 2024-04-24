Config = Config or {}


Config.BullCount = 5 --Number of bulls
Config.Follow = true -- after spawn, the bulls will immediately follow you
Config.ZoneDist = 100 --how far should the bulls be driven away from the ranch
Config.WaitHuntersMin = 120000 -- minimum wait time for npc to spawn (120000 - 2 minutes)
Config.WaitHuntersMax = 360000 --maximum wait time for npc to spawn (360000 - 6 minutes)
Config.WaitTimeBull = 600000 --how long do bulls need to graze (600000 - 10 minutes)
Config.DistanceHunters = 100.0 -- hunter spawn distance from player
Config.RandomChance = 35 -- hunter spawn chance
Config.MoneyReward = 200 --how much money the player will receive

Config.BlipBull = {
    blipName = 'Job: Pastor de Toros', 
    blipSprite = 423351566, 
    blipScale = 0.2 
}

Config.Bull = {
    {name = 'Trabajo: Pastor de Toros', location = 'jobbull',  coords = vector3(1878.1232, -1408.471, 41.957832 -0.8),  showblip = true},
}

-- counted from these coordinates Config.ZoneDist
Config.BullZone = {
    vector3(1878.1232, -1408.471, 41.957832 - 0.8),

}
Config.BullZoneReturn = {
    vector3(1414.0854, 285.14892, 89.205772 -0.8),

}
Config.BullDelivery = {
    {name = 'Trabajo: Pastor de Toros', location = 'jobbull2',  coords = vector3(1414.0854, 285.14892, 89.205772 -0.8),  showblip = true},
}

Config.Hunters = {
    [1] = { ["Model"] = "G_M_O_UniExConfeds_01" },
    [2] = { ["Model"] = "G_M_Y_UniExConfeds_01" },
    --[3] = { ["Model"] = "CS_exconfedsleader_01"},
    --[4] = { ["Model"] = "G_M_Y_UNIEXCONFEDS_02" },
    --[5] = { ["Model"] = "U_M_M_UniExConfedsBounty_01"},
}

