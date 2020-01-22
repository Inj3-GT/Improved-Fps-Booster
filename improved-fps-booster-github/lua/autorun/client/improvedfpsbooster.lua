------------- Script by Inj3, prohibited to copy the code
------------- https://steamcommunity.com/id/Inj3/
------------- https://centralcityrp.mtxserv.fr/
------------- https://steamcommunity.com/groups/CentralCityRoleplay

-------------------- FONT
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

-------------------- CONFIGURATION / CHANGE YOU LANGUAGE HERE !
local CentralIncludedMyLanguage = "No" ----- "Yes" for disabled automatic translation (by country), "No" for enabled automatic translation (by country), READ THIS / if you want to change the translation for your community, put "Yes" and change the sentences above. 
local CentralNameOfYourCommunity = "CentralCity" ---- Include the name of your community here (Only availaible on github version)
local Central_Texte1 = "  Close"
local Central_Texte2 = "You have not checked any checkbox in the Options Tab Optimization, Improved Fps Booster cannot load, it disabled automatically."
local Central_Texte3 = "FPS detection :"
local Central_Texte4 = "Be careful this convar 'Shadow Removed' also deactivates the light of your flashlight."
local Central_Texte5 = "Current :"
local Central_Texte6 = "Enable"
local Central_Texte7 = "     Disable"
local Central_Texte9 = "If you encounter graphic problems or crashes, use the Options button to change your settings. For open Improved Fps Booster /boost."
local Central_Texte10 = "For open Improved FPS Booster /boost."
local Central_Texte11 = "You have reset your settings to the default values." 
local Central_Texte12 = "Do you want activate Improved FPS Booster ?"
local Central_Texte13 = "To override the default settings, enable Improved Fps Booster"

-------------------- CONVAR / DO NOT TOUCH THIS !
CreateClientConVar("CentralMultiCoreC",1,true,false)
CreateClientConVar("CentralSkyboxC",1,true,false)
CreateClientConVar("CentralSprayC",1,true,false)
CreateClientConVar("CentralTeethC",1,true,false)
CreateClientConVar("CentralM9KC",1,true,false)
CreateClientConVar("CentralShadowC",0,true,false)
CreateClientConVar("CentralAutresC",1,true,false)
CreateClientConVar("CentralOptiReloadAut",1,true,false)
CreateClientConVar("CentralDrawHudC",0,true,false)
CreateClientConVar("CentralHUDPosW",50,true,false)
CreateClientConVar("CentralHUDPosH",50,true,false)
local CentralMultiCoreC = GetConVar("CentralMultiCoreC")
local CentralSkyboxC = GetConVar("CentralSkyboxC")
local CentralSprayC = GetConVar("CentralSprayC")
local CentralTeethC = GetConVar("CentralTeethC")
local CentralShadowC = GetConVar("CentralShadowC")
local CentralM9KC = GetConVar("CentralM9KC")
local CentralAutresC = GetConVar("CentralAutresC")
local CentralOptiReloadAut = GetConVar("CentralOptiReloadAut")
local CentralDrawHudC = GetConVar("CentralDrawHudC")

-------------------- DO NOT TOUCH THIS !
local CentralMap = game.GetMap()
local CentralBoostFps = false
local CentralTimerVOccur = true
local CentralLoadRefresh = false
local CentralOptionOpen = false
local CentralToutCocher = false
local CentralColorFps = Color( 0,0,0, 255 )
local CentralColorFpsmin = Color( 0,0,0, 255 )
local CentralColorFpsmax = Color( 0,0,0, 255 )
local CentralColorFpsHud = Color(255,255,255, 255 )
local CentralUrlWorkshop = "https://steamcommunity.com/sharedfiles/filedetails/?id=1762151370" 
local CentralFpsGains = 0 
local CentralFpsMax = 0 
local CentralFpsMin = 1000
local CentralFpsDetect = "0"
local CentralFpsDetectHUD = "0"
local CentralTimerFps = 0.6
local CentralOccurTimer = 0
local CentralTimerRefreshV = 5
local CentralOccurFramerate = -CentralTimerFps
local Central_Redimension = 56
local Central_RedimensionActu = 28
local Central_RedimensionActivation = 275

-------------------- DO NOT TOUCH THIS !
local function InitCentralFpsBooster()

if CentralIncludedMyLanguage == "Yes" then return end

local CentralTraductionFpsBoost = {
	["BE"]=true,
	["FR"]=true,
	["DZ"]=true,
	["MA"]=true,
	["CA"]=true,
}

