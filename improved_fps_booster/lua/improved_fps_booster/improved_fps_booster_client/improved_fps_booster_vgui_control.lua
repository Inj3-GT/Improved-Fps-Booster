----------- // SCRIPT BY INJ3 
----------- // SCRIPT BY INJ3 
----------- // SCRIPT BY INJ3 
----------- // https://steamcommunity.com/id/Inj3/
----------- GNU General Public License v3.0
----------- https://github.com/Inj3-GT
local ipr = {}
ipr.cvar_box = {}
ipr.debug = true
ipr.save = "ipr_fps_booster_/"

local function Ipr_UpdateVgui(s, d)
    if (s) then
        ipr.cvar_box = util.JSONToTable(file.Read(ipr.save.. "_save.json", "DATA") or {})
        return
    end
    if (d) then
        local ipr_default = {{ipr_b = true}, {ipr_b = false}, {ipr_b = false}, {ipr_b = false}, {ipr_b = false}, {ipr_b = false}, {ipr_b = true}, {ipr_b = false}, {ipr_b = false}, {ipr_b = false}, {ipr_b = false}, {ipr_b = false}, {ipr_b = false}, {ipr_b = false}, {ipr_b = false}, {ipr_b = true}, {ipr_b = false}, {ipr_b = 32}, {ipr_b = 40}}
        ipr.cvar_box = ipr_default
    end

    local ipr_js = util.TableToJSON(ipr.cvar_box)
    file.Write(ipr.save.. "_save.json", ipr_js)
end

local function IprFpsBooster_CVar(cvar, p, n)
    if (cvar == 1) then
        if not IsValid(p) then
            return
        end
        if ipr.cvar_box[p.value] then
            local ipr_p, ipr_u = p.GetChecked

            if (ipr_p) then
                ipr_u = p:GetChecked()
                surface.PlaySound("buttons/combine_button1.wav")
            end
            local ipr_g = p:GetValue()
            if isnumber(ipr_g) then
                ipr_u = ipr_g
            end

            ipr.cvar_box[p.value].ipr_b = ipr_u
            Ipr_UpdateVgui()
        end
    elseif (cvar == 2) then
        if not IsValid(p) then
            return false
        end
        if ipr.cvar_box[p.value] then
            return ipr.cvar_box[p.value].ipr_b
        end

        if (ipr.debug) then
            print("*C2-error")
        end
        return false
    elseif (cvar == 3) then
        if ipr.cvar_box[n] then
            return ipr.cvar_box[n].ipr_b
        end

        if (ipr.debug) then
            print("*C3-error")
        end
        return false
    end
end

local function ipr_InfoNum(ply, o, s)
    local ipr_info = tonumber(ply:GetInfoNum(o, -99))
    if (s) then
        return (ipr_info == -99)
    end

    return ipr_info
end

local function IprFpsBooster_Cmds(b)
    local ipr_ply = LocalPlayer()

    for _, v in pairs(ipr.cvar_box) do
        if Ipr_Fps_Booster.DefautCommand[_] then
            local ipr_v = v.ipr_b

            for o, g in pairs(Ipr_Fps_Booster.DefautCommand[_].Ipr_CmdChild) do
                local ipr_t = (ipr_v and g.Ipr_Enabled) or g.Ipr_Disabled
                if (b) then
                    if (g.Ipr_Disabled ~= ipr_t) then
                        return true
                    end
                else
                    if ipr_InfoNum(ipr_ply, o, true) then
                       continue
                    end
                    if tonumber(ipr_t) ~= ipr_InfoNum(ipr_ply, o) then
                        return true
                    end
                end
            end
        end
    end
    return false
end

ipr.fps_default = {mx = 0, smx = 0, mn = math.huge, gn = 0}
local ipr_tc = table.Copy(ipr.fps_default)
local function Ipr_ResetValue(g)
    if not g then
        ipr_tc.smx = ipr.fps_default.smx
    end

    ipr_tc.mn = ipr.fps_default.mn
    ipr_tc.mx = ipr.fps_default.mx
    ipr_tc.gn = ipr.fps_default.gn
end
 
local ipr_status = false
local function IprFpsBooster_Status(s, o)
    if (s) then
        return ipr_status
    end
    ipr_status = o

    return ipr_status
end

local function IprFpsBooster_Enable(b)
    local ipr_ply = LocalPlayer()

    if (b) then
        for _, v in pairs(ipr.cvar_box) do
            if Ipr_Fps_Booster.DefautCommand[_] then
                local ipr_v = v.ipr_b

                for o, g in pairs(Ipr_Fps_Booster.DefautCommand[_].Ipr_CmdChild) do
                    if ipr_InfoNum(ipr_ply, o, true) then
                       continue
                    end

                    local ipr_t = (ipr_v and g.Ipr_Enabled) or g.Ipr_Disabled
                    ipr_ply:ConCommand(o.. " " ..ipr_t)
                end
            end
        end
    else
        for _, g in pairs(Ipr_Fps_Booster.DefautCommand) do
            for d, t in pairs(g.Ipr_CmdChild) do
                if ipr_InfoNum(ipr_ply, d, true) then
                   continue
                end

                ipr_ply:ConCommand(d.. " " ..t.Ipr_Disabled)
            end
        end
    end

    local ipr_cmd = IprFpsBooster_Cmds(true)
    if not ipr_cmd then
        Ipr_ResetValue()
        IprFpsBooster_Status(false, false)
    end
end

