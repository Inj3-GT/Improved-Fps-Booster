----------- // SCRIPT BY INJ3 
----------- // SCRIPT BY INJ3 
----------- // SCRIPT BY INJ3 
---- // https://steamcommunity.com/id/Inj3/

--//--
------------- GNU General Public License v3.0
------------- https://github.com/Inj3-GT
--\\--
local function IprFpsBooster_ConvControl(t, g, b, n)
    local ipr_debug = true

    if (t == 1) then
        if not IsValid(g) then
            return
        end
        local ipr_check = b and g:GetChecked() or not b and g:GetValue()

        for _, v in ipairs(Ipr_Fps_Booster.Save_Tbl) do
            if (v.ipr_unumb == g.ipr_unumb) then
                v.ipr_vld = ipr_check
                break
            end
        end
        file.Write(Ipr_Fps_Booster.SaveLocation.. "_save.json", util.TableToJSON(Ipr_Fps_Booster.Save_Tbl))

        if (b) then
            surface.PlaySound("buttons/combine_button1.wav")
        end
    elseif (t == 2) then
        if not IsValid(g) then
            return
        end
        for _, v in ipairs(Ipr_Fps_Booster.Save_Tbl) do
            if (v.ipr_unumb == g.ipr_unumb) then
                return v.ipr_vld
            end
        end

        return false, (ipr_debug) and print("*C-error")
    elseif (t == 3) then
        for _, v in ipairs(Ipr_Fps_Booster.Save_Tbl) do
            if (v.ipr_unumb == n) then
                return v.ipr_vld
            end
        end

        return false, (ipr_debug) and print("*CS-error")
    else
        if (Ipr_Fps_Booster.Save_Lg and Ipr_Fps_Booster.Save_Lg[1]) then
            for l in pairs(Ipr_Fps_Booster.Lang) do
                if (l == Ipr_Fps_Booster.Save_Lg[1]) then
                    return Ipr_Fps_Booster.Save_Lg[1]
                end
            end
        end

        return Ipr_Fps_Booster.DefaultLanguage
    end
end

local Ipr_Fps_Booster_Color = {["gris"] = Color(236, 240, 241),["vert"] = Color(39, 174, 96),["rouge"] = Color(192, 57, 43),["orange"] = Color(243, 156, 18),["blanc"] = Color(236, 240, 241), ["bleu"] = Color(52, 73, 94), ["bleuc"] = Color(30, 73, 109)}
local function IprFpsBooster_OverDcb(g, n)
    if (n == 1) then
        for _, v in ipairs(g:GetChildren()) do
            if (v:GetName() ~= "DMenu") then
                v.Paint = function(panel, w, h)
                    draw.RoundedBox(12, 9, 6, w - 10, h - 10, Ipr_Fps_Booster_Color["blanc"])
                end
            end
        end
    elseif (n == 2) then
        for _, v in ipairs(g:GetChildren()) do
            if (v:GetName() ~= "DSlider") then
                v:SetFont("Ipr_Fps_Booster_Font")
                v:SetTextColor(Ipr_Fps_Booster_Color["blanc"])
            end
        end
    elseif (n == 3) then
        for _, v in ipairs(g:GetChildren()) do
            if (v:GetName() == "DCheckBox") then
                v.Paint = function(self, w, h)
                    draw.RoundedBox( 6, 0, 0, w, h, self:GetChecked() and Ipr_Fps_Booster_Color["vert"] or Ipr_Fps_Booster_Color["rouge"] )
                    draw.RoundedBox( 12, 7, 7, 2, 2, self:GetChecked() and Ipr_Fps_Booster_Color["blanc"] or color_black )
                end
            end
        end
    elseif (n == 4) then
        for _, v in ipairs(g:GetChildren()) do
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

local function IprFpsBooster_LoadChb(b)
    local ipr_count = 0
    for _, v in ipairs(Ipr_Fps_Booster.Save_Tbl) do
        if (Ipr_Fps_Booster.DefautCommand[v.ipr_unumb]) then
            local ipr_val = v.ipr_vld
            for o, g in pairs(Ipr_Fps_Booster.DefautCommand[v.ipr_unumb].Ipr_CmdChild) do
                local ipr_control = (ipr_val and g.Ipr_Enabled) or g.Ipr_Disabled
                
            if (b) then
                if (g.Ipr_Disabled ~= ipr_control) then
                    ipr_count = ipr_count + 1
                end
            else
                if (o == "M9KGasEffect") then
                    continue
                end
                if tonumber(ipr_control) ~= tonumber(LocalPlayer():GetInfoNum(o, 0)) then
                    return true
                end
            end
            end
        end
    end
    if (b) and (ipr_count <= 0) then
        return true
    end

    return false
end

