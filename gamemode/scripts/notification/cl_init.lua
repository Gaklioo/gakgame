net.Receive("GakGame_Notify", function()
    local str = net.ReadString()

    local panel = vgui.Create("DPanel")
    panel:SetPos(ScrW() / 1.2, ScrH() / 1.2)
    panel:SetSize(ScrW() / 6, ScrH() / 20)

    panel.Paint = function(self, w, h)
        draw.RoundedBox(2, 0, 0, w, h, Color(0, 0, 0, 180))
    end

    local label = vgui.Create("DLabel", panel)
    label:SetColor(Color(255, 0, 0))
    label:SetText(str)
    label:SizeToContents()
    label:Center()

    timer.Simple(10, function()
        panel:Remove()
    end)   
end)
