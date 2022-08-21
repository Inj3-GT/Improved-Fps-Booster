----------- // SCRIPT BY INJ3 
----------- // SCRIPT BY INJ3 
----------- // SCRIPT BY INJ3 
---- // https://steamcommunity.com/id/Inj3/

--//--
------------- GNU General Public License v3.0
------------- https://github.com/Inj3-GT
--\\--

local Ipr_Fps_Booster_Vgui, Ipr_Fps_Booster_Opt_Vgui = {}, {}
local Ipr_Fps_Booster_Color = {["gris"] = Color(236, 240, 241),["vert"] = Color(39, 174, 96),["rouge"] = Color(192, 57, 43),["orange"] = Color(243, 156, 18),["blanc"] = Color(236, 240, 241), ["bleu"] = Color(52, 73, 94), ["bleuc"] = Color(30, 73, 109)}
local Ipr_Sys_BlurMat, Ipr_StatusVgui, Ipr_LastMax = Material("pp/blurscreen"), false, 0
local Ipr_Current, Ipr_Max, Ipr_Min, Ipr_Gain, Ipr_CurtLast = 0, 0, math.huge, 0
local Ipr_Save_Location, Ipr_Lang_C = "improved_fps_booster_v3_data/save/"

local function Ipr_FPS_Booster_CountryLang()
    if (Ipr_Fps_Booster.Country[system.GetCountry()]) then
        return "FR"
    end

    return "EN"
end

local function Ipr_Fps_Booster_SaveConvar(ipr_gui, ipr_bool)
    if not IsValid(ipr_gui) then
        return
    end
    
    local ipr_check = ipr_bool and ipr_gui:GetChecked() or not ipr_bool and ipr_gui:GetValue()
    for _, v in ipairs(Ipr_Fps_Booster.Save_Tbl) do
        if (v.Ipr_UniqueNumber == ipr_gui.Ipr_UniqueNumber) then
            v.Ipr_ValueDyn = ipr_check
            break
        end
    end
    file.Write(Ipr_Save_Location.. "_fps_booster_v.txt", util.TableToJSON(Ipr_Fps_Booster.Save_Tbl))
    
    if (ipr_bool) then
        surface.PlaySound("buttons/combine_button1.wav")
    end
end

local function Ipr_Fps_Booster_CallConvar(ipr_gui)
    if not IsValid(ipr_gui) then
        return
    end

    for _, v in ipairs(Ipr_Fps_Booster.Save_Tbl) do
        if (v.Ipr_UniqueNumber == ipr_gui.Ipr_UniqueNumber) then
            return v.Ipr_ValueDyn
        end
    end

    return false, print("*C-error")
end

local function Ipr_Fps_Booster_CallConvarSelected(ipr_nb)
    for _, v in ipairs(Ipr_Fps_Booster.Save_Tbl) do
        if (v.Ipr_UniqueNumber == ipr_nb) then
            return v.Ipr_ValueDyn
        end
    end

    return false, print("*CS-error")
end

local function Ipr_Fps_Booster_CheckLang()
    if (Ipr_Fps_Booster.Save_Lg and Ipr_Fps_Booster.Save_Lg[1]) then
        for l in pairs(Ipr_Fps_Booster.Lang) do
            if (l == Ipr_Fps_Booster.Save_Lg[1]) then
                return true
            end
        end
    end

    return false
end

local function Ipr_Fps_Booster_SaveLang(ipr_lang)
    file.Write(Ipr_Save_Location.. "_fps_booster_lang.txt", util.TableToJSON({ipr_lang}))
    Ipr_Fps_Booster.Save_Lg[1] = ipr_lang
end

local function Ipr_FPS_Booster_Call_Lang()
    if Ipr_Fps_Booster_CheckLang() then
        return Ipr_Fps_Booster.Save_Lg[1]
    end

    return "EN"
end

local function Ipr_Fps_Booster_LoadSx(ipr_nb)
    if (ipr_nb == 1) then
        local Ipr_CountryLang = Ipr_FPS_Booster_CountryLang()
        file.Write(Ipr_Save_Location.. "_fps_booster_lang.txt", util.TableToJSON({Ipr_CountryLang}))
        Ipr_Fps_Booster.Save_Lg[1] = Ipr_CountryLang
    else
        Ipr_Fps_Booster.Save_Tbl = {{Ipr_UniqueNumber = 1, Ipr_ValueDyn = true},{Ipr_UniqueNumber = 2, Ipr_ValueDyn = false},{Ipr_UniqueNumber = 3, Ipr_ValueDyn = true},{Ipr_UniqueNumber = 4, Ipr_ValueDyn = true},{Ipr_UniqueNumber = 5, Ipr_ValueDyn = false},{Ipr_UniqueNumber = 6, Ipr_ValueDyn = false},{Ipr_UniqueNumber = 7, Ipr_ValueDyn = true},{Ipr_UniqueNumber = 8, Ipr_ValueDyn = true},{Ipr_UniqueNumber = 9, Ipr_ValueDyn = false},{Ipr_UniqueNumber = 10, Ipr_ValueDyn = 40},{Ipr_UniqueNumber = 11, Ipr_ValueDyn = 32}}
        file.Write(Ipr_Save_Location.. "_fps_booster_v.txt", util.TableToJSON(Ipr_Fps_Booster.Save_Tbl))
    end