if CentralTraductionFpsBoost[system.GetCountry()] then 
Central_Texte1 = "   Quitter"
Central_Texte2 = "Vous n'avez cochée aucune case dans l'onglet Options Optimization, Improved Fps Booster ne peut démarrer."
Central_Texte3 = "FPS détection :"
Central_Texte4 = "Attention, ce convar 'Shadow Removed' désactive aussi la lumière de votre lampe de poche."
Central_Texte5 = "Actuel : "
Central_Texte6 = "Activer"
Central_Texte7 = "     Désactiver"
Central_Texte9 = "Si vous rencontrez des problèmes graphiques ou crashs, utilisez le button Options pour modifier vos paramètres. Pour ouvrir Improved FPS Booster /boost."
Central_Texte10 = "Pour ouvrir Improved FPS Booster /boost."
Central_Texte11 = "Vous avez réinitialisé vos paramètres par défaut, pour ouvrir Improved FPS Booster /boost." 
Central_Texte12 = "Voulez-vous activer Improved FPS Booster ?"
Central_Texte13 = "Pour remplacer les paramètres par défaut, activer Improved Fps Booster"
Central_Redimension = 53
Central_RedimensionActu = 31
Central_RedimensionActivation = 270
end

end
hook.Add( "Initialize", "InitCentralFpsBooster", InitCentralFpsBooster )


local function CentralFpsBoostPanel()

local CentralPly = LocalPlayer()
if !IsValid(CentralPly) then return end

if CentralOptionOpen == false then

local CentralPanelFpsBoost = vgui.Create( "DFrame" )
local CentralDPanel = vgui.Create( "DPropertySheet", CentralPanelFpsBoost )
local CentralIcon = vgui.Create( "HTML", CentralDPanel )
local CentralQuitterFps = vgui.Create("DButton", CentralIcon )
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

if CentralMultiCoreC:GetInt() == 0 and CentralSkyboxC:GetInt() == 0 and CentralSprayC:GetInt() == 0 and CentralTeethC:GetInt() == 0 and CentralShadowC:GetInt() == 0 and CentralM9KC:GetInt() == 0 and CentralAutresC:GetInt() == 0 then
CentralToutCocher = true
CentralBoostFps = false
chat.AddText(Color( 255, 255, 255 ), "[", "ERROR", "] : ", Color( 255, 0, 0 ), Central_Texte2 )
else
CentralToutCocher = false
end

CentralPanelFpsBoost:ShowCloseButton(false)
CentralPanelFpsBoost:SetDraggable(true)
CentralPanelFpsBoost:MakePopup()
CentralPanelFpsBoost:SetTitle("")
CentralPanelFpsBoost:SetPos(ScrW()/2-160, ScrH()/2-180 )
CentralPanelFpsBoost:SetSize( 0, 0 )
CentralPanelFpsBoost:SizeTo( 300, 270, .5, 0, 10)
function CentralPanelFpsBoost:Init()
	self.startTime = SysTime()
end
CentralPanelFpsBoost.Paint = function( self, w, h )
Derma_DrawBackgroundBlur( self, self.startTime )
draw.RoundedBox( 5, 0, 0, w, h, Color( 0, 69, 175, 255 ) ) 
draw.RoundedBox( 5, 3, 3, w-7, h-7, Color( 255, 255, 255, 255 ) ) 
draw.RoundedBox( 5, 0, 0, w, 32, Color(0,69,165,250))
draw.SimpleText(( Central_Texte12 ),"CentralFpsBoost",Central_RedimensionActivation,3,Color( 255,255,255, 255 ), TEXT_ALIGN_RIGHT)
if CentralBoostFps == true then 
draw.SimpleText(("FPS :" ),"CentralFpsBoost",125,16,Color( 255,255,255, 255 ), TEXT_ALIGN_RIGHT)
draw.SimpleText(("ON (BOOST)" ),"CentralFpsBoost",195,16,Color( 0, 160, 0, 255 ), TEXT_ALIGN_RIGHT)
else
draw.SimpleText(("FPS :" ),"CentralFpsBoost",118,16,Color( 255,255,255, 255 ), TEXT_ALIGN_RIGHT)
draw.SimpleText(("OFF (Disabled)" ),"CentralFpsBoost",201,16,Color( 255, 0,0, 255 ), TEXT_ALIGN_RIGHT)
end
end

CentralDPanel:Dock( FILL )
CentralDPanel:DockPadding( 52, 10, 0, 0)
CentralDPanel.Paint = function (self, w, h)
end
CentralIcon:SetPos(5,0)
CentralIcon:SetSize(300,300)
CentralIcon:SetHTML([[
<img src="https://centralcityrp.mtxserv.fr/centralboost.gif" alt="Img" style="width:300px;height:200px;">
]])
	
