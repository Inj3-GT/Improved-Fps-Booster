// Script by Inj3
// Steam : https://steamcommunity.com/id/Inj3/
// Discord : Inj3
// General Public License v3.0
// https://github.com/Inj3-GT

local include = include
local math = math
local file = file
local system = system
local util = util
local timer = timer
local draw = draw
local surface = surface
local string = string
local render = render
local hook = hook

local ipr = {}
ipr.Settings = include("table.lua")
ipr.Data = include("include.lua")
ipr.Function = {}

ipr.Function.CreateData = function()
    local ipr_directory = file.IsDir(ipr.Settings.Save, "DATA")
    if not ipr_directory then
        file.CreateDir(ipr.Settings.Save)
    end

    local ipr_file_lang, ipr_lang = ipr.Settings.Save.. "language.json"
    local ipr_file_exists = file.Exists(ipr_file_lang, "DATA")

    local ipr_file_size = file.Size(ipr_file_lang, "DATA")
    if (ipr_file_size == 0) then
        ipr_file_exists = false
    end

    if not ipr_file_exists then
        local ipr_file_country = file.Exists("ipr_fps_booster_language/" ..string.lower(ipr.Settings.Country.target).. ".lua", "LUA")
        if (ipr_file_country) then
            local ipr_get_country = system.GetCountry()
            if (ipr_get_country) and ipr.Settings.Country.code[ipr_get_country] then
                ipr_lang = ipr.Settings.Country.target
            end
        end
        if not ipr_lang or (ipr_lang == "") then
            ipr_lang = ipr.Function.SearchLang()
        end

        ipr.Settings.SetLang = ipr_lang
        file.Write(ipr_file_lang, ipr_lang)
    end
    if not ipr_lang then
        ipr.Settings.SetLang = file.Read(ipr_file_lang, "DATA")
    end

    local ipr_file_convars, ipr_convars = file.Exists(ipr.Settings.Save.. "convars.json", "DATA")
    if not ipr_file_convars then
        ipr_convars = {}

        local ipr_data_convars = ipr.Data.Default.convars
        for i = 1, #ipr_data_convars do
            ipr_convars[#ipr_convars + 1] = {
                Name = ipr_data_convars[i].Name,
                Checked = ipr_data_convars[i].DefaultCheck
            }
        end

        local ipr_data_settings = ipr.Data.Default.settings
        for i = 1, #ipr_data_settings do
            ipr_convars[#ipr_convars + 1] = {
                Vgui = ipr_data_settings[i].Vgui,
                Name = ipr_data_settings[i].Name,
                Checked = ipr_data_settings[i].DefaultCheck
            }
        end

        ipr.Settings.SetConvars = ipr_convars
        file.Write(ipr.Settings.Save.. "convars.json", util.TableToJSON(ipr_convars))
    end
    if not ipr_convars then
        ipr.Settings.SetConvars = util.JSONToTable(file.Read(ipr.Settings.Save.. "convars.json", "DATA"))
    end

    local ipr_match = ipr.Function.Activate(true, true)
    if not ipr_match then
        ipr.Settings.Status.State = true
    end
end

ipr.Function.SearchLang = function()
    local ipr_data_lang = ipr.Settings.SetLang
    local ipr_default_lang = file.Exists("ipr_fps_booster_language/" ..ipr_data_lang.. ".lua", "LUA")
    if (ipr_default_lang) then
        return ipr_data_lang
    end

    local ipr_find = file.Find("ipr_fps_booster_language/*", "LUA")
    for i = 1, #ipr_find do
        local ipr_index_lang = ipr_find[i]
        local ipr_size = file.Size("ipr_fps_booster_language/" ..ipr_index_lang, "LUA")

        if (ipr_size ~= 0) then
            return string.upper(string.gsub(ipr_index_lang, ".lua", ""))
        end
    end

    return ipr_data_lang
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
        local ipr_json = util.TableToJSON(ipr.Settings.SetConvars)
        ipr.Function.SaveConvar(ipr_json)

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
            local ipr_save_convar = "IprFpsBooster_SetConvar"
            if (timer.Exists(ipr_save_convar)) then
                timer.Remove(ipr_save_convar)
            end

            timer.Create(ipr_save_convar, 1, 1, function()
                ipr.Function.SaveConvar()
            end)
        elseif (save == 2) then
            ipr.Function.SaveConvar()
        end
    end
