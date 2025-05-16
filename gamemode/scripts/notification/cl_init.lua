net.Receive("GakGame_Notify", function()
    local str = net.ReadString()

    local panel = vgui.Create("gakPanel")
    panel:SetPos(ScrW() / 1.2, ScrH() / 1.2)
    panel:SetSize(ScrW() / 6, ScrH() / 20)

    local label = vgui.Create("DLabel", panel)
    label:SetColor(Color(255, 240, 255, 255))
    label:SetText(str)
    label:SizeToContents()
    label:Center()

    timer.Simple(10, function()
        panel:Remove()
    end)   
end)
