// Script by Inj3
// Steam : https://steamcommunity.com/id/Inj3/
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
        Sound = function(tbl)
            return tbl.Settings.Data.Set and "friends/message.wav" or "buttons/button18.wav"
        end,
        Function = function(tbl)
            if not tbl.Settings.Data.Set then
                chat.AddText(tbl.Settings.TColor["rouge"], tbl.Settings.Script, tbl.Settings.TColor["blanc"], Ipr_Fps_Booster.Lang[tbl.Settings.SetLang].CheckedBox)
                return
            end

            local Ipr_CurrentState = tbl.Function.CurrentState()
            if (Ipr_CurrentState) then
                tbl.Function.Activate(true)
                chat.AddText(tbl.Settings.TColor["rouge"], tbl.Settings.Script, tbl.Settings.TColor["blanc"], Ipr_Fps_Booster.Lang[tbl.Settings.SetLang].OptimizationReloaded)
            end

            local Ipr_StartupDelay = timer.Exists(tbl.Settings.StartupLaunch.Name)
            if (Ipr_StartupDelay) then
                timer.Remove(tbl.Settings.StartupLaunch.Name)
                chat.AddText(tbl.Settings.TColor["rouge"], tbl.Settings.Script, tbl.Settings.TColor["blanc"], Ipr_Fps_Booster.Lang[tbl.Settings.SetLang].StartupAbandoned)
            end

            tbl.Function.SetConvar("Startup", false, 2)
            tbl.Function.CopyData()

            file.Write(tbl.Settings.Save.. "convars.json", util.TableToJSON(Ipr_Fps_Booster.Convars))
            chat.AddText(tbl.Settings.TColor["rouge"], tbl.Settings.Script, tbl.Settings.TColor["blanc"], Ipr_Fps_Booster.Lang[tbl.Settings.SetLang].SettingsSaved)
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
        Sound = function(tbl)
            return timer.Exists(tbl.Settings.StartupLaunch.Name) and "friends/friend_join.wav" or "hl1/fvox/fuzz.wav"
        end,
        Function = function(tbl, but)
            local Ipr_StartupDelay = timer.Exists(tbl.Settings.StartupLaunch.Name)
            if (Ipr_StartupDelay) then
                timer.Remove(tbl.Settings.StartupLaunch.Name)
                chat.AddText(tbl.Settings.TColor["rouge"], tbl.Settings.Script, tbl.Settings.TColor["blanc"], Ipr_Fps_Booster.Lang[tbl.Settings.SetLang].StartupAbandoned)
            end

            Ipr_StartupDelay = not Ipr_StartupDelay

            if (Ipr_StartupDelay) then
                local Ipr_CurrentState = tbl.Function.CurrentState()
                if not Ipr_CurrentState then
                    tbl.Function.Activate(true)
                end

                tbl.Function.SetConvar(but.Convar.Name, Ipr_StartupDelay)

                timer.Create(tbl.Settings.StartupLaunch.Name, tbl.Settings.StartupLaunch.Delay, 1, function()
                    tbl.Function.SetConvar(but.Convar.Name, true, 2)
                    chat.AddText(tbl.Settings.TColor["rouge"], tbl.Settings.Script, tbl.Settings.TColor["vert"], Ipr_Fps_Booster.Lang[tbl.Settings.SetLang].StartupEnabled)
                end)

                chat.AddText(tbl.Settings.TColor["rouge"], tbl.Settings.Script, tbl.Settings.TColor["blanc"], Ipr_Fps_Booster.Lang[tbl.Settings.SetLang].StartupLaunched)
            else
                tbl.Function.SetConvar(but.Convar.Name, Ipr_StartupDelay, 1)
                chat.AddText(tbl.Settings.TColor["rouge"], tbl.Settings.Script, tbl.Settings.TColor["blanc"], Ipr_Fps_Booster.Lang[tbl.Settings.SetLang].StartupDisabled)
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
        Function = function(tbl)
            for i = 1, #tbl.Settings.Vgui.CheckBox do
                tbl.Settings.Vgui.CheckBox[i].Vgui:SetValue(tbl.Settings.Vgui.CheckBox[i].Default)
            end

            chat.AddText(tbl.Settings.TColor["rouge"], tbl.Settings.Script, tbl.Settings.TColor["blanc"], Ipr_Fps_Booster.Lang[tbl.Settings.SetLang].DefaultConfig)
        end
    },
}