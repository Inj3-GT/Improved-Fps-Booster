------------- Script by Inj3, PROHIBITED to copy the code !
------------- If you have any language to add or suggestion, contact me on my steam.
------------- GNU General Public License v3.0
------------- https://steamcommunity.com/id/Inj3/
------------- www.centralcityrp.fr/ --- Affiliated Website 
------------- https://steamcommunity.com/groups/CentralCityRoleplay --- Affiliated Group

-------------------- Included Font
surface.CreateFont( "CentralFpsBoost", {
    font = "Segoe UI Black Italic",
    size = 14,
    weight = 400,
	blursize = 0.1,
	scanlines = 0,
	antialias = true,
})
surface.CreateFont( "CentralFpsBoostV", {
    font = "Segoe UI Black",
    size = 16,
    weight = 400,
	blursize = 0.1,
	scanlines = 0,
	antialias = true,
})
-------------------- Don't touch it or it's break
local Central_NmV, Central_ImprovedLanguage, CentralGainCalcul, CentralCalculFPS, CentralCalculRSZ, CentralIndexTableImprFPS
local CentralBoostFps, CentralTimerVOccur, CentralLoadRefresh, CentralOptionOpen, CentralToutCocher, CentralMap, CentralBoostOV, CentralPanelFpsBoost = false, true, false, false, false, game.GetMap(), false, nil
local CentralFpsGains, CentralFpsMax, CentralFpsMin, CentralFpsDetect, CentralTimerFps, CentralTimerRefreshV, CentralOccurFramerate, CentralOccurCountFps = 0, 0, 1000, 0, 1, 5, 1, 0
local CentralColorFps, CentralColorFpsmin, CentralColorFpsmax, Central_ColorFPSA, Central_ColorFPSB, Central_ColorFPSC, Central_ColorFPSD, Central_ColorFPSE, Central_ColorFPSF, Central_ColorFPSG, Central_ColorFPSH = Color( 0,0,0, 255 ), Color( 0,0,0, 255 ), Color( 0,0,0, 255 ) , Color( 255,165,0, 255 ), Color( 0,160,0, 255 ), Color( 255,0,0, 255 ), Color( 0,175,0, 255 ), Color( 0, 69, 175, 250 ), Color( 255, 255, 255, 255 ), Color( 0,0, 0, 250 ), Color( 3, 43, 69, 245 )
local CentralFPSbooster_SauvegardeCVInit, CentralFPSbooster_SauvegardeChemin, CentralFPSbooster_TableFpsConvar, CentralFPSbooster_DCheckBoxLabel, CentralFPSbooster_ImprovedLang, Central_FpsBooster_TblUtil  = {} , "improvedfpsbooster/sauvegarde/sv[1].txt",  {}, {}, {}, nil
 
CentralFPSbooster_ImprovedLang = {
["FR"] = {
Central_Texte1 = "Quitter",
Central_Texte2 = "Vous n'avez cochée aucune case dans l'onglet Options Optimisation, Improved Fps Booster ne peut démarrer.",
Central_Texte3 = "FPS détection",
Central_Texte4 = "Attention, ce convar 'Shadow Removed' désactive aussi la lumière de votre lampe de poche.",
Central_Texte5 = "Actuel :",
Central_Texte6 = "Activer",
Central_Texte7 = "Désactiver",
Central_Texte9 = "Si vous rencontrez des problèmes graphiques ou crashs, utilisez le button Options pour modifier vos paramètres. Pour ouvrir Improved FPS Booster /boost.",
Central_Texte10 = "Pour ouvrir Improved FPS Booster /boost.",
Central_Texte11 = "Vous avez réinitialisé vos paramètres par défaut, pour ouvrir Improved FPS Booster /boost.",
Central_Texte12 = "Voulez-vous activer Improved FPS Booster ?",
Central_Texte13 = "Pour remplacer les paramètres par défaut, activer Improved Fps Booster",
Central_Texte14 = "OFF (Désactivé)",
Central_Texte15 = "Optimisation",
Central_Texte16 = "Activer la performance multi-coeur de votre CPU (Peut être instable)",
Central_Texte17 = "Rendu multi-coeur",
Central_Texte18 = "Supprimer SkyBox",
Central_Texte19 = "Supprimer l'arrière plan",
Central_Texte20 = "Supprimer Spray",
Central_Texte21 = "Retire l'effet spray",
Central_Texte22 = "Supprimer Dents",
Central_Texte23 = "Les dents sont retirées sur les models",
Central_Texte24 = "Retirer effet M9k",
Central_Texte25 = "Retirer les particules sur les armes M9K",
Central_Texte26 = "Ombre - Lampe",
Central_Texte27 = "Enlève les ombres sur les entités, et enlève la lumière de votre lampe de poche",
Central_Texte28 = "Autre commande désactivé",
Central_Texte29 = "Activation automatique [FPS Booster]",
Central_Texte30 = "Si Improved Fps Booster est désactivé, cette case à cocher sera utilisée pour le démarrer automatiquement après avoir quitté",
Central_Texte31 = "Afficher FPS sur votre HUD",
Central_Texte32 = "Afficher vos FPS sur votre HUD, vous pouvez ajuster la position avec les sliders ci-dessous",
Central_Texte33 = "Position (gauche-droite) :",
Central_Texte34 = "Position (haut-bas) :",
Central_Texte35 = "Fermer & charger",
Central_Texte36 = "Cocher/Décocher tout",
Central_Texte37 = "Paramètres des options Chargée",
Central_Texte38 = "Langue",
Central_Texte39 = "dans la map",
Central_Texte40 = "Filtre Texture (lissage)",
Central_Texte42 = "Retire le lissage sur les textures"
},
["EN"] = {
Central_Texte1 = "Close",
Central_Texte2 = "You have not checked any checkbox in the Options Tab Optimization, Improved Fps Booster cannot load, it disabled automatically.",
Central_Texte3 = "FPS detection",
Central_Texte4 = "Be careful this convar 'Shadow Removed' also deactivates the light of your flashlight.",
Central_Texte5 = "Current :",
Central_Texte6 = "Enable",
Central_Texte7 = "Disable",
Central_Texte9 = "If you encounter graphic problems or crashes, use the Options button to change your settings. For open Improved Fps Booster /boost.",
Central_Texte10 = "For open Improved FPS Booster /boost.",
Central_Texte11 = "You have reset your settings to the default values.",
Central_Texte12 = "Do you want activate Improved FPS Booster ?",
Central_Texte13 = "To override the default settings, enable Improved Fps Booster",
Central_Texte14 = "OFF (Disabled)",
Central_Texte15 = "Optimization",
Central_Texte16 = "Take advantage of a Multi Core CPU",
Central_Texte17 = "Multicore Rendering",
Central_Texte18 = "Skybox Removed",
Central_Texte19 = "Remove skybox",
Central_Texte20 = "Spray Removed",
Central_Texte21 = "Remove the spray",
Central_Texte22 = "Teeth Removed",
Central_Texte23 = "Remove teeth on model",
Central_Texte24 = "M9K Effect Removed" ,
Central_Texte25 = "Remove particle effect on M9K",
Central_Texte26 = "Shadow - Lamp",
Central_Texte27 = "Removes shadows on entities, and removes light from your flashlight",
Central_Texte28 = "Other Command Disable",
Central_Texte29 = "Auto-enable after Close & Reload",
Central_Texte30 =  "If Improved Fps Booster is Off Disabled, this checkbox will be used to start it automatically after had Closed & Reload",
Central_Texte31 = "Show Framerate on HUD",
Central_Texte32 = "Display your FPS on your HUD, you can adjust the position with the sliders below",
Central_Texte33 = "Left-Right position :",
Central_Texte34 = "Up-Down position :",
Central_Texte35 = "Close & Reload",
Central_Texte36 = "Check All/Uncheck All",
Central_Texte37 = "Options settings Loaded",
Central_Texte38 = "Language",
Central_Texte39 = "on map",
Central_Texte40 = "Texture filter (smoothing)",
Central_Texte42 = "Removes smoothing on textures"
},
} 
 
