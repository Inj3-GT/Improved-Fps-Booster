// Script by Inj3
// Steam : https://steamcommunity.com/id/Inj3/
// Discord : Inj3
// General Public License v3.0
// https://github.com/Inj3-GT

Ipr_Fps_Booster = Ipr_Fps_Booster or {}

Ipr_Fps_Booster.Developer = "Inj3"
Ipr_Fps_Booster.Version = "4.0.1"

if (CLIENT) then
    Ipr_Fps_Booster.DefaultLanguage = "EN"
    
    surface.CreateFont("Ipr_Fps_Booster_Font",{
        font = "Rajdhani Bold",
        size = 18,
        weight = 250,
        antialias = true,
    })
    
    include("ipr_fps_booster_lua/client/vgui.lua")
else
    local Ipr_Resource = {"resource/fonts/Rajdhani-Bold.ttf", "materials/icon/ipr_boost_pc.png", "materials/icon/ipr_boost_wtool.png"}
    for i = 1, #Ipr_Resource do
        local Ipr_Resources = Ipr_Resource[i]
        resource.AddFile(Ipr_Resources)
    end

    local Ipr_FilesConfig = file.Find("ipr_fps_booster_configuration/*", "LUA")
    for i = 1, #Ipr_FilesConfig do
        local Ipr_Config = Ipr_FilesConfig[i]
        AddCSLuaFile("ipr_fps_booster_configuration/" ..Ipr_Config)
    end
    
    local Ipr_FilesLang = file.Find("ipr_fps_booster_language/*", "LUA")
    for i = 1, #Ipr_FilesLang do
        local Ipr_Lang = Ipr_FilesLang[i]
        AddCSLuaFile("ipr_fps_booster_language/" ..Ipr_Lang)
    end
    
    local Ipr_BlackListFile = {["include"] = true}
    local Ipr_FilesClient = file.Find("ipr_fps_booster_lua/client/*", "LUA")
    for i = 1, #Ipr_FilesClient do
        local Ipr_FClient = Ipr_FilesClient[i]
        if (Ipr_BlackListFile[Ipr_FClient]) then
            continue
        end

        AddCSLuaFile("ipr_fps_booster_lua/client/" ..Ipr_FClient)
    end
    
    MsgC(Color(0, 250, 0), "\nImproved FPS Booster System " ..Ipr_Fps_Booster.Version.. " by " ..Ipr_Fps_Booster.Developer.. "\n")

end