CentralQuitterFps:SetPos(203, 6)
CentralQuitterFps:SetSize( 80, 20 )
CentralQuitterFps:SetText( Central_Texte1 )
CentralQuitterFps:SetTextColor( Color( 255, 255, 255 ) )
CentralQuitterFps:SetFont( "CentralFpsBoost" )
CentralQuitterFps:SetImage( "icon16/cross.png" )
function CentralQuitterFps:Paint( w, h )
if CentralQuitterFps:IsHovered() then
draw.RoundedBox( 6, 0, 0, w, h, Color( 255, 0, 0, 255 ) )
else
draw.RoundedBox( 6, 0, 0, w, h, Color( 3, 43, 69, 245 ) )
end
draw.RoundedBox( 6, 2, 2, w-2, h-1, Color( 0, 69, 175, 250 ) )
end
CentralQuitterFps.DoClick = function()
chat.AddText(Color( 255, 0, 0 ), "[", CentralNameOfYourCommunity.. " Boost Framerate", "] : ", Color( 255, 255, 255 ), Central_Texte10 )
CentralPanelFpsBoost:Remove()
end 

CentralResetFps:SetPos( 69, 165 )
CentralResetFps:SetSize( 145, 21 )
CentralResetFps:SetText( "  Reset FPS Max/Min" )
CentralResetFps:SetTextColor( Color( 255, 255, 255 ) )
CentralResetFps:SetImage( "icon16/arrow_refresh.png" )
CentralResetFps:SetFont( "CentralFpsBoost" )
function CentralResetFps:Paint( w, h )
if CentralResetFps:IsHovered() then
draw.RoundedBox( 6, 0, 0, w, h, Color( 255, 0, 0, 255 ) )
else
draw.RoundedBox( 6, 0, 0, w, h, Color( 3, 43, 69, 245 ) )
end
draw.RoundedBox( 6, 2, 2, w-2, h-1, Color( 0, 69, 175, 250 ) )
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
CentralFpsDetection:SetTextColor( Color( 255, 255, 255 ) )
CentralFpsDetection:SetFont( "CentralFpsBoost" )
function CentralFpsDetection:Paint( w, h )
local CentralValTimer = CentralOccurTimer - CurTime()
if CentralValTimer < 0 then
CentralFpsDetect = math.Round(1/RealFrameTime())
CentralOccurTimer = CurTime() + CentralTimerFps
end
if CentralFpsDetect > 20 and CentralFpsDetect <= 60 then
CentralColorFps = Color( 255,165,0, 255 )
elseif CentralFpsDetect > 60 then 
CentralColorFps = Color( 0,160,0, 255 )
elseif CentralFpsDetect <= 20 then
CentralColorFps = Color( 255,0,0, 255 )
end
if CentralFpsMin > 40 then
CentralColorFpsmin = Color( 0,175,0, 255 )
else
CentralColorFpsmin = Color( 255,0,0, 255 )
end
if CentralFpsMax > 40 then
CentralColorFpsmax = Color( 0,175,0, 255 )
else
CentralColorFpsmax = Color( 255,0,0, 255 )
end
if CentralFpsDetect < CentralFpsMin then CentralFpsMin = CentralFpsDetect  end
if CentralBoostFps == false then 
if CentralFpsDetect > CentralFpsMax then CentralFpsMax = CentralFpsDetect  end
else
if CentralFpsDetect > CentralFpsGains then CentralFpsGains = CentralFpsDetect end
end
if CentralFpsMin == 0 then 
CentralFpsMin = 1000
end
local calculfps = CentralFpsGains - CentralFpsMax
local CentralGainCalcul = "Gains : "
local CentralCalculReSize = 50
if calculfps <= 0 then calculfps = 0 else CentralLoadRefresh = false end
if calculfps == 0 and CentralBoostFps == true and CentralLoadRefresh != true then 
CentralGainCalcul = "" 
CentralCalculReSize = 5 
calculfps = "Refreshing.." 
if CentralTimerVOccur then
CentralTimerVOccur = false
timer.Simple( CentralTimerRefreshV, function() CentralLoadRefresh = true calculfps = 0 CentralTimerVOccur = true end )
end
end
draw.SimpleText(( Central_Texte3 ),"CentralFpsBoost",83,1,Color( 0,0,0, 255 ), TEXT_ALIGN_RIGHT)
draw.SimpleText(( Central_Texte5 ), "CentralFpsBoost",Central_RedimensionActu,15,Color( 0,0,0, 255 ), TEXT_ALIGN_CENTER)
draw.SimpleText(( CentralFpsDetect ), "CentralFpsBoostV", Central_Redimension,14,CentralColorFps, TEXT_ALIGN_LEFT)
draw.SimpleText(("Min : " ), "CentralFpsBoost",32,43,Color( 0,0,0, 255 ), TEXT_ALIGN_CENTER)
draw.SimpleText(( CentralFpsMin ), "CentralFpsBoostV",48,42,CentralColorFpsmin, TEXT_ALIGN_LEFT)
draw.SimpleText(("Max : "), "CentralFpsBoost",30,29,Color( 0,0,0, 255 ), TEXT_ALIGN_CENTER)
draw.SimpleText(( CentralGainCalcul ), "CentralFpsBoost",31,57,Color( 0,0,0, 255 ), TEXT_ALIGN_CENTER)
if CentralBoostFps == true then 
draw.SimpleText(( CentralFpsGains ), "CentralFpsBoostV",48,28,CentralColorFpsmax, TEXT_ALIGN_LEFT)
draw.SimpleText(( calculfps ), "CentralFpsBoostV",CentralCalculReSize,56, Color( 0,175,0, 255 ), TEXT_ALIGN_LEFT)
else
draw.SimpleText(( CentralFpsMax ), "CentralFpsBoostV",48,28,CentralColorFpsmax, TEXT_ALIGN_LEFT)
draw.SimpleText(( "OFF" ), "CentralFpsBoost",50,57,Color( 255,0,0, 255 ), TEXT_ALIGN_LEFT)
end
end
CentralFpsDetection.DoClick = function()
gui.OpenURL( CentralUrlWorkshop )
end 

