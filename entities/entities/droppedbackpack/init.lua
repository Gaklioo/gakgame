AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
print("Loaded Ent")

function ENT:Initialize()
    self:SetModel("models/props_junk/cardboard_box003a_gib01.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_NONE)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetUseType(SIMPLE_USE)

    local phys = self:GetPhysicsObject()

    if phys:IsValid() then
        phys:Wake()
    end
end

function ENT:SetContents(table)
    if not table then return end

    self.Contents = table
end

function ENT:CheckItem(item)

end

function ENT:TakeItem(item)

end


util.AddNetworkString("GakGame_DeadInvOpen")
function ENT:Use(act)
    if not IsValid(act) then return end
    if not act:IsPlayer() then return end

    local tbl = util.TableToJSON(self.Contents or {})

    net.Start("GakGame_DeadInvOpen")
    net.WriteString(tbl)
    net.WriteEntity(self)
    net.Send(act)
end

util.AddNetworkString("GakGame_TakeBackpackItem")
net.Receive("GakGame_TakeBackpackItem", function(len, ply)
    if not IsValid(ply) then return end
    if not ply:IsPlayer() then return end

    local str = net.ReadString()
    local ent = net.ReadEntity()

    if not IsValid(ent) then return end
    if not str then return end
    local item = util.JSONToTable(str)

    if not ent:CheckItem(item) then 
        hook.Run("GakGame_NotifyPlayer", ply, "Unable to take item as it does not exist cheater.")
        return 
    end

    ent:TakeItem(item)
    ply:AddItem(item)



end)