----------- // SCRIPT BY INJ3 
----------- // SCRIPT BY INJ3 
----------- // SCRIPT BY INJ3 
---- // https://steamcommunity.com/id/Inj3/

--//--
------------- GNU General Public License v3.0
------------- https://github.com/Inj3-GT
--\\--

Ipr_Fps_Booster_Vgui, Ipr_Fps_Booster_Opt_Vgui = Ipr_Fps_Booster_Vgui or {}, Ipr_Fps_Booster_Opt_Vgui or {}
local Ipr_Fps_Booster_Color = {["gris"] = Color(236, 240, 241),["vert"] = Color(39, 174, 96),["rouge"] = Color(192, 57, 43),["orange"] = Color(243, 156, 18),["blanc"] = Color(236, 240, 241), ["bleu"] = Color(52, 73, 94), ["bleuc"] = Color(30, 73, 109)}
local Ipr_Tbl_Convar_L, Ipr_Tbl_Lang = Ipr_Tbl_Convar_L or {}, Ipr_Tbl_Lang or {}
local Ipr_Sys_BlurMat, Ipr_StatusVgui, Ipr_LastMax = Material("pp/blurscreen"), false, 0
local Ipr_Current, Ipr_Max, Ipr_Min, Ipr_Gain, Ipr_CurtLast = 0, 0, math.huge, 0
local Ipr_Save_Location, Ipr_Loaded_Lua, Ipr_Lang_C = "improved_fps_booster_v3/sauvegarde/", false

local function Ipr_FPS_Booster_CountryLang()
    if (Ipr_Fps_Booster.Country[system.GetCountry()]) then
        return "FR"
    end

    return "EN"
end

local function Ipr_Fps_Booster_SaveConvar(ipr_gui, ipr_nb)
    if not IsValid(ipr_gui) then
        return
    end

    local ipr_check = ((ipr_nb == 1 and ipr_gui:GetChecked()) or (ipr_nb == 2 and ipr_gui:GetValue()))
    for _, v in pairs(Ipr_Tbl_Convar_L) do
        if (v.Ipr_UniqueNumber == ipr_gui.Ipr_UniqueNumber) then
            v.Ipr_ValueDyn = ipr_check
            break
        end
    end

    file.Write(Ipr_Save_Location.. "_fps_booster_v.txt", util.TableToJSON(Ipr_Tbl_Convar_L))
end

local function Ipr_Fps_Booster_CallConvar(ipr_gui)
    if IsValid(ipr_gui) then
         for _, v in pairs(Ipr_Tbl_Convar_L) do
              if (v.Ipr_UniqueNumber == ipr_gui.Ipr_UniqueNumber) then
                   return v.Ipr_ValueDyn
              end
         end
    end

    return false, print("*C-error")
end

local function Ipr_Fps_Booster_CallConvarSelected(ipr_nb)
         for _, v in pairs(Ipr_Tbl_Convar_L) do
              if (v.Ipr_UniqueNumber == ipr_nb) then
                   return v.Ipr_ValueDyn
              end
         end

    return false, print("*CS-error")
end

local function Ipr_FPS_Booster_Call_Lang()
    if (Ipr_Tbl_Lang and Ipr_Tbl_Lang[1]) then
        return Ipr_Tbl_Lang[1]
    end

    return "EN"
end

local function Ipr_Fps_Booster_SaveLang(ipr_lang)
    file.Write(Ipr_Save_Location.. "_fps_booster_lang.txt", util.TableToJSON({ipr_lang}))
    Ipr_Tbl_Lang[1] = ipr_lang
end

local function Ipr_Fps_Booster_TblLoad(ipr_bool)
    if (ipr_bool) then
        Ipr_Tbl_Convar_L = util.JSONToTable(file.Read(Ipr_Save_Location.. "_fps_booster_v.txt", "DATA") or {})
    else
        Ipr_Tbl_Lang = util.JSONToTable(file.Read(Ipr_Save_Location.. "_fps_booster_lang.txt", "DATA") or {})
    end
end