local ipr_fps = 0
local function IprFpsBooster_CalcFps()
    local ipr_Cur = CurTime()

    if (ipr_Cur > (ipr.c or 0)) then
        ipr_fps = math.Round(1/FrameTime())

        if (ipr_fps < ipr_tc.mn) then
            ipr_tc.mn = ipr_fps
        end
        if (ipr_fps > (ipr_tc.mx ~= math.huge and ipr_tc.mx or 0)) then
            ipr_tc.mx = ipr_fps
        end
        if not IprFpsBooster_Status(true) then
            ipr_tc.smx = ipr_tc.mx
        end
        if (ipr_tc.mx > ipr_tc.smx) then
            ipr_tc.gn = ipr_tc.mx - ipr_tc.smx
        end

        ipr.c = ipr_Cur + 0.3
    end
    
    return ipr_fps, ipr_tc.mn, ipr_tc.mx, ipr_tc.gn
end

ipr.cvar_lang = {}
local function Ipr_RequestLang()
    return ipr.cvar_lang[1] or Ipr_Fps_Booster.DefaultLanguage
end

ipr.blur = Material("pp/blurscreen")
local function IprFpsBooster_GuiBlur(f, fl, c, br)
    if not IsValid(f) then
        return
    end
    surface.SetDrawColor(255, 255, 255)
    surface.SetMaterial(ipr.blur)

    local ipr_x, ipr_y = f:LocalToScreen(0, 0)
    ipr.blur:SetInt("$blur", 2)
    ipr.blur:Recompute()
    render.UpdateScreenEffectTexture()

    local ipr_sw, ipr_sh = ScrW(), ScrH()
    surface.DrawTexturedRect(ipr_x * -1, ipr_y * -1, ipr_sw, ipr_sh)
    draw.RoundedBoxEx(br, 0, 0, f:GetWide(), f:GetTall(), c, true, true, true, true)
end

ipr.color = {["gris"] = Color(236, 240, 241), ["vert"] = Color(39, 174, 96), ["rouge"] = Color(192, 57, 43), ["orange"] = Color(243, 156, 18), ["blanc"] = Color(236, 240, 241), ["bleu"] = Color(52, 73, 94), ["bleuc"] = Color(30, 73, 109)}
local function IprFpsBooster_Override(g, n)
    local ipr_child = g:GetChildren()
    
    if (n == 1) then
        for _, v in ipairs(ipr_child) do
            if (v:GetName() ~= "DMenu") then
                v.Paint = function(self, w, h)
                    draw.RoundedBox(12, 9, 6, w - 10, h - 10, ipr.color["blanc"])
                end
            end
        end
    elseif (n == 2) then
        for _, v in ipairs(ipr_child) do
            if (v:GetName() ~= "DSlider") then
                v:SetFont("Ipr_Fps_Booster_Font")
                v:SetTextColor(ipr.color["blanc"])
            end
        end
    elseif (n == 3) then
        for _, v in ipairs(ipr_child) do
            if (v:GetName() == "DCheckBox") then
                v.Paint = function(self, w, h)
                    draw.RoundedBox(6, 0, 0, w, h, self:GetChecked() and ipr.color["vert"] or ipr.color["rouge"])
                    draw.RoundedBox(12, 7, 7, 2, 2, self:GetChecked() and ipr.color["blanc"] or color_black)
                end
            end
        end
    elseif (n == 4) then
        for _, v in ipairs(ipr_child) do
            if (v:GetName() == "DSlider") then
                v.Knob.Paint = function(self, w, h)
                    draw.RoundedBox(3, 5, 0, w-10, h, ipr.color["vert"])
                end
                v.Paint = function(self, w, h)
                    draw.RoundedBox(3, 7, h/2 -2, w - 12, h/2 -10, ipr.color["rouge"])
                end
            end
        end
    end
end

local function ipr_RgbTransition(ipr_nbc)
    return (ipr_nbc <= 30) and ipr.color["rouge"] or (ipr_nbc > 30) and (ipr_nbc <= 60) and ipr.color["orange"] or ipr.color["vert"]
end

