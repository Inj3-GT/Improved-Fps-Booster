----------- // SCRIPT BY INJ3 
----------- // SCRIPT BY INJ3 
----------- // SCRIPT BY INJ3 
---- // https://steamcommunity.com/id/Inj3/

--//--
------------- GNU General Public License v3.0
------------- https://github.com/Inj3-GT
--\\--

-----------
resource.AddFile( "resource/fonts/Rajdhani-Bold.ttf" )
-----------
resource.AddFile( "materials/icon/ipr_boost_computer.png" )
resource.AddFile( "materials/icon/ipr_boost_wrench.png" )
----------
hook.Add("Initialize","ipr_fps_booster_rv_init",function()
    if timer.Exists("HostnameThink") then
        timer.Remove("HostnameThink")
    end
    if timer.Exists("CheckHookTimes") then
        timer.Remove("CheckHookTimes")
    end

    hook.Remove("Think", "CheckSchedules")
    hook.Remove("PlayerTick", "TickWidgets")
end)
