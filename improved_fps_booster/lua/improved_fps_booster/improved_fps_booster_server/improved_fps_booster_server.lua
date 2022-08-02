----------- // SCRIPT BY INJ3 
----------- // SCRIPT BY INJ3 
----------- // SCRIPT BY INJ3 
---- // https://steamcommunity.com/id/Inj3/

--//--
------------- GNU General Public License v3.0
------------- https://github.com/Inj3-GT
--\\--

----------- Fast DL Font
resource.AddFile( "resource/fonts/Rajdhani-Bold.ttf" )
-----------
hook.Add("Initialize","Ipr_Fps_Booster_HookRemove",function()
    if timer.Exists("HostnameThink") then
        timer.Remove("HostnameThink")
    end
    if timer.Exists("CheckHookTimes") then
        timer.Remove("CheckHookTimes")
    end

    hook.Remove("Think", "CheckSchedules")
    hook.Remove("PlayerTick", "TickWidgets")
end)