local ipr_vgui_func
local function Ipr_Booster_Option_Func(p)
    if IsValid(ipr_vgui_func) then
        ipr_vgui_func:Remove()
    else
        if IsValid(p) then
            local ipr_gx, ipr_gxy = p:GetPos()
            p:SetPos(ipr_gx - 100, ipr_gxy)
        end
    end

    ipr_vgui_func = vgui.Create( "DFrame" )
    local ipr_scrollbar = vgui.Create( "DScrollPanel", ipr_vgui_func)
    local ipr_scrollbar_c = vgui.Create( "DScrollPanel", ipr_vgui_func)

    local ipr_cbox_hud = vgui.Create( "DCheckBoxLabel", ipr_scrollbar_c)
    local ipr_cbox_close = vgui.Create( "DCheckBoxLabel", ipr_scrollbar_c)
    local ipr_cbox_forceopen = vgui.Create( "DCheckBoxLabel", ipr_scrollbar_c)

    local ipr_dnum_w = vgui.Create( "DNumSlider", ipr_vgui_func)
    local ipr_dnum_h = vgui.Create( "DNumSlider", ipr_vgui_func)

    local ipr_dbut_save = vgui.Create("DButton", ipr_vgui_func)
    local ipr_dbut_default = vgui.Create("DButton", ipr_vgui_func)
    local ipr_close = vgui.Create("DImageButton", ipr_vgui_func)

    ipr_vgui_func:SetTitle("")
    ipr_vgui_func:SetSize(240, 405)
    ipr_vgui_func:SetPos(0, 0)
    ipr_vgui_func:MakePopup()
    ipr_vgui_func:ShowCloseButton(false)
    ipr_vgui_func:SetDraggable(true)
    ipr_vgui_func:AlphaTo(5, 0, 0)
    ipr_vgui_func:AlphaTo(255, 1, 0)
    ipr_vgui_func.Think = function(self)
        if not IsValid(self) or not IsValid(p) then
            return 
        end
        local ipr_getpos_x, ipr_getpos_y = p:GetPos()
        self:SetPos(ipr_getpos_x + 310, ipr_getpos_y + -60)
    end
 
    local ipr_lang = Ipr_RequestLang()
    ipr_vgui_func.Paint = function( self, w, h )
        IprFpsBooster_GuiBlur(self, 2, Color( 0, 0, 0, 170 ), 8)
        draw.RoundedBoxEx(6, 0, 0, w, 20, ipr.color["bleu"], true, true, false, false)

        draw.SimpleText("Options FPS Booster","Ipr_Fps_Booster_Font",w/2,1, ipr.color["blanc"], TEXT_ALIGN_CENTER)
        draw.SimpleText("Configuration :","Ipr_Fps_Booster_Font",w/2,h/2+18, ipr.color["blanc"], TEXT_ALIGN_CENTER)

        local ipr_flimit = math.Round(ipr_InfoNum(LocalPlayer(), "fps_max"))
        draw.SimpleText("FPS Limit : ","Ipr_Fps_Booster_Font", 5, h-17, ipr.color["blanc"], TEXT_ALIGN_LEFT)
        draw.SimpleText(ipr_flimit,"Ipr_Fps_Booster_Font", 67, h-17, ipr_RgbTransition(ipr_flimit), TEXT_ALIGN_LEFT)
        draw.SimpleText("Inj3","Ipr_Fps_Booster_Font", w-5,h-17, ipr.color["vert"], TEXT_ALIGN_RIGHT)
        draw.SimpleText(Ipr_Fps_Booster.Version.. " By","Ipr_Fps_Booster_Font", w-28,h-17, ipr.color["blanc"], TEXT_ALIGN_RIGHT)
        
        ipr_lang = Ipr_RequestLang()
        draw.SimpleText(Ipr_Fps_Booster.Lang[ipr_lang].ipr_vgui_opti_t,"Ipr_Fps_Booster_Font",w/2,50, ipr.color["blanc"], TEXT_ALIGN_CENTER)
        draw.SimpleText(Ipr_Fps_Booster.Lang[ipr_lang].ipr_vgui_posw_t,"Ipr_Fps_Booster_Font",w/2+2,h/2+105, ipr.color["blanc"], TEXT_ALIGN_CENTER)
        draw.SimpleText(Ipr_Fps_Booster.Lang[ipr_lang].ipr_vgui_posh_t,"Ipr_Fps_Booster_Font",w/2+2,h/2+148, ipr.color["blanc"], TEXT_ALIGN_CENTER)
    end

    local function ipr_bar(p)
        function p:Paint(w, h)
        end
        function p.btnUp:Paint(w, h)
            draw.RoundedBox(3, 0, 0, w, h, ipr.color["bleu"])
        end
        function p.btnDown:Paint(w, h)
            draw.RoundedBox(3, 0, 0, w, h, ipr.color["bleu"])
        end
        function p.btnGrip:Paint(w, h)
            draw.RoundedBox(3, 0, 0, w, h, ipr.color["bleu"])
        end
    end

    ipr_scrollbar:Dock(FILL)
    ipr_scrollbar:DockMargin(0, 40, 0, 190)
    ipr_bar(ipr_scrollbar:GetVBar())

    ipr_scrollbar_c:Dock(FILL)
    ipr_scrollbar_c:DockMargin(0, 213, 0, 103)
    ipr_bar(ipr_scrollbar_c:GetVBar())

    local ipr_vgui_cmds = #Ipr_Fps_Booster.DefautCommand
    for i = 1, ipr_vgui_cmds do
        local ipr_cbox = vgui.Create( "DCheckBoxLabel", ipr_scrollbar)
        ipr_cbox:SetPos(10, i * (1+ 22) -22)
        ipr_cbox:SetText("")
        ipr_cbox.value = i
        ipr_cbox:SetValue(IprFpsBooster_CVar(2, ipr_cbox))
        ipr_cbox:SetTooltip(Ipr_Fps_Booster.DefautCommand[i].Ipr_ToolTip[ipr_lang])
        ipr_cbox:SetWide(200)
        IprFpsBooster_Override(ipr_cbox, 3)
        function ipr_cbox:Paint(w, h)
            draw.SimpleText(Ipr_Fps_Booster.DefautCommand[i].Ipr_Texte[ipr_lang], "Ipr_Fps_Booster_Font", 22, 0, ipr.color["blanc"], TEXT_ALIGN_LEFT)
        end
        ipr_cbox.OnChange = function(self)
            IprFpsBooster_CVar(1, self)
        end
    end
    local function ipr_cmds_func()
        ipr_vgui_cmds = ipr_vgui_cmds + 1
        return ipr_vgui_cmds
    end

    ipr_cbox_hud:SetPos(10, 0)
    ipr_cbox_hud:SetText("")
    ipr_cbox_hud.value = ipr_cmds_func()
    ipr_cbox_hud:SetValue(IprFpsBooster_CVar(2, ipr_cbox_hud))
    ipr_cbox_hud:SetTooltip("Fps counter is visible on your screen")
    ipr_cbox_hud:SetWide(200)
    IprFpsBooster_Override(ipr_cbox_hud, 3)
    function ipr_cbox_hud:Paint(w, h)
        draw.SimpleText(Ipr_Fps_Booster.Lang[ipr_lang].ipr_vgui_hudshow_t, "Ipr_Fps_Booster_Font", 22, 0, ipr.color["blanc"], TEXT_ALIGN_LEFT)
    end
    ipr_cbox_hud.OnChange = function(self)
        IprFpsBooster_CVar(1, self)
    end

    ipr_cbox_close:SetPos(10, 22)
    ipr_cbox_close:SetText("")
    ipr_cbox_close.value = ipr_cmds_func()
    ipr_cbox_close:SetValue(IprFpsBooster_CVar(2, ipr_cbox_close))
    ipr_cbox_close:SetTooltip("If you press 'Enable' or 'Disable', the panel will close")
    ipr_cbox_close:SetWide(210)
    IprFpsBooster_Override(ipr_cbox_close, 3)
    function ipr_cbox_close:Paint(w, h)
        draw.SimpleText(Ipr_Fps_Booster.Lang[ipr_lang].ipr_vgui_Cls, "Ipr_Fps_Booster_Font", 22, 0, ipr.color["blanc"], TEXT_ALIGN_LEFT)
    end
    ipr_cbox_close.OnChange = function(self)
        IprFpsBooster_CVar(1, self)
    end

    ipr_cbox_forceopen:SetPos(10, 44)
    ipr_cbox_forceopen:SetText("")
    ipr_cbox_forceopen.value = ipr_cmds_func()
    ipr_cbox_forceopen:SetValue(IprFpsBooster_CVar(2, ipr_cbox_forceopen))
    ipr_cbox_forceopen:SetTooltip("Disable automatic start when you have finished loading")
    ipr_cbox_forceopen:SetWide(210)
    IprFpsBooster_Override(ipr_cbox_forceopen, 3)
    function ipr_cbox_forceopen:Paint(w, h)
        draw.SimpleText(Ipr_Fps_Booster.Lang[ipr_lang].ipr_vgui_fopen, "Ipr_Fps_Booster_Font", 22, 0, ipr.color["blanc"], TEXT_ALIGN_LEFT)
    end
    ipr_cbox_forceopen.OnChange = function(self)
        IprFpsBooster_CVar(1, self)
    end

    ipr_dnum_w:SetPos(-160, 323)
    ipr_dnum_w:SetSize(415, 25)
    ipr_dnum_w:SetText("")
    ipr_dnum_w:SetMinMax(0, 100)
    ipr_dnum_w.value = ipr_cmds_func()
    ipr_dnum_w:SetValue(IprFpsBooster_CVar(2, ipr_dnum_w))
    ipr_dnum_w:SetDecimals(0)
    IprFpsBooster_Override(ipr_dnum_w, 2)
    IprFpsBooster_Override(ipr_dnum_w, 4)
    ipr_dnum_w.OnValueChanged = function(self, val)
        IprFpsBooster_CVar(1, self)
    end

    ipr_dnum_h:SetPos(-160, 366)
    ipr_dnum_h:SetSize(415, 25)
    ipr_dnum_h:SetText("")
    ipr_dnum_h:SetMinMax(0, 100)
    ipr_dnum_h.value = ipr_cmds_func()
    ipr_dnum_h:SetValue(IprFpsBooster_CVar(2, ipr_dnum_h))
    ipr_dnum_h:SetDecimals(0)
    IprFpsBooster_Override(ipr_dnum_h, 2)
    IprFpsBooster_Override(ipr_dnum_h, 4)
    ipr_dnum_h.OnValueChanged = ipr_dnum_w.OnValueChanged

    ipr_dbut_save:SetPos(122, 25)
    ipr_dbut_save:SetSize(100, 20)
    ipr_dbut_save:SetText("")
    ipr_dbut_save:SetImage("icon16/arrow_rotate_anticlockwise.png")
    function ipr_dbut_save:Paint(w, h)
        draw.RoundedBox(6, 0, 0, w, h, self:IsHovered() and ipr.color["bleuc"] or ipr.color["bleu"])
        draw.SimpleText(Ipr_Fps_Booster.Lang[ipr_lang].ipr_vgui_LoadS, "Ipr_Fps_Booster_Font", w / 2 + 6, 1, ipr.color["blanc"], TEXT_ALIGN_CENTER)
    end
    ipr_dbut_save.DoClick = function()
        IprFpsBooster_Enable(false)
        Ipr_ResetValue(true)

        IprFpsBooster_Enable(true)
        IprFpsBooster_Status(false, true)

        chat.AddText(ipr.color["rouge"], "[", "FPS Booster", "] : ", ipr.color["blanc"], Ipr_Fps_Booster.Lang[ipr_lang].ipr_vgui_fps_load_data)
        surface.PlaySound("buttons/button9.wav")
    end

    ipr_dbut_default:SetPos(22, 25)
    ipr_dbut_default:SetSize(80, 20)
    ipr_dbut_default:SetText("")
    ipr_dbut_default:SetImage("icon16/cog_go.png")
    function ipr_dbut_default:Paint(w, h)
        draw.RoundedBox(6, 0, 0, w, h, self:IsHovered() and ipr.color["bleuc"] or ipr.color["bleu"])
        draw.SimpleText(Ipr_Fps_Booster.Lang[ipr_lang].ipr_vgui_Default, "Ipr_Fps_Booster_Font", w / 2 + 6, 1, ipr.color["blanc"], TEXT_ALIGN_CENTER)
    end
    ipr_dbut_default.DoClick = function()
        Ipr_UpdateVgui(false, true)
        IprFpsBooster_Enable(false)

        IprFpsBooster_Status(false, false)
        Ipr_ResetValue(true)
        
        if IsValid(ipr_vgui_func) then
            ipr_vgui_func:Remove()
        end
        if IsValid(p) then
            local ipr_gx, ipr_gxy = p:GetPos()
            p:SetPos(ipr_gx + 100, ipr_gxy)
        end

        chat.AddText(ipr.color["rouge"], "[", "FPS Booster", "] : ", ipr.color["blanc"], "The default configuration has been loaded !")
        surface.PlaySound("buttons/button9.wav")
    end

    ipr_close:SetPos(221, 2)
    ipr_close:SetSize(17, 17)
    ipr_close:SetImage("icon16/cross.png")
    function ipr_close:Paint(w, h) end
    ipr_close.DoClick = function()
        if IsValid(p) then
            local ipr_gx, ipr_gxy = p:GetPos()
            p:SetPos(ipr_gx + 100, ipr_gxy)
        end

        if IsValid(ipr_vgui_func) then
            ipr_vgui_func:Remove()
        end
    end
