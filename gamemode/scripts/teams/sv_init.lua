AddCSLuaFile("cl_init.lua")
AddCSLuaFile("sh_shared.lua")
include("sh_shared.lua")

gTeams.TeamInfo = {}
gTeams.PlayerTeams = {}
gTeams.P = FindMetaTable("Player")

hook.Add("GakGame_InitializeSQL", "GakGame_SetupTeamDatabase", function()
    gTeams.CreateDatabase()

    gTeams.LoadTeamInfo()
end)

function gTeams.P:InitTeams()
    self.Rank = ""
    self.Team = ""

    local id = self:SteamID()

    self.Team, self.Rank = gTeams.GetPlayersTeam(id)
end

function gTeams.CreateDatabase()
    local str = string.format("CREATE TABLE %s (teamName varchar(255) PRIMARY KEY, information TEXT)",
    gTeams.Database
    )

    if not sql.TableExists(gTeams.Database) then
        sql.Begin()
        sql.Query(str)
        sql.Commit()
    end
end

function gTeams.LoadTeamInfo()
    local str = string.format("SELECT * FROM %s",
    gTeams.Database    
    )

    local qry = sql.Query(str)

    if qry == true then
        for k, v in pairs(qry) do
            local teamName = v.teamName
            local teamInfo = util.JSONToTable(v.information)

            local tbl = {[teamName] = teamInfo}

            gTeams.TeamInfo[teamName] = teamInfo 
        end
    else
        print(sql.LastError())
    end
end

function gTeams.SaveTeams()
    for teamName, teamData in pairs(gTeams.TeamInfo) do
        local save = util.TableToJSON(teamData)

        local str = string.format("REPLACE INTO %s VALUES('%s', '%s');",
        gTeams.Database,
        sql.SQLStr(teamName, true),
        sql.SQLStr(save, true)
        )

        sql.Query(str)
    end
end

function gTeams.P:ChangeRank(rank)
    if not gTeams.BasicRank[rank] then return end
    self.Rank = rank
end

function gTeams.P:GetRank()
    return self.Rank
end

function gTeams.CheckInvite(ply)
    local rank = ply.Rank
    local rankInfo = gTeams.Ranks[rank]

    return rankInfo and rankInfo.canInvite == true
end

function gTeams.CheckTeam(ply)
    if not IsValid(ply) then return end

    return ply.Team
end

function gTeams.GetPlayersTeam(id)
    for team, teamData in pairs(gTeams.TeamInfo) do
        for _, playerID in pairs(teamData.PlayerList) do
            if playerID.steamID == id then
                return team, playerID.rank
            end
        end
    end

    return "", ""
end

hook.Add("GakGame_GetTeam", "GakGame_GetTeamServer", function(ply)
    return ply:GetRank()    
end)

util.AddNetworkString("GakGame_CreateTeam")
net.Receive("GakGame_CreateTeam", function(len, ply)
    local rank = ply:GetRank()
    if rank then return end
    if gTeams.Ranks[rank] then return end
    if not IsValid(ply) then return end

    local teamName = net.ReadString()
    local newTeam = gTeams.CreateTeam(teamName, ply)

    gTeams.TeamInfo[teamName] = newTeam
end)

gTeams.Invitee = {}

util.AddNetworkString("GakGame_InviteTeamClient")
util.AddNetworkString("GakGame_InviteTeam")
net.Receive("GakGame_InviteTeam", function(len, ply)
    local invitee = net.ReadPlayer()

    if not IsValid(ply) then return end
    if not ply.Rank then return end
    if not gTeams.CheckInvite(ply) then return end

    if not IsValid(invitee) then return end
    if invitee.Team == "" then hook.Run("GakGame_NotifyPlayer", ply, "Cannot invite someone who is already in team") return end


    net.Start("GakGame_InviteTeamClient")
    net.WriteString(ply.Team)
    net.Send(invitee)

    gTeams.Invitee[invitee] = ply.Team
end)

function gTeams.AddToTeam(team, ply)
    local newAdd = {steamID = ply:SteamID(), rank = "Recruit"}
    table.insert(team.PlayerList, newAdd)
end

util.AddNetworkString("GakGame_InviteResponse")
net.Receive("GakGame_InviteResponse", function(len, ply)
    local response = net.ReadBool()
    if not IsValid(response) then return end
    if not IsValid(ply) then return end

    if not gTeams.Invitee[ply] then return end

    if response then
        local team = gTeams.Invitee[ply]

        gTeams.AddToTeam(team, ply)
        ply.Team = team

        gTeams.Invitee[ply] = nil
    end
end)