end

ipr.Function.SaveConvar = function(json)
    local ipr_json_convars = (json) or util.TableToJSON(ipr.Settings.SetConvars)
    file.Write(ipr.Settings.Save.. "convars.json", ipr_json_convars)
end

ipr.Function.InfoNum = function(cmd, exist)
    local ipr_info_num = LocalPlayer():GetInfoNum(cmd, -99)
    if (exist) then
        return (ipr_info_num == -99)
    end

    return tonumber(ipr_info_num)
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
    local ipr_convars_check = bool

    for i = 1, #ipr.Data.Default.convars do
        local ipr_name_cmd = ipr.Data.Default.convars[i].Name
        local ipr_convar_cmd = ipr.Data.Default.convars[i].Convars

        for k, v in pairs(ipr_convar_cmd) do
            if isbool(ipr.Function.GetConvar(ipr_name_cmd)) then
                if (bool) then
                    ipr_convars_check = ipr.Function.GetConvar(ipr_name_cmd)
                end

                local ipr_toggle = (ipr_convars_check) and v.Enabled or v.Disabled
                ipr_toggle = tonumber(ipr_toggle)

                local ipr_info_cmds = ipr.Function.InfoNum(k)
                if ipr.Function.InfoNum(k, true) or (ipr_info_cmds == ipr_toggle) then
                    continue
                end
                if (match) then
                    return true
                end
                RunConsoleCommand(k, ipr_toggle)

                if (ipr.Settings.Debug) then
                    print("Updating " ..k.. " set " ..ipr_info_cmds.. " to " ..ipr_toggle)
                end
            end
        end
    end

    if (ipr.Settings.Status.State ~= bool) then
        ipr.Function.ResetFps()
        ipr.Settings.Status.State = bool
    end
end

ipr.Function.FpsCalculator = function()
    local ipr_systime = SysTime()

    if ipr_systime > (ipr.CurNext or 0) then
        local ipr_absolute_frametime = engine.AbsoluteFrameTime()
        
        ipr.Settings.FpsCurrent = math.Round(1 / ipr_absolute_frametime)
        ipr.Settings.FpsCurrent = (ipr.Settings.FpsCurrent > ipr.Settings.MaxFps) and ipr.Settings.MaxFps or ipr.Settings.FpsCurrent

        if (ipr.Settings.FpsCurrent < ipr.Settings.Fps.Min.Int) then
            ipr.Settings.Fps.Min.Int = ipr.Settings.FpsCurrent
        end
        if (ipr.Settings.FpsCurrent > ipr.Settings.Fps.Max.Int) then
            ipr.Settings.Fps.Max.Int = ipr.Settings.FpsCurrent
        end
        
        ipr.Settings.Fps.Low.Current = ipr.Settings.Fps.Low.Current or ipr.Settings.Fps.Min.Int

        local ipr_count_frame = #ipr.Settings.Fps.Low.Frame
        if (ipr_count_frame < ipr.Settings.Fps.Low.MaxFrame) then
            local ipr_insert_frame = ipr_count_frame + 1
            
            ipr.Settings.Fps.Low.Frame[ipr_insert_frame] = ipr.Settings.FpsCurrent
        else
            table.sort(ipr.Settings.Fps.Low.Frame, function(a, b) 
                return a < b 
            end)

            ipr.Settings.Fps.Low.Current = ipr.Settings.Fps.Low.Frame[2]
            ipr.Settings.Fps.Low.Frame = {}
        end

        ipr.CurNext = ipr_systime + 0.3
    end

    local ipr_fps_min = ipr.Settings.Fps.Min.Int
    ipr_fps_min = (ipr_fps_min == math.huge) and ipr.Settings.Fps.Max.Int or ipr_fps_min

    return ipr.Settings.FpsCurrent, ipr_fps_min, ipr.Settings.Fps.Max.Int, ipr.Settings.Fps.Low.Current
end

