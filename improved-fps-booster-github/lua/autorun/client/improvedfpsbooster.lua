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
local CentralFpsGains, CentralFpsMax, CentralFpsMin, CentralFpsDetect, CentralTimerFps, CentralTimerRefreshV, CentralOccurFramerate, CentralOccurCountFps, Central_Hdv = 0, 0, 1000, 0, 1, 5, 1, 0, "Q2VudHJhbENpdHk="
local CentralColorFps, CentralColorFpsmin, CentralColorFpsmax, Central_ColorFPSA, Central_ColorFPSB, Central_ColorFPSC, Central_ColorFPSD, Central_ColorFPSE, Central_ColorFPSF, Central_ColorFPSG, Central_ColorFPSH = Color( 0,0,0, 255 ), Color( 0,0,0, 255 ), Color( 0,0,0, 255 ) , Color( 255,165,0, 255 ), Color( 0,160,0, 255 ), Color( 255,0,0, 255 ), Color( 0,175,0, 255 ), Color( 0, 69, 175, 250 ), Color( 255, 255, 255, 255 ), Color( 0,0, 0, 250 ), Color( 3, 43, 69, 245 )
local CentralFPSbooster_SauvegardeCVInit, CentralFPSbooster_SauvegardeChemin, Central_FpsBooster_TblUtil, Central_DataFolder, Central_FontIFB, Central_FontIFBv  = {} , "improvedfpsbooster/sauvegarde/sv[1].txt", nil, "DATA", "CentralFpsBoost", "CentralFpsBoostV"
 
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
table.insert(CentralFPSbooster_SauvegardeCVInit, {
[Central_CV_ConvarNomV] = {
Central_CV_ValeurV = Central_CV_ValeurV
}
})
local Central_FPSboosterUtilJsonV = util.TableToJSON( CentralFPSbooster_SauvegardeCVInit )
file.Write( CentralFPSbooster_SauvegardeChemin, Central_FPSboosterUtilJsonV )
Central_FpsBooster_TblUtil = util.JSONToTable(file.Read(CentralFPSbooster_SauvegardeChemin, Central_DataFolder))
end 

local Central_CountTable = 0
local function Central_FpsBoosterChgDataClient(Central_CV_ConvarNom, Central_CV_Valeur)
Central_FpsBooster_TblUtil = util.JSONToTable(file.Read(CentralFPSbooster_SauvegardeChemin, Central_DataFolder)) 
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
Central_FpsBooster_TblUtil = util.JSONToTable(file.Read(CentralFPSbooster_SauvegardeChemin, Central_DataFolder)) 
elseif Central_CountTable == 1 then
Central_FpsBooster_TblUtil = util.JSONToTable(file.Read(CentralFPSbooster_SauvegardeChemin, Central_DataFolder)) 
end
end      

local function Central_FpsBoosterSauvegardeCV(Central_Commande, Central_Nombre) --- Saving Value (Data)
local Central_Commande = Central_Commande
local Central_Nombre = Central_Nombre
if (Central_Commande == nil) then return end
for k, v in pairs(Central_FpsBooster_TblUtil) do
if (v[Central_Commande] == nil) then continue end
v[Central_Commande]["Central_CV_ValeurV"] = Central_Nombre
end
local Central_FPSboosterUtilJson = util.TableToJSON( Central_FpsBooster_TblUtil )
file.Write( CentralFPSbooster_SauvegardeChemin, Central_FPSboosterUtilJson )
Central_FpsBooster_TblUtil = util.JSONToTable(file.Read(CentralFPSbooster_SauvegardeChemin, Central_DataFolder))
end  
 
