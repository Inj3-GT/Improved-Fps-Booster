// Script by Inj3
// Steam : https://steamcommunity.com/profiles/76561197988568430
// Discord : Inj3
// General Public License v3.0
// https://github.com/Inj3-GT

return {
    {
        Icon = "icon16/bullet_disk.png",
        DrawLine = true,
        Localization = {
            Text = "SaveOpti",
            ToolTip = "TSaveOpti",
        },
        Sound = function(t)
            return (t.Settings.Revert.Set) and "friends/message.wav" or "buttons/button18.wav"
        end,
        Function = function(t)
            local ipr_data_lang = t.Data.Lang[t.Settings.SetLang]
            if not t.Settings.Revert.Set then
                chat.AddText(t.Settings.TColor["rouge"], ipr_data_lang.Addon.. " ", t.Settings.TColor["blanc"], ipr_data_lang.CheckedBox)
                return
            end
            
            if (t.Settings.Status) then
                t.Function.Activate(true)
            end

            local ipr_startup = timer.Exists(t.Settings.StartupLaunch.Name)
            if (ipr_startup) then
                timer.Remove(t.Settings.StartupLaunch.Name)
                t.Function.SetConvar("Startup", false, 2)

                chat.AddText(t.Settings.TColor["rouge"], ipr_data_lang.Addon.. " ", t.Settings.TColor["blanc"], ipr_data_lang.StartupAbandoned)
            end

            t.Function.DeepCopy()
            t.Function.SaveSettings()

            chat.AddText(t.Settings.TColor["rouge"], ipr_data_lang.Addon.. " ", t.Settings.TColor["blanc"], ipr_data_lang.SettingsSaved)
        end
    },
    {
        Icon = "icon16/bullet_key.png",
        DrawLine = true,
        DataDelayed = true,
        Convar = {
            Name = "Startup",
            DefaultCheck = false,
        },
        Localization = {
            Text = "ApplyStartup",
            ToolTip = "TApplyStartup",
        },
        Sound = function(t)
            return timer.Exists(t.Settings.StartupLaunch.Name) and "friends/friend_join.wav" or "hl1/fvox/fuzz.wav"
        end,
        Function = function(t, b)
            local ipr_data_lang = t.Data.Lang[t.Settings.SetLang]
            local ipr_vgui_cvar = b.Convar.Name

            local ipr_startup = timer.Exists(t.Settings.StartupLaunch.Name)
            if (ipr_startup) then
                timer.Remove(t.Settings.StartupLaunch.Name)
                chat.AddText(t.Settings.TColor["rouge"], ipr_data_lang.Addon.. " ", t.Settings.TColor["blanc"], ipr_data_lang.StartupAbandoned)
            else
                if (t.Function.GetConvar(ipr_vgui_cvar)) then
                    t.Function.SetConvar(ipr_vgui_cvar, false, 2)
                    return
                end
            end

            ipr_startup = not ipr_startup

            if (ipr_startup) then
                if not t.Settings.Status then
                    t.Function.Activate(true)
                end

                t.Function.SetConvar(ipr_vgui_cvar, ipr_startup)

                timer.Create(t.Settings.StartupLaunch.Name, t.Settings.StartupLaunch.Delay, 1, function()
                    t.Function.SetConvar(ipr_vgui_cvar, true, 2)
                    chat.AddText(t.Settings.TColor["rouge"], ipr_data_lang.Addon.. " ", t.Settings.TColor["vert"], ipr_data_lang.StartupEnabled)
                end)

                local ipr_pattern = "%"
                local ipr_string_find = string.find(ipr_data_lang.StartupLaunched, ipr_pattern, nil, true)
                local ipr_startup_delay = math.Round(t.Settings.StartupLaunch.Delay / 60)

                ipr_startup_delay = (ipr_startup_delay < 1) and 1 or ipr_startup_delay
                ipr_string_find = (ipr_string_find) and string.Replace(ipr_data_lang.StartupLaunched, ipr_pattern, ipr_startup_delay) or ipr_data_lang.StartupLaunched

                chat.AddText(t.Settings.TColor["rouge"], ipr_data_lang.Addon.. " ", t.Settings.TColor["blanc"], ipr_string_find)
            else
                t.Function.SetConvar(ipr_vgui_cvar, ipr_startup, 1)
            end
        end
    },
    {
        Icon = "icon16/bullet_wrench.png",
        DrawLine = false,
        Localization = {
            Text = "SetDefaultSettings",
            ToolTip = "TSetDefaultSettings",
        },
        Sound = function()
            return "common/wpn_select.wav"
        end,
        Function = function(t)
            local ipr_data_lang = t.Data.Lang[t.Settings.SetLang]
            for i = 1, #t.Settings.Vgui.CheckBox do
                t.Settings.Vgui.CheckBox[i].Vgui:SetValue(t.Settings.Vgui.CheckBox[i].Default)
            end

            chat.AddText(t.Settings.TColor["rouge"], ipr_data_lang.Addon.. " ", t.Settings.TColor["blanc"], ipr_data_lang.DefaultConfig)
        end
    },
}