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
local Ipr_Sys_BlurMat, ipr_statusvgui, ipr_lastmax = Material("pp/blurscreen"), false, 0
local ipr_current, ipr_max, ipr_min, ipr_gain, ipr_CurtLast = 0, 0, math.huge, 0
local ipr_save_location = "improved_fps_booster_finalversion/sauvegarde/"
local Ipr_Loaded_Lua = false

local function Ipr_Fps_Booster_TblLoad(ipr_nb)
    if (ipr_nb == 1) then
        Ipr_Tbl_Convar_L = util.JSONToTable(file.Read(ipr_save_location.. "_fps_booster_v.txt", "DATA") or {})
    else
        Ipr_Tbl_Lang = util.JSONToTable(file.Read(ipr_save_location.. "_fps_booster_lang.txt", "DATA") or {})
    end
end

local function Ipr_FPS_Booster_CountryLang()
    local Ipr_Country_Val = {
        ["BE"] = true,
        ["FR"] = true,
        ["DZ"] = true,
        ["MA"] = true,
        ["CA"] = true,
    }
    if (Ipr_Country_Val[system.GetCountry()]) then
        return "FR"
    end

    return "EN"
end

local function Ipr_Fps_Booster_SaveLoad()
    if not file.Exists(ipr_save_location, "DATA") then
        file.CreateDir(ipr_save_location)
    end

    if not file.Exists(ipr_save_location.. "_fps_booster_v.txt", "DATA") then
        Ipr_Tbl_Convar_L = {{Ipr_UniqueNumber = 1, Ipr_ValueDyn = true},{Ipr_UniqueNumber = 2, Ipr_ValueDyn = false},{Ipr_UniqueNumber = 3, Ipr_ValueDyn = true},{Ipr_UniqueNumber = 4, Ipr_ValueDyn = true},{Ipr_UniqueNumber = 5, Ipr_ValueDyn = false},{Ipr_UniqueNumber = 6, Ipr_ValueDyn = true},{Ipr_UniqueNumber = 7, Ipr_ValueDyn = true},{Ipr_UniqueNumber = 8, Ipr_ValueDyn = true},{Ipr_UniqueNumber = 9, Ipr_ValueDyn = false},{Ipr_UniqueNumber = 10, Ipr_ValueDyn = 50},{Ipr_UniqueNumber = 11, Ipr_ValueDyn = 50}}
        file.Write(ipr_save_location.. "_fps_booster_v.txt", util.TableToJSON(Ipr_Tbl_Convar_L))
    else
        Ipr_Fps_Booster_TblLoad(1)
    end
    if not file.Exists(ipr_save_location.. "_fps_booster_lang.txt", "DATA") then
        local Ipr_CountryLang = Ipr_FPS_Booster_CountryLang()
        file.Write(ipr_save_location.. "_fps_booster_lang.txt", util.TableToJSON({Ipr_CountryLang}))
        Ipr_Tbl_Lang[1] = Ipr_CountryLang
    else
        Ipr_Fps_Booster_TblLoad(2)
    end
end

local function Ipr_Fps_Booster_SaveConvar(ipr_gui, ipr_nb)
    if IsValid(ipr_gui) then
         local ipr_check = ((ipr_nb == 1 and ipr_gui:GetChecked()) or (ipr_nb == 2 and ipr_gui:GetValue()))
         for k, v in pairs(Ipr_Tbl_Convar_L) do
              if (v.Ipr_UniqueNumber == ipr_gui.Ipr_UniqueNumber) then
                   v.Ipr_ValueDyn = ipr_check
                   break
              end
         end

         file.Write(ipr_save_location.. "_fps_booster_v.txt", util.TableToJSON(Ipr_Tbl_Convar_L))
    end
end

local function Ipr_Fps_Booster_CallConvar(ipr_gui)
    if IsValid(ipr_gui) then
         for k, v in pairs(Ipr_Tbl_Convar_L) do
              if (v.Ipr_UniqueNumber == ipr_gui.Ipr_UniqueNumber) then
                   return v.Ipr_ValueDyn
              end
         end
    end

    return false, print("*C-error")
end

