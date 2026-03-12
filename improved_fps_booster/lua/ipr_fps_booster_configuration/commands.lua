// Script by Inj3
// Steam : https://steamcommunity.com/id/Inj3/
// Discord : Inj3
// General Public License v3.0
// https://github.com/Inj3-GT

return {
    {
        Cmd = "!boost",
        Func = function(t)
            t.PanelOpen()
        end
    },
    {
        Cmd = "!reset",
        Func = function(t)
            t.Function.Activate(false)
            chat.AddText(t.Settings.TColor["rouge"], t.Settings.Script, t.Settings.TColor["blanc"], t.Data.Lang[t.Settings.SetLang].SReset)
            surface.PlaySound("buttons/combine_button5.wav")
        end
    }
}
