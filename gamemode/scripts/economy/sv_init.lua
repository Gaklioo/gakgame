AddCSLuaFile("sh_shared.lua")
AddCSLuaFile("cl_init.lua")
include("sh_shared.lua")

gEconomy.P = FindMetaTable("Player")

function gEconomy.P:AddMoney(amt)
    if amt <= 0 then hook.Run("GakGame_NotifyPlayer", self, "Cannot add <= 0 money") return end
    self.Money = self.Money + amt

    gEconomy.LogTransaction(self:SteamID(), "Added Money", amt)
end

function gEconomy.P:RemoveMoney(amt)
    if self.Money < amt then hook.Run("GakGame_NotifyPlayer", self, "You are to poor for this action, brokie.") return end
    if amt <= 0 then hook.Run("GakGame_NotifyPlayer", self, "Cannot remove negative money.") return end

    self.Money = self.Money - amt

    gEconomy.LogTransaction(self:SteamID(), "Removed Money", amt)
end

--ply is the other user
function gEconomy.P:Transfer(amt, ply)
    if not IsValid(amt) then return end
    if not IsValid(ply) then return end
    if self.Money < amt then hook.Run("GakGame_NotifyPlayer", self, "Cannot transfer more than you have") return end

    ply:AddMoney(amt)
    self:RemoveMoney(amt)

    gEconomy.LogTransaction(self:SteamID(), "Transfered Money to ", ply:SteamID(), amt)
end

function gEconomy.P:TransferSteamID(amt, steamid)
    if not IsValid(amt) then return end
    if not IsValid(steamid) then return end
    if self.Money < amt then hook.Run("GakGame_NotifyPlayer", self, "Cannot transfer more than you have") return end

    local foundPly = player.GetBySteamID(steamid)

    if foundPly then
        self:Transfer(amt, foundPly)
        return
    else
        if gEconomy.TransferById(amt, steamid) then
            self:RemoveMoney(amt)
            gEconomy.LogTransaction(self:SteamID(), "Transfered Money to ", steamid, amt)
        else
            hook.Run("GakGame_NotifyPlayer", self, "SteamID not found in economy")
        end
    end
end

function gEconomy.TransferById(amt, steamid)
    local str = string.format("SELECT balance FROM %s where id = '%s'",
    gEconomy.Database,
    sql.SQLStr(steamid, true)
    )

    local q = sql.Query(str)

    if not sql.LastError() then
        local bal = tonumber(q[1].balance)
        bal = bal + amt

        local update = string.format("UPDATE %s SET balance = %d WHERE id = '%s'",
        gEconomy.Database,
        bal,
        sql.SQLStr(steamid, true)
        )

        q = sql.Query(update)

        if not sql.LastError() then
            return true 
        else
            return false
        end
    else
        return false
    end
end

function gEconomy.P:LoadEconomy()
    self:LoadMoney(self:SteamID())
end

hook.Add("GakGame_AddMoney", "GakGame_AddMoneyServer", function(ply, amt)
    if not IsValid(ply) then return end
    if not IsValid(amt) then return end
    ply:AddMoney(amt)
end)

hook.Add("GakGame_RemoveMoney", "GakGame_RemoveMoneyServer", function(ply, amt)
    if not IsValid(ply) then return end
    if not IsValid(amt) then return end
    ply:RemoveMoney(amt)
end)

hook.Add("GakGame_TransferMoney", "GakGame_TransferMoneyServe", function(ply, amt, transferPlayer)
    if not IsValid(ply) then return end
    if not IsValid(amt) then return end
    if not IsValid(transferPlayer) then return end

    ply:Transfer(amt, ply)
end)

hook.Add("GakGame_TransferMoneyID", "GakGame_TransferSteamIDMoney", function(ply, amt, steamID)
    if not IsValid(ply) then return end
    if not IsValid(amt) then return end
    if not IsValid(steamID) then return end

    ply:TransferById(amt, steamID)
end)

hook.Add("GakGame_LoadEconomy", "GakGame_CreateNewEconomy", function(ply)
    ply:LoadEconomy()
end)

function gEconomy.P:LoadMoney(id)
    local str = string.format("SELECT balance FROM %s where id = '%s'",
    gEconomy.Database,
    sql.SQLStr(id, true)
    )

    local q = sql.Query(str)

    if q then
        self.Money = tonumber(q[1])
        return
    else
        gEconomy.CreateUser(id)
        self.Money = gEconomy.StartingMoney
    end
end

function gEconomy.CreateUser(id)
    local str = string.format("INSERT INTO %s (id, balance) VALUES (%s, %d)",
    gEconomy.Database,
    sql.SQLStr(id, true),
    gEconomy.StartingMoney
    )

    sql.Query(str)
end