CentralActiver:SetText( Central_Texte6 )
CentralActiver:SetImage( "icon16/tick.png" )	
CentralActiver:SetTextColor( Color( 255, 255, 255 ) )
CentralActiver:SetFont( "CentralFpsBoost" )
CentralActiver:SetPos( 8, 233 )
CentralActiver:SetSize( 110, 30 )
CentralActiver.Paint = function( self, w, h )	
local CentralColorFlash = math.abs(math.sin(CurTime() * 3) * 255)
local CentralVert = Color(0, CentralColorFlash, 0)
if CentralBoostFps == true then
CentralVert = Color(0, 175, 0, 255)
end		
draw.RoundedBox( 6, 0, 0, w, h, CentralVert )
draw.RoundedBox( 6, 2, 2, w-1, h-1, Color( 0, 69, 175, 250 ) )
end
CentralActiver.DoClick = function() 
if CentralToutCocher == true then
chat.AddText(Color( 255, 255, 255 ), "[", "ERROR", "] : ", Color( 255, 0, 0 ), Central_Texte2 )
CentralBoostFps = false
return
end
chat.AddText(Color( 255, 0, 0 ), "[", CentralNameOfYourCommunity.. " Boost Framerate", "] : ", Color( 255, 255, 255 ), Central_Texte9 )
if CentralBoostFps == false then 
CentralFpsMin = 1000
else 
CentralPanelFpsBoost:Remove() 
return 
end
CentralBoostFps = true
if CentralAutresC:GetInt() == 1 then
CentralPly:ConCommand("r_threaded_particles 1")
CentralPly:ConCommand("r_threaded_renderables 1")
CentralPly:ConCommand("r_queued_ropes 1")
CentralPly:ConCommand("cl_threaded_client_leaf_system 1")
end
if CentralMultiCoreC:GetInt() == 1 then
CentralPly:ConCommand("gmod_mcore_test 1")
CentralPly:ConCommand("mat_queue_mode -1")
CentralPly:ConCommand("cl_threaded_bone_setup 1")
end
if CentralSkyboxC:GetInt() == 1 then
CentralPly:ConCommand("r_3dsky 0")
end
if CentralSprayC:GetInt() == 1 then
CentralPly:ConCommand("cl_playerspraydisable 1")
end
if CentralTeethC:GetInt() == 1 then
CentralPly:ConCommand("r_teeth 0")
end
if CentralShadowC:GetInt() == 1 then
CentralPly:ConCommand("r_shadows 0")
end
if CentralM9KC:GetInt() == 1 then
CentralPly:ConCommand("M9KGasEffect 0")
end
CentralPanelFpsBoost:Remove()
end
		
