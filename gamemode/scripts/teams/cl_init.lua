include("sh_shared.lua")
--[[
Info
Manage Team (Invite, See Players [Promote / Demote])
Team Info (Entity Max, Player Max, Current balance)
Money (Withdraw Money, Deposit Money)
Upgrades (More Entities, More Max Players, Interest multiplier [Base is 0.05, each upgrade is 0.05 with scaling costs]
]]
gTeams.TeamFrame = {}
gTeams.TeamPanel = {}

gTeams.Options = {
    ["Manage Team"] = gTeams.DrawManage,
    ["Team Info"] = gTeams.DrawInfo,
    ["Manage Money"] = gTeams.DrawMoney,
    ["Team Upgrades"] = gTeams.DrawUpgrade
}

function gTeams.DrawManage()
    print("manage")
end

function gTeams.DrawInfo()
print("manage1")
end

function gTeams.DrawMoney()
print("manage2")
end

function gTeams.DrawUpgrade()
print("manage3")
end

function gTeams.DrawFrame()
    gTeams.TeamFrame = vgui.Create("gakFrame")
    local w, h = ScrW() / 2, ScrH() / 2
    gTeams.TeamFrame:SetSize(w, h)
    gTeams.TeamFrame:Center()
    gTeams.TeamFrame:SetHeader("Gak Teams")

    gTeams.TeamPanel = vgui.Create("gakPanel", gTeams.TeamFrame.Content)
    gTeams.TeamPanel:SetSize(w / 7, h)

    local scroll = vgui.Create("DScrollPanel", gTeams.TeamPanel)
    scroll:SetSize(w / 7, h)
    scroll:DockMargin(5, 5, 5, 5)

    for option, func in pairs(gTeams.Options) do
        local button = vgui.Create("gakButton", scroll)
        button:SetText(option)
        button:Dock(TOP)

        button.DoClick = function()
            func()
        end

        scroll:Add(button)
    end
end

hook.Add("OnPlayerChat", "GakGame_TeamStuff", function(ply, text)
    if text != "/team" then return end

    gTeams.DrawFrame()
end)

hook.Add("HUDPaint", "GakGame_DrawTeamHud", function()

end)