local function Ipr_Fps_Booster_SaveLoad()
    if not file.Exists(Ipr_Save_Location, "DATA") then
        file.CreateDir(Ipr_Save_Location)
    end

    if not file.Exists(Ipr_Save_Location.. "_fps_booster_v.txt", "DATA") then
        Ipr_Tbl_Convar_L = {{Ipr_UniqueNumber = 1, Ipr_ValueDyn = true},{Ipr_UniqueNumber = 2, Ipr_ValueDyn = false},{Ipr_UniqueNumber = 3, Ipr_ValueDyn = true},{Ipr_UniqueNumber = 4, Ipr_ValueDyn = true},{Ipr_UniqueNumber = 5, Ipr_ValueDyn = false},{Ipr_UniqueNumber = 6, Ipr_ValueDyn = true},{Ipr_UniqueNumber = 7, Ipr_ValueDyn = true},{Ipr_UniqueNumber = 8, Ipr_ValueDyn = true},{Ipr_UniqueNumber = 9, Ipr_ValueDyn = false},{Ipr_UniqueNumber = 10, Ipr_ValueDyn = 40},{Ipr_UniqueNumber = 11, Ipr_ValueDyn = 32}}
        file.Write(Ipr_Save_Location.. "_fps_booster_v.txt", util.TableToJSON(Ipr_Tbl_Convar_L))
    else
        Ipr_Fps_Booster_TblLoad(true)
    end
    if not file.Exists(Ipr_Save_Location.. "_fps_booster_lang.txt", "DATA") then
        local Ipr_CountryLang = Ipr_FPS_Booster_CountryLang()
        file.Write(Ipr_Save_Location.. "_fps_booster_lang.txt", util.TableToJSON({Ipr_CountryLang}))
        Ipr_Tbl_Lang[1] = Ipr_CountryLang
    else
        Ipr_Fps_Booster_TblLoad(false)
    end
end

local function Ipr_Fps_Booster_OverrideDcb(ipr_gui, ipr_bool)
    if (ipr_bool) then
        for _, v in pairs(ipr_gui:GetChildren()) do
            if (v:GetName() == "DMenu") then
                continue
            end

            v.Paint = function(panel, w, h)
                draw.RoundedBox(12, 9, 6, w - 10, h - 10, color_white)
            end
        end
    else
        for _, v in pairs(ipr_gui:GetChildren()) do
            if (v:GetName() == "DSlider") then
                continue
            end
            v:SetFont("Ipr_Fps_Booster_Font")
            v:SetTextColor(Ipr_Fps_Booster_Color["blanc"])
        end
    end
end

local function Ipr_Fps_Booster_Enabled_Disabled(ipr_bool)
    if (ipr_bool) then
         for _, v in pairs(Ipr_Tbl_Convar_L) do
              if (Ipr_Fps_Booster.DefautCommand[v.Ipr_UniqueNumber]) then
                   local ipr_val = v.Ipr_ValueDyn
                   for o, g in pairs(Ipr_Fps_Booster.DefautCommand[v.Ipr_UniqueNumber].Ipr_CmdChild) do
                        local ipr_control = ((ipr_val == true) and g.Ipr_Enabled) or g.Ipr_Disabled
                        LocalPlayer():ConCommand(o.. " " ..ipr_control)
                   end
              end
         end
    else
         for _, g in pairs(Ipr_Fps_Booster.DefautCommand) do
              for d,t in pairs(g.Ipr_CmdChild) do
                   LocalPlayer():ConCommand(d.. " " ..t.Ipr_Disabled)
              end
         end
    end
end

local function Ipr_Fps_Booster_CalculationFps()
    local Ipr_Cur = CurTime()

    if (Ipr_Cur > (Ipr_CurtLast or 0)) then
        Ipr_Current = math.Round(1/RealFrameTime(), 0)

        if (Ipr_Current < Ipr_Min) then
            Ipr_Min = Ipr_Current
        end
        if (Ipr_Current > Ipr_Max) then
            Ipr_Max = Ipr_Current
        end
        if not Ipr_StatusVgui then
            Ipr_LastMax = Ipr_Max
        end
        if (Ipr_Max > Ipr_LastMax) then
            Ipr_Gain = Ipr_Max - Ipr_LastMax
        end

        Ipr_CurtLast = CurTime() + 0.3
    end

    return Ipr_Current, Ipr_Min, Ipr_Max, Ipr_Gain
end

local function Ipr_Fps_Booster_RgbTransition(ipr_nbc)
    if (ipr_nbc <= 20) then
        return Ipr_Fps_Booster_Color["rouge"]
    elseif (ipr_nbc > 20 and ipr_nbc <= 40) then
        return Ipr_Fps_Booster_Color["orange"]
    else
        return Ipr_Fps_Booster_Color["vert"]
    end

    return Ipr_Fps_Booster_Color["blanc"]
end

local function Ipr_Gui_Blur(Ipr_Sys_Frame, Ipr_Sys_Float, Ipr_Sys_Col, Ipr_Sys_Bord)
    local x, y = Ipr_Sys_Frame:LocalToScreen(0, 0)
    surface.SetDrawColor(255, 255, 255)
    surface.SetMaterial(Ipr_Sys_BlurMat)
    for i = 1, 3 do
         Ipr_Sys_BlurMat:SetFloat("$blur", (i / 3) * Ipr_Sys_Float)
         Ipr_Sys_BlurMat:Recompute()
         render.UpdateScreenEffectTexture()
         surface.DrawTexturedRect(x * -1, y * -1, ScrW(), ScrH())
    end
    draw.RoundedBoxEx( Ipr_Sys_Bord, 0, 0, Ipr_Sys_Frame:GetWide(), Ipr_Sys_Frame:GetTall(), Ipr_Sys_Col, true, true, true, true )
