include("sh_shared.lua")

local gPanel = gPanel or {}
gPanel.panel = {}

function gPanel.panel:Init()
    self:SetBackgroundColor(gakUI.Colors.panel)
    self:SizeToContents()
end

function gPanel.panel:Paint(w, h)
    draw.RoundedBox(6, 0, 0, w, h, gakUI.Colors.panel)
    surface.SetDrawColor(gakUI.Colors.border)
    surface.DrawOutlinedRect(0, 0, w, h, 2)
end

gakUI.register("gakPanel", gPanel.panel, "DPanel")
