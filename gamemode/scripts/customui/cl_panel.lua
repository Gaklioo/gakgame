include("sh_shared.lua")

local gPanel = gPanel or {}
gPanel.panel = {}

function gPanel.panel:Init()
    self:SetBackgroundColor(gakUI.Color.Primary)
    self:SizeToContents()
end

gakUI.register("gakPanel", gPanel.panel, "DPanel")
