AddCSLuaFile("cl_init.lua")
AddCSLuaFile("sh_shared.lua")
include("sh_shared.lua")

gDroppedItem.ItemList = hook.Run("GakGame_GetItems")

function ENT:Initialize()
    self:SetModel("models/props_junk/PlasticCrate01a.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_NONE)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetUseType(SIMPLE_USE)
    self.id = nil
    self.item = nil

    local phys = self:GetPhysicsObject()

    if phys:IsValid() then
        phys:Wake()
    end
end

function ENT:SetID(itemID)
    if not itemID then return end
    if not gDroppedItem.ItemList[itemID] then return end

    self.id = itemID
end

function ENT:SetItem(item)
    if not item then return end
    if not gDroppedItem.ItemList[item.id] then return end

    self.item = item
    self:SetNW2String("ItemName", item.name)
end

function ENT:Use(act)
    if not IsValid(act) then return end
    if not act:IsPlayer() then return end

    if self.id != self.item.id then return end

    act:AddItem(gDroppedItem.ItemList[self.id])
    self:Remove()
end