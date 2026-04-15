// Script by Inj3
// Steam : https://steamcommunity.com/profiles/76561197988568430
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

ipr.Function.DataCreate = function()
    local ipr_path = "DATA"
    if not file.IsDir(ipr.Settings.Save, ipr_path) then
        file.CreateDir(ipr.Settings.Save)
    end

    local ipr_json_lang = ipr.Settings.Save.. "language.json"
    if not file.Exists(ipr_json_lang, ipr_path) then
        ipr.Settings.SetLang = not game.IsDedicated() and ipr.Settings.Country.code[system.GetCountry()] and ipr.Settings.Country.target or ipr.Settings.SetLang
        ipr.Function.SaveSettings(ipr.Settings.SetLang, true)
    else
        ipr.Settings.SetLang = file.Read(ipr_json_lang, ipr_path)
    end

    local ipr_json_cvar = ipr.Settings.Save.. "convars.json"
    if not file.Exists(ipr_json_cvar, ipr_path) then
        local ipr_nodes = {
            ipr.Data.Default.convars, 
            ipr.Data.Default.settings, 
            ipr.Data.Default.convars_registry,
        }
        ipr_nodes[3].Registry = true
        
        ipr.Settings.SetConvars = {}
        for h = 1, #ipr_nodes do
            local ipr_data = ipr_nodes[h]
            
            for i = 1, #ipr_data do
                local ipr_index = #ipr.Settings.SetConvars + 1
                local ipr_index_data = ipr_data[i]

                ipr.Settings.SetConvars[ipr_index] = {
                    Name = ipr_index_data.Name,
                    Checked = ipr_index_data.DefaultCheck,
                }

                if (ipr_index_data.Vgui) then
                    ipr.Settings.SetConvars[ipr_index].Vgui = ipr_index_data.Vgui
                elseif (ipr_data.Registry) then
                    ipr.Settings.SetConvars[ipr_index].Register = true
                end
            end
        end

        ipr.Function.SaveSettings()
    else
        local ipr_json_parse = util.JSONToTable(file.Read(ipr_json_cvar, ipr_path))
        local ipr_dup = table.Copy(ipr.Data.Default.convars)
        local ipr_erase = function() file.Delete(ipr_json_cvar, ipr_path) ipr.Function.DataCreate() end

        table.Add(ipr_dup, ipr.Data.Default.settings)
        table.Add(ipr_dup, ipr.Data.Default.convars_registry)

        if (#ipr_json_parse ~= #ipr_dup) then
            ipr_erase()
            return
        end

        for h = 1, #ipr_dup do
            local ipr_unset = false

            for i = 1, #ipr_json_parse do
                if (ipr_dup[h].Name == ipr_json_parse[i].Name) then
                    ipr_unset = true
                    break
                end
            end
            
            if not ipr_unset then
                ipr_erase()
                return
            end
        end

        ipr.Settings.SetConvars = ipr_json_parse
    end

    ipr.Function.Activate(true, true)
    ipr.Function.DeepCopy()
    ipr.Function.UpdateFont(ipr.Settings.SetLang)
end

ipr.Function.GetConvar = function(name)
    local ipr_cvar = ipr.Settings.SetConvars
    for i = 1, #ipr_cvar do
        if (ipr_cvar[i].Name == name) then
            return ipr_cvar[i].Checked
        end
    end

    local ipr_debug = ipr.Settings.Debug
    if (ipr_debug) then
        print("Convar not found !", " " ..name)
    end
    return nil
end

ipr.Function.SetConvar = function(name, checked, int)
    local ipr_unregistered = (ipr.Function.GetConvar(name) == nil)
    if (ipr_unregistered) then
        print("Missing cvar in configuration file : " ..name)
    else
        local ipr_cvar = ipr.Settings.SetConvars
        for i = 1, #ipr_cvar do
            if (ipr_cvar[i].Name == name) then
                ipr.Settings.SetConvars[i].Checked = checked
                break
            end
        end

        local ipr_interval = {
            function()
                local ipr_timer = ipr.Settings.Save.. "_delay"
                if timer.Exists(ipr_timer) then
                    timer.Remove(ipr_timer)
                end

                timer.Create(ipr_timer, 1, 1, function()
                    ipr.Function.SaveSettings()
                end)
            end,
            ipr.Function.SaveSettings,
        }
        if (int) then
            ipr_interval[int]()
        end
    end
end

ipr.Function.SaveSettings = function(data, directory)
    directory = (directory) and ipr.Settings.Save.. "language.json" or ipr.Settings.Save.. "convars.json"
    file.Write(directory, (data) or util.TableToJSON(ipr.Settings.SetConvars))
end

ipr.Function.CvarInfo = function(cvar)
    cvar = LocalPlayer():GetInfoNum(cvar, -99)
    return tonumber(cvar), (cvar == -99)
end

ipr.Function.CvarState = function()
    local ipr_data = ipr.Settings.SetConvars
    for i = 1, #ipr_data do
        local ipr_index_data = ipr_data[i]
        if not ipr_index_data.Vgui and not ipr_index_data.Register and ipr_index_data.Checked then
            return true
        end
    end

    return false
end

local ipr_font = ipr.Settings.Font
do
    local ipr_size_cache = {}
    ipr.Function.SizeLang = function(text)
        local ipr_lang = ipr.Settings.SetLang
        if not ipr_size_cache[ipr_lang] then
            ipr_size_cache = {}
            ipr_size_cache[ipr_lang] = {}
        end
        if not ipr_size_cache[ipr_lang][text] then
            surface.SetFont(ipr_font)
            ipr_size_cache[ipr_lang][text] = {surface.GetTextSize(ipr.Data.Lang[ipr_lang][text])}
        end

        return ipr_size_cache[ipr_lang][text][1], ipr_size_cache[ipr_lang][text][2]
    end

    local ipr_font_cache = {}
    ipr.Function.UpdateFont = function(index)
        if not ipr_font_cache[index] then
            ipr_font_cache = {}

            local ipr_data_lang = ipr.Data.Lang[index]
            surface.CreateFont(ipr_font,{
                font = ipr_data_lang.FontTTF,
                extented = ipr_data_lang.FontExtented,
                size = ipr_data_lang.FontSize,
                weight = ipr_data_lang.FontWeigth,
                antialias = true,
            })

            ipr_font_cache[index] = true
        end
    end
end

ipr.Function.Activate = function(enabled, match)
    local ipr_debug = ipr.Settings.Debug

    for i = 1, #ipr.Data.Default.convars do
        local ipr_data_name = ipr.Data.Default.convars[i].Name
        local ipr_data_cvar = ipr.Data.Default.convars[i].Convars
        local ipr_data_state = (enabled) and ipr.Function.GetConvar(ipr_data_name)
        
        for k, v in pairs(ipr_data_cvar) do
            local ipr_data_toggle = (ipr_data_state) and v.Enabled or v.Disabled
            ipr_data_toggle = tonumber(ipr_data_toggle)

            local ipr_cvar_info, ipr_cvar_registered = ipr.Function.CvarInfo(k)
            if (ipr_cvar_registered) or (ipr_cvar_info == ipr_data_toggle) then
                continue
            end
            if (match) then
                return true
            end
            RunConsoleCommand(k, ipr_data_toggle)

            if (ipr_debug) then
                print("Updating " ..k.. " set " ..ipr_cvar_info.. " to " ..ipr_data_toggle)
            end
        end
    end

    if not ipr.Function.CvarState() then
        ipr.Settings.Status = false
    elseif (ipr.Settings.Status ~= enabled) then
        ipr.Function.ResetFps()
        ipr.Settings.Status = enabled
    end
end

ipr.Function.FpsTracker = function()
    local ipr_systime = SysTime()

    if (ipr_systime > (ipr.SysNext or 0)) then
        local ipr_frametime = engine.AbsoluteFrameTime()
        
        ipr.Settings.FpsCurrent = math.Round(1 / ipr_frametime)
        ipr.Settings.FpsCurrent = (ipr.Settings.FpsCurrent > ipr.Settings.Fps.Ceiling) and ipr.Settings.Fps.Ceiling or ipr.Settings.FpsCurrent

        ipr.Settings.Fps.Min = (ipr.Settings.FpsCurrent < ipr.Settings.Fps.Min) and ipr.Settings.FpsCurrent or ipr.Settings.Fps.Min
        ipr.Settings.Fps.Max = (ipr.Settings.FpsCurrent > ipr.Settings.Fps.Max) and ipr.Settings.FpsCurrent or ipr.Settings.Fps.Max
        ipr.Settings.Fps.LowCurrent = ipr.Settings.Fps.LowCurrent or ipr.Settings.Fps.Min

        local ipr_low = #ipr.Settings.Fps.LowFrame
        if (ipr_low < ipr.Settings.Fps.LowMaxFrame) then
            ipr.Settings.Fps.LowFrame[ipr_low + 1] = ipr.Settings.FpsCurrent
        else
            table.sort(ipr.Settings.Fps.LowFrame, function(a, b) 
                return a < b 
            end)

            ipr.Settings.Fps.LowCurrent = ipr.Settings.Fps.LowFrame[2]
            ipr.Settings.Fps.LowFrame = {}
        end

        ipr.SysNext = ipr_systime + 0.3
    end

    local ipr_fps_huge = ipr.Settings.Fps.Min
    ipr_fps_huge = (ipr_fps_huge == math.huge) and ipr.Settings.Fps.Max or ipr_fps_huge

    return ipr.Settings.FpsCurrent, ipr_fps_huge, ipr.Settings.Fps.Max, ipr.Settings.Fps.LowCurrent
end

ipr.Function.DeepCopy = function()
    local ipr_source = {}
    local ipr_data = ipr.Settings.SetConvars
    for i = 1, #ipr_data do
        local ipr_index_data = ipr_data[i]
        if not ipr_index_data.Vgui and not ipr_index_data.Register then
           ipr_source[#ipr_source + 1] = ipr_index_data
        end
    end

    ipr.Settings.Revert = {
        Copy = table.Copy(ipr_source), 
        Set = false,
    }
end

ipr.Function.ResetFps = function()
    ipr.Settings.Fps.Min = math.huge
    ipr.Settings.Fps.Max = 0
end

ipr.Function.ColorRange = function(int)
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

ipr.Function.DrawMultipleTextAligned = function(data)
    local ipr_old_wide = 0
    local ipr_new_wide = 0

    for t = 1, #data do
        local ipr_index_text = data[t]
        local ipr_pos = ipr_index_text.Pos

        for i = 1, #ipr_index_text do
            ipr_new_wide = ipr_old_wide

            surface.SetFont(ipr_font)

            local ipr_text_name = ipr_index_text[i].Name
            local ipr_text_wide = surface.GetTextSize(ipr_text_name)
            ipr_old_wide = ipr_old_wide + ipr_text_wide + 5

            local ipr_text_align = ipr_pos.PWide + ipr_new_wide
            draw.SimpleTextOutlined(ipr_text_name, ipr_font, ipr_text_align, ipr_pos.PHeight, ipr_index_text[i].FColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT, 1, ColorAlpha(color_black, 100))
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
            surface.SetFont(ipr_font)
            local ipr_text_wide, ipr_text_height = surface.GetTextSize(text)

            ipr.Settings.Vgui.ToolTip:SetSize(ipr_text_wide + ipr_icon_size + ipr_box_size, ipr_text_height + 1)
            ipr_text = text
        end
        ipr.Settings.Vgui.ToolTip.Paint = function(self, w, h)
            ipr.Function.RenderBlur(self, ColorAlpha(color_black, 130), 6)

            surface.SetDrawColor(color_white)
            surface.SetMaterial(ipr.Settings.IToolTip)
            surface.DrawTexturedRect(2, 2, ipr_icon_size, ipr_icon_size)
 
            draw.SimpleText(ipr_text, ipr_font, ipr_icon_size + ipr_box_size / 2 - 2, 1, ipr.Settings.TColor["blanc"], TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT)
        end

        ipr.Settings.Vgui.ToolTip:SetVisible(false)
    end
    if not IsValid(panel) then
        return
    end
    
    local ipr_get_children = panel:GetChildren()
    local ipr_vgui_name = panel:GetName()
    local ipr_vgui_lists = {
        ["DButton"] = {Panel = true},
        ["DImageButton"] = {Panel = true},
        ["DCheckBox"] = {Panel = false, Parent = panel:GetParent()},
    }

    if (ipr_vgui_lists[ipr_vgui_name].Panel) then
        ipr_get_children[#ipr_get_children + 1] = panel
    end
    if (ipr_vgui_lists[ipr_vgui_name].Parent) then
        ipr_get_children[#ipr_get_children + 1] = ipr_vgui_lists[ipr_vgui_name].Parent
    end

    for i = 1, #ipr_get_children do
        local ipr_index_child = ipr_get_children[i]

        ipr_index_child.OnCursorMoved = function(self)
            if not IsValid(ipr.Settings.Vgui.ToolTip) then
                return
            end

            local ipr_inputx, ipr_inputy = input.GetCursorPos()
            local ipr_pos = ipr_inputx - ipr.Settings.Vgui.ToolTip:GetWide() / 2

            ipr.Settings.Vgui.ToolTip:SetPos(ipr_pos, ipr_inputy - 30)
        end
        ipr_index_child.OnCursorExited = function()
            if not IsValid(ipr.Settings.Vgui.ToolTip) then
                return
            end

            ipr.Settings.Vgui.ToolTip:SetVisible(false)
        end
        ipr_index_child.OnCursorEntered = function(self)
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

ipr.Function.DComboBox = function(panel)
    panel = panel:GetChildren()

    for i = 1, #panel do
        local ipr_index_panel = panel[i]
        local ipr_name_panel = ipr_index_panel:GetName()

        if (ipr_name_panel == "DPanel") then
            ipr_index_panel.Paint = function(self, w, h)
                local ipr_center_wide = w / 2
                local ipr_center_height = h / 2

                local ipr_arrow_right = {
                    {x = ipr_center_wide, y = ipr_center_height - 8 / 2},
                    {x = ipr_center_wide + 5, y = ipr_center_height},
                    {x = ipr_center_wide, y = ipr_center_height + 8 / 2},
                }

                surface.SetDrawColor(ColorAlpha(ipr.Settings.TColor["blanc"], 170))
                draw.NoTexture()
                surface.DrawPoly(ipr_arrow_right)
            end
        end
    end
end

ipr.Function.DCheckBoxLabel = function(panel, data)
    local ipr_dpanel = vgui.Create("DPanel", panel)
    ipr_dpanel:Dock(TOP)
    ipr_dpanel:SetTall(20)
    ipr_dpanel:DockMargin(0, 5, 0, 6)
    ipr_dpanel.Paint = nil

    local ipr_dcheckbox = vgui.Create("DCheckBox", ipr_dpanel)
    ipr_dcheckbox:DockMargin(0, 0, 5, 0)
    ipr_dcheckbox:Dock(LEFT)
    ipr_dcheckbox:SetWide(35)

    local ipr_checked = ipr.Function.GetConvar(data.Name)
    ipr_dcheckbox:SetValue(ipr_checked)
    ipr_dcheckbox.SLerp = (ipr_checked) and ipr_dcheckbox:GetTall() + 3 or 6

    ipr_dcheckbox.Paint = function(self, w, h)
        local ipr_checked = self:GetChecked()
        local ipr_pos_wide = (ipr_checked) and (w / 2 ) + 2 or 6

        self.SLerp = Lerp(SysTime() * 13, self.SLerp or ipr_pos_wide, ipr_pos_wide)

        draw.RoundedBox(12, 2, 2, w - 4, h - 4, ipr.Settings.TColor["gris"])
        draw.RoundedBox(12, self.SLerp, 5, 10, 10, (ipr_checked) and ipr.Settings.TColor["vert"] or ipr.Settings.TColor["rouge"])
    end
    ipr_dcheckbox.DoClick = function(self)
        local ipr_sound_checked = self:GetChecked() and "garrysmod/ui_return.wav" or "buttons/button15.wav"
        surface.PlaySound(ipr_sound_checked)

        self:Toggle()
    end

    local ipr_dlabel = vgui.Create("DLabel", ipr_dpanel)
    ipr_dlabel:Dock(FILL)
    ipr_dlabel:SetFont(ipr_font)
    ipr_dlabel:SetText("")

    ipr_dlabel.Paint = function(self, w, h)
        local _, ipr_text_heigth = ipr.Function.SizeLang(data.Localization.Text)
        local ipr_hovered = ipr_dcheckbox:IsHovered() and ColorAlpha(color_white, 130) or ipr.Settings.TColor["blanc"]
        draw.SimpleText(ipr.Data.Lang[ipr.Settings.SetLang][data.Localization.Text], ipr_font, 0, (h - ipr_text_heigth) / 2, ipr_hovered, TEXT_ALIGN_LEFT)
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

ipr.Function.DNumSlider = function(panel, data)
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
    ipr_dnumslider:SetMinMax(0, data.Max or 100)
    ipr_dnumslider:SetValue(ipr.Function.GetConvar(data.Name))
    ipr_dnumslider:SetDecimals(0)

    ipr_dpanel_dock.Paint = function(self, w, h)
       draw.SimpleText(ipr.Data.Lang[ipr.Settings.SetLang][data.Localization.Text].. " [" ..math.Round(ipr_dnumslider:GetValue()).. "]", ipr_font, w / 2, 0, ipr.Settings.TColor["blanc"], TEXT_ALIGN_CENTER)
    end

    local ipr_primary_wide = ipr_dpanel:GetWide()
    local ipr_vgui = {
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
            slide:SetFont(ipr_font)
            slide:SetTextColor(ipr.Settings.TColor["blanc"])

            slide:SetVisible(false)
        end,
    }

    local ipr_panel_child = ipr_dnumslider:GetChildren()
    for i = 1, #ipr_panel_child do
        local ipr_index_child = ipr_panel_child[i]
        local ipr_data_name = ipr_index_child:GetName()

        local ipr_vgui_override = ipr_vgui[ipr_data_name]
        if (ipr_vgui_override) then
            ipr_vgui_override(ipr_index_child)
        end
    end

    ipr_dnumslider.OnValueChanged = function(self)
        ipr.Function.SetConvar(data.Name, self:GetValue(), 1)
    end

    return ipr_dnumslider, ipr_dpanel
end

ipr.Function.SettingsVgui = {
    ["DCheckBoxLabel"] = function(panel, data, hud)
        local ipr_dcheckboxlabel, ipr_dpanel = ipr.Function.DCheckBoxLabel(panel, data)

        ipr_dcheckboxlabel.OnChange = function(self)
            local ipr_checked = self:GetChecked()
            ipr.Function.SetConvar(data.Name, ipr_checked, 1)

            for i = 1, #ipr.Settings.Vgui.CheckBox do
                if (ipr.Settings.Vgui.CheckBox[i].Paired == data.Name) then
                    local ipr_vgui_index = ipr.Settings.Vgui.CheckBox[i].Vgui
                    ipr_vgui_index = ipr_vgui_index:GetParent()

                    if IsValid(ipr_vgui_index) then
                        ipr_vgui_index:SetDisabled(not ipr_checked)
                    end
                end
            end

            if (data.Run_HookFog) then
                ipr.Function.FogActivate(ipr_checked)
            elseif (data.Run_HookFps) then
                if (ipr_checked) then
                    hook.Add("PostDrawHUD", "IprFpsBooster_HUD", hud)
                else
                    hook.Remove("PostDrawHUD", "IprFpsBooster_HUD", hud)
                end
            elseif (data.Run_Debug) then
                ipr.Settings.Debug = ipr_checked
            end
        end

        return ipr_dcheckboxlabel, ipr_dpanel
    end,
    ["DNumSlider"] = function(panel, data)
        local ipr_dnumslider, ipr_dpanel = ipr.Function.DNumSlider(panel, data)

        ipr_dnumslider.OnValueChanged = function(self)
            ipr.Function.SetConvar(data.Name, self:GetValue(), 1)
        end

        return ipr_dnumslider, ipr_dpanel
    end,
}

ipr.Cmd = include("ipr_fps_booster_configuration/commands.lua")

return ipr