// Script by Inj3
// Steam : https://steamcommunity.com/id/Inj3/
// Discord : Inj3
// General Public License v3.0
// https://github.com/Inj3-GT

Ipr_Fps_Booster = Ipr_Fps_Booster or {}
Ipr_Fps_Booster.Settings = Ipr_Fps_Booster.Settings or {}
Ipr_Fps_Booster.Settings.Version = "4.0"
Ipr_Fps_Booster.Settings.Developer = "Inj3"

local Ipr_FilesConfig = file.Find("ipr_fps_booster_configuration/*", "LUA")
local Ipr_FilesLang = file.Find("ipr_fps_booster_language/*", "LUA")

if (CLIENT) then
    Ipr_Fps_Booster.Settings.DefaultLanguage = "EN"
    
    surface.CreateFont("Ipr_Fps_Booster_Font",{
        font = "Rajdhani Bold",
        size = 18,
        weight = 250,
        antialias = true,
    })

    Ipr_Fps_Booster.Convars = Ipr_Fps_Booster.Convars or {}
    Ipr_Fps_Booster.Lang = {}

    for i = 1, #Ipr_FilesLang do
        local Ipr_Lang = Ipr_FilesLang[i]
        local Ipr_RefLang = string.upper(string.gsub(Ipr_Lang, ".lua", ""))

        Ipr_Fps_Booster.Lang[Ipr_RefLang] = include("ipr_fps_booster_language/"..Ipr_Lang)
    end

    for i = 1, #Ipr_FilesConfig do
        local Ipr_Config = Ipr_FilesConfig[i]
        local Ipr_RefConfig = "Default" ..string.lower(string.gsub(Ipr_Config, ".lua", ""))
        
        Ipr_Fps_Booster[Ipr_RefConfig] = include("ipr_fps_booster_configuration/"..Ipr_Config)
    end
    
    include("ipr_fps_booster_lua/client/vgui.lua")
else
    local Ipr_Resource = {"resource/fonts/Rajdhani-Bold.ttf", "materials/icon/ipr_boost_pc.png", "materials/icon/ipr_boost_wtool.png"}
    for i = 1, #Ipr_Resource do
        local Ipr_Resources = Ipr_Resource[i]
        resource.AddFile(Ipr_Resources)
    end

    for i = 1, #Ipr_FilesConfig do
        local Ipr_Config = Ipr_FilesConfig[i]
        AddCSLuaFile("ipr_fps_booster_configuration/" ..Ipr_Config)
    end
    
    for i = 1, #Ipr_FilesLang do
        local Ipr_Lang = Ipr_FilesLang[i]
        AddCSLuaFile("ipr_fps_booster_language/" ..Ipr_Lang)
    end
    
    local Ipr_FilesClient = file.Find("ipr_fps_booster_lua/client/*", "LUA")
    for i = 1, #Ipr_FilesClient do
        local Ipr_FClient = Ipr_FilesClient[i]
        AddCSLuaFile("ipr_fps_booster_lua/client/" ..Ipr_FClient)
    end
    
    MsgC(Color(0, 250, 0), "\nImproved FPS Booster System " ..Ipr_Fps_Booster.Settings.Version.. " by " ..Ipr_Fps_Booster.Settings.Developer.. "\n")
end