CentralFPSbooster_TableFpsConvar = {
[1] = {CentralValueConvar = "CentralMultiCoreC", CentralValueT = 1, CentralValueD =  "vide"},
[2] = {CentralValueConvar = "CentralSkyboxC", CentralValueT = 1, CentralValueD =  "vide"},
[3] = {CentralValueConvar = "CentralSprayC", CentralValueT = 1, CentralValueD =  "vide"},
[4] = {CentralValueConvar = "CentralTeethC", CentralValueT = 1, CentralValueD =  "vide"},
[5] = {CentralValueConvar = "CentralM9KC", CentralValueT = 1, CentralValueD =  "vide"},
[6] = {CentralValueConvar = "CentralShadowC", CentralValueT = 0, CentralValueD =  "vide"},
[7] = {CentralValueConvar = "CentralAutresC", CentralValueT = 1, CentralValueD =  "vide"},
[8] = {CentralValueConvar = "CentralOptiReloadAut", CentralValueT = 1, CentralValueD =  "vide"},
[9] = {CentralValueConvar = "CentralDrawHudC", CentralValueT = 0, CentralValueD =  "vide"},
[10] = {CentralValueConvar = "CentralHUDPosW", CentralValueT = 50, CentralValueD =  "vide"},
[11] = {CentralValueConvar = "CentralHUDPosH", CentralValueT = 50, CentralValueD =  "vide"},
[12] = {CentralValueConvar = "CentralImprovedLanguageCV", CentralValueT = "nil", CentralValueD = "nil"},
[13] = {CentralValueConvar = "CentralMatFilterTextures", CentralValueT = 0, CentralValueD = "vide"}
}

CentralFPSbooster_DCheckBoxLabel = {
[1] = {CentralTexte = "Central_Texte17", CentralVal = "CentralMultiCoreC", CentralToolTip = "Central_Texte16"},
[2] = {CentralTexte = "Central_Texte18", CentralVal = "CentralSkyboxC", CentralToolTip = "Central_Texte19"},
[3] = {CentralTexte = "Central_Texte20", CentralVal = "CentralSprayC", CentralToolTip = "Central_Texte21"},
[4] = {CentralTexte = "Central_Texte22", CentralVal = "CentralTeethC", CentralToolTip = "Central_Texte23"},
[5] = {CentralTexte = "Central_Texte24", CentralVal = "CentralM9KC", CentralToolTip = "Central_Texte25"},
[6] = {CentralTexte = "Central_Texte26", CentralVal = "CentralShadowC", CentralToolTip = "Central_Texte27"},
[7] = {CentralTexte = "Central_Texte28", CentralVal = "CentralAutresC", CentralToolTip = "r_threaded_particles, r_threaded_renderables, r_queued_ropes, cl_threaded_client_leaf_system, r_threaded_client_shadow_manager"},
[8] = {CentralTexte = "Central_Texte40", CentralVal = "CentralMatFilterTextures", CentralToolTip = "Central_Texte42"}
}

local function InitCentralFpsBooster(CentralPly)
if !IsValid(CentralPly) then return end
local CentralTraductionFpsBoost = {
["BE"]=true,
["FR"]=true,
["DZ"]=true,
["MA"]=true,
["CA"]=true,
}
if CentralTraductionFpsBoost[system.GetCountry()]  then 
CentralPly.Central_ImprovedLanguage = "FR"
else
CentralPly.Central_ImprovedLanguage = "EN"
end
end
local CentralUrlWorkshop = "https://steamcommunity.com/sharedfiles/filedetails/?id=1762151370" 
Central_NmV = "\67\101\110\116\114\97\108\67\105\116\121"

local function Central_FpsBoostRetTableV(Central_Commande) ---- Allows you to check table to see if a value exists, and return it.
local Central_CommandeV = Central_Commande
local Central_ValueRet = 0
if (Central_FpsBooster_TblUtil != nil) then
for k, v in pairs(Central_FpsBooster_TblUtil) do 
if (v[Central_CommandeV] == nil) then continue end
Central_ValueRet = v[Central_CommandeV]["Central_CV_ValeurV"]
end
end
return Central_ValueRet
end

local function Central_ChgLangueSys()
if (Central_FpsBoostRetTableV("CentralImprovedLanguageCV") != "nil") then
LocalPlayer().Central_ImprovedLanguage = Central_FpsBoostRetTableV("CentralImprovedLanguageCV")
elseif (Central_FpsBoostRetTableV("CentralImprovedLanguageCV") == "nil") and (CentralIndexTableImprFPS == nil) then
CentralIndexTableImprFPS = true
InitCentralFpsBooster(LocalPlayer()) --- By default if the client has not defined a language / the tracking system takes over
end 
end

local function Central_FpsBoosterImporteTblInit(Central_CV_ConvarNom, Central_CV_Valeur)
local Central_CV_ConvarNomV = Central_CV_ConvarNom
local Central_CV_ValeurV = Central_CV_Valeur
table.insert(CentralFPSbooster_SauvegardeCVInit, {  --- Insert in empty table previously created and declared above
[Central_CV_ConvarNomV] = {  ------ Typo of table inserted
Central_CV_ValeurV = Central_CV_ValeurV
}
})
local Central_FPSboosterUtilJsonV = util.TableToJSON( CentralFPSbooster_SauvegardeCVInit )
file.Write( CentralFPSbooster_SauvegardeChemin, Central_FPSboosterUtilJsonV ) ---Importing in data folder
Central_FpsBooster_TblUtil = util.JSONToTable(file.Read(CentralFPSbooster_SauvegardeChemin, "DATA")) --- Variable refresh
end 