end

local function Ipr_Booster_Option_Func(panel)
    if IsValid(panel) and not IsValid(Ipr_Fps_Booster_Opt_Vgui) then
        local ipr_gx, ipr_gxy = panel:GetPos()
        panel:SetPos(ipr_gx - 100, ipr_gxy)
    end
    if IsValid(Ipr_Fps_Booster_Opt_Vgui) then
        Ipr_Fps_Booster_Opt_Vgui:Remove()
    end
    Ipr_Fps_Booster_Opt_Vgui = vgui.Create( "DFrame" )
    local Ipr_Fps_Booster_Exp = vgui.Create("DImageButton", Ipr_Fps_Booster_Opt_Vgui)
    local Ipr_Fps_Booster_SaveLoad = vgui.Create("DButton", Ipr_Fps_Booster_Opt_Vgui)
    local Ipr_Fps_Booster_Dscroll = vgui.Create( "DScrollPanel", Ipr_Fps_Booster_Opt_Vgui)
    local Ipr_Fps_Booster_DChb_ShowHud = vgui.Create( "DCheckBoxLabel", Ipr_Fps_Booster_Opt_Vgui)
    local Ipr_Fps_Booster_PosW = vgui.Create( "DNumSlider", Ipr_Fps_Booster_Opt_Vgui)
    local Ipr_Fps_Booster_PosH = vgui.Create( "DNumSlider", Ipr_Fps_Booster_Opt_Vgui)
    Ipr_Lang_C = Ipr_FPS_Booster_Call_Lang()

    Ipr_Fps_Booster_Opt_Vgui:SetTitle( "" )
    Ipr_Fps_Booster_Opt_Vgui:SetSize(240, 360)
    Ipr_Fps_Booster_Opt_Vgui:SetPos(0, 0)
    Ipr_Fps_Booster_Opt_Vgui:MakePopup()
    Ipr_Fps_Booster_Opt_Vgui:ShowCloseButton(false)
    Ipr_Fps_Booster_Opt_Vgui:SetDraggable(true)
    Ipr_Fps_Booster_Opt_Vgui.Think = function(self)
        if IsValid(panel) then
            local ipr_getpos_x, ipr_getpos_y = panel:GetPos()
            self:SetPos(ipr_getpos_x + 310, ipr_getpos_y + -33)
        end
    end
    Ipr_Fps_Booster_Opt_Vgui.Paint = function( self, w, h )
        Ipr_Gui_Blur(self, 2, Color( 0, 0, 0, 170 ), 8)
        local Ior_Sys_Abs = math.abs(math.sin(CurTime() * 1.5) * 170)
        Ipr_Lang_C = Ipr_FPS_Booster_Call_Lang()

        draw.RoundedBox( 6, 0, 0, w, 20, Ipr_Fps_Booster_Color["bleu"])
        draw.SimpleText("Options FPS Booster","Ipr_Fps_Booster_Font",w/2,1, color_white, TEXT_ALIGN_CENTER)
        draw.SimpleText(Ipr_Fps_Booster.Lang[Ipr_Lang_C].ipr_vgui_opti_t,"Ipr_Fps_Booster_Font",w/2,50, color_white, TEXT_ALIGN_CENTER)
        draw.SimpleText("Configuration :","Ipr_Fps_Booster_Font",w/2,h-145, color_white, TEXT_ALIGN_CENTER)
        draw.SimpleText("V3.0 by Inj3","Ipr_Fps_Booster_Font", w-38,h-17, Color(Ior_Sys_Abs, Ior_Sys_Abs, Ior_Sys_Abs), TEXT_ALIGN_CENTER)
        draw.SimpleText(Ipr_Fps_Booster.Lang[Ipr_Lang_C].ipr_vgui_posw_t,"Ipr_Fps_Booster_Font",w/2+2,h-100, color_white, TEXT_ALIGN_CENTER)
        draw.SimpleText(Ipr_Fps_Booster.Lang[Ipr_Lang_C].ipr_vgui_posh_t,"Ipr_Fps_Booster_Font",w/2+2,h-60, color_white, TEXT_ALIGN_CENTER)
    end

    Ipr_Fps_Booster_Dscroll:Dock( FILL )
    Ipr_Fps_Booster_Dscroll:DockMargin(0, 40, 0, 150)

    local Ipr_Fps_Booster_Vbar = Ipr_Fps_Booster_Dscroll:GetVBar()
    function Ipr_Fps_Booster_Vbar:Paint(w, h)
    end
    function Ipr_Fps_Booster_Vbar.btnUp:Paint(w, h)
        draw.RoundedBox(3, 0, 0, w, h, Ipr_Fps_Booster_Color["bleu"])
    end
    function Ipr_Fps_Booster_Vbar.btnDown:Paint(w, h)
        draw.RoundedBox(3, 0, 0, w, h, Ipr_Fps_Booster_Color["bleu"])
    end
    function Ipr_Fps_Booster_Vbar.btnGrip:Paint(w, h)
        draw.RoundedBox(3, 0, 0, w, h, Ipr_Fps_Booster_Color["bleu"])
    end

    for i = 1, #Ipr_Fps_Booster.DefautCommand do
        local Ipr_Fps_Booster_DChb = vgui.Create( "DCheckBoxLabel", Ipr_Fps_Booster_Dscroll)
        Ipr_Fps_Booster_DChb:SetPos( 10, i * (1+ 22) -22)
        Ipr_Fps_Booster_DChb:SetFont("Ipr_Fps_Booster_Font")
        Ipr_Fps_Booster_DChb:SetText(Ipr_Fps_Booster.DefautCommand[i].Ipr_Texte)
        Ipr_Fps_Booster_DChb.Ipr_UniqueNumber = i
        Ipr_Fps_Booster_DChb:SetValue(Ipr_Fps_Booster_CallConvar(Ipr_Fps_Booster_DChb))
        Ipr_Fps_Booster_DChb:SetTooltip(Ipr_Fps_Booster.DefautCommand[i].Ipr_ToolTip)
        Ipr_Fps_Booster_DChb:SetTextColor(Ipr_Fps_Booster_Color["blanc"])
        Ipr_Fps_Booster_DChb.OnChange = function(self)
            Ipr_Fps_Booster_SaveConvar(self, 1)
        end
        Ipr_Fps_Booster_DChb:SizeToContents()
    end

    Ipr_Fps_Booster_DChb_ShowHud:SetPos( 38, 236)
    Ipr_Fps_Booster_DChb_ShowHud:SetText("")
    Ipr_Fps_Booster_DChb_ShowHud.Ipr_UniqueNumber = 9
    Ipr_Fps_Booster_DChb_ShowHud:SetValue(Ipr_Fps_Booster_CallConvar(Ipr_Fps_Booster_DChb_ShowHud))
    Ipr_Fps_Booster_DChb_ShowHud:SetTooltip(Ipr_Fps_Booster.Lang[Ipr_Lang_C].ipr_vgui_hudshow_t)
    Ipr_Fps_Booster_DChb_ShowHud:SetTextColor(Ipr_Fps_Booster_Color["blanc"])
    Ipr_Fps_Booster_DChb_ShowHud:SetWide(200)
    function Ipr_Fps_Booster_DChb_ShowHud:Paint(w, h)
        draw.SimpleText(Ipr_Fps_Booster.Lang[Ipr_Lang_C].ipr_vgui_hudshow_t, "Ipr_Fps_Booster_Font", w / 2 - 11, 0, color_white, TEXT_ALIGN_CENTER)
    end
    Ipr_Fps_Booster_DChb_ShowHud.OnChange = function(self)
        Ipr_Fps_Booster_SaveConvar(self, 1)
    end

    Ipr_Fps_Booster_PosW:SetPos( -160, 275 )
    Ipr_Fps_Booster_PosW:SetSize(415, 25 )
    Ipr_Fps_Booster_PosW:SetText( "" )
    Ipr_Fps_Booster_PosW:SetMinMax(0, 100)
    Ipr_Fps_Booster_PosW.Ipr_UniqueNumber = 10
    Ipr_Fps_Booster_PosW:SetValue(Ipr_Fps_Booster_CallConvar(Ipr_Fps_Booster_PosW))
    Ipr_Fps_Booster_PosW:SetDecimals(0)
    Ipr_Fps_Booster_OverrideDcb(Ipr_Fps_Booster_PosW, false)
    Ipr_Fps_Booster_PosW.OnValueChanged = function(self, val)
        Ipr_Fps_Booster_SaveConvar(self, 2)
    end

    Ipr_Fps_Booster_PosH:SetPos( -160, 315)
    Ipr_Fps_Booster_PosH:SetSize(415, 25)
    Ipr_Fps_Booster_PosH:SetText("")
    Ipr_Fps_Booster_PosH:SetMinMax(0, 100)
    Ipr_Fps_Booster_PosH.Ipr_UniqueNumber = 11
    Ipr_Fps_Booster_PosH:SetValue(Ipr_Fps_Booster_CallConvar(Ipr_Fps_Booster_PosH))
    Ipr_Fps_Booster_PosH:SetDecimals(0)
    Ipr_Fps_Booster_OverrideDcb(Ipr_Fps_Booster_PosH, false)
    Ipr_Fps_Booster_PosH.OnValueChanged = Ipr_Fps_Booster_PosW.OnValueChanged

    Ipr_Fps_Booster_Exp:SetPos(221, 2)
    Ipr_Fps_Booster_Exp:SetSize(17, 17)
    Ipr_Fps_Booster_Exp:SetImage("icon16/cross.png")
    function Ipr_Fps_Booster_Exp:Paint(w, h) end
    Ipr_Fps_Booster_Exp.DoClick = function()
        Ipr_Fps_Booster_Opt_Vgui:Remove()
    end

    Ipr_Fps_Booster_SaveLoad:SetPos(60, 25)
    Ipr_Fps_Booster_SaveLoad:SetSize(120, 18)
    Ipr_Fps_Booster_SaveLoad:SetText("")
    Ipr_Fps_Booster_SaveLoad:SetImage( "icon16/arrow_rotate_clockwise.png" )
    function Ipr_Fps_Booster_SaveLoad:Paint(w, h)
        if self:IsHovered() then
            draw.RoundedBox( 6, 0, 0, w, h, Ipr_Fps_Booster_Color["bleuc"])
        else
            draw.RoundedBox( 6, 0, 0, w, h, Ipr_Fps_Booster_Color["bleu"])
        end
        draw.SimpleText("Load Settings", "Ipr_Fps_Booster_Font", w / 2 + 4, 0, color_white, TEXT_ALIGN_CENTER)
    end
    Ipr_Fps_Booster_SaveLoad.DoClick = function()
        Ipr_Fps_Booster_Enabled_Disabled(false)
        Ipr_Max, Ipr_Min, Ipr_Gain, Ipr_StatusVgui = 0, math.huge, 0, true
        chat.AddText(Ipr_Fps_Booster_Color["rouge"], "[", "FPS Booster", "] : ", Ipr_Fps_Booster_Color["blanc"], Ipr_Fps_Booster.Lang[Ipr_Lang_C].ipr_vgui_fps_load_data)
        surface.PlaySound("buttons/button9.wav")
        Ipr_Fps_Booster_Enabled_Disabled(true)
    end
