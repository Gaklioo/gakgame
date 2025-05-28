include("sh_shared.lua")

net.Receive("GakGame_InviteeRequest", function()
    Derma_Query("Do you want to join the team?", "Team Invite",
        "Accept", function()
            net.Start("GakGame_InviteeResponse")
            net.WriteString("yes")
            net.SendToServer()
        end,
        "Decline", function()
            net.Start("GakGame_InviteeResponse")
            net.WriteString("decline")
            net.SendToServer()
        end
    )
end)