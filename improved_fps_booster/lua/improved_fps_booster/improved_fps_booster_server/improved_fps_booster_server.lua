----------- // SCRIPT BY INJ3 
----------- // SCRIPT BY INJ3 
----------- // SCRIPT BY INJ3 
---- // https://steamcommunity.com/id/Inj3/

--//--
------------- GNU General Public License v3.0
------------- https://github.com/Inj3-GT
--\\--
local function IprFpsBooster_Init()
    local ipr_tbl = {"HostnameThink", "CheckHookTimes"}
    for _, v in pairs(ipr_tbl) do
        if not timer.Exists(v) then
            continue
        end
        
        timer.Remove(v)
    end

    hook.Remove("Think", "CheckSchedules")
end
hook.Add("Initialize", "IprFpsBooster_Init", IprFpsBooster_Init)