local function IprFpsBooster_CheckConv(v)
    if (tonumber(LocalPlayer():GetInfoNum(v, -99)) ~= -99) then
        return true
    end

    return false
end

local Ipr_StatusVgui, Ipr_LastMx = false, 0
local function IprFpsBooster_Enable(b)
    local ipr_ply = LocalPlayer()

    if (b) then
        for _, v in ipairs(Ipr_Fps_Booster.Save_Tbl) do
            if (Ipr_Fps_Booster.DefautCommand[v.ipr_unumb]) then
                local ipr_val = v.ipr_vld
                for o, g in pairs(Ipr_Fps_Booster.DefautCommand[v.ipr_unumb].Ipr_CmdChild) do
                    local ipr_control = (ipr_val and g.Ipr_Enabled) or g.Ipr_Disabled
                    if IprFpsBooster_CheckConv(o) then
                        ipr_ply:ConCommand(o.. " " ..ipr_control)
                    end
                end
            end
        end
    else
        for _, g in pairs(Ipr_Fps_Booster.DefautCommand) do
            for d,t in pairs(g.Ipr_CmdChild) do
                if IprFpsBooster_CheckConv(d) then
                    ipr_ply:ConCommand(d.. " " ..t.Ipr_Disabled)
                end
            end
        end
    end

    if IprFpsBooster_LoadChb(true) then
        Ipr_Mx, Ipr_Mn, Ipr_Gn, Ipr_StatusVgui, Ipr_LastMx = 0, math.huge, 0, false, 0
    end
end

local Ipr_Mx, Ipr_Mn, Ipr_Gn, Ipr_CLast, Ipr_Cr = 0, math.huge, 0
local function IprFpsBooster_CalcFps()
    local Ipr_ = CurTime()

    if (Ipr_ > (Ipr_CLast or 0)) then
        Ipr_Cr = math.Round(1/RealFrameTime(), 0)
        if (Ipr_Cr < Ipr_Mn) then
            Ipr_Mn = Ipr_Cr
        end
        if (Ipr_Cr > (Ipr_Mx ~= math.huge and Ipr_Mx or 0)) then
            Ipr_Mx = Ipr_Cr
        end
        if not Ipr_StatusVgui then
            Ipr_LastMx = Ipr_Mx
        end
        if (Ipr_Mx > Ipr_LastMx) then
            Ipr_Gn = Ipr_Mx - Ipr_LastMx
        end
        Ipr_CLast = Ipr_ + 0.3
    end

    return Ipr_Cr, Ipr_Mn, Ipr_Mx, Ipr_Gn
end

local Ipr_Sys_BlurMat = Material("pp/blurscreen")
local function IprFpsBooster_GuiBlur(f, fl, c, br) 
    surface.SetDrawColor(255, 255, 255)
    surface.SetMaterial(Ipr_Sys_BlurMat)

    local x, y = f:LocalToScreen(0, 0)
    for i = 1, 3 do
         Ipr_Sys_BlurMat:SetFloat("$blur", (i / 3) * fl)
         Ipr_Sys_BlurMat:Recompute()
         render.UpdateScreenEffectTexture()
         surface.DrawTexturedRect(x * -1, y * -1, ScrW(), ScrH())
    end
    
    draw.RoundedBoxEx(br, 0, 0, f:GetWide(), f:GetTall(), c, true, true, true, true)
end

