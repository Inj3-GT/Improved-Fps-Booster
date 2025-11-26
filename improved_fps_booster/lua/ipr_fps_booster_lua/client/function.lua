// Script by Inj3
// Steam : https://steamcommunity.com/id/Inj3/
// Discord : Inj3
// General Public License v3.0
// https://github.com/Inj3-GT

local Ipr = {}
Ipr.Function = {}

Ipr.Settings = include("table.lua")
Ipr.Data = include("include.lua")

Ipr.Function.CreateData = function()
    local Ipr_CreateDir = file.IsDir(Ipr.Settings.Save, "DATA")
    if not Ipr_CreateDir then
        file.CreateDir(Ipr.Settings.Save)
    end

    local Ipr_DirLang, Ipr_SetLang = Ipr.Settings.Save.. "language.json"
    local Ipr_FLangs = file.Exists(Ipr_DirLang, "DATA")
    local Ipr_CheckSize = file.Size(Ipr_DirLang, "DATA")
    
    if (Ipr_CheckSize == 0) then
        Ipr_FLangs = false
    end

    if not Ipr_FLangs then
        local Ipr_FileCountry = file.Exists("ipr_fps_booster_language/" ..string.lower(Ipr.Settings.Country.target).. ".lua", "LUA")
        if (Ipr_FileCountry) then
            local Ipr_GetCountry = system.GetCountry()
            if (Ipr_GetCountry) and Ipr.Settings.Country.code[Ipr_GetCountry] then
                Ipr_SetLang = Ipr.Settings.Country.target
            end
        end
        if not Ipr_SetLang or (Ipr_SetLang == "") then
            Ipr_SetLang = Ipr.Function.SearchLang()
        end

        Ipr.Settings.SetLang = Ipr_SetLang
        file.Write(Ipr_DirLang, Ipr_SetLang)
    end

    if not Ipr_SetLang then
        Ipr.Settings.SetLang = file.Read(Ipr_DirLang, "DATA")
    end

    local Ipr_FileConvars, Ipr_SetConvars = file.Exists(Ipr.Settings.Save.. "convars.json", "DATA")
    if not Ipr_FileConvars then
        Ipr_SetConvars = {}

        local Ipr_ConvarsLists = Ipr.Data.Default.convars
        for i = 1, #Ipr_ConvarsLists do
            Ipr_SetConvars[#Ipr_SetConvars + 1] = {
                Name = Ipr_ConvarsLists[i].Name,
                Checked = Ipr_ConvarsLists[i].DefaultCheck
            }
        end

        local Ipr_SettingsLists = Ipr.Data.Default.settings
        for i = 1, #Ipr_SettingsLists do
            Ipr_SetConvars[#Ipr_SetConvars + 1] = {
                Vgui = Ipr_SettingsLists[i].Vgui,
                Name = Ipr_SettingsLists[i].Name,
                Checked = Ipr_SettingsLists[i].DefaultCheck
            }
        end

        Ipr.Settings.SetConvars = Ipr_SetConvars
        file.Write(Ipr.Settings.Save.. "convars.json", util.TableToJSON(Ipr_SetConvars))
    end
    
    if not Ipr_SetConvars then
        Ipr.Settings.SetConvars = util.JSONToTable(file.Read(Ipr.Settings.Save.. "convars.json", "DATA"))
    end

    local Ipr_CheckMatch = Ipr.Function.Activate(true, true)
    if not Ipr_CheckMatch then
        Ipr.Settings.Status.State = true
    end
end

Ipr.Function.SearchLang = function()
    local Ipr_DLang = Ipr.Settings.SetLang
    local Ipr_DefaultLang = file.Exists("ipr_fps_booster_language/" ..Ipr_DLang.. ".lua", "LUA")
    if (Ipr_DefaultLang) then 
        return Ipr_DLang
    end

    local Ipr_SearchLang = file.Find("ipr_fps_booster_language/*", "LUA")
    for i = 1, #Ipr_SearchLang do
        local Ipr_Lang = Ipr_SearchLang[i]
        local Ipr_Size = file.Size("ipr_fps_booster_language/" ..Ipr_Lang, "LUA")

        if (Ipr_Size ~= 0) then
            return string.upper(string.gsub(Ipr_Lang, ".lua", ""))
        end
    end

    return Ipr_DLang