local function Ipr_Fps_Booster_CallConvarSelected(ipr_nb)
         for k, v in pairs(Ipr_Tbl_Convar_L) do
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
    file.Write(ipr_save_location.. "_fps_booster_lang.txt", util.TableToJSON({ipr_lang}))
    Ipr_Tbl_Lang[1] = ipr_lang
end

local function Ipr_Fps_Booster_OverrideDcb(self)
    for k, v in pairs(self:GetChildren()) do
        if (v:GetName() == "DMenu") then
            continue
        end

        v.Paint = function(panel, w, h)
            draw.RoundedBox(12, 9, 6, w - 10, h - 10, color_white)
        end
    end
end

local function Ipr_Fps_Booster_Enabled_Disabled(ipr_bool)
    if (ipr_bool) then
         for k, v in pairs(Ipr_Tbl_Convar_L) do
              if (Ipr_Fps_Booster.DefautCommand[v.Ipr_UniqueNumber]) then
                   local ipr_val = v.Ipr_ValueDyn
                   for o, g in pairs(Ipr_Fps_Booster.DefautCommand[v.Ipr_UniqueNumber].Ipr_CmdChild) do
                        local ipr_control = ((ipr_val == true) and g.Ipr_Enabled) or g.Ipr_Disabled
                        LocalPlayer():ConCommand(o.. " " ..ipr_control)
                   end
              end
         end
    else
         for o, g in pairs(Ipr_Fps_Booster.DefautCommand) do
              for d,t in pairs(g.Ipr_CmdChild) do
                   LocalPlayer():ConCommand(d.. " " ..t.Ipr_Disabled)
              end
         end
    end
end

local function Ipr_Fps_Booster_RetVal()
    local ipr_CurT = CurTime()
    if ipr_CurT > (ipr_CurtLast or 0) then
         ipr_current = math.Round(1/RealFrameTime(), 0)
         if (ipr_current < ipr_min) then
              ipr_min = ipr_current
         end
         if (ipr_current > ipr_max) then
              ipr_max = ipr_current
         end
         if not ipr_statusvgui then
              ipr_lastmax = ipr_max
         end
         if (ipr_max > ipr_lastmax) then
              ipr_gain = ipr_max - ipr_lastmax
         end
         ipr_CurtLast = CurTime() + 0.3
    end

    return ipr_current, ipr_min, ipr_max, ipr_gain
end  

