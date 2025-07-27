// Script by Inj3
// Steam : https://steamcommunity.com/id/Inj3/
// Discord : Inj3
// General Public License v3.0
// https://github.com/Inj3-GT

return {
    {
        Vgui = "DCheckBoxLabel",
        Name = "FpsView",
        DefaultCheck = false,
        Localization = {
            Text = "FpsView",
            ToolTip = "TFpsView",
        },
        Run_HookFps = true,
    },
    {
        Vgui = "DNumSlider",
        Name = "FpsPosWidth",
        Paired = "FpsView",
        DefaultCheck = 44,
        Localization = {
            Text = "FpsPosWidth",
        },
    },
    {
        Vgui = "DNumSlider",
        Name = "FpsPosHeight",
        Paired = "FpsView",
        DefaultCheck = 28,
        Localization = {
            Text = "FpsPosHeight",
        },
    },
    {
        Vgui = "DCheckBoxLabel",
        Name = "EnabledFog",
        DefaultCheck = false,
        Localization = {
            Text = "EnabledFog",
            ToolTip = "TEnabledFog",
        },
        Run_HookFog = true,
    },
    {
        Vgui = "DNumSlider",
        Name = "FogStart",
        Paired = "EnabledFog",
        DefaultCheck = 0,
        Max = 1000000,
        Localization = {
            Text = "EnabledFogSart",
        },
    },
    {
        Vgui = "DNumSlider",
        Name = "FogEnd",
        Paired = "EnabledFog",
        DefaultCheck = 5000,
        Max = 1000000,
        Localization = {
            Text = "EnabledFogEnd",
        },
    },
    {
        Vgui = "DCheckBoxLabel",
        Name = "AutoClose",
        DefaultCheck = true,
        Localization = {
            Text = "AutoClose",
            ToolTip = "TAutoClose",
        },
    },
    {
        Vgui = "DCheckBoxLabel",
        Name = "ForcedOpen",
        DefaultCheck = true,
        Localization = {
            Text = "ForcedOpen",
            ToolTip = "TForcedOpen",
        },
    },
    {
        Vgui = "DCheckBoxLabel",
        Name = "ServerLeaveSettings",
        DefaultCheck = false,
        Localization = {
            Text = "ServerLeave",
            ToolTip = "TServerLeave",
        },
    },
    {
        Vgui = "DCheckBoxLabel",
        Name = "EnableDebug",
        DefaultCheck = false,
        Localization = {
            Text = "EnableDebug",
            ToolTip = "TEnableDebug",
        },
        Run_Debug = true,
    },
}
