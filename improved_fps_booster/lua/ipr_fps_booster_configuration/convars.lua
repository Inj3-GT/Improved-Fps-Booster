// Script by Inj3
// Steam : https://steamcommunity.com/id/Inj3/
// Discord : Inj3
// General Public License v3.0
// https://github.com/Inj3-GT

return {
    {
        Name = "Multicore",
        DefaultCheck = true,
        Convars = {
            ["gmod_mcore_test"] = {
                Enabled = "1",
                Disabled = "0"
            },
        },
        Localization = {
            Text = "MultiCore",
            ToolTip = "TMultiCore",
        },
    },
    {
        Name = "Corde",
        DefaultCheck = false,
        Convars = {
            ["rope_smooth"] = {
                Enabled = "0",
                Disabled = "1"
            }
        },
        Localization = {
            Text = "Rope",
            ToolTip = "TRope",
        },
    },
    {
        Name = "Skybox",
        DefaultCheck = false,
        Convars = {
            ["r_3dsky"] = {
                Enabled = "0",
                Disabled = "1"
            }
        },
        Localization = {
            Text = "Skybox",
            ToolTip = "TSkybox",
        },
    },
    {
        Name = "Material processing",
        DefaultCheck = false,
        Convars = {
            ["mat_queue_mode"] = {
                Enabled = "2",
                Disabled = "-1"
            },
        },
        Localization = {
            Text = "MatProcessing",
            ToolTip = "TMatProcessing",
        },
    },
    {
        Name = "Shadow Quality",
        DefaultCheck = true,
        Convars = {
            ["mat_shadowstate"] = {
                Enabled = "0",
                Disabled = "1"
            },
            ["r_shadowmaxrendered"] = {
                Enabled = "0",
                Disabled = "32"
            },
            ["r_shadowrendertotexture"] = {
                Enabled = "0",
                Disabled = "1"
            },
            ["nb_shadow_dist"] = {
                Enabled = "0",
                Disabled = "3000"
            }
        },
        Localization = {
            Text = "ShadowQuality",
            ToolTip = "TShadowQuality",
        },
    },
    {
        Name = "Texture filtering",
        DefaultCheck = false,
        Convars = {
            ["mat_filtertextures"] = {
                Enabled = "0",
                Disabled = "1"
            }
        },
        Localization = {
            Text = "TextureFiltering",
            ToolTip = "TTextureFiltering",
        },
    },
    {
        Name = "Source Engine",
        DefaultCheck = false,
        Convars = {
            ["r_threaded_particles"] = {
                Enabled = "1",
                Disabled = "0"
            },
            ["r_threaded_renderables"] = {
                Enabled = "-1",
                Disabled = "0"
            },
            ["r_threaded_client_shadow_manager"] = {
                Enabled = "1",
                Disabled = "0"
            }
        },
        Localization = {
            Text = "SourceEngine",
            ToolTip = "TSourceEngine",
        },
    },
    {
        Name = "Hardware acceleration",
        DefaultCheck = true,
        Convars = {
            ["r_fastzreject"] = {
                Enabled = "-1",
                Disabled = "0"
            }
        },
        Localization = {
            Text = "HardwareAcceleration",
            ToolTip = "THardwareAcceleration",
        },
    },
    {
        Name = "TeethPM",
        DefaultCheck = false,
        Convars = {
            ["r_teeth"] = {
                Enabled = "0",
                Disabled = "1"
            }
        },
        Localization = {
            Text = "TeethPM",
            ToolTip = "TTeethPM",
        },
    },
    {
        Name = "Blood",
        DefaultCheck = false,
        Convars = {
            ["violence_ablood"] = {
                Enabled = "0",
                Disabled = "1"
            },
            ["violence_agibs"] = {
                Enabled = "0",
                Disabled = "1"
            },
            ["violence_hblood"] = {
                Enabled = "0",
                Disabled = "1"
            },
            ["violence_hgibs"] = {
                Enabled = "0",
                Disabled = "1"
            }
        },
        Localization = {
            Text = "Blood",
            ToolTip = "TBlood",
        },
    },
    {
        Name = "Small Object",
        DefaultCheck = false,
        Convars = {
            ["cl_phys_props_enable"] = {
                Enabled = "0",
                Disabled = "1"
            },
            ["cl_phys_props_max"] = {
                Enabled = "0",
                Disabled = "300"
            },
            ["props_break_max_pieces"] = {
                Enabled = "0",
                Disabled = "-1"
            }
        },
        Localization = {
            Text = "SmallObject",
            ToolTip = "TSmallObject",
        },
    },
    {
        Name = "Bloom",
        DefaultCheck = false,
        Convars = {
            ["mat_bloom_scalefactor_scalar"] = {
                Enabled = "0",
                Disabled = "1"
            },
            ["mat_bloomscale"] = {
                Enabled = "0",
                Disabled = "1"
            }
        },
        Localization = {
            Text = "Bloom",
            ToolTip = "TBloom",
        },
    },
    {
        Name = "WaterSplashEffect",
        DefaultCheck = false,
        Convars = {
            ["cl_show_splashes"] = {
                Enabled = "0",
                Disabled = "1"
            }
        },
        Localization = {
            Text = "WaterSplash",
            ToolTip = "TWaterSplash",
        },
    },
    {
        Name = "M9K effect",
        DefaultCheck = true,
        Convars = {
            ["M9KGasEffect"] = {
                Enabled = "0",
                Disabled = "1"
            }
        },
        Localization = {
            Text = "M9KEffect",
            ToolTip = "TM9KEffect",
        },
    },
    {
        Name = "Muzzleflash",
        DefaultCheck = false,
        Convars = {
            ["muzzleflash_light"] = {
                Enabled = "0",
                Disabled = "1"
            },
        },
        Localization = {
            Text = "Muzzleflash",
            ToolTip = "TMuzzleflash",
        },
    },
    {
        Name = "Ejectedshells",
        DefaultCheck = false,
        Convars = {
            ["cl_ejectbrass"] = {
                Enabled = "0",
                Disabled = "1"
            },
        },
        Localization = {
            Text = "Ejectedshells",
            ToolTip = "TEjectedshells",
        },
    },
}