local Central_CountTable = 0
local function Central_FpsBoosterChgDataClient(Central_CV_ConvarNom, Central_CV_Valeur) ---- Check if new value exists, if not, add it.
Central_FpsBooster_TblUtil = util.JSONToTable(file.Read(CentralFPSbooster_SauvegardeChemin, "DATA")) 
Central_CountTable = Central_CountTable + 1 
if (Central_FpsBooster_TblUtil[Central_CountTable] == nil) then
if (Central_CV_Valeur != "vide") then Central_CV_Valeur = Central_CV_Valeur else Central_CV_Valeur = 1 end
local Central_CV_ConvarNomV = Central_CV_ConvarNom
table.insert(Central_FpsBooster_TblUtil, {
[Central_CV_ConvarNomV] = {
Central_CV_Valeur = Central_CV_Valeur
}
})
local Central_FPSboosterUtilJsonV = util.TableToJSON( Central_FpsBooster_TblUtil )
file.Write( CentralFPSbooster_SauvegardeChemin, Central_FPSboosterUtilJsonV ) 
Central_FpsBooster_TblUtil = util.JSONToTable(file.Read(CentralFPSbooster_SauvegardeChemin, "DATA")) 
elseif Central_CountTable == 1 then
Central_FpsBooster_TblUtil = util.JSONToTable(file.Read(CentralFPSbooster_SauvegardeChemin, "DATA")) 
end
end      

local function Central_FpsBoosterSauvegardeCV(Central_Commande, Central_Nombre) --- Saving Value (Data)
local Central_Commande = Central_Commande
local Central_Nombre = Central_Nombre
if (Central_Commande == nil) then return end
for k, v in pairs(Central_FpsBooster_TblUtil) do  ---- Checking
if (v[Central_Commande] == nil) then continue end
v[Central_Commande]["Central_CV_ValeurV"] = Central_Nombre
end
local Central_FPSboosterUtilJson = util.TableToJSON( Central_FpsBooster_TblUtil )
file.Write( CentralFPSbooster_SauvegardeChemin, Central_FPSboosterUtilJson ) --- Import in Data folder
Central_FpsBooster_TblUtil = util.JSONToTable(file.Read(CentralFPSbooster_SauvegardeChemin, "DATA")) --- Refresh Table
end  
 
local function CentralCreateConvar(Central_Bool) ---- I'm going to improve the code to make it more versatile.
if Central_Bool then
for i = 1, #CentralFPSbooster_TableFpsConvar do
Central_FpsBoosterImporteTblInit(CentralFPSbooster_TableFpsConvar[i]["CentralValueConvar"], CentralFPSbooster_TableFpsConvar[i]["CentralValueT"] )
end  
else 
for i = 1, #CentralFPSbooster_TableFpsConvar do
Central_FpsBoosterChgDataClient(CentralFPSbooster_TableFpsConvar[i]["CentralValueConvar"], CentralFPSbooster_TableFpsConvar[i]["CentralValueD"] )
end  
end  
end

local function Central_CheckClientFPS(CentralPanelFpsBoost)	
if !IsValid(CentralPanelFpsBoost) then return end	
if CentralFpsDetect < CentralFpsMin then CentralFpsMin = CentralFpsDetect  end
if CentralBoostFps == false then 
if CentralFpsDetect > CentralFpsMax then CentralFpsMax = CentralFpsDetect  end
else
if CentralFpsDetect > CentralFpsGains then CentralFpsGains = CentralFpsDetect end
end
if CentralFpsDetect > 20 and CentralFpsDetect <= 60 then
CentralColorFps = Central_ColorFPSA
elseif CentralFpsDetect > 60 then 
CentralColorFps = Central_ColorFPSB
elseif CentralFpsDetect <= 20 then
CentralColorFps = Central_ColorFPSC
end
if CentralFpsMin > 40 then
CentralColorFpsmin = Central_ColorFPSD
else
CentralColorFpsmin = Central_ColorFPSC
end
if CentralFpsMax > 40 then
CentralColorFpsmax = Central_ColorFPSD
else
CentralColorFpsmax = Central_ColorFPSC
end
if CentralFpsMin == 0 then 
CentralFpsMin = 1000
end
CentralCalculFPS = CentralFpsGains - CentralFpsMax
CentralGainCalcul = "Gains : "
CentralCalculRSZ = 50
if CentralCalculFPS <= 0 then CentralCalculFPS = 0 else CentralLoadRefresh = false end
if CentralCalculFPS == 0 and CentralBoostFps and CentralLoadRefresh != true then 
CentralGainCalcul = "" 
CentralCalculRSZ = 5 
CentralCalculFPS = "Refreshing.." 
if CentralTimerVOccur then
CentralTimerVOccur = false
timer.Simple( CentralTimerRefreshV, function() CentralLoadRefresh = true CentralCalculFPS = 0 CentralTimerVOccur = true end )
end
end
end

local function Central_FrmPanel()
if !IsValid(CentralPanelFpsBoost) then return end
CentralPanelFpsBoost:Remove()
CentralBoostOV = false
end

local function Central_ResetConCommand()
local CentralPlyConC = LocalPlayer()
if !IsValid(CentralPlyConC) then return end
for i = 1, #CentralTable.CentralFPSbooster_DResetConC do
CentralPlyConC:ConCommand(CentralTable.CentralFPSbooster_DResetConC[i]["CentralFPSbooster_ConCom"])
end
end

local function CentralFpsBoostPanel()
local CentralPly = LocalPlayer()
if !IsValid(CentralPly) then return end

CentralBoostOV = true
if CentralOptionOpen == false then

CentralPanelFpsBoost = vgui.Create( "DFrame" )
local CentralDPanel = vgui.Create( "DPropertySheet", CentralPanelFpsBoost )
local CentralLangue = vgui.Create( "DComboBox", CentralPanelFpsBoost )
local CentralIcon = vgui.Create( "HTML", CentralDPanel )
local CentralQuitterFps = vgui.Create("DButton", CentralPanelFpsBoost )
local CentralResetFps = vgui.Create("DButton", CentralIcon )
local CentralFpsDetection = vgui.Create("DButton", CentralIcon )
local CentralActiver = vgui.Create( "DButton", CentralPanelFpsBoost )
local CentralDesactiver = vgui.Create( "DButton", CentralPanelFpsBoost )
local CentralOptions = vgui.Create( "DButton", CentralPanelFpsBoost )

if !CentralFpsGains then
CentralFpsGains = 1
end
if CentralBoostFps == false then 
CentralFpsMax = 1
else 
CentralFpsGains = 1
end
CentralFpsMin = 1000

