AddCSLuaFile("cl_init.lua")
AddCSLuaFile("sh_shared.lua")
include("sh_shared.lua")

function ENT:Initialize()
    self:SetModel("models/props_lab/reciever_cart.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_NONE)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetUseType(SIMPLE_USE)

    local phys = self:GetPhysicsObject()

    if phys:IsValid() then
        phys:Wake()
    end
end

util.AddNetworkString("GakGame_OpenATM")
function ENT:Use(act)
    net.Start("GakGame_OpenATM")
    net.Send(act)
end