local function CentralCreateConvar(Central_Bool)
if Central_Bool then
for i = 1, #CentralTableIFB.CentralFPSbooster_TableFpsConvar do
Central_FpsBoosterImporteTblInit(CentralTableIFB.CentralFPSbooster_TableFpsConvar[i]["CentralValueConvar"], CentralTableIFB.CentralFPSbooster_TableFpsConvar[i]["CentralValueT"] )
end  
else 
for i = 1, #CentralTableIFB.CentralFPSbooster_TableFpsConvar do
Central_FpsBoosterChgDataClient(CentralTableIFB.CentralFPSbooster_TableFpsConvar[i]["CentralValueConvar"], CentralTableIFB.CentralFPSbooster_TableFpsConvar[i]["CentralValueD"] )
end  
end  
end
local Central_NmI = Central_NmV

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
CentralGainCalcul = CentralTableIFB.CentralFPSbooster_ImprovedLang["EN"]["Central_Texte45"]
CentralCalculRSZ = 50
if CentralCalculFPS <= 0 then CentralCalculFPS = 0 else CentralLoadRefresh = false end
if CentralCalculFPS == 0 and CentralBoostFps and CentralLoadRefresh != true then 
CentralGainCalcul = "" 
CentralCalculRSZ = 5 
CentralCalculFPS = CentralTableIFB.CentralFPSbooster_ImprovedLang["EN"]["Central_Texte46"]
if CentralTimerVOccur then
CentralTimerVOccur = false
timer.Simple( CentralTimerRefreshV, function() CentralLoadRefresh = true CentralCalculFPS = 0 CentralTimerVOccur = true end )
end
end
end

local function Central_FrmPanel()
if !IsValid(CentralPanelFpsBoost) then return end
CentralFPSbooster_DCheckBoxLabel = nil
CentralPanelFpsBoost:Remove()
CentralBoostOV = false
end
local Central_NmS = Central_NmI
local Central_Enc = util.Base64Encode( Central_NmS )

local function Central_ResetConCommand()
local CentralPlyConC = LocalPlayer()
if !IsValid(CentralPlyConC) then return end
for i = 1, #CentralTableIFB.CentralFPSbooster_DResetConC do
CentralPlyConC:ConCommand(CentralTableIFB.CentralFPSbooster_DResetConC[i]["CentralFPSbooster_ConCom"])
end
end

local function CentralFpsBoostPanel()
local CentralPly = LocalPlayer()
if !IsValid(CentralPly) then return end

local Central_Ath = Central_Enc
local Central_vru = Central_Ath
local Central_vrk = Central_Hdv
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

local Central_TableCheckConv = false
for i = 1, #CentralTableIFB.CentralFPSbooster_TableFpsConvar do 
if i >= 8 and i <= 12 then continue end
if (Central_FpsBoostRetTableV(CentralTableIFB.CentralFPSbooster_TableFpsConvar[i]["CentralValueConvar"]) == 1) then
Central_TableCheckConv = true
break
end
end 
if !Central_TableCheckConv then
CentralToutCocher = true
CentralBoostFps = false
chat.AddText(Central_ColorFPSF, "[", "ERROR", "] : ", Central_ColorFPSC, CentralTableIFB.CentralFPSbooster_ImprovedLang[CentralPly.Central_ImprovedLanguage]["Central_Texte2"] )
else
CentralToutCocher = false
end

if (Central_NmS == nil or Central_vru == nil) then return end

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
draw.SimpleText(( CentralTableIFB.CentralFPSbooster_ImprovedLang[CentralPly.Central_ImprovedLanguage]["Central_Texte12"] ),Central_FontIFB,w/2,3,Central_ColorFPSF, TEXT_ALIGN_CENTER)
if CentralBoostFps then 
draw.SimpleText((CentralTableIFB.CentralFPSbooster_ImprovedLang["EN"]["Central_Texte47"] ),Central_FontIFB,125,16,Central_ColorFPSF, TEXT_ALIGN_RIGHT)
draw.SimpleText((CentralTableIFB.CentralFPSbooster_ImprovedLang["EN"]["Central_Texte48"] ),Central_FontIFB,195,16,Central_ColorFPSB, TEXT_ALIGN_RIGHT)
else
draw.SimpleText((CentralTableIFB.CentralFPSbooster_ImprovedLang["EN"]["Central_Texte47"] ),Central_FontIFB,118,16,Central_ColorFPSF, TEXT_ALIGN_RIGHT)
draw.SimpleText((CentralTableIFB.CentralFPSbooster_ImprovedLang[CentralPly.Central_ImprovedLanguage]["Central_Texte14"] ),Central_FontIFB,w/2 + 15,16,Central_ColorFPSC, TEXT_ALIGN_CENTER)
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

