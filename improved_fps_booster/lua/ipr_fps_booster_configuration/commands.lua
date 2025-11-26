// Script by Inj3
// Steam : https://steamcommunity.com/id/Inj3/
// Discord : Inj3
// General Public License v3.0
// https://github.com/Inj3-GT

return {
    ["/boost"] = function(tbl)
        tbl.PanelOpen()
    end,
    ["/reset"] = function(tbl)
        tbl.Function.Activate(false)

        chat.AddText(tbl.Settings.TColor["rouge"], tbl.Settings.Script, tbl.Settings.TColor["blanc"], tbl.Data.Lang[tbl.Settings.SetLang].SReset)
        surface.PlaySound("buttons/combine_button5.wav")
    end,
}