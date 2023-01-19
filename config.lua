Config = {

    PayCheckTime = 15,                -- The time in minutes that it will give the Paycheck

    PayCheckBlips = true,             -- Enable to grab the blip locations

    PayCheckLocation = {    --- Support to add multiple locations to collect paycheck
        ['1'] = { coords = vector3(-1083.21, -246.95, 37.52), },
    },

    -- apGov Support --
    apGov = false,                   -- If you use ap-government

    -- Notify/Mail Support --
    Notify = false,                  -- If you prefer notify over phone set to true... else set false to disable notification

    PhoneMail = {
        Enable = true,              -- Enable or Disable Phone Mail
        Phone = "qb",               -- 'qb' - qb-phone/renewed-phone / 'gks' - GKSPhone / 'qs' - QS-Smartphone
    },

}