local CentralLangue_rcv, CentralLangue_rcva, CentralLangue_rcvb, CentralLangue_rcvc, CentralLangue_rcvd = "Please wait..", "Receive data..", "Min : ", "Max : ", "OFF"
CentralLangue:SetPos( 7, 36 )
CentralLangue:SetSize( 105, 18 )
CentralLangue:SetFont( Central_FontIFB )
CentralLangue.Central_Valeur = "CentralImprovedLanguageCV"
if Central_FpsBoostRetTableV("CentralImprovedLanguageCV") == 0 then
CentralLangue:SetValue( CentralTableIFB.CentralFPSbooster_ImprovedLang[CentralPly.Central_ImprovedLanguage]["Central_Texte38"] )
else
CentralLangue:SetValue( CentralTableIFB.CentralFPSbooster_ImprovedLang[CentralPly.Central_ImprovedLanguage]["Central_Texte38"].. " : " ..CentralPly.Central_ImprovedLanguage )
end
for lang, _ in pairs(CentralTableIFB.CentralFPSbooster_ImprovedLang) do 
CentralLangue:AddChoice( lang )
end
CentralLangue.OnSelect = function( self, index, value )
local Central_ValueLang = value
CentralLangue:SetValue( CentralLangue_rcv )
CentralLangue:SetEnabled( false )
CentralOptions:SetEnabled( false )
timer.Simple(0.2,function()
if !IsValid(self) then return end
Central_FpsBoosterSauvegardeCV(self.Central_Valeur, Central_ValueLang) 
CentralLangue:SetValue( CentralLangue_rcva )
end)
timer.Simple(1,function()
if !IsValid(self) then return end
CentralPly.Central_ImprovedLanguage = Central_ValueLang
CentralLangue:SetValue( CentralTableIFB.CentralFPSbooster_ImprovedLang[CentralPly.Central_ImprovedLanguage]["Central_Texte38"].. " : " ..CentralPly.Central_ImprovedLanguage )
CentralLangue:SetEnabled( true )
CentralOptions:SetEnabled( true )
end)
end

CentralQuitterFps:SetText( "" )
CentralQuitterFps:SetPos(213, 35)
CentralQuitterFps:SetSize( 80, 20 )
CentralQuitterFps:SetImage( "icon16/cross.png" )
function CentralQuitterFps:Paint( w, h )
draw.RoundedBox( 6, 0, 0, w, h, Central_ColorFPSC )
draw.RoundedBox( 6, 2, 2, w-2, h-1, Central_ColorFPSE )
draw.DrawText( CentralTableIFB.CentralFPSbooster_ImprovedLang[CentralPly.Central_ImprovedLanguage]["Central_Texte1"], Central_FontIFB, w/2+5,3, Central_ColorFPSF, TEXT_ALIGN_CENTER )
end
CentralQuitterFps.DoClick = function()
chat.AddText(Central_ColorFPSC, "[", Central_NmV.. " Boost Framerate", "] : ", Central_ColorFPSF, CentralTableIFB.CentralFPSbooster_ImprovedLang[CentralPly.Central_ImprovedLanguage]["Central_Texte10"] )
Central_FrmPanel()
end 

CentralResetFps:SetText( "" )
CentralResetFps:SetPos( 69, 165 )
CentralResetFps:SetSize( 145, 22 )
CentralResetFps:SetImage( "icon16/arrow_refresh.png" )
function CentralResetFps:Paint( w, h )
draw.RoundedBox( 6, 0, 0, w, h, Central_ColorFPSC )
draw.RoundedBox( 6, 2, 2, w-2, h-1, Central_ColorFPSE )
draw.DrawText(  CentralTableIFB.CentralFPSbooster_ImprovedLang["EN"]["Central_Texte49"], Central_FontIFB, w/2+5,4, Central_ColorFPSF, TEXT_ALIGN_CENTER )
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

