include("sh_shared.lua")

function ENT:Draw()
    self:DrawModel()
    local pos = self:GetPos() + 
    self:GetUp() * 45 +
    self:GetRight() * -5 +
    self:GetForward() * 5
    local ang = self:GetAngles()
    ang:RotateAroundAxis(ang:Forward(), 90)
    ang:RotateAroundAxis(ang:Right(), -90)

    cam.Start3D2D(pos, ang, 0.2)
        surface.SetDrawColor(0, 0, 0)
        surface.DrawTexturedRect(-25, 0, 50, 25)
        draw.DrawText("ATM", "GakButtonText", 0, 0, Color(255, 255, 255), TEXT_ALIGN_CENTER)
    cam.End3D2D()
end

net.Receive("GakGame_OpenATM", function()
    local x, y = ScrW(), ScrH()
    local frame = vgui.Create("gakFrame")
    frame:SetSize(x / 3, y / 3)
    frame:Center()

    local w = frame:GetWide()
    local h = frame:GetTall()

    local wW = w / 2
    local hH = h / 2

    local plyTransferPanel = vgui.Create("gakPanel", frame.Content)
    local plyButton = vgui.Create("gakButton", plyTransferPanel)
    plyTransferPanel:SetSize(200, 50)
    plyButton:SetSize(200, 50)
    plyButton:SetText("Transfer To Player")
    plyButton:SizeToContents()
    plyTransferPanel:SetPos(w / 10, h / 3)

    plyButton.DoClick = function()
        frame:Remove()
        frame = vgui.Create("gakFrame")
        frame:SetSize(x / 3, y / 3)
        frame:Center()
        local combo = vgui.Create("DComboBox", frame)
        combo:SetPos(combo:GetParent():GetWide() / 1.5, hH)
        combo:SetSize(100, 20)
        combo:SetValue("Player")

        combo.OnSelect = function(_, _, val)
            print(val)
        end

        for _, v in player.Iterator() do
            combo:AddChoice(v:Name())
        end

        local wang = vgui.Create("DNumberWang", frame)
        wang:SetPos(w / 5, h / 2)
        wang:SetMin(0)
        
        local submit = vgui.Create("gakButton", frame)
        submit:SetText("Transfer")
        submit:SetPos(w / 2.2, h / 1.2)
    end

    local idTransferPanel = vgui.Create("gakPanel", frame.Content)
    local idButton = vgui.Create("gakButton", idTransferPanel)
    idTransferPanel:SetPos(w / 2, h / 3)
    idButton:SetText("Transfer To SteamID")

    idTransferPanel:SetSize(200, 50)
    idButton:SetSize(200, 50)

    -- local combo = vgui.Create("DComboBox", frame)
    -- combo:SetPos(combo:GetParent():GetWide() / 1.5, hH)
    -- combo:SetSize(100, 20)
    -- combo:SetValue("Player")

    -- combo.OnSelect = function(_, _, val)
    --     print(val)
    -- end

    -- for _, v in player.Iterator() do
    --     combo:AddChoice(v:Name())
    -- end
end)