end

local function Ipr_UpdateLang(s)
    if (s) then
        file.Write(ipr.save.. "_lang.json", util.TableToJSON({s}))
        ipr.cvar_lang[1] = s
        return
    end
    ipr.cvar_lang = util.JSONToTable(file.Read(ipr.save.. "_lang.json", "DATA") or {})
end

local ipr_vgui
local function Ipr_Fps_Booster_Vgui_Func()
    if IsValid(ipr_vgui_func) then
        ipr_vgui_func:Remove()
    end
    if IsValid(ipr_vgui) then
        ipr_vgui:Remove()
    end

    ipr_vgui = vgui.Create("DFrame")
    local ipr_sheet = vgui.Create("DPropertySheet", ipr_vgui)
    local ipr_box = vgui.Create("DComboBox", ipr_vgui)
    local ipr_close = vgui.Create("DImageButton", ipr_vgui)

    local ipr_url = vgui.Create("DButton", ipr_vgui)
    local ipr_dbut_enable = vgui.Create("DButton", ipr_vgui)
    local ipr_dbut_disable = vgui.Create("DButton", ipr_vgui)
    local ipr_dbut_config = vgui.Create("DButton", ipr_vgui)
    local ipr_dbut_fps = vgui.Create("DButton", ipr_vgui)

    ipr_vgui:SetTitle("")
    ipr_vgui:SetSize(300, 270)
    ipr_vgui:MakePopup()
    ipr_vgui:ShowCloseButton(false)
    ipr_vgui:SetDraggable(true)
    ipr_vgui:Center()
    ipr_vgui:AlphaTo(5, 0, 0)
    ipr_vgui:AlphaTo(255, 1, 0)

    local ipr_lang = Ipr_RequestLang()
    ipr_vgui.Paint = function(self, w, h)
        IprFpsBooster_GuiBlur(self, 2, Color( 0, 0, 0, 170 ), 8)
        local ipr_status_gui = IprFpsBooster_Status(true)

        draw.RoundedBoxEx(6, 0, 0, w, 33, ipr.color["bleu"], true, true, false, false)
        draw.SimpleText("FPS :","Ipr_Fps_Booster_Font",(ipr_status_gui and w/2 -25) or w/2 -10,16, ipr.color["blanc"], TEXT_ALIGN_CENTER)

        ipr_lang = Ipr_RequestLang()
        draw.SimpleText(Ipr_Fps_Booster.Lang[ipr_lang].ipr_vgui_enabled,"Ipr_Fps_Booster_Font",w/2,1, ipr.color["blanc"], TEXT_ALIGN_CENTER)
        draw.SimpleText((ipr_status_gui and "On (Boost)") or "Off", "Ipr_Fps_Booster_Font",(ipr_status_gui and w/2 + 22) or w/2 + 18,16, ipr_status_gui and ipr.color["vert"] or ipr.color["rouge"], TEXT_ALIGN_CENTER)
    end
    ipr_sheet:Dock(FILL)
    ipr_sheet:DockPadding(52, 10, 0, 0)

    do
        local ipr_rotate = {start = 10, s_end = 35, step = 5}
        
        local ipr_copy = table.Copy(ipr_rotate)
        ipr_copy.nextstep = 0.2
        ipr_copy.update = 0

        local function ipr_AnimLoop()
            local ipr_Cur = CurTime()
            if (ipr_Cur > ipr_copy.update) then
                for i = ipr_copy.start, ipr_copy.s_end, ipr_copy.step do
                    ipr_copy.start = i + ipr_copy.step

                    if (i == ipr_copy.s_end) then
                        local ipr_min = (ipr_copy.step < 0)

                        ipr_copy.start = ipr_min and ipr_rotate.start or ipr_copy.s_end
                        ipr_copy.s_end = ipr_min and ipr_rotate.s_end or ipr_rotate.start
                        ipr_copy.step = ipr_min and ipr_rotate.step or -ipr_rotate.step
                    end
                    break
                end
                ipr_copy.update = ipr_Cur + ipr_copy.nextstep
            end
            return ipr_copy.start
        end

        function surface.ipr_DrawAnim(x, y, w, h, rot, x0)
            local r = math.rad(rot)
            local c, s = math.cos(r), math.sin(r)
            local newx = s - x0 * c
            local newy = c + x0 * s

            surface.DrawTexturedRectRotated(x + newx, y + newy, w, h, rot)
        end

        local function ipr_LimitFps(s)
            return (math.abs(s) > 999) and 999 or s
        end

        local ipr_icon_computer = Material("icon/ipr_boost_computer.png", "noclamp smooth")
        local ipr_icon_wrench = Material("icon/ipr_boost_wrench.png", "noclamp smooth")
        ipr_sheet.Paint = function(self, w, h)
            local ipr_c, ipr_m, ipr_mx, ipr_gn = IprFpsBooster_CalcFps()
            local ipr_status_gui = IprFpsBooster_Status(true)

            draw.SimpleText("FPS Status","Ipr_Fps_Booster_Font",w/2,h/2-63, ipr.color["blanc"], TEXT_ALIGN_CENTER)
            draw.SimpleText("Max : ","Ipr_Fps_Booster_Font",w/2-10,h/2-31, ipr.color["blanc"], TEXT_ALIGN_CENTER)
            draw.SimpleText("Min : ","Ipr_Fps_Booster_Font",w/2-10,h/2-16, ipr.color["blanc"], TEXT_ALIGN_CENTER)
            draw.SimpleText("Gain : ","Ipr_Fps_Booster_Font",w/2-10, h/2-1, ipr.color["blanc"], TEXT_ALIGN_CENTER)
            draw.SimpleText(Ipr_Fps_Booster.Lang[ipr_lang].ipr_vgui_fps_cur,"Ipr_Fps_Booster_Font",w/2-10,h/2-46, ipr.color["blanc"], TEXT_ALIGN_CENTER)

            draw.SimpleText(ipr_LimitFps(ipr_c), "Ipr_Fps_Booster_Font",w/2+15,h/2-46, ipr_RgbTransition(ipr_c), TEXT_ALIGN_LEFT)
            draw.SimpleText(ipr_LimitFps(ipr_mx),"Ipr_Fps_Booster_Font",w/2+10,h/2-31, ipr_RgbTransition(ipr_mx), TEXT_ALIGN_LEFT)
            draw.SimpleText(ipr_LimitFps(ipr_m),"Ipr_Fps_Booster_Font",w/2+10,h/2-16, ipr_RgbTransition(ipr_m), TEXT_ALIGN_LEFT)
            draw.SimpleText((ipr_status_gui and (ipr_mx ~= ipr_gn) and ipr_LimitFps(ipr_gn) or "OFF"),"Ipr_Fps_Booster_Font",w/2+10, h/2-1, ipr_status_gui and (ipr_mx ~= ipr_gn) and ipr.color["vert"] or ipr.color["rouge"], TEXT_ALIGN_LEFT)

            surface.SetMaterial(ipr_icon_computer)
            surface.SetDrawColor(255, 255, 255, 255)
            surface.DrawTexturedRect(-10, 0, 350, 235)

            surface.SetMaterial(ipr_icon_wrench)
            surface.SetDrawColor(255, 255, 255, 255)
            local ipr_loop = ipr_AnimLoop()
            surface.ipr_DrawAnim(207, 120, 220, 220, ipr_loop, -25)
        end
    end

    ipr_url:SetPos(97, 80)
    ipr_url:SetSize(110, 90)
    ipr_url:SetText("")
    function ipr_url:Paint(w, h) end
    ipr_url.DoClick = function()
        gui.OpenURL("https://steamcommunity.com/sharedfiles/filedetails/?id=1762151370")
    end

    ipr_dbut_enable:SetPos(6, 240)
    ipr_dbut_enable:SetSize(110, 24)
    ipr_dbut_enable:SetImage("icon16/tick.png")
    ipr_dbut_enable:SetText("")
    function ipr_dbut_enable:Paint(w, h)
        draw.RoundedBox( 6, 0, 0, w, h, self:IsHovered() and ipr.color["bleuc"] or ipr.color["bleu"])
        draw.SimpleText(Ipr_Fps_Booster.Lang[ipr_lang].ipr_vgui_enable_t, "Ipr_Fps_Booster_Font", w / 2 + 3, 3, ipr.color["blanc"], TEXT_ALIGN_CENTER)
    end
    ipr_dbut_enable.DoClick = function()
        if not IprFpsBooster_Cmds(true) then
            return chat.AddText(ipr.color["rouge"], "[", "FPS Booster", "] : ", ipr.color["blanc"], "Please check boxes in optimization to activate the fps booster !")
        end
        if IprFpsBooster_Cmds() then
            IprFpsBooster_Enable(false)
            Ipr_ResetValue(true)

            IprFpsBooster_Enable(true)
            IprFpsBooster_Status(false, true)
            chat.AddText(ipr.color["rouge"], "[", "FPS Booster", "] : ", ipr.color["blanc"], Ipr_Fps_Booster.Lang[ipr_lang].ipr_vgui_enable_prevent_t)
        else
            chat.AddText(ipr.color["rouge"], "[", "FPS Booster", "] : ", ipr.color["blanc"], "Already enabled !")
        end

        if IprFpsBooster_CVar(3, nil, 16) then
            if IsValid(ipr_vgui) then
                ipr_vgui:Remove()
            end

            if IsValid(ipr_vgui_func) then
                ipr_vgui_func:Remove()
            end
        end

        surface.PlaySound("buttons/combine_button7.wav")
    end

    ipr_dbut_disable:SetPos(184, 240)
    ipr_dbut_disable:SetSize(110, 24)
    ipr_dbut_disable:SetImage("icon16/cross.png")
    ipr_dbut_disable:SetText("")
    function ipr_dbut_disable:Paint(w, h)
        draw.RoundedBox( 6, 0, 0, w, h, self:IsHovered() and ipr.color["bleuc"] or ipr.color["bleu"])
        draw.SimpleText(Ipr_Fps_Booster.Lang[ipr_lang].ipr_vgui_disable_t, "Ipr_Fps_Booster_Font", w / 2 + 6, 3, ipr.color["blanc"], TEXT_ALIGN_CENTER)
    end
    ipr_dbut_disable.DoClick = function()
        if not IprFpsBooster_Cmds() then
            Ipr_ResetValue()
            IprFpsBooster_Status(false, false)
            IprFpsBooster_Enable(false)

            chat.AddText(ipr.color["rouge"], "[", "FPS Booster", "] : ", ipr.color["blanc"], Ipr_Fps_Booster.Lang[ipr_lang].ipr_vgui_disableop_t)
        else
            chat.AddText(ipr.color["rouge"], "[", "FPS Booster", "] : ", ipr.color["blanc"], "Already disabled !")
        end

        if IprFpsBooster_CVar(3, nil, 16) then
            if IsValid(ipr_vgui) then
                ipr_vgui:Remove()
            end

            if IsValid(ipr_vgui_func) then
                ipr_vgui_func:Remove()
            end
        end

        surface.PlaySound("buttons/combine_button5.wav")
    end

    ipr_dbut_config:SetPos(200, 38)
    ipr_dbut_config:SetSize(95, 20)
    ipr_dbut_config:SetText("")
    ipr_dbut_config:SetImage("icon16/cog.png")
    function ipr_dbut_config:Paint(w, h)
        draw.RoundedBox( 6, 0, 0, w, h, self:IsHovered() and ipr.color["bleuc"] or ipr.color["bleu"])
        draw.SimpleText("Options ", "Ipr_Fps_Booster_Font", w / 2 + 7, 1, ipr.color["blanc"], TEXT_ALIGN_CENTER)
    end
    ipr_dbut_config.DoClick = function()
        if IsValid(ipr_vgui_func) then
            return
        end

        Ipr_Booster_Option_Func(ipr_vgui)
        surface.PlaySound("buttons/button9.wav")
    end

    ipr_dbut_fps:SetPos(77, 192)
    ipr_dbut_fps:SetSize(150, 20)
    ipr_dbut_fps:SetText("")
    ipr_dbut_fps:SetImage("icon16/arrow_refresh.png")
    function ipr_dbut_fps:Paint(w, h)
        draw.RoundedBox( 6, 0, 0, w, h, self:IsHovered() and ipr.color["bleuc"] or ipr.color["bleu"])
        draw.SimpleText("Reset FPS max/min", "Ipr_Fps_Booster_Font", w / 2 + 7, 1, ipr.color["blanc"], TEXT_ALIGN_CENTER)
    end
    ipr_dbut_fps.DoClick = function()
        Ipr_ResetValue(true)
        surface.PlaySound("buttons/button9.wav")
    end

    ipr_box:SetPos(5, 38)
    ipr_box:SetSize(105, 20)
    ipr_box:SetFont("Ipr_Fps_Booster_Font")
    ipr_box:SetValue(Ipr_Fps_Booster.Lang[ipr_lang].ipr_vgui_Lang.. " " ..ipr_lang)
    for lang in pairs(Ipr_Fps_Booster.Lang) do
        ipr_box:AddChoice(Ipr_Fps_Booster.Lang[ipr_lang].ipr_vgui_Lang.. " " ..lang)
    end
    ipr_box:SetTextColor( ipr.color["blanc"] )
    function ipr_box:Paint(w, h)
        draw.RoundedBox( 6, 0, 0, w, h, self:IsHovered() and ipr.color["bleuc"] or ipr.color["bleu"])
    end
    IprFpsBooster_Override(ipr_box, 1)
    ipr_box.OnMenuOpened = function(self)
        for _, v in pairs(self:GetChildren()) do
            v.Paint = function(p, w, h)
                draw.RoundedBox(6, 0, 0, w, h, ipr.color["bleu"])
            end

            if (v:GetName() == "DPanel") then
               continue
            end
            for _, d in pairs(v:GetChildren()) do
                if (d:GetName() == "DVScrollBar") then
                   continue
                end

                for _, y in pairs(d:GetChildren()) do
                    y:SetTextColor(ipr.color["blanc"])
                    y:SetFont( "Ipr_Fps_Booster_Font" )
                end
            end
        end
        IprFpsBooster_Override(self, 1)
    end
    ipr_box.OnSelect = function(self, index, value)
        local ipr_tlang = string.Replace(value, Ipr_Fps_Booster.Lang[ipr_lang].ipr_vgui_Lang.. " ", "")
        if (ipr_tlang == ipr_lang) then
            return
        end

        self:Clear()
        self:SetValue(Ipr_Fps_Booster.Lang[ipr_tlang].ipr_vgui_Lang.. " " ..ipr_tlang)
        for data in pairs(Ipr_Fps_Booster.Lang) do
            self:AddChoice(Ipr_Fps_Booster.Lang[ipr_tlang].ipr_vgui_Lang.. " " ..data)
        end

        Ipr_UpdateLang(ipr_tlang)
        surface.PlaySound("buttons/button9.wav")
    end

    ipr_close:SetPos(280, 3)
    ipr_close:SetSize(17, 17)
    ipr_close:SetImage("icon16/cross.png")
    function ipr_close:Paint(w, h) end
    ipr_close.DoClick = function()
        if IsValid(ipr_vgui_func) then
            ipr_vgui_func:Remove()
        end
        if IsValid(ipr_vgui) then
            ipr_vgui:Remove()
        end
    end
