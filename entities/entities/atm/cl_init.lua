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