local Ipr_Fps_Booster_Opt_Vgui, Ipr_Lang_C = {}
local function Ipr_Booster_Option_Func(p)
    if IsValid(p) and not IsValid(Ipr_Fps_Booster_Opt_Vgui) then
        local ipr_gx, ipr_gxy = p:GetPos()
        p:SetPos(ipr_gx - 100, ipr_gxy)
    end
    if IsValid(Ipr_Fps_Booster_Opt_Vgui) then
        Ipr_Fps_Booster_Opt_Vgui:Remove()
    end

    Ipr_Fps_Booster_Opt_Vgui = vgui.Create( "DFrame" )
    local Ipr_Fps_Booster_Exp = vgui.Create("DImageButton", Ipr_Fps_Booster_Opt_Vgui)
    local Ipr_Fps_Booster_SaveLoad = vgui.Create("DButton", Ipr_Fps_Booster_Opt_Vgui)
    local Ipr_Fps_Booster_Dscroll = vgui.Create( "DScrollPanel", Ipr_Fps_Booster_Opt_Vgui)
    local Ipr_Fps_Booster_DChb_ShowHud = vgui.Create( "DCheckBoxLabel", Ipr_Fps_Booster_Opt_Vgui)
    local Ipr_Fps_Booster_Cls_a = vgui.Create( "DCheckBoxLabel", Ipr_Fps_Booster_Opt_Vgui)
    local Ipr_Fps_Booster_PosW = vgui.Create( "DNumSlider", Ipr_Fps_Booster_Opt_Vgui)
    local Ipr_Fps_Booster_PosH = vgui.Create( "DNumSlider", Ipr_Fps_Booster_Opt_Vgui)

    Ipr_Fps_Booster_Opt_Vgui:SetTitle( "" )
    Ipr_Fps_Booster_Opt_Vgui:SetSize(240, 400)
    Ipr_Fps_Booster_Opt_Vgui:SetPos(0, 0)
    Ipr_Fps_Booster_Opt_Vgui:MakePopup()
    Ipr_Fps_Booster_Opt_Vgui:ShowCloseButton(false)
    Ipr_Fps_Booster_Opt_Vgui:SetDraggable(true)
    Ipr_Fps_Booster_Opt_Vgui:AlphaTo(5, 0, 0)
    Ipr_Fps_Booster_Opt_Vgui:AlphaTo(255, 1, 0)
    Ipr_Fps_Booster_Opt_Vgui.Think = function(self)
        if IsValid(p) then
            local ipr_getpos_x, ipr_getpos_y = p:GetPos()
            self:SetPos(ipr_getpos_x + 310, ipr_getpos_y + -60)
        end
    end
    Ipr_Fps_Booster_Opt_Vgui.Paint = function( self, w, h )
        IprFpsBooster_GuiBlur(self, 2, Color( 0, 0, 0, 170 ), 8)
        local Ior_Sys_Abs = math.abs(math.sin(CurTime() * 1.5) * 170)

        draw.RoundedBoxEx(6, 0, 0, w, 20, Ipr_Fps_Booster_Color["bleu"], true, true, false, false)
        draw.SimpleText("Options FPS Booster","Ipr_Fps_Booster_Font",w/2,1, Ipr_Fps_Booster_Color["blanc"], TEXT_ALIGN_CENTER)
        draw.SimpleText(Ipr_Fps_Booster.Lang[Ipr_Lang_C].ipr_vgui_opti_t,"Ipr_Fps_Booster_Font",w/2,50, Ipr_Fps_Booster_Color["blanc"], TEXT_ALIGN_CENTER)
        draw.SimpleText("Configuration :","Ipr_Fps_Booster_Font",w/2,h-175, Ipr_Fps_Booster_Color["blanc"], TEXT_ALIGN_CENTER)
        draw.SimpleText(Ipr_Fps_Booster.Version.. " By Inj3","Ipr_Fps_Booster_Font", w-5,h-17, Color(Ior_Sys_Abs, Ior_Sys_Abs, Ior_Sys_Abs), TEXT_ALIGN_RIGHT)
        draw.SimpleText(Ipr_Fps_Booster.Lang[Ipr_Lang_C].ipr_vgui_posw_t,"Ipr_Fps_Booster_Font",w/2+2,h-105, Ipr_Fps_Booster_Color["blanc"], TEXT_ALIGN_CENTER)
        draw.SimpleText(Ipr_Fps_Booster.Lang[Ipr_Lang_C].ipr_vgui_posh_t,"Ipr_Fps_Booster_Font",w/2+2,h-60, Ipr_Fps_Booster_Color["blanc"], TEXT_ALIGN_CENTER)
    end

    Ipr_Fps_Booster_Dscroll:Dock(FILL)
    Ipr_Fps_Booster_Dscroll:DockMargin(0, 40, 0, 180)

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

    local ipr_tbl_add = #Ipr_Fps_Booster.DefautCommand
    for i = 1, ipr_tbl_add do
        local Ipr_Fps_Booster_DChb = vgui.Create( "DCheckBoxLabel", Ipr_Fps_Booster_Dscroll)
        Ipr_Fps_Booster_DChb:SetPos( 10, i * (1+ 22) -22)
        Ipr_Fps_Booster_DChb:SetText("")
        Ipr_Fps_Booster_DChb.ipr_unumb = i
        Ipr_Fps_Booster_DChb:SetValue(IprFpsBooster_ConvControl(2, Ipr_Fps_Booster_DChb))
        Ipr_Fps_Booster_DChb:SetTooltip(Ipr_Fps_Booster.DefautCommand[i].Ipr_ToolTip[Ipr_Lang_C])
        Ipr_Fps_Booster_DChb:SetWide(200)
        function Ipr_Fps_Booster_DChb:Paint(w, h)
            draw.SimpleText(Ipr_Fps_Booster.DefautCommand[i].Ipr_Texte[Ipr_Lang_C], "Ipr_Fps_Booster_Font", 22, 0, Ipr_Fps_Booster_Color["blanc"], TEXT_ALIGN_LEFT)
        end
        Ipr_Fps_Booster_DChb.OnChange = function(self)
            IprFpsBooster_ConvControl(1, self, true)
        end
        IprFpsBooster_OverDcb(Ipr_Fps_Booster_DChb, 3)
    end
    local function ipr_tbl_add_func()
        ipr_tbl_add = ipr_tbl_add + 1
        return ipr_tbl_add
    end

    Ipr_Fps_Booster_DChb_ShowHud:SetPos(20, 245)
    Ipr_Fps_Booster_DChb_ShowHud:SetText("")
    Ipr_Fps_Booster_DChb_ShowHud.ipr_unumb = ipr_tbl_add_func()
    Ipr_Fps_Booster_DChb_ShowHud:SetValue(IprFpsBooster_ConvControl(2, Ipr_Fps_Booster_DChb_ShowHud))
    Ipr_Fps_Booster_DChb_ShowHud:SetTooltip(Ipr_Fps_Booster.Lang[Ipr_Lang_C].ipr_vgui_hudshow_tx)
    Ipr_Fps_Booster_DChb_ShowHud:SetWide(200)
    function Ipr_Fps_Booster_DChb_ShowHud:Paint(w, h)
        draw.SimpleText(Ipr_Fps_Booster.Lang[Ipr_Lang_C].ipr_vgui_hudshow_t, "Ipr_Fps_Booster_Font", 22, 0, Ipr_Fps_Booster_Color["blanc"], TEXT_ALIGN_LEFT)
    end
    Ipr_Fps_Booster_DChb_ShowHud.OnChange = function(self)
        IprFpsBooster_ConvControl(1, self, true)
    end
    IprFpsBooster_OverDcb(Ipr_Fps_Booster_DChb_ShowHud, 3)

    Ipr_Fps_Booster_Cls_a:SetPos(20, 270)
    Ipr_Fps_Booster_Cls_a:SetText("")
    Ipr_Fps_Booster_Cls_a.ipr_unumb = ipr_tbl_add_func()
    Ipr_Fps_Booster_Cls_a:SetValue(IprFpsBooster_ConvControl(2, Ipr_Fps_Booster_Cls_a))
    Ipr_Fps_Booster_Cls_a:SetTooltip(Ipr_Fps_Booster.Lang[Ipr_Lang_C].ipr_vgui_Cls)
    Ipr_Fps_Booster_Cls_a:SetWide(210)
    function Ipr_Fps_Booster_Cls_a:Paint(w, h)
        draw.SimpleText(Ipr_Fps_Booster.Lang[Ipr_Lang_C].ipr_vgui_Cls, "Ipr_Fps_Booster_Font", 22, 0, Ipr_Fps_Booster_Color["blanc"], TEXT_ALIGN_LEFT)
    end
    Ipr_Fps_Booster_Cls_a.OnChange = function(self)
        IprFpsBooster_ConvControl(1, self, true)
    end
    IprFpsBooster_OverDcb(Ipr_Fps_Booster_Cls_a, 3)

    Ipr_Fps_Booster_PosW:SetPos(-160, 310)
    Ipr_Fps_Booster_PosW:SetSize(415, 25)
    Ipr_Fps_Booster_PosW:SetText( "" )
    Ipr_Fps_Booster_PosW:SetMinMax(0, 100)
    Ipr_Fps_Booster_PosW.ipr_unumb = ipr_tbl_add_func()
    Ipr_Fps_Booster_PosW:SetValue(IprFpsBooster_ConvControl(2, Ipr_Fps_Booster_PosW))
    Ipr_Fps_Booster_PosW:SetDecimals(0)
    IprFpsBooster_OverDcb(Ipr_Fps_Booster_PosW, 2)
    Ipr_Fps_Booster_PosW.OnValueChanged = function(self, val)
        IprFpsBooster_ConvControl(1, self, false)
    end
    IprFpsBooster_OverDcb(Ipr_Fps_Booster_PosW, 4)

    Ipr_Fps_Booster_PosH:SetPos(-160, 355)
    Ipr_Fps_Booster_PosH:SetSize(415, 25)
    Ipr_Fps_Booster_PosH:SetText("")
    Ipr_Fps_Booster_PosH:SetMinMax(0, 100)
    Ipr_Fps_Booster_PosH.ipr_unumb = ipr_tbl_add_func()
    Ipr_Fps_Booster_PosH:SetValue(IprFpsBooster_ConvControl(2, Ipr_Fps_Booster_PosH))
    Ipr_Fps_Booster_PosH:SetDecimals(0)
    IprFpsBooster_OverDcb(Ipr_Fps_Booster_PosH, 2)
    Ipr_Fps_Booster_PosH.OnValueChanged = Ipr_Fps_Booster_PosW.OnValueChanged
    IprFpsBooster_OverDcb(Ipr_Fps_Booster_PosH, 4)

    Ipr_Fps_Booster_Exp:SetPos(221, 2)
    Ipr_Fps_Booster_Exp:SetSize(17, 17)
    Ipr_Fps_Booster_Exp:SetImage("icon16/cross.png")
    function Ipr_Fps_Booster_Exp:Paint(w, h) end
    Ipr_Fps_Booster_Exp.DoClick = function()
        if IsValid(p) then
        local ipr_gx, ipr_gxy = p:GetPos()
        p:SetPos(ipr_gx + 100, ipr_gxy)
        end

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
        IprFpsBooster_Enable(false)
        Ipr_Mx, Ipr_Mn, Ipr_Gn, Ipr_StatusVgui = 0, math.huge, 0, true

        chat.AddText(Ipr_Fps_Booster_Color["rouge"], "[", "FPS Booster", "] : ", Ipr_Fps_Booster_Color["blanc"], Ipr_Fps_Booster.Lang[Ipr_Lang_C].ipr_vgui_fps_load_data)
        surface.PlaySound("buttons/button9.wav")
        IprFpsBooster_Enable(true)
    end
