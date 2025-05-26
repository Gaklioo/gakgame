AddCSLuaFile("cl_init.lua")
AddCSLuaFile("sh_shared.lua")
include("sh_shared.lua")

gTeams.TeamInfo = {}
gTeams.PlayerTeams = {}
gTeams.P = FindMetaTable("Player")

function gTeams.P:InitTeams()
    self.Rank = ""

    local foundRank = gTeams.GetRank(self:SteamID())
    local foundTeam = gTeams.FindTeam(self:SteamID())

    if foundRank then
        self.Rank = foundRank
    end

    if foundTeam then 
        self.Team = foundTeam
    end
end

function gTeams.FindTeam(id)
    local str = string.format("SELECT team FROM %s where id = '%s'", 
    gTeams.Database,
    sql.SQLStr(id, true)
    )

    local res = sql.Query(str)

    if res and res[1] then
        return res[1].team
    else
        return ""
    end
end

function gTeams.GetRank(id)
    local str = string.format("SELECT rank FROM %s where id = '%s'",
    gTeams.Database,
    sql.SQLStr(id, true)
    )

    local res = sql.Query(str)

    if res and res[1] then
        return res[1].rank
    else
        return ""
    end
end

function gTeams.SaveTeams()
    
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
    

end)

util.AddNetworkString("GakGame_InviteTeamClient")
util.AddNetworkString("GakGame_InviteTeam")
net.Receive("GakGame_InviteTeam", function(len, ply)
    local invitee = net.ReadPlayer()

    if not IsValid(ply) then return end
    if not ply.Rank then return end
    if not gTeams.CheckInvite(ply) then return end

    if not IsValid(invitee) then return end
    if not invitee.Team == "" then hook.Run("GakGame_NotifyPlayer", ply, "Cannot invite someone who is already in team") return end


    net.Start("GakGame_InviteTeamClient")
    net.WriteString(ply.Team)
    net.Send(invitee)
end)

util.AddNetworkString("GakGame_InviteResponse")
net.Receive("GakGame_InviteResponse", function(len, ply)
    local response = net.ReadBool()

    if response then
        
    end
end)