CentralDesactiver:SetImage( "icon16/cross.png" )		
CentralDesactiver:SetText( Central_Texte7 )
CentralDesactiver:SetTextColor( Color( 255, 255, 255 ) )
CentralDesactiver:SetFont( "CentralFpsBoost" )
CentralDesactiver:SetPos( 181, 233 )
CentralDesactiver:SetSize( 110, 30 )
CentralDesactiver.Paint = function( self, w, h )
local CentralColorFlash = math.abs(math.sin(CurTime() * 3) * 255)
local CentralRouge = Color(CentralColorFlash, 0, 0)
if CentralBoostFps == false then
CentralRouge = Color(255, 0, 0, 255)
end
draw.RoundedBox( 6, 0, 0, w, h, CentralRouge )
draw.RoundedBox( 6, 2, 2, w-2, h-1, Color( 0, 69, 175, 250 ) )
end
CentralDesactiver.DoClick = function()
chat.AddText(Color( 255, 0, 0 ), "[", CentralNameOfYourCommunity.. " Boost Framerate", "] : ", Color( 255, 255, 255 ), Central_Texte11 )
if CentralBoostFps == true then
CentralFpsMin = 1000
CentralFpsMax = 1
CentralFpsGains = 1
end
CentralBoostFps = false
CentralPly:ConCommand("cl_threaded_bone_setup 0")
CentralPly:ConCommand("r_threaded_particles 0")
CentralPly:ConCommand("r_threaded_renderables 0")
CentralPly:ConCommand("cl_threaded_client_leaf_system 0")
CentralPly:ConCommand("gmod_mcore_test 0")
CentralPly:ConCommand("mat_queue_mode 0")
CentralPly:ConCommand("r_queued_ropes 0")
CentralPly:ConCommand("r_3dsky 1")
CentralPly:ConCommand("cl_playerspraydisable 0")
CentralPly:ConCommand("r_teeth 1")
CentralPly:ConCommand("r_shadows 1")
CentralPly:ConCommand("M9KGasEffect 1")
CentralPanelFpsBoost:Remove()
end

CentralOptions:SetImage( "icon16/bullet_wrench.png" )		
CentralOptions:SetText( "  Options" )
CentralOptions:SetTextColor( Color( 255, 255, 255 ) )
CentralOptions:SetFont( "CentralFpsBoost" )
CentralOptions:SetPos(110, 58)
CentralOptions:SetSize( 85, 19 )
CentralOptions.Paint = function( self, w, h )
if CentralOptions:IsHovered() then
draw.RoundedBox( 6, 0, 0, w, h, Color( 255, 0, 0, 255 ) )
else
draw.RoundedBox( 6, 0, 0, w, h, Color( 3, 43, 69, 245 ) )
end
draw.RoundedBox( 6, 2, 2, w-2, h-1, Color( 0, 69, 175, 245 ) )
end
CentralOptions.DoClick = function()
surface.PlaySound( "buttons/combine_button7.wav" )
CentralOptionOpen = true
CentralPanelFpsBoost:Remove()
CentralFpsBoostPanel()
end

else

local CentralOptionsBoost = vgui.Create( "DFrame" )
local CentralMultiCore = vgui.Create( "DCheckBoxLabel", CentralOptionsBoost)
local CentralSkybox = vgui.Create( "DCheckBoxLabel", CentralOptionsBoost)
local CentralSpray = vgui.Create( "DCheckBoxLabel", CentralOptionsBoost)
local CentralDent = vgui.Create( "DCheckBoxLabel", CentralOptionsBoost)
local CentralAutres = vgui.Create( "DCheckBoxLabel", CentralOptionsBoost)
local CentralM9kEffect = vgui.Create( "DCheckBoxLabel", CentralOptionsBoost)
local CentralShadow = vgui.Create( "DCheckBoxLabel", CentralOptionsBoost)
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
CentralOptionsBoost:SizeTo( 280, 360, .5, 0, 10)
CentralOptionsBoost.Paint = function( self, w, h )
draw.RoundedBox( 6, 0, 0, w, h, Color( 0, 69, 175, 255 ) ) 
draw.RoundedBox( 6, 3, 3, w-7, h-7, Color( 255, 255, 255, 250 ) ) 
draw.RoundedBox( 6, 0, 0, w-132, 25, Color(0,69,165,250))
draw.SimpleText(( "[Options]" ),"CentralFpsBoost",78,5,Color( 255,255,255, 255 ), TEXT_ALIGN_RIGHT)
draw.SimpleText(( "Improved Fps Booster version 1.2 / by Inj3" ),"CentralFpsBoost",273,342,Color(255,0,0, 255 ), TEXT_ALIGN_RIGHT)
draw.SimpleText(( "Ping detection : " ..CentralPly:Ping()),"CentralFpsBoost",137,327,Color(0, 69, 175, 255 ), TEXT_ALIGN_CENTER)
draw.SimpleText(( "Optimization :" ),"CentralFpsBoost",180,61,Color( 0, 69, 175, 255), TEXT_ALIGN_RIGHT)
draw.SimpleText(( "Configuration :" ),"CentralFpsBoost",183,185,Color( 0, 69, 175, 255 ), TEXT_ALIGN_RIGHT)
draw.SimpleText(( "Pos W :" ),"CentralFpsBoost",157,252,Color( 0,0,0, 255 ), TEXT_ALIGN_RIGHT)
draw.SimpleText(( "Pos H :" ),"CentralFpsBoost",154,285,Color( 0,0,0, 255 ), TEXT_ALIGN_RIGHT)
surface.SetDrawColor( Color( 0, 0, 0, 150 ) )
surface.DrawOutlinedRect( 5, 224, 269, 98 )
end
		  