local function ipr_Fps_Booster_ColTransition(ipr_nbc)
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

    if IsValid(panel) then
        panel:Center()
        local ipr_gx, ipr_gxy = panel:GetPos()
        panel:SetPos(ipr_gx - 100, ipr_gxy)
    end

    local ipr_lang_c = Ipr_FPS_Booster_Call_Lang()

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
        ipr_lang_c = Ipr_FPS_Booster_Call_Lang()

        draw.RoundedBox( 6, 0, 0, w, 20, Ipr_Fps_Booster_Color["bleu"])
        draw.SimpleText("Options FPS Booster","Ipr_Fps_Booster_Font",w/2,1, color_white, TEXT_ALIGN_CENTER)
        draw.SimpleText(Ipr_Fps_Booster.Lang[ipr_lang_c].ipr_vgui_opti_t,"Ipr_Fps_Booster_Font",w/2,50, color_white, TEXT_ALIGN_CENTER)
        draw.SimpleText("Configuration :","Ipr_Fps_Booster_Font",w/2,h-145, color_white, TEXT_ALIGN_CENTER)
        draw.SimpleText("V3.0 by Inj3","Ipr_Fps_Booster_Font", w-38,h-17, Color(Ior_Sys_Abs, Ior_Sys_Abs, Ior_Sys_Abs), TEXT_ALIGN_CENTER)
        draw.SimpleText(Ipr_Fps_Booster.Lang[ipr_lang_c].ipr_vgui_posw_t,"Ipr_Fps_Booster_Font",w/2,h-100, color_white, TEXT_ALIGN_CENTER)
        draw.SimpleText(Ipr_Fps_Booster.Lang[ipr_lang_c].ipr_vgui_posh_t,"Ipr_Fps_Booster_Font",w/2,h-60, color_white, TEXT_ALIGN_CENTER)
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

    Ipr_Fps_Booster_DChb_ShowHud:SetPos( 38, 235)
    Ipr_Fps_Booster_DChb_ShowHud:SetFont("Ipr_Fps_Booster_Font")
    Ipr_Fps_Booster_DChb_ShowHud:SetText(Ipr_Fps_Booster.Lang[ipr_lang_c].ipr_vgui_hudshow_t)
    Ipr_Fps_Booster_DChb_ShowHud.Ipr_UniqueNumber = 9
    Ipr_Fps_Booster_DChb_ShowHud:SetValue(Ipr_Fps_Booster_CallConvar(Ipr_Fps_Booster_DChb_ShowHud))
    Ipr_Fps_Booster_DChb_ShowHud:SetTooltip(Ipr_Fps_Booster.Lang[ipr_lang_c].ipr_vgui_hudshow_t)
    Ipr_Fps_Booster_DChb_ShowHud:SetTextColor(Ipr_Fps_Booster_Color["blanc"])
    Ipr_Fps_Booster_DChb_ShowHud.OnChange = function(self)
        Ipr_Fps_Booster_SaveConvar(self, 1)
    end
    Ipr_Fps_Booster_DChb_ShowHud:SizeToContents()

    Ipr_Fps_Booster_PosW:SetPos( -160, 275 )
    Ipr_Fps_Booster_PosW:SetSize(415, 25 )
    Ipr_Fps_Booster_PosW:SetText( "" )
    Ipr_Fps_Booster_PosW:SetMinMax(0, 100)
    Ipr_Fps_Booster_PosW.Ipr_UniqueNumber = 10
    Ipr_Fps_Booster_PosW:SetValue(Ipr_Fps_Booster_CallConvar(Ipr_Fps_Booster_PosW))
    Ipr_Fps_Booster_PosW:SetDecimals(0)
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
    Ipr_Fps_Booster_PosH.OnValueChanged = Ipr_Fps_Booster_PosW.OnValueChanged

    Ipr_Fps_Booster_Exp:SetPos(221, 2)
    Ipr_Fps_Booster_Exp:SetSize(17, 17)
    Ipr_Fps_Booster_Exp:SetImage("icon16/cross.png")
    function Ipr_Fps_Booster_Exp:Paint(w, h) end
    Ipr_Fps_Booster_Exp.DoClick = function()
        if IsValid(panel) then
            panel:Center()
        end
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
        ipr_max, ipr_min, ipr_gain, ipr_statusvgui = 0, math.huge, 0, true
        chat.AddText(Ipr_Fps_Booster_Color["rouge"], "[", "FPS Booster", "] : ", Ipr_Fps_Booster_Color["blanc"], Ipr_Fps_Booster.Lang[ipr_lang_c].ipr_vgui_fps_load_data)
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
    local Ipr_Fps_Booster_Vgui_BT1 = vgui.Create("DButton", Ipr_Fps_Booster_Vgui)
    local Ipr_Fps_Booster_Vgui_BT2 = vgui.Create("DButton", Ipr_Fps_Booster_Vgui)
    local Ipr_Fps_Booster_Vgui_BT3 = vgui.Create("DButton", Ipr_Fps_Booster_Vgui)
    local Ipr_Fps_Booster_Vgui_BT4 = vgui.Create("DButton", Ipr_Fps_Booster_Vgui)
    local Ipr_Fps_Booster_Dcb = vgui.Create( "DComboBox", Ipr_Fps_Booster_Vgui)
    local Ipr_Fps_Booster_Exp = vgui.Create("DImageButton", Ipr_Fps_Booster_Vgui)

    local ipr_lang_x = Ipr_FPS_Booster_Call_Lang()

    Ipr_Fps_Booster_Vgui:SetTitle( "" )
    Ipr_Fps_Booster_Vgui:SetSize(300, 290)
    Ipr_Fps_Booster_Vgui:MakePopup()
    Ipr_Fps_Booster_Vgui:ShowCloseButton(false)
    Ipr_Fps_Booster_Vgui:SetDraggable(true)
    Ipr_Fps_Booster_Vgui:Center()
    Ipr_Fps_Booster_Vgui.Paint = function( self, w, h )
        Ipr_Gui_Blur(self, 2, Color( 0, 0, 0, 170 ), 8)
        ipr_lang_x = Ipr_FPS_Booster_Call_Lang()

        draw.RoundedBox( 6, 0, 0, w, 33, Ipr_Fps_Booster_Color["bleu"])
        draw.SimpleText(Ipr_Fps_Booster.Lang[ipr_lang_x].ipr_vgui_enabled,"Ipr_Fps_Booster_Font",w/2,1, color_white, TEXT_ALIGN_CENTER)
        draw.SimpleText("FPS :","Ipr_Fps_Booster_Font",(ipr_statusvgui and w/2 -25) or w/2 -10,16, color_white, TEXT_ALIGN_CENTER)
        draw.SimpleText((ipr_statusvgui and "On (Boost)") or "Off", "Ipr_Fps_Booster_Font",(ipr_statusvgui and w/2 + 22) or w/2 + 18,16, ipr_statusvgui and Ipr_Fps_Booster_Color["vert"] or Ipr_Fps_Booster_Color["rouge"], TEXT_ALIGN_CENTER)
    end 
  
    Ipr_Fps_Booster_Vgui_Dp:Dock( FILL )
    Ipr_Fps_Booster_Vgui_Dp:DockPadding( 52, 10, 0, 0)
    Ipr_Fps_Booster_Vgui_Dp.Paint = function (self, w, h)
        local Ipr_Cur, Ipr_min, Ipr_Max_, Ipr_Gain = Ipr_Fps_Booster_RetVal()
        draw.SimpleText("FPS Status","Ipr_Fps_Booster_Font",w/2,h/2-71, color_white, TEXT_ALIGN_CENTER)
        draw.SimpleText(Ipr_Fps_Booster.Lang[ipr_lang_x].ipr_vgui_fps_cur,"Ipr_Fps_Booster_Font",w/2-10,h/2-55, color_white, TEXT_ALIGN_CENTER)
        draw.SimpleText(Ipr_Cur, "Ipr_Fps_Booster_Font",w/2+15,h/2-55, ipr_Fps_Booster_ColTransition(Ipr_Cur), TEXT_ALIGN_LEFT)
        draw.SimpleText("Max : ","Ipr_Fps_Booster_Font",w/2-10,h/2-40, color_white, TEXT_ALIGN_CENTER)
        draw.SimpleText(Ipr_Max_,"Ipr_Fps_Booster_Font",w/2+10,h/2-40, ipr_Fps_Booster_ColTransition(Ipr_Max_), TEXT_ALIGN_LEFT)
        draw.SimpleText("Min : ","Ipr_Fps_Booster_Font",w/2-10,h/2-25, color_white, TEXT_ALIGN_CENTER)
        draw.SimpleText(Ipr_min,"Ipr_Fps_Booster_Font",w/2+10,h/2-25, ipr_Fps_Booster_ColTransition(Ipr_min), TEXT_ALIGN_LEFT)
        draw.SimpleText("Gain : ","Ipr_Fps_Booster_Font",w/2-10, h/2-10, color_white, TEXT_ALIGN_CENTER)
        draw.SimpleText((ipr_statusvgui and Ipr_Gain or "OFF"),"Ipr_Fps_Booster_Font",w/2+10, h/2-10, ipr_statusvgui and Ipr_Fps_Booster_Color["vert"] or Ipr_Fps_Booster_Color["rouge"], TEXT_ALIGN_LEFT)
    end
    Ipr_Fps_Booster_Vgui_HT:SetPos(-20, -6)
    Ipr_Fps_Booster_Vgui_HT:SetSize(370,300)
    Ipr_Fps_Booster_Vgui_HT:SetHTML([[<img src="https://centralcityrp.mtxserv.fr/ipr_boost_fnl0.gif" alt="Img" style="width:355px;height:230px;">]])
    Ipr_Fps_Booster_Vgui_HT:SetMouseInputEnabled( false )

    Ipr_Fps_Booster_Vgui_BT1:SetPos(6, 258)
    Ipr_Fps_Booster_Vgui_BT1:SetSize(110, 25)
    Ipr_Fps_Booster_Vgui_BT1:SetImage( "icon16/tick.png" )
    Ipr_Fps_Booster_Vgui_BT1:SetText("")
    function Ipr_Fps_Booster_Vgui_BT1:Paint(w, h)
        if self:IsHovered() then
            draw.RoundedBox( 6, 0, 0, w, h, Ipr_Fps_Booster_Color["bleuc"])
        else
            draw.RoundedBox( 6, 0, 0, w, h, Ipr_Fps_Booster_Color["bleu"] )
        end
        draw.SimpleText(Ipr_Fps_Booster.Lang[ipr_lang_x].ipr_vgui_enable_t, "Ipr_Fps_Booster_Font", w / 2 + 5, 3, color_white, TEXT_ALIGN_CENTER)
    end
    Ipr_Fps_Booster_Vgui_BT1.DoClick = function()
        if ipr_statusvgui then
            Ipr_Fps_Booster_Enabled_Disabled(false)
        end
        ipr_max, ipr_min, ipr_gain, ipr_statusvgui = 0, math.huge, 0, true
        Ipr_Fps_Booster_Enabled_Disabled(true)

        chat.AddText(Ipr_Fps_Booster_Color["rouge"], "[", "FPS Booster", "] : ", Ipr_Fps_Booster_Color["blanc"], Ipr_Fps_Booster.Lang[ipr_lang_x].ipr_vgui_enable_prevent_t)
        Ipr_Fps_Booster_Vgui:Remove()
        if IsValid(Ipr_Fps_Booster_Opt_Vgui) then
            Ipr_Fps_Booster_Opt_Vgui:Remove()
        end
        surface.PlaySound("buttons/combine_button7.wav")
    end

    Ipr_Fps_Booster_Vgui_BT2:SetPos(184, 258)
    Ipr_Fps_Booster_Vgui_BT2:SetSize(110, 25)
    Ipr_Fps_Booster_Vgui_BT2:SetImage( "icon16/cross.png" )
    Ipr_Fps_Booster_Vgui_BT2:SetText("")
    function Ipr_Fps_Booster_Vgui_BT2:Paint(w, h)
        if self:IsHovered() then
            draw.RoundedBox( 6, 0, 0, w, h, Ipr_Fps_Booster_Color["bleuc"])
        else
            draw.RoundedBox( 6, 0, 0, w, h, Ipr_Fps_Booster_Color["bleu"])
        end
        draw.SimpleText(Ipr_Fps_Booster.Lang[ipr_lang_x].ipr_vgui_disable_t, "Ipr_Fps_Booster_Font", w / 2 + 7, 3, color_white, TEXT_ALIGN_CENTER)
    end
    Ipr_Fps_Booster_Vgui_BT2.DoClick = function()
        ipr_max, ipr_min, ipr_gain, ipr_statusvgui = 0, math.huge, 0, false
        ipr_lastmax = 0
        Ipr_Fps_Booster_Enabled_Disabled(false)

        chat.AddText(Ipr_Fps_Booster_Color["rouge"], "[", "FPS Booster", "] : ", Ipr_Fps_Booster_Color["blanc"], Ipr_Fps_Booster.Lang[ipr_lang_x].ipr_vgui_disableop_t)
        Ipr_Fps_Booster_Vgui:Remove()
        if IsValid(Ipr_Fps_Booster_Opt_Vgui) then
            Ipr_Fps_Booster_Opt_Vgui:Remove()
        end
        surface.PlaySound("buttons/combine_button5.wav")
    end

    Ipr_Fps_Booster_Vgui_BT3:SetPos(200, 37)
    Ipr_Fps_Booster_Vgui_BT3:SetSize(95, 20)
    Ipr_Fps_Booster_Vgui_BT3:SetText("")
    Ipr_Fps_Booster_Vgui_BT3:SetImage( "icon16/cog.png" )
    function Ipr_Fps_Booster_Vgui_BT3:Paint(w, h)
        if self:IsHovered() then
            draw.RoundedBox( 6, 0, 0, w, h, Ipr_Fps_Booster_Color["bleuc"])
        else
            draw.RoundedBox( 6, 0, 0, w, h, Ipr_Fps_Booster_Color["bleu"])
        end
        draw.SimpleText("Options ", "Ipr_Fps_Booster_Font", w / 2 + 4, 1, color_white, TEXT_ALIGN_CENTER)
    end
    Ipr_Fps_Booster_Vgui_BT3.DoClick = function()
        Ipr_Booster_Option_Func(Ipr_Fps_Booster_Vgui)
        surface.PlaySound("buttons/button9.wav")
    end

    Ipr_Fps_Booster_Vgui_BT4:SetPos(75, 216)
    Ipr_Fps_Booster_Vgui_BT4:SetSize(151, 20)
    Ipr_Fps_Booster_Vgui_BT4:SetText("")
    Ipr_Fps_Booster_Vgui_BT4:SetImage( "icon16/arrow_refresh.png" )
    function Ipr_Fps_Booster_Vgui_BT4:Paint(w, h)
        if self:IsHovered() then
            draw.RoundedBox( 6, 0, 0, w, h, Ipr_Fps_Booster_Color["bleuc"])
        else
            draw.RoundedBox( 6, 0, 0, w, h, Ipr_Fps_Booster_Color["bleu"])
        end
        draw.SimpleText("Reset FPS max/min", "Ipr_Fps_Booster_Font", w / 2 + 5, 2, color_white, TEXT_ALIGN_CENTER)
    end
    Ipr_Fps_Booster_Vgui_BT4.DoClick = function()
        ipr_max, ipr_min = 0, math.huge
        surface.PlaySound("buttons/button9.wav")
    end

    Ipr_Fps_Booster_Dcb:SetPos(5, 37)
    Ipr_Fps_Booster_Dcb:SetSize(95, 20)
    Ipr_Fps_Booster_Dcb:SetFont( "Ipr_Fps_Booster_Font" )
    Ipr_Fps_Booster_Dcb:SetValue( "Langue : " ..Ipr_FPS_Booster_Call_Lang())
    for k, v in pairs(Ipr_Fps_Booster.Lang) do
    Ipr_Fps_Booster_Dcb:AddChoice( "Langue : " ..k)
    end
    Ipr_Fps_Booster_Dcb:SetTextColor( color_white )
    function Ipr_Fps_Booster_Dcb:Paint(w, h)
        if self:IsHovered() then
            draw.RoundedBox( 6, 0, 0, w, h, Ipr_Fps_Booster_Color["bleuc"])
        else
            draw.RoundedBox( 6, 0, 0, w, h, Ipr_Fps_Booster_Color["bleu"])
        end
    end
    Ipr_Fps_Booster_OverrideDcb(Ipr_Fps_Booster_Dcb)
    Ipr_Fps_Booster_Dcb.OnMenuOpened = function(self)
        for k, v in pairs(self:GetChildren()) do
            v.Paint = function(panel, w, h)
                draw.RoundedBox(6, 0, 0, w, h, Ipr_Fps_Booster_Color["bleu"])
            end
            if (v:GetName() == "DPanel") then
                continue
            end
            for i, d in pairs(v:GetChildren()) do
                if (d:GetName() == "DVScrollBar") then
                   continue
                end
                for h,y in pairs(d:GetChildren()) do
                    y:SetTextColor(color_white)
                    y:SetFont( "Ipr_Fps_Booster_Font" )
                end
            end
        end

        Ipr_Fps_Booster_OverrideDcb(self)
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
        local Ipr_Cur, Ipr_min, Ipr_Max_, Ipr_Gain = Ipr_Fps_Booster_RetVal()
        draw.SimpleTextOutlined("FPS : " ..Ipr_Cur.. " Min : " ..Ipr_min.. " Max : " ..Ipr_Max_.. " Gain : " ..(ipr_statusvgui and Ipr_Gain or "OFF"), "Ipr_Fps_Booster_Font", ScrW() * (Ipr_Fps_Booster_CallConvarSelected(10) / 100),  ScrH() * (Ipr_Fps_Booster_CallConvarSelected(11) / 100), Ipr_Fps_Booster_Color["blanc"], TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Ipr_Fps_Booster_Color["bleu"])
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
