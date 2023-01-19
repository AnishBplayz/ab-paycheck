local QBCore = exports['qb-core']:GetCoreObject()

----------------- EVENTS -----------------

RegisterServerEvent('ab-paychecks:Register', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end
    local PlayerData = Player.PlayerData
	local cid = PlayerData.citizenid
    local payment = PlayerData.job.payment
    if PlayerData.job.onduty then
        MySQL.fetch("SELECT * FROM `paychecks` WHERE citizenid = '"..cid.."'", function(result)
            if result[1] then
                local collectamount = result[1].collectamount + payment
                local currentpaycheck = result[1].collectamount
                MySQL.update("UPDATE paychecks SET collectamount = '"..collectamount.."' WHERE citizenid = '"..cid.."'")
                if Config.Notify then
                    TriggerClientEvent('QBCore:Notify', src, 'Your paycheck has been sent to Life Invader! Head there to collect it at your convenience.')
                else
                    TriggerClientEvent("ab-paycheck:client:sendregistermail", Player.PlayerData.source)
                end
                Wait(1000)
                TriggerEvent("qb-log:server:CreateLog", "paychecks", "Paychecks", "white", " | "..cid.." now has "..collectamount.." waiting as a paycheck")
            else
                MySQL.insert("INSERT INTO `paychecks` (`citizenid`, `collectamount`) VALUES ('"..cid.."', '"..payment.."')")
            end
        end)
    end
end)

RegisterServerEvent('ab-paychecks:Collect', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end
    local PlayerData = Player.PlayerData
	local cid = PlayerData.citizenid
    local payment = PlayerData.job.payment
    MySQL.fetch("SELECT * FROM `paychecks` WHERE citizenid = '"..cid.."'", function(result)
        if result[1] then
            local Paycheck = result[1].collectamount
            if Paycheck > 0 then
                Player.Functions.AddMoney("cash", Paycheck)
                if Config.apGov then
                    TriggerEvent('ap-government:server:systemTax', Player.PlayerData.source, "Player", Paycheck)
                end
                MySQL.update("UPDATE paychecks SET collectamount = 0 WHERE citizenid = '"..cid.."'")
                if Config.Notify then
                    TriggerClientEvent('QBCore:Notify', src, 'You received your Paycheck of '..Paycheck..'!')
                else
                    TriggerClientEvent("ab-paycheck:client:sendcollectionmail", Player.PlayerData.source, Paycheck)
                end
                TriggerEvent("qb-log:server:CreateLog", "paychecks", "Paychecks", "green", " | "..cid.." collected "..Paycheck.." from their paycheck")
            else
                if Config.Notify then
                    TriggerClientEvent('QBCore:Notify', src, "You don't have a Paycheck dude.")
                end
            end
        end
    end)
end)