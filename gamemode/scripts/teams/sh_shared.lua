gTeams = gTeams or {}
gTeams.Database = "GakGame_TeamInfo"

gTeams.Ranks = {
    ["Commander"] = {
        canInvite = true,
        canManage = true,
        canBank = true,
    },
    ["Officer"] = {
        canInvite = true,
        canManage = false,
        canBank = true
    },
}

gTeams.BasicRank = {
    "Commander",
    "Officer",
    "Enlisted",
    "Recruit"
}

gTeams.Team = {}
gTeams.Team.BaseMoney = 5000
gTeams.Team.BaseEntities = 50
gTeams.Team.BaseSlots = 25
gTeams.Team.Name = ""
gTeams.Team.Leader = nil 

function gTeams.CreateTeam(name, leader)
    local team = table.Copy(gTeams.Team)

    if name and leader then
        team.Name = name
        team.Leader = leader
    end

    return team
end