------------- Script by Inj3, prohibited to copy the code
-- *The configuration part on this file doesn't exist anymore, i deleted it for recoded all, now is automatic for the language (You can include anyway your own language in this file 'lang_improvedfpsbooter.lua').
-- If you have a language to add or a suggestion contact me on my steam.
-- If you want to support me, come and check out "Centralcity RP" server.
------------- https://steamcommunity.com/id/Inj3/
------------- https://centralcityrp.mtxserv.fr/
------------- https://steamcommunity.com/groups/CentralCityRoleplay

-------------------- Include Font
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
CreateClientConVar("CentralImprovedLanguageCV","",true,false)
local Central_NmV, Central_ImprovedLanguage, CentralGainCalcul, CentralCalculFPS, CentralCalculReSize, CentralIndexTableImprFPS
local CentralBoostFps, CentralTimerVOccur, CentralLoadRefresh, CentralOptionOpen, CentralToutCocher, CentralMap = false, true, false, false, false, game.GetMap()
local CentralColorFps, CentralColorFpsmin, CentralColorFpsmax = Color( 0,0,0, 255 ), Color( 0,0,0, 255 ), Color( 0,0,0, 255 ) --- Dynamic Value
local CentralMultiCoreC, CentralSkyboxC, CentralSprayC, CentralTeethC, CentralShadowC, CentralM9KC, CentralAutresC, CentralOptiReloadAut, CentralDrawHudC, CentralLangueSys = GetConVar("CentralMultiCoreC"), GetConVar("CentralSkyboxC"), GetConVar("CentralSprayC"), GetConVar("CentralTeethC"), GetConVar("CentralShadowC"), GetConVar("CentralM9KC"), GetConVar("CentralAutresC"), GetConVar("CentralOptiReloadAut"), GetConVar("CentralDrawHudC"), GetConVar("CentralImprovedLanguageCV")
local CentralFpsGains, CentralFpsMax, CentralFpsMin, CentralFpsDetect = 0, 0, 1000, 0
local CentralTimerFps, CentralTimerRefreshV, CentralOccurFramerate, CentralOccurCountFps = 1, 5, 1, 0
local Central_ColorFPSA, Central_ColorFPSB, Central_ColorFPSC, Central_ColorFPSD, Central_ColorFPSE, Central_ColorFPSF, Central_ColorFPSG, Central_ColorFPSH = Color( 255,165,0, 255 ), Color( 0,160,0, 255 ), Color( 255,0,0, 255 ), Color( 0,175,0, 255 ), Color( 0, 69, 175, 250 ), Color( 255, 255, 255, 255 ), Color( 0,0, 0, 250 ), Color( 3, 43, 69, 245 )

local function InitCentralFpsBooster(CentralPly)	

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
Central_NmV = "\67\101\110\116\114\97\108\67\105\116\121" -- Don't removed this or it's break :D

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
CentralCalculReSize = 50
if CentralCalculFPS <= 0 then CentralCalculFPS = 0 else CentralLoadRefresh = false end
if CentralCalculFPS == 0 and CentralBoostFps == true and CentralLoadRefresh != true then 
CentralGainCalcul = "" 
CentralCalculReSize = 5 
CentralCalculFPS = "Refreshing.." 
if CentralTimerVOccur then
CentralTimerVOccur = false
timer.Simple( CentralTimerRefreshV, function() CentralLoadRefresh = true CentralCalculFPS = 0 CentralTimerVOccur = true end )
end
end

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

end

local function CentralFpsBoostPanel()

local CentralPly = LocalPlayer()
if !IsValid(CentralPly) then return end

if CentralLangueSys:GetString() != "" then
CentralPly.Central_ImprovedLanguage = CentralLangueSys:GetString()
elseif CentralLangueSys:GetString() == "" and (CentralIndexTableImprFPS == nil) then
CentralIndexTableImprFPS = true
InitCentralFpsBooster(CentralPly) --- By default if the client has not defined a language / the tracking system takes over
end

if CentralOptionOpen == false then

local CentralPanelFpsBoost = vgui.Create( "DFrame" )
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

