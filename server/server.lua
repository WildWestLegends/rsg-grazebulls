local RSGCore = exports['rsg-core']:GetCoreObject()

RegisterServerEvent('rsg-grazebulls:server:givemoney')
AddEventHandler('rsg-grazebulls:server:givemoney', function()
    local Player = RSGCore.Functions.GetPlayer(source)
	local moneyReward = Config.MoneyReward
	Player.Functions.AddMoney('cash', moneyReward)
end)