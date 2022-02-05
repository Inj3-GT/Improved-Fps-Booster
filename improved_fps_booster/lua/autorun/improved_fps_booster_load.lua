----------- // SCRIPT BY INJ3 
----------- // SCRIPT BY INJ3 
----------- // SCRIPT BY INJ3 
---- // https://steamcommunity.com/id/Inj3/

--//--
------------- GNU General Public License v3.0
------------- https://github.com/Inj3-GT
--\\--

local Ipr_ClientFile = file.Find("improved_fps_booster/improved_fps_booster_client/*", "LUA")
local Ipr_ServerFile = file.Find("improved_fps_booster/improved_fps_booster_server/*", "LUA")
local Ipr_SharedFile = file.Find("improved_fps_booster/improved_fps_booster_shared/*", "LUA")

if SERVER then
    for count, file in pairs(Ipr_SharedFile) do
        include("improved_fps_booster/improved_fps_booster_shared/"..file)
        AddCSLuaFile("improved_fps_booster/improved_fps_booster_shared/"..file)
    end
    for count, file in pairs(Ipr_ServerFile) do
        include("improved_fps_booster/improved_fps_booster_server/"..file)
    end
    for count, file in pairs(Ipr_ClientFile) do
        AddCSLuaFile("improved_fps_booster/improved_fps_booster_client/"..file)
    end
end 

if CLIENT then
    ----------- Font
    surface.CreateFont("Ipr_Fps_Booster_Font",{
        font = "Rajdhani Bold",
        size = 18,
        weight = 250,
        antialias = true
    })
    -----------

    for count, file in pairs(Ipr_SharedFile) do
        include("improved_fps_booster/improved_fps_booster_shared/"..file)
    end
    for count, file in pairs(Ipr_ClientFile) do
        include("improved_fps_booster/improved_fps_booster_client/"..file)
    end
end
