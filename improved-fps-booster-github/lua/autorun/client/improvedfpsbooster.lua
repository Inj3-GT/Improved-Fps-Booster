------------- Script by Inj3, PROHIBITED to copy the code !
------------- If you have any language to add or suggestion, contact me on my steam.
------------- If you want to take a piece of code -> contact Inj3
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
local CentralFPSbooster_SauvegardeCVInit, CentralFPSbooster_SauvegardeChemin, CentralFPSbooster_TableFpsConvar = {} , "improvedfpsbooster/sauvegarde/sv.txt",  {}

CentralFPSbooster_TableFpsConvar = {
[1] = { CentralValueConvar = "CentralMultiCoreC", CentralValueT = 1, CentralValueD =  "vide" },
[2] = { CentralValueConvar = "CentralSkyboxC", CentralValueT = 1, CentralValueD =  "vide" },
[3] = { CentralValueConvar = "CentralSprayC", CentralValueT = 1, CentralValueD =  "vide" },
[4] = { CentralValueConvar = "CentralTeethC", CentralValueT = 1, CentralValueD =  "vide" },
[5] = { CentralValueConvar = "CentralM9KC", CentralValueT = 1, CentralValueD =  "vide" },
[6] = { CentralValueConvar = "CentralShadowC", CentralValueT = 0, CentralValueD =  "vide" },
[7] = { CentralValueConvar = "CentralAutresC", CentralValueT = 1, CentralValueD =  "vide" },
[8] = { CentralValueConvar = "CentralOptiReloadAut", CentralValueT = 1, CentralValueD =  "vide" },
[9] = { CentralValueConvar = "CentralDrawHudC", CentralValueT = 0, CentralValueD =  "vide" },
[10] = { CentralValueConvar = "CentralHUDPosW", CentralValueT = 50, CentralValueD =  "vide" },
[11] = { CentralValueConvar = "CentralHUDPosH", CentralValueT = 50, CentralValueD =  "vide" },
[12] = { CentralValueConvar = "CentralImprovedLanguageCV", CentralValueT = "nil", CentralValueD = "nil" },
[13] = { CentralValueConvar = "CentralMatFilterTextures", CentralValueT = 0, CentralValueD = "vide" },
[14] = { CentralValueConvar = "CentralMatFilterLightmaps", CentralValueT = 1, CentralValueD = "vide" }
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
if istable(Central_FpsBooster_TblUtil) then
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
timer.Simple(0.5, function()
LocalPlayer():ConCommand("say /boost")
end)
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

local function Central_FpsBoosterCheckDataClient() --- Only use on clientside/ does not affect server performance
timer.Simple(0.3, function()
Central_ChgLangueSys() -- Load Language
end)
if !file.Exists( CentralFPSbooster_SauvegardeChemin, "DATA" ) then
file.CreateDir("improvedfpsbooster/sauvegarde")
CentralCreateConvar(true)
else
CentralCreateConvar(false)
end 
end 
net.Receive("CentralBoostLDData", Central_FpsBoosterCheckDataClient)

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
if CentralCalculFPS == 0 and CentralBoostFps == true and CentralLoadRefresh != true then 
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
CentralPlyConC:ConCommand("cl_threaded_bone_setup 0")
CentralPlyConC:ConCommand("r_threaded_particles 0")
CentralPlyConC:ConCommand("r_threaded_renderables 0")
CentralPlyConC:ConCommand("cl_threaded_client_leaf_system 0")
CentralPlyConC:ConCommand("gmod_mcore_test 0")
CentralPlyConC:ConCommand("mat_queue_mode 0")
CentralPlyConC:ConCommand("r_queued_ropes 0")
CentralPlyConC:ConCommand("r_3dsky 1")
CentralPlyConC:ConCommand("cl_playerspraydisable 0")
CentralPlyConC:ConCommand("r_teeth 1")
CentralPlyConC:ConCommand("r_shadows 1")
CentralPlyConC:ConCommand("M9KGasEffect 1")
CentralPlyConC:ConCommand("r_threaded_client_shadow_manager 0")	
CentralPlyConC:ConCommand("mat_filterlightmaps 1")
CentralPlyConC:ConCommand("mat_filtertextures 1")
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

if Central_FpsBoostRetTableV("CentralMultiCoreC") == 0 and Central_FpsBoostRetTableV("CentralSkyboxC") == 0 and Central_FpsBoostRetTableV("CentralSprayC") == 0 and Central_FpsBoostRetTableV("CentralTeethC") == 0 and Central_FpsBoostRetTableV("CentralM9KC") == 0 and Central_FpsBoostRetTableV("CentralShadowC") == 0 and Central_FpsBoostRetTableV("CentralAutresC") == 0 and Central_FpsBoostRetTableV("CentralMatFilterTextures") == 0 and Central_FpsBoostRetTableV("CentralMatFilterLightmaps") == 0 then
CentralToutCocher = true
CentralBoostFps = false
chat.AddText(Central_ColorFPSF, "[", "ERROR", "] : ", Central_ColorFPSC, CentralTable.LangImprovedFpsBooster[CentralPly.Central_ImprovedLanguage]["Central_Texte2"] )
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
draw.SimpleText(( CentralTable.LangImprovedFpsBooster[CentralPly.Central_ImprovedLanguage]["Central_Texte12"] ),"CentralFpsBoost",w/2,3,Central_ColorFPSF, TEXT_ALIGN_CENTER)
if CentralBoostFps == true then 
draw.SimpleText(("FPS :" ),"CentralFpsBoost",125,16,Central_ColorFPSF, TEXT_ALIGN_RIGHT)
draw.SimpleText(("ON (BOOST)" ),"CentralFpsBoost",195,16,Central_ColorFPSB, TEXT_ALIGN_RIGHT)
else
draw.SimpleText(("FPS :" ),"CentralFpsBoost",118,16,Central_ColorFPSF, TEXT_ALIGN_RIGHT)
draw.SimpleText((CentralTable.LangImprovedFpsBooster[CentralPly.Central_ImprovedLanguage]["Central_Texte14"] ),"CentralFpsBoost",w/2 + 15,16,Central_ColorFPSC, TEXT_ALIGN_CENTER)
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
CentralLangue:SetValue( CentralTable.LangImprovedFpsBooster[CentralPly.Central_ImprovedLanguage]["Central_Texte38"] )
else
CentralLangue:SetValue( CentralTable.LangImprovedFpsBooster[CentralPly.Central_ImprovedLanguage]["Central_Texte38"].. " : " ..CentralPly.Central_ImprovedLanguage )
end
for lang, _ in pairs(CentralTable.LangImprovedFpsBooster) do 
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
CentralLangue:SetValue( CentralTable.LangImprovedFpsBooster[CentralPly.Central_ImprovedLanguage]["Central_Texte38"].. " : " ..CentralPly.Central_ImprovedLanguage )
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
draw.DrawText( CentralTable.LangImprovedFpsBooster[CentralPly.Central_ImprovedLanguage]["Central_Texte1"], "CentralFpsBoost", w/2,3, Central_ColorFPSF, TEXT_ALIGN_CENTER )
end
CentralQuitterFps.DoClick = function()
chat.AddText(Central_ColorFPSC, "[", Central_NmV.. " Boost Framerate", "] : ", Central_ColorFPSF, CentralTable.LangImprovedFpsBooster[CentralPly.Central_ImprovedLanguage]["Central_Texte10"] )
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
draw.SimpleText(( CentralTable.LangImprovedFpsBooster[CentralPly.Central_ImprovedLanguage]["Central_Texte3"] ),"CentralFpsBoost",w/2+35,1,Central_ColorFPSG, TEXT_ALIGN_RIGHT)
draw.SimpleText(( CentralTable.LangImprovedFpsBooster[CentralPly.Central_ImprovedLanguage]["Central_Texte5"] ), "CentralFpsBoost",w/2 +7,15,Central_ColorFPSG, TEXT_ALIGN_RIGHT)
draw.SimpleText(( CentralFpsDetect ), "CentralFpsBoostV", w/2 + 12,14,CentralColorFps, TEXT_ALIGN_LEFT)
draw.SimpleText(("Min : " ), "CentralFpsBoost",32,43,Central_ColorFPSG, TEXT_ALIGN_CENTER)
draw.SimpleText(( CentralFpsMin ), "CentralFpsBoostV",48,42,CentralColorFpsmin, TEXT_ALIGN_LEFT)
draw.SimpleText(("Max : "), "CentralFpsBoost",30,29,Central_ColorFPSG, TEXT_ALIGN_CENTER)
draw.SimpleText(( CentralGainCalcul ), "CentralFpsBoost",31,57,Central_ColorFPSG, TEXT_ALIGN_CENTER)
if CentralBoostFps == true then 
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
if CentralBoostFps == true then
CentralVert = Central_ColorFPSD
end		
draw.RoundedBox( 6, 0, 0, w, h, CentralVert )
draw.RoundedBox( 6, 2, 2, w-1, h-1, Central_ColorFPSE )
draw.DrawText( CentralTable.LangImprovedFpsBooster[CentralPly.Central_ImprovedLanguage]["Central_Texte6"], "CentralFpsBoost", w/2,8, Central_ColorFPSF, TEXT_ALIGN_CENTER )
end
CentralActiver.DoClick = function() 
if CentralToutCocher == true then
chat.AddText(Central_ColorFPSF, "[", "ERROR", "] : ", Central_ColorFPSC, CentralTable.LangImprovedFpsBooster[CentralPly.Central_ImprovedLanguage]["Central_Texte2"] )
CentralBoostFps = false
return
end
chat.AddText(Central_ColorFPSC, "[", Central_NmV.. " Boost Framerate", "] : ", Central_ColorFPSF, CentralTable.LangImprovedFpsBooster[CentralPly.Central_ImprovedLanguage]["Central_Texte9"] )
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
if Central_FpsBoostRetTableV("CentralMatFilterLightmaps") == 1 then
CentralPly:ConCommand("mat_filterlightmaps 0")
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
draw.DrawText( CentralTable.LangImprovedFpsBooster[CentralPly.Central_ImprovedLanguage]["Central_Texte7"], "CentralFpsBoost", w/2,8, Central_ColorFPSF, TEXT_ALIGN_CENTER )
end
CentralDesactiver.DoClick = function()
chat.AddText(Central_ColorFPSC, "[", Central_NmV.. " Boost Framerate", "] : ", Central_ColorFPSF, CentralTable.LangImprovedFpsBooster[CentralPly.Central_ImprovedLanguage]["Central_Texte11"] )
if CentralBoostFps == true then
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
local CentralMultiCore = vgui.Create( "DCheckBoxLabel", Central_OptionsBoost_Dscroll)
local CentralSkybox = vgui.Create( "DCheckBoxLabel", Central_OptionsBoost_Dscroll)
local CentralSpray = vgui.Create( "DCheckBoxLabel", Central_OptionsBoost_Dscroll)
local CentralDent = vgui.Create( "DCheckBoxLabel", Central_OptionsBoost_Dscroll)
local CentralAutres = vgui.Create( "DCheckBoxLabel", Central_OptionsBoost_Dscroll)
local CentralM9kEffect = vgui.Create( "DCheckBoxLabel", Central_OptionsBoost_Dscroll)
local CentralShadow = vgui.Create( "DCheckBoxLabel", Central_OptionsBoost_Dscroll)
local CentralMatFilterTextures = vgui.Create( "DCheckBoxLabel", Central_OptionsBoost_Dscroll)
local CentralMatFilterLightmaps = vgui.Create( "DCheckBoxLabel", Central_OptionsBoost_Dscroll)
local CentralHudDraw = vgui.Create( "DCheckBoxLabel", CentralOptionsBoost)
local CentralToutCocherOptions = vgui.Create("DButton", CentralOptionsBoost)
local CentralFermerEtQuitter = vgui.Create("DCheckBoxLabel", CentralOptionsBoost)
local CentralQuitterOptions = vgui.Create("DButton", CentralOptionsBoost)
local CentralPosW = vgui.Create( "DNumSlider", CentralOptionsBoost )
local CentralPosH = vgui.Create( "DNumSlider", CentralOptionsBoost )

CentralOptionsBoost:SetTitle("")
CentralOptionsBoost:ShowCloseButton(false)
CentralOptionsBoost:SetIcon( "icon16/cog.png" )
CentralOptionsBoost:SetDraggable(true)
CentralOptionsBoost:MakePopup()
CentralOptionsBoost:SetTitle("")
CentralOptionsBoost:SetPos(ScrW()/2-160, ScrH()/2-180 )
CentralOptionsBoost:SetSize( 0, 0 )
CentralOptionsBoost:SizeTo( 280, 395, .5, 0, 10)
CentralOptionsBoost.Paint = function( self, w, h )
draw.RoundedBox( 6, 0, 0, w, h, Central_ColorFPSE ) 
draw.RoundedBox( 6, 3, 3, w-7, h-7, Central_ColorFPSF ) 
draw.RoundedBox( 6, 0, 0, w-132, 25, Central_ColorFPSE)
draw.SimpleText(( "[Options]" ),"CentralFpsBoost",78,5,Central_ColorFPSF, TEXT_ALIGN_RIGHT)
draw.SimpleText(( "\73\109\112\114\111\118\101\100\32\70\112\115\32\66\111\111\115\116\101\114\32\118\101\114\115\105\111\110\32\50\46\48\32\47\32\73\110\106\51" ),"CentralFpsBoost",w/2,376,Central_ColorFPSE, TEXT_ALIGN_CENTER)
draw.SimpleText(( "Ping detection : " ..CentralPly:Ping()),"CentralFpsBoost",w/2,360,Central_ColorFPSE, TEXT_ALIGN_CENTER) -- if the ping value is equal to a 1 it's a spoofing.
draw.SimpleText(( CentralTable.LangImprovedFpsBooster[CentralPly.Central_ImprovedLanguage]["Central_Texte15"].. " :" ),"CentralFpsBoost",w/2 ,62,Central_ColorFPSE, TEXT_ALIGN_CENTER)
draw.SimpleText(( "Configuration :" ),"CentralFpsBoost",w/2,215,Central_ColorFPSE, TEXT_ALIGN_CENTER)
draw.SimpleText(( CentralTable.LangImprovedFpsBooster[CentralPly.Central_ImprovedLanguage]["Central_Texte33"] ),"CentralFpsBoost",w/2,280,Central_ColorFPSG, TEXT_ALIGN_CENTER)
draw.SimpleText(( CentralTable.LangImprovedFpsBooster[CentralPly.Central_ImprovedLanguage]["Central_Texte34"] ),"CentralFpsBoost",w/2,320,Central_ColorFPSG, TEXT_ALIGN_CENTER)
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

CentralMultiCore:SetPos( 20, 0 )	
CentralMultiCore:SetFont( "CentralFpsBoost" )
CentralMultiCore:SetText( CentralTable.LangImprovedFpsBooster[CentralPly.Central_ImprovedLanguage]["Central_Texte17"] )	
CentralMultiCore:SetValue(Central_FpsBoostRetTableV("CentralMultiCoreC"))
CentralMultiCore:SetTooltip( CentralTable.LangImprovedFpsBooster[CentralPly.Central_ImprovedLanguage]["Central_Texte16"] )
CentralMultiCore:SetTextColor( Central_ColorFPSG )
CentralMultiCore.Central_Valeur = "CentralMultiCoreC"
CentralMultiCore.OnChange = function( self, val )
local CentralSaveConV_Val = nil
if self.Central_Valeur == "CentralShadowC" then
local CentralValTimer = CentralOccurFramerate - CurTime()
if CentralValTimer < 0 and val then
chat.AddText(Central_ColorFPSC, "[", "Shadow Removed", "] : ", Central_ColorFPSF, CentralTable.LangImprovedFpsBooster[CentralPly.Central_ImprovedLanguage]["Central_Texte4"] )
CentralOccurFramerate = CurTime() + CentralTimerFps
end
end
if val then
CentralSaveConV_Val = 1
else
CentralSaveConV_Val = 0
end
if (CentralSaveConV_Val == nil) then return end
Central_FpsBoosterSauvegardeCV(self.Central_Valeur, CentralSaveConV_Val) 
end
CentralMultiCore:SizeToContents()	

CentralSkybox:SetPos( 20, 25 )	
CentralSkybox:SetFont( "CentralFpsBoost" )
CentralSkybox:SetText( CentralTable.LangImprovedFpsBooster[CentralPly.Central_ImprovedLanguage]["Central_Texte18"] )	
CentralSkybox:SetValue(Central_FpsBoostRetTableV("CentralSkyboxC"))
CentralSkybox:SetTooltip( CentralTable.LangImprovedFpsBooster[CentralPly.Central_ImprovedLanguage]["Central_Texte19"] )	
CentralSkybox:SetTextColor( Central_ColorFPSG )
CentralSkybox.Central_Valeur = "CentralSkyboxC"
CentralSkybox.OnChange = CentralMultiCore.OnChange
CentralSkybox:SizeToContents()

CentralSpray:SetPos(  20, 50 )	
CentralSpray:SetFont( "CentralFpsBoost" )
CentralSpray:SetText( CentralTable.LangImprovedFpsBooster[CentralPly.Central_ImprovedLanguage]["Central_Texte20"] )		
CentralSpray:SetTooltip( CentralTable.LangImprovedFpsBooster[CentralPly.Central_ImprovedLanguage]["Central_Texte21"] )	
CentralSpray:SetValue(Central_FpsBoostRetTableV("CentralSprayC"))
CentralSpray:SetTextColor( Central_ColorFPSG )
CentralSpray.Central_Valeur = "CentralSprayC"
CentralSpray.OnChange = CentralMultiCore.OnChange
CentralSpray:SizeToContents()		

CentralDent:SetPos(  20, 75)	
CentralDent:SetFont( "CentralFpsBoost" )
CentralDent:SetText( CentralTable.LangImprovedFpsBooster[CentralPly.Central_ImprovedLanguage]["Central_Texte22"] )		
CentralDent:SetTooltip( CentralTable.LangImprovedFpsBooster[CentralPly.Central_ImprovedLanguage]["Central_Texte23"] )	
CentralDent:SetValue(Central_FpsBoostRetTableV("CentralTeethC"))
CentralDent:SetTextColor( Central_ColorFPSG )
CentralDent.Central_Valeur = "CentralTeethC"
CentralDent.OnChange = CentralMultiCore.OnChange
CentralDent:SizeToContents()	

CentralM9kEffect:SetPos(  20, 100 )	
CentralM9kEffect:SetFont( "CentralFpsBoost" )
CentralM9kEffect:SetText(  CentralTable.LangImprovedFpsBooster[CentralPly.Central_ImprovedLanguage]["Central_Texte24"] )
CentralM9kEffect:SetTooltip( CentralTable.LangImprovedFpsBooster[CentralPly.Central_ImprovedLanguage]["Central_Texte25"]  )			
CentralM9kEffect:SetValue(Central_FpsBoostRetTableV("CentralM9KC"))
CentralM9kEffect:SetTextColor( Central_ColorFPSG )
CentralM9kEffect.Central_Valeur = "CentralM9KC"
CentralM9kEffect.OnChange = CentralMultiCore.OnChange
CentralM9kEffect:SizeToContents()

CentralShadow:SetPos(  20, 125 )	
CentralShadow:SetFont( "CentralFpsBoost" )
CentralShadow:SetText( CentralTable.LangImprovedFpsBooster[CentralPly.Central_ImprovedLanguage]["Central_Texte26"] )		
CentralShadow:SetTooltip( CentralTable.LangImprovedFpsBooster[CentralPly.Central_ImprovedLanguage]["Central_Texte27"] )
CentralShadow:SetValue(Central_FpsBoostRetTableV("CentralShadowC"))
CentralShadow:SetTextColor( Central_ColorFPSG )
CentralShadow.Central_Valeur = "CentralShadowC"
CentralShadow.OnChange = CentralMultiCore.OnChange
CentralShadow:SizeToContents()
	 
CentralAutres:SetPos(  20, 150 )	
CentralAutres:SetFont( "CentralFpsBoost" )
CentralAutres:SetText( CentralTable.LangImprovedFpsBooster[CentralPly.Central_ImprovedLanguage]["Central_Texte28"] )		
CentralAutres:SetTooltip( "r_threaded_particles, r_threaded_renderables, r_queued_ropes, cl_threaded_client_leaf_system, r_threaded_client_shadow_manager" )
CentralAutres:SetValue(Central_FpsBoostRetTableV("CentralAutresC"))
CentralAutres:SetTextColor( Central_ColorFPSG )
CentralAutres.Central_Valeur = "CentralAutresC"
CentralAutres.OnChange = CentralMultiCore.OnChange
CentralAutres:SizeToContents()		

CentralMatFilterTextures:SetPos(  20, 175 )	
CentralMatFilterTextures:SetFont( "CentralFpsBoost" )
CentralMatFilterTextures:SetText( CentralTable.LangImprovedFpsBooster[CentralPly.Central_ImprovedLanguage]["Central_Texte40"] )		
CentralMatFilterTextures:SetTooltip( CentralTable.LangImprovedFpsBooster[CentralPly.Central_ImprovedLanguage]["Central_Texte42"] )
CentralMatFilterTextures:SetValue(Central_FpsBoostRetTableV("CentralMatFilterTextures"))
CentralMatFilterTextures:SetTextColor( Central_ColorFPSG )
CentralMatFilterTextures.Central_Valeur = "CentralMatFilterTextures"
CentralMatFilterTextures.OnChange = CentralMultiCore.OnChange
CentralMatFilterTextures:SizeToContents()		

CentralMatFilterLightmaps:SetPos(  20, 200 )	
CentralMatFilterLightmaps:SetFont( "CentralFpsBoost" )
CentralMatFilterLightmaps:SetText( CentralTable.LangImprovedFpsBooster[CentralPly.Central_ImprovedLanguage]["Central_Texte41"] )		
CentralMatFilterLightmaps:SetTooltip(CentralTable.LangImprovedFpsBooster[CentralPly.Central_ImprovedLanguage]["Central_Texte43"])
CentralMatFilterLightmaps:SetValue(Central_FpsBoostRetTableV("CentralMatFilterLightmaps"))
CentralMatFilterLightmaps:SetTextColor( Central_ColorFPSG )
CentralMatFilterLightmaps.Central_Valeur = "CentralMatFilterLightmaps"
CentralMatFilterLightmaps.OnChange = CentralMultiCore.OnChange
CentralMatFilterLightmaps:SizeToContents()

CentralFermerEtQuitter:SetPos( 20,233 )	
CentralFermerEtQuitter:SetFont( "CentralFpsBoost" )
CentralFermerEtQuitter:SetText( CentralTable.LangImprovedFpsBooster[CentralPly.Central_ImprovedLanguage]["Central_Texte29"] )		
CentralFermerEtQuitter:SetTooltip( CentralTable.LangImprovedFpsBooster[CentralPly.Central_ImprovedLanguage]["Central_Texte30"]  )
CentralFermerEtQuitter:SetValue(Central_FpsBoostRetTableV("CentralOptiReloadAut"))
CentralFermerEtQuitter:SetTextColor( Central_ColorFPSG )
CentralFermerEtQuitter.Central_Valeur = "CentralOptiReloadAut"
CentralFermerEtQuitter.OnChange = CentralMultiCore.OnChange
CentralFermerEtQuitter:SizeToContents()	

CentralHudDraw:SetPos( 20,258 )	
CentralHudDraw:SetFont( "CentralFpsBoost" )
CentralHudDraw:SetText( CentralTable.LangImprovedFpsBooster[CentralPly.Central_ImprovedLanguage]["Central_Texte31"] )		
CentralHudDraw:SetTooltip( CentralTable.LangImprovedFpsBooster[CentralPly.Central_ImprovedLanguage]["Central_Texte32"] )
CentralHudDraw:SetValue(Central_FpsBoostRetTableV("CentralDrawHudC"))
CentralHudDraw:SetTextColor( Central_ColorFPSG )
CentralHudDraw.Central_Valeur = "CentralDrawHudC"
CentralHudDraw.OnChange = CentralMultiCore.OnChange
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
draw.DrawText( CentralTable.LangImprovedFpsBooster[CentralPly.Central_ImprovedLanguage]["Central_Texte35"], "CentralFpsBoost", w/2 +7,2, Central_ColorFPSF, TEXT_ALIGN_CENTER )
end
CentralQuitterOptions.DoClick = function()
if Central_FpsBoostRetTableV("CentralOptiReloadAut") == 1 then
CentralBoostFps = true
end
if CentralBoostFps == true then
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
if Central_FpsBoostRetTableV("CentralMatFilterLightmaps") == 1 then
CentralPly:ConCommand("mat_filterlightmaps 0")
else
CentralPly:ConCommand("mat_filterlightmaps 1")
end
if Central_FpsBoostRetTableV("CentralMatFilterTextures") == 1 then
CentralPly:ConCommand("mat_filtertextures 0")
else
CentralPly:ConCommand("mat_filtertextures 1")
end
timer.Simple(0.1, function()
if CentralToutCocher == false then
chat.AddText(Central_ColorFPSC, "[", Central_NmV.. " Boost Framerate", "] : ", Central_ColorFPSF, CentralTable.LangImprovedFpsBooster[CentralPly.Central_ImprovedLanguage]["Central_Texte37"] )
else
chat.AddText(Central_ColorFPSC, "[", Central_NmV.. " Boost Framerate", "] : ", Central_ColorFPSF, CentralTable.LangImprovedFpsBooster[CentralPly.Central_ImprovedLanguage]["Central_Texte13"] )
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
draw.DrawText( CentralTable.LangImprovedFpsBooster[CentralPly.Central_ImprovedLanguage]["Central_Texte36"], "CentralFpsBoost", w/2 +5,2, Central_ColorFPSF, TEXT_ALIGN_CENTER )
end
CentralToutCocherOptions.DoClick = function()
if CentralToutCocher then
CentralM9kEffect:SetValue(1)
CentralAutres:SetValue(1)
CentralShadow:SetValue(1)
CentralDent:SetValue(1)
CentralSpray:SetValue(1)
CentralSkybox:SetValue(1)
CentralMultiCore:SetValue(1)
CentralMatFilterTextures:SetValue(1)
CentralMatFilterLightmaps:SetValue(1)
CentralToutCocher = false
else
CentralM9kEffect:SetValue(0)
CentralAutres:SetValue(0)
CentralShadow:SetValue(0)
CentralDent:SetValue(0)
CentralSpray:SetValue(0)
CentralSkybox:SetValue(0)
CentralMultiCore:SetValue(0)
CentralMatFilterTextures:SetValue(0)
CentralMatFilterLightmaps:SetValue(0)
CentralToutCocher = true
end 
surface.PlaySound( "buttons/button9.wav" )
end
end
if (Central_NmV == nil or Central_NmV != "\67\101\110\116\114\97\108\67\105\116\121") then 
for i = 1, 50 do
CentralPly:PrintMessage( HUD_PRINTTALK, "Please reinstall Improved Fps Booster from Github, or the Workshop !" )
end 
timer.Simple(0.1, function()
Central_FrmPanel()
end)
end
end
net.Receive("CentralBoost", CentralFpsBoostPanel)
	
local function CentralBoosterDrawHud()
if (CentralBoostOV or Central_FpsBoostRetTableV("CentralDrawHudC") == 1) then --- We only execute the code when we need to.
local Central_ValTimerClientDelai = CentralOccurCountFps - CurTime() --- Client delay
if Central_ValTimerClientDelai < 0 then
CentralFpsDetect = math.Round(1/RealFrameTime())
CentralOccurCountFps = CurTime() + CentralTimerFps
end			
if (Central_FpsBoostRetTableV("CentralDrawHudC") != 1) then return end
if (CentralTable.LangImprovedFpsBooster[LocalPlayer().Central_ImprovedLanguage] == nil) then return end
draw.SimpleText("FPS : " ..CentralFpsDetect.. " " ..CentralTable.LangImprovedFpsBooster[LocalPlayer().Central_ImprovedLanguage]["Central_Texte39"].. " " ..string.upper( CentralMap ), "CentralFpsBoostV", ScrW() * (Central_FpsBoostRetTableV("CentralHUDPosW") / 100),  ScrH() * (Central_FpsBoostRetTableV("CentralHUDPosH") / 100), Central_ColorFPSF, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end
end
hook.Add("HUDPaint","CentralBoosterDrawHud", CentralBoosterDrawHud)

net.Receive("CentralReset", function()
if !IsValid(LocalPlayer()) then return end
CentralBoostFps = false
chat.AddText(Central_ColorFPSC, "[", Central_NmV.. " Boost Framerate", "] : ", Central_ColorFPSF, CentralTable.LangImprovedFpsBooster[LocalPlayer().Central_ImprovedLanguage]["Central_Texte11"] )
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