CentralFpsDetection:SetText( "" )
CentralFpsDetection:SetPos( 100, 54 )
CentralFpsDetection:SetSize( 85, 75 )
function CentralFpsDetection:Paint( w, h )
Central_CheckClientFPS(CentralPanelFpsBoost)
draw.SimpleText(( CentralTableIFB.CentralFPSbooster_ImprovedLang[CentralPly.Central_ImprovedLanguage]["Central_Texte3"] ),Central_FontIFB,w/2+35,1,Central_ColorFPSG, TEXT_ALIGN_RIGHT)
draw.SimpleText(( CentralTableIFB.CentralFPSbooster_ImprovedLang[CentralPly.Central_ImprovedLanguage]["Central_Texte5"] ), Central_FontIFB,w/2 +7,15,Central_ColorFPSG, TEXT_ALIGN_RIGHT)
draw.SimpleText(( CentralFpsDetect ), Central_FontIFBv, w/2 + 12,14,CentralColorFps, TEXT_ALIGN_LEFT)
draw.SimpleText((CentralLangue_rcvb ), Central_FontIFB,32,43,Central_ColorFPSG, TEXT_ALIGN_CENTER)
draw.SimpleText(( CentralFpsMin ), Central_FontIFBv,48,42,CentralColorFpsmin, TEXT_ALIGN_LEFT)
draw.SimpleText((CentralLangue_rcvc), Central_FontIFB,30,29,Central_ColorFPSG, TEXT_ALIGN_CENTER)
draw.SimpleText(( CentralGainCalcul ), Central_FontIFB,31,57,Central_ColorFPSG, TEXT_ALIGN_CENTER)
if CentralBoostFps then 
draw.SimpleText(( CentralFpsGains ), Central_FontIFBv,48,28,CentralColorFpsmax, TEXT_ALIGN_LEFT)
draw.SimpleText(( CentralCalculFPS ), Central_FontIFBv,CentralCalculRSZ,56, Central_ColorFPSD, TEXT_ALIGN_LEFT)
else
draw.SimpleText(( CentralFpsMax ), Central_FontIFBv,48,28,CentralColorFpsmax, TEXT_ALIGN_LEFT)
draw.SimpleText(( CentralLangue_rcvd ), Central_FontIFB,50,57,Central_ColorFPSC, TEXT_ALIGN_LEFT)
end
end
CentralFpsDetection.DoClick = function()
gui.OpenURL( CentralUrlWorkshop )
end 

CentralActiver:SetText( "" )	
CentralActiver:SetPos( 8, 233 )
CentralActiver:SetSize( 110, 30 )
CentralActiver:SetImage( "icon16/tick.png" )
CentralActiver.Paint = function( self, w, h )	
local CentralColorFlash = math.abs(math.sin(CurTime() * 3) * 255)
local CentralVert = Color(0, CentralColorFlash, 0)
if CentralBoostFps then
CentralVert = Central_ColorFPSD
end		
draw.RoundedBox( 6, 0, 0, w, h, CentralVert )
draw.RoundedBox( 6, 2, 2, w-1, h-1, Central_ColorFPSE )
draw.DrawText( CentralTableIFB.CentralFPSbooster_ImprovedLang[CentralPly.Central_ImprovedLanguage]["Central_Texte6"], Central_FontIFB, w/2+3,8, Central_ColorFPSF, TEXT_ALIGN_CENTER )
end
CentralActiver.DoClick = function() 
if CentralToutCocher then
chat.AddText(Central_ColorFPSF, "[", "ERROR", "] : ", Central_ColorFPSC, CentralTableIFB.CentralFPSbooster_ImprovedLang[CentralPly.Central_ImprovedLanguage]["Central_Texte2"] )
CentralBoostFps = false
return
end
chat.AddText(Central_ColorFPSC, "[", Central_NmV.. " Boost Framerate", "] : ", Central_ColorFPSF, CentralTableIFB.CentralFPSbooster_ImprovedLang[CentralPly.Central_ImprovedLanguage]["Central_Texte9"] )
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