end

local function Ipr_Fps_Booster_Vgui_Func()
    if IsValid(Ipr_Fps_Booster_Vgui) then
        Ipr_Fps_Booster_Vgui:Remove()
    end

    Ipr_Fps_Booster_Vgui = vgui.Create( "DFrame" )
    local Ipr_Fps_Booster_Vgui_Dp = vgui.Create( "DPropertySheet", Ipr_Fps_Booster_Vgui )
    local Ipr_Fps_Booster_Vgui_HT = vgui.Create( "HTML", Ipr_Fps_Booster_Vgui_Dp )
    local Ipr_Fps_Booster_En = vgui.Create("DButton", Ipr_Fps_Booster_Vgui)
    local Ipr_Fps_Booster_Di = vgui.Create("DButton", Ipr_Fps_Booster_Vgui)
    local Ipr_Fps_Booster_Opt = vgui.Create("DButton", Ipr_Fps_Booster_Vgui)
    local Ipr_Fps_Booster_Res = vgui.Create("DButton", Ipr_Fps_Booster_Vgui)
    local Ipr_Fps_Booster_Dcb = vgui.Create( "DComboBox", Ipr_Fps_Booster_Vgui)
    local Ipr_Fps_Booster_Exp = vgui.Create("DImageButton", Ipr_Fps_Booster_Vgui)
    local Ipr_Fps_Booster_Vgui_HTurl = vgui.Create("DButton", Ipr_Fps_Booster_Vgui)

    Ipr_Lang_C = Ipr_FPS_Booster_Call_Lang()

    Ipr_Fps_Booster_Vgui:SetTitle( "" )
    Ipr_Fps_Booster_Vgui:SetSize(300, 290)
    Ipr_Fps_Booster_Vgui:MakePopup()
    Ipr_Fps_Booster_Vgui:ShowCloseButton(false)
    Ipr_Fps_Booster_Vgui:SetDraggable(true)
    Ipr_Fps_Booster_Vgui:Center()
    Ipr_Fps_Booster_Vgui.Paint = function( self, w, h )
        Ipr_Gui_Blur(self, 2, Color( 0, 0, 0, 170 ), 8)
        Ipr_Lang_C = Ipr_FPS_Booster_Call_Lang()

        draw.RoundedBox( 6, 0, 0, w, 33, Ipr_Fps_Booster_Color["bleu"])
        draw.SimpleText(Ipr_Fps_Booster.Lang[Ipr_Lang_C].ipr_vgui_enabled,"Ipr_Fps_Booster_Font",w/2,1, color_white, TEXT_ALIGN_CENTER)
        draw.SimpleText("FPS :","Ipr_Fps_Booster_Font",(Ipr_StatusVgui and w/2 -25) or w/2 -10,16, color_white, TEXT_ALIGN_CENTER)
        draw.SimpleText((Ipr_StatusVgui and "On (Boost)") or "Off", "Ipr_Fps_Booster_Font",(Ipr_StatusVgui and w/2 + 22) or w/2 + 18,16, Ipr_StatusVgui and Ipr_Fps_Booster_Color["vert"] or Ipr_Fps_Booster_Color["rouge"], TEXT_ALIGN_CENTER)
    end 
  
    Ipr_Fps_Booster_Vgui_Dp:Dock( FILL )
    Ipr_Fps_Booster_Vgui_Dp:DockPadding( 52, 10, 0, 0)
    Ipr_Fps_Booster_Vgui_Dp.Paint = function (self, w, h)
        local Ipr_Cur, Ipr_Min, Ipr_Max_, Ipr_Gain = Ipr_Fps_Booster_CalculationFps()
        draw.SimpleText("FPS Status","Ipr_Fps_Booster_Font",w/2,h/2-71, color_white, TEXT_ALIGN_CENTER)
        draw.SimpleText(Ipr_Fps_Booster.Lang[Ipr_Lang_C].ipr_vgui_fps_cur,"Ipr_Fps_Booster_Font",w/2-10,h/2-55, color_white, TEXT_ALIGN_CENTER)
        draw.SimpleText(Ipr_Cur, "Ipr_Fps_Booster_Font",w/2+15,h/2-55, Ipr_Fps_Booster_RgbTransition(Ipr_Cur), TEXT_ALIGN_LEFT)
        draw.SimpleText("Max : ","Ipr_Fps_Booster_Font",w/2-10,h/2-40, color_white, TEXT_ALIGN_CENTER)
        draw.SimpleText(Ipr_Max_,"Ipr_Fps_Booster_Font",w/2+10,h/2-40, Ipr_Fps_Booster_RgbTransition(Ipr_Max_), TEXT_ALIGN_LEFT)
        draw.SimpleText("Min : ","Ipr_Fps_Booster_Font",w/2-10,h/2-25, color_white, TEXT_ALIGN_CENTER)
        draw.SimpleText(Ipr_Min,"Ipr_Fps_Booster_Font",w/2+10,h/2-25, Ipr_Fps_Booster_RgbTransition(Ipr_Min), TEXT_ALIGN_LEFT)
        draw.SimpleText("Gain : ","Ipr_Fps_Booster_Font",w/2-10, h/2-10, color_white, TEXT_ALIGN_CENTER)
        draw.SimpleText((Ipr_StatusVgui and Ipr_Gain or "OFF"),"Ipr_Fps_Booster_Font",w/2+10, h/2-10, Ipr_StatusVgui and Ipr_Fps_Booster_Color["vert"] or Ipr_Fps_Booster_Color["rouge"], TEXT_ALIGN_LEFT)
    end
    Ipr_Fps_Booster_Vgui_HT:SetPos(-20, -6)
    Ipr_Fps_Booster_Vgui_HT:SetSize(370,300)
    Ipr_Fps_Booster_Vgui_HT:SetHTML([[<img src="https://centralcityrp.mtxserv.fr/ipr_boost_fnl0.gif" alt="Img" style="width:355px;height:230px;">]])
    Ipr_Fps_Booster_Vgui_HT:SetMouseInputEnabled( false )
    Ipr_Fps_Booster_Vgui_HTurl:SetPos(97, 80)
    Ipr_Fps_Booster_Vgui_HTurl:SetSize(110, 90)
    Ipr_Fps_Booster_Vgui_HTurl:SetText("")
    function Ipr_Fps_Booster_Vgui_HTurl:Paint(w, h) end
    Ipr_Fps_Booster_Vgui_HTurl.DoClick = function()
        gui.OpenURL("https://steamcommunity.com/sharedfiles/filedetails/?id=1762151370")
    end

    Ipr_Fps_Booster_En:SetPos(6, 258)
    Ipr_Fps_Booster_En:SetSize(110, 25)
    Ipr_Fps_Booster_En:SetImage( "icon16/tick.png" )
    Ipr_Fps_Booster_En:SetText("")
    function Ipr_Fps_Booster_En:Paint(w, h)
        if self:IsHovered() then
            draw.RoundedBox( 6, 0, 0, w, h, Ipr_Fps_Booster_Color["bleuc"])
        else
            draw.RoundedBox( 6, 0, 0, w, h, Ipr_Fps_Booster_Color["bleu"] )
        end
        draw.SimpleText(Ipr_Fps_Booster.Lang[Ipr_Lang_C].ipr_vgui_enable_t, "Ipr_Fps_Booster_Font", w / 2 + 5, 3, color_white, TEXT_ALIGN_CENTER)
    end
    Ipr_Fps_Booster_En.DoClick = function()
        if Ipr_StatusVgui then
            Ipr_Fps_Booster_Enabled_Disabled(false)
        end
        Ipr_Max, Ipr_Min, Ipr_Gain, Ipr_StatusVgui = 0, math.huge, 0, true
        Ipr_Fps_Booster_Enabled_Disabled(true)

        chat.AddText(Ipr_Fps_Booster_Color["rouge"], "[", "FPS Booster", "] : ", Ipr_Fps_Booster_Color["blanc"], Ipr_Fps_Booster.Lang[Ipr_Lang_C].ipr_vgui_enable_prevent_t)
        Ipr_Fps_Booster_Vgui:Remove()
        if IsValid(Ipr_Fps_Booster_Opt_Vgui) then
            Ipr_Fps_Booster_Opt_Vgui:Remove()
        end
        surface.PlaySound("buttons/combine_button7.wav")
    end

    Ipr_Fps_Booster_Di:SetPos(184, 258)
    Ipr_Fps_Booster_Di:SetSize(110, 25)
    Ipr_Fps_Booster_Di:SetImage( "icon16/cross.png" )
    Ipr_Fps_Booster_Di:SetText("")
    function Ipr_Fps_Booster_Di:Paint(w, h)
        if self:IsHovered() then
            draw.RoundedBox( 6, 0, 0, w, h, Ipr_Fps_Booster_Color["bleuc"])
        else
            draw.RoundedBox( 6, 0, 0, w, h, Ipr_Fps_Booster_Color["bleu"])
        end
        draw.SimpleText(Ipr_Fps_Booster.Lang[Ipr_Lang_C].ipr_vgui_disable_t, "Ipr_Fps_Booster_Font", w / 2 + 7, 3, color_white, TEXT_ALIGN_CENTER)
    end
    Ipr_Fps_Booster_Di.DoClick = function()
        Ipr_Max, Ipr_Min, Ipr_Gain, Ipr_StatusVgui = 0, math.huge, 0, false
        Ipr_LastMax = 0
        Ipr_Fps_Booster_Enabled_Disabled(false)

        chat.AddText(Ipr_Fps_Booster_Color["rouge"], "[", "FPS Booster", "] : ", Ipr_Fps_Booster_Color["blanc"], Ipr_Fps_Booster.Lang[Ipr_Lang_C].ipr_vgui_disableop_t)
        Ipr_Fps_Booster_Vgui:Remove()
        if IsValid(Ipr_Fps_Booster_Opt_Vgui) then
            Ipr_Fps_Booster_Opt_Vgui:Remove()
        end
        surface.PlaySound("buttons/combine_button5.wav")
    end

    Ipr_Fps_Booster_Opt:SetPos(200, 37)
    Ipr_Fps_Booster_Opt:SetSize(95, 20)
    Ipr_Fps_Booster_Opt:SetText("")
    Ipr_Fps_Booster_Opt:SetImage( "icon16/cog.png" )
    function Ipr_Fps_Booster_Opt:Paint(w, h)
        if self:IsHovered() then
            draw.RoundedBox( 6, 0, 0, w, h, Ipr_Fps_Booster_Color["bleuc"])
        else
            draw.RoundedBox( 6, 0, 0, w, h, Ipr_Fps_Booster_Color["bleu"])
        end
        draw.SimpleText("Options ", "Ipr_Fps_Booster_Font", w / 2 + 4, 1, color_white, TEXT_ALIGN_CENTER)
    end
    Ipr_Fps_Booster_Opt.DoClick = function()
        Ipr_Booster_Option_Func(Ipr_Fps_Booster_Vgui)
        surface.PlaySound("buttons/button9.wav")
    end

    Ipr_Fps_Booster_Res:SetPos(75, 216)
    Ipr_Fps_Booster_Res:SetSize(151, 20)
    Ipr_Fps_Booster_Res:SetText("")
    Ipr_Fps_Booster_Res:SetImage( "icon16/arrow_refresh.png" )
    function Ipr_Fps_Booster_Res:Paint(w, h)
        if self:IsHovered() then
            draw.RoundedBox( 6, 0, 0, w, h, Ipr_Fps_Booster_Color["bleuc"])
        else
            draw.RoundedBox( 6, 0, 0, w, h, Ipr_Fps_Booster_Color["bleu"])
        end
        draw.SimpleText("Reset FPS max/min", "Ipr_Fps_Booster_Font", w / 2 + 5, 2, color_white, TEXT_ALIGN_CENTER)
    end
    Ipr_Fps_Booster_Res.DoClick = function()
        Ipr_Max, Ipr_Min = 0, math.huge
        surface.PlaySound("buttons/button9.wav")
    end

    Ipr_Fps_Booster_Dcb:SetPos(5, 37)
    Ipr_Fps_Booster_Dcb:SetSize(95, 20)
    Ipr_Fps_Booster_Dcb:SetFont( "Ipr_Fps_Booster_Font" )
    Ipr_Fps_Booster_Dcb:SetValue( "Langue : " ..Ipr_FPS_Booster_Call_Lang())
    for lang in pairs(Ipr_Fps_Booster.Lang) do
    Ipr_Fps_Booster_Dcb:AddChoice("Langue : " ..lang)
    end
    Ipr_Fps_Booster_Dcb:SetTextColor( color_white )
    function Ipr_Fps_Booster_Dcb:Paint(w, h)
        if self:IsHovered() then
            draw.RoundedBox( 6, 0, 0, w, h, Ipr_Fps_Booster_Color["bleuc"])
        else
            draw.RoundedBox( 6, 0, 0, w, h, Ipr_Fps_Booster_Color["bleu"])
        end
    end
    Ipr_Fps_Booster_OverrideDcb(Ipr_Fps_Booster_Dcb, true)
    Ipr_Fps_Booster_Dcb.OnMenuOpened = function(self)
        for _, v in pairs(self:GetChildren()) do
            v.Paint = function(panel, w, h)
                draw.RoundedBox(6, 0, 0, w, h, Ipr_Fps_Booster_Color["bleu"])
            end
            if (v:GetName() == "DPanel") then
                continue
            end
            for _, d in pairs(v:GetChildren()) do
                if (d:GetName() == "DVScrollBar") then
                   continue
                end
                for _, y in pairs(d:GetChildren()) do
                    y:SetTextColor(color_white)
                    y:SetFont( "Ipr_Fps_Booster_Font" )
                end
            end
        end

        Ipr_Fps_Booster_OverrideDcb(self, true)
    end
    Ipr_Fps_Booster_Dcb.OnSelect = function( self, index, value )
        local ipr_lang_rpl = string.Replace(value, "Langue : ", "")
        Ipr_Fps_Booster_SaveLang(ipr_lang_rpl)
        surface.PlaySound("buttons/button9.wav")
    end

    Ipr_Fps_Booster_Exp:SetPos(280, 3)
    Ipr_Fps_Booster_Exp:SetSize(17, 17)
    Ipr_Fps_Booster_Exp:SetImage("icon16/cross.png")
    function Ipr_Fps_Booster_Exp:Paint(w, h) end
    Ipr_Fps_Booster_Exp.DoClick = function()
        if IsValid(Ipr_Fps_Booster_Opt_Vgui) then
            Ipr_Fps_Booster_Opt_Vgui:Remove()
        end
        Ipr_Fps_Booster_Vgui:Remove()
    end