end

local function Ipr_Fps_Booster_CountBox()
    local ipr_count = 0

    for _, v in ipairs(Ipr_Fps_Booster.Save_Tbl) do
        if (Ipr_Fps_Booster.DefautCommand[v.Ipr_UniqueNumber]) then
            local ipr_val = v.Ipr_ValueDyn
            for _, g in pairs(Ipr_Fps_Booster.DefautCommand[v.Ipr_UniqueNumber].Ipr_CmdChild) do
                local ipr_control = (ipr_val and g.Ipr_Enabled) or g.Ipr_Disabled
                if (g.Ipr_Disabled ~= ipr_control) then
                    ipr_count = ipr_count + 1
                end
            end
        end
    end

    if (ipr_count <= 0) then
        return true
    end

    return false
end
    
local function ipr_fps_booster_saveload()
    local ipr_find = file.Find("improved_fps_booster_v3_data/save/*.txt", "DATA")
    if (#ipr_find <= 0) then
        file.CreateDir(Ipr_Save_Location)

        for i = 1, 2 do
            Ipr_Fps_Booster_LoadSx(i)
        end
        return
    end

    if not (ipr_find[1] == "_fps_booster_lang.txt") then
        Ipr_Fps_Booster_LoadSx(1)
    else
        Ipr_Fps_Booster.Save_Lg = util.JSONToTable(file.Read(Ipr_Save_Location.. "_fps_booster_lang.txt", "DATA") or {})
    end

    if not (ipr_find[2] == "_fps_booster_v.txt") then
        Ipr_Fps_Booster_LoadSx(2)
    else
        Ipr_Fps_Booster.Save_Tbl = util.JSONToTable(file.Read(Ipr_Save_Location.. "_fps_booster_v.txt", "DATA") or {})
    end
end

local function Ipr_Fps_Booster_OverrideDcb(ipr_gui, ipr_nb)
    if (ipr_nb == 1) then
        for _, v in pairs(ipr_gui:GetChildren()) do
            if (v:GetName() ~= "DMenu") then
                v.Paint = function(panel, w, h)
                    draw.RoundedBox(12, 9, 6, w - 10, h - 10, Ipr_Fps_Booster_Color["blanc"])
                end
            end
        end
    elseif (ipr_nb == 2) then
        for _, v in pairs(ipr_gui:GetChildren()) do
            if (v:GetName() ~= "DSlider") then
                v:SetFont("Ipr_Fps_Booster_Font")
                v:SetTextColor(Ipr_Fps_Booster_Color["blanc"])
            end
        end
    elseif (ipr_nb == 3) then
        for k, v in pairs(ipr_gui:GetChildren()) do
            if (v:GetName() == "DCheckBox") then
                v.Paint = function(self, w, h)
                    draw.RoundedBox( 6, 0, 0, w, h, self:GetChecked() and Ipr_Fps_Booster_Color["vert"] or Ipr_Fps_Booster_Color["rouge"] )
                    draw.RoundedBox( 12, 7, 7, 2, 2, self:GetChecked() and Ipr_Fps_Booster_Color["blanc"] or color_black )
                end
            end
        end
    elseif (ipr_nb == 4) then
        for k, v in pairs(ipr_gui:GetChildren()) do
            if (v:GetName() == "DSlider") then
                v.Knob.Paint = function(self, w, h)
                    draw.RoundedBox( 12, 0, 0, w, h, Ipr_Fps_Booster_Color["blanc"] )
                end
                v.Paint = function(self, w, h)
                    draw.RoundedBox( 3, 7, h/2 -2, w - 12, h/2 -10, Ipr_Fps_Booster_Color["bleu"] )
                end
            end
        end
    end
end

local function Ipr_Fps_Booster_Enabled_Disabled(ipr_bool)
    local ipr_ply = LocalPlayer()

    if (ipr_bool) then
        for _, v in ipairs(Ipr_Fps_Booster.Save_Tbl) do
            if (Ipr_Fps_Booster.DefautCommand[v.Ipr_UniqueNumber]) then
                local ipr_val = v.Ipr_ValueDyn
                for o, g in pairs(Ipr_Fps_Booster.DefautCommand[v.Ipr_UniqueNumber].Ipr_CmdChild) do
                    local ipr_control = (ipr_val and g.Ipr_Enabled) or g.Ipr_Disabled

                    if (tonumber(ipr_ply:GetInfoNum(o, -99)) ~= -99) then
                        ipr_ply:ConCommand(o.. " " ..ipr_control)
                    end
                end
            end
        end
    else
        for _, g in pairs(Ipr_Fps_Booster.DefautCommand) do
            for d,t in pairs(g.Ipr_CmdChild) do
                ipr_ply:ConCommand(d.. " " ..t.Ipr_Disabled)
            end
        end
    end

    if Ipr_Fps_Booster_CountBox() then
        Ipr_Max, Ipr_Min, Ipr_Gain, Ipr_StatusVgui, Ipr_LastMax = 0, math.huge, 0, false, 0
    end
end

local function Ipr_Fps_Booster_CalculationFps()
    local Ipr_Cur = CurTime()

    if (Ipr_Cur > (Ipr_CurtLast or 0)) then
        Ipr_Current = math.Round(1/RealFrameTime(), 0)
        if (Ipr_Current < Ipr_Min) then
            Ipr_Min = Ipr_Current
        end
        if (Ipr_Current > (Ipr_Max ~= math.huge and Ipr_Max or 0)  ) then
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

local function Ipr_Fps_Booster_Unc(ipr_crypt)
    return util.Base64Decode(ipr_crypt) --- :D
end

local function Ipr_Gui_Blur(ipr_sys_frame, ipr_sys_float, ipr_sys_col, ipr_sys_brd)
    local x, y = ipr_sys_frame:LocalToScreen(0, 0)
    surface.SetDrawColor(255, 255, 255)
    surface.SetMaterial(Ipr_Sys_BlurMat)

    for i = 1, 3 do
         Ipr_Sys_BlurMat:SetFloat("$blur", (i / 3) * ipr_sys_float)
         Ipr_Sys_BlurMat:Recompute()
         render.UpdateScreenEffectTexture()
         surface.DrawTexturedRect(x * -1, y * -1, ScrW(), ScrH())
    end
    draw.RoundedBoxEx( ipr_sys_brd, 0, 0, ipr_sys_frame:GetWide(), ipr_sys_frame:GetTall(), ipr_sys_col, true, true, true, true )
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

    Ipr_Fps_Booster_Opt_Vgui:SetTitle( "" )
    Ipr_Fps_Booster_Opt_Vgui:SetSize(240, 360)
    Ipr_Fps_Booster_Opt_Vgui:SetPos(0, 0)
    Ipr_Fps_Booster_Opt_Vgui:MakePopup()
    Ipr_Fps_Booster_Opt_Vgui:ShowCloseButton(false)
    Ipr_Fps_Booster_Opt_Vgui:SetDraggable(true)
    Ipr_Fps_Booster_Opt_Vgui:AlphaTo(5, 0, 0)
    Ipr_Fps_Booster_Opt_Vgui:AlphaTo(255, 1, 0)
    Ipr_Fps_Booster_Opt_Vgui.Think = function(self)
        if IsValid(panel) then
            local ipr_getpos_x, ipr_getpos_y = panel:GetPos()
            self:SetPos(ipr_getpos_x + 310, ipr_getpos_y + -33)
        end
    end
    Ipr_Fps_Booster_Opt_Vgui.Paint = function( self, w, h )
        Ipr_Gui_Blur(self, 2, Color( 0, 0, 0, 170 ), 8)
        local Ior_Sys_Abs = math.abs(math.sin(CurTime() * 1.5) * 170)

        draw.RoundedBox( 6, 0, 0, w, 20, Ipr_Fps_Booster_Color["bleu"])
        draw.SimpleText("Options FPS Booster","Ipr_Fps_Booster_Font",w/2,1, Ipr_Fps_Booster_Color["blanc"], TEXT_ALIGN_CENTER)
        draw.SimpleText(Ipr_Fps_Booster.Lang[Ipr_Lang_C].ipr_vgui_opti_t,"Ipr_Fps_Booster_Font",w/2,50, Ipr_Fps_Booster_Color["blanc"], TEXT_ALIGN_CENTER)
        draw.SimpleText("Configuration :","Ipr_Fps_Booster_Font",w/2,h-145, Ipr_Fps_Booster_Color["blanc"], TEXT_ALIGN_CENTER)
        draw.SimpleText(Ipr_Fps_Booster.Version.. "" ..Ipr_Fps_Booster_Unc("IGJ5IEluajM="),"Ipr_Fps_Booster_Font", w-5,h-17, Color(Ior_Sys_Abs, Ior_Sys_Abs, Ior_Sys_Abs), TEXT_ALIGN_RIGHT)
        draw.SimpleText(Ipr_Fps_Booster.Lang[Ipr_Lang_C].ipr_vgui_posw_t,"Ipr_Fps_Booster_Font",w/2+2,h-100, Ipr_Fps_Booster_Color["blanc"], TEXT_ALIGN_CENTER)
        draw.SimpleText(Ipr_Fps_Booster.Lang[Ipr_Lang_C].ipr_vgui_posh_t,"Ipr_Fps_Booster_Font",w/2+2,h-60, Ipr_Fps_Booster_Color["blanc"], TEXT_ALIGN_CENTER)
    end

    Ipr_Fps_Booster_Dscroll:Dock(FILL)
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
        Ipr_Fps_Booster_DChb:SetText("")
        Ipr_Fps_Booster_DChb.Ipr_UniqueNumber = i
        Ipr_Fps_Booster_DChb:SetValue(Ipr_Fps_Booster_CallConvar(Ipr_Fps_Booster_DChb))
        Ipr_Fps_Booster_DChb:SetTooltip(Ipr_Fps_Booster.DefautCommand[i].Ipr_ToolTip[Ipr_Lang_C])
        Ipr_Fps_Booster_DChb:SetWide(200)
        function Ipr_Fps_Booster_DChb:Paint(w, h)
            draw.SimpleText(Ipr_Fps_Booster.DefautCommand[i].Ipr_Texte[Ipr_Lang_C], "Ipr_Fps_Booster_Font", 22, 0, Ipr_Fps_Booster_Color["blanc"], TEXT_ALIGN_LEFT)
        end
        Ipr_Fps_Booster_DChb.OnChange = function(self)
            Ipr_Fps_Booster_SaveConvar(self, true)
        end
        Ipr_Fps_Booster_OverrideDcb(Ipr_Fps_Booster_DChb, 3)
    end    

    Ipr_Fps_Booster_DChb_ShowHud:SetPos(50, 236)
    Ipr_Fps_Booster_DChb_ShowHud:SetText("")
    Ipr_Fps_Booster_DChb_ShowHud.Ipr_UniqueNumber = #Ipr_Fps_Booster.DefautCommand + 1
    Ipr_Fps_Booster_DChb_ShowHud:SetValue(Ipr_Fps_Booster_CallConvar(Ipr_Fps_Booster_DChb_ShowHud))
    Ipr_Fps_Booster_DChb_ShowHud:SetTooltip(Ipr_Fps_Booster.Lang[Ipr_Lang_C].ipr_vgui_hudshow_tx)
    Ipr_Fps_Booster_DChb_ShowHud:SetWide(200)
    function Ipr_Fps_Booster_DChb_ShowHud:Paint(w, h)
        draw.SimpleText(Ipr_Fps_Booster.Lang[Ipr_Lang_C].ipr_vgui_hudshow_t, "Ipr_Fps_Booster_Font", 22, 0, Ipr_Fps_Booster_Color["blanc"], TEXT_ALIGN_LEFT)
    end
    Ipr_Fps_Booster_DChb_ShowHud.OnChange = function(self)
        Ipr_Fps_Booster_SaveConvar(self, true)
    end
    Ipr_Fps_Booster_OverrideDcb(Ipr_Fps_Booster_DChb_ShowHud, 3)

    Ipr_Fps_Booster_PosW:SetPos( -160, 275 )
    Ipr_Fps_Booster_PosW:SetSize(415, 25 )
    Ipr_Fps_Booster_PosW:SetText( "" )
    Ipr_Fps_Booster_PosW:SetMinMax(0, 100)
    Ipr_Fps_Booster_PosW.Ipr_UniqueNumber = 10
    Ipr_Fps_Booster_PosW:SetValue(Ipr_Fps_Booster_CallConvar(Ipr_Fps_Booster_PosW))
    Ipr_Fps_Booster_PosW:SetDecimals(0)
    Ipr_Fps_Booster_OverrideDcb(Ipr_Fps_Booster_PosW, 2)
    Ipr_Fps_Booster_PosW.OnValueChanged = function(self, val)
        Ipr_Fps_Booster_SaveConvar(self, false)
    end
    Ipr_Fps_Booster_OverrideDcb(Ipr_Fps_Booster_PosW, 4)

    Ipr_Fps_Booster_PosH:SetPos( -160, 315)
    Ipr_Fps_Booster_PosH:SetSize(415, 25)
    Ipr_Fps_Booster_PosH:SetText("")
    Ipr_Fps_Booster_PosH:SetMinMax(0, 100)
    Ipr_Fps_Booster_PosH.Ipr_UniqueNumber = 11
    Ipr_Fps_Booster_PosH:SetValue(Ipr_Fps_Booster_CallConvar(Ipr_Fps_Booster_PosH))
    Ipr_Fps_Booster_PosH:SetDecimals(0)
    Ipr_Fps_Booster_OverrideDcb(Ipr_Fps_Booster_PosH, 2)
    Ipr_Fps_Booster_PosH.OnValueChanged = Ipr_Fps_Booster_PosW.OnValueChanged
    Ipr_Fps_Booster_OverrideDcb(Ipr_Fps_Booster_PosH, 4)

    Ipr_Fps_Booster_Exp:SetPos(221, 2)
    Ipr_Fps_Booster_Exp:SetSize(17, 17)
    Ipr_Fps_Booster_Exp:SetImage("icon16/cross.png")
    function Ipr_Fps_Booster_Exp:Paint(w, h) end
    Ipr_Fps_Booster_Exp.DoClick = function()
        local ipr_gx, ipr_gxy = panel:GetPos()
        panel:SetPos(ipr_gx + 100, ipr_gxy)

        if IsValid(Ipr_Fps_Booster_Opt_Vgui) then
        Ipr_Fps_Booster_Opt_Vgui:Remove()
        end
    end

    Ipr_Fps_Booster_SaveLoad:SetPos(61, 26)
    Ipr_Fps_Booster_SaveLoad:SetSize(120, 18)
    Ipr_Fps_Booster_SaveLoad:SetText("")
    Ipr_Fps_Booster_SaveLoad:SetImage( "icon16/arrow_rotate_clockwise.png" )
    function Ipr_Fps_Booster_SaveLoad:Paint(w, h)
        if self:IsHovered() then
            draw.RoundedBox( 6, 0, 0, w, h, Ipr_Fps_Booster_Color["bleuc"])
        else
            draw.RoundedBox( 6, 0, 0, w, h, Ipr_Fps_Booster_Color["bleu"])
        end
        draw.SimpleText(Ipr_Fps_Booster.Lang[Ipr_Lang_C].ipr_vgui_LoadS, "Ipr_Fps_Booster_Font", w / 2 + 6, 1, Ipr_Fps_Booster_Color["blanc"], TEXT_ALIGN_CENTER)
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
    if IsValid(Ipr_Fps_Booster_Opt_Vgui) then
        Ipr_Fps_Booster_Opt_Vgui:Remove()
    end
    if IsValid(Ipr_Fps_Booster_Vgui) then
        Ipr_Fps_Booster_Vgui:Remove()
    end

    Ipr_Fps_Booster_Vgui = vgui.Create( "DFrame" )
    local Ipr_Fps_Booster_Vgui_Dp = vgui.Create( "DPropertySheet", Ipr_Fps_Booster_Vgui )
    local Ipr_Fps_Booster_Vgui_HT = vgui.Create( "HTML", Ipr_Fps_Booster_Vgui_Dp )
    local Ipr_Fps_Booster_Exp = vgui.Create("DImageButton", Ipr_Fps_Booster_Vgui)
    local Ipr_Fps_Booster_Vgui_HTurl = vgui.Create("DButton", Ipr_Fps_Booster_Vgui)
    local Ipr_Fps_Booster_En = vgui.Create("DButton", Ipr_Fps_Booster_Vgui)
    local Ipr_Fps_Booster_Di = vgui.Create("DButton", Ipr_Fps_Booster_Vgui)
    local Ipr_Fps_Booster_Opt = vgui.Create("DButton", Ipr_Fps_Booster_Vgui)
    local Ipr_Fps_Booster_Res = vgui.Create("DButton", Ipr_Fps_Booster_Vgui)
    local Ipr_Fps_Booster_Dcb = vgui.Create( "DComboBox", Ipr_Fps_Booster_Vgui)
    Ipr_Lang_C = Ipr_FPS_Booster_Call_Lang()

    Ipr_Fps_Booster_Vgui:SetTitle( "" )
    Ipr_Fps_Booster_Vgui:SetSize(300, 290)
    Ipr_Fps_Booster_Vgui:MakePopup()
    Ipr_Fps_Booster_Vgui:ShowCloseButton(false)
    Ipr_Fps_Booster_Vgui:SetDraggable(true)
    Ipr_Fps_Booster_Vgui:Center()
    Ipr_Fps_Booster_Vgui:AlphaTo(5, 0, 0)
    Ipr_Fps_Booster_Vgui:AlphaTo(255, 1, 0)
    Ipr_Fps_Booster_Vgui.Paint = function( self, w, h )
        Ipr_Gui_Blur(self, 2, Color( 0, 0, 0, 170 ), 8)
        Ipr_Lang_C = Ipr_FPS_Booster_Call_Lang()

        draw.RoundedBox( 6, 0, 0, w, 33, Ipr_Fps_Booster_Color["bleu"])
        draw.SimpleText(Ipr_Fps_Booster.Lang[Ipr_Lang_C].ipr_vgui_enabled,"Ipr_Fps_Booster_Font",w/2,1, Ipr_Fps_Booster_Color["blanc"], TEXT_ALIGN_CENTER)
        draw.SimpleText("FPS :","Ipr_Fps_Booster_Font",(Ipr_StatusVgui and w/2 -25) or w/2 -10,16, Ipr_Fps_Booster_Color["blanc"], TEXT_ALIGN_CENTER)
        draw.SimpleText((Ipr_StatusVgui and "On (Boost)") or "Off", "Ipr_Fps_Booster_Font",(Ipr_StatusVgui and w/2 + 22) or w/2 + 18,16, Ipr_StatusVgui and Ipr_Fps_Booster_Color["vert"] or Ipr_Fps_Booster_Color["rouge"], TEXT_ALIGN_CENTER)
    end 
  
    Ipr_Fps_Booster_Vgui_Dp:Dock( FILL )
    Ipr_Fps_Booster_Vgui_Dp:DockPadding( 52, 10, 0, 0)

    do
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
        Ipr_Fps_Booster_Vgui_Dp.Paint = function (self, w, h)
            local Ipr_Cur, Ipr_Min, Ipr_Max_, Ipr_Gain = Ipr_Fps_Booster_CalculationFps()
            draw.SimpleText("FPS Status","Ipr_Fps_Booster_Font",w/2,h/2-71, Ipr_Fps_Booster_Color["blanc"], TEXT_ALIGN_CENTER)
            draw.SimpleText(Ipr_Fps_Booster.Lang[Ipr_Lang_C].ipr_vgui_fps_cur,"Ipr_Fps_Booster_Font",w/2-10,h/2-55, Ipr_Fps_Booster_Color["blanc"], TEXT_ALIGN_CENTER)
            draw.SimpleText(Ipr_Cur, "Ipr_Fps_Booster_Font",w/2+15,h/2-55, Ipr_Fps_Booster_RgbTransition(Ipr_Cur), TEXT_ALIGN_LEFT)
            draw.SimpleText("Max : ","Ipr_Fps_Booster_Font",w/2-10,h/2-40, Ipr_Fps_Booster_Color["blanc"], TEXT_ALIGN_CENTER)
            draw.SimpleText(Ipr_Max_,"Ipr_Fps_Booster_Font",w/2+10,h/2-40, Ipr_Fps_Booster_RgbTransition(Ipr_Max_), TEXT_ALIGN_LEFT)
            draw.SimpleText("Min : ","Ipr_Fps_Booster_Font",w/2-10,h/2-25, Ipr_Fps_Booster_Color["blanc"], TEXT_ALIGN_CENTER)
            draw.SimpleText(Ipr_Min,"Ipr_Fps_Booster_Font",w/2+10,h/2-25, Ipr_Fps_Booster_RgbTransition(Ipr_Min), TEXT_ALIGN_LEFT)
            draw.SimpleText("Gain : ","Ipr_Fps_Booster_Font",w/2-10, h/2-10, Ipr_Fps_Booster_Color["blanc"], TEXT_ALIGN_CENTER)
            draw.SimpleText((Ipr_StatusVgui and (Ipr_Max ~= Ipr_Gain) and Ipr_Gain or "OFF"),"Ipr_Fps_Booster_Font",w/2+10, h/2-10, Ipr_StatusVgui and (Ipr_Max ~= Ipr_Gain) and Ipr_Fps_Booster_Color["vert"] or Ipr_Fps_Booster_Color["rouge"], TEXT_ALIGN_LEFT)
        end
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

    Ipr_Fps_Booster_En:SetPos(6, 259)
    Ipr_Fps_Booster_En:SetSize(110, 24)
    Ipr_Fps_Booster_En:SetImage( "icon16/tick.png" )
    Ipr_Fps_Booster_En:SetText("")
    function Ipr_Fps_Booster_En:Paint(w, h)
        if self:IsHovered() then
            draw.RoundedBox( 6, 0, 0, w, h, Ipr_Fps_Booster_Color["bleuc"])
        else
            draw.RoundedBox( 6, 0, 0, w, h, Ipr_Fps_Booster_Color["bleu"] )
        end
        draw.SimpleText(Ipr_Fps_Booster.Lang[Ipr_Lang_C].ipr_vgui_enable_t, "Ipr_Fps_Booster_Font", w / 2 + 3, 3, Ipr_Fps_Booster_Color["blanc"], TEXT_ALIGN_CENTER)
    end
    Ipr_Fps_Booster_En.DoClick = function()
        if Ipr_Fps_Booster_CountBox() then
        Ipr_Max, Ipr_Min, Ipr_Gain, Ipr_StatusVgui, Ipr_LastMax = 0, math.huge, 0, false, 0
        chat.AddText(Ipr_Fps_Booster_Color["rouge"], "[", "FPS Booster", "] : ", Ipr_Fps_Booster_Color["blanc"], "Please check boxes in optimization to activate the fps booster !")
            return 
        end
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

    Ipr_Fps_Booster_Di:SetPos(184, 259)
    Ipr_Fps_Booster_Di:SetSize(110, 24)
    Ipr_Fps_Booster_Di:SetImage( "icon16/cross.png" )
    Ipr_Fps_Booster_Di:SetText("")
    function Ipr_Fps_Booster_Di:Paint(w, h)
        if self:IsHovered() then
            draw.RoundedBox( 6, 0, 0, w, h, Ipr_Fps_Booster_Color["bleuc"])
        else
            draw.RoundedBox( 6, 0, 0, w, h, Ipr_Fps_Booster_Color["bleu"])
        end
        draw.SimpleText(Ipr_Fps_Booster.Lang[Ipr_Lang_C].ipr_vgui_disable_t, "Ipr_Fps_Booster_Font", w / 2 + 6, 3, Ipr_Fps_Booster_Color["blanc"], TEXT_ALIGN_CENTER)
    end
    Ipr_Fps_Booster_Di.DoClick = function()
        Ipr_Max, Ipr_Min, Ipr_Gain, Ipr_StatusVgui, Ipr_LastMax = 0, math.huge, 0, false, 0
        Ipr_Fps_Booster_Enabled_Disabled(false)

        chat.AddText(Ipr_Fps_Booster_Color["rouge"], "[", "FPS Booster", "] : ", Ipr_Fps_Booster_Color["blanc"], Ipr_Fps_Booster.Lang[Ipr_Lang_C].ipr_vgui_disableop_t)
        Ipr_Fps_Booster_Vgui:Remove()
        if IsValid(Ipr_Fps_Booster_Opt_Vgui) then
            Ipr_Fps_Booster_Opt_Vgui:Remove()
        end
        surface.PlaySound("buttons/combine_button5.wav")
    end

    Ipr_Fps_Booster_Opt:SetPos(200, 38)
    Ipr_Fps_Booster_Opt:SetSize(95, 20)
    Ipr_Fps_Booster_Opt:SetText("")
    Ipr_Fps_Booster_Opt:SetImage( "icon16/cog.png" )
    function Ipr_Fps_Booster_Opt:Paint(w, h)
        if self:IsHovered() then
            draw.RoundedBox( 6, 0, 0, w, h, Ipr_Fps_Booster_Color["bleuc"])
        else
            draw.RoundedBox( 6, 0, 0, w, h, Ipr_Fps_Booster_Color["bleu"])
        end
        draw.SimpleText("Options ", "Ipr_Fps_Booster_Font", w / 2 + 7, 1, Ipr_Fps_Booster_Color["blanc"], TEXT_ALIGN_CENTER)
    end
    Ipr_Fps_Booster_Opt.DoClick = function()
        if IsValid(Ipr_Fps_Booster_Opt_Vgui) then
            return
        end
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
        draw.SimpleText("Reset FPS max/min", "Ipr_Fps_Booster_Font", w / 2 + 7, 1, Ipr_Fps_Booster_Color["blanc"], TEXT_ALIGN_CENTER)
    end
    Ipr_Fps_Booster_Res.DoClick = function()
        Ipr_Max, Ipr_Min, Ipr_Gain = 0, math.huge, 0
        surface.PlaySound("buttons/button9.wav")
    end

    Ipr_Fps_Booster_Dcb:SetPos(5, 38)
    Ipr_Fps_Booster_Dcb:SetSize(105, 20)
    Ipr_Fps_Booster_Dcb:SetFont( "Ipr_Fps_Booster_Font" )
    Ipr_Fps_Booster_Dcb:SetValue(Ipr_Fps_Booster.Lang[Ipr_Lang_C].ipr_vgui_Lang.. " " ..Ipr_Lang_C)
    for lang in pairs(Ipr_Fps_Booster.Lang) do
    Ipr_Fps_Booster_Dcb:AddChoice(Ipr_Fps_Booster.Lang[Ipr_Lang_C].ipr_vgui_Lang.. " " ..lang)
    end
    Ipr_Fps_Booster_Dcb:SetTextColor( Ipr_Fps_Booster_Color["blanc"] )
    function Ipr_Fps_Booster_Dcb:Paint(w, h)
        if self:IsHovered() then
            draw.RoundedBox( 6, 0, 0, w, h, Ipr_Fps_Booster_Color["bleuc"])
        else
            draw.RoundedBox( 6, 0, 0, w, h, Ipr_Fps_Booster_Color["bleu"])
        end
    end
    Ipr_Fps_Booster_OverrideDcb(Ipr_Fps_Booster_Dcb, 1)
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
                    y:SetTextColor(Ipr_Fps_Booster_Color["blanc"])
                    y:SetFont( "Ipr_Fps_Booster_Font" )
                end
            end
        end

        Ipr_Fps_Booster_OverrideDcb(self, 1)
    end
    Ipr_Fps_Booster_Dcb.OnSelect = function( self, index, value )
        local ipr_lang_cf = Ipr_Fps_Booster.Lang[Ipr_Lang_C].ipr_vgui_Lang.. " "
        ipr_lang_cf = string.Replace(value, ipr_lang_cf, "")
        if (ipr_lang_cf == Ipr_Lang_C) then
            return
        end
        Ipr_Fps_Booster_SaveLang(ipr_lang_cf)
        surface.PlaySound("buttons/button9.wav")
    
        self:Clear()
        local Ipr_Call = Ipr_FPS_Booster_Call_Lang()
        self:SetValue(Ipr_Fps_Booster.Lang[Ipr_Call].ipr_vgui_Lang.. " " ..Ipr_Call)
        for lang in pairs(Ipr_Fps_Booster.Lang) do
            self:AddChoice(Ipr_Fps_Booster.Lang[Ipr_Call].ipr_vgui_Lang.. " " ..lang)
        end
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

local function ipr_fps_booster_op(ipr_bool)
    if (ipr_bool) then
        Ipr_Fps_Booster_Vgui_Func()
    else
        Ipr_Fps_Booster_Enabled_Disabled(false)
    end
end
 
hook.Add("PostDrawHUD","Ipr_Fps_Booster_PostDraw", function()
    if (Ipr_Fps_Booster.Loaded_Lua and Ipr_Fps_Booster_CallConvarSelected(9)) then
        local Ipr_Cur, Ipr_Min, Ipr_Max_, Ipr_Gain = Ipr_Fps_Booster_CalculationFps()
        
        draw.SimpleTextOutlined("FPS : " ..Ipr_Cur.. " Min : " ..Ipr_Min.. " Max : " ..Ipr_Max_.. " Gain : " ..(Ipr_StatusVgui and (Ipr_Max ~= Ipr_Gain) and Ipr_Gain or "OFF"), "Ipr_Fps_Booster_Font", ScrW() * (Ipr_Fps_Booster_CallConvarSelected(10) / 100) - 40,  ScrH() * (Ipr_Fps_Booster_CallConvarSelected(11) / 100) - 10, Ipr_Fps_Booster_Color["blanc"], TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT, 0.8, Ipr_Fps_Booster_Color["bleu"])
    end
end)

do
    local function ipr_fps_booster_ft_load()
        for _, v in ipairs(Ipr_Fps_Booster.Save_Tbl) do
            if (Ipr_Fps_Booster.DefautCommand[v.Ipr_UniqueNumber]) then
                local ipr_val = v.Ipr_ValueDyn
                for o, g in pairs(Ipr_Fps_Booster.DefautCommand[v.Ipr_UniqueNumber].Ipr_CmdChild) do
                    local ipr_control = (ipr_val and g.Ipr_Enabled) or g.Ipr_Disabled
                    if (o == "M9KGasEffect") then
                      continue
                    end
                    if tonumber(ipr_control) ~= tonumber(LocalPlayer():GetInfoNum(o, 0)) then
                        return true
                    end
                end
            end
        end

        return false
    end

    local function Ipr_Fps_Booster_CheckString(ipr_sys_string, ipr_sys_cmd)
        if string.sub( string.lower( ipr_sys_string ), 1, string.len(string.lower( ipr_sys_cmd )) + 1 ) == string.lower( ipr_sys_cmd ) then
            return true
        end

        return false
    end

    hook.Add( "OnPlayerChat", "Ipr_Fps_Booster_Chat_Vgui", function( ply, strText, bTeam, bDead )
        if (ply ~= LocalPlayer()) then
            return
        end

        if Ipr_Fps_Booster_CheckString(strText, "/boost")  then
            return true, ipr_fps_booster_op(true)
        end
        if Ipr_Fps_Booster_CheckString(strText, "/reset") then
            if not ipr_fps_booster_ft_load() then
                Ipr_Max, Ipr_Min, Ipr_Gain, Ipr_StatusVgui, Ipr_LastMax = 0, math.huge, 0, false, 0
                surface.PlaySound("buttons/combine_button5.wav")
                return true, ipr_fps_booster_op(false)
            else
                chat.AddText(Ipr_Fps_Booster_Color["rouge"], "[", "Improved FPS Booster", "] : ", Ipr_Fps_Booster_Color["blanc"], "Already disabled !")
                return true
            end
        end
    end)

    hook.Add( "InitPostEntity", "Ipr_Fps_Booster_Spawn_Vgui", function()
        ipr_fps_booster_saveload()

        if ipr_fps_booster_ft_load() then
            timer.Simple(5, function()
                ipr_fps_booster_op(true)
            end)
        else
            Ipr_Max, Ipr_Min, Ipr_StatusVgui = 0, math.huge, true
            chat.AddText(Ipr_Fps_Booster_Color["rouge"], "[", "Improved FPS Booster", "] : ", Ipr_Fps_Booster_Color["blanc"], "The fps booster started automatically !")
        end
        Ipr_Fps_Booster.Loaded_Lua = true
    end)
end
