// Script by Inj3
// Steam : https://steamcommunity.com/id/Inj3/
// Discord : Inj3
// General Public License v3.0
// https://github.com/Inj3-GT

local ipr = {}

ipr.Settings = include("table.lua")
ipr.Data = include("include.lua")
ipr.Function = {}

ipr.Function.CreateData = function()
    local ipr_createdir = file.IsDir(ipr.Settings.Save, "DATA")
    if not ipr_createdir then
        file.CreateDir(ipr.Settings.Save)
    end

    local ipr_dirlang, ipr_setlang = ipr.Settings.Save.. "language.json"
    local ipr_flangs = file.Exists(ipr_dirlang, "DATA")

    local ipr_checksize = file.Size(ipr_dirlang, "DATA")
    if (ipr_checksize == 0) then
        ipr_flangs = false
    end
    if not ipr_flangs then
        local ipr_filecountry = file.Exists("ipr_fps_booster_language/" ..string.lower(ipr.Settings.Country.target).. ".lua", "LUA")
        if (ipr_filecountry) then
            local ipr_getcountry = system.GetCountry()
            if (ipr_getcountry) and ipr.Settings.Country.code[ipr_getcountry] then
                ipr_setlang = ipr.Settings.Country.target
            end
        end
        if not ipr_setlang or (ipr_setlang == "") then
            ipr_setlang = ipr.Function.SearchLang()
        end

        ipr.Settings.SetLang = ipr_setlang
        file.Write(ipr_dirlang, ipr_setlang)
    end
    if not ipr_setlang then
        ipr.Settings.SetLang = file.Read(ipr_dirlang, "DATA")
    end

    local ipr_fileconvars, ipr_setconvars = file.Exists(ipr.Settings.Save.. "convars.json", "DATA")
    if not ipr_fileconvars then
        ipr_setconvars = {}

        local ipr_ConvarsLists = ipr.Data.Default.convars
        for i = 1, #ipr_ConvarsLists do
            ipr_setconvars[#ipr_setconvars + 1] = {
                Name = ipr_ConvarsLists[i].Name,
                Checked = ipr_ConvarsLists[i].DefaultCheck
            }
        end

        local ipr_settingslists = ipr.Data.Default.settings
        for i = 1, #ipr_settingslists do
            ipr_setconvars[#ipr_setconvars + 1] = {
                Vgui = ipr_settingslists[i].Vgui,
                Name = ipr_settingslists[i].Name,
                Checked = ipr_settingslists[i].DefaultCheck
            }
        end

        ipr.Settings.SetConvars = ipr_setconvars
        file.Write(ipr.Settings.Save.. "convars.json", util.TableToJSON(ipr_setconvars))
    end
    if not ipr_setconvars then
        ipr.Settings.SetConvars = util.JSONToTable(file.Read(ipr.Settings.Save.. "convars.json", "DATA"))
    end

    local ipr_checkmatch = ipr.Function.Activate(true, true)
    if not ipr_checkmatch then
        ipr.Settings.Status.State = true
    end
end

ipr.Function.SearchLang = function()
    local ipr_dlang = ipr.Settings.SetLang
    local ipr_defaultlang = file.Exists("ipr_fps_booster_language/" ..ipr_dlang.. ".lua", "LUA")
    if (ipr_defaultlang) then 
        return ipr_dlang
    end

    local ipr_searchlang = file.Find("ipr_fps_booster_language/*", "LUA")
    for i = 1, #ipr_searchlang do
        local ipr_lang = ipr_searchlang[i]
        local ipr_size = file.Size("ipr_fps_booster_language/" ..ipr_lang, "LUA")

        if (ipr_size ~= 0) then
            return string.upper(string.gsub(ipr_lang, ".lua", ""))
        end
    end

    return ipr_dlang
end

ipr.Function.GetConvar = function(name)
    for i = 1, #ipr.Settings.SetConvars do
        local ipr_convars = ipr.Settings.SetConvars[i]

        if (ipr_convars.Name == name) then
            return ipr_convars.Checked
        end
    end
    if (ipr.Settings.Debug) then
        print("Convar not found !", " " ..name)
    end

    return nil
end