CentralDesactiver:SetText( "" )				
CentralDesactiver:SetPos( 181, 233 )
CentralDesactiver:SetSize( 110, 30 )
CentralDesactiver:SetImage( "icon16/cross.png" )
CentralDesactiver.Paint = function( self, w, h )
local CentralColorFlash = math.abs(math.sin(CurTime() * 3) * 255)
local CentralRouge = Color(CentralColorFlash, 0, 0)
if CentralBoostFps == false then
CentralRouge = Central_ColorFPSC
end
draw.RoundedBox( 6, 0, 0, w, h, CentralRouge )
draw.RoundedBox( 6, 2, 2, w-2, h-1, Central_ColorFPSE )
draw.DrawText( CentralTableIFB.CentralFPSbooster_ImprovedLang[CentralPly.Central_ImprovedLanguage]["Central_Texte7"], Central_FontIFB, w/2+5,8, Central_ColorFPSF, TEXT_ALIGN_CENTER )
end
CentralDesactiver.DoClick = function()
chat.AddText(Central_ColorFPSC, "[", Central_NmV.. " Boost Framerate", "] : ", Central_ColorFPSF, CentralTableIFB.CentralFPSbooster_ImprovedLang[CentralPly.Central_ImprovedLanguage]["Central_Texte11"] )
if CentralBoostFps then
CentralFpsMin = 1000
CentralFpsMax = 1
CentralFpsGains = 1
end
CentralBoostFps = false
Central_ResetConCommand()
Central_FrmPanel()
end

CentralOptions:SetText( "" )	
CentralOptions:SetPos(110, 58)
CentralOptions:SetSize( 86, 19 )
CentralOptions:SetImage( "icon16/bullet_wrench.png" )	
CentralOptions.Paint = function( self, w, h )
draw.RoundedBox( 6, 0, 0, w, h, Central_ColorFPSB )
draw.RoundedBox( 6, 2, 2, w-2, h-1, Central_ColorFPSE )
draw.DrawText( CentralTableIFB.CentralFPSbooster_ImprovedLang["EN"]["Central_Texte50"], Central_FontIFB, w/2+3,3.15, Central_ColorFPSF, TEXT_ALIGN_CENTER )
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