end

local Ipr_Fps_Booster_Vgui = {}
local function Ipr_Fps_Booster_Vgui_Func()
    if IsValid(Ipr_Fps_Booster_Opt_Vgui) then
        Ipr_Fps_Booster_Opt_Vgui:Remove()
    end
    if IsValid(Ipr_Fps_Booster_Vgui) then
        Ipr_Fps_Booster_Vgui:Remove()
    end

    Ipr_Fps_Booster_Vgui = vgui.Create("DFrame")
    local Ipr_Fps_Booster_Vgui_Dp = vgui.Create("DPropertySheet", Ipr_Fps_Booster_Vgui)
    local Ipr_Fps_Booster_Exp = vgui.Create("DImageButton", Ipr_Fps_Booster_Vgui)
    local Ipr_Fps_Booster_Vgui_HTurl = vgui.Create("DButton", Ipr_Fps_Booster_Vgui)
    local Ipr_Fps_Booster_En = vgui.Create("DButton", Ipr_Fps_Booster_Vgui)
    local Ipr_Fps_Booster_Di = vgui.Create("DButton", Ipr_Fps_Booster_Vgui)
    local Ipr_Fps_Booster_Opt = vgui.Create("DButton", Ipr_Fps_Booster_Vgui)
    local Ipr_Fps_Booster_Res = vgui.Create("DButton", Ipr_Fps_Booster_Vgui)
    local Ipr_Fps_Booster_Dcb = vgui.Create("DComboBox", Ipr_Fps_Booster_Vgui)
    Ipr_Lang_C = IprFpsBooster_ConvControl()

    Ipr_Fps_Booster_Vgui:SetTitle( "" )
    Ipr_Fps_Booster_Vgui:SetSize(300, 275)
    Ipr_Fps_Booster_Vgui:MakePopup()
    Ipr_Fps_Booster_Vgui:ShowCloseButton(false)
    Ipr_Fps_Booster_Vgui:SetDraggable(true)
    Ipr_Fps_Booster_Vgui:Center()
    Ipr_Fps_Booster_Vgui:AlphaTo(5, 0, 0)
    Ipr_Fps_Booster_Vgui:AlphaTo(255, 1, 0)
    Ipr_Fps_Booster_Vgui.Paint = function( self, w, h )
        IprFpsBooster_GuiBlur(self, 2, Color( 0, 0, 0, 170 ), 8)
        Ipr_Lang_C = IprFpsBooster_ConvControl()

        draw.RoundedBoxEx(6, 0, 0, w, 33, Ipr_Fps_Booster_Color["bleu"], true, true, false, false)
        draw.SimpleText(Ipr_Fps_Booster.Lang[Ipr_Lang_C].ipr_vgui_enabled,"Ipr_Fps_Booster_Font",w/2,1, Ipr_Fps_Booster_Color["blanc"], TEXT_ALIGN_CENTER)
        draw.SimpleText("FPS :","Ipr_Fps_Booster_Font",(Ipr_StatusVgui and w/2 -25) or w/2 -10,16, Ipr_Fps_Booster_Color["blanc"], TEXT_ALIGN_CENTER)
        draw.SimpleText((Ipr_StatusVgui and "On (Boost)") or "Off", "Ipr_Fps_Booster_Font",(Ipr_StatusVgui and w/2 + 22) or w/2 + 18,16, Ipr_StatusVgui and Ipr_Fps_Booster_Color["vert"] or Ipr_Fps_Booster_Color["rouge"], TEXT_ALIGN_CENTER)
    end 
  
    Ipr_Fps_Booster_Vgui_Dp:Dock( FILL )
    Ipr_Fps_Booster_Vgui_Dp:DockPadding( 52, 10, 0, 0)

    do
        local ipr_h, ipr_v, ipr_t = 0, 0, {5,15,25,35}
        local function ipr_anim_rotate(self)
            local ipr_cur = CurTime()
            if ipr_cur > (self.time or 0) then
                for k, v in pairs(ipr_t) do
                    if (ipr_h) and (k <= ipr_h) then
                      continue
                    end
                    ipr_h, ipr_v = k, v
    
                    if (k == #ipr_t) then
                        ipr_h = 0
                    end
                    break
                end
                self.time = ipr_cur + 1
            end
    
            return ipr_v
        end
        local function ipr_fps_booster_rgbtransition(ipr_nbc)
            if (ipr_nbc <= 20) then
                return Ipr_Fps_Booster_Color["rouge"]
            elseif (ipr_nbc > 20 and ipr_nbc <= 40) then
                return Ipr_Fps_Booster_Color["orange"]
            else
                return Ipr_Fps_Booster_Color["vert"]
            end
        end
        function surface.ipr_draw(x, y, w, h, rot, x0)
            local c, s = math.cos(math.rad(rot)), math.sin(math.rad(rot))
            local newx = s - x0 * c
            local newy = c + x0 * s
    
            surface.DrawTexturedRectRotated(x + newx, y + newy, w, h, rot)
        end
        local ipr_icon, ipr_icon_ = Material("icon/ipr_boost_computer.png", "noclamp smooth"), Material("icon/ipr_boost_wrench.png", "noclamp smooth")
        Ipr_Fps_Booster_Vgui_Dp.Paint = function (self, w, h)
            local Ipr_Cur, Ipr_Mn, Ipr_Max_, Ipr_Gn = IprFpsBooster_CalcFps()
            draw.SimpleText("FPS Status","Ipr_Fps_Booster_Font",w/2,h/2-66, Ipr_Fps_Booster_Color["blanc"], TEXT_ALIGN_CENTER)
            draw.SimpleText(Ipr_Fps_Booster.Lang[Ipr_Lang_C].ipr_vgui_fps_cur,"Ipr_Fps_Booster_Font",w/2-10,h/2-48, Ipr_Fps_Booster_Color["blanc"], TEXT_ALIGN_CENTER)
            draw.SimpleText(Ipr_Cur, "Ipr_Fps_Booster_Font",w/2+15,h/2-48, ipr_fps_booster_rgbtransition(Ipr_Cur), TEXT_ALIGN_LEFT)
            draw.SimpleText("Max : ","Ipr_Fps_Booster_Font",w/2-10,h/2-33, Ipr_Fps_Booster_Color["blanc"], TEXT_ALIGN_CENTER)
            draw.SimpleText(Ipr_Max_,"Ipr_Fps_Booster_Font",w/2+10,h/2-33, ipr_fps_booster_rgbtransition(Ipr_Max_), TEXT_ALIGN_LEFT)
            draw.SimpleText("Min : ","Ipr_Fps_Booster_Font",w/2-10,h/2-18, Ipr_Fps_Booster_Color["blanc"], TEXT_ALIGN_CENTER)
            draw.SimpleText(Ipr_Mn,"Ipr_Fps_Booster_Font",w/2+10,h/2-18, ipr_fps_booster_rgbtransition(Ipr_Mn), TEXT_ALIGN_LEFT)
            draw.SimpleText("Gain : ","Ipr_Fps_Booster_Font",w/2-10, h/2-3, Ipr_Fps_Booster_Color["blanc"], TEXT_ALIGN_CENTER)
            draw.SimpleText((Ipr_StatusVgui and (Ipr_Mx ~= Ipr_Gn) and Ipr_Gn or "OFF"),"Ipr_Fps_Booster_Font",w/2+10, h/2-3, Ipr_StatusVgui and (Ipr_Mx ~= Ipr_Gn) and Ipr_Fps_Booster_Color["vert"] or Ipr_Fps_Booster_Color["rouge"], TEXT_ALIGN_LEFT)
    
            surface.SetMaterial(ipr_icon)
            surface.SetDrawColor(255, 255, 255, 255)
            surface.DrawTexturedRect(-10, 0, 350, 235)
    
            surface.SetMaterial(ipr_icon_)
            surface.SetDrawColor(255, 255, 255, 255)
            surface.ipr_draw(207, 120, 220, 220, ipr_anim_rotate(self), -25)
        end
    end
       
    Ipr_Fps_Booster_Vgui_HTurl:SetPos(97, 80)
    Ipr_Fps_Booster_Vgui_HTurl:SetSize(110, 90)
    Ipr_Fps_Booster_Vgui_HTurl:SetText("")
    function Ipr_Fps_Booster_Vgui_HTurl:Paint(w, h) end
    Ipr_Fps_Booster_Vgui_HTurl.DoClick = function()
        gui.OpenURL("https://steamcommunity.com/sharedfiles/filedetails/?id=1762151370")
    end

    Ipr_Fps_Booster_En:SetPos(6, 245)
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
        if IprFpsBooster_LoadChb(true) then
        Ipr_Mx, Ipr_Mn, Ipr_Gn, Ipr_StatusVgui, Ipr_LastMx = 0, math.huge, 0, false, 0
        chat.AddText(Ipr_Fps_Booster_Color["rouge"], "[", "FPS Booster", "] : ", Ipr_Fps_Booster_Color["blanc"], "Please check boxes in optimization to activate the fps booster !")
            return 
        end
        if (Ipr_StatusVgui) then
            IprFpsBooster_Enable(false)
        end
        
        Ipr_Mx, Ipr_Mn, Ipr_Gn, Ipr_StatusVgui = 0, math.huge, 0, true
        IprFpsBooster_Enable(true)
        chat.AddText(Ipr_Fps_Booster_Color["rouge"], "[", "FPS Booster", "] : ", Ipr_Fps_Booster_Color["blanc"], Ipr_Fps_Booster.Lang[Ipr_Lang_C].ipr_vgui_enable_prevent_t)
        
        if IprFpsBooster_ConvControl(3, nil, nil, 14) then
          Ipr_Fps_Booster_Vgui:Remove()
            
            if IsValid(Ipr_Fps_Booster_Opt_Vgui) then
              Ipr_Fps_Booster_Opt_Vgui:Remove()
            end
        end
        surface.PlaySound("buttons/combine_button7.wav")
    end

    Ipr_Fps_Booster_Di:SetPos(184, 245)
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
        Ipr_Mx, Ipr_Mn, Ipr_Gn, Ipr_StatusVgui, Ipr_LastMx = 0, math.huge, 0, false, 0
        IprFpsBooster_Enable(false)

        chat.AddText(Ipr_Fps_Booster_Color["rouge"], "[", "FPS Booster", "] : ", Ipr_Fps_Booster_Color["blanc"], Ipr_Fps_Booster.Lang[Ipr_Lang_C].ipr_vgui_disableop_t)
        if IprFpsBooster_ConvControl(3, nil, nil, 14) then
          Ipr_Fps_Booster_Vgui:Remove()
            if IsValid(Ipr_Fps_Booster_Opt_Vgui) then
              Ipr_Fps_Booster_Opt_Vgui:Remove()
            end
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

    Ipr_Fps_Booster_Res:SetPos(77, 195)
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
        Ipr_Mx, Ipr_Mn, Ipr_Gn = 0, math.huge, 0
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
    IprFpsBooster_OverDcb(Ipr_Fps_Booster_Dcb, 1)
    Ipr_Fps_Booster_Dcb.OnMenuOpened = function(self)
        for _, v in pairs(self:GetChildren()) do
            v.Paint = function(p, w, h)
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

        IprFpsBooster_OverDcb(self, 1)
    end
    Ipr_Fps_Booster_Dcb.OnSelect = function( self, index, value )
        local ipr_lang_cf = Ipr_Fps_Booster.Lang[Ipr_Lang_C].ipr_vgui_Lang.. " "
        ipr_lang_cf = string.Replace(value, ipr_lang_cf, "")
        if (ipr_lang_cf == Ipr_Lang_C) then
            return
        end
        file.Write(Ipr_Fps_Booster.SaveLocation.. "_lang.json", util.TableToJSON({ipr_lang_cf}))
        Ipr_Fps_Booster.Save_Lg[1] = ipr_lang_cf
        
        surface.PlaySound("buttons/button9.wav")
    
        self:Clear()
        local Ipr_Call = IprFpsBooster_ConvControl()
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

local function IprFpsBooster_PostDraw()
    if not Ipr_Fps_Booster.Loaded_Lua or not IprFpsBooster_ConvControl(3, nil, nil, 13) then
        return
    end
    local Ipr_Cur, Ipr_Mn, Ipr_Max_, Ipr_Gn = IprFpsBooster_CalcFps()
    local Ipr_Map = game.GetMap()

    draw.SimpleTextOutlined("FPS : " ..Ipr_Cur.. " Min : " ..Ipr_Mn.. " Max : " ..Ipr_Max_.. " " ..(Ipr_StatusVgui and (Ipr_Mx ~= Ipr_Gn) and "Gain :" ..Ipr_Gn or ""), "Ipr_Fps_Booster_Font", ScrW() * (IprFpsBooster_ConvControl(3, nil, nil, 15) / 100) - 40,  ScrH() * (IprFpsBooster_ConvControl(3, nil, nil, 16) / 100) - 10, Ipr_Fps_Booster_Color["blanc"], TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT, 0.8, Ipr_Fps_Booster_Color["bleu"])
    draw.SimpleTextOutlined("Map : " ..Ipr_Map, "Ipr_Fps_Booster_Font", ScrW() * (IprFpsBooster_ConvControl(3, nil, nil, 15) / 100) - 40,  ScrH() * (IprFpsBooster_ConvControl(3, nil, nil, 16) / 100) + 10, Ipr_Fps_Booster_Color["blanc"], TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT, 0.8, Ipr_Fps_Booster_Color["bleu"])
end

local function IprFpsBooster_ChatVgui(ply, strText, bTeam, bDead)
    if (ply ~= LocalPlayer()) then
        return
    end
    local Ipr_Str = string.lower(strText)

    if (Ipr_Str  == "/boost")  then
        return true, Ipr_Fps_Booster_Vgui_Func()
    end
    if (Ipr_Str == "/reset") then
        if not IprFpsBooster_LoadChb() then
            Ipr_Mx, Ipr_Mn, Ipr_Gn, Ipr_StatusVgui, Ipr_LastMx = 0, math.huge, 0, false, 0
            surface.PlaySound("buttons/combine_button5.wav")
            return true, IprFpsBooster_Enable(false)
        else
            chat.AddText(Ipr_Fps_Booster_Color["rouge"], "[", "Improved FPS Booster", "] : ", Ipr_Fps_Booster_Color["blanc"], "Already disabled !")
            return true
        end
    end
end

local function IprFpsBooster_LoadSxt(n)
    if (n == 1) then
        local Ipr_CountryLang = Ipr_Fps_Booster.DefaultLanguage
        if (Ipr_Fps_Booster.Country[system.GetCountry()]) then
            Ipr_CountryLang = "FR"
        end
        
        file.Write(Ipr_Fps_Booster.SaveLocation.. "_lang.json", util.TableToJSON({Ipr_CountryLang}))
        Ipr_Fps_Booster.Save_Lg[1] = Ipr_CountryLang
        return
    end

    Ipr_Fps_Booster.Save_Tbl = {{ipr_unumb = 1, ipr_vld = true},{ipr_unumb = 2, ipr_vld = false},{ipr_unumb = 3, ipr_vld = false},{ipr_unumb = 4, ipr_vld = false},{ipr_unumb = 5, ipr_vld = false},{ipr_unumb = 6, ipr_vld = false},{ipr_unumb = 7, ipr_vld = true},{ipr_unumb = 8, ipr_vld = false},{ipr_unumb = 9, ipr_vld = false},{ipr_unumb = 10, ipr_vld = false},{ipr_unumb = 11, ipr_vld = false}, {ipr_unumb = 12, ipr_vld = false}, {ipr_unumb = 13, ipr_vld = false}, {ipr_unumb = 14, ipr_vld = true}, {ipr_unumb = 15, ipr_vld = 32}, {ipr_unumb = 16, ipr_vld = 40}}
    file.Write(Ipr_Fps_Booster.SaveLocation.. "_save.json", util.TableToJSON(Ipr_Fps_Booster.Save_Tbl))
end

local function IprFpsBooster_InitEnt()
    local ipr_find = file.Find(Ipr_Fps_Booster.SaveLocation.. "*.json", "DATA")

    if (#ipr_find <= 0) then
        file.CreateDir(Ipr_Fps_Booster.SaveLocation)

        for i = 1, 2 do
            IprFpsBooster_LoadSxt(i)
        end
    else
        if not (ipr_find[1] == "_lang.json") then
            IprFpsBooster_LoadSxt(1)
        else
            Ipr_Fps_Booster.Save_Lg = util.JSONToTable(file.Read(Ipr_Fps_Booster.SaveLocation.. "_lang.json", "DATA") or {})
        end
        if not (ipr_find[2] == "_save.json") then
            IprFpsBooster_LoadSxt(2)
        else
            local ipr_lg = util.JSONToTable(file.Read(Ipr_Fps_Booster.SaveLocation.. "_save.json", "DATA") or {})
            if (#ipr_lg <= 0) then --- OOOh shit :P
                IprFpsBooster_LoadSxt(2)
            end

            Ipr_Fps_Booster.Save_Tbl = ipr_lg
        end
    end
    if IprFpsBooster_LoadChb() then
        timer.Simple(5, function()
            Ipr_Fps_Booster_Vgui_Func()
        end)
    else
        Ipr_Mx, Ipr_Mn, Ipr_StatusVgui = 0, math.huge, true
        chat.AddText(Ipr_Fps_Booster_Color["vert"], "[", "Improved FPS Booster automatically started", "]")
    end

    Ipr_Fps_Booster.Loaded_Lua = true
end

hook.Add( "OnPlayerChat", "IprFpsBooster_ChatVgui", IprFpsBooster_ChatVgui)
hook.Add("PostDrawHUD","IprFpsBooster_PostDraw", IprFpsBooster_PostDraw)
hook.Add( "InitPostEntity", "IprFpsBooster_InitEnt", IprFpsBooster_InitEnt)
