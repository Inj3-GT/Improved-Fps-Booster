// Script by Inj3
// Steam : https://steamcommunity.com/id/Inj3/
// Discord : Inj3
// General Public License v3.0
// https://github.com/Inj3-GT

local Ipr_IncludeConfig = {}
Ipr_IncludeConfig.Default = {}
Ipr_IncludeConfig.Lang = {}

local Ipr_FilesLang = file.Find("ipr_fps_booster_language/*", "LUA")
for i = 1, #Ipr_FilesLang do
    local Ipr_Lang = Ipr_FilesLang[i]
    local Ipr_RefLang = string.upper(string.gsub(Ipr_Lang, ".lua", ""))

    Ipr_IncludeConfig.Lang[Ipr_RefLang] = include("ipr_fps_booster_language/"..Ipr_Lang)
end

local Ipr_FilesConfig = file.Find("ipr_fps_booster_configuration/*", "LUA")
for i = 1, #Ipr_FilesConfig do
    local Ipr_Config = Ipr_FilesConfig[i]
    local Ipr_RefConfig = string.lower(string.gsub(Ipr_Config, ".lua", ""))
    
    Ipr_IncludeConfig.Default[Ipr_RefConfig] = include("ipr_fps_booster_configuration/"..Ipr_Config)
end

return Ipr_IncludeConfig
