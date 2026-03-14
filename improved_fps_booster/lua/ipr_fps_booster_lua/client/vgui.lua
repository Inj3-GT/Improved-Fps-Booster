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
    local ipr_player_ping = LocalPlayer():Ping()

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
            {Name = ipr_player_ping, FColor = (ipr_player_ping > 100) and ipr.Settings.TColor["rouge"] or ipr.Settings.TColor["vert"]},

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
                local ipr_wcenterprimary = self:GetX() - primary:GetWide() - 10
                local ipr_hcenterprimary = self:GetY() + (ipr_options_size.h / 2)
                ipr_hcenterprimary = ipr_hcenterprimary - (primary:GetTall() / 2)

                primary:SetPos(ipr_wcenterprimary, ipr_hcenterprimary)

                if not primary.PMoved then
                    primary.PMoved = true
                end
            end
        end

        ipr.Function.RenderBlur(self, ColorAlpha(color_black, 180), 6)

        draw.RoundedBoxEx(6, 0, 0, w, 20, ipr.Settings.TColor["bleu"], true, true, false, false)
        draw.SimpleText(ipr.Data.Lang[ipr.Settings.SetLang].NOptions, ipr.Settings.Font, w / 2, 1, ipr.Settings.TColor["blanc"], TEXT_ALIGN_CENTER)

        local ipr_fpslimit = math.Round(ipr.Function.InfoNum("fps_max"))
        ipr_fpslimit = (ipr_fpslimit > ipr.Settings.MaxFps) and ipr.Settings.MaxFps or ipr_fpslimit

        draw.SimpleText(ipr.Data.Lang[ipr.Settings.SetLang].FPSLimit, ipr.Settings.Font, 5, h - 19, ipr.Settings.TColor["blanc"], TEXT_ALIGN_LEFT)
        draw.SimpleText(ipr_fpslimit, ipr.Settings.Font, 67, h - 19, ipr.Function.ColorTransition(ipr_fpslimit), TEXT_ALIGN_LEFT)

        local ipr_systimecolor = SysTime() * 1.5
        local ipr_r = math.sin(ipr_systimecolor) * 255
        local ipr_g = math.sin(ipr_systimecolor + 2) * 255
        local ipr_b = math.sin(ipr_systimecolor + 4) * 255

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
        local ipr_cdata, ipr_cfind = ipr.Function.GetCopyData()

        for i = 1, #ipr.Settings.SetConvars do
            local ipr_convarlist = ipr.Settings.SetConvars[i]
            local ipr_convarname, ipr_convarcheck = ipr_convarlist.Name, ipr_convarlist.Checked

            for t = 1, #ipr_cdata do
                local ipr_copylist = ipr_cdata[t]
                local ipr_copyname, ipr_copydefault = ipr_copylist.Name, ipr_copylist.Checked

                if (ipr_convarname == ipr_copyname and ipr_convarcheck ~= ipr_copydefault) then
                    for c = 1, #ipr.Settings.Vgui.CheckBox do
                        local ipr_checklist = ipr.Settings.Vgui.CheckBox[c]
                        local ipr_checkname = ipr_checklist.Name

                        if (ipr_copyname == ipr_checkname) then
                            ipr_checklist.Vgui:SetValue(ipr_copydefault)
                            ipr_cfind = true
                            break
                        end
                    end
                    break
                end
            end
        end

        surface.PlaySound((ipr_cfind) and "friends/friend_online.wav" or "buttons/button18.wav")
        chat.AddText(ipr.Settings.TColor["rouge"], ipr.Settings.Script, ipr.Settings.TColor["blanc"], (ipr_cfind) and ipr.Data.Lang[ipr.Settings.SetLang].RevertDataApply or ipr.Data.Lang[ipr.Settings.SetLang].RevertDataCancel)
    end

    local ipr_options_default, ipr_checkboxstate, ipr_checked = vgui.Create("DImageButton", ipr_options_middle), {[true] = {Icon = "icon16/lorry_flatbed.png", PoH = 2}, [false] = {Icon = "icon16/lorry.png", PoH = 4}}, ipr.Function.IsChecked()
    ipr_options_default:SetSize(16, 16)
    ipr_options_default:SetPos(6, ipr_checkboxstate[ipr_checked].PoH)
    ipr_options_default:SetImage(ipr_checkboxstate[ipr_checked].Icon)
    ipr.Function.SetToolTip(ipr.Data.Lang[ipr.Settings.SetLang].CheckUncheckAll, ipr_options_default, true)
    ipr_options_default.Paint = nil
    ipr_options_default.DoClick = function()
        local ipr_tcheckbox = ipr.Settings.Vgui.CheckBox
        local ipr_tdefault = #ipr.Data.Default.convars
        ipr_checked = not ipr_checked

        for i = 1, #ipr_tcheckbox do
            if (i > ipr_tdefault) then
                break
            end

            ipr_tcheckbox[i].Vgui:SetValue(ipr_checked)
        end

        ipr_options_default:SetImage(ipr_checkboxstate[ipr_checked].Icon)
        ipr_options_default:SetY(ipr_checkboxstate[ipr_checked].PoH)

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
        local ipr_tconvars = ipr.Data.Default.convars[i]
        local ipr_createcheckbox = ipr.Function.DCheckBoxLabel(ipr_options_mscroll, ipr_tconvars)
        
        ipr_createcheckbox:SetValue(ipr.Function.GetConvar(ipr_tconvars.Name))
        ipr.Function.SetToolTip(ipr_tconvars.Localization.ToolTip, ipr_createcheckbox)
        ipr.Function.SetConvar(ipr_tconvars.Name, ipr_tconvars.DefaultCheck, nil, true, true)

        ipr_createcheckbox.OnChange = function(self)
            ipr.Function.SetConvar(ipr_tconvars.Name, self:GetChecked())

            local ipr_tlenght = #ipr.Settings.SetConvars
            local ipr_tdata = ipr.Function.GetCopyData()
            local ipr_convarfind = false

            for i = 1, #ipr_tdata do
                local ipr_dataname = ipr_tdata[i].Name
                local ipr_datacheck = ipr_tdata[i].Checked

                for c = 1, ipr_tlenght do
                    local ipr_datafind = ipr.Settings.SetConvars[c]
                    if (ipr_dataname == ipr_datafind.Name) and (ipr_datacheck ~= ipr_datafind.Checked) then
                        ipr_convarfind = true
                        break
                    end
                end
            end

            ipr.Settings.Revert.Set = ipr_convarfind
        end

        ipr.Settings.Vgui.CheckBox[#ipr.Settings.Vgui.CheckBox + 1] = {Vgui = ipr_createcheckbox, Default = ipr_tconvars.DefaultCheck, Name = ipr_tconvars.Name, Paired = ipr_tconvars.Paired}
    end

    local ipr_options_bscroll = vgui.Create("DScrollPanel", ipr_options_bottom)
    ipr_options_bscroll:Dock(FILL)
    ipr_options_bscroll:DockMargin(5, 22, 0, 5)
    ipr.Function.DScrollPaint(ipr_options_bscroll, 11)

    for i = 1, #ipr.Data.Default.settings do
        local ipr_sconfigsettings = ipr.Data.Default.settings[i]
        local ipr_sconfigcheckbox, ipr_sconfigslider = ipr.Function.SettingsVgui[ipr_sconfigsettings.Vgui](ipr_options_bscroll, ipr_sconfigsettings, ipr_DrawHud)

        ipr.Function.SetConvar(ipr_sconfigsettings.Name, ipr_sconfigsettings.DefaultCheck, nil, true)
        if (ipr_sconfigsettings.Localization.ToolTip) then
            ipr.Function.SetToolTip(ipr_sconfigsettings.Localization.ToolTip, ipr_sconfigcheckbox)
        end

        ipr.Settings.Vgui.CheckBox[#ipr.Settings.Vgui.CheckBox + 1] = {Vgui = ipr_sconfigcheckbox, Default = ipr_sconfigsettings.DefaultCheck, Name = ipr_sconfigsettings.Name, Paired = ipr_sconfigsettings.Paired}

        if (ipr_sconfigsettings.Paired) then
            ipr_sconfigslider:SetDisabled(not ipr.Function.GetConvar(ipr_sconfigsettings.Paired))
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

        local ipr_tmanage = ipr.Data.Default.buttons[i]
        local ipr_options_vmanage = vgui.Create(ipr_tmanage.Vgui, ipr_options_manage)
        ipr_options_vmanage:Dock(FILL)
        ipr_options_vmanage:DockMargin(0, 1, 0, 1)
        ipr_options_vmanage:SetText("")
        ipr_options_vmanage:SetImage(ipr_tmanage.Icon)
        ipr.Function.SetToolTip(ipr_tmanage.Localization.ToolTip, ipr_options_vmanage)
        if (ipr_tmanage.Convar) then
            ipr.Function.SetConvar(ipr_tmanage.Convar.Name, ipr_tmanage.Convar.DefaultCheck, nil, true)
        end
        local ipr_convarcolor = ipr.Settings.TColor["blanc"]
        ipr_options_vmanage.Paint = function(self, w, h)
            local ipr_hovered = self:IsHovered()
            if (ipr_tmanage.DrawLine) then
                if (ipr_tmanage.Convar) then
                    draw.RoundedBoxEx(6, 0, 0, w, h, (ipr_hovered) and ipr.Settings.TColor["bleuc"] or ipr.Settings.TColor["bleu"], true, true, false, false)

                    local ipr_startupdelay = timer.Exists(ipr.Settings.StartupLaunch.Name)
                    ipr_convarcolor = (ipr_startupdelay) and ipr.Settings.TColor["orange"] or ipr.Function.GetConvar(ipr_tmanage.Convar.Name) and ipr.Settings.TColor["vert"] or ipr.Settings.TColor["rouge"]
                    draw.RoundedBox(0, 0, h- 1, w, h, ipr_convarcolor)
                else
                    if (ipr.Settings.Revert.Set) then
                        local ipr_systimecolor = SysTime()
                        local ipr_colorg = math.abs(math.sin(ipr_systimecolor * 2.5) * 255)

                        draw.RoundedBoxEx(6, 0, 0, w, h, (ipr_hovered) and ipr.Settings.TColor["bleuc"] or ipr.Settings.TColor["bleu"], true, true, false, false)
                        draw.RoundedBox(1, 0, h- 1, w, h, Color(ipr_colorg, ipr_colorg, 0))
                    else
                        draw.RoundedBox(6, 0, 0, w, h, (ipr_hovered) and ipr.Settings.TColor["bleuc"] or ipr.Settings.TColor["bleu"])
                    end
                end
            else
                draw.RoundedBox(6, 0, 0, w, h, (ipr_hovered) and ipr.Settings.TColor["gvert_"] or ipr.Settings.TColor["gvert"])
            end
            surface.SetFont(ipr.Settings.Font)
            local ipr_tbutton = ipr.Data.Lang[ipr.Settings.SetLang][ipr_tmanage.Localization.Text]
            local ipr_ptwide, ipr_ptheight = surface.GetTextSize(ipr_tbutton)

            draw.SimpleText(ipr_tbutton, ipr.Settings.Font, w / 2 - ipr_ptwide / 2 + 7, h / 2 - ipr_ptheight /  2, ipr.Settings.TColor["blanc"], TEXT_ALIGN_LEFT)
        end
        ipr_options_vmanage.DoClick = function()
            local ipr_tsound = ipr_tmanage.Sound(ipr)
            surface.PlaySound(ipr_tsound)
            
            ipr_tmanage.Function(ipr, ipr_tmanage)
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

        ipr.Function.RenderBlur(self, ColorAlpha(color_black, 180), 6)

        draw.RoundedBoxEx(6, 0, 0, w, 33, ipr.Settings.TColor["bleu"], true, true, false, false)
        draw.SimpleText(ipr.Data.Lang[ipr.Settings.SetLang].TEnabled,ipr.Settings.Font,w / 2, 1, ipr.Settings.TColor["blanc"], TEXT_ALIGN_CENTER)

        local ipr_currentstate = ipr.Function.CurrentState()
        local ipr_tcurrentstatus = (ipr_currentstate) and "On (Boost)" or "Off"
        local ipr_tcurrentcolor = (ipr_currentstate) and (ipr.Settings.Revert.Set) and ipr.Settings.TColor["orange"] or (ipr_currentstate) and ipr.Settings.TColor["vert"] or ipr.Settings.TColor["rouge"]

        draw.SimpleText("FPS :",ipr.Settings.Font, (ipr_currentstate) and w / 2 - 25 or w / 2 -10, 16, ipr.Settings.TColor["blanc"], TEXT_ALIGN_CENTER)
        draw.SimpleText(ipr_tcurrentstatus, ipr.Settings.Font, (ipr_currentstate) and w / 2 + 22 or w / 2 + 18, 16, ipr_tcurrentcolor, TEXT_ALIGN_CENTER)
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

        local ipr_currentstate = ipr.Function.CurrentState()
        surface.SetDrawColor((ipr_currentstate) and ipr.Settings.TColor["vert"] or ipr.Settings.TColor["rouge"])
        surface.SetMaterial(ipr.Settings.IWrench)
        local ipr_loop = ipr_copy.Loop()
        ipr_copy.Draw(207, 125, 220, 220, ipr_loop, -25)
    end

    local ipr_booster_fps = vgui.Create("DButton", ipr_booster)
    ipr_booster_fps:SetSize(110, 83)
    ipr_booster_fps:SetPos(ipr_booster_size.w / 2 - ipr_booster_fps:GetWide() / 2, ipr_booster_size.h / 2 - ipr_booster_fps:GetTall() / 2 - 13)
    ipr_booster_fps:SetText("")
    ipr_booster_fps.Paint = function(self, w, h)
        local ipr_fps_current, ipr_fps_min, ipr_fps_max, ipr_fps_low = ipr.Function.FpsCalculator()
        local ipr_centerfpshud = w / 2

        draw.SimpleText(ipr.Settings.Status.Name, ipr.Settings.Font, ipr_centerfpshud, 6, ipr.Settings.TColor["blanc"], TEXT_ALIGN_CENTER)

        local ipr_currentpos = ipr_centerfpshud + 10
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
    ipr_booster_enabled:SetPos(5, ipr_booster_size.h - ipr_booster_enabled:GetTall() - 4)
    ipr_booster_enabled:SetText("")
    ipr_booster_enabled.Paint = function(self, w, h)
        draw.RoundedBox(6, 0, 0, w, h, self:IsHovered() and ipr.Settings.TColor["bleuc"] or ipr.Settings.TColor["bleu"])
        draw.SimpleText(ipr.Data.Lang[ipr.Settings.SetLang].VEnabled, ipr.Settings.Font, w / 2 + 7, 3, ipr.Settings.TColor["blanc"], TEXT_ALIGN_CENTER)

        surface.SetMaterial(ipr.Settings.IEnabled)
        surface.SetDrawColor(color_white)
        surface.DrawTexturedRect(5, h / 2 - 7, 16, 16)
    end
    ipr_booster_enabled.DoClick = function()
        local ipr_checkbox = ipr.Function.IsChecked()
        if not ipr_checkbox then
            return chat.AddText(ipr.Settings.TColor["rouge"], ipr.Settings.Script, ipr.Settings.TColor["blanc"], ipr.Data.Lang[ipr.Settings.SetLang].CheckedBox)
        end

        local ipr_convarsenabled = ipr.Function.Activate(true, true)
        if (ipr_convarsenabled) then
            ipr.Function.Activate(true)
            chat.AddText(ipr.Settings.TColor["rouge"], ipr.Settings.Script, ipr.Settings.TColor["blanc"], ipr.Data.Lang[ipr.Settings.SetLang].PreventCrash.. " " ..ipr.Cmd[1].Cmd)
        else
            chat.AddText(ipr.Settings.TColor["rouge"], ipr.Settings.Script, ipr.Settings.TColor["blanc"], ipr.Data.Lang[ipr.Settings.SetLang].AEnabled)
        end

        local ipr_closefpsbooster = ipr.Function.GetConvar("AutoClose")
        if (ipr_closefpsbooster) then
            ipr_PanelClose()
        end

        surface.PlaySound("buttons/combine_button7.wav")
    end

    local ipr_booster_disabled = vgui.Create("DButton", ipr_booster)
    ipr_booster_disabled:SetSize(110, 23)
    ipr_booster_disabled:SetPos(ipr_booster_size.w - ipr_booster_disabled:GetWide() - 5, ipr_booster_size.h - ipr_booster_disabled:GetTall() - 4)
    ipr_booster_disabled:SetText("")
    ipr_booster_disabled.Paint = function(self, w, h)
        draw.RoundedBox(6, 0, 0, w, h, self:IsHovered() and ipr.Settings.TColor["bleuc"] or ipr.Settings.TColor["bleu"])
        draw.SimpleText(ipr.Data.Lang[ipr.Settings.SetLang].VDisabled, ipr.Settings.Font, w / 2 + 7, 3, ipr.Settings.TColor["blanc"], TEXT_ALIGN_CENTER)

        surface.SetMaterial(ipr.Settings.IDisabled)
        surface.SetDrawColor(color_white)
        surface.DrawTexturedRect(4, h / 2 - 7, 16, 16)
    end
    ipr_booster_disabled.DoClick = function()
        local ipr_convarsenabled = ipr.Function.Activate(false, true)
        if (ipr_convarsenabled) then
            ipr.Function.Activate(false)
            chat.AddText(ipr.Settings.TColor["rouge"], ipr.Settings.Script, ipr.Settings.TColor["blanc"], ipr.Data.Lang[ipr.Settings.SetLang].Optimization)
        else
            chat.AddText(ipr.Settings.TColor["rouge"], ipr.Settings.Script, ipr.Settings.TColor["blanc"], ipr.Data.Lang[ipr.Settings.SetLang].ADisabled)
        end

        local ipr_closefpsbooster = ipr.Function.GetConvar("AutoClose")
        if (ipr_closefpsbooster) then
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
        draw.RoundedBox(6, 0, 0, w, h, self:IsHovered() and ipr.Settings.TColor["bleuc"] or ipr.Settings.TColor["bleu"])
        draw.SimpleText("Reset FPS Max/Min", ipr.Settings.Font, w / 2 + 8, 2, ipr.Settings.TColor["blanc"], TEXT_ALIGN_CENTER)

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
        local ipr_hover = self:IsHovered()

        draw.RoundedBox(6, 0, 0, w, h, (ipr_hover) and ipr.Settings.TColor["bleuc"] or ipr.Settings.TColor["bleu"])
        draw.SimpleText("Options ", ipr.Settings.Font, w / 2 + 9, 2, ipr.Settings.TColor["blanc"], TEXT_ALIGN_CENTER)

        surface.SetMaterial(ipr.Settings.IMatOptions)
        surface.SetDrawColor(ipr.Settings.TColor["blanc"])

        local ipr_rotation_tool = 0
        if (ipr_hover) then
            local ipr_systime = SysTime()
            ipr_rotation_tool = math.sin(ipr_systime * 80 * math.pi / 180) * 180
        end
        surface.DrawTexturedRectRotated(13, 11, 16, 16, ipr_rotation_tool)
    end
    ipr_booster_options.DoClick = function()
        ipr_PanelOptions(ipr_booster)
    end

    local ipr_booster_lang, ipr_booster_flang = vgui.Create("DComboBox", ipr_booster)
    ipr_booster_lang:SetSize(85, 21)
    ipr_booster_lang:SetPos(5, 37)
    ipr_booster_lang:SetFont(ipr.Settings.Font)
    ipr_booster_lang:SetValue(ipr.Settings.SetLang)
    ipr_booster_lang:SetTextColor(ipr.Settings.TColor["blanc"])
    ipr_booster_lang:SetSortItems(false)

    local ipr_SortByLang = function(index)
        local ipr_sort = {}
        for k, v in pairs(ipr.Data.Lang) do
            local ipr_selected = (index == k)
            ipr_sort[#ipr_sort + 1] = {Lang = k, Icon = (ipr_selected) and "icon16/bullet_add.png" or "materials/flags16/" ..v.Icon, Selected = (ipr_selected)}
        end
        
        ipr_booster_flang = Material("materials/flags16/" ..ipr.Data.Lang[index].Icon, "noclamp")
        table.SortByMember(ipr_sort, "Selected", true)

        for i = 1, #ipr_sort do
            local ipr_choicevar = ipr_sort[i]
            local ipr_choicelang = ipr_choicevar.Lang
            local ipr_choiceicon = ipr_choicevar.Icon

            ipr_booster_lang:AddChoice(ipr.Data.Lang[ipr.Settings.SetLang].SelectLangue.. " " ..ipr_choicelang, ipr_choicelang, false, ipr_choiceicon)

            local ipr_cspace = ipr_choicevar.Selected
            if (ipr_cspace) then
                ipr_booster_lang:AddSpacer()
            end
        end
    end

    ipr_SortByLang(ipr.Settings.SetLang)
    ipr_booster_lang:SetText("")

    ipr_booster_lang.Paint = function(self, w, h)
        draw.RoundedBox(6, 0, 0, w, h, self:IsHovered() and ipr.Settings.TColor["bleuc"] or ipr.Settings.TColor["bleu"])

        local ipr_settings_lang = ipr.Settings.SetLang
        surface.SetFont(ipr.Settings.Font)
        local ipr_settings_wide, ipr_settings_height = surface.GetTextSize(ipr_settings_lang)

        local ipr_align_center = w / 2 - ipr_settings_wide / 2 + 2
        draw.SimpleText(ipr_settings_lang, ipr.Settings.Font, ipr_align_center, 2, ipr.Settings.TColor["blanc"], TEXT_ALIGN_LEFT)

        surface.SetDrawColor(ColorAlpha(ipr.Settings.TColor["blanc"], 125))

        local ipr_align_left = ipr_align_center - 4
        ipr_align_left = math.ceil(ipr_align_left)
        surface.DrawLine(ipr_align_left, h - ipr_settings_height + 4, ipr_align_left, ipr_settings_height - 4)

        local ipr_align_right = ipr_align_center + 5 + ipr_settings_wide
        surface.DrawLine(ipr_align_right, h - ipr_settings_height + 4, ipr_align_right, ipr_settings_height - 4)

        surface.SetMaterial(ipr_booster_flang)
        surface.SetDrawColor(color_white)
        surface.DrawTexturedRect(5, h / 2 - 5.5, 16, 11)
    end

    local ipr_ComboPaint = function(panel)
        local ipr_pchild = panel:GetChildren()

        for i = 1, #ipr_pchild do
            local ipr_cpanel = ipr_pchild[i]
            local ipr_cnamepanel = ipr_cpanel:GetName()

            if (ipr_cnamepanel == "DPanel") then
                ipr_cpanel.Paint = function(self, w, h)
                    local ipr_wcenterlangpaint = w / 2
                    local ipr_hcenterlangpaint = h / 2

                    local ipr_arrowright = {
                        {x = ipr_wcenterlangpaint, y = ipr_hcenterlangpaint - 8 / 2},
                        {x = ipr_wcenterlangpaint + 5, y = ipr_hcenterlangpaint},
                        {x = ipr_wcenterlangpaint, y = ipr_hcenterlangpaint + 8 / 2},
                    }

                    surface.SetDrawColor(ColorAlpha(ipr.Settings.TColor["blanc"], 170))
                    draw.NoTexture()
                    surface.DrawPoly(ipr_arrowright)
                end
            end
        end
    end
    
    ipr_ComboPaint(ipr_booster_lang)

    ipr_booster_lang.OnMenuOpened = function(self)
        local ipr_pchild = self:GetChildren()
        ipr_ComboPaint(self)

        for i = 1, #ipr_pchild do
            local ipr_tchild = ipr_pchild[i]
            if (ipr_tchild:GetName() == "DMenu") then
                ipr_tchild.Paint = function(p, w, h)
                    draw.RoundedBox(6, 0, 0, w, h, ipr.Settings.TColor["bleu"])
                end

                local ipr_planguagedmenu = ipr_tchild:GetChildren()
                for i = 1, #ipr_planguagedmenu do
                    local ipr_plangdmenu = ipr_planguagedmenu[i]

                    if (ipr_plangdmenu:GetName() == "Panel") then
                        local ipr_planguagepanel = ipr_plangdmenu:GetChildren()

                        for i = 1, #ipr_planguagepanel do
                            local ipr_pmenu = ipr_planguagepanel[i]
                            local ipr_getval = ipr_pmenu:GetValue()

                            ipr_getval = string.find(ipr_getval, ipr.Settings.SetLang)

                            if (ipr_pmenu.SetTextColor) then
                                ipr_pmenu:SetTextColor(ipr_getval and ipr.Settings.TColor["vert"] or ipr.Settings.TColor["blanc"])
                                ipr_pmenu:SetFont(ipr.Settings.Font)

                                if (ipr_getval) then
                                    ipr_pmenu:SetMouseInputEnabled(false)

                                    ipr_pmenu.Paint = nil
                                    ipr_pmenu.OnMousePressed = function(self, mousecode)
                                        if (mousecode == MOUSE_LEFT) then
                                            chat.AddText(ipr.Settings.TColor["rouge"], ipr.Settings.Script, ipr.Settings.TColor["blanc"], ipr.Data.Lang[ipr.Settings.SetLang].ASelectLang)
                                        end
                                    end
                                else
                                    ipr_pmenu.Paint = function(self, w, h)
                                        draw.RoundedBox(1, 0, 0, w, h, self:IsHovered() and ipr.Settings.TColor["bleuc"] or ipr.Settings.TColor["bleu"])
                                    end
                                end
                            else
                                ipr_pmenu.Paint = function(self, w, h)
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
        local ipr_setlang = self.Data[index]
        self:Clear()
        self:SetValue(ipr_setlang)

        ipr_SortByLang(ipr_setlang)
        self:SetText("")

        if (ipr_setlang ~= ipr.Settings.SetLang) then
            file.Write(ipr.Settings.Save.. "language.json", ipr_setlang)

            ipr.Settings.SetLang = ipr_setlang
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

            local ipr_forcedopen = ipr.Function.GetConvar("ForcedOpen")
            if (ipr_forcedopen) then
                ipr_PanelBooster()
            else
                chat.AddText(ipr.Settings.TColor["rouge"], ipr.Settings.Script, ipr.Settings.TColor["blanc"], ipr.Data.Lang[ipr.Settings.SetLang].CForcedOpen.. " " ..ipr.Cmd[1].Cmd)
            end
        end

        local ipr_debugenable = ipr.Function.GetConvar("EnableDebug")
        if (ipr_debugenable) then
            ipr.Settings.Debug = true
        end

        local ipr_startup = ipr.Function.GetConvar("Startup")
        if (ipr_startup) then
            ipr.Function.Activate(true)
            chat.AddText(ipr.Settings.TColor["rouge"], ipr.Settings.Script, ipr.Settings.TColor["blanc"], ipr.Data.Lang[ipr.Settings.SetLang].StartupEnabled)
        end

        local ipr_hudenable = ipr.Function.GetConvar("FpsView")
        if (ipr_hudenable) then
            hook.Add("PostDrawHUD", "IprFpsBooster_HUD", ipr_DrawHud)
        end

        local ipr_enabledfog = ipr.Function.GetConvar("EnabledFog")
        if (ipr_enabledfog) then
            ipr.Function.FogActivate(true)
        end
    end)
end

local ipr_PlayerShutDown = function()
    local ipr_serverleave = ipr.Function.GetConvar("ServerLeaveSettings")
    if (ipr_serverleave) then
        ipr.Function.Activate(false)
    end

    local ipr_startupdelay = timer.Exists(ipr.Settings.StartupLaunch.Name)
    if (ipr_startupdelay) then
        MsgC(ipr.Settings.TColor["orange"], ipr.Settings.Script ..ipr.Data.Lang[ipr.Settings.SetLang].StartupAbandoned.. "\n")
    end
end

local ipr_OnScreenSize = function()
    ipr.Settings.Pos.w, ipr.Settings.Pos.h = ScrW(), ScrH()
end

local ipr_cmds, ipr_func = ipr.Cmd, nil
local ipr_length = #ipr_cmds
for i = 1, ipr_length do
    local ipr_tcmd = ipr_cmds[i]
    ipr_func = function()
        ipr_tcmd.Func(ipr)
    end

    concommand.Add(ipr_tcmd.Cmd, ipr_func)
end

local ipr_ChatCmds = function(ply, text)
    local ipr_localplayer = LocalPlayer()
    if (ipr_localplayer == ply) then
        text = string.lower(text)
        
        for i = 1, ipr_length do
            local ipr_tcmd = ipr_cmds[i]

            if (ipr_tcmd.Cmd == text) then
                ipr_tcmd.Func(ipr)
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