ipr.Function.CopyData = function()
    local ipr_data = {}
    local ipr_exclude = {
        ["Startup"] = true,
    }

    for i = 1, #ipr.Settings.SetConvars do
        local ipr_index_convars = ipr.Settings.SetConvars[i]

        if not ipr_exclude[ipr_index_convars.Name] and not ipr_index_convars.Vgui then
            ipr_data[#ipr_data + 1] = ipr_index_convars
        end
    end

    ipr.Settings.Revert = {
        Copy = table.Copy(ipr_data), 
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

    local ipr_screen_x, ipr_screen_y = panel:LocalToScreen(0, 0)
    ipr.Settings.Blur:SetFloat("$blur", 1.5)
    ipr.Settings.Blur:Recompute()

    render.UpdateScreenEffectTexture()
    surface.DrawTexturedRect(ipr_screen_x * -1, ipr_screen_y * -1, ipr.Settings.Pos.w, ipr.Settings.Pos.h)

    local ipr_panel_wide, ipr_panel_height = panel:GetWide(), panel:GetTall()
    draw.RoundedBoxEx(border, 0, 0, ipr_panel_wide, ipr_panel_height, colors, true, true, true, true)
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
    local ipr_old_wide = 0
    local ipr_new_wide = 0

    for t = 1, #tbl do
        local ipr_data_text = tbl[t]
        local ipr_pos = ipr_data_text.Pos

        for i = 1, #ipr_data_text do
            ipr_new_wide = ipr_old_wide

            surface.SetFont(ipr.Settings.Font)

            local ipr_text_name = ipr_data_text[i].Name
            local ipr_text_wide = surface.GetTextSize(ipr_text_name)
            ipr_old_wide = ipr_old_wide + ipr_text_wide + ipr.Settings.Escape

            local ipr_text_align = ipr_pos.PWide + ipr_new_wide
            draw.SimpleTextOutlined(ipr_text_name, ipr.Settings.Font, ipr_text_align, ipr_pos.PHeight, ipr_data_text[i].FColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT, 1, ColorAlpha(color_black, 100))
        end

        ipr_old_wide = 0
    end
end

ipr.Function.SetToolTip = function(text, panel, localization)
    if not IsValid(ipr.Settings.Vgui.ToolTip) then
        ipr.Settings.Vgui.ToolTip = vgui.Create("DPanel")
        ipr.Settings.Vgui.ToolTip:SetText("")
        ipr.Settings.Vgui.ToolTip:SetDrawOnTop(true)

        local ipr_text = text
        local ipr_icon_size = 16
        local ipr_box_size = 9
        ipr.Settings.Vgui.ToolTip.Text = function(text) 
            surface.SetFont(ipr.Settings.Font)
            local ipr_text_wide, ipr_text_height = surface.GetTextSize(text)
            ipr.Settings.Vgui.ToolTip:SetSize(ipr_text_wide + ipr_icon_size + ipr_box_size, ipr_text_height + 1)

            ipr_text = text
        end
        ipr.Settings.Vgui.ToolTip.Paint = function(self, w, h)
            ipr.Function.RenderBlur(self, ColorAlpha(color_black, 130), 6)

            surface.SetDrawColor(color_white)
            surface.SetMaterial(ipr.Settings.IToolTip)
            surface.DrawTexturedRect(2, 2, ipr_icon_size, ipr_icon_size)
 
            draw.SimpleText(ipr_text, ipr.Settings.Font, ipr_icon_size + ipr_box_size / 2 - 2, 1, ipr.Settings.TColor["blanc"], TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT)
        end

        ipr.Settings.Vgui.ToolTip:SetVisible(false)
    end
    if not IsValid(panel) then
        return
    end
    
    local ipr_override_children = panel:GetChildren()
    local ipr_vgui_name = panel:GetName()
    local ipr_vgui_lists = {
        ["DButton"] = {Panel = true},
        ["DImageButton"] = {Panel = true},
        ["DCheckBox"] = {Panel = false, Parent = panel:GetParent()},
    }

    if (ipr_vgui_lists[ipr_vgui_name].Panel) then
        ipr_override_children[#ipr_override_children + 1] = panel
    end
    if (ipr_vgui_lists[ipr_vgui_name].Parent) then
        ipr_override_children[#ipr_override_children + 1] = ipr_vgui_lists[ipr_vgui_name].Parent
    end

    for i = 1, #ipr_override_children do
        local ipr_override_child = ipr_override_children[i]

        ipr_override_child.OnCursorMoved = function(self)
            if not IsValid(ipr.Settings.Vgui.ToolTip) then
                return
            end

            local ipr_inputx, ipr_inputy = input.GetCursorPos()
            local ipr_pos = ipr_inputx - ipr.Settings.Vgui.ToolTip:GetWide() / 2

            ipr.Settings.Vgui.ToolTip:SetPos(ipr_pos, ipr_inputy - 30)
        end

        ipr_override_child.OnCursorExited = function()
            if not IsValid(ipr.Settings.Vgui.ToolTip) then
                return
            end

            ipr.Settings.Vgui.ToolTip:SetVisible(false)
        end
        
        ipr_override_child.OnCursorEntered = function(self)
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
    local ipr_dpanel = vgui.Create("DPanel", panel)
    ipr_dpanel:Dock(TOP)
    ipr_dpanel:SetTall(20)
    ipr_dpanel:DockMargin(0, 5, 0, 5)
    ipr_dpanel.Paint = nil

    local ipr_dcheckbox = vgui.Create("DCheckBox", ipr_dpanel)
    ipr_dcheckbox:DockMargin(0, 0, 5, 0)
    ipr_dcheckbox:Dock(LEFT)
    ipr_dcheckbox:SetWide(35)

    local ipr_checked = ipr.Function.GetConvar(tbl.Name)
    ipr_dcheckbox:SetValue(ipr_checked)
    ipr_dcheckbox.SLerp = (ipr_checked) and ipr_dcheckbox:GetTall() + 3 or 6

    ipr_dcheckbox.Paint = function(self, w, h)
        local ipr_checked = self:GetChecked()
        local ipr_pos_wide = (ipr_checked) and (w / 2 ) + 2 or 6

        self.SLerp = Lerp(SysTime() * 13, self.SLerp or ipr_pos_wide, ipr_pos_wide)

        draw.RoundedBox(12, 2, 2, w - 4, h - 4, (ipr_checked) and ipr.Settings.TColor["bleu"] or ipr.Settings.TColor["gris"])
        draw.RoundedBox(12, self.SLerp, 5, 10, 10, ipr.Settings.TColor["blanc"])
        
        surface.DrawCircle(self.SLerp + 5, 10, 6, ColorAlpha(color_black, 90))
    end
    ipr_dcheckbox.DoClick = function(self)
        local ipr_sound_checked = self:GetChecked() and "garrysmod/ui_return.wav" or "buttons/button15.wav"
        surface.PlaySound(ipr_sound_checked)

        self:Toggle()
    end

    local ipr_dlabel = vgui.Create("DLabel", ipr_dpanel)
    ipr_dlabel:Dock(FILL)
    ipr_dlabel:SetFont(ipr.Settings.Font)
    ipr_dlabel:SetText("")

    ipr_dlabel.Paint = function(self, w, h)
        local ipr_hovered = ipr_dcheckbox:IsHovered() and ColorAlpha(color_white, 130) or ipr.Settings.TColor["blanc"]
        draw.SimpleText(ipr.Data.Lang[ipr.Settings.SetLang][tbl.Localization.Text], ipr.Settings.Font, 0, 1, ipr_hovered, TEXT_ALIGN_LEFT)
    end

    return ipr_dcheckbox, ipr_dpanel
end

ipr.Function.DScrollPaint = function(panel, int)
    panel = panel:GetVBar()
    panel:SetWide(int)

    panel.btnUp:SetSize(0, 0)
    panel.btnDown:SetSize(0, 0)

    panel.PerformLayout = function(self)
        local ipr_panel_wide = self:GetWide()
        local ipr_tall = self:GetTall()

        local ipr_scroll = self:GetScroll() / self.CanvasSize
        local ipr_bar = math.max(self:BarScale() *  ipr_tall, 10)

        local ipr_bartall = ipr_tall - ipr_bar
        ipr_bartall = ipr_bartall + 1
        ipr_scroll = ipr_scroll * ipr_bartall

        self.btnGrip:SetPos(0, ipr_scroll)
        self.btnGrip:SetSize(ipr_panel_wide, ipr_bar)
    end

    panel.Paint = function(self, w, h)
        draw.RoundedBox(5, 0, 0, w, h, ColorAlpha(color_black, 65))
    end

    panel.btnGrip.Paint = function(self, w, h)
        draw.RoundedBox(5, 0, 0, w, h, ipr.Settings.TColor["bleu"])
    end
end

ipr.Function.DNumSlider = function(panel, tbl)
    local ipr_dpanel = vgui.Create("DPanel", panel)
    ipr_dpanel:SetSize(225, 39)
    ipr_dpanel:Dock(TOP)
    ipr_dpanel.Paint = nil

    local ipr_dpanel_dock = vgui.Create("DPanel", ipr_dpanel)
    ipr_dpanel_dock:Dock(TOP)

    local ipr_dnumslider = vgui.Create("DNumSlider", ipr_dpanel)
    ipr_dnumslider:SetTall(25)
    ipr_dnumslider:Dock(BOTTOM)
    ipr_dnumslider:SetText("")
    ipr_dnumslider:SetMinMax(0, tbl.Max or 100)
    ipr_dnumslider:SetValue(ipr.Function.GetConvar(tbl.Name))
    ipr_dnumslider:SetDecimals(0)

    ipr_dpanel_dock.Paint = function(self, w, h)
       draw.SimpleText(ipr.Data.Lang[ipr.Settings.SetLang][tbl.Localization.Text].. " [" ..math.Round(ipr_dnumslider:GetValue()).. "]", ipr.Settings.Font, w / 2, 0, ipr.Settings.TColor["blanc"], TEXT_ALIGN_CENTER)
    end

    local ipr_primary_wide = ipr_dpanel:GetWide()
    local ipr_panel_child = ipr_dnumslider:GetChildren()
    local ipr_override_slider = {
        ["DSlider"] = function(slide)
            slide:Dock(FILL)
            slide:SetSize(ipr_primary_wide, 25)

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

    for i = 1, #ipr_panel_child do
        local ipr_data_child = ipr_panel_child[i]
        local ipr_data_name = ipr_data_child:GetName()

        local ipr_vgui_override = ipr_override_slider[ipr_data_name]
        if (ipr_vgui_override) then
            ipr_vgui_override(ipr_data_child)
        end
    end

    ipr_dnumslider.OnValueChanged = function(self)
        ipr.Function.SetConvar(tbl.Name, self:GetValue(), 1)
    end

    return ipr_dnumslider, ipr_dpanel
end

ipr.Function.SettingsVgui = {
    ["DCheckBoxLabel"] = function(panel, tbl, hud)
        local ipr_dcheckboxlabel, ipr_dpanel = ipr.Function.DCheckBoxLabel(panel, tbl)

        ipr_dcheckboxlabel.OnChange = function(self)
            local ipr_checked = self:GetChecked()
            ipr.Function.SetConvar(tbl.Name, ipr_checked, 1)

            for i = 1, #ipr.Settings.Vgui.CheckBox do
                if (ipr.Settings.Vgui.CheckBox[i].Paired == tbl.Name) then
                    local ipr_vgui_index = ipr.Settings.Vgui.CheckBox[i].Vgui
                    ipr_vgui_index = ipr_vgui_index:GetParent()

                    if IsValid(ipr_vgui_index) then
                        ipr_vgui_index:SetDisabled(not ipr_checked)
                    end
                end
            end

            if (tbl.Run_HookFog) then
                ipr.Function.FogActivate(ipr_checked)
            elseif (tbl.Run_HookFps) then
                if (ipr_checked) then
                    hook.Add("PostDrawHUD", "IprFpsBooster_HUD", hud)
                else
                    hook.Remove("PostDrawHUD", "IprFpsBooster_HUD", hud)
                end
            elseif (tbl.Run_Debug) then
                ipr.Settings.Debug = ipr_checked
            end
        end

        return ipr_dcheckboxlabel, ipr_dpanel
    end,
    ["DNumSlider"] = function(panel, tbl)
        local ipr_dnumslider, ipr_dpanel = ipr.Function.DNumSlider(panel, tbl)

        ipr_dnumslider.OnValueChanged = function(self)
            ipr.Function.SetConvar(tbl.Name, self:GetValue(), 1)
        end

        return ipr_dnumslider, ipr_dpanel
    end,
}

ipr.Cmd = include("ipr_fps_booster_configuration/commands.lua")

return ipr