if CentralMultiCoreC:GetInt() == 0 and CentralSkyboxC:GetInt() == 0 and CentralSprayC:GetInt() == 0 and CentralTeethC:GetInt() == 0 and CentralShadowC:GetInt() == 0 and CentralM9KC:GetInt() == 0 and CentralAutresC:GetInt() == 0 then
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
<img src="https://centralcityrp.mtxserv.fr/centralboost.gif" alt="Img" style="width:300px;height:200px;">
]]) --- HTML is good to avoid adding material for your players to download.


CentralLangue:SetPos( 7, 36 )
CentralLangue:SetSize( 105, 18 )
CentralLangue:SetFont( "CentralFpsBoost" )
if CentralLangueSys:GetString() == "" then
CentralLangue:SetValue( CentralTable.LangImprovedFpsBooster[CentralPly.Central_ImprovedLanguage]["Central_Texte38"] )
else
CentralLangue:SetValue( CentralTable.LangImprovedFpsBooster[CentralPly.Central_ImprovedLanguage]["Central_Texte38"].. " : " ..CentralPly.Central_ImprovedLanguage )
end
for lang, _ in pairs(CentralTable.LangImprovedFpsBooster) do 
CentralLangue:AddChoice( lang )
end
CentralLangue.OnSelect = function( self, index, value )
if !IsValid(self) then return end
CentralPly.Central_ImprovedLanguage = value
CentralLangue:SetValue( CentralTable.LangImprovedFpsBooster[CentralPly.Central_ImprovedLanguage]["Central_Texte38"].. " : " ..CentralPly.Central_ImprovedLanguage )
CentralLangueSys:SetString( value ) 
end
	
CentralQuitterFps:SetPos(213, 35)
CentralQuitterFps:SetSize( 80, 20 )
CentralQuitterFps:SetText( "" )
CentralQuitterFps:SetTextColor( Central_ColorFPSF )
CentralQuitterFps:SetFont( "CentralFpsBoost" )
CentralQuitterFps:SetImage( "icon16/cross.png" )
function CentralQuitterFps:Paint( w, h )
if CentralQuitterFps:IsHovered() then
draw.RoundedBox( 6, 0, 0, w, h, Central_ColorFPSC )
else
draw.RoundedBox( 6, 0, 0, w, h, Central_ColorFPSH )
end
draw.RoundedBox( 6, 2, 2, w-2, h-1, Central_ColorFPSE )
draw.DrawText( CentralTable.LangImprovedFpsBooster[CentralPly.Central_ImprovedLanguage]["Central_Texte1"], "CentralFpsBoost", w/2,3, Central_ColorFPSF, TEXT_ALIGN_CENTER )
end
CentralQuitterFps.DoClick = function()
chat.AddText(Central_ColorFPSC, "[", Central_NmV.. " Boost Framerate", "] : ", Central_ColorFPSF, CentralTable.LangImprovedFpsBooster[CentralPly.Central_ImprovedLanguage]["Central_Texte10"] )
CentralPanelFpsBoost:Remove()
end 

CentralResetFps:SetPos( 69, 165 )
CentralResetFps:SetSize( 145, 21 )
CentralResetFps:SetText( "  Reset FPS Max/Min" )
CentralResetFps:SetTextColor( Central_ColorFPSF )
CentralResetFps:SetImage( "icon16/arrow_refresh.png" )
CentralResetFps:SetFont( "CentralFpsBoost" )
function CentralResetFps:Paint( w, h )
if CentralResetFps:IsHovered() then
draw.RoundedBox( 6, 0, 0, w, h, Central_ColorFPSC )
else
draw.RoundedBox( 6, 0, 0, w, h, Central_ColorFPSH )
end
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
draw.SimpleText(( CentralCalculFPS ), "CentralFpsBoostV",CentralCalculReSize,56, Central_ColorFPSD, TEXT_ALIGN_LEFT)
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
CentralPanelFpsBoost:Remove() 
return 
end
CentralBoostFps = true
if CentralAutresC:GetInt() == 1 then
CentralPly:ConCommand("r_threaded_particles 1")
CentralPly:ConCommand("r_threaded_renderables 1")
CentralPly:ConCommand("r_queued_ropes 1")
CentralPly:ConCommand("cl_threaded_client_leaf_system 1")
CentralPly:ConCommand("r_threaded_client_shadow_manager 1")				
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
CentralPanelFpsBoost:Remove()
end