if Central_FpsBoostRetTableV("CentralMultiCoreC") == 0 and Central_FpsBoostRetTableV("CentralSkyboxC") == 0 and Central_FpsBoostRetTableV("CentralSprayC") == 0 and Central_FpsBoostRetTableV("CentralTeethC") == 0 and Central_FpsBoostRetTableV("CentralM9KC") == 0 and Central_FpsBoostRetTableV("CentralShadowC") == 0 and Central_FpsBoostRetTableV("CentralAutresC") == 0 and Central_FpsBoostRetTableV("CentralMatFilterTextures") == 0 then
CentralToutCocher = true
CentralBoostFps = false
chat.AddText(Central_ColorFPSF, "[", "ERROR", "] : ", Central_ColorFPSC, CentralFPSbooster_ImprovedLang[CentralPly.Central_ImprovedLanguage]["Central_Texte2"] )
else
CentralToutCocher = false
end

CentralPanelFpsBoost:ShowCloseButton(false)
CentralPanelFpsBoost:SetDraggable(true)
CentralPanelFpsBoost:MakePopup()
CentralPanelFpsBoost:SetTitle("")
CentralPanelFpsBoost:SetPos(ScrW()/2-160, ScrH()/2-180 )
CentralPanelFpsBoost:SetSize( 0, 0 )
CentralPanelFpsBoost:AlphaTo(5, 0, 0)
CentralPanelFpsBoost:AlphaTo(255, 1, 0)
CentralPanelFpsBoost:SizeTo( 300, 270, .5, 0, 10)
function CentralPanelFpsBoost:Init()
self.startTime = SysTime()
end
CentralPanelFpsBoost.Paint = function( self, w, h )
Derma_DrawBackgroundBlur( self, self.startTime )
draw.RoundedBox( 5, 0, 0, w, h, Central_ColorFPSE ) 
draw.RoundedBox( 5, 3, 3, w-7, h-7, Central_ColorFPSF ) 
draw.RoundedBox( 5, 0, 0, w, 32, Central_ColorFPSE)
draw.SimpleText(( CentralFPSbooster_ImprovedLang[CentralPly.Central_ImprovedLanguage]["Central_Texte12"] ),"CentralFpsBoost",w/2,3,Central_ColorFPSF, TEXT_ALIGN_CENTER)
if CentralBoostFps then 
draw.SimpleText(("FPS :" ),"CentralFpsBoost",125,16,Central_ColorFPSF, TEXT_ALIGN_RIGHT)
draw.SimpleText(("ON (BOOST)" ),"CentralFpsBoost",195,16,Central_ColorFPSB, TEXT_ALIGN_RIGHT)
else
draw.SimpleText(("FPS :" ),"CentralFpsBoost",118,16,Central_ColorFPSF, TEXT_ALIGN_RIGHT)
draw.SimpleText((CentralFPSbooster_ImprovedLang[CentralPly.Central_ImprovedLanguage]["Central_Texte14"] ),"CentralFpsBoost",w/2 + 15,16,Central_ColorFPSC, TEXT_ALIGN_CENTER)
end
end

CentralDPanel:Dock( FILL )
CentralDPanel:DockMargin( 1, 10, 0, 50 )
CentralDPanel.Paint = function (self, w, h)
end
CentralIcon:SetPos(5,-10)
CentralIcon:SetSize(300,300)
CentralIcon:SetHTML([[
<img src="https://centralcityrp.mtxserv.fr/centralboost1.gif" alt="Img" style="width:300px;height:200px;">
]]) --- HTML is good to avoid adding material for your players to download.

CentralLangue:SetPos( 7, 36 )
CentralLangue:SetSize( 105, 18 )
CentralLangue:SetFont( "CentralFpsBoost" )
CentralLangue.Central_Valeur = "CentralImprovedLanguageCV"
if Central_FpsBoostRetTableV("CentralImprovedLanguageCV") == 0 then
CentralLangue:SetValue( CentralFPSbooster_ImprovedLang[CentralPly.Central_ImprovedLanguage]["Central_Texte38"] )
else
CentralLangue:SetValue( CentralFPSbooster_ImprovedLang[CentralPly.Central_ImprovedLanguage]["Central_Texte38"].. " : " ..CentralPly.Central_ImprovedLanguage )
end
for lang, _ in pairs(CentralFPSbooster_ImprovedLang) do 
CentralLangue:AddChoice( lang )
end
CentralLangue.OnSelect = function( self, index, value )
local Central_ValueLang = value
CentralLangue:SetValue( "Please wait.." )
CentralLangue:SetEnabled( false )
CentralOptions:SetEnabled( false )
timer.Simple(0.2,function()
if !IsValid(self) then return end
Central_FpsBoosterSauvegardeCV(self.Central_Valeur, Central_ValueLang) 
CentralLangue:SetValue( "Receive data.." )
end)
timer.Simple(1,function()
if !IsValid(self) then return end
CentralPly.Central_ImprovedLanguage = Central_ValueLang
CentralLangue:SetValue( CentralFPSbooster_ImprovedLang[CentralPly.Central_ImprovedLanguage]["Central_Texte38"].. " : " ..CentralPly.Central_ImprovedLanguage )
CentralLangue:SetEnabled( true )
CentralOptions:SetEnabled( true )
end)
end
	 
CentralQuitterFps:SetPos(213, 35)
CentralQuitterFps:SetSize( 80, 20 )
CentralQuitterFps:SetText( "" )
CentralQuitterFps:SetTextColor( Central_ColorFPSF )
CentralQuitterFps:SetFont( "CentralFpsBoost" )
CentralQuitterFps:SetImage( "icon16/cross.png" )
function CentralQuitterFps:Paint( w, h )
draw.RoundedBox( 6, 0, 0, w, h, Central_ColorFPSC )
draw.RoundedBox( 6, 2, 2, w-2, h-1, Central_ColorFPSE )
draw.DrawText( CentralFPSbooster_ImprovedLang[CentralPly.Central_ImprovedLanguage]["Central_Texte1"], "CentralFpsBoost", w/2,3, Central_ColorFPSF, TEXT_ALIGN_CENTER )
end
CentralQuitterFps.DoClick = function()
chat.AddText(Central_ColorFPSC, "[", Central_NmV.. " Boost Framerate", "] : ", Central_ColorFPSF, CentralFPSbooster_ImprovedLang[CentralPly.Central_ImprovedLanguage]["Central_Texte10"] )
Central_FrmPanel()
end 

CentralResetFps:SetPos( 69, 165 )
CentralResetFps:SetSize( 145, 21 )
CentralResetFps:SetText( "  Reset FPS Max/Min" )
CentralResetFps:SetTextColor( Central_ColorFPSF )
CentralResetFps:SetImage( "icon16/arrow_refresh.png" )
CentralResetFps:SetFont( "CentralFpsBoost" )
function CentralResetFps:Paint( w, h )
draw.RoundedBox( 6, 0, 0, w, h, Central_ColorFPSC )
draw.RoundedBox( 6, 2, 2, w-2, h-1, Central_ColorFPSE )
end
CentralResetFps.DoClick = function()
if CentralFpsMin == 1000 then return end
CentralFpsMin = 1000
if CentralBoostFps == false then 
CentralFpsMax = 1
else
CentralFpsGains = 1
end
surface.PlaySound( "buttons/button9.wav" )
end 

