AddCSLuaFile()

local _P = FindMetaTable("Player")

function _P:Save()
    hook.Run("GakGame_SavePlayer", self)
end

function _P:Load()
    hook.Run("GakGame_LoadPlayer", self)
    hook.Run("GakGame_LoadEconomy", self)
    hook.Run("GakGame_LoadTeams", self)
end

hook.Add("PlayerInitialSpawn", "GakGame_PlayerJoin", function(ply)
    ply:Load()
end)

hook.Add("PlayerDisconnected", "GakGame_PlayerLeave", function(ply)
    ply:Save()
end)