end

Ipr.Function.GetConvar = function(name)
    for i = 1, #Ipr.Settings.SetConvars do
        local Ipr_Convars = Ipr.Settings.SetConvars[i]

        if (Ipr_Convars.Name == name) then
            return Ipr_Convars.Checked
        end
    end
    if (Ipr.Settings.Debug) then
        print("Convar not found !", " " ..name)
    end

    return nil
end

Ipr.Function.SetConvar = function(name, value, save, exist, copy)
    local Ipr_Convar = (Ipr.Function.GetConvar(name) == nil)

    if (Ipr_Convar) then
        Ipr.Settings.SetConvars[#Ipr.Settings.SetConvars + 1] = {
            Name = name,
            Checked = value,
        }
        local Ipr_NewData = util.TableToJSON(Ipr.Settings.SetConvars)
        Ipr.Function.SaveConvar(Ipr_NewData)

        if (copy) then
            Ipr.Function.CopyData()
        end
        if (Ipr.Settings.Debug) then
            print("Creating a new convar : " ..name, value, save)
        end
    else
        if (exist) then
            return
        end

        for i = 1, #Ipr.Settings.SetConvars do
            local Ipr_ToggleCount = Ipr.Settings.SetConvars[i]

            if (Ipr_ToggleCount.Name == name) then
                Ipr.Settings.SetConvars[i].Checked = value
                break
            end
        end

        if (save == 1) then
            local Ipr_SaveConvar = "IprFpsBooster_SetConvar"
            if (timer.Exists(Ipr_SaveConvar)) then
                timer.Remove(Ipr_SaveConvar)
            end

            timer.Create(Ipr_SaveConvar, 1, 1, function()
                Ipr.Function.SaveConvar()
            end)
        elseif (save == 2) then
            Ipr.Function.SaveConvar()
        end
    end
end

Ipr.Function.SaveConvar = function(json)
    local Ipr_TConvars = (json) or util.TableToJSON(Ipr.Settings.SetConvars)
    file.Write(Ipr.Settings.Save.. "convars.json", Ipr_TConvars)
end

Ipr.Function.InfoNum = function(cmd, exist)
    local Ipr_InfoNum = LocalPlayer():GetInfoNum(cmd, -99)
    if (exist) then
        return (Ipr_InfoNum == -99)
    end

    return tonumber(Ipr_InfoNum)
end

Ipr.Function.IsChecked = function()
    for i = 1, #Ipr.Settings.SetConvars do
        if not Ipr.Settings.SetConvars[i].Vgui and (Ipr.Settings.SetConvars[i].Checked == true) then
            return true
        end
    end
    
    return false
end

Ipr.Function.CurrentState = function()
    return Ipr.Settings.Status.State
end

Ipr.Function.Activate = function(bool, match)
    local Ipr_ConvarsCheck = bool

    for i = 1, #Ipr.Data.Default.convars do
        local Ipr_NameCommand = Ipr.Data.Default.convars[i].Name
        local Ipr_ConvarCommand = Ipr.Data.Default.convars[i].Convars

        for k, v in pairs(Ipr_ConvarCommand) do
            if isbool(Ipr.Function.GetConvar(Ipr_NameCommand)) then
                if (bool) then
                    Ipr_ConvarsCheck = Ipr.Function.GetConvar(Ipr_NameCommand)
                end

                local Ipr_Toggle = (Ipr_ConvarsCheck) and v.Enabled or v.Disabled
                Ipr_Toggle = tonumber(Ipr_Toggle)

                local Ipr_InfoCmds = Ipr.Function.InfoNum(k)
                if Ipr.Function.InfoNum(k, true) or (Ipr_InfoCmds == Ipr_Toggle) then
                    continue
                end
                if (match) then
                    return true
                end
                RunConsoleCommand(k, Ipr_Toggle)

                if (Ipr.Settings.Debug) then
                    print("Updating " ..k.. " set " ..Ipr_InfoCmds.. " to " ..Ipr_Toggle)
                end
            end
        end
    end

    if (Ipr.Settings.Status.State ~= bool) then
        Ipr.Function.ResetFps()
        Ipr.Settings.Status.State = bool
    end