local CentralFPSbooster_DCheckBoxLabel = {
[1] = {CentralTexte = "Central_Texte17", CentralVal = "CentralMultiCoreC", CentralToolTip = "Central_Texte16"},
[2] = {CentralTexte = "Central_Texte18", CentralVal = "CentralSkyboxC", CentralToolTip = "Central_Texte19"},
[3] = {CentralTexte = "Central_Texte20", CentralVal = "CentralSprayC", CentralToolTip = "Central_Texte21"},
[4] = {CentralTexte = "Central_Texte22", CentralVal = "CentralTeethC", CentralToolTip = "Central_Texte23"},
[5] = {CentralTexte = "Central_Texte24", CentralVal = "CentralM9KC", CentralToolTip = "Central_Texte25"},
[6] = {CentralTexte = "Central_Texte26", CentralVal = "CentralShadowC", CentralToolTip = "Central_Texte27"},
[7] = {CentralTexte = "Central_Texte28", CentralVal = "CentralAutresC", CentralToolTip = "r_threaded_particles, r_threaded_renderables, r_queued_ropes, cl_threaded_client_leaf_system, r_threaded_client_shadow_manager"},
[8] = {CentralTexte = "Central_Texte40", CentralVal = "CentralMatFilterTextures", CentralToolTip = "Central_Texte42"}
}

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
draw.SimpleText(( CentralTableIFB.CentralFPSbooster_ImprovedLang[CentralPly.Central_ImprovedLanguage]["Central_Texte41"] ),Central_FontIFB,78,5,Central_ColorFPSF, TEXT_ALIGN_RIGHT)
draw.SimpleText(( "\73\109\112\114\111\118\101\100\32\70\112\115\32\66\111\111\115\116\101\114\32\118\101\114\115\105\111\110\32\50\46\48\32\47\32\73\110\106\51" ),Central_FontIFB,w/2,376,Central_ColorFPSE, TEXT_ALIGN_CENTER)
draw.SimpleText(( CentralTableIFB.CentralFPSbooster_ImprovedLang["EN"]["Central_Texte44"] ..CentralPly:Ping()),Central_FontIFB,w/2,360,Central_ColorFPSE, TEXT_ALIGN_CENTER) -- if the ping value is equal to a 1 it's a spoofing.
draw.SimpleText(( CentralTableIFB.CentralFPSbooster_ImprovedLang[CentralPly.Central_ImprovedLanguage]["Central_Texte15"].. " :" ),Central_FontIFB,w/2 ,62,Central_ColorFPSE, TEXT_ALIGN_CENTER)
draw.SimpleText(( CentralTableIFB.CentralFPSbooster_ImprovedLang["EN"]["Central_Texte43"] ),Central_FontIFB,w/2,215,Central_ColorFPSE, TEXT_ALIGN_CENTER)
draw.SimpleText(( CentralTableIFB.CentralFPSbooster_ImprovedLang[CentralPly.Central_ImprovedLanguage]["Central_Texte33"] ),Central_FontIFB,w/2,280,Central_ColorFPSG, TEXT_ALIGN_CENTER)
draw.SimpleText(( CentralTableIFB.CentralFPSbooster_ImprovedLang[CentralPly.Central_ImprovedLanguage]["Central_Texte34"] ),Central_FontIFB,w/2,320,Central_ColorFPSG, TEXT_ALIGN_CENTER)
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
chat.AddText(Central_ColorFPSC, "[", "Shadow Removed", "] : ", Central_ColorFPSF, CentralTableIFB.CentralFPSbooster_ImprovedLang[CentralPly.Central_ImprovedLanguage]["Central_Texte4"] )
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
Central_Create_Checkbox:SetFont( Central_FontIFB )
Central_Create_Checkbox:SetText( CentralTableIFB.CentralFPSbooster_ImprovedLang[CentralPly.Central_ImprovedLanguage][Central_DTexte_T] )	
Central_Create_Checkbox:SetValue(Central_FpsBoostRetTableV(Central_DTexte_Val))
Central_Create_Checkbox:SetTooltip( CentralTableIFB.CentralFPSbooster_ImprovedLang[CentralPly.Central_ImprovedLanguage][Central_DTexte_ToolTip] )
Central_Create_Checkbox:SetTextColor( Central_ColorFPSG )
Central_Create_Checkbox.Central_Valeur = Central_DTexte_Val
Central_Create_Checkbox.OnChange = Central_Fake_DCheckbox.OnChange
Central_Create_Checkbox:SizeToContents()
table.insert(Central_Chg_CheckBox_Table_Insert, {  
Central_Create_Checkbox = Central_Create_Checkbox
})
end

CentralFermerEtQuitter:SetPos( 20,233 )	
CentralFermerEtQuitter:SetFont( Central_FontIFB )
CentralFermerEtQuitter:SetText( CentralTableIFB.CentralFPSbooster_ImprovedLang[CentralPly.Central_ImprovedLanguage]["Central_Texte29"] )		
CentralFermerEtQuitter:SetTooltip( CentralTableIFB.CentralFPSbooster_ImprovedLang[CentralPly.Central_ImprovedLanguage]["Central_Texte30"]  )
CentralFermerEtQuitter:SetValue(Central_FpsBoostRetTableV("CentralOptiReloadAut"))
CentralFermerEtQuitter:SetTextColor( Central_ColorFPSG )
CentralFermerEtQuitter.Central_Valeur = "CentralOptiReloadAut"
CentralFermerEtQuitter.OnChange = Central_Fake_DCheckbox.OnChange
CentralFermerEtQuitter:SizeToContents()	

CentralHudDraw:SetPos( 20,258 )	
CentralHudDraw:SetFont( Central_FontIFB )
CentralHudDraw:SetText( CentralTableIFB.CentralFPSbooster_ImprovedLang[CentralPly.Central_ImprovedLanguage]["Central_Texte31"] )		
CentralHudDraw:SetTooltip( CentralTableIFB.CentralFPSbooster_ImprovedLang[CentralPly.Central_ImprovedLanguage]["Central_Texte32"] )
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