CentralFpsDetection:SetPos( 100, 54 )
CentralFpsDetection:SetSize( 85, 75 )
CentralFpsDetection:SetText( "" )
CentralFpsDetection:SetTextColor( Central_ColorFPSF )
CentralFpsDetection:SetFont( "CentralFpsBoost" )
function CentralFpsDetection:Paint( w, h )
Central_CheckClientFPS(CentralPanelFpsBoost)
draw.SimpleText(( CentralFPSbooster_ImprovedLang[CentralPly.Central_ImprovedLanguage]["Central_Texte3"] ),"CentralFpsBoost",w/2+35,1,Central_ColorFPSG, TEXT_ALIGN_RIGHT)
draw.SimpleText(( CentralFPSbooster_ImprovedLang[CentralPly.Central_ImprovedLanguage]["Central_Texte5"] ), "CentralFpsBoost",w/2 +7,15,Central_ColorFPSG, TEXT_ALIGN_RIGHT)
draw.SimpleText(( CentralFpsDetect ), "CentralFpsBoostV", w/2 + 12,14,CentralColorFps, TEXT_ALIGN_LEFT)
draw.SimpleText(("Min : " ), "CentralFpsBoost",32,43,Central_ColorFPSG, TEXT_ALIGN_CENTER)
draw.SimpleText(( CentralFpsMin ), "CentralFpsBoostV",48,42,CentralColorFpsmin, TEXT_ALIGN_LEFT)
draw.SimpleText(("Max : "), "CentralFpsBoost",30,29,Central_ColorFPSG, TEXT_ALIGN_CENTER)
draw.SimpleText(( CentralGainCalcul ), "CentralFpsBoost",31,57,Central_ColorFPSG, TEXT_ALIGN_CENTER)
if CentralBoostFps then 
draw.SimpleText(( CentralFpsGains ), "CentralFpsBoostV",48,28,CentralColorFpsmax, TEXT_ALIGN_LEFT)
draw.SimpleText(( CentralCalculFPS ), "CentralFpsBoostV",CentralCalculRSZ,56, Central_ColorFPSD, TEXT_ALIGN_LEFT)
else
draw.SimpleText(( CentralFpsMax ), "CentralFpsBoostV",48,28,CentralColorFpsmax, TEXT_ALIGN_LEFT)
draw.SimpleText(( "OFF" ), "CentralFpsBoost",50,57,Central_ColorFPSC, TEXT_ALIGN_LEFT)
end
end
CentralFpsDetection.DoClick = function()
gui.OpenURL( CentralUrlWorkshop )
end 

CentralActiver:SetText( "" )
CentralActiver:SetImage( "icon16/tick.png" )	
CentralActiver:SetTextColor( Central_ColorFPSF )
CentralActiver:SetFont( "CentralFpsBoost" )
CentralActiver:SetPos( 8, 233 )
CentralActiver:SetSize( 110, 30 )
CentralActiver.Paint = function( self, w, h )	
local CentralColorFlash = math.abs(math.sin(CurTime() * 3) * 255)
local CentralVert = Color(0, CentralColorFlash, 0)
if CentralBoostFps then
CentralVert = Central_ColorFPSD
end		
draw.RoundedBox( 6, 0, 0, w, h, CentralVert )
draw.RoundedBox( 6, 2, 2, w-1, h-1, Central_ColorFPSE )
draw.DrawText( CentralFPSbooster_ImprovedLang[CentralPly.Central_ImprovedLanguage]["Central_Texte6"], "CentralFpsBoost", w/2,8, Central_ColorFPSF, TEXT_ALIGN_CENTER )
end
CentralActiver.DoClick = function() 
if CentralToutCocher then
chat.AddText(Central_ColorFPSF, "[", "ERROR", "] : ", Central_ColorFPSC, CentralFPSbooster_ImprovedLang[CentralPly.Central_ImprovedLanguage]["Central_Texte2"] )
CentralBoostFps = false
return
end
chat.AddText(Central_ColorFPSC, "[", Central_NmV.. " Boost Framerate", "] : ", Central_ColorFPSF, CentralFPSbooster_ImprovedLang[CentralPly.Central_ImprovedLanguage]["Central_Texte9"] )
if CentralBoostFps == false then 
CentralFpsMin = 1000
else 
Central_FrmPanel()
return 
end
CentralBoostFps = true
if Central_FpsBoostRetTableV("CentralAutresC") == 1 then
CentralPly:ConCommand("r_threaded_particles 1")
CentralPly:ConCommand("r_threaded_renderables 1")
CentralPly:ConCommand("r_queued_ropes 1")
CentralPly:ConCommand("cl_threaded_client_leaf_system 1")
CentralPly:ConCommand("r_threaded_client_shadow_manager 1")				
end
if Central_FpsBoostRetTableV("CentralMultiCoreC") == 1 then
CentralPly:ConCommand("gmod_mcore_test 1")
CentralPly:ConCommand("mat_queue_mode -1")
CentralPly:ConCommand("cl_threaded_bone_setup 1")
end
if  Central_FpsBoostRetTableV("CentralSkyboxC") == 1 then
CentralPly:ConCommand("r_3dsky 0")
end
if Central_FpsBoostRetTableV("CentralSprayC") == 1 then
CentralPly:ConCommand("cl_playerspraydisable 1")
end
if Central_FpsBoostRetTableV("CentralTeethC") == 1 then
CentralPly:ConCommand("r_teeth 0")
end
if Central_FpsBoostRetTableV("CentralShadowC") == 1 then
CentralPly:ConCommand("r_shadows 0")
end
if Central_FpsBoostRetTableV("CentralM9KC") == 1 then
CentralPly:ConCommand("M9KGasEffect 0")
end
if Central_FpsBoostRetTableV("CentralMatFilterTextures") == 1 then
CentralPly:ConCommand("mat_filtertextures 0")
end
Central_FrmPanel()
end
		