end

local math = math

Ipr.Function.FpsCalculator = function()
    local Ipr_SysTime = SysTime()

    if Ipr_SysTime > (Ipr.CurNext or 0) then
        local Ipr_AbsoluteFrameTime = engine.AbsoluteFrameTime()
        
        Ipr.Settings.FpsCurrent = math.Round(1 / Ipr_AbsoluteFrameTime)
        Ipr.Settings.FpsCurrent = (Ipr.Settings.FpsCurrent > Ipr.Settings.MaxFps) and Ipr.Settings.MaxFps or Ipr.Settings.FpsCurrent

        if (Ipr.Settings.FpsCurrent < Ipr.Settings.Fps.Min.Int) then
            Ipr.Settings.Fps.Min.Int = Ipr.Settings.FpsCurrent
        end
        if (Ipr.Settings.FpsCurrent > Ipr.Settings.Fps.Max.Int) then
            Ipr.Settings.Fps.Max.Int = Ipr.Settings.FpsCurrent
        end
        
        Ipr.Settings.Fps.Low.Current = Ipr.Settings.Fps.Low.Current or Ipr.Settings.Fps.Min.Int

        local Ipr_CountFrame = #Ipr.Settings.Fps.Low.Frame
        if (Ipr_CountFrame < Ipr.Settings.Fps.Low.MaxFrame) then
            local Ipr_InsertFrame = Ipr_CountFrame + 1
            
            Ipr.Settings.Fps.Low.Frame[Ipr_InsertFrame] = Ipr.Settings.FpsCurrent
        else
            table.sort(Ipr.Settings.Fps.Low.Frame, function(a, b) 
                return a < b 
            end)

            Ipr.Settings.Fps.Low.Current = Ipr.Settings.Fps.Low.Frame[2]
            Ipr.Settings.Fps.Low.Frame = {}
        end

        Ipr.CurNext = Ipr_SysTime + 0.3
    end

    local Ipr_InfMin = Ipr.Settings.Fps.Min.Int
    Ipr_InfMin = (Ipr_InfMin == math.huge) and Ipr.Settings.Fps.Max.Int or Ipr_InfMin

    return Ipr.Settings.FpsCurrent, Ipr_InfMin, Ipr.Settings.Fps.Max.Int, Ipr.Settings.Fps.Low.Current
end