CentralMultiCore:SetPos( 8, 80 )	
CentralMultiCore:SetConVar( "CentralMultiCoreC" )
CentralMultiCore:SetFont( "CentralFpsBoost" )
CentralMultiCore:SetText( "Multicore Rendering" )		
CentralMultiCore:SetTooltip( "Take advantage of a Multi Core CPU" )
CentralMultiCore:SetValue(CentralMultiCoreC:GetBool())
CentralMultiCore:SetTextColor( Color( 0,0, 0, 250 ) )
CentralMultiCore:SizeToContents()	

CentralSkybox:SetPos( 150, 80 )	
CentralSkybox:SetConVar( "CentralSkyboxC" )
CentralSkybox:SetFont( "CentralFpsBoost" )
CentralSkybox:SetText( "Skybox Removed" )	
CentralSkybox:SetTooltip( "Remove the sky" )	
CentralSkybox:SetValue(CentralSkyboxC:GetBool())
CentralSkybox:SetTextColor( Color( 0,0, 0, 250 ) )
CentralSkybox:SizeToContents()	

CentralSpray:SetPos( 8, 105 )	
CentralSpray:SetConVar( "CentralSprayC" )
CentralSpray:SetFont( "CentralFpsBoost" )
CentralSpray:SetText( "Spray Removed" )		
CentralSpray:SetTooltip( "Remove the spray" )	
CentralSpray:SetValue(CentralSprayC:GetBool())
CentralSpray:SetTextColor( Color( 0,0, 0, 250 ) )
CentralSpray:SizeToContents()		

CentralDent:SetPos( 150, 105 )	
CentralDent:SetConVar( "CentralTeethC" )
CentralDent:SetFont( "CentralFpsBoost" )
CentralDent:SetText( "Teeth Removed" )		
CentralDent:SetTooltip( "Remove teeth on playermodel" )	
CentralDent:SetValue(CentralTeethC:GetBool())
CentralDent:SetTextColor( Color( 0,0, 0, 250 ) )
CentralDent:SizeToContents()	

CentralM9kEffect:SetPos( 8, 130 )	
CentralM9kEffect:SetConVar( "CentralM9KC" )
CentralM9kEffect:SetFont( "CentralFpsBoost" )
CentralM9kEffect:SetText( "M9k Effect Removed" )
CentralM9kEffect:SetTooltip( "Remove particle effect on M9K" )			
CentralM9kEffect:SetValue(CentralM9KC:GetBool())
CentralM9kEffect:SetTextColor( Color( 0,0, 0, 250 ) )
CentralM9kEffect:SizeToContents()

CentralShadow:SetPos( 150, 130 )	
CentralShadow:SetConVar( "CentralShadowC" )
CentralShadow:SetFont( "CentralFpsBoost" )
CentralShadow:SetText( "Shadow  Removed" )		
CentralShadow:SetTooltip( "Removes shadows on entities, and removes light from your flashlight" )
CentralShadow:SetValue(CentralShadowC:GetBool())
CentralShadow:SetTextColor( Color( 0,0, 0, 250 ) )
CentralShadow:SizeToContents()
function CentralShadow:OnChange( val )
local CentralValTimer = CentralOccurTimer - CurTime()
if CentralValTimer < 0 and val then
chat.AddText(Color( 0, 250, 0 ), "[", "Shadow Removed", "] : ", Color( 255, 0, 0 ), Central_Texte4 )
CentralOccurTimer = CurTime() + CentralTimerFps
end
end
	 
CentralAutres:SetPos( 60,154 )	
CentralAutres:SetConVar( "CentralAutresC" )
CentralAutres:SetFont( "CentralFpsBoost" )
CentralAutres:SetText( "Other Command Disable" )		
CentralAutres:SetValue(CentralAutresC:GetBool())
CentralAutres:SetTooltip( "r_threaded_particles, r_threaded_renderables, r_queued_ropes, cl_threaded_client_leaf_system" )
CentralAutres:SetTextColor( Color( 0,0, 0, 250 ) )
CentralAutres:SizeToContents()		

