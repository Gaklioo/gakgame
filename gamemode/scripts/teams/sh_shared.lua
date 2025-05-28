gTeams = gTeams or {}

gTeams.P = FindMetaTable("Player")

if CLIENT then return end

gTeams.Team = {}
gTeams.Team.StartingCash = 5000
gTeams.Team.MaxEntity = 50
gTeams.Team.MaxPlayers = 25
gTeams.Team.Name = ""
gTeams.Team.PlayerList = {}

gTeams.Teams = {}

function gTeams.Notify(ply, args)
    hook.Run("GakGame_NotifyPlayer", ply, args)
end

function gTeams.P:InitTeam()
    self:SetNW2String("TeamName", "nTeam")
end

function gTeams.P:SetgTeam(teamName)
    if not gTeams.Teams[teamName] then return end
    
    self:SetNW2String("TeamName", teamName)
end

function gTeams.CreateTeam(teamName, ownerID)
    if gTeams.Teams[teamName] then return end
    if string.find(teamName, "[^a-zA-Z]") then return end
    if teamName == "nTeam" then return end

    local newTeam = table.Copy(gTeams.Team)
    newTeam.PlayerList = {}

    local tbl = {rank = "Commander", id = ownerID}
    table.insert(newTeam.PlayerList, tbl)

    setmetatable(newTeam, {__index = gTeams.Team})

    gTeams.Teams[teamName] = newTeam
    newTeam.Name = teamName

    return newTeam
end

function gTeams.Team:CheckRank(id)
    for _, ply in ipairs(self.PlayerList) do
        if ply.id == id then
            return ply.rank
        end
    end
end

function gTeams.Team:AddPlayer(adderID, id)
    local canInvite = false

    for _, ply in ipairs(self.PlayerList) do
        if adderID == ply.id and (ply.rank == "Commander" or ply.rank == "Officer") then
            canInvite = true
            break
        end
        if ply.id == id then return end
    end

    if not canInvite then return end
    if #self.PlayerList >= self.MaxPlayers then return end

    local tbl = {rank = "Enlisted", id = id}

    table.insert(self.PlayerList, tbl)

    local p = player.GetBySteamID(id)

    if not IsValid(p) then return end
    if not p:IsPlayer() then return end

    p:SetgTeam(self.Name)
end

function gTeams.Team:RemovePlayer(removerID, removedID)
    local isOwner = false
    if removerID == removedID then return end

    for _, ply in ipairs(self.PlayerList) do
        if removerID == ply.id and ply.rank == "Commander" then
            isOwner = true
            break            
        end 
    end

    if not isOwner then return end

    for i, ply in ipairs(self.PlayerList) do
        if ply.id == removedID then
            table.remove(self.PlayerList, i)
        end
    end
end