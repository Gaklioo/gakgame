AddCSLuaFile("cl_init.lua")
AddCSLuaFile("sh_shared.lua")
include("sh_shared.lua")

util.AddNetworkString("GakGame_CreateTeam")
net.Receive("GakGame_CreateTeam", function(len, ply)
    local teamName = net.ReadString()

    if gTeams.Teams[teamName] then gTeams.Notify(ply, "Team Already Exists") return end
    if not teamName then return end

    local newTeam = gTeams.CreateTeam(teamName, ply:SteamID())

    if newTeam then
        ply:SetgTeam(teamName)
        return 
    else
        gTeams.Notify(ply, "Failed to create new team")
    end
end)

local pendingResponse = {}

function runInvite(ply, invited)
    local co = coroutine.create(function()
        net.Start("GakGame_InviteeRequest")
        net.Send(invited)

        local response = coroutine.yield("GakGame_WaitResponse", invited)

        print(response)

        if response == "yes" then
            --Add to team
        else
            pendingResponse[invited] = nil
        end
    end)

    local ok, wait, target = coroutine.resume(co)

    if wait == "GakGame_WaitResponse" then
        pendingResponse[target] = {
            coroutine = co
        }
    end
end

concommand.Add("Sigma", function(ply)
    runInvite(ply, ply)
end)

util.AddNetworkString("GakGame_InvitePlayer")
util.AddNetworkString("GakGame_InviteeRequest")
util.AddNetworkString("GakGame_InviteeResponse")
net.Receive("GakGame_InvitePlayer", function(len, ply)
    local playerTeam = gTeams.Teams[ply:GetNW2String("TeamName")]
    local invited = net.ReadPlayer()
    if not IsValid(invited) then return end
    if not invited:IsPlayer() then return end

    if invited:GetNW2String("TeamName") != "nTeam" then return end


    if not playerTeam then return end
    local id = ply:SteamID()
    local rank = playerTeam:CheckRank(id)

    if rank == "Commander" or rank == "Officer" then
        runInvite(ply, invited)
    end
end)

net.Receive("GakGame_InviteeResponse", function(len, ply)
    local res = net.ReadString()

    local pending = pendingResponse[ply]

    print(res)

    if pending and coroutine.status(pending.coroutine) == "suspended" then
        coroutine.resume(pending.coroutine, res)
        pendingResponse[ply] = nil
    end
end)