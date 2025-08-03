// Script by Inj3
// Steam : https://steamcommunity.com/id/Inj3/
// Discord : Inj3
// General Public License v3.0
// https://github.com/Inj3-GT

local Ipr = include("function.lua")

local function Ipr_HUD()
    local Ipr_FpsCurrent, Ipr_FpsMin, Ipr_FpsMax, Ipr_FpsLow = Ipr.Function.FpsCalculator()
    local Ipr_HHeight = Ipr.Settings.Pos.h * Ipr.Function.GetConvar("FpsPosHeight") / 100
    local Ipr_HWide = Ipr.Settings.Pos.w * Ipr.Function.GetConvar("FpsPosWidth") / 100
    local Ipr_PlayerPing = LocalPlayer():Ping()

    local Ipr_HudFpsBooster = {
        {
            {Name = "FPS :", FColor = Ipr.Settings.TColor["blanc"]},
            {Name = Ipr_FpsCurrent, FColor = Ipr.Function.ColorTransition(Ipr_FpsCurrent)},
            {Name = "|", FColor = Ipr.Settings.TColor["blanc"]},
            {Name = Ipr.Settings.Fps.Min.Name, FColor = Ipr.Settings.TColor["blanc"]},
            {Name = Ipr_FpsMin, FColor = Ipr.Function.ColorTransition(Ipr_FpsMin)},
            {Name = "|", FColor = Ipr.Settings.TColor["blanc"]},
            {Name = Ipr.Settings.Fps.Max.Name, FColor = Ipr.Settings.TColor["blanc"]},
            {Name = Ipr_FpsMax, FColor = Ipr.Function.ColorTransition(Ipr_FpsMax)},
            {Name = "|", FColor = Ipr.Settings.TColor["blanc"]},
            {Name = Ipr.Settings.Fps.Low.Name, FColor = Ipr.Settings.TColor["blanc"]},
            {Name = Ipr_FpsLow, FColor = Ipr.Function.ColorTransition(Ipr_FpsLow)},

            Pos = {PWide = Ipr_HWide, PHeight = Ipr_HHeight},
        },

        {
            {Name = "Map :", FColor = Ipr.Settings.TColor["blanc"]},
            {Name = Ipr.Settings.Map, FColor = Ipr.Settings.TColor["orangec"]},
            {Name = "|", FColor = Ipr.Settings.TColor["blanc"]},
            {Name = "Ping :", FColor = Ipr.Settings.TColor["blanc"]},
            {Name = Ipr_PlayerPing, FColor = (Ipr_PlayerPing > 100) and Ipr.Settings.TColor["rouge"] or Ipr.Settings.TColor["vert"]},

            Pos = {PWide = Ipr_HWide - 1, PHeight = Ipr_HHeight + 20},
        },
    }

    Ipr.Function.DrawMultipleTextAligned(Ipr_HudFpsBooster)
end

local function Ipr_PanelShutdown(panel, bool)
    if IsValid(panel) then
        surface.PlaySound("common/wpn_select.wav")

        if (bool) then
            panel:Remove()
            return
        end
    end

    for _, v in pairs(Ipr.Settings.Vgui) do
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

