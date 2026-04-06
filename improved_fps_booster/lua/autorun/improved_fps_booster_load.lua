// Script by Inj3
// Steam : https://steamcommunity.com/profiles/76561197988568430
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
    local ipr_file_resource = {"resource/fonts/Rajdhani-Bold.ttf", "materials/icon/ipr_boost_pc.png", "materials/icon/ipr_boost_wtool.png"}
    for i = 1, #ipr_file_resource do
        local ipr_index_resource = ipr_file_resource[i]
        resource.AddFile(ipr_index_resource)
    end

    local ipr_file_config = file.Find("ipr_fps_booster_configuration/*", "LUA")
    for i = 1, #ipr_file_config do
        local ipr_index_config = ipr_file_config[i]
        AddCSLuaFile("ipr_fps_booster_configuration/" ..ipr_index_config)
    end
    
    local ipr_file_lang = file.Find("ipr_fps_booster_language/*", "LUA")
    for i = 1, #ipr_file_lang do
        local ipr_index_lang = ipr_file_lang[i]
        AddCSLuaFile("ipr_fps_booster_language/" ..ipr_index_lang)
    end
    
    local ipr_file_client = file.Find("ipr_fps_booster_lua/client/*", "LUA")
    for i = 1, #ipr_file_client do
        local ipr_index_client = ipr_file_client[i]
        AddCSLuaFile("ipr_fps_booster_lua/client/" ..ipr_index_client)
    end
    
    MsgC(Color(0, 250, 0), "\nImproved FPS Booster System " ..IprFpsBooster.Version.. " by " ..IprFpsBooster.Developer.. "\n")
end