CentralDesactiver:SetImage( "icon16/cross.png" )		
CentralDesactiver:SetText( "" )
CentralDesactiver:SetTextColor( Central_ColorFPSF )
CentralDesactiver:SetFont( "CentralFpsBoost" )
CentralDesactiver:SetPos( 181, 233 )
CentralDesactiver:SetSize( 110, 30 )
CentralDesactiver.Paint = function( self, w, h )
local CentralColorFlash = math.abs(math.sin(CurTime() * 3) * 255)
local CentralRouge = Color(CentralColorFlash, 0, 0)
if CentralBoostFps == false then
CentralRouge = Central_ColorFPSC
end
draw.RoundedBox( 6, 0, 0, w, h, CentralRouge )
draw.RoundedBox( 6, 2, 2, w-2, h-1, Central_ColorFPSE )
draw.DrawText( CentralFPSbooster_ImprovedLang[CentralPly.Central_ImprovedLanguage]["Central_Texte7"], "CentralFpsBoost", w/2,8, Central_ColorFPSF, TEXT_ALIGN_CENTER )
end
CentralDesactiver.DoClick = function()
chat.AddText(Central_ColorFPSC, "[", Central_NmV.. " Boost Framerate", "] : ", Central_ColorFPSF, CentralFPSbooster_ImprovedLang[CentralPly.Central_ImprovedLanguage]["Central_Texte11"] )
if CentralBoostFps then
CentralFpsMin = 1000
CentralFpsMax = 1
CentralFpsGains = 1
end
CentralBoostFps = false
Central_ResetConCommand()
Central_FrmPanel()
end

CentralOptions:SetImage( "icon16/bullet_wrench.png" )		
CentralOptions:SetText( "  Options" )
CentralOptions:SetTextColor( Central_ColorFPSF )
CentralOptions:SetFont( "CentralFpsBoost" )
CentralOptions:SetPos(110, 58)
CentralOptions:SetSize( 86, 19 )
CentralOptions.Paint = function( self, w, h )
draw.RoundedBox( 6, 0, 0, w, h, Central_ColorFPSB )
draw.RoundedBox( 6, 2, 2, w-2, h-1, Central_ColorFPSE )
end
CentralOptions.DoClick = function()
surface.PlaySound( "buttons/combine_button7.wav" )
CentralOptionOpen = true
Central_FrmPanel()
CentralFpsBoostPanel()
end

else

local CentralOptionsBoost = vgui.Create( "DFrame" )
local Central_OptionsBoost_Dscroll = vgui.Create( "DScrollPanel", CentralOptionsBoost )
local CentralPosW = vgui.Create( "DNumSlider", CentralOptionsBoost )
local CentralPosH = vgui.Create( "DNumSlider", CentralOptionsBoost )
local CentralHudDraw = vgui.Create( "DCheckBoxLabel", CentralOptionsBoost)
local CentralFermerEtQuitter = vgui.Create("DCheckBoxLabel", CentralOptionsBoost)
local CentralToutCocherOptions = vgui.Create("DButton", CentralOptionsBoost)
local CentralQuitterOptions = vgui.Create("DButton", CentralOptionsBoost)

CentralOptionsBoost:SetTitle("")
CentralOptionsBoost:ShowCloseButton(false)
CentralOptionsBoost:SetIcon( "icon16/cog.png" )
CentralOptionsBoost:SetDraggable(true)
CentralOptionsBoost:MakePopup()
CentralOptionsBoost:SetTitle("")
CentralOptionsBoost:SetPos(ScrW()/2-150, ScrH()/2-200)
CentralOptionsBoost:SetSize( 0, 0 )
CentralOptionsBoost:SizeTo( 280, 395, .5, 0, 10)
CentralOptionsBoost.Paint = function( self, w, h )
draw.RoundedBox( 6, 0, 0, w, h, Central_ColorFPSE ) 
draw.RoundedBox( 6, 3, 3, w-7, h-7, Central_ColorFPSF ) 
draw.RoundedBox( 6, 0, 0, w-132, 25, Central_ColorFPSE)
draw.SimpleText(( "[Options]" ),"CentralFpsBoost",78,5,Central_ColorFPSF, TEXT_ALIGN_RIGHT)
draw.SimpleText(( "\73\109\112\114\111\118\101\100\32\70\112\115\32\66\111\111\115\116\101\114\32\118\101\114\115\105\111\110\32\50\46\48\32\47\32\73\110\106\51" ),"CentralFpsBoost",w/2,376,Central_ColorFPSE, TEXT_ALIGN_CENTER)
draw.SimpleText(( "Ping detection : " ..CentralPly:Ping()),"CentralFpsBoost",w/2,360,Central_ColorFPSE, TEXT_ALIGN_CENTER) -- if the ping value is equal to a 1 it's a spoofing.
draw.SimpleText(( CentralFPSbooster_ImprovedLang[CentralPly.Central_ImprovedLanguage]["Central_Texte15"].. " :" ),"CentralFpsBoost",w/2 ,62,Central_ColorFPSE, TEXT_ALIGN_CENTER)
draw.SimpleText(( "Configuration :" ),"CentralFpsBoost",w/2,215,Central_ColorFPSE, TEXT_ALIGN_CENTER)
draw.SimpleText(( CentralFPSbooster_ImprovedLang[CentralPly.Central_ImprovedLanguage]["Central_Texte33"] ),"CentralFpsBoost",w/2,280,Central_ColorFPSG, TEXT_ALIGN_CENTER)
draw.SimpleText(( CentralFPSbooster_ImprovedLang[CentralPly.Central_ImprovedLanguage]["Central_Texte34"] ),"CentralFpsBoost",w/2,320,Central_ColorFPSG, TEXT_ALIGN_CENTER)
draw.RoundedBox(1, 10, 57, 260, 2, Central_ColorFPSC)
draw.RoundedBox(1, 10, 209, 260, 2, Central_ColorFPSC)
end

Central_OptionsBoost_Dscroll:Dock( FILL )
Central_OptionsBoost_Dscroll:DockMargin( -5,50, 0, 195 )
local Central_OptionsBoost_DscrollSbar = Central_OptionsBoost_Dscroll:GetVBar()
function Central_OptionsBoost_DscrollSbar:Paint(w, h)
end
function Central_OptionsBoost_DscrollSbar.btnUp:Paint(w, h)
draw.RoundedBox(2, 0, 0, w, h, Color(0, 69, 175, 250))
end
function Central_OptionsBoost_DscrollSbar.btnDown:Paint(w, h)
draw.RoundedBox(2, 0, 0, w, h, Color(0, 69, 175, 250))
end
function Central_OptionsBoost_DscrollSbar.btnGrip:Paint(w, h)
draw.RoundedBox(2, 0, 0, w, h, Color(255, 0, 0, 250))
end

local Central_Fake_DCheckbox = vgui.Create( "DCheckBoxLabel", Central_OptionsBoost_Dscroll)
Central_Fake_DCheckbox:SetVisible( false )
Central_Fake_DCheckbox.OnChange = function( self, val )
local CentralSaveConV_Val = nil
if self.Central_Valeur == "CentralShadowC" then
local CentralValTimer = CentralOccurFramerate - CurTime()
if CentralValTimer < 0 and val then
chat.AddText(Central_ColorFPSC, "[", "Shadow Removed", "] : ", Central_ColorFPSF, CentralFPSbooster_ImprovedLang[CentralPly.Central_ImprovedLanguage]["Central_Texte4"] )
CentralOccurFramerate = CurTime() + CentralTimerFps
end
end
if val then CentralSaveConV_Val = 1 else CentralSaveConV_Val = 0 end
if (CentralSaveConV_Val == nil) then return end
Central_FpsBoosterSauvegardeCV(self.Central_Valeur, CentralSaveConV_Val) 
end