local function Ipr_FpsBooster_Options(primary)
    local Ipr_SSize = {w = 240, h = 450}

    Ipr.Settings.Vgui.Secondary = vgui.Create("DFrame")
    Ipr.Settings.Vgui.Secondary:SetTitle("")
    Ipr.Settings.Vgui.Secondary:SetSize(Ipr_SSize.w, Ipr_SSize.h)
    Ipr.Settings.Vgui.Secondary:MakePopup()
    Ipr.Settings.Vgui.Secondary:ShowCloseButton(false)
    Ipr.Settings.Vgui.Secondary:SetDraggable(true)

    if IsValid(primary) then
        local function Ipr_MovedVgui()
            Ipr.Settings.Vgui.Secondary:AlphaTo(255, 1.5, 0)

            local Ipr_CenterSecondaryH = primary:GetY() - (Ipr_SSize.h / 2)
            local Ipr_FirstPosW = primary:GetX() + primary:GetWide()
            Ipr.Settings.Vgui.Secondary:SetPos(Ipr_FirstPosW, Ipr_CenterSecondaryH)

            Ipr_CenterSecondaryH = Ipr_CenterSecondaryH + (primary:GetTall() / 2)
            Ipr.Settings.Vgui.Secondary:MoveTo(Ipr_FirstPosW, Ipr_CenterSecondaryH, 0.5, 0)

            local Ipr_CenterSecondaryW = Ipr_FirstPosW + 10
            Ipr.Settings.Vgui.Secondary:MoveTo(Ipr_CenterSecondaryW, Ipr_CenterSecondaryH, 0.5, 0.5)
        end
        Ipr.Settings.Vgui.Secondary:SetAlpha(0)

        if not primary.PMoved then
            primary:MoveTo(primary:GetX() - (Ipr_SSize.w / 2), primary:GetY(), 0.3, 0, -1, Ipr_MovedVgui)
        else
            Ipr_MovedVgui()
        end
    else
        Ipr.Settings.Vgui.Secondary:Center()
    end
    Ipr.Settings.Vgui.Secondary.Paint = function(self, w, h)
        if IsValid(primary) then
            if (primary.Dragging) and (self.m_AnimList) then
                self:Stop()
                self:SetAlpha(255)
            end
            if (self.Dragging) then
                local Ipr_CenterPrimaryW = self:GetX() - primary:GetWide() - 10
                local Ipr_CenterPrimaryH = self:GetY() + (Ipr_SSize.h / 2)
                Ipr_CenterPrimaryH = Ipr_CenterPrimaryH - (primary:GetTall() / 2)

                primary:SetPos(Ipr_CenterPrimaryW, Ipr_CenterPrimaryH)

                if not primary.PMoved then
                    primary.PMoved = true
                end
            end
        end

        Ipr.Function.RenderBlur(self, ColorAlpha(color_black, 170), 6)

        draw.RoundedBoxEx(6, 0, 0, w, 20, Ipr.Settings.TColor["bleu"], true, true, false, false)
        draw.SimpleText(Ipr.Data.Lang[Ipr.Settings.SetLang].NOptions, Ipr.Settings.Font, w / 2, 1, Ipr.Settings.TColor["blanc"], TEXT_ALIGN_CENTER)

        local Ipr_FpsLimit = math.Round(Ipr.Function.InfoNum("fps_max"))
        Ipr_FpsLimit = (Ipr_FpsLimit > 1000) and 1000 or Ipr_FpsLimit

        draw.SimpleText(Ipr.Data.Lang[Ipr.Settings.SetLang].FPSLimit, Ipr.Settings.Font, 5, h - 19, Ipr.Settings.TColor["blanc"], TEXT_ALIGN_LEFT)
        draw.SimpleText(Ipr_FpsLimit, Ipr.Settings.Font, 67, h - 19, Ipr.Function.ColorTransition(Ipr_FpsLimit), TEXT_ALIGN_LEFT)

        local Ipr_SysTimeColor = SysTime() * 1.5
        local Ipr_R = math.sin(Ipr_SysTimeColor) * 255
        local Ipr_G = math.sin(Ipr_SysTimeColor + 2) * 255
        local Ipr_B = math.sin(Ipr_SysTimeColor + 4) * 255

        draw.SimpleText("v" ..Ipr_Fps_Booster.Version.. " by", Ipr.Settings.Font, w - 29, h - 19, Ipr.Settings.TColor["blanc"], TEXT_ALIGN_RIGHT)
        draw.SimpleText(Ipr_Fps_Booster.Developer, Ipr.Settings.Font, w - 5, h - 19, Color(Ipr_R, Ipr_G, Ipr_B), TEXT_ALIGN_RIGHT)
    end

    local Ipr_CenterVgui = Ipr_SSize.w / 2
    local Ipr_SChecked = Ipr.Function.IsChecked()
    Ipr.Settings.Vgui.CheckBox = {}

    local Ipr_SClose = vgui.Create("DImageButton", Ipr.Settings.Vgui.Secondary)
    Ipr_SClose:SetSize(16, 16)
    Ipr_SClose:SetPos(Ipr_SSize.w - Ipr_SClose:GetWide() - 2, 2)
    Ipr_SClose:SetImage("icon16/cross.png")
    Ipr_SClose.Paint = nil
    Ipr_SClose.DoClick = function()
        Ipr_PanelShutdown(Ipr.Settings.Vgui.Secondary, true)

        timer.Simple(0.3, function()
            if IsValid(primary) and not primary.PMoved then
                primary:MoveTo(Ipr.Settings.Pos.w / 2 - primary:GetWide() / 2, Ipr.Settings.Pos.h / 2 - primary:GetTall() / 2, 0.3, 0)
            end
        end)
    end

    local Ipr_SOpti = vgui.Create("DPanel", Ipr.Settings.Vgui.Secondary)
    Ipr_SOpti:SetSize(232, 165)
    Ipr_SOpti:SetPos(Ipr_CenterVgui - (Ipr_SOpti:GetWide() / 2), 90)
    Ipr_SOpti.Paint = function(self, w, h)
        draw.RoundedBox(4, 0, 0, w, h, Ipr.Settings.BackGround)
        draw.SimpleText(Ipr.Data.Lang[Ipr.Settings.SetLang].TSettings, Ipr.Settings.Font, w / 2, 2, Ipr.Settings.TColor["blanc"], TEXT_ALIGN_CENTER)
    end

    local Ipr_Revert = vgui.Create("DImageButton", Ipr_SOpti)
    Ipr_Revert:SetSize(16, 16)
    Ipr_Revert:SetPos(Ipr_SOpti:GetWide() - Ipr_Revert:GetWide() - 1, 3)
    Ipr_Revert:SetImage("icon16/arrow_rotate_clockwise.png")
    Ipr.Function.SetToolTip(Ipr.Data.Lang[Ipr.Settings.SetLang].RevertData, Ipr_Revert, true)
    Ipr_Revert.Paint = nil
    Ipr_Revert.DoClick = function()
        local Ipr_CopyFind = false
        local Ipr_TableData = Ipr.Function.GetCopyData()

        for i = 1, #Ipr.Settings.SetConvars do
            local Ipr_ConvarList = Ipr.Settings.SetConvars[i]
            local Ipr_ConvarName = Ipr_ConvarList.Name
            local Ipr_ConvarCheck = Ipr_ConvarList.Checked

            for t = 1, #Ipr_TableData do
                local Ipr_CopyList = Ipr_TableData[t]
                local Ipr_CopyName = Ipr_CopyList.Name
                local Ipr_CopyDefault = Ipr_CopyList.Checked

                if (Ipr_ConvarName == Ipr_CopyName and Ipr_ConvarCheck ~= Ipr_CopyDefault) then
                    for c = 1, #Ipr.Settings.Vgui.CheckBox do
                        local Ipr_CheckList = Ipr.Settings.Vgui.CheckBox[c]
                        local Ipr_CheckName = Ipr_CheckList.Name

                        if (Ipr_CopyName == Ipr_CheckName) then
                            Ipr_CheckList.Vgui:SetValue(Ipr_CopyDefault)
                            Ipr_CopyFind = true
                            break
                        end
                    end
                    break
                end
            end
        end

        surface.PlaySound((Ipr_CopyFind) and "friends/friend_online.wav" or "buttons/button18.wav")
        chat.AddText(Ipr.Settings.TColor["rouge"], Ipr.Settings.Script, Ipr.Settings.TColor["blanc"], (Ipr_CopyFind) and Ipr.Data.Lang[Ipr.Settings.SetLang].RevertDataApply or Ipr.Data.Lang[Ipr.Settings.SetLang].RevertDataCancel)
    end

    local Ipr_CheckboxState = {[true] = {Icon = "icon16/lorry_flatbed.png", PoH = 2}, [false] = {Icon = "icon16/lorry.png", PoH = 4}}
    local Ipr_SUncheck = vgui.Create("DImageButton", Ipr_SOpti)
    Ipr_SUncheck:SetSize(16, 16)
    Ipr_SUncheck:SetPos(6, Ipr_CheckboxState[Ipr_SChecked].PoH)
    Ipr_SUncheck:SetImage(Ipr_CheckboxState[Ipr_SChecked].Icon)
    Ipr_SUncheck.Paint = nil
    Ipr.Function.SetToolTip(Ipr.Data.Lang[Ipr.Settings.SetLang].CheckUncheckAll, Ipr_SUncheck, true)
    Ipr_SUncheck.DoClick = function()
        local Ipr_Defaultconvars = #Ipr.Data.Default.convars
        Ipr_SChecked = not Ipr_SChecked

        for i = 1, #Ipr.Settings.Vgui.CheckBox do
            if (i > Ipr_Defaultconvars) then
                break
            end

            Ipr.Settings.Vgui.CheckBox[i].Vgui:SetValue(Ipr_SChecked)
        end

        surface.PlaySound("buttons/lever7.wav")
        Ipr_SUncheck:SetImage(Ipr_CheckboxState[Ipr_SChecked].Icon)
        Ipr_SUncheck:SetY(Ipr_CheckboxState[Ipr_SChecked].PoH)
    end

    local function Ipr_SScrollPaint(panel)
        panel.btnUp:SetSize(0, 0)
        panel.btnDown:SetSize(0, 0)

        panel.PerformLayout = function(self)
            local Ipr_Wide = self:GetWide()
            local Ipr_Tall = self:GetTall()

            local Ipr_Scroll = self:GetScroll() / self.CanvasSize
            local Ipr_Bar = math.max(self:BarScale() *  Ipr_Tall, 10)

            local Ipr_BarTall = Ipr_Tall - Ipr_Bar
            Ipr_BarTall = Ipr_BarTall + 1

            Ipr_Scroll = Ipr_Scroll * Ipr_BarTall

            self.btnGrip:SetPos(0, Ipr_Scroll)
            self.btnGrip:SetSize(Ipr_Wide, Ipr_Bar)
        end

        panel.Paint = function(self, w, h)
            draw.RoundedBox(5, 0, 0, w, h, ColorAlpha(color_black, 65))
        end
        panel.btnGrip.Paint = function(self, w, h)
            draw.RoundedBox(5, 0, 0, w, h, Ipr.Settings.TColor["bleu"])
        end
    end

    local Ipr_SScrollOpti = vgui.Create("DScrollPanel", Ipr_SOpti)
    Ipr_SScrollOpti:Dock(FILL)
    Ipr_SScrollOpti:DockMargin(5, 22, 0, 5)
    local Ipr_SScrollVbarOpti = Ipr_SScrollOpti:GetVBar()
    Ipr_SScrollVbarOpti:SetWide(11)
    Ipr_SScrollPaint(Ipr_SScrollVbarOpti)

    for i = 1, #Ipr.Data.Default.convars do
        local Ipr_SOptiTbl = Ipr.Data.Default.convars[i]

        local Ipr_CreateCheckBox = Ipr.Function.DCheckBoxLabel(Ipr_SScrollOpti, Ipr_SOptiTbl)
        Ipr_CreateCheckBox:SetValue(Ipr.Function.GetConvar(Ipr_SOptiTbl.Name))

        Ipr.Function.SetToolTip(Ipr_SOptiTbl.Localization.ToolTip, Ipr_CreateCheckBox)
        Ipr.Function.SetConvar(Ipr_SOptiTbl.Name, Ipr_SOptiTbl.DefaultCheck, nil, true, true)

        Ipr_CreateCheckBox.OnChange = function(self)
            Ipr.Function.SetConvar(Ipr_SOptiTbl.Name, self:GetChecked())

            local Ipr_ConvarsCount = #Ipr.Settings.SetConvars
            local Ipr_TableData = Ipr.Function.GetCopyData()
            local Ipr_ConvarFind = false

            for i = 1, #Ipr_TableData do
                local Ipr_DataName = Ipr_TableData[i].Name
                local Ipr_DataCheck = Ipr_TableData[i].Checked

                for c = 1, Ipr_ConvarsCount do
                    if (Ipr_DataName == Ipr.Settings.SetConvars[c].Name) and (Ipr_DataCheck ~= Ipr.Settings.SetConvars[c].Checked) then
                        Ipr_ConvarFind = true
                        break
                    end
                end
            end
            Ipr.Settings.Revert.Set = Ipr_ConvarFind
        end

        Ipr.Settings.Vgui.CheckBox[#Ipr.Settings.Vgui.CheckBox + 1] = {Vgui = Ipr_CreateCheckBox, Default = Ipr_SOptiTbl.DefaultCheck, Name = Ipr_SOptiTbl.Name, Paired = Ipr_SOptiTbl.Paired}
    end

    local Ipr_SConfig = vgui.Create("DPanel", Ipr.Settings.Vgui.Secondary)
    Ipr_SConfig:SetSize(232, 165)
    Ipr_SConfig:SetPos(Ipr_CenterVgui - (Ipr_SConfig:GetWide() / 2), 260)
    Ipr_SConfig.Paint = function(self, w, h)
        draw.RoundedBox(4, 0, 0, w, h, Ipr.Settings.BackGround)
        draw.SimpleText("Configuration :", Ipr.Settings.Font, w / 2, 2, Ipr.Settings.TColor["blanc"], TEXT_ALIGN_CENTER)
    end

    local Ipr_SScrollConfig = vgui.Create("DScrollPanel", Ipr_SConfig)
    Ipr_SScrollConfig:Dock(FILL)
    Ipr_SScrollConfig:DockMargin(5, 22, 0, 5)
    local Ipr_SScrollVbarConfig = Ipr_SScrollConfig:GetVBar()
    Ipr_SScrollVbarConfig:SetWide(11)
    Ipr_SScrollPaint(Ipr_SScrollVbarConfig)

    for i = 1, #Ipr.Data.Default.settings do
        local Ipr_SConfigSettings = Ipr.Data.Default.settings[i]
        local Ipr_SConfigCheckBox, Ipr_SConfigSlider = Ipr.Function.SettingsVgui[Ipr_SConfigSettings.Vgui](Ipr_SScrollConfig, Ipr_SConfigSettings, Ipr_HUD)

        Ipr.Function.SetConvar(Ipr_SConfigSettings.Name, Ipr_SConfigSettings.DefaultCheck, nil, true)
        if (Ipr_SConfigSettings.Localization.ToolTip) then
            Ipr.Function.SetToolTip(Ipr_SConfigSettings.Localization.ToolTip, Ipr_SConfigCheckBox)
        end

        Ipr.Settings.Vgui.CheckBox[#Ipr.Settings.Vgui.CheckBox + 1] = {Vgui = Ipr_SConfigCheckBox, Default = Ipr_SConfigSettings.DefaultCheck, Name = Ipr_SConfigSettings.Name, Paired = Ipr_SConfigSettings.Paired}

        if (Ipr_SConfigSettings.Paired) then
            Ipr_SConfigSlider:SetDisabled(not Ipr.Function.GetConvar(Ipr_SConfigSettings.Paired))
        end
    end

    local Ipr_SManage = vgui.Create("DPanel", Ipr.Settings.Vgui.Secondary)
    Ipr_SManage:SetSize(150, 60)
    Ipr_SManage:SetPos(Ipr_CenterVgui - (Ipr_SManage:GetWide() / 2), 25)
    Ipr_SManage.Paint = function(self, w, h)
        draw.RoundedBox(4, 0, 0, w, h, Ipr.Settings.BackGround)
    end

    local Ipr_SScrollManage = vgui.Create("DScrollPanel", Ipr_SManage)
    Ipr_SScrollManage:Dock(FILL)
    Ipr_SScrollManage:DockMargin(0, 1, 0, 1)
    local Ipr_SScrollVbarManage = Ipr_SScrollManage:GetVBar()
    Ipr_SScrollVbarManage:SetWide(7)
    Ipr_SScrollPaint(Ipr_SScrollVbarManage)

    for i = 1, #Ipr.Data.Default.buttons do
        local Ipr_SManageTbl = Ipr.Data.Default.buttons[i]

        local Ipr_SManagePanel = vgui.Create("DPanel", Ipr_SScrollManage)
        Ipr_SManagePanel:Dock(TOP)
        Ipr_SManagePanel:DockMargin(4, 3, 4, 0)
        Ipr_SManagePanel.Paint = nil

        local Ipr_SManageCreate = vgui.Create(Ipr_SManageTbl.Vgui, Ipr_SManagePanel)
        Ipr_SManageCreate:Dock(FILL)
        Ipr_SManageCreate:DockMargin(0, 1, 0, 1)
        Ipr_SManageCreate:SetText("")
        Ipr_SManageCreate:SetImage(Ipr_SManageTbl.Icon)
        Ipr.Function.SetToolTip(Ipr_SManageTbl.Localization.ToolTip, Ipr_SManageCreate)

        if (Ipr_SManageTbl.Convar) then
            Ipr.Function.SetConvar(Ipr_SManageTbl.Convar.Name, Ipr_SManageTbl.Convar.DefaultCheck, nil, true)
        end

        local Ipr_ConvarColor = Ipr.Settings.TColor["blanc"]
        Ipr_SManageCreate.Paint = function(self, w, h)
            local Ipr_Hovered = self:IsHovered()
            if (Ipr_SManageTbl.DrawLine) then
                if (Ipr_SManageTbl.Convar) then
                    draw.RoundedBoxEx(6, 0, 0, w, h, (Ipr_Hovered) and Ipr.Settings.TColor["bleuc"] or Ipr.Settings.TColor["bleu"], true, true, false, false)

                    local Ipr_StartupDelay = timer.Exists(Ipr.Settings.StartupLaunch.Name)
                    Ipr_ConvarColor = (Ipr_StartupDelay) and Ipr.Settings.TColor["orange"] or Ipr.Function.GetConvar(Ipr_SManageTbl.Convar.Name) and Ipr.Settings.TColor["vert"] or Ipr.Settings.TColor["rouge"]
                    draw.RoundedBox(0, 0, h- 1, w, h, Ipr_ConvarColor)
                else
                    if (Ipr.Settings.Revert.Set) then
                        local Ipr_SysTimeColor = SysTime()
                        local Ipr_ColorRG = math.abs(math.sin(Ipr_SysTimeColor * 2.5) * 255)

                        draw.RoundedBoxEx(6, 0, 0, w, h, (Ipr_Hovered) and Ipr.Settings.TColor["bleuc"] or Ipr.Settings.TColor["bleu"], true, true, false, false)
                        draw.RoundedBox(1, 0, h- 1, w, h, Color(Ipr_ColorRG, Ipr_ColorRG, 0))
                    else
                        draw.RoundedBox(6, 0, 0, w, h, (Ipr_Hovered) and Ipr.Settings.TColor["bleuc"] or Ipr.Settings.TColor["bleu"])
                    end
                end
            else
                draw.RoundedBox(6, 0, 0, w, h, (Ipr_Hovered) and Ipr.Settings.TColor["gvert_"] or Ipr.Settings.TColor["gvert"])
            end
            surface.SetFont(Ipr.Settings.Font)
            local Ipr_TButton = Ipr.Data.Lang[Ipr.Settings.SetLang][Ipr_SManageTbl.Localization.Text]
            local Ipr_PTWide, Ipr_PTHeight = surface.GetTextSize(Ipr_TButton)

            draw.SimpleText(Ipr_TButton, Ipr.Settings.Font, w / 2 - Ipr_PTWide / 2 + 7, h / 2 - Ipr_PTHeight /  2, Ipr.Settings.TColor["blanc"], TEXT_ALIGN_LEFT)
        end
        Ipr_SManageCreate.DoClick = function()
            local Ipr_ReadSound = Ipr_SManageTbl.Sound(Ipr)
            surface.PlaySound(Ipr_ReadSound)
            
            Ipr_SManageTbl.Function(Ipr, Ipr_SManageTbl)
        end
    end
end

local function Ipr_FpsBooster()
    if IsValid(Ipr.Settings.Vgui.Primary) then
        return
    end

    local Ipr_PSize = {w = 300, h = 267}

    Ipr.Settings.Vgui.Primary = vgui.Create("DFrame")
    Ipr.Settings.Vgui.Primary:SetTitle("")
    Ipr.Settings.Vgui.Primary:SetSize(Ipr_PSize.w, Ipr_PSize.h)
    Ipr.Settings.Vgui.Primary:Center()
    Ipr.Settings.Vgui.Primary:MakePopup()
    Ipr.Settings.Vgui.Primary:SetMouseInputEnabled(false)

    timer.Simple(0.01, function()
        if not IsValid(Ipr.Settings.Vgui.Primary) then
            return
        end

        input.SetCursorPos(Ipr.Settings.Vgui.Primary:GetX() + (Ipr_PSize.w / 2), Ipr.Settings.Vgui.Primary:GetY() + (Ipr_PSize.h - 50))
        Ipr.Settings.Vgui.Primary:SetMouseInputEnabled(true)
    end)

    Ipr.Settings.Vgui.Primary:ShowCloseButton(false)
    Ipr.Settings.Vgui.Primary:SetDraggable(true)

    Ipr.Settings.Vgui.Primary:SetAlpha(0)
    Ipr.Settings.Vgui.Primary:AlphaTo(255, 1, 0)

    Ipr.Settings.Vgui.Primary.Paint = function(self, w, h)
        if (self.Dragging) then
            if IsValid(Ipr.Settings.Vgui.Secondary) then
                local Ipr_CenterSecondaryW = self:GetX() + Ipr_PSize.w + 10
                local Ipr_CenterSecondaryH = self:GetY() - (Ipr.Settings.Vgui.Secondary:GetTall() / 2)
                Ipr_CenterSecondaryH = Ipr_CenterSecondaryH + (Ipr_PSize.h / 2)

                Ipr.Settings.Vgui.Secondary:SetPos(Ipr_CenterSecondaryW, Ipr_CenterSecondaryH)
            end

            if not self.PMoved then
                self.PMoved = true
            end
        end

        Ipr.Function.RenderBlur(self, ColorAlpha(color_black, 170), 6)

        draw.RoundedBoxEx(6, 0, 0, w, 33, Ipr.Settings.TColor["bleu"], true, true, false, false)
        draw.SimpleText(Ipr.Data.Lang[Ipr.Settings.SetLang].TEnabled,Ipr.Settings.Font,w / 2, 1, Ipr.Settings.TColor["blanc"], TEXT_ALIGN_CENTER)

        local Ipr_CurrentState = Ipr.Function.CurrentState()
        local Ipr_TCurrentStatus = (Ipr_CurrentState) and "On (Boost)" or "Off"
        local ipr_TCurrentColor = (Ipr_CurrentState) and (Ipr.Settings.Revert.Set) and Ipr.Settings.TColor["orange"] or (Ipr_CurrentState) and Ipr.Settings.TColor["vert"] or Ipr.Settings.TColor["rouge"]

        draw.SimpleText("FPS :",Ipr.Settings.Font, (Ipr_CurrentState) and w / 2 - 25 or w / 2 -10, 16, Ipr.Settings.TColor["blanc"], TEXT_ALIGN_CENTER)
        draw.SimpleText(Ipr_TCurrentStatus, Ipr.Settings.Font, (Ipr_CurrentState) and w / 2 + 22 or w / 2 + 18, 16, ipr_TCurrentColor, TEXT_ALIGN_CENTER)
    end

    local Ipr_Rotate = {start = 10, s_end = 35, step = 5}
    local Ipr_Copy = table.Copy(Ipr_Rotate)

    Ipr_Copy.NextStep = 0.2
    Ipr_Copy.Update = 0

    Ipr_Copy.Loop = function()
        local Ipr_SysTime = SysTime()

        if (Ipr_SysTime > Ipr_Copy.Update) then
            for i = Ipr_Copy.start, Ipr_Copy.s_end, Ipr_Copy.step do
                Ipr_Copy.start = i + Ipr_Copy.step

                if (i == Ipr_Copy.s_end) then
                    local Ipr_min = (Ipr_Copy.step < 0)

                    Ipr_Copy.start = Ipr_min and Ipr_Rotate.start or Ipr_Copy.s_end
                    Ipr_Copy.s_end = Ipr_min and Ipr_Rotate.s_end or Ipr_Rotate.start
                    Ipr_Copy.step = Ipr_min and Ipr_Rotate.step or -Ipr_Rotate.step
                end
                break
            end
            Ipr_Copy.Update = Ipr_SysTime + Ipr_Copy.NextStep
        end

        return Ipr_Copy.start
    end

    Ipr_Copy.Draw = function(x, y, w, h, rotate, x0)
        local Ipr_Rad = math.rad(rotate)
        local Ipr_Cos, Ipr_Sin = math.cos(Ipr_Rad), math.sin(Ipr_Rad)
        local Ipr_Newx = Ipr_Sin - x0 * Ipr_Cos
        local Ipr_NewY = Ipr_Cos + x0 * Ipr_Sin

        surface.DrawTexturedRectRotated(x + Ipr_Newx, y + Ipr_NewY, w, h, rotate)
    end

    local Ipr_PIcon = vgui.Create("DPanel", Ipr.Settings.Vgui.Primary)
    Ipr_PIcon:Dock(FILL)
    Ipr_PIcon.Paint = function(self, w, h)
        surface.SetDrawColor(Ipr.Settings.TColor["bleu"])
        surface.SetMaterial(Ipr.Settings.IComputer)
        surface.DrawTexturedRect(-11, 0, 349, 235)

        local Ipr_CurrentState = Ipr.Function.CurrentState()
        surface.SetDrawColor((Ipr_CurrentState) and Ipr.Settings.TColor["vert"] or Ipr.Settings.TColor["rouge"])
        surface.SetMaterial(Ipr.Settings.IWrench)
        local Ipr_Loop = Ipr_Copy.Loop()
        Ipr_Copy.Draw(207, 120, 220, 220, Ipr_Loop, -25)
    end

    local Ipr_PFps = vgui.Create("DButton", Ipr.Settings.Vgui.Primary)
    Ipr_PFps:SetSize(110, 83)
    Ipr_PFps:SetPos(Ipr_PSize.w / 2 - Ipr_PFps:GetWide() / 2, Ipr_PSize.h / 2 - Ipr_PFps:GetTall() / 2 - 13)
    Ipr_PFps:SetText("")
    Ipr_PFps.Paint = function(self, w, h)
        local Ipr_FpsCurrent, Ipr_FpsMin, Ipr_FpsMax, Ipr_FpsLow = Ipr.Function.FpsCalculator()
        local Ipr_CenterFpsHud = w / 2

        draw.SimpleText(Ipr.Settings.Status.Name, Ipr.Settings.Font, Ipr_CenterFpsHud, 6, Ipr.Settings.TColor["blanc"], TEXT_ALIGN_CENTER)

        draw.SimpleText(Ipr.Data.Lang[Ipr.Settings.SetLang].FpsCurrent, Ipr.Settings.Font, Ipr_CenterFpsHud + 10, 25, Ipr.Settings.TColor["blanc"], TEXT_ALIGN_RIGHT)
        draw.SimpleText(Ipr_FpsCurrent, Ipr.Settings.Font, Ipr_CenterFpsHud + 15, 25, Ipr.Function.ColorTransition(Ipr_FpsCurrent), TEXT_ALIGN_LEFT)

        draw.SimpleText(Ipr.Settings.Fps.Max.Name, Ipr.Settings.Font, Ipr_CenterFpsHud + 10, 40, Ipr.Settings.TColor["blanc"], TEXT_ALIGN_RIGHT)
        draw.SimpleText(Ipr_FpsMax, Ipr.Settings.Font, Ipr_CenterFpsHud + 14, 40, Ipr.Function.ColorTransition(Ipr_FpsMax), TEXT_ALIGN_LEFT)

        draw.SimpleText(Ipr.Settings.Fps.Min.Name, Ipr.Settings.Font, Ipr_CenterFpsHud + 6, 55, Ipr.Settings.TColor["blanc"], TEXT_ALIGN_RIGHT)
        draw.SimpleText(Ipr_FpsMin, Ipr.Settings.Font, Ipr_CenterFpsHud + 10, 55, Ipr.Function.ColorTransition(Ipr_FpsMin), TEXT_ALIGN_LEFT)

        draw.SimpleText(Ipr.Settings.Fps.Low.Name, Ipr.Settings.Font, Ipr_CenterFpsHud + 15, 70, Ipr.Settings.TColor["blanc"], TEXT_ALIGN_RIGHT)
        draw.SimpleText(Ipr_FpsLow, Ipr.Settings.Font, Ipr_CenterFpsHud + 19, 70, Ipr.Function.ColorTransition(Ipr_FpsLow), TEXT_ALIGN_LEFT)
    end
    Ipr_PFps.DoClick = function()
        gui.OpenURL(Ipr.Settings.ExternalLink)
    end

    local Ipr_PClose = vgui.Create("DImageButton", Ipr.Settings.Vgui.Primary)
    Ipr_PClose:SetSize(16, 16)
    Ipr_PClose:SetPos(Ipr_PSize.w - Ipr_PClose:GetWide() - 2, 2)
    Ipr_PClose:SetImage("icon16/cross.png")
    Ipr_PClose.Paint = nil
    Ipr_PClose.DoClick = function()
        Ipr_PanelShutdown(Ipr_PClose)
    end

    local Ipr_PEnabled = vgui.Create("DButton", Ipr.Settings.Vgui.Primary)
    Ipr_PEnabled:SetSize(110, 23)
    Ipr_PEnabled:SetPos(5, Ipr_PSize.h - Ipr_PEnabled:GetTall() - 4)
    Ipr_PEnabled:SetText("")
    Ipr_PEnabled.Paint = function(self, w, h)
        draw.RoundedBox(6, 0, 0, w, h, self:IsHovered() and Ipr.Settings.TColor["bleuc"] or Ipr.Settings.TColor["bleu"])
        draw.SimpleText(Ipr.Data.Lang[Ipr.Settings.SetLang].VEnabled, Ipr.Settings.Font, w / 2 + 7, 3, Ipr.Settings.TColor["blanc"], TEXT_ALIGN_CENTER)

        surface.SetMaterial(Ipr.Settings.IEnabled)
        surface.SetDrawColor(color_white)
        surface.DrawTexturedRect(5, h / 2 - 7, 16, 16)
    end
    Ipr_PEnabled.DoClick = function()
        local Ipr_CheckBox = Ipr.Function.IsChecked()
        if not Ipr_CheckBox then
            return chat.AddText(Ipr.Settings.TColor["rouge"], Ipr.Settings.Script, Ipr.Settings.TColor["blanc"], Ipr.Data.Lang[Ipr.Settings.SetLang].CheckedBox)
        end

        local Ipr_ConvarsEnabled = Ipr.Function.Activate(true, true)
        if (Ipr_ConvarsEnabled) then
            Ipr.Function.Activate(true)
            Ipr.Function.ResetFps()

            chat.AddText(Ipr.Settings.TColor["rouge"], Ipr.Settings.Script, Ipr.Settings.TColor["blanc"], Ipr.Data.Lang[Ipr.Settings.SetLang].PreventCrash)
        else
            chat.AddText(Ipr.Settings.TColor["rouge"], Ipr.Settings.Script, Ipr.Settings.TColor["blanc"], Ipr.Data.Lang[Ipr.Settings.SetLang].AEnabled)
        end

        local Ipr_CloseFpsBooster = Ipr.Function.GetConvar("AutoClose")
        if (Ipr_CloseFpsBooster) then
            Ipr_PanelShutdown()
        end

        surface.PlaySound("buttons/combine_button7.wav")
    end

    local Ipr_PDisabled = vgui.Create("DButton", Ipr.Settings.Vgui.Primary)
    Ipr_PDisabled:SetSize(110, 23)
    Ipr_PDisabled:SetPos(Ipr_PSize.w - Ipr_PDisabled:GetWide() - 5, Ipr_PSize.h - Ipr_PDisabled:GetTall() - 4)
    Ipr_PDisabled:SetText("")
    Ipr_PDisabled.Paint = function(self, w, h)
        draw.RoundedBox(6, 0, 0, w, h, self:IsHovered() and Ipr.Settings.TColor["bleuc"] or Ipr.Settings.TColor["bleu"])
        draw.SimpleText(Ipr.Data.Lang[Ipr.Settings.SetLang].VDisabled, Ipr.Settings.Font, w / 2 + 7, 3, Ipr.Settings.TColor["blanc"], TEXT_ALIGN_CENTER)

        surface.SetMaterial(Ipr.Settings.IDisabled)
        surface.SetDrawColor(color_white)
        surface.DrawTexturedRect(4, h / 2 - 7, 16, 16)
    end
    Ipr_PDisabled.DoClick = function()
        local Ipr_ConvarsEnabled = Ipr.Function.Activate(false, true)
        if (Ipr_ConvarsEnabled) then
            Ipr.Function.Activate(false)
            Ipr.Function.ResetFps()

            chat.AddText(Ipr.Settings.TColor["rouge"], Ipr.Settings.Script, Ipr.Settings.TColor["blanc"], Ipr.Data.Lang[Ipr.Settings.SetLang].Optimization)
        else
            chat.AddText(Ipr.Settings.TColor["rouge"], Ipr.Settings.Script, Ipr.Settings.TColor["blanc"], Ipr.Data.Lang[Ipr.Settings.SetLang].ADisabled)
        end

        local Ipr_CloseFpsBooster = Ipr.Function.GetConvar("AutoClose")
        if (Ipr_CloseFpsBooster) then
            Ipr_PanelShutdown()
        end

        surface.PlaySound("buttons/combine_button5.wav")
    end

    local Ipr_PResetFps = vgui.Create("DButton", Ipr.Settings.Vgui.Primary)
    Ipr_PResetFps:SetSize(151, 21)
    Ipr_PResetFps:SetPos(Ipr_PSize.w / 2 - Ipr_PResetFps:GetWide() / 2, 189)
    Ipr_PResetFps:SetText("")
    Ipr.Function.SetToolTip(Ipr.Data.Lang[Ipr.Settings.SetLang].TReset, Ipr_PResetFps, true)
    Ipr_PResetFps.Paint = function(self, w, h)
        draw.RoundedBox(6, 0, 0, w, h, self:IsHovered() and Ipr.Settings.TColor["bleuc"] or Ipr.Settings.TColor["bleu"])
        draw.SimpleText("Reset FPS Max/Min", Ipr.Settings.Font, w / 2 + 7, 2, Ipr.Settings.TColor["blanc"], TEXT_ALIGN_CENTER)

        surface.SetMaterial(Ipr.Settings.IResetFps)
        surface.SetDrawColor(color_white)
        surface.DrawTexturedRect(4, h / 2 - 7, 16, 16)
    end
    Ipr_PResetFps.DoClick = function()
        Ipr.Function.ResetFps()
        surface.PlaySound("buttons/button9.wav")
    end

    local Ipr_PSettings = vgui.Create("DButton", Ipr.Settings.Vgui.Primary)
    Ipr_PSettings:SetSize(85, 21)
    Ipr_PSettings:SetPos(Ipr_PSize.w - Ipr_PSettings:GetWide() - 5, 37)
    Ipr_PSettings:SetText("")
    Ipr.Function.SetToolTip(Ipr.Data.Lang[Ipr.Settings.SetLang].Options, Ipr_PSettings, true)
    Ipr_PSettings.Paint = function(self, w, h)
        local Ipr_IsHovered = self:IsHovered()
        draw.RoundedBox(6, 0, 0, w, h, (Ipr_IsHovered) and Ipr.Settings.TColor["bleuc"] or Ipr.Settings.TColor["bleu"])

        draw.SimpleText("Options ", Ipr.Settings.Font, w / 2 + 9, 2, Ipr.Settings.TColor["blanc"], TEXT_ALIGN_CENTER)

        surface.SetMaterial(Ipr.Settings.IMatOptions)
        surface.SetDrawColor(Ipr.Settings.TColor["blanc"])

        local Ipr_PRotation = 0
        if (Ipr_IsHovered) then
            local Ipr_SysTime = SysTime()
            Ipr_PRotation = math.sin(Ipr_SysTime * 80 * math.pi / 180) * 180
        end
        surface.DrawTexturedRectRotated(13, 11, 16, 16, Ipr_PRotation)
    end
    Ipr_PSettings.DoClick = function()
        if IsValid(Ipr.Settings.Vgui.Secondary) then
            return
        end

        Ipr_FpsBooster_Options(Ipr.Settings.Vgui.Primary)
        surface.PlaySound("buttons/button9.wav")
    end

    local Ipr_PLanguage, Ipr_FlagMat = vgui.Create("DComboBox", Ipr.Settings.Vgui.Primary)
    Ipr_PLanguage:SetSize(85, 21)
    Ipr_PLanguage:SetPos(5, 37)
    Ipr_PLanguage:SetFont(Ipr.Settings.Font)
    Ipr_PLanguage:SetValue(Ipr.Settings.SetLang)
    Ipr_PLanguage:SetTextColor(Ipr.Settings.TColor["blanc"])
    Ipr_PLanguage:SetSortItems(false)

    local function Ipr_AddLangSort(index)
        local Ipr_SortLang = {}
        
        for k, v in pairs(Ipr.Data.Lang) do
            local Ipr_Selected = (index == k)
            Ipr_SortLang[#Ipr_SortLang + 1] = {Lang = k, Icon = (Ipr_Selected) and "icon16/bullet_add.png" or "materials/flags16/" ..v.Icon, Selected = (Ipr_Selected)}
        end
        
        Ipr_FlagMat = Material("materials/flags16/" ..Ipr.Data.Lang[index].Icon, "noclamp")
        table.SortByMember(Ipr_SortLang, "Selected", true)

        for i = 1, #Ipr_SortLang do
            local Ipr_ChoiceVar = Ipr_SortLang[i]
            local Ipr_ChoiceLang = Ipr_ChoiceVar.Lang
            local Ipr_ChoiceIcon = Ipr_ChoiceVar.Icon

            Ipr_PLanguage:AddChoice(Ipr.Data.Lang[Ipr.Settings.SetLang].SelectLangue.. " " ..Ipr_ChoiceLang, Ipr_ChoiceLang, false, Ipr_ChoiceIcon)

            local Ipr_Spacer = Ipr_ChoiceVar.Selected
            if (Ipr_Spacer) then
                Ipr_PLanguage:AddSpacer()
            end
        end
    end

    Ipr_AddLangSort(Ipr.Settings.SetLang)
    Ipr_PLanguage:SetText("")

    Ipr_PLanguage.Paint = function(self, w, h)
        draw.RoundedBox(6, 0, 0, w, h, self:IsHovered() and Ipr.Settings.TColor["bleuc"] or Ipr.Settings.TColor["bleu"])

        local Ipr_TLang = Ipr.Settings.SetLang
        surface.SetFont(Ipr.Settings.Font)
        local Ipr_PTWide, Ipr_PTHeight = surface.GetTextSize(Ipr_TLang)

        local Ipr_AlignCenterText = w / 2 - Ipr_PTWide / 2 + 2
        draw.SimpleText(Ipr_TLang, Ipr.Settings.Font, Ipr_AlignCenterText, 2, Ipr.Settings.TColor["blanc"], TEXT_ALIGN_LEFT)

        surface.SetDrawColor(ColorAlpha(Ipr.Settings.TColor["blanc"], 125))

        local Ipr_AlignLeft = Ipr_AlignCenterText - 4
        Ipr_AlignLeft = math.ceil(Ipr_AlignLeft)
        surface.DrawLine(Ipr_AlignLeft, h - Ipr_PTHeight + 4, Ipr_AlignLeft, Ipr_PTHeight - 4)

        local Ipr_AlignRight = Ipr_AlignCenterText + 5 + Ipr_PTWide
        surface.DrawLine(Ipr_AlignRight, h - Ipr_PTHeight + 4, Ipr_AlignRight, Ipr_PTHeight - 4)

        surface.SetMaterial(Ipr_FlagMat)
        surface.SetDrawColor(color_white)
        surface.DrawTexturedRect(5, h / 2 - 5.5, 16, 11)
    end

    local function Ipr_OverrideLangPaint(panel)
        local Ipr_PanelChild = panel:GetChildren()

        for i = 1, #Ipr_PanelChild do
            local Ipr_CPanel = Ipr_PanelChild[i]
            local Ipr_CNamePanel = Ipr_CPanel:GetName()

            if (Ipr_CNamePanel == "DPanel") then
                Ipr_CPanel.Paint = function(self, w, h)
                    local Ipr_CenterLangPaintW = w / 2
                    local Ipr_CenterLangPaintH = h / 2

                    local Ipr_ArrowRight = {
                        {x = Ipr_CenterLangPaintW, y = Ipr_CenterLangPaintH - 8 / 2},
                        {x = Ipr_CenterLangPaintW + 5, y = Ipr_CenterLangPaintH},
                        {x = Ipr_CenterLangPaintW, y = Ipr_CenterLangPaintH + 8 / 2},
                    }

                    surface.SetDrawColor(ColorAlpha(Ipr.Settings.TColor["blanc"], 170))
                    draw.NoTexture()
                    surface.DrawPoly(Ipr_ArrowRight)
                end
            end
        end
    end

    Ipr_OverrideLangPaint(Ipr_PLanguage)

    Ipr_PLanguage.OnMenuOpened = function(self)
        local Ipr_PLanguageChild = self:GetChildren()
        Ipr_OverrideLangPaint(self)

        for i = 1, #Ipr_PLanguageChild do
            local Ipr_NLangMenu = Ipr_PLanguageChild[i]
            if (Ipr_NLangMenu:GetName() == "DMenu") then
                Ipr_NLangMenu.Paint = function(p, w, h)
                    draw.RoundedBox(6, 0, 0, w, h, Ipr.Settings.TColor["bleu"])
                end

                local Ipr_PLanguageDMenu = Ipr_NLangMenu:GetChildren()
                for i = 1, #Ipr_PLanguageDMenu do
                    local Ipr_PLangDmenu = Ipr_PLanguageDMenu[i]

                    if (Ipr_PLangDmenu:GetName() == "Panel") then
                        local Ipr_PLanguagePanel = Ipr_PLangDmenu:GetChildren()

                        for i = 1, #Ipr_PLanguagePanel do
                            local Ipr_PMenu = Ipr_PLanguagePanel[i]
                            local Ipr_GetVal = Ipr_PMenu:GetValue()

                            Ipr_GetVal = string.find(Ipr_GetVal, Ipr.Settings.SetLang)

                            if (Ipr_PMenu.SetTextColor) then
                                Ipr_PMenu:SetTextColor(Ipr_GetVal and Ipr.Settings.TColor["vert"] or Ipr.Settings.TColor["blanc"])
                                Ipr_PMenu:SetFont(Ipr.Settings.Font)

                                if (Ipr_GetVal) then
                                    Ipr_PMenu:SetMouseInputEnabled(false)

                                    Ipr_PMenu.Paint = nil
                                    Ipr_PMenu.OnMousePressed = function(self, mousecode)
                                        if (mousecode == MOUSE_LEFT) then
                                            chat.AddText(Ipr.Settings.TColor["rouge"], Ipr.Settings.Script, Ipr.Settings.TColor["blanc"], Ipr.Data.Lang[Ipr.Settings.SetLang].ASelectLang)
                                        end
                                    end
                                else
                                    Ipr_PMenu.Paint = function(self, w, h)
                                        draw.RoundedBox(1, 0, 0, w, h, self:IsHovered() and Ipr.Settings.TColor["bleuc"] or Ipr.Settings.TColor["bleu"])
                                    end
                                end
                            else
                                Ipr_PMenu.Paint = function(self, w, h)
                                    draw.RoundedBox(1, 0, 0, w, h, Ipr.Settings.TColor["vert"])
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    Ipr_PLanguage.OnSelect = function(self, index, value)
        local Ipr_SetLang = self.Data[index]

        self:Clear()
        self:SetValue(Ipr_SetLang)

        Ipr_AddLangSort(Ipr_SetLang)
        self:SetText("")

        if (Ipr_SetLang ~= Ipr.Settings.SetLang) then
            file.Write(Ipr.Settings.Save.. "language.json", Ipr_SetLang)

            Ipr.Settings.SetLang = Ipr_SetLang
            surface.PlaySound("common/stuck1.wav")
        end
    end

    Ipr.Function.CopyData()
end

local function Ipr_InitPostPlayer()
    timer.Simple(5, function()
        if not IsValid(Ipr.Settings.Vgui.Primary) then
            Ipr.Function.CreateData()

            local Ipr_ForcedOpen = Ipr.Function.GetConvar("ForcedOpen")
            if (Ipr_ForcedOpen) then
                Ipr_FpsBooster()
            else
                chat.AddText(Ipr.Settings.TColor["rouge"], Ipr.Settings.Script, Ipr.Settings.TColor["blanc"], Ipr.Data.Lang[Ipr.Settings.SetLang].CForcedOpen)
            end
        end

        local Ipr_DebugEnable = Ipr.Function.GetConvar("EnableDebug")
        if (Ipr_DebugEnable) then
            Ipr.Settings.Debug = true
        end

        local Ipr_Startup = Ipr.Function.GetConvar("Startup")
        if (Ipr_Startup) then
            Ipr.Function.Activate(true)
            chat.AddText(Ipr.Settings.TColor["rouge"], Ipr.Settings.Script, Ipr.Settings.TColor["blanc"], Ipr.Data.Lang[Ipr.Settings.SetLang].StartupEnabled)
        end

        local Ipr_HudEnable = Ipr.Function.GetConvar("FpsView")
        if (Ipr_HudEnable) then
            hook.Add("PostDrawHUD", "IprFpsBooster_HUD", Ipr_HUD)
        end

        local Ipr_EnabledFog = Ipr.Function.GetConvar("EnabledFog")
        if (Ipr_EnabledFog) then
            Ipr.Function.FogActivate(true)
        end
    end)
end

local function Ipr_PlayerShutDown()
    local Ipr_ServerLeave = Ipr.Function.GetConvar("ServerLeaveSettings")
    if (Ipr_ServerLeave) then
        Ipr.Function.Activate(false)
    end

    local Ipr_StartupDelay = timer.Exists(Ipr.Settings.StartupLaunch.Name)
    if (Ipr_StartupDelay) then
        MsgC(Ipr.Settings.TColor["orange"], Ipr.Settings.Script ..Ipr.Data.Lang[Ipr.Settings.SetLang].StartupAbandoned.. "\n")
    end
end

local function Ipr_OnScreenSize()
    Ipr.Settings.Pos.w, Ipr.Settings.Pos.h = ScrW(), ScrH()
end

local Ipr_ChatCommands = {
    ["/boost"] = {
        Function = function()
            Ipr.Function.CreateData()
            Ipr_FpsBooster()

            return true
        end
    },
    ["/reset"] = {
        Function = function()
            Ipr.Function.Activate(false)
            Ipr.Function.ResetFps()

            chat.AddText(Ipr.Settings.TColor["rouge"], Ipr.Settings.Script, Ipr.Settings.TColor["blanc"], Ipr.Data.Lang[Ipr.Settings.SetLang].SReset)
            surface.PlaySound("buttons/combine_button5.wav")

            return true
        end
    },
}                        

local function Ipr_ChatCmds(ply, text)
    local Ipr_LocalPlayer = LocalPlayer()
    if (ply == Ipr_LocalPlayer) then
        text = string.lower(text)

        if (Ipr_ChatCommands[text]) then
            Ipr_ChatCommands[text].Function()
        end
    end
end

hook.Add("ShutDown", "IprFpsBooster_ShutDown", Ipr_PlayerShutDown)
hook.Add("OnScreenSizeChanged", "IprFpsBooster_OnScreen", Ipr_OnScreenSize)
hook.Add("InitPostEntity", "IprFpsBooster_InitPlayer", Ipr_InitPostPlayer)
hook.Add("OnPlayerChat", "IprFpsBooster_ChatCmds", Ipr_ChatCmds)
