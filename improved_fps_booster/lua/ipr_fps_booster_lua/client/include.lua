// Script by Inj3
// Steam : https://steamcommunity.com/id/Inj3/
// Discord : Inj3
// General Public License v3.0
// https://github.com/Inj3-GT

local ipr_data = {}
ipr_data.Default = {}
ipr_data.Lang = {}

local ipr_file_lang = file.Find("ipr_fps_booster_language/*", "LUA")
for i = 1, #ipr_file_lang do
    local ipr_index_lang = ipr_file_lang[i]

    local ipr_var_lang = string.upper(string.gsub(ipr_index_lang, ".lua", ""))
    ipr_data.Lang[ipr_var_lang] = include("ipr_fps_booster_language/"..ipr_index_lang)
end

local ipr_file_config = file.Find("ipr_fps_booster_configuration/*", "LUA")
for i = 1, #ipr_file_config do
    local ipr_index_config = ipr_file_config[i]

    local ipr_var_config = string.lower(string.gsub(ipr_index_config, ".lua", ""))
    ipr_data.Default[ipr_var_config] = include("ipr_fps_booster_configuration/"..ipr_index_config)
end

return ipr_data