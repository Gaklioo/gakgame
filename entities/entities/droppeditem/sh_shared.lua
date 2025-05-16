ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "basedroppeditem"
ENT.Author = "Gak"
ENT.Category = "inventory"
ENT.Purpose = "base for dropped inventory items"
ENT.Spawnable = true 

gDroppedItem = gDroppedItem or {}

function ENT:SetupDataTables()
    self:SetNW2String("ItemName", "")
end