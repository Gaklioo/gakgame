util.AddNetworkString("GakGame_Notify")

--Stolen log message from shared.lua in gamemode
function ToString(...)
    local msg = {...}

    for k, v in ipairs(msg) do
        msg[k] = tostring(v)
    end

    local msg = table.concat(msg, " ")
    
    return msg
end

hook.Add("GakGame_NotifyPlayer", "GakGame_ServerNotify", function(ply, ...)
    if not IsValid(ply) then return end
    if not ply:IsPlayer() then return end

    local str = ToString(...)

    net.Start("GakGame_Notify")
    net.WriteString(str)
    net.Send(ply)


end)