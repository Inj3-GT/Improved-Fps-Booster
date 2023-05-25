----------- // SCRIPT BY INJ3 
----------- // SCRIPT BY INJ3 
----------- // SCRIPT BY INJ3 
---- // https://steamcommunity.com/id/Inj3/

--//--
------------- GNU General Public License v3.0
------------- https://github.com/Inj3-GT
--\\--
do
    local ipr_addfile = {"resource/fonts/Rajdhani-Bold.ttf", "materials/icon/ipr_boost_computer.png", "materials/icon/ipr_boost_wrench.png"}
    for _, v in pairs(ipr_addfile) do
        resource.AddFile(v)
    end
end

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