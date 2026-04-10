// Script by Inj3
// Steam : https://steamcommunity.com/profiles/76561197988568430
// Discord : Inj3
// General Public License v3.0
// https://github.com/Inj3-GT

return {
    {
        Vgui = "DButton",
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

            local Ipr_CurrentState = t.Function.CurrentState()
            if (Ipr_CurrentState) then
                t.Function.Activate(true)
            end

            if timer.Exists(t.Settings.StartupLaunch.Name) then
                timer.Remove(t.Settings.StartupLaunch.Name)
                t.Function.SetConvar("Startup", false, 2)
                chat.AddText(t.Settings.TColor["rouge"], ipr_data_lang.Addon.. " ", t.Settings.TColor["blanc"], ipr_data_lang.StartupAbandoned)
            end

            t.Function.CopyData()
            t.Function.SaveConvar()

            chat.AddText(t.Settings.TColor["rouge"], ipr_data_lang.Addon.. " ", t.Settings.TColor["blanc"], ipr_data_lang.SettingsSaved)
        end
    },
    {
        Vgui = "DButton",
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
            local Ipr_StartupDelay = timer.Exists(t.Settings.StartupLaunch.Name)
            local ipr_data_lang = t.Data.Lang[t.Settings.SetLang]
            if (Ipr_StartupDelay) then
                timer.Remove(t.Settings.StartupLaunch.Name)
                chat.AddText(t.Settings.TColor["rouge"], ipr_data_lang.Addon.. " ", t.Settings.TColor["blanc"], ipr_data_lang.StartupAbandoned)
            end

            Ipr_StartupDelay = not Ipr_StartupDelay

            if (Ipr_StartupDelay) then
                local Ipr_CurrentState = t.Function.CurrentState()
                if not Ipr_CurrentState then
                    t.Function.Activate(true)
                end

                t.Function.SetConvar(b.Convar.Name, Ipr_StartupDelay)

                if not timer.Exists(t.Settings.StartupLaunch.Name) then
                    timer.Create(t.Settings.StartupLaunch.Name, t.Settings.StartupLaunch.Delay, 1, function()
                        t.Function.SetConvar(b.Convar.Name, true, 2)
                        chat.AddText(t.Settings.TColor["rouge"], ipr_data_lang.Addon.. " ", t.Settings.TColor["vert"], ipr_data_lang.StartupEnabled)
                    end)
                
                    chat.AddText(t.Settings.TColor["rouge"], ipr_data_lang.Addon.. " ", t.Settings.TColor["blanc"], ipr_data_lang.StartupLaunched)
                end
            else
                t.Function.SetConvar(b.Convar.Name, Ipr_StartupDelay, 1)
            end
        end
    },
    {
        Vgui = "DButton",
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