CentralFermerEtQuitter:SetPos( 13,204 )	
CentralFermerEtQuitter:SetConVar( "CentralOptiReloadAut" )
CentralFermerEtQuitter:SetFont( "CentralFpsBoost" )
CentralFermerEtQuitter:SetText( "Auto-enable Booster after Close & Reload" )		
CentralFermerEtQuitter:SetValue(CentralOptiReloadAut:GetBool())
CentralFermerEtQuitter:SetTooltip( "If Improved Fps Booster is Off Disabled, this checkbox will be used to start it automatically after had Closed & Reload" )
CentralFermerEtQuitter:SetTextColor( Color( 0,0, 0, 250 ) )
CentralFermerEtQuitter:SizeToContents()	

CentralHudDraw:SetPos( 40,230 )	
CentralHudDraw:SetConVar( "CentralDrawHudC" )
CentralHudDraw:SetFont( "CentralFpsBoost" )
CentralHudDraw:SetText( "Show Framerate on your HUD" )		
CentralHudDraw:SetValue(CentralDrawHudC:GetBool())
CentralHudDraw:SetTooltip( "Display FPS" )
CentralHudDraw:SetTextColor( Color( 0,0, 0, 250 ) )
CentralHudDraw:SizeToContents()	

CentralPosW:SetPos( -194, 262 )
CentralPosW:SetSize( 485, 20 )	
CentralPosW:SetText( "" )	
CentralPosW:SetMin( 0 )	
CentralPosW:SetMax( ScrW() - 198 )	
CentralPosW:SetDecimals( 0 )
CentralPosW:SetConVar( "CentralHUDPosW" ) 

CentralPosH:SetPos( -195, 295 )
CentralPosH:SetSize( 485, 20 )	
CentralPosH:SetText( "" )	
CentralPosH:SetMin( 0 )	
CentralPosH:SetMax( ScrH() - 15 )	
CentralPosH:SetDecimals( 0 )
CentralPosH:SetConVar( "CentralHUDPosH" ) 
	
CentralQuitterOptions:SetPos( 151, 5 )
CentralQuitterOptions:SetSize( 122, 18 )
CentralQuitterOptions:SetFont( "CentralFpsBoost" )
CentralQuitterOptions:SetText( "   Close & Reload" ) 
CentralQuitterOptions:SetImage( "icon16/cross.png" )
CentralQuitterOptions:SetTextColor( Color( 255,255, 255, 255 )  )
function CentralQuitterOptions:Paint( w, h )
if CentralQuitterOptions:IsHovered() then
draw.RoundedBox( 6, 0, 0, w, h, Color( 255, 0, 0, 255 ) )
else
draw.RoundedBox( 6, 0, 0, w, h, Color( 3, 43, 69, 245 ) )
end
draw.RoundedBox( 6, 2, 2, w-2, h-1, Color( 0, 69, 175, 250 ) )
end
CentralQuitterOptions.DoClick = function()
if CentralOptiReloadAut:GetInt() == 1 then
CentralBoostFps = true
end
if CentralBoostFps == true then
if CentralMultiCoreC:GetInt() == 1 then
CentralPly:ConCommand("gmod_mcore_test 1")
CentralPly:ConCommand("mat_queue_mode -1")
CentralPly:ConCommand("cl_threaded_bone_setup 1")
else
CentralPly:ConCommand("gmod_mcore_test 0")
CentralPly:ConCommand("mat_queue_mode 0")
CentralPly:ConCommand("cl_threaded_bone_setup 0")
end
if CentralSkyboxC:GetInt() == 1 then
CentralPly:ConCommand("r_3dsky 0")
else
CentralPly:ConCommand("r_3dsky 1")
end
if CentralSprayC:GetInt() == 1 then
CentralPly:ConCommand("cl_playerspraydisable 1")
else
CentralPly:ConCommand("cl_playerspraydisable 0")
end
if CentralTeethC:GetInt() == 1 then
CentralPly:ConCommand("r_teeth 0")
else
CentralPly:ConCommand("r_teeth 1")
end
if CentralShadowC:GetInt() == 1 then
CentralPly:ConCommand("r_shadows 0")
else
CentralPly:ConCommand("r_shadows 1")
end
if CentralM9KC:GetInt() == 1 then
CentralPly:ConCommand("M9KGasEffect 0")
else
CentralPly:ConCommand("M9KGasEffect 1")
end
if CentralAutresC:GetInt() == 1 then
CentralPly:ConCommand("r_threaded_particles 1")
CentralPly:ConCommand("r_threaded_renderables 1")
CentralPly:ConCommand("r_queued_ropes 1")
CentralPly:ConCommand("cl_threaded_client_leaf_system 1")
else
CentralPly:ConCommand("r_threaded_particles 0")
CentralPly:ConCommand("r_threaded_renderables 0")
CentralPly:ConCommand("r_queued_ropes 0")
CentralPly:ConCommand("cl_threaded_client_leaf_system 0")
end
timer.Simple(0.1, function()
if CentralToutCocher == false then
chat.AddText(Color( 255, 0, 0 ), "[", CentralNameOfYourCommunity.. " Boost Framerate", "] : ", Color( 255, 255, 255 ), "Options settings Loaded" )
else
chat.AddText(Color( 255, 0, 0 ), "[", CentralNameOfYourCommunity.. " Boost Framerate", "] : ", Color( 255, 255, 255 ), Central_Texte13 )
end
end)
end
CentralOptionOpen = false
CentralFpsGains = 1
CentralOptionsBoost:Remove()
CentralFpsBoostPanel()
end