end

local function IprFpsBooster_ChatVgui(ply, str)
    local ipr_ply = LocalPlayer()
    if (ply ~= ipr_ply) then
        return
    end
    str = string.lower(str)

    if (str  == "/boost")  then
        return true, Ipr_Fps_Booster_Vgui_Func()
    elseif (str == "/reset") then
        local ipr_cmd = IprFpsBooster_Cmds()
        if ipr_cmd then
            return false, chat.AddText(ipr.color["rouge"], "[", "Improved FPS Booster", "] : ", ipr.color["blanc"], "Already disabled !")
        end
        IprFpsBooster_Status(false, true)
        Ipr_ResetValue()

        IprFpsBooster_Enable(false)
        return true, surface.PlaySound("buttons/combine_button5.wav")
    end
end  

local ipr_wd, ipr_ht, ipr_mp = ScrW(), ScrH(), game.GetMap()
local function IprFpsBooster_OnScreen()
    ipr_wd, ipr_ht = ScrW(), ScrH()
end

local function IprFpsBooster_PostDraw()
    local ipr_hud = IprFpsBooster_CVar(3, nil, 15)
    if not ipr_hud then
        return
    end
    local ipr_w = IprFpsBooster_CVar(3, nil, 18) / 100
    local ipr_h = IprFpsBooster_CVar(3, nil, 19) / 100
    local ipr_c, ipr_m, ipr_mx, ipr_gn = IprFpsBooster_CalcFps()

    draw.SimpleText("Fps : " ..ipr_c.. " Min : " ..ipr_m.. " Max : " ..ipr_mx.. " " ..(IprFpsBooster_Status(true) and (Ipr_Mx ~= ipr_gn) and "Gain : " ..ipr_gn or ""), "Ipr_Fps_Booster_Font", ipr_wd * ipr_w,  ipr_ht * ipr_h, ipr.color["blanc"], TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT)
    draw.SimpleText("Map : " ..ipr_mp, "Ipr_Fps_Booster_Font", ipr_wd * ipr_w,  ipr_ht * ipr_h + 20, ipr.color["blanc"], TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT)
