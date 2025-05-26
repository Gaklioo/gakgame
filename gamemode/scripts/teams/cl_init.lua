include("sh_shared.lua")
--[[
Info
Manage Team (Invite, See Players [Promote / Demote])
Team Info (Entity Max, Player Max, Current balance)
Money (Withdraw Money, Deposit Money)
Upgrades (More Entities, More Max Players, Interest multiplier [Base is 0.05, each upgrade is 0.05 with scaling costs]
]]
gTeams.Player = FindMetaTable("Player")

function gTeams.Player:SetTeam(team)
    self.gTeam = gTeam
end

function gTeams.Player:GetTeam()
    return self.gTeam
end

gTeams.TeamFrame = {}
gTeams.TeamPanel = {}

gTeams.Options = {
    ["Manage Team"] = gTeams.DrawManage,
    ["Team Info"] = gTeams.DrawInfo,
    ["Manage Money"] = gTeams.DrawMoney,
    ["Team Upgrades"] = gTeams.DrawUpgrade
}

function gTeams.DrawNoTeam(content)
    local w, h = content:GetSize()
    local header = vgui.Create("gakPanel", content)
    header:SetTall(h / 15)
    header:Dock(TOP)
    header:DockMargin(5, 5, 5, 5)

    local createTeam = vgui.Create("gakButton", header)
    createTeam:SetText("Create Team")
    createTeam:SetSize(100, 30)
    createTeam:SizeToContents()
    createTeam:SetPos((w - createTeam:GetWide()) / 2, 0)

    header:SizeToContents()
end

function gTeams.DrawManage(content)
    local w, h = content:GetSize()

    print(LocalPlayer():GetTeam())

    if (LocalPlayer():GetTeam() == "") or (LocalPlayer():GetTeam() == nil) then
        gTeams.DrawNoTeam(content)
        return
    end

    local header = vgui.Create("gakPanel", content)
    header:SetTall(h / 20)
    header:Dock(TOP)
    header:DockMargin(5, 5, 5, 5)


    local invite = vgui.Create("gakButton", header)
    invite:SetText("Invite")
    invite:Dock(LEFT)
    invite:DockMargin(0, 0, 5, 0)


    local playerList = vgui.Create("gakButton", header)
    playerList:SetText("Team List")
    playerList:Dock(RIGHT)
end

function gTeams.DrawInfo(content)
print("manage1")
end

function gTeams.DrawMoney(content)
print("manage2")
end

function gTeams.DrawUpgrade(content)
print("manage3")
end

function gTeams.DrawFrame()
    gTeams.TeamFrame = vgui.Create("gakFrame")
    local w, h = ScrW() / 2, ScrH() / 2
    gTeams.TeamFrame:SetSize(w, h)
    gTeams.TeamFrame:Center()
    gTeams.TeamFrame:SetHeader("Gak Teams")

    local container = vgui.Create("gakPanel", gTeams.TeamFrame.Content)
    container:Dock(FILL)

    gTeams.TeamPanel = vgui.Create("gakPanel", container)
    gTeams.TeamPanel:SetWide(w / 4)
    gTeams.TeamPanel:Dock(LEFT)

    local scroll = vgui.Create("DScrollPanel", gTeams.TeamPanel)
    scroll:Dock(FILL)
    scroll:SetSize(w / 7, h)
    scroll:DockMargin(5, 5, 5, 5)

    local content = vgui.Create("gakPanel", container)
    content:Dock(FILL)

    for option, func in pairs(gTeams.Options) do
        local button = vgui.Create("gakButton", scroll)
        button:SetText(option)
        button:Dock(TOP)

        button.DoClick = function()
            func(content)
        end

        scroll:Add(button)
    end
end

net.Receive("GakGame_RecieveTeam", function()
    local gTeam = net.ReadString()

    LocalPlayer():SetTeam(gTeam)
end)

hook.Add("OnPlayerChat", "GakGame_TeamStuff", function(ply, text)
    if text != "/team" then return end

    net.Start("GakGame_GetTeam")
    net.SendToServer()

    gTeams.DrawFrame()
end)

hook.Add("HUDPaint", "GakGame_DrawTeamHud", function()

end)