local Central_Chg_CheckBox_Table_Insert = {}
local Central_Create_Checkbox
for i = 1, #CentralFPSbooster_DCheckBoxLabel do
local Central_DTexte_T = CentralFPSbooster_DCheckBoxLabel[i]["CentralTexte"]
local Central_DTexte_Val = CentralFPSbooster_DCheckBoxLabel[i]["CentralVal"]
local Central_DTexte_ToolTip = CentralFPSbooster_DCheckBoxLabel[i]["CentralToolTip"]
Central_Create_Checkbox = vgui.Create( "DCheckBoxLabel", Central_OptionsBoost_Dscroll)
Central_Create_Checkbox:SetPos( 20, i * (1+ 24) - 20 )	
Central_Create_Checkbox:SetFont( "CentralFpsBoost" )
Central_Create_Checkbox:SetText( CentralFPSbooster_ImprovedLang[CentralPly.Central_ImprovedLanguage][Central_DTexte_T] )	
Central_Create_Checkbox:SetValue(Central_FpsBoostRetTableV(Central_DTexte_Val))
Central_Create_Checkbox:SetTooltip( CentralFPSbooster_ImprovedLang[CentralPly.Central_ImprovedLanguage][Central_DTexte_ToolTip] )
Central_Create_Checkbox:SetTextColor( Central_ColorFPSG )
Central_Create_Checkbox.Central_Valeur = Central_DTexte_Val
Central_Create_Checkbox.OnChange = Central_Fake_DCheckbox.OnChange
Central_Create_Checkbox:SizeToContents()
table.insert(Central_Chg_CheckBox_Table_Insert, {  
Central_Create_Checkbox = Central_Create_Checkbox --- I need it for SetValue.
})
end

CentralFermerEtQuitter:SetPos( 20,233 )	
CentralFermerEtQuitter:SetFont( "CentralFpsBoost" )
CentralFermerEtQuitter:SetText( CentralFPSbooster_ImprovedLang[CentralPly.Central_ImprovedLanguage]["Central_Texte29"] )		
CentralFermerEtQuitter:SetTooltip( CentralFPSbooster_ImprovedLang[CentralPly.Central_ImprovedLanguage]["Central_Texte30"]  )
CentralFermerEtQuitter:SetValue(Central_FpsBoostRetTableV("CentralOptiReloadAut"))
CentralFermerEtQuitter:SetTextColor( Central_ColorFPSG )
CentralFermerEtQuitter.Central_Valeur = "CentralOptiReloadAut"
CentralFermerEtQuitter.OnChange = Central_Fake_DCheckbox.OnChange
CentralFermerEtQuitter:SizeToContents()	

CentralHudDraw:SetPos( 20,258 )	
CentralHudDraw:SetFont( "CentralFpsBoost" )
CentralHudDraw:SetText( CentralFPSbooster_ImprovedLang[CentralPly.Central_ImprovedLanguage]["Central_Texte31"] )		
CentralHudDraw:SetTooltip( CentralFPSbooster_ImprovedLang[CentralPly.Central_ImprovedLanguage]["Central_Texte32"] )
CentralHudDraw:SetValue(Central_FpsBoostRetTableV("CentralDrawHudC"))
CentralHudDraw:SetTextColor( Central_ColorFPSG )
CentralHudDraw.Central_Valeur = "CentralDrawHudC"
CentralHudDraw.OnChange = Central_Fake_DCheckbox.OnChange
CentralHudDraw:SizeToContents()	

CentralPosW:SetPos( -194, 295 )
CentralPosW:SetSize( 485, 20 )	
CentralPosW:SetText( "" )	
CentralPosW:SetMinMax( 0, 100 )
CentralPosW:SetValue(Central_FpsBoostRetTableV("CentralHUDPosW"))
CentralPosW:SetDecimals( 0 )
CentralPosW.Central_Valeur = "CentralHUDPosW"
CentralPosW.OnValueChanged = function(self, val)
local CentralSaveConV_Val = val
if (CentralSaveConV_Val == nil) then return end
Central_FpsBoosterSauvegardeCV(self.Central_Valeur, CentralSaveConV_Val) 
end

CentralPosH:SetPos( -195, 335 )
CentralPosH:SetSize( 485, 20 )	
CentralPosH:SetText( "" )	
CentralPosH:SetMinMax( 0, 100 )
CentralPosH:SetValue(Central_FpsBoostRetTableV("CentralHUDPosH"))
CentralPosH:SetDecimals( 0 )
CentralPosH.Central_Valeur = "CentralHUDPosH"
CentralPosH.OnValueChanged = CentralPosW.OnValueChanged