ipr.Function.SetConvar = function(name, value, save, exist, copy)
    local ipr_convar = (ipr.Function.GetConvar(name) == nil)

    if (ipr_convar) then
        ipr.Settings.SetConvars[#ipr.Settings.SetConvars + 1] = {
            Name = name,
            Checked = value,
        }
        local ipr_newdata = util.TableToJSON(ipr.Settings.SetConvars)
        ipr.Function.SaveConvar(ipr_newdata)

        if (copy) then
            ipr.Function.CopyData()
        end
        if (ipr.Settings.Debug) then
            print("Creating a new convar : " ..name, value, save)
        end
    else
        if (exist) then
            return
        end

        for i = 1, #ipr.Settings.SetConvars do
            local ipr_togglecount = ipr.Settings.SetConvars[i]

            if (ipr_togglecount.Name == name) then
                ipr.Settings.SetConvars[i].Checked = value
                break
            end
        end

        if (save == 1) then
            local ipr_saveconvar = "IprFpsBooster_SetConvar"
            if (timer.Exists(ipr_saveconvar)) then
                timer.Remove(ipr_saveconvar)
            end

            timer.Create(ipr_saveconvar, 1, 1, function()
                ipr.Function.SaveConvar()
            end)
        elseif (save == 2) then
            ipr.Function.SaveConvar()
        end
    end
end

ipr.Function.SaveConvar = function(json)
    local ipr_tconvars = (json) or util.TableToJSON(ipr.Settings.SetConvars)
    file.Write(ipr.Settings.Save.. "convars.json", ipr_tconvars)
end

ipr.Function.InfoNum = function(cmd, exist)
    local ipr_infonum = LocalPlayer():GetInfoNum(cmd, -99)
    if (exist) then
        return (ipr_infonum == -99)
    end

    return tonumber(ipr_infonum)
end

ipr.Function.IsChecked = function()
    for i = 1, #ipr.Settings.SetConvars do
        if not ipr.Settings.SetConvars[i].Vgui and (ipr.Settings.SetConvars[i].Checked == true) then
            return true
        end
    end
    
    return false
end

ipr.Function.CurrentState = function()
    return ipr.Settings.Status.State
end

ipr.Function.Activate = function(bool, match)
    local ipr_convarscheck = bool

    for i = 1, #ipr.Data.Default.convars do
        local ipr_namecommand = ipr.Data.Default.convars[i].Name
        local ipr_convarcommand = ipr.Data.Default.convars[i].Convars

        for k, v in pairs(ipr_convarcommand) do
            if isbool(ipr.Function.GetConvar(ipr_namecommand)) then
                if (bool) then
                    ipr_convarscheck = ipr.Function.GetConvar(ipr_namecommand)
                end

                local ipr_toggle = (ipr_convarscheck) and v.Enabled or v.Disabled
                ipr_toggle = tonumber(ipr_toggle)

                local ipr_infocmds = ipr.Function.InfoNum(k)
                if ipr.Function.InfoNum(k, true) or (ipr_infocmds == ipr_toggle) then
                    continue
                end
                if (match) then
                    return true
                end
                RunConsoleCommand(k, ipr_toggle)

                if (ipr.Settings.Debug) then
                    print("Updating " ..k.. " set " ..ipr_infocmds.. " to " ..ipr_toggle)
                end
            end
        end
    end

    if (ipr.Settings.Status.State ~= bool) then
        ipr.Function.ResetFps()
        ipr.Settings.Status.State = bool
    end
end

local math = math

ipr.Function.FpsCalculator = function()
    local ipr_systime = SysTime()

    if ipr_systime > (ipr.CurNext or 0) then
        local ipr_absoluteframetime = engine.AbsoluteFrameTime()
        
        ipr.Settings.FpsCurrent = math.Round(1 / ipr_absoluteframetime)
        ipr.Settings.FpsCurrent = (ipr.Settings.FpsCurrent > ipr.Settings.MaxFps) and ipr.Settings.MaxFps or ipr.Settings.FpsCurrent

        if (ipr.Settings.FpsCurrent < ipr.Settings.Fps.Min.Int) then
            ipr.Settings.Fps.Min.Int = ipr.Settings.FpsCurrent
        end
        if (ipr.Settings.FpsCurrent > ipr.Settings.Fps.Max.Int) then
            ipr.Settings.Fps.Max.Int = ipr.Settings.FpsCurrent
        end
        
        ipr.Settings.Fps.Low.Current = ipr.Settings.Fps.Low.Current or ipr.Settings.Fps.Min.Int

        local ipr_countframe = #ipr.Settings.Fps.Low.Frame
        if (ipr_countframe < ipr.Settings.Fps.Low.MaxFrame) then
            local ipr_Iinsertframe = ipr_countframe + 1
            
            ipr.Settings.Fps.Low.Frame[ipr_Iinsertframe] = ipr.Settings.FpsCurrent
        else
            table.sort(ipr.Settings.Fps.Low.Frame, function(a, b) 
                return a < b 
            end)

            ipr.Settings.Fps.Low.Current = ipr.Settings.Fps.Low.Frame[2]
            ipr.Settings.Fps.Low.Frame = {}
        end

        ipr.CurNext = ipr_systime + 0.3
    end

    local ipr_fmin = ipr.Settings.Fps.Min.Int
    ipr_fmin = (ipr_fmin == math.huge) and ipr.Settings.Fps.Max.Int or ipr_fmin

    return ipr.Settings.FpsCurrent, ipr_fmin, ipr.Settings.Fps.Max.Int, ipr.Settings.Fps.Low.Current
