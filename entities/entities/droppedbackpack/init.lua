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
    for _, v in pairs(self.Contents) do
        if item.id == v.id then
            return true
        end
    end

    return false
end

function ENT:TakeItem(item)
    for _, v in pairs(self.Contents) do
        if item.id == v.id then
            v.count = v.count - 1

            if v.count <= 0 then
                self.Contents[v] = nil
            end
            return
        end
    end
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

local function printInv(inv)
    for _, v in pairs(inv) do
        PrintTable(v)
    end
end

--Right now there is a bug here, that if you die by cyanide that cyanide is put into the bag instead of being used so just wait a second
hook.Add("PlayerDeath", "GakGame_CreateBackpack", function(ply)
    if not ply:IsPlayer() then return end

    local inv = ply:GetInventory()
    printInv(inv)
    ply:ResetInventory()
    local pos = ply:GetPos() + Vector(0, 0, 10)
    local ang = ply:GetAngles()

    local backpack = ents.Create("droppedbackpack")
    backpack:SetPos(pos)
    backpack:SetAngles(ang)
    backpack:SetContents(inv)

    backpack:Spawn()

    timer.Simple(600, function()
        backpack:Remove()
    end)
end)