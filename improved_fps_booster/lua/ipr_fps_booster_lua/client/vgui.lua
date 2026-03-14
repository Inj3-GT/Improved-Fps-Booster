// Script by Inj3
// Steam : https://steamcommunity.com/id/Inj3/
// Discord : Inj3
// General Public License v3.0
// https://github.com/Inj3-GT

local ipr = include("function.lua")

local ipr_DrawHud = function()
    local ipr_fps_current, ipr_fps_min, ipr_fps_max, ipr_fps_low = ipr.Function.FpsCalculator()
    local ipr_hud_height = ipr.Settings.Pos.h * ipr.Function.GetConvar("FpsPosHeight") / 100
    local ipr_hud_wide = ipr.Settings.Pos.w * ipr.Function.GetConvar("FpsPosWidth") / 100
    local ipr_client_ping = LocalPlayer():Ping()

    local ipr_hudfpsbooster = {
        {
            {Name = "FPS :", FColor = ipr.Settings.TColor["blanc"]},
            {Name = ipr_fps_current, FColor = ipr.Function.ColorTransition(ipr_fps_current)},
            {Name = "|", FColor = ipr.Settings.TColor["blanc"]},
            {Name = ipr.Settings.Fps.Min.Name, FColor = ipr.Settings.TColor["blanc"]},
            {Name = ipr_fps_min, FColor = ipr.Function.ColorTransition(ipr_fps_min)},
            {Name = "|", FColor = ipr.Settings.TColor["blanc"]},
            {Name = ipr.Settings.Fps.Max.Name, FColor = ipr.Settings.TColor["blanc"]},
            {Name = ipr_fps_max, FColor = ipr.Function.ColorTransition(ipr_fps_max)},
            {Name = "|", FColor = ipr.Settings.TColor["blanc"]},
            {Name = ipr.Settings.Fps.Low.Name, FColor = ipr.Settings.TColor["blanc"]},
            {Name = ipr_fps_low, FColor = ipr.Function.ColorTransition(ipr_fps_low)},

            Pos = {PWide = ipr_hud_wide, PHeight = ipr_hud_height},
        },
        {
            {Name = "Map :", FColor = ipr.Settings.TColor["blanc"]},
            {Name = ipr.Settings.Map, FColor = ipr.Settings.TColor["orangec"]},
            {Name = "|", FColor = ipr.Settings.TColor["blanc"]},
            {Name = "Ping :", FColor = ipr.Settings.TColor["blanc"]},
            {Name = ipr_client_ping, FColor = (ipr_client_ping > 100) and ipr.Settings.TColor["rouge"] or ipr.Settings.TColor["vert"]},

            Pos = {PWide = ipr_hud_wide - 1, PHeight = ipr_hud_height + 20},
        }
    }

    ipr.Function.DrawMultipleTextAligned(ipr_hudfpsbooster)
end

local ipr_PanelClose = function(panel, bool)
    if IsValid(panel) then
        surface.PlaySound("common/wpn_select.wav")

        if (bool) then
            panel:Remove()
            return
        end
    end

    for _, v in pairs(ipr.Settings.Vgui) do
        if not IsValid(v) then
            continue
        end

        if (v:GetName() == "DFrame") then
            v:AlphaTo(0, 0.3, 0, function()
                if IsValid(v) then
                    v:Remove()
                end
            end)
        else
            v:Remove()
        end
    end
end

