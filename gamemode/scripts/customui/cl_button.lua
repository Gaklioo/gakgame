include("sh_shared.lua")

gakButton = gakButton or {}
gakButton.Panel = {}

function gakButton.Panel:Init()
    self:SetMouseInputEnabled(true)
    self:SetCursor("hand")

    self._text = ""
    self.DoClick = function() end
end

function gakButton.Panel:SetText(text)
    self._text = text
end

function gakButton.Panel:GetText()
    return self._text or ""
end

function gakButton.Panel:OnMousePressed()
    if self.DoClick then
        self:DoClick()
    end
end

function gakButton.Panel:Paint(w, h)
    local bgColor = self:IsHovered() and gakUI.Colors.buttonHover or gakUI.Colors.button
    draw.RoundedBox(6, 0, 0, w, h, bgColor)

    surface.SetDrawColor(gakUI.Colors.border)
    surface.DrawOutlinedRect(0, 0, w, h, 2)

    local text = self:GetText()
    surface.SetFont("GakText")
    local textW, textH = surface.GetTextSize(text)
    draw.SimpleText(text, "GakText", w / 2, (h - textH) / 2, gakUI.Colors.text, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
end

gakUI.register("gakButton", gakButton.Panel, "DPanel")