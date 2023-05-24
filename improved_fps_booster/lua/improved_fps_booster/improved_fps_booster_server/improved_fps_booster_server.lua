----------- // SCRIPT BY INJ3 
----------- // SCRIPT BY INJ3 
----------- // SCRIPT BY INJ3 
---- // https://steamcommunity.com/id/Inj3/

--//--
------------- GNU General Public License v3.0
------------- https://github.com/Inj3-GT
--\\--
resource.AddFile("resource/fonts/Rajdhani-Bold.ttf")
resource.AddFile("materials/icon/ipr_boost_computer.png")
resource.AddFile("materials/icon/ipr_boost_wrench.png")

hook.Add("Initialize", "IprFpsBooster_Init", function()
    local Ipr_TimRev = {"HostnameThink", "CheckHookTimes"}
    for _, v in pairs(Ipr_TimRev) do
        if timer.Exists(v) then
            timer.Remove(v)
        end
    end
    
    hook.Remove("Think", "CheckSchedules")
end)