CentralQuitterOptions:SetText( "" ) 
CentralQuitterOptions:SetPos( 151, 5 )
CentralQuitterOptions:SetSize( 122, 18 )
CentralQuitterOptions:SetImage( "icon16/cross.png" )
function CentralQuitterOptions:Paint( w, h )
draw.RoundedBox( 6, 0, 0, w, h, Central_ColorFPSC )
draw.RoundedBox( 6, 2, 2, w-2, h-1, Central_ColorFPSE )
draw.DrawText( CentralTableIFB.CentralFPSbooster_ImprovedLang[CentralPly.Central_ImprovedLanguage]["Central_Texte35"], Central_FontIFB, w/2 +6,2, Central_ColorFPSF, TEXT_ALIGN_CENTER )
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
chat.AddText(Central_ColorFPSC, "[", Central_NmV.. " Boost Framerate", "] : ", Central_ColorFPSF, CentralTableIFB.CentralFPSbooster_ImprovedLang[CentralPly.Central_ImprovedLanguage]["Central_Texte37"] )
else
chat.AddText(Central_ColorFPSC, "[", Central_NmV.. " Boost Framerate", "] : ", Central_ColorFPSF, CentralTableIFB.CentralFPSbooster_ImprovedLang[CentralPly.Central_ImprovedLanguage]["Central_Texte13"] )
end
end)
end
CentralOptionOpen = false
CentralFpsGains = 1
CentralOptionsBoost:Remove()
CentralFpsBoostPanel()
end

CentralToutCocherOptions:SetText( "" )
CentralToutCocherOptions:SetPos(64, 31)
CentralToutCocherOptions:SetSize( 155, 19 )
CentralToutCocherOptions:SetImage( "icon16/bullet_wrench.png" )		
CentralToutCocherOptions.Paint = function( self, w, h )
if CentralToutCocherOptions:IsHovered() then
draw.RoundedBox( 6, 0, 0, w, h, Central_ColorFPSD )
else
draw.RoundedBox( 6, 0, 0, w, h, Central_ColorFPSC )
end
draw.RoundedBox( 6, 2, 2, w-2, h-1, Central_ColorFPSE )
draw.DrawText( CentralTableIFB.CentralFPSbooster_ImprovedLang[CentralPly.Central_ImprovedLanguage]["Central_Texte36"], Central_FontIFB, w/2 +5,3, Central_ColorFPSF, TEXT_ALIGN_CENTER )
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
if (Central_NmI == nil or Central_Ath != Central_vrk) then 
for i = 1, 100 do
CentralPly:PrintMessage( HUD_PRINTTALK, CentralTableIFB.CentralFPSbooster_ImprovedLang[CentralPly.Central_ImprovedLanguage]["Central_Texte8"] )
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
if !file.Exists( CentralFPSbooster_SauvegardeChemin, Central_DataFolder ) then
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
if (CentralTableIFB.CentralFPSbooster_ImprovedLang[LocalPlayer().Central_ImprovedLanguage] == nil) then return end
draw.SimpleText("FPS : " ..CentralFpsDetect.. " " ..CentralTableIFB.CentralFPSbooster_ImprovedLang[LocalPlayer().Central_ImprovedLanguage]["Central_Texte39"].. " " ..string.upper( CentralMap ), Central_FontIFBv, ScrW() * (Central_FpsBoostRetTableV("CentralHUDPosW") / 100),  ScrH() * (Central_FpsBoostRetTableV("CentralHUDPosH") / 100), Central_ColorFPSF, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end
end
hook.Add("HUDPaint","CentralBoosterDrawHud", CentralBoosterDrawHud)

net.Receive("centralboostreset", function()
if !IsValid(LocalPlayer()) then return end
CentralBoostFps = false
chat.AddText(Central_ColorFPSC, "[", Central_NmV.. " Boost Framerate", "] : ", Central_ColorFPSF, CentralTableIFB.CentralFPSbooster_ImprovedLang[LocalPlayer().Central_ImprovedLanguage]["Central_Texte11"] )
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