CentralOptions:SetImage( "icon16/bullet_wrench.png" )		
CentralOptions:SetText( "  Options" )
CentralOptions:SetTextColor( Central_ColorFPSF )
CentralOptions:SetFont( "CentralFpsBoost" )
CentralOptions:SetPos(110, 58)
CentralOptions:SetSize( 86, 19 )
CentralOptions.Paint = function( self, w, h )
if CentralOptions:IsHovered() then
draw.RoundedBox( 6, 0, 0, w, h, Central_ColorFPSC )
else
draw.RoundedBox( 6, 0, 0, w, h, Central_ColorFPSH )
end
draw.RoundedBox( 6, 2, 2, w-2, h-1, Central_ColorFPSE )
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
draw.RoundedBox( 6, 0, 0, w, h, Central_ColorFPSE ) 
draw.RoundedBox( 6, 3, 3, w-7, h-7, Central_ColorFPSF ) 
draw.RoundedBox( 6, 0, 0, w-132, 25, Central_ColorFPSE)
draw.SimpleText(( "[Options]" ),"CentralFpsBoost",78,5,Central_ColorFPSF, TEXT_ALIGN_RIGHT)
draw.SimpleText(( "\73\109\112\114\111\118\101\100\32\70\112\115\32\66\111\111\115\116\101\114\32\118\101\114\115\105\111\110\32\50\46\48\32\47\32\73\110\106\51" ),"CentralFpsBoost",273,342,Central_ColorFPSC, TEXT_ALIGN_RIGHT)
draw.SimpleText(( "Ping detection : " ..CentralPly:Ping()),"CentralFpsBoost",w/2 -1,327,Central_ColorFPSE, TEXT_ALIGN_CENTER) -- if the ping value is equal to a 1 it's a spoofing.
draw.SimpleText(( CentralTable.LangImprovedFpsBooster[CentralPly.Central_ImprovedLanguage]["Central_Texte15"].. " :" ),"CentralFpsBoost",w/2 ,61,Central_ColorFPSE, TEXT_ALIGN_CENTER)
draw.SimpleText(( "Configuration :" ),"CentralFpsBoost",w/2,185,Central_ColorFPSE, TEXT_ALIGN_CENTER)
draw.SimpleText(( CentralTable.LangImprovedFpsBooster[CentralPly.Central_ImprovedLanguage]["Central_Texte33"] ),"CentralFpsBoost",w/2,249,Central_ColorFPSG, TEXT_ALIGN_CENTER)
draw.SimpleText(( CentralTable.LangImprovedFpsBooster[CentralPly.Central_ImprovedLanguage]["Central_Texte34"] ),"CentralFpsBoost",w/2,283,Central_ColorFPSG, TEXT_ALIGN_CENTER)
surface.SetDrawColor( Central_ColorFPSC )
surface.DrawOutlinedRect( 5, 224, 269, 98 )
end
		  
CentralMultiCore:SetPos( 8, 80 )	
CentralMultiCore:SetConVar( "CentralMultiCoreC" )
CentralMultiCore:SetFont( "CentralFpsBoost" )
CentralMultiCore:SetText( CentralTable.LangImprovedFpsBooster[CentralPly.Central_ImprovedLanguage]["Central_Texte17"] )		
CentralMultiCore:SetTooltip( CentralTable.LangImprovedFpsBooster[CentralPly.Central_ImprovedLanguage]["Central_Texte16"] )
CentralMultiCore:SetValue(CentralMultiCoreC:GetBool())
CentralMultiCore:SetTextColor( Central_ColorFPSG )
CentralMultiCore:SizeToContents()	

CentralSkybox:SetPos( 150, 80 )	
CentralSkybox:SetConVar( "CentralSkyboxC" )
CentralSkybox:SetFont( "CentralFpsBoost" )
CentralSkybox:SetText( CentralTable.LangImprovedFpsBooster[CentralPly.Central_ImprovedLanguage]["Central_Texte18"] )	
CentralSkybox:SetTooltip( CentralTable.LangImprovedFpsBooster[CentralPly.Central_ImprovedLanguage]["Central_Texte19"] )	
CentralSkybox:SetValue(CentralSkyboxC:GetBool())
CentralSkybox:SetTextColor( Central_ColorFPSG )
CentralSkybox:SizeToContents()	

