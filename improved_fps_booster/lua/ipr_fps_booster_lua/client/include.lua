// Script by Inj3
// Steam : https://steamcommunity.com/id/Inj3/
// Discord : Inj3
// General Public License v3.0
// https://github.com/Inj3-GT

local ipr_includeconfig = {}
ipr_includeconfig.Default = {}
ipr_includeconfig.Lang = {}

local ipr_fileslang = file.Find("ipr_fps_booster_language/*", "LUA")
for i = 1, #ipr_fileslang do
    local ipr_tlang = ipr_fileslang[i]
    local ipr_reflang = string.upper(string.gsub(ipr_tlang, ".lua", ""))

    ipr_includeconfig.Lang[ipr_reflang] = include("ipr_fps_booster_language/"..ipr_tlang)
end

local ipr_filesconfig = file.Find("ipr_fps_booster_configuration/*", "LUA")
for i = 1, #ipr_filesconfig do
    local ipr_tconfig = ipr_filesconfig[i]
    local ipr_refconfig = string.lower(string.gsub(ipr_tconfig, ".lua", ""))
    
    ipr_includeconfig.Default[ipr_refconfig] = include("ipr_fps_booster_configuration/"..ipr_tconfig)
end

return ipr_includeconfig