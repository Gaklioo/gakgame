AddCSLuaFile("cl_init.lua")
AddCSLuaFile("sh_shared.lua")
include("sh_shared.lua")

gSkillTree.P = FindMetaTable("Player")
gSkillTree.PlayerCache = gSkillTree.PlayerCache or {}

hook.Add("GakGame_LoadPlayer", "GakGame_LoadSkillTree", function(ply)
    ply:InitTree()
    ply:LoadTree()

    ply:SetClass()
end)

hook.Add("PlayerSpawn", "GakGame_LoadClass", function(ply)
    ply:SetClass()
end)

hook.Add("GakGame_SavePlayer", "GakGame_SaveSkillTree", function(ply)
    ply:SaveTree()
end)

hook.Add("GakGame_InitializeSQL", "GakGame_SetupSkillTreeSQL", function()
    if not sql.TableExists(gSkillTree.Database) then
        local str = string.format("CREATE TABLE IF NOT EXISTS %s (id TEXT PRIMARY KEY, level TEXT, xp INT)",
        gSkillTree.Database
        )

        sql.Begin()
            sql.Query(str)
            print("Created Table", gSkillTree.Database)
        sql.Commit()
    end
end)

function gSkillTree.P:LoadTree()
    local id = self:SteamID()
    local str = string.format("SELECT * FROM %s WHERE id = '%s'",
    gSkillTree.Database,
    sql.SQLStr(id, true)
    )

    local qry = sql.Query(str)

    if not qry then
        print("Creating tree")
        self:CreateTreePlayer()
    else
        print("Loaded Tree")
        local data = qry[1]
        local tbl = util.JSONToTable(data.level)
        gSkillTree.PlayerCache[id] = tbl
        gSkillTree.PlayerCache[id].xp = data.xp
    end
end

function gSkillTree.P:CreateTreePlayer()
    local id = self:SteamID()
    local str = string.format("INSERT INTO %s (id, level, xp) VALUES ('%s', '%s', %d)",
    gSkillTree.Database,
    sql.SQLStr(id, true),
    sql.SQLStr(util.TableToJSON(gSkillTree.PlayerCache[id]), true),
    0
    )

    sql.Query(str)
end

function gSkillTree.P:InitTree()
    local id = self:SteamID()
    if gSkillTree.PlayerCache[id] then return end

    gSkillTree.PlayerCache[id] = {
        xp = 0,
        abilities = {}
    }

    for k, v in pairs(gSkillTree.Abilities) do
        for i, ability in ipairs(v) do
            table.insert(gSkillTree.PlayerCache[id].abilities, {
                category = k,
                ability = ability,
                level = gSkillTree.StartLevel or 0
            })
        end
    end
end

function gSkillTree.P:PrintStats()
    local cache = gSkillTree.PlayerCache[self:SteamID()]

    for _, entry in ipairs(cache.abilities) do
        print(string.format("Category: %s | Ability: %s | Level: %d", entry.category, entry.ability, entry.level))
    end

    print("XP " .. cache.xp)
end

function gSkillTree.P:SaveTree()
    local id = self:SteamID()
    if not gSkillTree.PlayerCache[id] then return end

    local tmp = table.Copy(gSkillTree.PlayerCache[id])
    local xp = gSkillTree.PlayerCache[id].xp
    tmp.xp = nil
    local tbl = util.TableToJSON(tmp)

    local str = string.format("REPLACE INTO %s (id, level, xp) values ('%s', '%s', %d)",
    gSkillTree.Database,
    sql.SQLStr(id, true),
    sql.SQLStr(tbl, true),
    xp
    )

    local qry = sql.Query(str)    

    if sql.LastError() then
        print("Failed to save", sql.LastError())
    else
        print("Saved without failure")
    end
end

function gSkillTree.P:GiveXP(xp)
    hook.Run("GakGame_GiveSkillTreeXP", self, xp)
end

function gSkillTree.CheckFake(ply)
    if not Isvalid(ply) then return true end
    if not ply:IsPlayer() then return true end
    if not gSkillTree.PlayerCache[ply:SteamID()] then return true end
end

util.AddNetworkString("GakGame_SkillTreeUpgrade")
net.Receive("GakGame_SkillTreeUpgrade", function(len, ply)
    if gSkillTree.CheckFake(ply) then return end

    local category = net.ReadString()
    local ability = net.ReadString()
    local level = net.ReadInt(32)
    local id = ply:SteamID()

    local cache = gSkillTree.PlayerCache[id]

    if not cache then return end
    if not gSkillTree.Abilities[category] then return end
    if not gSkillTree.Abilities[category][ability] then return end
    

    for _, entry in ipairs(cache.abilities) do
        if entry.category == category and entry.ability == ability then
            local requiredXp = gSkillTree.GetXpRequired(entry.level)

            if cache.xp >= requiredXp and entry.level < gSkillTree.MaxLevel then
                cache.xp = cache.xp - requiredXp
                entry.level = entry.level + 1
            end
        end
    end
end)

util.AddNetworkString("GakGame_SkillTreeGet")
util.AddNetworkString("GakGame_SkillTreeRecieve")
net.Receive("GakGame_SkillTreeGet", function(len, ply)
    if not gSkillTree.PlayerCache[ply:SteamID()] then return end
    local cache = gSkillTree.PlayerCache[ply:SteamID()]

    local jsonData = util.TableToJSON(cache)
    net.Start("GakGame_SkillTreeRecieve")
    net.WriteString(jsonData)
    net.Send(ply)
end)

--For reasons of this being modular, it is vital that this is only server side, and we trust the person writing any module for this function to verify their own data integrity,
--And if they do not, than their game will be broken.
--This is also beacuse this is mainly intended for my own game mode, and i trust that the small group that may ever play this if I finish it will not abuse it,
--Because they are not smart enough to know how to abuse it.
hook.Add("GakGame_GiveSkillTreeXP", "GakGame_SkillTreeXPAdder", function(ply, amt)
    local id = ply:SteamID()

    local cache = gSkillTree.PlayerCache[id]

    cache.xp = cache.xp + amt 
end)

hook.Add("GakGame_GetMaxWeight", "GakGame_ServerMaxWeight", function(ply)
    return gSkillTree.GetPlayerWeight(ply)
end)

function gSkillTree.GetPlayerWeight(ply)
    if not IsValid(ply) then return end
    local cache = gSkillTree.PlayerCache[ply:SteamID()]
    if not cache then return end

    for _, v in ipairs(cache) do
        if v.category == "Strength" and v.ability == "Higher Carrying Capacity" then
            return (v.level or 0)
        end
    end

    return 0
end

function gSkillTree.GetXpRequired(level)
    return 1000 * level
end

function gSkillTree.GetMaxDrug(drugLevel, cookingLevel)
    local max = gSkillTree.MaxLevel
    local avg = (drugLevel + cookingLevel) / 2

    return math.min(max, math.floor(avg))
end