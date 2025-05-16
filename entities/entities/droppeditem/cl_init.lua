include("sh_shared.lua")

--DrawItem Correctly
function ENT:Draw()
    self:DrawModel()

    local pos = self:GetPos() + Vector(0, 0, 10)
    local ang = self:GetAngles()
    local text = self:GetNW2String("ItemName")
    ang:RotateAroundAxis(ang:Up(), 270)

    cam.Start3D2D(pos, ang, 0.5)
        draw.SimpleText(text, "DermaLarge", 0, 0, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    cam.End3D2D()
end