CentralSpray:SetPos( 8, 105 )	
CentralSpray:SetConVar( "CentralSprayC" )
CentralSpray:SetFont( "CentralFpsBoost" )
CentralSpray:SetText( CentralTable.LangImprovedFpsBooster[CentralPly.Central_ImprovedLanguage]["Central_Texte20"] )		
CentralSpray:SetTooltip( CentralTable.LangImprovedFpsBooster[CentralPly.Central_ImprovedLanguage]["Central_Texte21"] )	
CentralSpray:SetValue(CentralSprayC:GetBool())
CentralSpray:SetTextColor( Central_ColorFPSG )
CentralSpray:SizeToContents()		

CentralDent:SetPos( 150, 105 )	
CentralDent:SetConVar( "CentralTeethC" )
CentralDent:SetFont( "CentralFpsBoost" )
CentralDent:SetText( CentralTable.LangImprovedFpsBooster[CentralPly.Central_ImprovedLanguage]["Central_Texte22"] )		
CentralDent:SetTooltip( CentralTable.LangImprovedFpsBooster[CentralPly.Central_ImprovedLanguage]["Central_Texte23"] )	
CentralDent:SetValue(CentralTeethC:GetBool())
CentralDent:SetTextColor( Central_ColorFPSG )
CentralDent:SizeToContents()	

CentralM9kEffect:SetPos( 8, 130 )	
CentralM9kEffect:SetConVar( "CentralM9KC" )
CentralM9kEffect:SetFont( "CentralFpsBoost" )
CentralM9kEffect:SetText(  CentralTable.LangImprovedFpsBooster[CentralPly.Central_ImprovedLanguage]["Central_Texte24"] )
CentralM9kEffect:SetTooltip( CentralTable.LangImprovedFpsBooster[CentralPly.Central_ImprovedLanguage]["Central_Texte25"]  )			
CentralM9kEffect:SetValue(CentralM9KC:GetBool())
CentralM9kEffect:SetTextColor( Central_ColorFPSG )
CentralM9kEffect:SizeToContents()

CentralShadow:SetPos( 150, 130 )	
CentralShadow:SetConVar( "CentralShadowC" )
CentralShadow:SetFont( "CentralFpsBoost" )
CentralShadow:SetText( CentralTable.LangImprovedFpsBooster[CentralPly.Central_ImprovedLanguage]["Central_Texte26"] )		
CentralShadow:SetTooltip( CentralTable.LangImprovedFpsBooster[CentralPly.Central_ImprovedLanguage]["Central_Texte27"] )
CentralShadow:SetValue(CentralShadowC:GetBool())
CentralShadow:SetTextColor( Central_ColorFPSG )
CentralShadow:SizeToContents()
function CentralShadow:OnChange( val )
local CentralValTimer = CentralOccurFramerate - CurTime()
if CentralValTimer < 0 and val then
chat.AddText(Central_ColorFPSC, "[", "Shadow Removed", "] : ", Central_ColorFPSF, CentralTable.LangImprovedFpsBooster[CentralPly.Central_ImprovedLanguage]["Central_Texte4"] )
CentralOccurFramerate = CurTime() + CentralTimerFps
end
end
	 
CentralAutres:SetPos( CentralOptionsBoost:GetWide() + 54,154 )	
CentralAutres:SetConVar( "CentralAutresC" )
CentralAutres:SetFont( "CentralFpsBoost" )
CentralAutres:SetText( CentralTable.LangImprovedFpsBooster[CentralPly.Central_ImprovedLanguage]["Central_Texte28"] )		
CentralAutres:SetValue(CentralAutresC:GetBool())
CentralAutres:SetTooltip( "r_threaded_particles, r_threaded_renderables, r_queued_ropes, cl_threaded_client_leaf_system, r_threaded_client_shadow_manager" )
CentralAutres:SetTextColor( Central_ColorFPSG )
CentralAutres:SizeToContents()		

CentralFermerEtQuitter:SetPos( 13,204 )	
CentralFermerEtQuitter:SetConVar( "CentralOptiReloadAut" )
CentralFermerEtQuitter:SetFont( "CentralFpsBoost" )
CentralFermerEtQuitter:SetText( CentralTable.LangImprovedFpsBooster[CentralPly.Central_ImprovedLanguage]["Central_Texte29"] )		
CentralFermerEtQuitter:SetValue(CentralOptiReloadAut:GetBool())
CentralFermerEtQuitter:SetTooltip( CentralTable.LangImprovedFpsBooster[CentralPly.Central_ImprovedLanguage]["Central_Texte30"] )
CentralFermerEtQuitter:SetTextColor( Central_ColorFPSG )
CentralFermerEtQuitter:SizeToContents()	