end

local function IprFpsBooster_InitEnt(r)
    local ipr_dir = file.Exists(ipr.save, "DATA")
    if not ipr_dir then
        file.CreateDir(ipr.save)
    end

    local ipr_find_lang = file.Exists(ipr.save.. "_lang.json", "DATA")
    if not ipr_find_lang then
        Ipr_UpdateLang(Ipr_Fps_Booster.Country[system.GetCountry()] and "FR" or Ipr_Fps_Booster.DefaultLanguage)
    else
        Ipr_UpdateLang()
    end

    local ipr_find_save = file.Exists(ipr.save.. "_save.json", "DATA")
    if not ipr_find_save then
        Ipr_UpdateVgui(false, true)
    else
        Ipr_UpdateVgui(true)
    end

    local ipr_cvar = IprFpsBooster_CVar(3, nil, 17)
    if (ipr_cvar) then
        IprFpsBooster_Enable(false)
    end

    timer.Simple(5, function()
        local ipr_cmd = IprFpsBooster_Cmds()
        if (ipr_cmd) then
            if (r) then
                return
            end

            Ipr_Fps_Booster_Vgui_Func()
        else
            if (ipr_cvar) then
                Ipr_Fps_Booster_Vgui_Func()
                return
            end
            Ipr_ResetValue(true)
            IprFpsBooster_Status(false, true)

            print("[Improved FPS Booster automatically started")
            chat.AddText(ipr.color["vert"], "[", "Improved FPS Booster automatically started", "]")
        end
    end)

    local ipr_hook = hook.GetTable()
    if ipr_hook["PostDrawHUD"] and ipr_hook["PostDrawHUD"]["IprFpsBooster_PostDraw"] then
        hook.Remove("PostDrawHUD", "IprFpsBooster_PostDraw")
    end
    hook.Add("PostDrawHUD", "IprFpsBooster_PostDraw", IprFpsBooster_PostDraw)
end 
if (Ipr_Fps_Booster.Loaded_Lua) then
    IprFpsBooster_InitEnt(true)
end
  
Ipr_Fps_Booster.Loaded_Lua = Ipr_Fps_Booster.Loaded_Lua or {}
hook.Add("OnScreenSizeChanged", "IprFpsBooster_OnScreen", IprFpsBooster_OnScreen)
hook.Add("InitPostEntity", "IprFpsBooster_InitEnt", IprFpsBooster_InitEnt)
hook.Add("OnPlayerChat", "IprFpsBooster_ChatVgui", IprFpsBooster_ChatVgui)
