include("../sh_shared.lua")
util.AddNetworkString("GakGame_Notify")

gItems.ItemList = gItemList or {}
gItems.Cache = gItemList or {}
gItems.P = FindMetaTable("Player")
gItems.Database = "GakGame_Inventory"


hook.Add("GakGame_RegisterItem", "GakGame_ItemRegister", function(item)
    gItems.Register(item)
end)

hook.Add("GakGame_GetItems", "GakGame_GetAllRegisteredItems", function()
    return gItems.ItemList
end)

hook.Add("GakGame_InitializeSQL", "GakGame_InventorySQL", function()
    local str = string.format("CREATE TABLE %s (id TEXT PRIMARY KEY, inventory TEXT)",
    gItems.Database
    )

    if not sql.TableExists(gItems.Database) then
        sql.Begin()
            sql.Query(str)
        sql.Commit()
    end
end)

concommand.Add("chat", function(ply, cmd, args)
    ply:AddItem(gCyanide)
end)

hook.Add("GakGame_LoadPlayer", "GakGame_LoadInventory", function(ply)
    ply:InitInventory()
end)

hook.Add("GakGame_SavePlayer", "GakGame_SaveInventory", function(ply)
    ply:SaveInventory()
end)

function gItems.UpdateDatabase(id, inv)
    local str = string.format("REPLACE INTO %s (id, inventory) values ('%s', '%s')",
    gItems.Database,
    sql.SQLStr(id, true),
    sql.SQLStr(inv, true)
    )

    sql.Query(str)
end

function gItems.LoadDatabase(id)
    local str = string.format("SELECT * FROM %s WHERE id = '%s'",
    gItems.Database,
    sql.SQLStr(id, true)
    )

    local qry = sql.Query(str)

    if not qry then 
        return nil
    else
        return qry[1].inventory
    end
end

function gItems.Register(item)
    if not item.icon then return end
    if not item.weight then return end
    if not item.name then return end
    if not item.id then return end

    gItems.ItemList[item.id] = item
end

function gItems.P:InitInventory()
    self.Inventory = {}

    local inv = gItems.LoadDatabase(self:SteamID())

    if inv then
        local realInv = util.JSONToTable(inv)

        if realInv then
           self.Inventory = realInv
        else
            print("Failed to load inventory for user ", self:SteamID()) 
        end
    end 
end

function gItems.CheckItem(item)
    if not newItem.icon then return false end
    if not newItem.weight then return false end
    if not newItem.name then return false end
    if not newItem.id then return false end

    return true
end

util.AddNetworkString("GakGame_AddInventoryItem")
net.Receive("GakGame_AddInventoryItem", function(len, ply)
    local itmStr = net.ReadString()
    local itm = util.JSONToTable(itmStr)

    if gItems.CheckItem(itm) then
        ply:AddItem(itm)        
    end
end)

function gItems.P:GetMaxWeight()
    local pWeight = hook.Call("GakGame_GakGame_GetMaxWeight", self)
    return gItems.MaxWeight + (gItems.MaxWeight * (pWeight or 1))
end

function gItems.P:AddItem(item)
    if not item then return end

    local id = item.id
    if not gItems.ItemList[id] then return end

    local weight = 0

    for k, v in pairs(self.Inventory) do
        weight = weight + (v.weight * (v.count or 1))
    end
    local maxWeight = self:GetMaxWeight()

    if (item.weight + weight) > maxWeight then
        local str = "Unable to add item to inventory, to heavy"
        net.Start("GakGame_Notify")
        net.WriteString(str)
        net.Send(self)
    else
        if self.Inventory[id] then
            self.Inventory[id].count = (self.Inventory[id].count or 1) + 1
        else
            local newItem = table.Copy(gItems.ItemList[id])
            newItem.count = 1
            self.Inventory[id] = newItem
        end
    end

    self:SyncInventory()
end

function gItems.P:PrintInventory()
    PrintTable(self.Inventory)
end

function gItems.P:GetInventory()
    return self.Inventory
end

function gItems.P:ResetInventory()
    self.Inventory = {}
end

function gItems.P:NotifyFailureItem(itemID)
    if not self.Inventory[itemID] then
        local str = "Unable to remove item, item not found in inventory"
        net.Start("GakGame_Notify")
        net.WriteString(str)
        net.Send(self)
        return true
    end

    if not gItems.ItemList[itemID] then
        local str = "Unable to use item, item not found in server"
        net.Start("GakGame_Notify")
        net.WriteString(str)
        net.Send(self)
        return true
    end

    return false
end

function gItems.P:UseItem(itemID)
    local item = self.Inventory[itemID]

    if self:NotifyFailureItem(itemID) then return end

    gItems.ItemList[itemID].use(self)
    if item.count == 1 then
        self.Inventory[itemID] = nil 
    else
        item.count = item.count - 1
    end

    self:SyncInventory()
end

function gItems.P:DropItem(itemID)
    local item = self.Inventory[itemID]
    if self:NotifyFailureItem(itemID) then return end

    local model = gItems.ItemList[itemID].model
    local pos = self:GetPos() + Vector(50, 0, 0)
    local ang = self:GetAngles()

    local ent = ents.Create("droppeditem")
    if item.count == 1 then
        self.Inventory[itemID] = nil 
    else
        item.count = item.count - 1
    end

    ent:SetPos(pos)
    ent:SetAngles(ang)

    ent:Spawn()
    ent:SetID(itemID)
    ent:SetItem(item)
    if model then
        ent:SetModel(model)
    end
end

function gItems.P:SaveInventory()
    local id = self:SteamID()
    local cache = self.Inventory

    gItems.UpdateDatabase(id, util.TableToJSON(cache))
end

util.AddNetworkString("GakGame_UpdateInventory")
function gItems.P:SyncInventory()
    net.Start("GakGame_UpdateInventory")
        local tbl = util.TableToJSON(self.Inventory)
        net.WriteString(tbl)
    net.Send(self)
end

util.AddNetworkString("GakGame_GetInventory")
net.Receive("GakGame_GetInventory", function(len, ply)
    net.Start("GakGame_UpdateInventory")
        local tbl = util.TableToJSON(ply.Inventory)
        net.WriteString(tbl)
    net.Send(ply)
end)

util.AddNetworkString("GakGame_UseItem")
net.Receive("GakGame_UseItem", function(len, ply)
    local str = net.ReadString()
    local tbl = util.JSONToTable(str)

    ply:UseItem(tbl.id)
end)

util.AddNetworkString("GakGame_DropItem")
net.Receive("GakGame_DropItem", function(len, ply)
    local str = net.ReadString()
    local tbl = util.JSONToTable(str)

    ply:DropItem(tbl.id)
end)