// Script by Inj3
// Steam : https://steamcommunity.com/id/Inj3/
// Discord : Inj3
// General Public License v3.0
// https://github.com/Inj3-GT

return {
    Blur = Material("pp/blurscreen"),
    IMatOptions = Material("icon16/cog.png", "noclamp smooth"),
    IResetFps = Material("icon16/chart_bar.png", "noclamp"),
    IEnabled = Material("icon16/tick.png", "noclamp"),
    IDisabled = Material("icon16/cross.png", "noclamp"),
    IComputer = Material("icon/ipr_boost_pc.png", "noclamp smooth"),
    IWrench = Material("icon/ipr_boost_wtool.png", "noclamp smooth"),
    IToolTip = Material("icon16/help.png", "noclamp"),
    SetLang = Ipr_Fps_Booster.Settings.DefaultLanguage,
    Debug = false,
    Map = game.GetMap(),
    Infinity = math.huge,
    Escape = 5,
    Data = {},
    Pos = {
        w = ScrW(),
        h = ScrH(),
    },
    Status = {
        Name = "FPS Status",
        State = false,
    },
    Fps =  {
        Max = {
            Int = 0,
            Name = "Max : "
        },
        Min = {
            Int = math.huge,
            Name = "Min : "},
        Low = {
            Lists = {},
            MaxFrame = 10,
            InProgress = false,
            Name = "Low 1% : ",
        },
    },
    TColor = {
        ["blanc"] = Color(245, 245, 245),
        ["vert"] = Color(39, 174, 96),
        ["rouge"] = Color(192, 57, 43),
        ["orange"] = Color(226, 149, 25),
        ["orangec"] = Color(255, 140, 0),
        ["gvert"] = Color(28, 143, 24, 182),
        ["gvert_"] = Color(28, 143, 24, 232),
        ["bleu"] = Color(52, 73, 94),
        ["bleuc"] = Color(27, 66, 99),
        ["gris"] = Color(128, 128, 128, 145),
    },
    Country = {
        ["BE"] = true,
        ["FR"] = true,
        ["DZ"] = true,
        ["MA"] = true,
        ["CA"] = true
    },
    Vgui = {
        Primary = false,
        Secondary = false,
        ToolTip = false,
    },
    StartupLaunch = {
        Name = "IprFpsBooster_ApplyToStartup",
        Delay = 300,
    },
    Script = "[Improved Fps Booster] : ",
    Font = "Ipr_Fps_Booster_Font",
    Save = "improvedfpsbooster/",
    ExternalLink = "https://steamcommunity.com/sharedfiles/filedetails/?id=1762151370",
    BackGround = ColorAlpha(color_black, 110),
}