CentralToutCocherOptions:SetImage( "icon16/bullet_wrench.png" )		
CentralToutCocherOptions:SetText( "  Check All/Uncheck All" )
CentralToutCocherOptions:SetTextColor( Color( 255, 255, 255 ) )
CentralToutCocherOptions:SetFont( "CentralFpsBoost" )
CentralToutCocherOptions:SetPos(64, 36)
CentralToutCocherOptions:SetSize( 155, 19 )
CentralToutCocherOptions.Paint = function( self, w, h )
if CentralToutCocherOptions:IsHovered() then
draw.RoundedBox( 6, 0, 0, w, h, Color( 255, 0, 0, 255 ) )
else
draw.RoundedBox( 6, 0, 0, w, h, Color( 3, 43, 69, 245 ) )
end
draw.RoundedBox( 6, 2, 2, w-2, h-1, Color( 0, 69, 175, 250 ) )
end
CentralToutCocherOptions.DoClick = function()
if CentralToutCocher == true then
CentralM9kEffect:SetValue(1)
CentralAutres:SetValue(1)
CentralShadow:SetValue(1)
CentralDent:SetValue(1)
CentralSpray:SetValue(1)
CentralSkybox:SetValue(1)
CentralMultiCore:SetValue(1)
CentralToutCocher = false
else
CentralM9kEffect:SetValue(0)
CentralAutres:SetValue(0)
CentralShadow:SetValue(0)
CentralDent:SetValue(0)
CentralSpray:SetValue(0)
CentralSkybox:SetValue(0)
CentralMultiCore:SetValue(0)
CentralToutCocher = true
end 
surface.PlaySound( "buttons/button9.wav" )
end
end

end
net.Receive("CentralBoost", CentralFpsBoostPanel)
	
local function CentralBoosterDrawHud()
if CentralDrawHudC:GetInt() == 1 then
local CentralTimerR = CurTime() - CentralOccurFramerate
if CentralTimerR > CentralTimerFps then
CentralFpsDetectHUD = math.Round(1/RealFrameTime())
CentralOccurFramerate = CurTime()
end
draw.SimpleText("FPS : " ..CentralFpsDetectHUD.. " on map " ..string.upper( CentralMap ), "CentralFpsBoostV", ScrW() - GetConVar("CentralHUDPosW"):GetInt(),  ScrH() - 15 - GetConVar("CentralHUDPosH"):GetInt(), CentralColorFpsHud, TEXT_ALIGN_RIGHT, TEXT_ALIGN_RIGHT)
end
end
hook.Add("HUDPaint","CentralBoosterDrawHud", CentralBoosterDrawHud)

net.Receive("CentralReset", function()
if !IsValid(LocalPlayer()) then return end
CentralBoostFps = false
chat.AddText(Color( 255, 0, 0 ), "[", CentralNameOfYourCommunity.. " Boost Framerate", "] : ", Color( 255, 255, 255 ), Central_Texte11 )
LocalPlayer():ConCommand("cl_threaded_bone_setup 0")
LocalPlayer():ConCommand("r_threaded_particles 0")
LocalPlayer():ConCommand("r_threaded_renderables 0")
LocalPlayer():ConCommand("cl_threaded_client_leaf_system 0")
LocalPlayer():ConCommand("gmod_mcore_test 0")
LocalPlayer():ConCommand("mat_queue_mode 0")
LocalPlayer():ConCommand("r_queued_ropes 0")
LocalPlayer():ConCommand("r_3dsky 1")
LocalPlayer():ConCommand("cl_playerspraydisable 0")
LocalPlayer():ConCommand("r_teeth 1")
LocalPlayer():ConCommand("r_shadows 1")
LocalPlayer():ConCommand("M9KGasEffect 1")		
end)

hook.Add("OnEntityCreated","WidgetInit",function(ent) --- Facepunch
if ent:IsWidget() then
hook.Add( "PlayerTick", "TickWidgets", function( pl, mv ) widgets.PlayerTick( pl, mv ) end ) 
hook.Remove("OnEntityCreated","WidgetInit")
end
end)