end

ipr.Function.CopyData = function()
    local ipr_tdata = {}
    local ipr_dname = {
        ["Startup"] = true,
    }

    for i = 1, #ipr.Settings.SetConvars do
        local ipr_copylist = ipr.Settings.SetConvars[i]

        if not ipr_dname[ipr_copylist.Name] and not ipr_copylist.Vgui then
            ipr_tdata[#ipr_tdata + 1] = ipr_copylist
        end
    end

    ipr.Settings.Revert = {
        Copy = table.Copy(ipr_tdata), 
        Set = false,
    }
end

ipr.Function.GetCopyData = function()
    return ipr.Settings.Revert.Copy
end

ipr.Function.ResetFps = function()
    ipr.Settings.Fps.Min.Int = math.huge
    ipr.Settings.Fps.Max.Int = 0
end

ipr.Function.ColorTransition = function(int)
    return (int <= 30) and ipr.Settings.TColor["rouge"] or (int > 30 and int <= 50) and ipr.Settings.TColor["orange"] or ipr.Settings.TColor["vert"]
end

ipr.Function.RenderBlur = function(panel, colors, border)
    surface.SetDrawColor(ipr.Settings.TColor["blanc"])
    surface.SetMaterial(ipr.Settings.Blur)

    local ipr_posx, ipr_posy = panel:LocalToScreen(0, 0)
    ipr.Settings.Blur:SetFloat("$blur", 1.5)
    ipr.Settings.Blur:Recompute()

    render.UpdateScreenEffectTexture()
    surface.DrawTexturedRect(ipr_posx * -1, ipr_posy * -1, ipr.Settings.Pos.w, ipr.Settings.Pos.h)

    local ipr_vguiwide = panel:GetWide()
    local ipr_vguiheight = panel:GetTall()

    draw.RoundedBoxEx(border, 0, 0, ipr_vguiwide, ipr_vguiheight, colors, true, true, true, true)
end

ipr.Function.FogActivate = function(bool)
    if not bool then
        hook.Remove("SetupWorldFog", "IprFpsBooster_WorldFog")
        hook.Remove("SetupSkyboxFog", "IprFpsBooster_SkyboxFog")
    else
        hook.Add("SetupWorldFog", "IprFpsBooster_WorldFog", function()
            render.FogMode(MATERIAL_FOG_LINEAR)
            render.FogStart(ipr.Function.GetConvar("FogStart"))
            render.FogEnd(ipr.Function.GetConvar("FogEnd"))
            render.FogMaxDensity(0.9)

            render.FogColor(171, 174, 176)

            return true
        end)

        hook.Add("SetupSkyboxFog", "IprFpsBooster_SkyboxFog", function(scale)
            render.FogMode(MATERIAL_FOG_LINEAR)
            render.FogStart(ipr.Function.GetConvar("FogStart") * scale)
            render.FogEnd(ipr.Function.GetConvar("FogEnd") * scale)
            render.FogMaxDensity(0.9)

            render.FogColor(171, 174, 176)

            return true
        end)
    end
end

ipr.Function.DrawMultipleTextAligned = function(tbl)
    local ipr_oldwide = 0
    local ipr_newwide = 0

    for t = 1, #tbl do
        local ipr_texttbl = tbl[t]
        local ipr_pos = ipr_texttbl.Pos

        for i = 1, #ipr_texttbl do
            ipr_newwide = ipr_oldwide

            surface.SetFont(ipr.Settings.Font)

            local ipr_nametext = ipr_texttbl[i].Name
            local ipr_twide = surface.GetTextSize(ipr_nametext)
            ipr_oldwide = ipr_oldwide + ipr_twide + ipr.Settings.Escape

            local ipr_talign = ipr_pos.PWide + ipr_newwide
            draw.SimpleTextOutlined(ipr_nametext, ipr.Settings.Font, ipr_talign, ipr_pos.PHeight, ipr_texttbl[i].FColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT, 1, ColorAlpha(color_black, 100))
        end

        ipr_oldwide = 0
    end
end

ipr.Function.SetToolTip = function(text, panel, localization)
    if not IsValid(ipr.Settings.Vgui.ToolTip) then
        ipr.Settings.Vgui.ToolTip = vgui.Create("DPanel")
        ipr.Settings.Vgui.ToolTip:SetText("")
        ipr.Settings.Vgui.ToolTip:SetDrawOnTop(true)

        local ipr_text = text
        local ipr_iconsize = 16
        local ipr_cboxsize = 9
        ipr.Settings.Vgui.ToolTip.Text = function(text) 
            surface.SetFont(ipr.Settings.Font)
            local ipr_twide, ipr_theight = surface.GetTextSize(text)
            ipr.Settings.Vgui.ToolTip:SetSize(ipr_twide + ipr_iconsize + ipr_cboxsize, ipr_theight + 1)

            ipr_text = text
        end
        ipr.Settings.Vgui.ToolTip.Paint = function(self, w, h)
            ipr.Function.RenderBlur(self, ColorAlpha(color_black, 130), 6)

            surface.SetDrawColor(color_white)
            surface.SetMaterial(ipr.Settings.IToolTip)
            surface.DrawTexturedRect(2, 2, ipr_iconsize, ipr_iconsize)
 
            draw.SimpleText(ipr_text, ipr.Settings.Font, ipr_iconsize + ipr_cboxsize / 2 - 2, 1, ipr.Settings.TColor["blanc"], TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT)
        end

        ipr.Settings.Vgui.ToolTip:SetVisible(false)
    end
    if not IsValid(panel) then
        return
    end
    
    local ipr_overridechildren = panel:GetChildren()
    local ipr_namevgui = panel:GetName()
    local ipr_vguimanage = {
        ["DButton"] = {Panel = true},
        ["DImageButton"] = {Panel = true},
        ["DCheckBox"] = {Panel = false, Parent = panel:GetParent()},
    }

    if (ipr_vguimanage[ipr_namevgui].Panel) then
        ipr_overridechildren[#ipr_overridechildren + 1] = panel
    end
    if (ipr_vguimanage[ipr_namevgui].Parent) then
        ipr_overridechildren[#ipr_overridechildren + 1] = ipr_vguimanage[ipr_namevgui].Parent
    end

    for i = 1, #ipr_overridechildren do
        local ipr_overridechild = ipr_overridechildren[i]
        
        ipr_overridechild.OnCursorMoved = function(self)
            if not IsValid(ipr.Settings.Vgui.ToolTip) then
                return
            end

            local ipr_inputx, ipr_inputy = input.GetCursorPos()
            local ipr_pos = ipr_inputx - ipr.Settings.Vgui.ToolTip:GetWide() / 2

            ipr.Settings.Vgui.ToolTip:SetPos(ipr_pos, ipr_inputy - 30)
        end
        ipr_overridechild.OnCursorExited = function()
            if not IsValid(ipr.Settings.Vgui.ToolTip) then
                return
            end

            ipr.Settings.Vgui.ToolTip:SetVisible(false)
        end
        ipr_overridechild.OnCursorEntered = function(self)
            if not IsValid(ipr.Settings.Vgui.ToolTip) then
                return
            end
            ipr.Settings.Vgui.ToolTip.Text((localization) and text or ipr.Data.Lang[ipr.Settings.SetLang][text])
            ipr.Settings.Vgui.ToolTip:SetVisible(true)

            ipr.Settings.Vgui.ToolTip:SetAlpha(0)
            ipr.Settings.Vgui.ToolTip:AlphaTo(255, 0.8, 0)
        end
    end
end

ipr.Function.DCheckBoxLabel = function(panel, tbl)
    local ipr_soptipanel = vgui.Create("DPanel", panel)
    ipr_soptipanel:Dock(TOP)
    ipr_soptipanel:SetTall(20)
    ipr_soptipanel:DockMargin(0, 5, 0, 5)
    ipr_soptipanel.Paint = nil

    local ipr_soptibutton = vgui.Create("DCheckBox", ipr_soptipanel)
    ipr_soptibutton:DockMargin(0, 0, 5, 0)
    ipr_soptibutton:Dock(LEFT)
    ipr_soptibutton:SetWide(35)

    local ipr_checked = ipr.Function.GetConvar(tbl.Name)
    ipr_soptibutton:SetValue(ipr_checked)
    ipr_soptibutton.SLerp = (ipr_checked) and ipr_soptibutton:GetTall() + 3 or 6

    ipr_soptibutton.Paint = function(self, w, h)
        local ipr_framechecked = self:GetChecked()
        local ipr_posw = (ipr_framechecked) and (w / 2 ) + 2 or 6

        self.SLerp = Lerp(SysTime() * 13, self.SLerp or ipr_posw, ipr_posw)

        draw.RoundedBox(12, 2, 2, w - 4, h - 4, (ipr_framechecked) and ipr.Settings.TColor["bleu"] or ipr.Settings.TColor["gris"])
        draw.RoundedBox(12, self.SLerp, 5, 10, 10, ipr.Settings.TColor["blanc"])
        
        surface.DrawCircle(self.SLerp + 5, 10, 6, ColorAlpha(color_black, 90))
    end
    ipr_soptibutton.DoClick = function(self)
        local ipr_soundchecked = self:GetChecked() and "garrysmod/ui_return.wav" or "buttons/button15.wav"
        surface.PlaySound(ipr_soundchecked)

        self:Toggle()
    end

    local ipr_sLabel = vgui.Create("DLabel", ipr_soptipanel)
    ipr_sLabel:Dock(FILL)
    ipr_sLabel:SetFont(ipr.Settings.Font)
    ipr_sLabel:SetText("")

    ipr_sLabel.Paint = function(self, w, h)
        local ipr_color = ipr_soptibutton:IsHovered() and ipr.Settings.TColor["vert"] or ipr.Settings.TColor["blanc"]
        draw.SimpleText(ipr.Data.Lang[ipr.Settings.SetLang][tbl.Localization.Text], ipr.Settings.Font, 0, 1, ipr_color, TEXT_ALIGN_LEFT)
    end

    return ipr_soptibutton, ipr_soptipanel
end

ipr.Function.DScrollPaint = function(panel, int)
    panel = panel:GetVBar()
    panel:SetWide(int)

    panel.btnUp:SetSize(0, 0)
    panel.btnDown:SetSize(0, 0)

    panel.PerformLayout = function(self)
        local ipr_wide = self:GetWide()
        local ipr_tall = self:GetTall()

        local ipr_scroll = self:GetScroll() / self.CanvasSize
        local ipr_bar = math.max(self:BarScale() *  ipr_tall, 10)

        local ipr_bartall = ipr_tall - ipr_bar
        ipr_bartall = ipr_bartall + 1
        ipr_scroll = ipr_scroll * ipr_bartall

        self.btnGrip:SetPos(0, ipr_scroll)
        self.btnGrip:SetSize(ipr_wide, ipr_bar)
    end

    panel.Paint = function(self, w, h)
        draw.RoundedBox(5, 0, 0, w, h, ColorAlpha(color_black, 65))
    end

    panel.btnGrip.Paint = function(self, w, h)
        draw.RoundedBox(5, 0, 0, w, h, ipr.Settings.TColor["bleu"])
    end
end

ipr.Function.DNumSlider = function(panel, tbl)
    local ipr_dnumpanel = vgui.Create("DPanel", panel)
    ipr_dnumpanel:SetSize(225, 39)
    ipr_dnumpanel:Dock(TOP)
    ipr_dnumpanel.Paint = nil

    local ipr_dnumpanelpaint = vgui.Create("DPanel", ipr_dnumpanel)
    ipr_dnumpanelpaint:Dock(TOP)

    local ipr_sconfigcreate = vgui.Create("DNumSlider", ipr_dnumpanel)
    ipr_sconfigcreate:SetSize(ipr_primarywide, 25)
    ipr_sconfigcreate:Dock(BOTTOM)
    ipr_sconfigcreate:SetText("")
    ipr_sconfigcreate:SetMinMax(0, tbl.Max or 100)
    ipr_sconfigcreate:SetValue(ipr.Function.GetConvar(tbl.Name))
    ipr_sconfigcreate:SetDecimals(0)

    ipr_dnumpanelpaint.Paint = function(self, w, h)
       draw.SimpleText(ipr.Data.Lang[ipr.Settings.SetLang][tbl.Localization.Text].. " [" ..math.Round(ipr_sconfigcreate:GetValue()).. "]", ipr.Settings.Font, w / 2, 0, ipr.Settings.TColor["blanc"], TEXT_ALIGN_CENTER)
    end

    local ipr_primarywide = ipr_dnumpanel:GetWide()
    local ipr_panelchild = ipr_sconfigcreate:GetChildren()
    local ipr_overrideslider = {
        ["DSlider"] = function(slide)
            slide:Dock(FILL)
            slide:SetSize(ipr_primarywide, 25)

            slide.Knob.Paint = function(self, w, h)
                draw.RoundedBox(6, 5, 2, w - 10, h - 4, (slide.Dragging or slide.Knob.Depressed) and ipr.Settings.TColor["rouge"] or ipr.Settings.TColor["vert"])
                draw.RoundedBox(6, 6, 3, w - 12, h - 6, ipr.Settings.TColor["blanc"])
            end
            slide.Paint = function(self, w, h)
                surface.SetDrawColor(ColorAlpha(color_black, 90))
                surface.DrawLine(9, h - 15, w - 8, h - 15)
                surface.DrawLine(9, h - 11, w - 8, h - 11)
                
                draw.RoundedBox(3, 7, h / 2 - 2, w - 12, h / 2 - 10, ipr.Settings.TColor["bleu"])

                draw.RoundedBox(3, 7, 9, 3, h - 18, ipr.Settings.TColor["blanc"])
                draw.RoundedBox(3, w / 2, 10, 3, h - 20, ipr.Settings.TColor["blanc"])
                draw.RoundedBox(3, w - 8, 9, 3, h - 18, ipr.Settings.TColor["blanc"])
            end
        end,
        ["DLabel"] = function(slide)
            slide:GetChildren()[1]:SetVisible(false)
            slide:SetVisible(false)
        end,
        ["DTextEntry"] = function(slide)
            slide:SetFont(ipr.Settings.Font)
            slide:SetTextColor(ipr.Settings.TColor["blanc"])

            slide:SetVisible(false)
        end,
    }

    for i = 1, #ipr_panelchild do
        local ipr_cpanel = ipr_panelchild[i]
        local ipr_cnamepanel = ipr_cpanel:GetName()

        local ipr_funcslider = ipr_overrideslider[ipr_cnamepanel]
        if (ipr_funcslider) then
            ipr_funcslider(ipr_cpanel)
        end
    end

    ipr_sconfigcreate.OnValueChanged = function(self)
        ipr.Function.SetConvar(tbl.Name, self:GetValue(), 1)
    end

    return ipr_sconfigcreate, ipr_dnumpanel
end

ipr.Function.SettingsVgui = {
    ["DCheckBoxLabel"] = function(panel, tbl, hud)
        local ipr_createcheckboxlabel, ipr_dpanelcheckBox = ipr.Function.DCheckBoxLabel(panel, tbl)

        ipr_createcheckboxlabel.OnChange = function(self)
            local ipr_getchecked = self:GetChecked()
            ipr.Function.SetConvar(tbl.Name, ipr_getchecked, 1)

            for i = 1, #ipr.Settings.Vgui.CheckBox do
                if (ipr.Settings.Vgui.CheckBox[i].Paired == tbl.Name) then
                    local ipr_vgui = ipr.Settings.Vgui.CheckBox[i].Vgui
                    ipr_vgui = ipr_vgui:GetParent()

                    if IsValid(ipr_vgui) then
                        ipr_vgui:SetDisabled(not ipr_getchecked)
                    end
                end
            end

            if (tbl.Run_HookFog) then
                ipr.Function.FogActivate(ipr_getchecked)
            elseif (tbl.Run_HookFps) then
                if (ipr_getchecked) then
                    hook.Add("PostDrawHUD", "IprFpsBooster_HUD", hud)
                else
                    hook.Remove("PostDrawHUD", "IprFpsBooster_HUD", hud)
                end
            elseif (tbl.Run_Debug) then
                ipr.Settings.Debug = ipr_getchecked
            end
        end

        return ipr_createcheckboxlabel, ipr_dpanelcheckBox
    end,
    ["DNumSlider"] = function(panel, tbl)
        local ipr_createnumslider, ipr_dpanelslider = ipr.Function.DNumSlider(panel, tbl)

        ipr_createnumslider.OnValueChanged = function(self)
            ipr.Function.SetConvar(tbl.Name, self:GetValue(), 1)
        end

        return ipr_createnumslider, ipr_dpanelslider
    end,
}

ipr.Cmd = include("ipr_fps_booster_configuration/commands.lua")

return ipr