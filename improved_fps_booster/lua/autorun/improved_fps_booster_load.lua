// Script by Inj3
// Steam : https://steamcommunity.com/id/Inj3/
// Discord : Inj3
// General Public License v3.0
// https://github.com/Inj3-GT

IprFpsBooster = IprFpsBooster or {}
IprFpsBooster.Developer = "Inj3"
IprFpsBooster.Version = "4.0.6"

if (CLIENT) then
    surface.CreateFont("Ipr_Fps_Booster_Font",{
        font = "Rajdhani Bold",
        size = 18,
        weight = 250,
        antialias = true,
    })
    
    include("ipr_fps_booster_lua/client/vgui.lua")
else
    local ipr_fresource = {"resource/fonts/Rajdhani-Bold.ttf", "materials/icon/ipr_boost_pc.png", "materials/icon/ipr_boost_wtool.png"}
    for i = 1, #ipr_fresource do
        local ipr_tresource = ipr_fresource[i]
        resource.AddFile(ipr_tresource)
    end

    local ipr_fconfig = file.Find("ipr_fps_booster_configuration/*", "LUA")
    for i = 1, #ipr_fconfig do
        local ipr_tconfig = ipr_fconfig[i]
        AddCSLuaFile("ipr_fps_booster_configuration/" ..ipr_tconfig)
    end
    
    local ipr_flang = file.Find("ipr_fps_booster_language/*", "LUA")
    for i = 1, #ipr_flang do
        local ipr_tlang = ipr_flang[i]
        AddCSLuaFile("ipr_fps_booster_language/" ..ipr_tlang)
    end
    
    local ipr_fclient = file.Find("ipr_fps_booster_lua/client/*", "LUA")
    for i = 1, #ipr_fclient do
        local ipr_tclient = ipr_fclient[i]
        AddCSLuaFile("ipr_fps_booster_lua/client/" ..ipr_tclient)
    end
    
    MsgC(Color(0, 250, 0), "\nImproved FPS Booster System " ..IprFpsBooster.Version.. " by " ..IprFpsBooster.Developer.. "\n")
end