CentralQuitterOptions:SetPos( 151, 5 )
CentralQuitterOptions:SetSize( 122, 18 )
CentralQuitterOptions:SetFont( "CentralFpsBoost" )
CentralQuitterOptions:SetText( "" ) 
CentralQuitterOptions:SetImage( "icon16/cross.png" )
CentralQuitterOptions:SetTextColor( Central_ColorFPSF  )
function CentralQuitterOptions:Paint( w, h )
draw.RoundedBox( 6, 0, 0, w, h, Central_ColorFPSC )
draw.RoundedBox( 6, 2, 2, w-2, h-1, Central_ColorFPSE )
draw.DrawText( CentralFPSbooster_ImprovedLang[CentralPly.Central_ImprovedLanguage]["Central_Texte35"], "CentralFpsBoost", w/2 +7,2, Central_ColorFPSF, TEXT_ALIGN_CENTER )
end
CentralQuitterOptions.DoClick = function()
if Central_FpsBoostRetTableV("CentralOptiReloadAut") == 1 then
CentralBoostFps = true
end
if CentralBoostFps  then
if Central_FpsBoostRetTableV("CentralMultiCoreC") == 1 then
CentralPly:ConCommand("gmod_mcore_test 1")
CentralPly:ConCommand("mat_queue_mode -1")
CentralPly:ConCommand("cl_threaded_bone_setup 1")
else
CentralPly:ConCommand("gmod_mcore_test 0")
CentralPly:ConCommand("mat_queue_mode 0")
CentralPly:ConCommand("cl_threaded_bone_setup 0")
end
if Central_FpsBoostRetTableV("CentralSkyboxC") == 1 then
CentralPly:ConCommand("r_3dsky 0")
else
CentralPly:ConCommand("r_3dsky 1")
end
if Central_FpsBoostRetTableV("CentralSprayC") == 1 then
CentralPly:ConCommand("cl_playerspraydisable 1")
else
CentralPly:ConCommand("cl_playerspraydisable 0")
end
if Central_FpsBoostRetTableV("CentralTeethC") == 1 then
CentralPly:ConCommand("r_teeth 0")
else
CentralPly:ConCommand("r_teeth 1")
end
if Central_FpsBoostRetTableV("CentralShadowC") == 1 then
CentralPly:ConCommand("r_shadows 0")
else
CentralPly:ConCommand("r_shadows 1")
end
if Central_FpsBoostRetTableV("CentralM9KC") == 1 then
CentralPly:ConCommand("M9KGasEffect 0")
else
CentralPly:ConCommand("M9KGasEffect 1")
end
if Central_FpsBoostRetTableV("CentralAutresC") == 1 then
CentralPly:ConCommand("r_threaded_particles 1")
CentralPly:ConCommand("r_threaded_renderables 1")
CentralPly:ConCommand("r_queued_ropes 1")
CentralPly:ConCommand("cl_threaded_client_leaf_system 1")
CentralPly:ConCommand("r_threaded_client_shadow_manager 1")					
else
CentralPly:ConCommand("r_threaded_particles 0")
CentralPly:ConCommand("r_threaded_renderables 0")
CentralPly:ConCommand("r_queued_ropes 0")
CentralPly:ConCommand("cl_threaded_client_leaf_system 0")
CentralPly:ConCommand("r_threaded_client_shadow_manager 0")					
end
if Central_FpsBoostRetTableV("CentralMatFilterTextures") == 1 then
CentralPly:ConCommand("mat_filtertextures 0")
else
CentralPly:ConCommand("mat_filtertextures 1")
end
timer.Simple(0.1, function()
if CentralToutCocher == false then
chat.AddText(Central_ColorFPSC, "[", Central_NmV.. " Boost Framerate", "] : ", Central_ColorFPSF, CentralFPSbooster_ImprovedLang[CentralPly.Central_ImprovedLanguage]["Central_Texte37"] )
else
chat.AddText(Central_ColorFPSC, "[", Central_NmV.. " Boost Framerate", "] : ", Central_ColorFPSF, CentralFPSbooster_ImprovedLang[CentralPly.Central_ImprovedLanguage]["Central_Texte13"] )
end
end)
end
CentralOptionOpen = false
CentralFpsGains = 1
CentralOptionsBoost:Remove()
CentralFpsBoostPanel()
end

CentralToutCocherOptions:SetImage( "icon16/bullet_wrench.png" )		
CentralToutCocherOptions:SetText( "" )
CentralToutCocherOptions:SetTextColor( Central_ColorFPSF )
CentralToutCocherOptions:SetFont( "CentralFpsBoost" )
CentralToutCocherOptions:SetPos(64, 31)
CentralToutCocherOptions:SetSize( 155, 19 )
CentralToutCocherOptions.Paint = function( self, w, h )
if CentralToutCocherOptions:IsHovered() then
draw.RoundedBox( 6, 0, 0, w, h, Central_ColorFPSD )
else
draw.RoundedBox( 6, 0, 0, w, h, Central_ColorFPSC )
end
draw.RoundedBox( 6, 2, 2, w-2, h-1, Central_ColorFPSE )
draw.DrawText( CentralFPSbooster_ImprovedLang[CentralPly.Central_ImprovedLanguage]["Central_Texte36"], "CentralFpsBoost", w/2 +5,2, Central_ColorFPSF, TEXT_ALIGN_CENTER )
end
CentralToutCocherOptions.DoClick = function()
if CentralToutCocher then
for k, v in pairs(Central_Chg_CheckBox_Table_Insert) do 
v["Central_Create_Checkbox"]:SetValue(1)
end
CentralToutCocher = false
else
for k, v in pairs(Central_Chg_CheckBox_Table_Insert) do 
v["Central_Create_Checkbox"]:SetValue(0)
end
CentralToutCocher = true
end 
surface.PlaySound( "buttons/button9.wav" )
end
end
if (Central_NmV == nil or Central_NmV != "\67\101\110\116\114\97\108\67\105\116\121") then 
for i = 1, 100 do
CentralPly:PrintMessage( HUD_PRINTTALK, "Please reinstall Improved Fps Booster from Github, or the Workshop !" )
end 
timer.Simple(0.1, function()
Central_FrmPanel()
end)
end
end

local Central_ChargementPanel_Bool = false
local function Central_FpsBoosterCheckDataClient()
if !Central_ChargementPanel_Bool then
Central_ChargementPanel_Bool = true
if !file.Exists( CentralFPSbooster_SauvegardeChemin, "DATA" ) then
file.CreateDir("improvedfpsbooster/sauvegarde")
CentralCreateConvar(true) 
else -------- Client data loaded once upstream
CentralCreateConvar(false)
end 
timer.Simple(0.1,function()
Central_ChgLangueSys() -- Load Language
end)
timer.Simple(0.5, function()
CentralFpsBoostPanel()
end)
else
CentralFpsBoostPanel()
end
end 
net.Receive("centralboost", Central_FpsBoosterCheckDataClient)
	
local function CentralBoosterDrawHud()
if (CentralBoostOV or Central_FpsBoostRetTableV("CentralDrawHudC") == 1) then --- We only execute the code when we need to.
local Central_ValTimerClientDelai = CentralOccurCountFps - CurTime() --- Client delay
if Central_ValTimerClientDelai < 0 then
CentralFpsDetect = math.Round(1/RealFrameTime())
CentralOccurCountFps = CurTime() + CentralTimerFps
end			
if (Central_FpsBoostRetTableV("CentralDrawHudC") != 1) then return end
if (CentralFPSbooster_ImprovedLang[LocalPlayer().Central_ImprovedLanguage] == nil) then return end
draw.SimpleText("FPS : " ..CentralFpsDetect.. " " ..CentralFPSbooster_ImprovedLang[LocalPlayer().Central_ImprovedLanguage]["Central_Texte39"].. " " ..string.upper( CentralMap ), "CentralFpsBoostV", ScrW() * (Central_FpsBoostRetTableV("CentralHUDPosW") / 100),  ScrH() * (Central_FpsBoostRetTableV("CentralHUDPosH") / 100), Central_ColorFPSF, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end
end
hook.Add("HUDPaint","CentralBoosterDrawHud", CentralBoosterDrawHud)

net.Receive("centralboostreset", function()
if !IsValid(LocalPlayer()) then return end
CentralBoostFps = false
chat.AddText(Central_ColorFPSC, "[", Central_NmV.. " Boost Framerate", "] : ", Central_ColorFPSF, CentralFPSbooster_ImprovedLang[LocalPlayer().Central_ImprovedLanguage]["Central_Texte11"] )
Central_ResetConCommand()
end)

hook.Add("OnEntityCreated","WidgetInit",function(ent) --- Facepunch
if ent:IsWidget() then
hook.Add( "PlayerTick", "TickWidgets", function( pl, mv ) 
widgets.PlayerTick( pl, mv ) 
end) 
hook.Remove("OnEntityCreated","WidgetInit")
end
end)