Ipr.Function.CopyData = function()
    local Ipr_TypeData = {}
    local Ipr_DataName = {
        ["Startup"] = true,
    }

    for i = 1, #Ipr.Settings.SetConvars do
        local Ipr_CopyList = Ipr.Settings.SetConvars[i]

        if not Ipr_DataName[Ipr_CopyList.Name] and not Ipr_CopyList.Vgui then
            Ipr_TypeData[#Ipr_TypeData + 1] = Ipr_CopyList
        end
    end

    Ipr.Settings.Revert = {
        Copy = table.Copy(Ipr_TypeData), 
        Set = false,
    }
end

Ipr.Function.GetCopyData = function()
    return Ipr.Settings.Revert.Copy
end

Ipr.Function.ResetFps = function()
    Ipr.Settings.Fps.Min.Int = math.huge
    Ipr.Settings.Fps.Max.Int = 0
end

Ipr.Function.ColorTransition = function(int)
    return (int <= 30) and Ipr.Settings.TColor["rouge"] or (int > 30 and int <= 50) and Ipr.Settings.TColor["orange"] or Ipr.Settings.TColor["vert"]
end

Ipr.Function.RenderBlur = function(panel, colors, border)
    surface.SetDrawColor(Ipr.Settings.TColor["blanc"])
    surface.SetMaterial(Ipr.Settings.Blur)

    local Ipr_Posx, Ipr_Posy = panel:LocalToScreen(0, 0)
    Ipr.Settings.Blur:SetFloat("$blur", 1.5)
    Ipr.Settings.Blur:Recompute()

    render.UpdateScreenEffectTexture()
    surface.DrawTexturedRect(Ipr_Posx * -1, Ipr_Posy * -1, Ipr.Settings.Pos.w, Ipr.Settings.Pos.h)

    local Ipr_VguiWide = panel:GetWide()
    local Ipr_VguiHeight = panel:GetTall()

    draw.RoundedBoxEx(border, 0, 0, Ipr_VguiWide, Ipr_VguiHeight, colors, true, true, true, true)
end

Ipr.Function.FogActivate = function(bool)
    if not bool then
        hook.Remove("SetupWorldFog", "IprFpsBooster_WorldFog")
        hook.Remove("SetupSkyboxFog", "IprFpsBooster_SkyboxFog")
    else
        hook.Add("SetupWorldFog", "IprFpsBooster_WorldFog", function()
            render.FogMode(MATERIAL_FOG_LINEAR)
            render.FogStart(Ipr.Function.GetConvar("FogStart"))
            render.FogEnd(Ipr.Function.GetConvar("FogEnd"))
            render.FogMaxDensity(0.9)

            render.FogColor(171, 174, 176)

            return true
        end)

        hook.Add("SetupSkyboxFog", "IprFpsBooster_SkyboxFog", function(scale)
            render.FogMode(MATERIAL_FOG_LINEAR)
            render.FogStart(Ipr.Function.GetConvar("FogStart") * scale)
            render.FogEnd(Ipr.Function.GetConvar("FogEnd") * scale)
            render.FogMaxDensity(0.9)

            render.FogColor(171, 174, 176)

            return true
        end)
    end
end

Ipr.Function.DrawMultipleTextAligned = function(tbl)
    local Ipr_OldWide = 0
    local Ipr_NewWide = 0

    for t = 1, #tbl do
        local Ipr_TextTbl = tbl[t]
        local Ipr_Pos = Ipr_TextTbl.Pos

        for i = 1, #Ipr_TextTbl do
            Ipr_NewWide = Ipr_OldWide

            surface.SetFont(Ipr.Settings.Font)

            local Ipr_NameText = Ipr_TextTbl[i].Name
            local Ipr_TWide = surface.GetTextSize(Ipr_NameText)
            Ipr_OldWide = Ipr_OldWide + Ipr_TWide + Ipr.Settings.Escape

            local Ipr_TAlign = Ipr_Pos.PWide + Ipr_NewWide
            draw.SimpleTextOutlined(Ipr_NameText, Ipr.Settings.Font, Ipr_TAlign, Ipr_Pos.PHeight, Ipr_TextTbl[i].FColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT, 1, ColorAlpha(color_black, 100))
        end

        Ipr_OldWide = 0
    end
end

Ipr.Function.SetToolTip = function(text, panel, localization)
    if not IsValid(Ipr.Settings.Vgui.ToolTip) then
        Ipr.Settings.Vgui.ToolTip = vgui.Create("DPanel")
        Ipr.Settings.Vgui.ToolTip:SetText("")
        Ipr.Settings.Vgui.ToolTip:SetDrawOnTop(true)

        local Ipr_Text = text
        local Ipr_IconSize = 16
        local Ipr_CBoxSize = 9
        Ipr.Settings.Vgui.ToolTip.Text = function(text) 
            surface.SetFont(Ipr.Settings.Font)
            local Ipr_TWide, Ipr_THeight = surface.GetTextSize(text)
            Ipr.Settings.Vgui.ToolTip:SetSize(Ipr_TWide + Ipr_IconSize + Ipr_CBoxSize, Ipr_THeight + 1)

            Ipr_Text = text
        end
        Ipr.Settings.Vgui.ToolTip.Paint = function(self, w, h)
            Ipr.Function.RenderBlur(self, ColorAlpha(color_black, 130), 6)

            surface.SetDrawColor(color_white)
            surface.SetMaterial(Ipr.Settings.IToolTip)
            surface.DrawTexturedRect(2, 2, Ipr_IconSize, Ipr_IconSize)
 
            draw.SimpleText(Ipr_Text, Ipr.Settings.Font, Ipr_IconSize + Ipr_CBoxSize / 2 - 2, 1, Ipr.Settings.TColor["blanc"], TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT)
        end

        Ipr.Settings.Vgui.ToolTip:SetVisible(false)
    end
    if not IsValid(panel) then
        return
    end
    
    local Ipr_OverrideChildren = panel:GetChildren()
    local Ipr_NameVgui = panel:GetName()
    local Ipr_VguiManage = {
        ["DButton"] = {Panel = true},
        ["DImageButton"] = {Panel = true},
        ["DCheckBox"] = {Panel = false, Parent = panel:GetParent()},
    }

    if (Ipr_VguiManage[Ipr_NameVgui].Panel) then
        Ipr_OverrideChildren[#Ipr_OverrideChildren + 1] = panel
    end
    if (Ipr_VguiManage[Ipr_NameVgui].Parent) then
        Ipr_OverrideChildren[#Ipr_OverrideChildren + 1] = Ipr_VguiManage[Ipr_NameVgui].Parent
    end

    for i = 1, #Ipr_OverrideChildren do
        local Ipr_OverrideChild = Ipr_OverrideChildren[i]
        
        Ipr_OverrideChild.OnCursorMoved = function(self)
            if not IsValid(Ipr.Settings.Vgui.ToolTip) then
                return
            end

            local ipr_InputX, ipr_InputY = input.GetCursorPos()
            local ipr_Pos = ipr_InputX - Ipr.Settings.Vgui.ToolTip:GetWide() / 2

            Ipr.Settings.Vgui.ToolTip:SetPos(ipr_Pos, ipr_InputY - 30)
        end
        Ipr_OverrideChild.OnCursorExited = function()
            if not IsValid(Ipr.Settings.Vgui.ToolTip) then
                return
            end

            Ipr.Settings.Vgui.ToolTip:SetVisible(false)
        end
        Ipr_OverrideChild.OnCursorEntered = function(self)
            if not IsValid(Ipr.Settings.Vgui.ToolTip) then
                return
            end
            Ipr.Settings.Vgui.ToolTip.Text((localization) and text or Ipr.Data.Lang[Ipr.Settings.SetLang][text])
            Ipr.Settings.Vgui.ToolTip:SetVisible(true)

            Ipr.Settings.Vgui.ToolTip:SetAlpha(0)
            Ipr.Settings.Vgui.ToolTip:AlphaTo(255, 0.8, 0)
        end
    end
end

Ipr.Function.DCheckBoxLabel = function(panel, tbl)
    local Ipr_SOptiPanel = vgui.Create("DPanel", panel)
    Ipr_SOptiPanel:Dock(TOP)
    Ipr_SOptiPanel:SetTall(20)
    Ipr_SOptiPanel:DockMargin(0, 5, 0, 5)
    Ipr_SOptiPanel.Paint = nil

    local Ipr_SOptiButton = vgui.Create("DCheckBox", Ipr_SOptiPanel)
    Ipr_SOptiButton:DockMargin(0, 0, 5, 0)
    Ipr_SOptiButton:Dock(LEFT)
    Ipr_SOptiButton:SetWide(35)

    local Ipr_Checked = Ipr.Function.GetConvar(tbl.Name)
    Ipr_SOptiButton:SetValue(Ipr_Checked)
    Ipr_SOptiButton.SLerp = (Ipr_Checked) and Ipr_SOptiButton:GetTall() + 3 or 6

    Ipr_SOptiButton.Paint = function(self, w, h)
        local Ipr_FrameChecked = self:GetChecked()
        local Ipr_PosW = (Ipr_FrameChecked) and (w / 2 ) + 2 or 6

        self.SLerp = Lerp(SysTime() * 13, self.SLerp or Ipr_PosW, Ipr_PosW)

        draw.RoundedBox(12, 2, 2, w - 4, h - 4, (Ipr_FrameChecked) and Ipr.Settings.TColor["bleu"] or Ipr.Settings.TColor["gris"])
        draw.RoundedBox(12, self.SLerp, 5, 10, 10, Ipr.Settings.TColor["blanc"])
        
        surface.DrawCircle(self.SLerp + 5, 10, 6, ColorAlpha(color_black, 90))
    end
    Ipr_SOptiButton.DoClick = function(self)
        local Ipr_SoundChecked = self:GetChecked() and "garrysmod/ui_return.wav" or "buttons/button15.wav"
        surface.PlaySound(Ipr_SoundChecked)

        self:Toggle()
    end

    local Ipr_SLabel = vgui.Create("DLabel", Ipr_SOptiPanel)
    Ipr_SLabel:Dock(FILL)
    Ipr_SLabel:SetFont(Ipr.Settings.Font)
    Ipr_SLabel:SetText("")

    Ipr_SLabel.Paint = function(self, w, h)
        local Ipr_Color = Ipr_SOptiButton:IsHovered() and Ipr.Settings.TColor["vert"] or Ipr.Settings.TColor["blanc"]
        draw.SimpleText(Ipr.Data.Lang[Ipr.Settings.SetLang][tbl.Localization.Text], Ipr.Settings.Font, 0, 1, Ipr_Color, TEXT_ALIGN_LEFT)
    end

    return Ipr_SOptiButton, Ipr_SOptiPanel
end

Ipr.Function.DNumSlider = function(panel, tbl)
    local Ipr_DNumPanel = vgui.Create("DPanel", panel)
    Ipr_DNumPanel:SetSize(225, 39)
    Ipr_DNumPanel:Dock(TOP)
    Ipr_DNumPanel.Paint = nil

    local Ipr_DNumPanelPaint = vgui.Create("DPanel", Ipr_DNumPanel)
    Ipr_DNumPanelPaint:Dock(TOP)

    local Ipr_SConfigCreate = vgui.Create("DNumSlider", Ipr_DNumPanel)
    Ipr_SConfigCreate:SetSize(Ipr_PrimaryWide, 25)
    Ipr_SConfigCreate:Dock(BOTTOM)
    Ipr_SConfigCreate:SetText("")
    Ipr_SConfigCreate:SetMinMax(0, tbl.Max or 100)
    Ipr_SConfigCreate:SetValue(Ipr.Function.GetConvar(tbl.Name))
    Ipr_SConfigCreate:SetDecimals(0)

    Ipr_DNumPanelPaint.Paint = function(self, w, h)
       draw.SimpleText(Ipr.Data.Lang[Ipr.Settings.SetLang][tbl.Localization.Text].. " [" ..math.Round(Ipr_SConfigCreate:GetValue()).. "]", Ipr.Settings.Font, w / 2, 0, Ipr.Settings.TColor["blanc"], TEXT_ALIGN_CENTER)
    end

    local Ipr_PrimaryWide = Ipr_DNumPanel:GetWide()
    local Ipr_PanelChild = Ipr_SConfigCreate:GetChildren()
    local Ipr_OverrideSlider = {
        ["DSlider"] = function(slide)
            slide:Dock(FILL)
            slide:SetSize(Ipr_PrimaryWide, 25)

            slide.Knob.Paint = function(self, w, h)
                draw.RoundedBox(6, 5, 2, w - 10, h - 4, (slide.Dragging or slide.Knob.Depressed) and Ipr.Settings.TColor["rouge"] or Ipr.Settings.TColor["vert"])
                draw.RoundedBox(6, 6, 3, w - 12, h - 6, Ipr.Settings.TColor["blanc"])
            end
            slide.Paint = function(self, w, h)
                surface.SetDrawColor(ColorAlpha(color_black, 90))
                surface.DrawLine(9, h - 15, w - 8, h - 15)
                surface.DrawLine(9, h - 11, w - 8, h - 11)
                
                draw.RoundedBox(3, 7, h / 2 - 2, w - 12, h / 2 - 10, Ipr.Settings.TColor["bleu"])

                draw.RoundedBox(3, 7, 9, 3, h - 18, Ipr.Settings.TColor["blanc"])
                draw.RoundedBox(3, w / 2, 10, 3, h - 20, Ipr.Settings.TColor["blanc"])
                draw.RoundedBox(3, w - 8, 9, 3, h - 18, Ipr.Settings.TColor["blanc"])
            end
        end,
        ["DLabel"] = function(slide)
            slide:GetChildren()[1]:SetVisible(false)
            slide:SetVisible(false)
        end,
        ["DTextEntry"] = function(slide)
            slide:SetFont(Ipr.Settings.Font)
            slide:SetTextColor(Ipr.Settings.TColor["blanc"])

            slide:SetVisible(false)
        end,
    }

    for i = 1, #Ipr_PanelChild do
        local Ipr_CPanel = Ipr_PanelChild[i]
        local Ipr_CNamePanel = Ipr_CPanel:GetName()

        local Ipr_FuncSlider = Ipr_OverrideSlider[Ipr_CNamePanel]
        if (Ipr_FuncSlider) then
            Ipr_FuncSlider(Ipr_CPanel)
        end
    end

    Ipr_SConfigCreate.OnValueChanged = function(self)
        Ipr.Function.SetConvar(tbl.Name, self:GetValue(), 1)
    end

    return Ipr_SConfigCreate, Ipr_DNumPanel
end

Ipr.Function.SettingsVgui = {
    ["DCheckBoxLabel"] = function(panel, tbl, hud)
        local Ipr_CreateCheckBoxLabel, Ipr_DPanelCheckBox = Ipr.Function.DCheckBoxLabel(panel, tbl)

        Ipr_CreateCheckBoxLabel.OnChange = function(self)
            local Ipr_GetChecked = self:GetChecked()
            Ipr.Function.SetConvar(tbl.Name, Ipr_GetChecked, 1)

            for i = 1, #Ipr.Settings.Vgui.CheckBox do
                if (Ipr.Settings.Vgui.CheckBox[i].Paired == tbl.Name) then
                    local Ipr_Vgui = Ipr.Settings.Vgui.CheckBox[i].Vgui
                    Ipr_Vgui = Ipr_Vgui:GetParent()

                    if IsValid(Ipr_Vgui) then
                        Ipr_Vgui:SetDisabled(not Ipr_GetChecked)
                    end
                end
            end

            if (tbl.Run_HookFog) then
                Ipr.Function.FogActivate(Ipr_GetChecked)
            elseif (tbl.Run_HookFps) then
                if (Ipr_GetChecked) then
                    hook.Add("PostDrawHUD", "IprFpsBooster_HUD", hud)
                else
                    hook.Remove("PostDrawHUD", "IprFpsBooster_HUD", hud)
                end
            elseif (tbl.Run_Debug) then
                Ipr.Settings.Debug = Ipr_GetChecked
            end
        end

        return Ipr_CreateCheckBoxLabel, Ipr_DPanelCheckBox
    end,
    ["DNumSlider"] = function(panel, tbl)
        local Ipr_CreateNumSlider, Ipr_DPanelSlider = Ipr.Function.DNumSlider(panel, tbl)

        Ipr_CreateNumSlider.OnValueChanged = function(self)
            Ipr.Function.SetConvar(tbl.Name, self:GetValue(), 1)
        end

        return Ipr_CreateNumSlider, Ipr_DPanelSlider
    end,
}

Ipr.Cmd = include("ipr_fps_booster_configuration/commands.lua")

return Ipr