end
 
hook.Add("PostDrawHUD","Ipr_Fps_Booster_PostDraw", function()
    if (Ipr_Loaded_Lua and Ipr_Fps_Booster_CallConvarSelected(9)) then
        local Ipr_Cur, Ipr_Min, Ipr_Max_, Ipr_Gain = Ipr_Fps_Booster_CalculationFps()
        draw.SimpleTextOutlined("FPS : " ..Ipr_Cur.. " Min : " ..Ipr_Min.. " Max : " ..Ipr_Max_.. " Gain : " ..(Ipr_StatusVgui and Ipr_Gain or "OFF"), "Ipr_Fps_Booster_Font", ScrW() * (Ipr_Fps_Booster_CallConvarSelected(10) / 100) - 40,  ScrH() * (Ipr_Fps_Booster_CallConvarSelected(11) / 100) - 10, Ipr_Fps_Booster_Color["blanc"], TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT, 0.8, Ipr_Fps_Booster_Color["bleu"])
    end
end)

net.Receive("ipr_fpsbooster_vgui", function()
    local Ipr_Get_NetRead = net.ReadBool()
    Ipr_Fps_Booster_SaveLoad()

    if (Ipr_Get_NetRead) then
        Ipr_Fps_Booster_Vgui_Func()
    else
        Ipr_Fps_Booster_Enabled_Disabled(false)
    end
    Ipr_Loaded_Lua = true
end)