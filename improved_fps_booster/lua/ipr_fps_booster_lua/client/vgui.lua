// Script by Inj3
// Steam : https://steamcommunity.com/id/Inj3/
// Discord : Inj3
// General Public License v3.0
// https://github.com/Inj3-GT

local ipr = include("function.lua")

local ipr_HUD = function()
    local ipr_fpscurrent, ipr_fpsmin, ipr_fpsmax, ipr_fpslow = ipr.Function.FpsCalculator()
    local ipr_pheight = ipr.Settings.Pos.h * ipr.Function.GetConvar("FpsPosHeight") / 100
    local ipr_pwide = ipr.Settings.Pos.w * ipr.Function.GetConvar("FpsPosWidth") / 100
    local ipr_playerping = LocalPlayer():Ping()

    local ipr_HudFpsBooster = {
        {
            {Name = "FPS :", FColor = ipr.Settings.TColor["blanc"]},
            {Name = ipr_fpscurrent, FColor = ipr.Function.ColorTransition(ipr_fpscurrent)},
            {Name = "|", FColor = ipr.Settings.TColor["blanc"]},
            {Name = ipr.Settings.Fps.Min.Name, FColor = ipr.Settings.TColor["blanc"]},
            {Name = ipr_fpsmin, FColor = ipr.Function.ColorTransition(ipr_fpsmin)},
            {Name = "|", FColor = ipr.Settings.TColor["blanc"]},
            {Name = ipr.Settings.Fps.Max.Name, FColor = ipr.Settings.TColor["blanc"]},
            {Name = ipr_fpsmax, FColor = ipr.Function.ColorTransition(ipr_fpsmax)},
            {Name = "|", FColor = ipr.Settings.TColor["blanc"]},
            {Name = ipr.Settings.Fps.Low.Name, FColor = ipr.Settings.TColor["blanc"]},
            {Name = ipr_fpslow, FColor = ipr.Function.ColorTransition(ipr_fpslow)},

            Pos = {PWide = ipr_pwide, PHeight = ipr_pheight},
        },
        {
            {Name = "Map :", FColor = ipr.Settings.TColor["blanc"]},
            {Name = ipr.Settings.Map, FColor = ipr.Settings.TColor["orangec"]},
            {Name = "|", FColor = ipr.Settings.TColor["blanc"]},
            {Name = "Ping :", FColor = ipr.Settings.TColor["blanc"]},
            {Name = ipr_playerping, FColor = (ipr_playerping > 100) and ipr.Settings.TColor["rouge"] or ipr.Settings.TColor["vert"]},

            Pos = {PWide = ipr_pwide - 1, PHeight = ipr_pheight + 20},
        }
    }

    ipr.Function.DrawMultipleTextAligned(ipr_HudFpsBooster)
end

local ipr_FrameClose = function(frame, bool)
    if IsValid(frame) then
        surface.PlaySound("common/wpn_select.wav")

        if (bool) then
            frame:Remove()
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

