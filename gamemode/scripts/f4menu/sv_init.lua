AddCSLuaFile("cl_init.lua")
AddCSLuaFile("sh_shared.lua")
include("sh_shared.lua")

gF4Menu = gF4Menu or {}
gF4Menu.RegisteredEntities = {}

util.AddNetworkString("GakGame_RecieveEntities")
util.AddNetworkString("GakGame_GetEntities")
net.Receive("GakGame_GetEntities", function(len, ply)
    local tbl = util.TableToJSON(gF4Menu.RegisteredEntities)

    net.Start("GakGame_RecieveEntities")
    net.WriteString(tbl)
    net.Send(ply)
end)

util.AddNetworkString("GakGame_BuyEntity")
net.Receive("GameGame_BuyEntity", function(len, ply)
    local str = net.ReadString()
    local tbl = util.JSONToTable(str)

    if not tbl then return end
    
end)

hook.Add("GakGame_RegisterBuyableEntity", "GakGame_RegisterEntityServer", function(ent, price, icon)
    local addTable = {
        ent = ent,
        price = price,
        icon = icon
    }

    table.insert(gF4Menu.RegisteredEntities, addTable)
end)