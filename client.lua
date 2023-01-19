local QBCore = exports['qb-core']:GetCoreObject()
local PayCheckGenTime =(Config.PayCheckTime * 60000)

--------------------------------------------------------------------

CreateThread(function()   -- Blips
    for k, v in pairs(Config.PayCheckLocation) do
        if Config.PayCheckBlips then
            local LifeInvader = AddBlipForCoord(v.coords)
            SetBlipAsShortRange(LifeInvader, true)
            SetBlipSprite(LifeInvader, 521)
            SetBlipDisplay(LifeInvader, 4)
            SetBlipScale(LifeInvader, 0.7)
            BeginTextCommandSetBlipName('STRING')
            AddTextComponentString("Life Invader")
            EndTextCommandSetBlipName(LifeInvader)
        end
    end
end)

CreateThread(function()     -- PayCheck Loop
    while true do
        Wait(PayCheckGenTime)
        TriggerServerEvent('ab-paychecks:Register')
    end
end)

RegisterNetEvent('ab-paycheck:client:waypoint', function()
    for k, v in pairs(Config.PayCheckLocation) do
        local coords = v.coords
        SetNewWaypoint(coords.x, coords.y)
    end
end)

------------------------      Target      -----------------------------------

CreateThread(function()
    for k, v in pairs(Config.PayCheckLocation) do
        local coords = v.coords
        exports['qb-target']:AddBoxZone("PayCheckCollection"..k, vector3(coords.x, coords.y, coords.z), 1.5, 1.5, {
            name = 'PayCheckCollection'..k,
            heading = 240,
            debugPoly = false,
        }, {
            options = {
                {
                    type = "server",
                    event = "ab-paychecks:Collect",
                    icon = "fas fa-money-check-alt",
                    label = "Collect Paycheck",
                },
            },
            distance = 2.0
        })
    end
end)

---------------------------------- Mail-Event ----------------------------------

RegisterNetEvent('ab-paycheck:client:sendregistermail', function()
    if Config.PhoneMail.Enable then
        if Config.PhoneMail.Phone == "gks" then
            serverevent = 'gksphone:NewMail'
        elseif Config.PhoneMail.Phone == "qs" then 
            serverevent = 'qs-smartphone:server:sendNewMail'
        elseif Config.PhoneMail.Phone == "qb" then 
            serverevent = 'qb-phone:server:sendNewMail' 
        else
            print("Your phone isn't setup right or not supported !")
        end

        TriggerServerEvent(serverevent, {
            sender = "LifeInvader",
            subject = "Paycheck",
            message = 'Your paycheck has been sent to Life Invader! Head there to collect it at your convenience.',
            button = {}
        })
    end
end)

RegisterNetEvent('ab-paycheck:client:sendcollectionmail', function(amount)
    if Config.PhoneMail.Enable then
        if Config.PhoneMail.Phone == "gks" then
            serverevent = 'gksphone:NewMail'
        elseif Config.PhoneMail.Phone == "qs" then
            serverevent = 'qs-smartphone:server:sendNewMail'
        elseif Config.PhoneMail.Phone == "qb" then 
            serverevent = 'qb-phone:server:sendNewMail'
        else
            print("Your phone isn't setup right or not supported !")
        end

        TriggerServerEvent(serverevent, {
            sender = "LifeInvader",
            subject = "Paycheck",
            message = 'You received your paycheck of $ '..amount..' !',
            button = {}
        })
    end
end)