local function IprFpsBooster_Options(primary)
    if IsValid(ipr.Settings.Vgui.Secondary) then
        return
    end
    
    local ipr_poptions, ipr_psize = vgui.Create("DFrame"), {w = 240, h = 450}
    ipr_poptions:SetTitle("")
    ipr_poptions:SetSize(ipr_psize.w, ipr_psize.h)
    ipr_poptions:MakePopup()
    ipr_poptions:ShowCloseButton(false)
    ipr_poptions:SetDraggable(true)
    ipr.Settings.Vgui.Secondary = ipr_poptions

    if IsValid(primary) then
        local ipr_vmoved = function()
            ipr_poptions:AlphaTo(255, 1.5, 0)

            local ipr_hcentersecondary = primary:GetY() - (ipr_psize.h / 2)
            local ipr_wfirstpos = primary:GetX() + primary:GetWide()
            ipr_poptions:SetPos(ipr_wfirstpos, ipr_hcentersecondary)

            ipr_hcentersecondary = ipr_hcentersecondary + (primary:GetTall() / 2)
            ipr_poptions:MoveTo(ipr_wfirstpos, ipr_hcentersecondary, 0.5, 0)

            local ipr_wcentersecondary = ipr_wfirstpos + 10
            ipr_poptions:MoveTo(ipr_wcentersecondary, ipr_hcentersecondary, 0.5, 0.5)
        end
        ipr_poptions:SetAlpha(0)

        if not primary.PMoved then
            primary:MoveTo(primary:GetX() - (ipr_psize.w / 2), primary:GetY(), 0.3, 0, -1, ipr_vmoved)
        else
            ipr_vmoved()
        end
    else
        ipr_poptions:Center()
    end

    ipr_poptions.Paint = function(self, w, h)
        if IsValid(primary) then
            if (primary.Dragging) and (self.m_AnimList) then
                self:Stop()
                self:SetAlpha(255)
            end
            
            if (self.Dragging) then
                local ipr_wcenterprimary = self:GetX() - primary:GetWide() - 10
                local ipr_hcenterprimary = self:GetY() + (ipr_psize.h / 2)
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

    local ipr_vcenter = ipr_psize.w / 2
    local ipr_schecked = ipr.Function.IsChecked()
    ipr.Settings.Vgui.CheckBox = {}

    local ipr_pclose = vgui.Create("DImageButton", ipr_poptions)
    ipr_pclose:SetSize(16, 16)
    ipr_pclose:SetPos(ipr_psize.w - ipr_pclose:GetWide() - 2, 2)
    ipr_pclose:SetImage("icon16/cross.png")
    ipr_pclose.Paint = nil
    ipr_pclose.DoClick = function()
        ipr_FrameClose(ipr_poptions, true)

        timer.Simple(0.3, function()
            if IsValid(primary) and not primary.PMoved then
                primary:MoveTo(ipr.Settings.Pos.w / 2 - primary:GetWide() / 2, ipr.Settings.Pos.h / 2 - primary:GetTall() / 2, 0.3, 0)
            end
        end)
    end

    local ipr_popti = vgui.Create("DPanel", ipr_poptions)
    ipr_popti:SetSize(232, 165)
    ipr_popti:SetPos(ipr_vcenter - (ipr_popti:GetWide() / 2), 90)
    ipr_popti.Paint = function(self, w, h)
        draw.RoundedBox(4, 0, 0, w, h, ipr.Settings.BackGround)
        draw.SimpleText(ipr.Data.Lang[ipr.Settings.SetLang].TSettings, ipr.Settings.Font, w / 2, 2, ipr.Settings.TColor["blanc"], TEXT_ALIGN_CENTER)
    end

    local ipr_prevert = vgui.Create("DImageButton", ipr_popti)
    ipr_prevert:SetSize(16, 16)
    ipr_prevert:SetPos(ipr_popti:GetWide() - ipr_prevert:GetWide() - 1, 3)
    ipr_prevert:SetImage("icon16/arrow_rotate_clockwise.png")
    ipr.Function.SetToolTip(ipr.Data.Lang[ipr.Settings.SetLang].RevertData, ipr_prevert, true)
    ipr_prevert.Paint = nil
    ipr_prevert.DoClick = function()
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

    local ipr_checkboxstate = {[true] = {Icon = "icon16/lorry_flatbed.png", PoH = 2}, [false] = {Icon = "icon16/lorry.png", PoH = 4}}

    local ipr_psuncheck = vgui.Create("DImageButton", ipr_popti)
    ipr_psuncheck:SetSize(16, 16)
    ipr_psuncheck:SetPos(6, ipr_checkboxstate[ipr_schecked].PoH)
    ipr_psuncheck:SetImage(ipr_checkboxstate[ipr_schecked].Icon)
    ipr_psuncheck.Paint = nil
    ipr.Function.SetToolTip(ipr.Data.Lang[ipr.Settings.SetLang].CheckUncheckAll, ipr_psuncheck, true)
    ipr_psuncheck.DoClick = function()
        local ipr_defaultconvars = #ipr.Data.Default.convars
        ipr_schecked = not ipr_schecked

        for i = 1, #ipr.Settings.Vgui.CheckBox do
            if (i > ipr_defaultconvars) then
                break
            end

            ipr.Settings.Vgui.CheckBox[i].Vgui:SetValue(ipr_schecked)
        end

        surface.PlaySound("buttons/lever7.wav")
        ipr_psuncheck:SetImage(ipr_checkboxstate[ipr_schecked].Icon)
        ipr_psuncheck:SetY(ipr_checkboxstate[ipr_schecked].PoH)
    end

    local ipr_OverrideScroll = function(frame)
        frame.btnUp:SetSize(0, 0)
        frame.btnDown:SetSize(0, 0)

        frame.PerformLayout = function(self)
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

        frame.Paint = function(self, w, h)
            draw.RoundedBox(5, 0, 0, w, h, ColorAlpha(color_black, 65))
        end
        frame.btnGrip.Paint = function(self, w, h)
            draw.RoundedBox(5, 0, 0, w, h, ipr.Settings.TColor["bleu"])
        end
    end

    local ipr_pscrollopti = vgui.Create("DScrollPanel", ipr_popti)
    ipr_pscrollopti:Dock(FILL)
    ipr_pscrollopti:DockMargin(5, 22, 0, 5)
    local ipr_pbar = ipr_pscrollopti:GetVBar()
    ipr_pbar:SetWide(11)
    ipr_OverrideScroll(ipr_pbar)

    for i = 1, #ipr.Data.Default.convars do
        local ipr_topti = ipr.Data.Default.convars[i]

        local ipr_createcheckbox = ipr.Function.DCheckBoxLabel(ipr_pscrollopti, ipr_topti)
        ipr_createcheckbox:SetValue(ipr.Function.GetConvar(ipr_topti.Name))

        ipr.Function.SetToolTip(ipr_topti.Localization.ToolTip, ipr_createcheckbox)
        ipr.Function.SetConvar(ipr_topti.Name, ipr_topti.DefaultCheck, nil, true, true)

        ipr_createcheckbox.OnChange = function(self)
            ipr.Function.SetConvar(ipr_topti.Name, self:GetChecked())

            local ipr_convarscount = #ipr.Settings.SetConvars
            local ipr_tdata = ipr.Function.GetCopyData()
            local ipr_convarfind = false

            for i = 1, #ipr_tdata do
                local ipr_dataname = ipr_tdata[i].Name
                local ipr_datacheck = ipr_tdata[i].Checked

                for c = 1, ipr_convarscount do
                    if (ipr_dataname == ipr.Settings.SetConvars[c].Name) and (ipr_datacheck ~= ipr.Settings.SetConvars[c].Checked) then
                        ipr_convarfind = true
                        break
                    end
                end
            end
            ipr.Settings.Revert.Set = ipr_convarfind
        end

        ipr.Settings.Vgui.CheckBox[#ipr.Settings.Vgui.CheckBox + 1] = {Vgui = ipr_createcheckbox, Default = ipr_topti.DefaultCheck, Name = ipr_topti.Name, Paired = ipr_topti.Paired}
    end

    local ipr_pconfig = vgui.Create("DPanel", ipr_poptions)
    ipr_pconfig:SetSize(232, 165)
    ipr_pconfig:SetPos(ipr_vcenter - (ipr_pconfig:GetWide() / 2), 260)
    ipr_pconfig.Paint = function(self, w, h)
        draw.RoundedBox(4, 0, 0, w, h, ipr.Settings.BackGround)
        draw.SimpleText("Configuration :", ipr.Settings.Font, w / 2, 2, ipr.Settings.TColor["blanc"], TEXT_ALIGN_CENTER)
    end

    local ipr_pscrollConfig = vgui.Create("DScrollPanel", ipr_pconfig)
    ipr_pscrollConfig:Dock(FILL)
    ipr_pscrollConfig:DockMargin(5, 22, 0, 5)
    local ipr_sscrollvbarconfig = ipr_pscrollConfig:GetVBar()
    ipr_sscrollvbarconfig:SetWide(11)
    ipr_OverrideScroll(ipr_sscrollvbarconfig)

    for i = 1, #ipr.Data.Default.settings do
        local ipr_sconfigsettings = ipr.Data.Default.settings[i]
        local ipr_sconfigcheckbox, ipr_sconfigslider = ipr.Function.SettingsVgui[ipr_sconfigsettings.Vgui](ipr_pscrollConfig, ipr_sconfigsettings, ipr_HUD)

        ipr.Function.SetConvar(ipr_sconfigsettings.Name, ipr_sconfigsettings.DefaultCheck, nil, true)
        if (ipr_sconfigsettings.Localization.ToolTip) then
            ipr.Function.SetToolTip(ipr_sconfigsettings.Localization.ToolTip, ipr_sconfigcheckbox)
        end

        ipr.Settings.Vgui.CheckBox[#ipr.Settings.Vgui.CheckBox + 1] = {Vgui = ipr_sconfigcheckbox, Default = ipr_sconfigsettings.DefaultCheck, Name = ipr_sconfigsettings.Name, Paired = ipr_sconfigsettings.Paired}

        if (ipr_sconfigsettings.Paired) then
            ipr_sconfigslider:SetDisabled(not ipr.Function.GetConvar(ipr_sconfigsettings.Paired))
        end
    end

    local ipr_pmanage = vgui.Create("DPanel", ipr_poptions)
    ipr_pmanage:SetSize(150, 60)
    ipr_pmanage:SetPos(ipr_vcenter - (ipr_pmanage:GetWide() / 2), 25)
    ipr_pmanage.Paint = function(self, w, h)
        draw.RoundedBox(4, 0, 0, w, h, ipr.Settings.BackGround)
    end

    local ipr_pscrollmanage = vgui.Create("DScrollPanel", ipr_pmanage)
    ipr_pscrollmanage:Dock(FILL)
    ipr_pscrollmanage:DockMargin(0, 1, 0, 1)
    local ipr_mbar = ipr_pscrollmanage:GetVBar()
    ipr_mbar:SetWide(7)
    ipr_OverrideScroll(ipr_mbar)

    for i = 1, #ipr.Data.Default.buttons do
        local ipr_tmanage = ipr.Data.Default.buttons[i]

        local ipr_pmanagebt = vgui.Create("DPanel", ipr_pscrollmanage)
        ipr_pmanagebt:Dock(TOP)
        ipr_pmanagebt:DockMargin(4, 3, 4, 0)
        ipr_pmanagebt.Paint = nil

        local ipr_pmanagecreate = vgui.Create(ipr_tmanage.Vgui, ipr_pmanagebt)
        ipr_pmanagecreate:Dock(FILL)
        ipr_pmanagecreate:DockMargin(0, 1, 0, 1)
        ipr_pmanagecreate:SetText("")
        ipr_pmanagecreate:SetImage(ipr_tmanage.Icon)
        ipr.Function.SetToolTip(ipr_tmanage.Localization.ToolTip, ipr_pmanagecreate)

        if (ipr_tmanage.Convar) then
            ipr.Function.SetConvar(ipr_tmanage.Convar.Name, ipr_tmanage.Convar.DefaultCheck, nil, true)
        end

        local ipr_convarcolor = ipr.Settings.TColor["blanc"]
        ipr_pmanagecreate.Paint = function(self, w, h)
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
        ipr_pmanagecreate.DoClick = function()
            local ipr_readsound = ipr_tmanage.Sound(ipr)
            surface.PlaySound(ipr_readsound)
            
            ipr_tmanage.Function(ipr, ipr_tmanage)
        end
    end

    surface.PlaySound("buttons/button9.wav")
end

local function IprFpsBooster()
    if IsValid(ipr.Settings.Vgui.Primary) then
        return
    end

    local ipr_pframe, ipr_psize =  vgui.Create("DFrame"), {w = 300, h = 275}
    ipr_pframe:SetTitle("")
    ipr_pframe:SetSize(ipr_psize.w, ipr_psize.h)
    ipr_pframe:Center()
    ipr_pframe:MakePopup()
    ipr_pframe:ShowCloseButton(false)
    ipr_pframe:SetDraggable(true)
    ipr_pframe:SetAlpha(0)
    ipr_pframe:AlphaTo(255, 1, 0)
    ipr.Settings.Vgui.Primary = ipr_pframe

    ipr_pframe.Paint = function(self, w, h)
        if (self.Dragging) then
            if IsValid(ipr.Settings.Vgui.Secondary) then
                local ipr_wcentersecondary = self:GetX() + ipr_psize.w + 10
                local ipr_hcentersecondary = self:GetY() - (ipr.Settings.Vgui.Secondary:GetTall() / 2)
                ipr_hcentersecondary = ipr_hcentersecondary + (ipr_psize.h / 2)

                ipr.Settings.Vgui.Secondary:SetPos(ipr_wcentersecondary, ipr_hcentersecondary)
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

    local ipr_picon = vgui.Create("DPanel", ipr_pframe)
    ipr_picon:Dock(FILL)
    ipr_picon.Paint = function(self, w, h)
        surface.SetDrawColor(ipr.Settings.TColor["bleu"])
        surface.SetMaterial(ipr.Settings.IComputer)
        surface.DrawTexturedRect(-11, 4, 349, 235)

        local ipr_currentstate = ipr.Function.CurrentState()
        surface.SetDrawColor((ipr_currentstate) and ipr.Settings.TColor["vert"] or ipr.Settings.TColor["rouge"])
        surface.SetMaterial(ipr.Settings.IWrench)
        local ipr_loop = ipr_copy.Loop()
        ipr_copy.Draw(207, 125, 220, 220, ipr_loop, -25)
    end

    local ipr_pfps = vgui.Create("DButton", ipr_pframe)
    ipr_pfps:SetSize(110, 83)
    ipr_pfps:SetPos(ipr_psize.w / 2 - ipr_pfps:GetWide() / 2, ipr_psize.h / 2 - ipr_pfps:GetTall() / 2 - 13)
    ipr_pfps:SetText("")
    ipr_pfps.Paint = function(self, w, h)
        local ipr_fpscurrent, ipr_fpsmin, ipr_fpsmax, ipr_fpslow = ipr.Function.FpsCalculator()
        local ipr_centerfpshud = w / 2

        draw.SimpleText(ipr.Settings.Status.Name, ipr.Settings.Font, ipr_centerfpshud, 6, ipr.Settings.TColor["blanc"], TEXT_ALIGN_CENTER)

        local ipr_currentpos = ipr_centerfpshud + 10
        draw.SimpleText(ipr.Data.Lang[ipr.Settings.SetLang].FpsCurrent, ipr.Settings.Font, ipr_currentpos, 25, ipr.Settings.TColor["blanc"], TEXT_ALIGN_RIGHT)
        draw.SimpleText(ipr_fpscurrent, ipr.Settings.Font, ipr_currentpos + 5, 25, ipr.Function.ColorTransition(ipr_fpscurrent), TEXT_ALIGN_LEFT)

        ipr_currentpos = ipr_currentpos - 5
        draw.SimpleText(ipr.Settings.Fps.Max.Name, ipr.Settings.Font, ipr_currentpos, 40, ipr.Settings.TColor["blanc"], TEXT_ALIGN_RIGHT)
        draw.SimpleText(ipr_fpsmax, ipr.Settings.Font, ipr_currentpos + 5, 40, ipr.Function.ColorTransition(ipr_fpsmax), TEXT_ALIGN_LEFT)

        draw.SimpleText(ipr.Settings.Fps.Min.Name, ipr.Settings.Font, ipr_currentpos, 55, ipr.Settings.TColor["blanc"], TEXT_ALIGN_RIGHT)
        draw.SimpleText(ipr_fpsmin, ipr.Settings.Font, ipr_currentpos + 5, 55, ipr.Function.ColorTransition(ipr_fpsmin), TEXT_ALIGN_LEFT)

        ipr_currentpos = ipr_currentpos + 10
        draw.SimpleText(ipr.Settings.Fps.Low.Name, ipr.Settings.Font, ipr_currentpos, 70, ipr.Settings.TColor["blanc"], TEXT_ALIGN_RIGHT)
        draw.SimpleText(ipr_fpslow, ipr.Settings.Font, ipr_currentpos + 5, 70, ipr.Function.ColorTransition(ipr_fpslow), TEXT_ALIGN_LEFT)
    end
    ipr_pfps.DoClick = function()
        gui.OpenURL(ipr.Settings.ExternalLink)
    end

    local ipr_pclose = vgui.Create("DImageButton", ipr_pframe)
    ipr_pclose:SetSize(16, 16)
    ipr_pclose:SetPos(ipr_psize.w - ipr_pclose:GetWide() - 2, 2)
    ipr_pclose:SetImage("icon16/cross.png")
    ipr_pclose.Paint = nil
    ipr_pclose.DoClick = function()
        ipr_FrameClose(ipr_pclose)
    end

    local ipr_penabled = vgui.Create("DButton", ipr_pframe)
    ipr_penabled:SetSize(110, 23)
    ipr_penabled:SetPos(5, ipr_psize.h - ipr_penabled:GetTall() - 4)
    ipr_penabled:SetText("")
    ipr_penabled.Paint = function(self, w, h)
        draw.RoundedBox(6, 0, 0, w, h, self:IsHovered() and ipr.Settings.TColor["bleuc"] or ipr.Settings.TColor["bleu"])
        draw.SimpleText(ipr.Data.Lang[ipr.Settings.SetLang].VEnabled, ipr.Settings.Font, w / 2 + 7, 3, ipr.Settings.TColor["blanc"], TEXT_ALIGN_CENTER)

        surface.SetMaterial(ipr.Settings.IEnabled)
        surface.SetDrawColor(color_white)
        surface.DrawTexturedRect(5, h / 2 - 7, 16, 16)
    end
    ipr_penabled.DoClick = function()
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
            ipr_FrameClose()
        end

        surface.PlaySound("buttons/combine_button7.wav")
    end

    local ipr_pdisabled = vgui.Create("DButton", ipr_pframe)
    ipr_pdisabled:SetSize(110, 23)
    ipr_pdisabled:SetPos(ipr_psize.w - ipr_pdisabled:GetWide() - 5, ipr_psize.h - ipr_pdisabled:GetTall() - 4)
    ipr_pdisabled:SetText("")
    ipr_pdisabled.Paint = function(self, w, h)
        draw.RoundedBox(6, 0, 0, w, h, self:IsHovered() and ipr.Settings.TColor["bleuc"] or ipr.Settings.TColor["bleu"])
        draw.SimpleText(ipr.Data.Lang[ipr.Settings.SetLang].VDisabled, ipr.Settings.Font, w / 2 + 7, 3, ipr.Settings.TColor["blanc"], TEXT_ALIGN_CENTER)

        surface.SetMaterial(ipr.Settings.IDisabled)
        surface.SetDrawColor(color_white)
        surface.DrawTexturedRect(4, h / 2 - 7, 16, 16)
    end
    ipr_pdisabled.DoClick = function()
        local ipr_convarsenabled = ipr.Function.Activate(false, true)
        if (ipr_convarsenabled) then
            ipr.Function.Activate(false)
            chat.AddText(ipr.Settings.TColor["rouge"], ipr.Settings.Script, ipr.Settings.TColor["blanc"], ipr.Data.Lang[ipr.Settings.SetLang].Optimization)
        else
            chat.AddText(ipr.Settings.TColor["rouge"], ipr.Settings.Script, ipr.Settings.TColor["blanc"], ipr.Data.Lang[ipr.Settings.SetLang].ADisabled)
        end

        local ipr_closefpsbooster = ipr.Function.GetConvar("AutoClose")
        if (ipr_closefpsbooster) then
            ipr_FrameClose()
        end

        surface.PlaySound("buttons/combine_button5.wav")
    end

    local ipr_presetfps = vgui.Create("DButton", ipr_pframe)
    ipr_presetfps:SetSize(152, 21)
    ipr_presetfps:SetPos(ipr_psize.w / 2 - ipr_presetfps:GetWide() / 2, 193)
    ipr_presetfps:SetText("")
    ipr.Function.SetToolTip(ipr.Data.Lang[ipr.Settings.SetLang].TReset, ipr_presetfps, true)
    ipr_presetfps.Paint = function(self, w, h)
        draw.RoundedBox(6, 0, 0, w, h, self:IsHovered() and ipr.Settings.TColor["bleuc"] or ipr.Settings.TColor["bleu"])
        draw.SimpleText("Reset FPS Max/Min", ipr.Settings.Font, w / 2 + 8, 2, ipr.Settings.TColor["blanc"], TEXT_ALIGN_CENTER)

        surface.SetMaterial(ipr.Settings.IResetFps)
        surface.SetDrawColor(color_white)
        surface.DrawTexturedRect(4, h / 2 - 7, 16, 16)
    end
    ipr_presetfps.DoClick = function()
        ipr.Function.ResetFps()
        surface.PlaySound("buttons/button9.wav")
    end

    local ipr_psettings = vgui.Create("DButton", ipr_pframe)
    ipr_psettings:SetSize(85, 21)
    ipr_psettings:SetPos(ipr_psize.w - ipr_psettings:GetWide() - 5, 37)
    ipr_psettings:SetText("")
    ipr.Function.SetToolTip(ipr.Data.Lang[ipr.Settings.SetLang].Options, ipr_psettings, true)
    ipr_psettings.Paint = function(self, w, h)
        local ipr_hover = self:IsHovered()

        draw.RoundedBox(6, 0, 0, w, h, (ipr_hover) and ipr.Settings.TColor["bleuc"] or ipr.Settings.TColor["bleu"])
        draw.SimpleText("Options ", ipr.Settings.Font, w / 2 + 9, 2, ipr.Settings.TColor["blanc"], TEXT_ALIGN_CENTER)

        surface.SetMaterial(ipr.Settings.IMatOptions)
        surface.SetDrawColor(ipr.Settings.TColor["blanc"])

        local ipr_protation = 0
        if (ipr_hover) then
            local ipr_systime = SysTime()
            ipr_protation = math.sin(ipr_systime * 80 * math.pi / 180) * 180
        end
        surface.DrawTexturedRectRotated(13, 11, 16, 16, ipr_protation)
    end
    ipr_psettings.DoClick = function()
        IprFpsBooster_Options(ipr_pframe)
    end

    local ipr_planguage, ipr_flagmat = vgui.Create("DComboBox", ipr_pframe)
    ipr_planguage:SetSize(85, 21)
    ipr_planguage:SetPos(5, 37)
    ipr_planguage:SetFont(ipr.Settings.Font)
    ipr_planguage:SetValue(ipr.Settings.SetLang)
    ipr_planguage:SetTextColor(ipr.Settings.TColor["blanc"])
    ipr_planguage:SetSortItems(false)

    local ipr_AddLangSort = function(index)
        local ipr_sortlang = {}
        
        for k, v in pairs(ipr.Data.Lang) do
            local ipr_selected = (index == k)
            ipr_sortlang[#ipr_sortlang + 1] = {Lang = k, Icon = (ipr_selected) and "icon16/bullet_add.png" or "materials/flags16/" ..v.Icon, Selected = (ipr_selected)}
        end
        
        ipr_flagmat = Material("materials/flags16/" ..ipr.Data.Lang[index].Icon, "noclamp")
        table.SortByMember(ipr_sortlang, "Selected", true)

        for i = 1, #ipr_sortlang do
            local ipr_choicevar = ipr_sortlang[i]
            local ipr_choicelang = ipr_choicevar.Lang
            local ipr_choiceicon = ipr_choicevar.Icon

            ipr_planguage:AddChoice(ipr.Data.Lang[ipr.Settings.SetLang].SelectLangue.. " " ..ipr_choicelang, ipr_choicelang, false, ipr_choiceicon)

            local ipr_aspacer = ipr_choicevar.Selected
            if (ipr_aspacer) then
                ipr_planguage:AddSpacer()
            end
        end
    end

    ipr_AddLangSort(ipr.Settings.SetLang)
    ipr_planguage:SetText("")

    ipr_planguage.Paint = function(self, w, h)
        draw.RoundedBox(6, 0, 0, w, h, self:IsHovered() and ipr.Settings.TColor["bleuc"] or ipr.Settings.TColor["bleu"])

        local ipr_tlang = ipr.Settings.SetLang
        surface.SetFont(ipr.Settings.Font)
        local ipr_ptwide, ipr_ptheight = surface.GetTextSize(ipr_tlang)

        local ipr_aligncentertext = w / 2 - ipr_ptwide / 2 + 2
        draw.SimpleText(ipr_tlang, ipr.Settings.Font, ipr_aligncentertext, 2, ipr.Settings.TColor["blanc"], TEXT_ALIGN_LEFT)

        surface.SetDrawColor(ColorAlpha(ipr.Settings.TColor["blanc"], 125))

        local ipr_alignleft = ipr_aligncentertext - 4
        ipr_alignleft = math.ceil(ipr_alignleft)
        surface.DrawLine(ipr_alignleft, h - ipr_ptheight + 4, ipr_alignleft, ipr_ptheight - 4)

        local ipr_alignright = ipr_aligncentertext + 5 + ipr_ptwide
        surface.DrawLine(ipr_alignright, h - ipr_ptheight + 4, ipr_alignright, ipr_ptheight - 4)

        surface.SetMaterial(ipr_flagmat)
        surface.SetDrawColor(color_white)
        surface.DrawTexturedRect(5, h / 2 - 5.5, 16, 11)
    end

    local ipr_OverrideLangPaint = function(frame)
        local ipr_fchild = frame:GetChildren()

        for i = 1, #ipr_fchild do
            local ipr_cpanel = ipr_fchild[i]
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

    ipr_OverrideLangPaint(ipr_planguage)

    ipr_planguage.OnMenuOpened = function(self)
        local ipr_planguagechild = self:GetChildren()
        ipr_OverrideLangPaint(self)

        for i = 1, #ipr_planguagechild do
            local ipr_plangmenu = ipr_planguagechild[i]
            if (ipr_plangmenu:GetName() == "DMenu") then
                ipr_plangmenu.Paint = function(p, w, h)
                    draw.RoundedBox(6, 0, 0, w, h, ipr.Settings.TColor["bleu"])
                end

                local ipr_planguagedmenu = ipr_plangmenu:GetChildren()
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
    ipr_planguage.OnSelect = function(self, index, value)
        local ipr_setlang = self.Data[index]

        self:Clear()
        self:SetValue(ipr_setlang)

        ipr_AddLangSort(ipr_setlang)
        self:SetText("")

        if (ipr_setlang ~= ipr.Settings.SetLang) then
            file.Write(ipr.Settings.Save.. "language.json", ipr_setlang)

            ipr.Settings.SetLang = ipr_setlang
            surface.PlaySound("common/stuck1.wav")
        end
    end

    ipr.Function.CopyData()
end

local ipr_InitPostPlayer = function()
    timer.Simple(5, function()
        if not IsValid(ipr.Settings.Vgui.Primary) then
            ipr.Function.CreateData()

            local ipr_forcedopen = ipr.Function.GetConvar("ForcedOpen")
            if (ipr_forcedopen) then
                IprFpsBooster()
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
            hook.Add("PostDrawHUD", "IprFpsBooster_HUD", ipr_HUD)
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

local ipr_cmds = ipr.Cmd
local ipr_length = #ipr_cmds
local ipr_func = nil
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
    IprFpsBooster()
end

hook.Add("ShutDown", "IprFpsBooster_ShutDown", ipr_PlayerShutDown)
hook.Add("OnScreenSizeChanged", "IprFpsBooster_OnScreen", ipr_OnScreenSize)
hook.Add("InitPostEntity", "IprFpsBooster_InitPlayer", ipr_InitPostPlayer)
hook.Add("OnPlayerChat", "IprFpsBooster_ChatCmds", ipr_ChatCmds)