----------- // SCRIPT BY INJ3 
----------- // SCRIPT BY INJ3 
----------- // SCRIPT BY INJ3 
---- // https://steamcommunity.com/id/Inj3/

--//--
------------- GNU General Public License v3.0
------------- https://github.com/Inj3-GT
--\\--

util.AddNetworkString("ipr_fpsbooster_vgui")
----------- Fast DL Font
resource.AddFile( "resource/fonts/Rajdhani-Bold.ttf" )
-----------
local function Ipr_Fps_Booster_CheckString(Ipr_Sys_String, Ipr_Sys_Cmd)
   if string.sub( string.lower( Ipr_Sys_String ), 1, string.len(string.lower( Ipr_Sys_Cmd )) + 1 ) == string.lower( Ipr_Sys_Cmd ) then
       return true
   end

   return false
end

hook.Add( "PlayerInitialSpawn", "Ipr_Fps_Booster_Spawn_Vgui", function(ply)
   timer.Simple(5, function()
       if not IsValid(ply) then
           return
       end

       net.Start("ipr_fpsbooster_vgui")
       net.WriteBool(true)
       net.Send(ply)
   end)
end)

hook.Add("PlayerDisconnected","Ipr_Fps_Booster_Logout", function(ply)
    for o, g in pairs(Ipr_Fps_Booster.DefautCommand) do
        for d, t in pairs(g.Ipr_CmdChild) do
            ply:ConCommand(d.. " " ..t.Ipr_Disabled)
        end
    end
end)

hook.Add("PlayerSay", "Ipr_Fps_Booster_Chat_Vgui", function(ply, text)
   if Ipr_Fps_Booster_CheckString(text, "/boost")  then
       net.Start("ipr_fpsbooster_vgui")
       net.WriteBool(true)
       net.Send(ply)
       return ""
   end
   if Ipr_Fps_Booster_CheckString(text, "/reset") then
       net.Start("ipr_fpsbooster_vgui")
       net.WriteBool(false)
       net.Send(ply)
       return ""
   end
end)

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

MsgC( Color( 0, 250, 0 ), "\nImproved FPS Booster System v3.0 by Inj3 loaded\n" )