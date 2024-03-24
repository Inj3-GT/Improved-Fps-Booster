----------- // SCRIPT BY INJ3 
----------- // SCRIPT BY INJ3 
----------- // SCRIPT BY INJ3 
---- // https://steamcommunity.com/id/Inj3/
------------- GNU General Public License v3.0
------------- https://github.com/Inj3-GT

hook.Add("Initialize", "Ipr_FpsBooster_Initialize", function()
    if (timer.Exists("HostnameThink")) then
        timer.Remove("HostnameThink")
    end
end)
