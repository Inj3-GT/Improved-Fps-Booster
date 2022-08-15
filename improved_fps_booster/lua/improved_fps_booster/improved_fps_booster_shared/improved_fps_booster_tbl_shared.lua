----------- // SCRIPT BY INJ3 
----------- // SCRIPT BY INJ3 
----------- // SCRIPT BY INJ3 
---- // https://steamcommunity.com/id/Inj3/

--//--
------------- GNU General Public License v3.0
------------- https://github.com/Inj3-GT
--\\--

Ipr_Fps_Booster = Ipr_Fps_Booster or {}
Ipr_Fps_Booster.Version = "v3.3"

if CLIENT then
    Ipr_Fps_Booster.Loaded_Lua = Ipr_Fps_Booster.Loaded_Lua or false
    Ipr_Fps_Booster.Save_Tbl = Ipr_Fps_Booster.Save_Tbl or {}
    Ipr_Fps_Booster.Save_Lg = Ipr_Fps_Booster.Save_Lg or {}
    
    Ipr_Fps_Booster.DefautCommand = {
        [1] = {
            Ipr_Texte = {
                ["FR"] = "Rendu Multicoeur",
                ["EN"] = "Multicore Rendering"
            },

            Ipr_ToolTip = {
                ["FR"] = "Tirer parti d'un processeur multicœur",
                ["EN"] = "Take advantage of a Multi Core CPU"
            },
            Ipr_CmdChild = {
                ["gmod_mcore_test"] = {
                    Ipr_Enabled = "1",
                    Ipr_Disabled = "0"
                },
                ["mat_queue_mode"] = {
                    Ipr_Enabled = "-1",
                    Ipr_Disabled = "0"
                },
                ["cl_threaded_bone_setup"] = {
                    Ipr_Enabled = "1",
                    Ipr_Disabled = "0"
                }
            },
        },
        [2] = {
            Ipr_Texte = {
                ["FR"] = "Supprimer Skybox 3D",
                ["EN"] = "Remove 3D Skybox"
            },
            Ipr_ToolTip = {
                ["FR"] = "Retire le rendu du ciel",
                ["EN"] = "Delete the sky"
            },
            Ipr_CmdChild = {
                ["r_3dsky"] = {
                    Ipr_Enabled = "0",
                    Ipr_Disabled = "1"
                }
            },
        },
        [3] = {
            Ipr_Texte = {
                ["FR"] = "Supprimer spray",
                ["EN"] = "Remove Spray"
            },
            Ipr_ToolTip = {
                ["FR"] = "Retire l'effet de pulvérisation",
                ["EN"] = "Remove the spray effect"
            },
            Ipr_CmdChild = {
                ["cl_playerspraydisable"] = {
                    Ipr_Enabled = "1",
                    Ipr_Disabled = "0"
                }
            },
        },
        [4] = {
            Ipr_Texte = {
                ["FR"] = "Supprimer les dents",
                ["EN"] = "Remove Teeth"
            },

            Ipr_ToolTip = {
                ["FR"] = "Retire les dents visibles sur les models",
                ["EN"] = "Remove teeth on the models"
            },
            Ipr_CmdChild = {
                ["r_teeth"] = {
                    Ipr_Enabled = "0",
                    Ipr_Disabled = "1"
                }
            },
        },
        [5] = {
            Ipr_Texte = {
                ["FR"] = "Supprimer ombres/flashlight",
                ["EN"] = "Remove Shadow/Flashlight"
            },
            Ipr_ToolTip = {
                ["FR"] = "Retire les ombres sur les entités, et supprime la lumière de votre lampe de poche.",
                ["EN"] = "Removes shadows on entities, and removes light from your flashlight"
            },
            Ipr_CmdChild = {
                ["r_shadows"] = {
                    Ipr_Enabled = "0",
                    Ipr_Disabled = "1"
                }
            },
        },
        [6] = {
            Ipr_Texte = {
                ["FR"] = "Filtrage des textures",
                ["EN"] = "Texture filtering"
            },
            Ipr_ToolTip = {
                ["FR"] = "Retire le filtrage des textures",
                ["EN"] = "Removes filtering on textures"
            },
            Ipr_CmdChild = {
                ["mat_filtertextures"] = {
                    Ipr_Enabled = "0",
                    Ipr_Disabled = "1"
                }
            },
        },
        [7] = {
            Ipr_Texte = {
                ["FR"] = "Supprimer M9k effect",
                ["EN"] = "Remove M9k effect"
            },
            Ipr_ToolTip = {
                ["FR"] = "Retire les effets sur les armes m9k",
                ["EN"] = "Remove particle effect on M9K"
            },
            Ipr_CmdChild = {
                ["M9KGasEffect"] = {
                    Ipr_Enabled = "0",
                    Ipr_Disabled = "1"
                }
            },
        },
        [8] = {
            Ipr_Texte = {
                ["FR"] = "Comportement moteur",
                ["EN"] = "Modify the behavior (engine)"
            },
            Ipr_ToolTip = {
                ["FR"] = "Modifie le comportement du moteur (particule, matrice osseuse, corde, pvs - threads séparés) = r_threaded_particles, r_threaded_renderables, r_queued_ropes, cl_threaded_client_leaf_system, r_threaded_client_shadow_manager",
                ["EN"] = "Modifies engine behavior (particle, bone matrix, string, pvs - separate threads) = r_threaded_particles, r_threaded_renderables, r_queued_ropes, cl_threaded_client_leaf_system, r_threaded_client_shadow_manager"
            },
            Ipr_CmdChild = {
                ["r_threaded_particles"] = {
                    Ipr_Enabled = "1",
                    Ipr_Disabled = "0"
                },
                ["r_threaded_renderables"] = {
                    Ipr_Enabled = "-1",
                    Ipr_Disabled = "0"
                },
                ["r_queued_ropes"] = {
                    Ipr_Enabled = "1",
                    Ipr_Disabled = "0"
                },
                ["cl_threaded_client_leaf_system"] = {
                    Ipr_Enabled = "1",
                    Ipr_Disabled = "0"
                },
                ["r_threaded_client_shadow_manager"] = {
                    Ipr_Enabled = "1",
                    Ipr_Disabled = "0"
                }
            }
        },
    }

    Ipr_Fps_Booster.Country = {
        ["BE"] = true,
        ["FR"] = true,
        ["DZ"] = true,
        ["MA"] = true,
        ["CA"] = true,
    }

    Ipr_Fps_Booster.Lang = {
        ["FR"] = {
            ipr_vgui_enabled = "Voulez-vous activer Improved FPS Booster ?",
            ipr_vgui_opti_t = "Optimisation :",
            ipr_vgui_posw_t = "FPS Position Largeur :",
            ipr_vgui_posh_t = "FPS Position Hauteur :",
            ipr_vgui_hudshow_t = "FPS visible sur HUD",
            ipr_vgui_hudshow_tx = "Rendre le compteur de fps complet visible directement votre sur HUD",
            ipr_vgui_enable_t = "Activer",
            ipr_vgui_disable_t = "Désactiver",
            ipr_vgui_enable_prevent_t = "Si vous rencontrez des problèmes graphiques ou crashs, utilisez le bouton options pour modifier vos paramètres. Pour ouvrir Improved FPS Booster /boost.",
            ipr_vgui_disableop_t = "Improved FPS Booster est maintenant inactif, pour ouvrir Improved FPS Booster /boost.",
            ipr_vgui_fps_cur = "Actuel :",
            ipr_vgui_fps_load_data = "Paramètre des options Chargées",
            ipr_vgui_Lang = "Langue :",
            ipr_vgui_LoadS = "Charger Preset",
        },

        ["EN"] = {
            ipr_vgui_enabled = "Do you want enable Improved FPS Booster ?",
            ipr_vgui_opti_t = "Optimization :",
            ipr_vgui_posw_t = "FPS Position Width :",
            ipr_vgui_posh_t = "FPS Position Height :",
            ipr_vgui_hudshow_t = "Display FPS on hud",
            ipr_vgui_hudshow_tx = "Show full fps counter visible directly on your HUD",
            ipr_vgui_enable_t = "Enable",
            ipr_vgui_disable_t = "Disable",
            ipr_vgui_enable_prevent_t = "If you encounter graphic problems or crashes, use the Options button to change your settings. For open Improved Fps Booster /boost.",
            ipr_vgui_disableop_t = "FPS Booster is now disabled, For open Improved FPS Booster /boost.",
            ipr_vgui_fps_cur = "Actual :",
            ipr_vgui_fps_load_data = "Options settings Loaded",
            ipr_vgui_Lang = "Language :",
            ipr_vgui_LoadS = "Load Preset",
        },
    }
else
    MsgC( Color( 0, 250, 0 ), "\nImproved FPS Booster System " ..Ipr_Fps_Booster.Version.. " by Inj3\n" )
end