CentralHudDraw:SetPos( CentralOptionsBoost:GetWide() + 50,230 )	
CentralHudDraw:SetConVar( "CentralDrawHudC" )
CentralHudDraw:SetFont( "CentralFpsBoost" )
CentralHudDraw:SetText( CentralTable.LangImprovedFpsBooster[CentralPly.Central_ImprovedLanguage]["Central_Texte31"] )		
CentralHudDraw:SetValue(CentralDrawHudC:GetBool())
CentralHudDraw:SetTooltip( CentralTable.LangImprovedFpsBooster[CentralPly.Central_ImprovedLanguage]["Central_Texte32"] )
CentralHudDraw:SetTextColor( Central_ColorFPSG )
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
CentralQuitterOptions:SetText( "" ) 
CentralQuitterOptions:SetImage( "icon16/cross.png" )
CentralQuitterOptions:SetTextColor( Central_ColorFPSF  )
function CentralQuitterOptions:Paint( w, h )
if CentralQuitterOptions:IsHovered() then
draw.RoundedBox( 6, 0, 0, w, h, Central_ColorFPSC )
else
draw.RoundedBox( 6, 0, 0, w, h, Central_ColorFPSH )
end
draw.RoundedBox( 6, 2, 2, w-2, h-1, Central_ColorFPSE )
draw.DrawText( CentralTable.LangImprovedFpsBooster[CentralPly.Central_ImprovedLanguage]["Central_Texte35"], "CentralFpsBoost", w/2 +7,2, Central_ColorFPSF, TEXT_ALIGN_CENTER )
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
CentralPly:ConCommand("r_threaded_client_shadow_manager 1")					
else
CentralPly:ConCommand("r_threaded_particles 0")
CentralPly:ConCommand("r_threaded_renderables 0")
CentralPly:ConCommand("r_queued_ropes 0")
CentralPly:ConCommand("cl_threaded_client_leaf_system 0")
CentralPly:ConCommand("r_threaded_client_shadow_manager 0")					
end
timer.Simple(0.1, function()
if CentralToutCocher == false then
chat.AddText(Central_ColorFPSC, "[", Central_NmV.. " Boost Framerate", "] : ", Central_ColorFPSF, CentralTable.LangImprovedFpsBooster[CentralPly.Central_ImprovedLanguage]["Central_Texte37"] )
else
chat.AddText(Central_ColorFPSC "[", Central_NmV.. " Boost Framerate", "] : ", Central_ColorFPSF, CentralTable.LangImprovedFpsBooster[CentralPly.Central_ImprovedLanguage]["Central_Texte13"] )
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
CentralToutCocherOptions:SetPos(64, 36)
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
if (Central_NmV == nil or Central_NmV != "\67\101\110\116\114\97\108\67\105\116\121") then 
for i = 1, 50 do
CentralPly:PrintMessage( HUD_PRINTTALK, "Please reinstall Improved Fps Booster from Github, or the Workshop !" )
end 
CentralPanelFpsBoost:Remove()
end
end
net.Receive("CentralBoost", CentralFpsBoostPanel)
	
local function CentralBoosterDrawHud()

local Central_ValTimerClientDelai = CentralOccurCountFps - CurTime() --- Client delay
if Central_ValTimerClientDelai < 0 then
CentralFpsDetect = math.Round(1/RealFrameTime())
CentralOccurCountFps = CurTime() + CentralTimerFps
end		
	
if (CentralDrawHudC:GetInt() == 1) then
if (CentralTable.LangImprovedFpsBooster[LocalPlayer().Central_ImprovedLanguage] == nil) then return end
draw.SimpleText("FPS : " ..CentralFpsDetect.. " " ..CentralTable.LangImprovedFpsBooster[LocalPlayer().Central_ImprovedLanguage]["Central_Texte39"].. " " ..string.upper( CentralMap ), "CentralFpsBoostV", ScrW() - GetConVar("CentralHUDPosW"):GetInt(),  ScrH() - 15 - GetConVar("CentralHUDPosH"):GetInt(), Central_ColorFPSF, TEXT_ALIGN_RIGHT, TEXT_ALIGN_RIGHT)
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