local ipr_PanelOptions = function(primary)
    if IsValid(ipr.Settings.Vgui.Secondary) then
        return
    end
    
    local ipr_options, ipr_options_size = vgui.Create("DFrame"), {w = 240, h = 450}
    ipr_options:SetTitle("")
    ipr_options:SetSize(ipr_options_size.w, ipr_options_size.h)
    ipr_options:MakePopup()
    ipr_options:ShowCloseButton(false)
    ipr_options:SetDraggable(true)
    ipr.Settings.Vgui.Secondary = ipr_options
    ipr_options.Paint = function(self, w, h)
        if IsValid(primary) then
            if (primary.Dragging) and (self.m_AnimList) then
                self:Stop()
                self:SetAlpha(255)
            end
            
            if (self.Dragging) then
                local ipr_center_wide = self:GetX() - primary:GetWide() - 10
                local ipr_center_height = self:GetY() + (ipr_options_size.h / 2)
                ipr_center_height = ipr_center_height - (primary:GetTall() / 2)

                primary:SetPos(ipr_center_wide, ipr_center_height)

                if not primary.PMoved then
                    primary.PMoved = true
                end
            end
        end

        ipr.Function.RenderBlur(self, ColorAlpha(color_black, 180), 6)

        draw.RoundedBoxEx(6, 0, 0, w, 20, ipr.Settings.TColor["bleu"], true, true, false, false)
        draw.SimpleText(ipr.Data.Lang[ipr.Settings.SetLang].NOptions, ipr.Settings.Font, w / 2, 1, ipr.Settings.TColor["blanc"], TEXT_ALIGN_CENTER)

        local ipr_fps_limit = math.Round(ipr.Function.InfoNum("fps_max"))
        ipr_fps_limit = (ipr_fps_limit > ipr.Settings.MaxFps) and ipr.Settings.MaxFps or ipr_fps_limit

        draw.SimpleText(ipr.Data.Lang[ipr.Settings.SetLang].FPSLimit, ipr.Settings.Font, 5, h - 19, ipr.Settings.TColor["blanc"], TEXT_ALIGN_LEFT)
        draw.SimpleText(ipr_fps_limit, ipr.Settings.Font, 67, h - 19, ipr.Function.ColorTransition(ipr_fps_limit), TEXT_ALIGN_LEFT)

        local ipr_systime = SysTime() * 1.5
        local ipr_r, ipr_g, ipr_b = math.sin(ipr_systime) * 255, math.sin(ipr_systime + 2) * 255, math.sin(ipr_systime + 4) * 255

        draw.SimpleText("v" ..IprFpsBooster.Version.. " by", ipr.Settings.Font, w - 29, h - 19, ipr.Settings.TColor["blanc"], TEXT_ALIGN_RIGHT)
        draw.SimpleText(IprFpsBooster.Developer, ipr.Settings.Font, w - 5, h - 19, Color(ipr_r, ipr_g, ipr_b), TEXT_ALIGN_RIGHT)
    end

    if IsValid(primary) then
        local ipr_PanelMoved = function()
            ipr_options:AlphaTo(255, 1.5, 0)

            local ipr_center_height = primary:GetY() - (ipr_options_size.h / 2)
            local ipr_fpos_wide = primary:GetX() + primary:GetWide()
            ipr_options:SetPos(ipr_fpos_wide, ipr_center_height)

            ipr_center_height = ipr_center_height + (primary:GetTall() / 2)
            ipr_options:MoveTo(ipr_fpos_wide, ipr_center_height, 0.5, 0)

            local ipr_center_wide = ipr_fpos_wide + 10
            ipr_options:MoveTo(ipr_center_wide, ipr_center_height, 0.5, 0.5)
        end
        ipr_options:SetAlpha(0)

        if not primary.PMoved then
            primary:MoveTo(primary:GetX() - (ipr_options_size.w / 2), primary:GetY(), 0.3, 0, -1, ipr_PanelMoved)
        else
            ipr_PanelMoved()
        end
    else
        ipr_options:Center()
    end

    local ipr_center = ipr_options_size.w / 2
    ipr.Settings.Vgui.CheckBox = {}

    local ipr_options_middle = vgui.Create("DPanel", ipr_options)
    ipr_options_middle:SetSize(232, 165)
    ipr_options_middle:SetPos(ipr_center - (ipr_options_middle:GetWide() / 2), 90)
    ipr_options_middle.Paint = function(self, w, h)
        draw.RoundedBox(4, 0, 0, w, h, ipr.Settings.BackGround)
        draw.SimpleText(ipr.Data.Lang[ipr.Settings.SetLang].TSettings, ipr.Settings.Font, w / 2, 2, ipr.Settings.TColor["blanc"], TEXT_ALIGN_CENTER)
    end

    local ipr_options_restore = vgui.Create("DImageButton", ipr_options_middle)
    ipr_options_restore:SetSize(16, 16)
    ipr_options_restore:SetPos(ipr_options_middle:GetWide() - ipr_options_restore:GetWide() - 1, 3)
    ipr_options_restore:SetImage("icon16/arrow_rotate_clockwise.png")
    ipr.Function.SetToolTip(ipr.Data.Lang[ipr.Settings.SetLang].RevertData, ipr_options_restore, true)
    ipr_options_restore.Paint = nil
    ipr_options_restore.DoClick = function()
        local ipr_copy_data, ipr_copy_find = ipr.Function.GetCopyData()

        for i = 1, #ipr.Settings.SetConvars do
            local ipr_index_convars = ipr.Settings.SetConvars[i]
            local ipr_convar_name, ipr_convar_check = ipr_index_convars.Name, ipr_index_convars.Checked

            for t = 1, #ipr_copy_data do
                local ipr_index_copy = ipr_copy_data[t]
                local ipr_copy_name, ipr_copy_default = ipr_index_copy.Name, ipr_index_copy.Checked

                if (ipr_convar_name == ipr_copy_name and ipr_convar_check ~= ipr_copy_default) then
                    for c = 1, #ipr.Settings.Vgui.CheckBox do
                        local ipr_index_checkbox = ipr.Settings.Vgui.CheckBox[c]
                        local ipr_check_name = ipr_index_checkbox.Name

                        if (ipr_copy_name == ipr_check_name) then
                            ipr_index_checkbox.Vgui:SetValue(ipr_copy_default)
                            ipr_copy_find = true
                            break
                        end
                    end
                    break
                end
            end
        end

        surface.PlaySound((ipr_copy_find) and "friends/friend_online.wav" or "buttons/button18.wav")
        chat.AddText(ipr.Settings.TColor["rouge"], ipr.Settings.Script, ipr.Settings.TColor["blanc"], (ipr_copy_find) and ipr.Data.Lang[ipr.Settings.SetLang].RevertDataApply or ipr.Data.Lang[ipr.Settings.SetLang].RevertDataCancel)
    end

    local ipr_options_default, ipr_checkbox_icon, ipr_checkbox_checked = vgui.Create("DImageButton", ipr_options_middle), {[true] = {Icon = "icon16/lorry_flatbed.png", PoH = 2}, [false] = {Icon = "icon16/lorry.png", PoH = 4}}, ipr.Function.IsChecked()
    ipr_options_default:SetSize(16, 16)
    ipr_options_default:SetPos(6, ipr_checkbox_icon[ipr_checkbox_checked].PoH)
    ipr_options_default:SetImage(ipr_checkbox_icon[ipr_checkbox_checked].Icon)
    ipr.Function.SetToolTip(ipr.Data.Lang[ipr.Settings.SetLang].CheckUncheckAll, ipr_options_default, true)
    ipr_options_default.Paint = nil
    ipr_options_default.DoClick = function()
        local ipr_data_checkbox = ipr.Settings.Vgui.CheckBox
        local ipr_data_default = #ipr.Data.Default.convars
        ipr_checkbox_checked = not ipr_checkbox_checked

        for i = 1, #ipr_data_checkbox do
            if (i > ipr_data_default) then
                break
            end

            ipr_data_checkbox[i].Vgui:SetValue(ipr_checkbox_checked)
        end

        ipr_options_default:SetImage(ipr_checkbox_icon[ipr_checkbox_checked].Icon)
        ipr_options_default:SetY(ipr_checkbox_icon[ipr_checkbox_checked].PoH)

        surface.PlaySound("buttons/lever7.wav")
    end

    local ipr_options_bottom = vgui.Create("DPanel", ipr_options)
    ipr_options_bottom:SetSize(232, 165)
    ipr_options_bottom:SetPos(ipr_center - (ipr_options_bottom:GetWide() / 2), 260)
    ipr_options_bottom.Paint = function(self, w, h)
        draw.RoundedBox(4, 0, 0, w, h, ipr.Settings.BackGround)
        draw.SimpleText("Configuration :", ipr.Settings.Font, w / 2, 2, ipr.Settings.TColor["blanc"], TEXT_ALIGN_CENTER)
    end

    local ipr_options_mscroll = vgui.Create("DScrollPanel", ipr_options_middle)
    ipr_options_mscroll:Dock(FILL)
    ipr_options_mscroll:DockMargin(5, 22, 0, 5)
    ipr.Function.DScrollPaint(ipr_options_mscroll, 11)

    for i = 1, #ipr.Data.Default.convars do
        local ipr_data_convars = ipr.Data.Default.convars[i]
        local ipr_vgui_label = ipr.Function.DCheckBoxLabel(ipr_options_mscroll, ipr_data_convars)
        
        ipr_vgui_label:SetValue(ipr.Function.GetConvar(ipr_data_convars.Name))
        ipr.Function.SetToolTip(ipr_data_convars.Localization.ToolTip, ipr_vgui_label)
        ipr.Function.SetConvar(ipr_data_convars.Name, ipr_data_convars.DefaultCheck, nil, true, true)

        ipr_vgui_label.OnChange = function(self)
            ipr.Function.SetConvar(ipr_data_convars.Name, self:GetChecked())

            local ipr_convars_length = #ipr.Settings.SetConvars
            local ipr_data_copy = ipr.Function.GetCopyData()
            local ipr_convar_find = false

            for i = 1, #ipr_data_copy do
                local ipr_data_name = ipr_data_copy[i].Name
                local ipr_data_check = ipr_data_copy[i].Checked

                for c = 1, ipr_convars_length do
                    local ipr_data_find = ipr.Settings.SetConvars[c]
                    if (ipr_data_name == ipr_data_find.Name) and (ipr_data_check ~= ipr_data_find.Checked) then
                        ipr_convar_find = true
                        break
                    end
                end
            end

            ipr.Settings.Revert.Set = ipr_convar_find
        end

        ipr.Settings.Vgui.CheckBox[#ipr.Settings.Vgui.CheckBox + 1] = {Vgui = ipr_vgui_label, Default = ipr_data_convars.DefaultCheck, Name = ipr_data_convars.Name, Paired = ipr_data_convars.Paired}
    end

    local ipr_options_bscroll = vgui.Create("DScrollPanel", ipr_options_bottom)
    ipr_options_bscroll:Dock(FILL)
    ipr_options_bscroll:DockMargin(5, 22, 0, 5)
    ipr.Function.DScrollPaint(ipr_options_bscroll, 11)

    for i = 1, #ipr.Data.Default.settings do
        local ipr_data_settings = ipr.Data.Default.settings[i]
        local ipr_vgui_checkbox, ipr_vgui_slider = ipr.Function.SettingsVgui[ipr_data_settings.Vgui](ipr_options_bscroll, ipr_data_settings, ipr_DrawHud)

        ipr.Function.SetConvar(ipr_data_settings.Name, ipr_data_settings.DefaultCheck, nil, true)
        if (ipr_data_settings.Localization.ToolTip) then
            ipr.Function.SetToolTip(ipr_data_settings.Localization.ToolTip, ipr_vgui_checkbox)
        end

        ipr.Settings.Vgui.CheckBox[#ipr.Settings.Vgui.CheckBox + 1] = {Vgui = ipr_vgui_checkbox, Default = ipr_data_settings.DefaultCheck, Name = ipr_data_settings.Name, Paired = ipr_data_settings.Paired}

        if (ipr_data_settings.Paired) then
            ipr_vgui_slider:SetDisabled(not ipr.Function.GetConvar(ipr_data_settings.Paired))
        end
    end

    local ipr_options_top = vgui.Create("DPanel", ipr_options)
    ipr_options_top:SetSize(150, 60)
    ipr_options_top:SetPos(ipr_center - (ipr_options_top:GetWide() / 2), 25)
    ipr_options_top.Paint = function(self, w, h)
        draw.RoundedBox(4, 0, 0, w, h, ipr.Settings.BackGround)
    end

    local ipr_options_tscroll = vgui.Create("DScrollPanel", ipr_options_top)
    ipr_options_tscroll:Dock(FILL)
    ipr_options_tscroll:DockMargin(0, 1, 0, 1)
    ipr.Function.DScrollPaint(ipr_options_tscroll, 7)

    for i = 1, #ipr.Data.Default.buttons do
        local ipr_options_manage = vgui.Create("DPanel", ipr_options_tscroll)
        ipr_options_manage:Dock(TOP)
        ipr_options_manage:DockMargin(4, 3, 4, 0)
        ipr_options_manage.Paint = nil

        local ipr_data_buttons = ipr.Data.Default.buttons[i]
        local ipr_options_vmanage = vgui.Create(ipr_data_buttons.Vgui, ipr_options_manage)
        ipr_options_vmanage:Dock(FILL)
        ipr_options_vmanage:DockMargin(0, 1, 0, 1)
        ipr_options_vmanage:SetText("")
        ipr_options_vmanage:SetImage(ipr_data_buttons.Icon)
        ipr.Function.SetToolTip(ipr_data_buttons.Localization.ToolTip, ipr_options_vmanage)
        if (ipr_data_buttons.Convar) then
            ipr.Function.SetConvar(ipr_data_buttons.Convar.Name, ipr_data_buttons.Convar.DefaultCheck, nil, true)
        end
        local ipr_convar_color = ipr.Settings.TColor["blanc"]
        ipr_options_vmanage.Paint = function(self, w, h)
            local ipr_hovered = self:IsHovered()
            if (ipr_data_buttons.DrawLine) then
                if (ipr_data_buttons.Convar) then
                    draw.RoundedBoxEx(6, 0, 0, w, h, (ipr_hovered) and ipr.Settings.TColor["bleuc"] or ipr.Settings.TColor["bleu"], true, true, false, false)

                    local ipr_startup_delay = timer.Exists(ipr.Settings.StartupLaunch.Name)
                    ipr_convar_color = (ipr_startup_delay) and ipr.Settings.TColor["orange"] or ipr.Function.GetConvar(ipr_data_buttons.Convar.Name) and ipr.Settings.TColor["vert"] or ipr.Settings.TColor["rouge"]
                    draw.RoundedBox(0, 0, h- 1, w, h, ipr_convar_color)
                else
                    if (ipr.Settings.Revert.Set) then
                        local ipr_systime = SysTime()
                        local ipr_color_g = math.abs(math.sin(ipr_systime * 2.5) * 255)

                        draw.RoundedBoxEx(6, 0, 0, w, h, (ipr_hovered) and ipr.Settings.TColor["bleuc"] or ipr.Settings.TColor["bleu"], true, true, false, false)
                        draw.RoundedBox(1, 0, h- 1, w, h, Color(ipr_color_g, ipr_color_g, 0))
                    else
                        draw.RoundedBox(6, 0, 0, w, h, (ipr_hovered) and ipr.Settings.TColor["bleuc"] or ipr.Settings.TColor["bleu"])
                    end
                end
            else
                draw.RoundedBox(6, 0, 0, w, h, (ipr_hovered) and ipr.Settings.TColor["gvert_"] or ipr.Settings.TColor["gvert"])
            end
            surface.SetFont(ipr.Settings.Font)
            local ipr_button_text = ipr.Data.Lang[ipr.Settings.SetLang][ipr_data_buttons.Localization.Text]
            local ipr_pos_wide, ipr_pos_heigth = surface.GetTextSize(ipr_button_text)

            draw.SimpleText(ipr_button_text, ipr.Settings.Font, w / 2 - ipr_pos_wide / 2 + 7, h / 2 - ipr_pos_heigth /  2, (ipr_hovered) and ColorAlpha(color_white, 130) or ipr.Settings.TColor["blanc"], TEXT_ALIGN_LEFT)
        end
        ipr_options_vmanage.DoClick = function()
            local ipr_data_sound = ipr_data_buttons.Sound(ipr)
            surface.PlaySound(ipr_data_sound)
            
            ipr_data_buttons.Function(ipr, ipr_data_buttons)
        end
    end

    local ipr_options_close = vgui.Create("DImageButton", ipr_options)
    ipr_options_close:SetSize(16, 16)
    ipr_options_close:SetPos(ipr_options_size.w - ipr_options_close:GetWide() - 2, 2)
    ipr_options_close:SetImage("icon16/cross.png")
    ipr_options_close.Paint = nil
    ipr_options_close.DoClick = function()
        ipr_PanelClose(ipr_options, true)

        timer.Simple(0.3, function()
            if IsValid(primary) and not primary.PMoved then
                primary:MoveTo(ipr.Settings.Pos.w / 2 - primary:GetWide() / 2, ipr.Settings.Pos.h / 2 - primary:GetTall() / 2, 0.3, 0)
            end
        end)
    end

    surface.PlaySound("buttons/button9.wav")
end

local ipr_PanelBooster = function()
    if IsValid(ipr.Settings.Vgui.Primary) then
        return
    end

    local ipr_booster, ipr_booster_size =  vgui.Create("DFrame"), {w = 300, h = 275}
    ipr.Settings.Vgui.Primary = ipr_booster
    ipr_booster:SetTitle("")
    ipr_booster:SetSize(ipr_booster_size.w, ipr_booster_size.h)
    ipr_booster:Center()
    ipr_booster:MakePopup()
    ipr_booster:ShowCloseButton(false)
    ipr_booster:SetDraggable(true)
    ipr_booster:SetAlpha(0)
    ipr_booster:AlphaTo(255, 1, 0)
    ipr_booster.Paint = function(self, w, h)
        if (self.Dragging) then
            if IsValid(ipr.Settings.Vgui.Secondary) then
                local ipr_center_wide = self:GetX() + ipr_booster_size.w + 10
                local ipr_center_height = self:GetY() - (ipr.Settings.Vgui.Secondary:GetTall() / 2)
                
                ipr_center_height = ipr_center_height + (ipr_booster_size.h / 2)
                ipr.Settings.Vgui.Secondary:SetPos(ipr_center_wide, ipr_center_height)
            end

            if not self.PMoved then
                self.PMoved = true
            end
        end

        ipr.Function.RenderBlur(self, ColorAlpha(color_black, 190), 6)

        draw.RoundedBoxEx(6, 0, 0, w, 33, ipr.Settings.TColor["bleu"], true, true, false, false)
        draw.SimpleText(ipr.Data.Lang[ipr.Settings.SetLang].TEnabled,ipr.Settings.Font,w / 2, 1, ipr.Settings.TColor["blanc"], TEXT_ALIGN_CENTER)

        local ipr_current = ipr.Function.CurrentState()
        local ipr_status_text = (ipr_current) and "On (Boost)" or "Off"
        local ipr_status_color = (ipr_current) and (ipr.Settings.Revert.Set) and ipr.Settings.TColor["orange"] or (ipr_current) and ipr.Settings.TColor["vert"] or ipr.Settings.TColor["rouge"]

        draw.SimpleText("FPS :",ipr.Settings.Font, (ipr_current) and w / 2 - 25 or w / 2 -10, 16, ipr.Settings.TColor["blanc"], TEXT_ALIGN_CENTER)
        draw.SimpleText(ipr_status_text, ipr.Settings.Font, (ipr_current) and w / 2 + 22 or w / 2 + 18, 16, ipr_status_color, TEXT_ALIGN_CENTER)
    end

    local ipr_rotate = {start = 10, s_end = 35, step = 5}
    local ipr_copy = table.Copy(ipr_rotate)
    ipr_copy.NextStep = 0.2
    ipr_copy.Update = 0

    ipr_copy.Loop = function()
        local ipr_systime = SysTime()

        if (ipr_systime > ipr_copy.Update) then
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
            ipr_copy.Update = ipr_systime + ipr_copy.NextStep
        end

        return ipr_copy.start
    end

    ipr_copy.Draw = function(x, y, w, h, rotate, x0)
        local ipr_rad = math.rad(rotate)
        local ipr_cos, ipr_sin = math.cos(ipr_rad), math.sin(ipr_rad)
        local ipr_newx = ipr_sin - x0 * ipr_cos
        local ipr_newy = ipr_cos + x0 * ipr_sin

        surface.DrawTexturedRectRotated(x + ipr_newx, y + ipr_newy, w, h, rotate)
    end

    local ipr_booster_status = vgui.Create("DPanel", ipr_booster)
    ipr_booster_status:Dock(FILL)
    ipr_booster_status.Paint = function(self, w, h)
        surface.SetDrawColor(ipr.Settings.TColor["bleu"])
        surface.SetMaterial(ipr.Settings.IComputer)
        surface.DrawTexturedRect(-11, 4, 349, 235)

        local ipr_current = ipr.Function.CurrentState()
        surface.SetDrawColor((ipr_current) and ipr.Settings.TColor["vert"] or ipr.Settings.TColor["rouge"])
        surface.SetMaterial(ipr.Settings.IWrench)
        ipr_copy.Draw(207, 125, 220, 220, ipr_copy.Loop(), -25)
    end

    local ipr_booster_fps = vgui.Create("DButton", ipr_booster)
    ipr_booster_fps:SetSize(110, 83)
    ipr_booster_fps:SetPos(ipr_booster_size.w / 2 - ipr_booster_fps:GetWide() / 2, ipr_booster_size.h / 2 - ipr_booster_fps:GetTall() / 2 - 13)
    ipr_booster_fps:SetText("")
    ipr_booster_fps.Paint = function(self, w, h)
        local ipr_fps_current, ipr_fps_min, ipr_fps_max, ipr_fps_low = ipr.Function.FpsCalculator()
        local ipr_fps_center = w / 2

        draw.SimpleText(ipr.Settings.Status.Name, ipr.Settings.Font, ipr_fps_center, 6, ipr.Settings.TColor["blanc"], TEXT_ALIGN_CENTER)

        local ipr_currentpos = ipr_fps_center + 10
        draw.SimpleText(ipr.Data.Lang[ipr.Settings.SetLang].FpsCurrent, ipr.Settings.Font, ipr_currentpos, 25, ipr.Settings.TColor["blanc"], TEXT_ALIGN_RIGHT)
        draw.SimpleText(ipr_fps_current, ipr.Settings.Font, ipr_currentpos + 5, 25, ipr.Function.ColorTransition(ipr_fps_current), TEXT_ALIGN_LEFT)

        ipr_currentpos = ipr_currentpos - 5
        draw.SimpleText(ipr.Settings.Fps.Max.Name, ipr.Settings.Font, ipr_currentpos, 40, ipr.Settings.TColor["blanc"], TEXT_ALIGN_RIGHT)
        draw.SimpleText(ipr_fps_max, ipr.Settings.Font, ipr_currentpos + 5, 40, ipr.Function.ColorTransition(ipr_fps_max), TEXT_ALIGN_LEFT)

        draw.SimpleText(ipr.Settings.Fps.Min.Name, ipr.Settings.Font, ipr_currentpos, 55, ipr.Settings.TColor["blanc"], TEXT_ALIGN_RIGHT)
        draw.SimpleText(ipr_fps_min, ipr.Settings.Font, ipr_currentpos + 5, 55, ipr.Function.ColorTransition(ipr_fps_min), TEXT_ALIGN_LEFT)

        ipr_currentpos = ipr_currentpos + 10
        draw.SimpleText(ipr.Settings.Fps.Low.Name, ipr.Settings.Font, ipr_currentpos, 70, ipr.Settings.TColor["blanc"], TEXT_ALIGN_RIGHT)
        draw.SimpleText(ipr_fps_low, ipr.Settings.Font, ipr_currentpos + 5, 70, ipr.Function.ColorTransition(ipr_fps_low), TEXT_ALIGN_LEFT)
    end
    ipr_booster_fps.DoClick = function()
        gui.OpenURL(ipr.Settings.ExternalLink)
    end

    local ipr_booster_enabled = vgui.Create("DButton", ipr_booster)
    ipr_booster_enabled:SetSize(110, 23)
    ipr_booster_enabled:SetPos(5, ipr_booster_size.h - ipr_booster_enabled:GetTall() - 5)
    ipr_booster_enabled:SetText("")
    ipr_booster_enabled.Paint = function(self, w, h)
        local ipr_hovered = self:IsHovered()
        draw.RoundedBox(6, 0, 0, w, h, (ipr_hovered) and ipr.Settings.TColor["bleuc"] or ipr.Settings.TColor["bleu"])
        draw.SimpleText(ipr.Data.Lang[ipr.Settings.SetLang].VEnabled, ipr.Settings.Font, w / 2 + 7, 3, (ipr_hovered) and ColorAlpha(color_white, 130) or ipr.Settings.TColor["blanc"], TEXT_ALIGN_CENTER)

        surface.SetMaterial(ipr.Settings.IEnabled)
        surface.SetDrawColor(color_white)
        surface.DrawTexturedRect(5, h / 2 - 7, 16, 16)
    end
    ipr_booster_enabled.DoClick = function()
        local ipr_convars_checked = ipr.Function.IsChecked()
        if not ipr_convars_checked then
            return chat.AddText(ipr.Settings.TColor["rouge"], ipr.Settings.Script, ipr.Settings.TColor["blanc"], ipr.Data.Lang[ipr.Settings.SetLang].CheckedBox)
        end

        local ipr_convars_enabled = ipr.Function.Activate(true, true)
        if (ipr_convars_enabled) then
            ipr.Function.Activate(true)
            chat.AddText(ipr.Settings.TColor["rouge"], ipr.Settings.Script, ipr.Settings.TColor["blanc"], ipr.Data.Lang[ipr.Settings.SetLang].PreventCrash.. " " ..ipr.Cmd[1].Cmd)
        else
            chat.AddText(ipr.Settings.TColor["rouge"], ipr.Settings.Script, ipr.Settings.TColor["blanc"], ipr.Data.Lang[ipr.Settings.SetLang].AEnabled)
        end

        local ipr_close_booster = ipr.Function.GetConvar("AutoClose")
        if (ipr_close_booster) then
            ipr_PanelClose()
        end

        surface.PlaySound("buttons/combine_button7.wav")
    end

    local ipr_booster_disabled = vgui.Create("DButton", ipr_booster)
    ipr_booster_disabled:SetSize(110, 23)
    ipr_booster_disabled:SetPos(ipr_booster_size.w - ipr_booster_disabled:GetWide() - 5, ipr_booster_size.h - ipr_booster_disabled:GetTall() - 5)
    ipr_booster_disabled:SetText("")
    ipr_booster_disabled.Paint = function(self, w, h)
        local ipr_hovered = self:IsHovered()
        draw.RoundedBox(6, 0, 0, w, h, (ipr_hovered) and ipr.Settings.TColor["bleuc"] or ipr.Settings.TColor["bleu"])
        draw.SimpleText(ipr.Data.Lang[ipr.Settings.SetLang].VDisabled, ipr.Settings.Font, w / 2 + 7, 3, (ipr_hovered) and ColorAlpha(color_white, 130) or ipr.Settings.TColor["blanc"], TEXT_ALIGN_CENTER)

        surface.SetMaterial(ipr.Settings.IDisabled)
        surface.SetDrawColor(color_white)
        surface.DrawTexturedRect(4, h / 2 - 7, 16, 16)
    end
    ipr_booster_disabled.DoClick = function()
        local ipr_convars_enabled = ipr.Function.Activate(false, true)
        if (ipr_convars_enabled) then
            ipr.Function.Activate(false)
            chat.AddText(ipr.Settings.TColor["rouge"], ipr.Settings.Script, ipr.Settings.TColor["blanc"], ipr.Data.Lang[ipr.Settings.SetLang].Optimization)
        else
            chat.AddText(ipr.Settings.TColor["rouge"], ipr.Settings.Script, ipr.Settings.TColor["blanc"], ipr.Data.Lang[ipr.Settings.SetLang].ADisabled)
        end

        local ipr_close_booster = ipr.Function.GetConvar("AutoClose")
        if (ipr_close_booster) then
            ipr_PanelClose()
        end

        surface.PlaySound("buttons/combine_button5.wav")
    end

    local ipr_booster_reset = vgui.Create("DButton", ipr_booster)
    ipr_booster_reset:SetSize(152, 21)
    ipr_booster_reset:SetPos(ipr_booster_size.w / 2 - ipr_booster_reset:GetWide() / 2, 193)
    ipr_booster_reset:SetText("")
    ipr.Function.SetToolTip(ipr.Data.Lang[ipr.Settings.SetLang].TReset, ipr_booster_reset, true)
    ipr_booster_reset.Paint = function(self, w, h)
        local ipr_hovered = self:IsHovered()
        draw.RoundedBox(6, 0, 0, w, h, (ipr_hovered) and ipr.Settings.TColor["bleuc"] or ipr.Settings.TColor["bleu"])
        draw.SimpleText("Reset FPS Max/Min", ipr.Settings.Font, w / 2 + 8, 2, (ipr_hovered) and ColorAlpha(color_white, 130) or ipr.Settings.TColor["blanc"], TEXT_ALIGN_CENTER)

        surface.SetMaterial(ipr.Settings.IResetFps)
        surface.SetDrawColor(color_white)
        surface.DrawTexturedRect(4, h / 2 - 7, 16, 16)
    end
    ipr_booster_reset.DoClick = function()
        ipr.Function.ResetFps()
        surface.PlaySound("buttons/button9.wav")
    end

    local ipr_booster_options = vgui.Create("DButton", ipr_booster)
    ipr_booster_options:SetSize(85, 21)
    ipr_booster_options:SetPos(ipr_booster_size.w - ipr_booster_options:GetWide() - 5, 37)
    ipr_booster_options:SetText("")
    ipr.Function.SetToolTip(ipr.Data.Lang[ipr.Settings.SetLang].Options, ipr_booster_options, true)
    ipr_booster_options.Paint = function(self, w, h)
        local ipr_hovered = self:IsHovered()
        draw.RoundedBox(6, 0, 0, w, h, (ipr_hovered) and ipr.Settings.TColor["bleuc"] or ipr.Settings.TColor["bleu"])
        draw.SimpleText("Options ", ipr.Settings.Font, w / 2 + 9, 2, (ipr_hovered) and ColorAlpha(color_white, 130) or ipr.Settings.TColor["blanc"], TEXT_ALIGN_CENTER)

        surface.SetMaterial(ipr.Settings.IMatOptions)
        surface.SetDrawColor(ipr.Settings.TColor["blanc"])

        local ipr_rotation_tool = 0
        if (ipr_hovered) then
            local ipr_systime = SysTime()
            ipr_rotation_tool = math.sin(ipr_systime * 80 * math.pi / 180) * 180
        end
        surface.DrawTexturedRectRotated(13, 11, 16, 16, ipr_rotation_tool)
    end
    ipr_booster_options.DoClick = function()
        ipr_PanelOptions(ipr_booster)
    end

    local ipr_booster_lang, ipr_material_lang = vgui.Create("DComboBox", ipr_booster)
    ipr_booster_lang:SetSize(85, 21)
    ipr_booster_lang:SetPos(5, 37)
    ipr_booster_lang:SetFont(ipr.Settings.Font)
    ipr_booster_lang:SetValue(ipr.Settings.SetLang)
    ipr_booster_lang:SetTextColor(ipr.Settings.TColor["blanc"])
    ipr_booster_lang:SetSortItems(false)

    local ipr_SortByLang = function(index)
        local ipr_data_lang = {}
        for k, v in pairs(ipr.Data.Lang) do
            local ipr_selected = (index == k)
            ipr_data_lang[#ipr_data_lang + 1] = {Lang = k, Icon = (ipr_selected) and "icon16/bullet_add.png" or "materials/flags16/" ..v.Icon, Selected = (ipr_selected)}
        end
        
        ipr_material_lang = Material("materials/flags16/" ..ipr.Data.Lang[index].Icon, "noclamp")
        table.SortByMember(ipr_data_lang, "Selected", true)

        for i = 1, #ipr_data_lang do
            local ipr_data_var = ipr_data_lang[i]
            local ipr_data_langs = ipr_data_var.Lang

            ipr_booster_lang:AddChoice(ipr.Data.Lang[ipr.Settings.SetLang].SelectLangue.. " " ..ipr_data_langs, ipr_data_langs, false, ipr_data_var.Icon)

            if (ipr_data_var.Selected) then
                ipr_booster_lang:AddSpacer()
            end
        end
    end

    ipr_SortByLang(ipr.Settings.SetLang)
    ipr_booster_lang:SetText("")

    ipr_booster_lang.Paint = function(self, w, h)
        local ipr_hovered = self:IsHovered()
        draw.RoundedBox(6, 0, 0, w, h, (ipr_hovered) and ipr.Settings.TColor["bleuc"] or ipr.Settings.TColor["bleu"])

        local ipr_settings_lang = ipr.Settings.SetLang
        surface.SetFont(ipr.Settings.Font)
        local ipr_settings_wide, ipr_settings_height = surface.GetTextSize(ipr_settings_lang)

        local ipr_align_center = w / 2 - ipr_settings_wide / 2 + 2
        draw.SimpleText(ipr_settings_lang, ipr.Settings.Font, ipr_align_center, 2, (ipr_hovered) and ColorAlpha(color_white, 130) or ipr.Settings.TColor["blanc"], TEXT_ALIGN_LEFT)

        surface.SetDrawColor(ColorAlpha(ipr.Settings.TColor["blanc"], 125))

        local ipr_align_left = ipr_align_center - 4
        ipr_align_left = math.ceil(ipr_align_left)
        surface.DrawLine(ipr_align_left, h - ipr_settings_height + 4, ipr_align_left, ipr_settings_height - 4)

        local ipr_align_right = ipr_align_center + 5 + ipr_settings_wide
        surface.DrawLine(ipr_align_right, h - ipr_settings_height + 4, ipr_align_right, ipr_settings_height - 4)

        surface.SetMaterial(ipr_material_lang)
        surface.SetDrawColor(color_white)
        surface.DrawTexturedRect(5, h / 2 - 5.5, 16, 11)
    end

    local ipr_ComboPaint = function(panel)
        panel = panel:GetChildren()

        for i = 1, #panel do
            local ipr_data_panel = panel[i]
            local ipr_name_panel = ipr_data_panel:GetName()

            if (ipr_name_panel == "DPanel") then
                ipr_data_panel.Paint = function(self, w, h)
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
    
    ipr_ComboPaint(ipr_booster_lang)

    ipr_booster_lang.OnMenuOpened = function(panel)
        ipr_ComboPaint(panel)
        panel = panel:GetChildren()
        
        for i = 1, #panel do
            local ipr_data_panel = panel[i]
            if (ipr_data_panel:GetName() == "DMenu") then
                ipr_data_panel.Paint = function(p, w, h)
                    draw.RoundedBox(6, 0, 0, w, h, ipr.Settings.TColor["bleu"])
                end

                local ipr_child_lang = ipr_data_panel:GetChildren()
                for i = 1, #ipr_child_lang do
                    local ipr_index_child = ipr_child_lang[i]

                    if (ipr_index_child:GetName() == "Panel") then
                        ipr_index_child = ipr_index_child:GetChildren()

                        for i = 1, #ipr_index_child do
                            local ipr_vgui_lang = ipr_index_child[i]
                            local ipr_vgui_value = ipr_vgui_lang:GetValue()
                            ipr_vgui_value = string.find(ipr_vgui_value, ipr.Settings.SetLang)

                            if (ipr_vgui_lang.SetTextColor) then
                                ipr_vgui_lang:SetTextColor(ipr_vgui_value and ipr.Settings.TColor["vert"] or ipr.Settings.TColor["blanc"])
                                ipr_vgui_lang:SetFont(ipr.Settings.Font)

                                if (ipr_vgui_value) then
                                    ipr_vgui_lang:SetMouseInputEnabled(false)

                                    ipr_vgui_lang.Paint = nil
                                    ipr_vgui_lang.OnMousePressed = function(self, mousecode)
                                        if (mousecode == MOUSE_LEFT) then
                                            chat.AddText(ipr.Settings.TColor["rouge"], ipr.Settings.Script, ipr.Settings.TColor["blanc"], ipr.Data.Lang[ipr.Settings.SetLang].ASelectLang)
                                        end
                                    end
                                else
                                    ipr_vgui_lang.Paint = function(self, w, h)
                                        local ipr_hovered = self:IsHovered()
                                        draw.RoundedBox(1, 0, 0, w, h, (ipr_hovered) and ipr.Settings.TColor["bleuc"] or ipr.Settings.TColor["bleu"])
                                        self:SetTextColor((ipr_hovered) and ColorAlpha(color_white, 130) or ipr.Settings.TColor["blanc"])
                                    end
                                end
                            else
                                ipr_vgui_lang.Paint = function(self, w, h)
                                    draw.RoundedBox(1, 0, 0, w, h, ipr.Settings.TColor["vert"])
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    ipr_booster_lang.OnSelect = function(self, index, value)
        local ipr_set_lang = self.Data[index]
        self:Clear()
        self:SetValue(ipr_set_lang)

        ipr_SortByLang(ipr_set_lang)
        self:SetText("")

        if (ipr_set_lang ~= ipr.Settings.SetLang) then
            file.Write(ipr.Settings.Save.. "language.json", ipr_set_lang)

            ipr.Settings.SetLang = ipr_set_lang
            surface.PlaySound("common/stuck1.wav")
        end
    end

    local ipr_booster_close = vgui.Create("DImageButton", ipr_booster)
    ipr_booster_close:SetSize(16, 16)
    ipr_booster_close:SetPos(ipr_booster_size.w - ipr_booster_close:GetWide() - 2, 2)
    ipr_booster_close:SetImage("icon16/cross.png")
    ipr_booster_close.Paint = nil
    ipr_booster_close.DoClick = function()
        ipr_PanelClose(ipr_booster_close)
    end

    ipr.Function.CopyData()
end

local ipr_InitPostPlayer = function()
    timer.Simple(5, function()
        if not IsValid(ipr.Settings.Vgui.Primary) then
            ipr.Function.CreateData()

            local ipr_forced_open = ipr.Function.GetConvar("ForcedOpen")
            if (ipr_forced_open) then
                ipr_PanelBooster()
            else
                chat.AddText(ipr.Settings.TColor["rouge"], ipr.Settings.Script, ipr.Settings.TColor["blanc"], ipr.Data.Lang[ipr.Settings.SetLang].CForcedOpen.. " " ..ipr.Cmd[1].Cmd)
            end
        end

        local ipr_debug_enable = ipr.Function.GetConvar("EnableDebug")
        if (ipr_debug_enable) then
            ipr.Settings.Debug = true
        end

        local ipr_boot_startup = ipr.Function.GetConvar("Startup")
        if (ipr_boot_startup) then
            ipr.Function.Activate(true)
            chat.AddText(ipr.Settings.TColor["rouge"], ipr.Settings.Script, ipr.Settings.TColor["blanc"], ipr.Data.Lang[ipr.Settings.SetLang].StartupEnabled)
        end

        local ipr_hud_enable = ipr.Function.GetConvar("FpsView")
        if (ipr_hud_enable) then
            hook.Add("PostDrawHUD", "IprFpsBooster_HUD", ipr_DrawHud)
        end

        local ipr_fog_enabled = ipr.Function.GetConvar("EnabledFog")
        if (ipr_fog_enabled) then
            ipr.Function.FogActivate(true)
        end
    end)
end

local ipr_PlayerShutDown = function()
    local ipr_server_leave = ipr.Function.GetConvar("ServerLeaveSettings")
    if (ipr_server_leave) then
        ipr.Function.Activate(false)
    end

    local ipr_startup_delay = timer.Exists(ipr.Settings.StartupLaunch.Name)
    if (ipr_startup_delay) then
        MsgC(ipr.Settings.TColor["orange"], ipr.Settings.Script ..ipr.Data.Lang[ipr.Settings.SetLang].StartupAbandoned.. "\n")
    end
end

local ipr_OnScreenSize = function()
    ipr.Settings.Pos.w, ipr.Settings.Pos.h = ScrW(), ScrH()
end

local ipr_cmds = ipr.Cmd
local ipr_cmds_lenght = #ipr_cmds
do
    local ipr_func = false
    for i = 1, ipr_cmds_lenght do
        local ipr_cmd_index = ipr_cmds[i]
        ipr_func = function()
            ipr_cmd_index.Func(ipr)
        end

        concommand.Add(ipr_cmd_index.Cmd, ipr_func)
    end
end

local ipr_ChatCmds = function(ply, text)
    local ipr_client_player = LocalPlayer()
    if (ipr_client_player == ply) then
        text = string.lower(text)
        
        for i = 1, ipr_cmds_lenght do
            local ipr_cmd_index = ipr_cmds[i]

            if (ipr_cmd_index.Cmd == text) then
                ipr_cmd_index.Func(ipr)
                return true
            end
        end
    end
end

ipr.PanelOpen = function()
    ipr.Function.CreateData()
    ipr_PanelBooster()
end

hook.Add("ShutDown", "IprFpsBooster_ShutDown", ipr_PlayerShutDown)
hook.Add("OnScreenSizeChanged", "IprFpsBooster_OnScreen", ipr_OnScreenSize)
hook.Add("InitPostEntity", "IprFpsBooster_InitPlayer", ipr_InitPostPlayer)
hook.Add("OnPlayerChat", "IprFpsBooster_ChatCmds", ipr_ChatCmds)