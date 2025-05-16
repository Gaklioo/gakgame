include("sh_shared.lua")

gakFrame = gakFrame or {}
gakFrame.Panel = {}

function gakFrame.Panel:Init()
    self:SetTitle("")
    self.title = ""
    self:SetDraggable(false)
    self:ShowCloseButton(false)

    self.close = vgui.Create("gakButton", self)
    self.close:SetTall(self:GetTall())
    self.close:SetText("X")
    self.close.DoClick = function()
        self:Close()
    end

    self.DrawHeader = true
    
    surface.SetFont("GakText")
    local _, textHeight = surface.GetTextSize("A")

    self.headerHeight = textHeight + 8
    self.Content = vgui.Create("gakPanel", self)
    self.Content:SetPos(0, self.headerHeight)

    self:MakePopup()
end

function gakFrame.Panel:SetHeader(text)
    self.title = text
end

function gakFrame.Panel:GetHeader()
    return self.title
end

function gakFrame.Panel:PerformLayout(w, h)
    if IsValid(self.close) then
        self.close:SetPos(self:GetWide() - self.close:GetWide(), 0)
    end

    if IsValid(self.Content) then
        self.Content:SetSize(w, h - self.headerHeight)
        self.Content:SetPos(0, self.headerHeight)
    end
end

function gakFrame.Panel:DrawNoHeader()
    self.DrawHeader = false
end

function gakFrame.Panel:Paint(w, h)
    draw.RoundedBox(2, 0, 0, w, h, gakUI.Colors.background)

    if self.DrawHeader then
        draw.RoundedBox(2, 0, 0, w, h / 10, gakUI.Colors.panel)
        draw.SimpleText(self.title, "GakText", w / 2, h / 20, gakUI.Colors.text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    else
        draw.RoundedBox(2, 0, 0, w, h, gakUI.Colors.panel)
        self.close:Remove()
        self.headerHeight = 0
    end
end

hook.Add("OnPlayerChat", "jlkasdcvjlkasc", function()
    local frame = vgui.Create("gakFrame")
    frame:SetSize(500, 250)
    frame:Center()
    frame:SetHeader("Gak UI")

    local button = vgui.Create("gakButton", frame.Content)
    button:SetText("Click!")
    button:SetSize(75, 25)
    button:Dock(FILL)
    button.DoClick = function()
        print("HI:)")
    end


end)

gakUI.register("gakFrame", gakFrame.Panel, "DFrame")